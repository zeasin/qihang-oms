package cn.qihangerp.service.impl;

import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.enums.EnumAuditStatus;
import cn.qihangerp.enums.EnumAuditType;
import cn.qihangerp.enums.EnumEnableStatus;
import cn.qihangerp.enums.EnumOOrderStatus;
import cn.qihangerp.enums.EnumOrderRole;
import cn.qihangerp.enums.EnumShipStatus;
import cn.qihangerp.enums.EnumShipType;
import cn.qihangerp.enums.EnumWaybillStatus;
import cn.qihangerp.enums.HttpStatus;
import cn.qihangerp.mapper.ErpSupplierMapper;
import cn.qihangerp.mapper.ErpWarehouseMapper;
import cn.qihangerp.mapper.OOrderItemMapper;
import cn.qihangerp.mapper.OOrderMapper;
import cn.qihangerp.mapper.OOrderStockingMapper;
import cn.qihangerp.mapper.OOrderTagMapper;
import cn.qihangerp.mapper.ShopWaybillAccountMapper;
import cn.qihangerp.model.bo.OrderAddressBo;
import cn.qihangerp.model.bo.OrderCancelBo;
import cn.qihangerp.model.bo.OrderExceptionBo;
import cn.qihangerp.model.bo.OrderMemoBo;
import cn.qihangerp.model.bo.OrderReleaseBo;
import cn.qihangerp.model.bo.OrderWithdrawBo;
import cn.qihangerp.model.entity.ErpSupplier;
import cn.qihangerp.model.entity.ErpWarehouse;
import cn.qihangerp.model.entity.OOrder;
import cn.qihangerp.model.entity.OOrderItem;
import cn.qihangerp.model.entity.OOrderStocking;
import cn.qihangerp.model.entity.OOrderTag;
import cn.qihangerp.model.entity.ShopWaybillAccount;
import cn.qihangerp.model.request.OrderWorkbenchQuery;
import cn.qihangerp.model.vo.ExceptionTagCountVo;
import cn.qihangerp.model.vo.OrderPoolCountsVo;
import cn.qihangerp.model.vo.OrderPoolItemVo;
import cn.qihangerp.model.vo.OrderPoolOrderVo;
import cn.qihangerp.model.vo.OrderReleaseResultVo;
import cn.qihangerp.service.OrderWorkbenchOrderService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 订单处理工作台-订单域服务实现
 * 参照 qihang-erp-pro OrderWorkbenchOrderServiceImpl，池口径与 erp-pro 完全一致：
 * 待审核=audit_status 0 AND order_status 1 AND ship_status 0；
 * 异常池=audit_status 2；
 * 待发货=audit_status 1 AND order_status 1 AND ship_status 0；
 * 已发货=audit_status 1 AND ship_status>0；
 * 已完成=order_status 3（2026-10-22 新增，交易完成态，由平台状态同步推进，与发货动作解耦）；
 * 已拆单=audit_status 3（主订单拆单后终态，不进入任何状态池）；
 * 全池排除已取消(order_status 11)/已删除(order_status 29)；
 * "all"=全部tab（2026-10-22 新增）：不设池条件、不排除任何状态（口径=旧订单库全量列表），
 * 可按 orderStatus/auditStatus 可选筛选（2026-10-22 由"默认排除取消/删除"改为"全量"）。
 * 主单/子单均按自身字段命中，无 order_role 过滤，四池统一平铺展示；
 * 主单行带 splitFlag（已拆分）与 canRelease（未拆分=数量完整，已拆分=全部子单就绪）计算，子单行只读展示。
 * 与 erp-pro 差异：OMS o_order 无 latest_delivery_time / shipping_time / member_id 列（相应筛选/排序不做）；
 * o_order_item 无 source_order_id 列，合并发货子单关联链路留待打单发货阶段，此处子单集合=拆分子单。
 *
 * @author qihang
 * @date 2026-10-21
 */
@Slf4j
@Service
@AllArgsConstructor
public class OrderWorkbenchOrderServiceImpl implements OrderWorkbenchOrderService {

    /** 订单号多号输入上限，避免超大 IN 查询 */
    private static final int ORDER_NUM_LIMIT = 50;
    /** 商品关键词命中订单数上限，保护 IN 查询规模 */
    private static final int KEYWORD_ORDER_LIMIT = 2000;
    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private final OOrderMapper orderMapper;
    private final OOrderItemMapper orderItemMapper;
    private final OOrderStockingMapper orderStockingMapper;
    private final OOrderTagMapper tagMapper;
    private final ShopWaybillAccountMapper shopWaybillAccountMapper;
    private final ErpSupplierMapper erpSupplierMapper;
    private final ErpWarehouseMapper erpWarehouseMapper;
    private final PlatformTransactionManager transactionManager;

    // ==================== 状态池查询 ====================

    @Override
    public PageResult<OrderPoolOrderVo> poolPage(OrderWorkbenchQuery query, PageQuery pageQuery) {
        String pool = resolvePool(query);
        LambdaQueryWrapper<OOrder> wrapper = buildPoolWrapper(query, pool);
        // 排序必须带唯一列兜底：order_time 大量重复（平台拉单同秒落库），无唯一列时 LIMIT 翻页不稳定会丢行/重行
        applyPoolSort(query, wrapper);
        Page<OOrder> page = orderMapper.selectPage(pageQuery.build(), wrapper);

        List<OrderPoolOrderVo> rows = buildFlatRows(page.getRecords());
        PageResult<OrderPoolOrderVo> result = new PageResult<>();
        result.setCode(HttpStatus.SUCCESS);
        result.setMsg("查询成功");
        result.setTotal(page.getTotal());
        result.setRecords(rows);
        return result;
    }

    @Override
    public OrderPoolCountsVo poolCounts(OrderWorkbenchQuery query) {
        OrderPoolCountsVo vo = new OrderPoolCountsVo();
        vo.setAll(orderMapper.selectCount(buildPoolWrapper(query, "all")));
        vo.setPending(orderMapper.selectCount(buildPoolWrapper(query, "pending")));
        vo.setException(orderMapper.selectCount(buildPoolWrapper(query, "exception")));
        vo.setReleased(orderMapper.selectCount(buildPoolWrapper(query, "released")));
        vo.setShipped(orderMapper.selectCount(buildPoolWrapper(query, "shipped")));
        vo.setCompleted(orderMapper.selectCount(buildPoolWrapper(query, "completed")));
        return vo;
    }

    /**
     * 解析状态池参数（pool 优先，未传时默认 pending）
     */
    private String resolvePool(OrderWorkbenchQuery query) {
        if (StringUtils.hasText(query.getPool())) {
            String pool = query.getPool().trim().toLowerCase();
            if (Arrays.asList("all", "pending", "exception", "released", "shipped", "completed").contains(pool)) {
                return pool;
            }
        }
        return "pending";
    }

    /**
     * 构建状态池查询条件：公共过滤 + 池条件（池口径见类注释）
     */
    private LambdaQueryWrapper<OOrder> buildPoolWrapper(OrderWorkbenchQuery query, String pool) {
        LambdaQueryWrapper<OOrder> wrapper = new LambdaQueryWrapper<>();
        // "all"（全部tab）的排除/状态条件在池分支里按筛选参数动态处理；其余四池恒定排除已取消(11)/已删除(29)
        if (!"all".equals(pool)) {
            wrapper.notIn(OOrder::getOrderStatus, EnumOOrderStatus.CANCEL.getIndex(),
                    EnumOOrderStatus.DELETED.getIndex());
        }
        wrapper
                .eq(query.getShopId() != null, OOrder::getShopId, query.getShopId())
                .eq(query.getShopType() != null, OOrder::getShopType, query.getShopType())
                .eq(query.getMerchantId() != null, OOrder::getMerchantId, query.getMerchantId())
                .like(StringUtils.hasText(query.getReceiverName()), OOrder::getReceiverName, query.getReceiverName())
                .like(StringUtils.hasText(query.getReceiverMobile()), OOrder::getReceiverMobile, query.getReceiverMobile())
                // 省市区用 like：级联选择传全称（如"广东省"），存量拉单数据可能存简称
                .like(StringUtils.hasText(query.getProvince()), OOrder::getProvince, query.getProvince())
                .like(StringUtils.hasText(query.getCity()), OOrder::getCity, query.getCity())
                .like(StringUtils.hasText(query.getDistrict()), OOrder::getTown, query.getDistrict())
                .eq(query.getOrderMode() != null, OOrder::getOrderMode, query.getOrderMode())
                .like(StringUtils.hasText(query.getBuyerMemo()), OOrder::getBuyerMemo, query.getBuyerMemo())
                .like(StringUtils.hasText(query.getSellerMemo()), OOrder::getSellerMemo, query.getSellerMemo())
                .ge(query.getAmountMin() != null, OOrder::getPayment, query.getAmountMin())
                .le(query.getAmountMax() != null, OOrder::getPayment, query.getAmountMax())
                .ge(parseTime(query.getOrderTimeBegin(), true) != null, OOrder::getOrderTime, parseTime(query.getOrderTimeBegin(), true))
                .le(parseTime(query.getOrderTimeEnd(), false) != null, OOrder::getOrderTime, parseTime(query.getOrderTimeEnd(), false));

        // 是否含买家留言
        if (Boolean.TRUE.equals(query.getHasBuyerMemo())) {
            wrapper.isNotNull(OOrder::getBuyerMemo).ne(OOrder::getBuyerMemo, "");
        }
        // 发货主体筛选：匹配订单明细 ship_type/shipper_id（与商品关键词同模式，先查明细订单ID集合）
        if (query.getShipperType() != null || query.getShipperId() != null) {
            List<OOrderItem> shipItems = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                    .select(OOrderItem::getOrderId)
                    .eq(query.getShipperType() != null, OOrderItem::getShipType, query.getShipperType())
                    .eq(query.getShipperId() != null, OOrderItem::getShipperId, query.getShipperId())
                    .last("LIMIT " + KEYWORD_ORDER_LIMIT));
            if (shipItems.isEmpty()) {
                wrapper.apply("1 = 0");
            } else {
                List<Long> shipOrderIds = shipItems.stream().map(OOrderItem::getOrderId).filter(Objects::nonNull)
                        .map(Long::parseLong).distinct().collect(Collectors.toList());
                wrapper.in(OOrder::getId, shipOrderIds);
            }
        }
        // 待发货池发货方固定分类：按明细 ship_type 归并（self=店铺自用0 / supplier=供应商300 / cloud=云仓100,110,200）
        if ("released".equals(pool) && StringUtils.hasText(query.getShipperCategory())) {
            switch (query.getShipperCategory().trim().toLowerCase()) {
                case "self" -> wrapper.exists(true,
                        "SELECT 1 FROM o_order_item i WHERE i.order_id = o_order.id AND i.ship_type = {0}",
                        EnumShipType.LOCAL.getIndex());
                case "supplier" -> wrapper.exists(true,
                        "SELECT 1 FROM o_order_item i WHERE i.order_id = o_order.id AND i.ship_type = {0}",
                        EnumShipType.SUPPLIER.getIndex());
                case "cloud" -> wrapper.exists(true,
                        "SELECT 1 FROM o_order_item i WHERE i.order_id = o_order.id AND i.ship_type IN ({0},{1},{2})",
                        EnumShipType.JD_CLOUD_WAREHOUSE.getIndex(),
                        EnumShipType.JKY_CLOUD_WAREHOUSE.getIndex(),
                        EnumShipType.CLOUD_WAREHOUSE.getIndex());
                default -> { }
            }
        }

        // 店铺多选
        List<Long> shopIds = parseLongList(query.getShopIds());
        wrapper.in(!shopIds.isEmpty(), OOrder::getShopId, shopIds);
        // 多订单号
        List<String> orderNums = parseOrderNums(query.getOrderNums());
        wrapper.in(!orderNums.isEmpty(), OOrder::getOrderNum, orderNums);
        // 标签多选（o_order.tag 为逗号分隔ID串，命中任一标签即返回）
        List<Long> tagIds = parseLongList(query.getTagIds());
        if (!tagIds.isEmpty()) {
            wrapper.and(w -> {
                for (Long tagId : tagIds) {
                    w.or().apply("FIND_IN_SET({0}, tag)", tagId);
                }
            });
        }
        // 商品关键词：先查命中商品行的订单ID集合
        if (StringUtils.hasText(query.getGoodsKeyword())) {
            String keyword = query.getGoodsKeyword().trim();
            List<OOrderItem> hitItems = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                    .select(OOrderItem::getOrderId)
                    .and(w -> w.like(OOrderItem::getGoodsTitle, keyword)
                            .or().like(OOrderItem::getSkuNum, keyword)
                            .or().like(OOrderItem::getBarcode, keyword))
                    .last("LIMIT " + KEYWORD_ORDER_LIMIT));
            if (hitItems.isEmpty()) {
                // 关键词无命中：强制空结果
                wrapper.apply("1 = 0");
            } else {
                List<Long> orderIds = hitItems.stream().map(OOrderItem::getOrderId).filter(Objects::nonNull)
                        .map(Long::parseLong).distinct().collect(Collectors.toList());
                wrapper.in(OOrder::getId, orderIds);
            }
        }

        // 池条件（主单/子单均按自身字段命中，无 order_role 过滤）
        switch (pool) {
            case "all":
                // 全部tab：不设池条件、不排除任何状态（口径=旧订单库全量），订单状态/审核状态仅作可选筛选
                wrapper.eq(query.getOrderStatus() != null, OOrder::getOrderStatus, query.getOrderStatus())
                        .eq(query.getAuditStatus() != null, OOrder::getAuditStatus, query.getAuditStatus());
                break;
            case "pending":
                // 待审核=audit_status 0 AND order_status 1 AND ship_status 0
                wrapper.eq(OOrder::getAuditStatus, EnumAuditStatus.PENDING.getIndex())
                        .eq(OOrder::getOrderStatus, EnumOOrderStatus.WAIT_SHIP.getIndex())
                        .eq(OOrder::getShipStatus, EnumShipStatus.NOT.getIndex());
                break;
            case "exception":
                // 异常池=audit_status 2
                wrapper.eq(OOrder::getAuditStatus, EnumAuditStatus.EXCEPTION.getIndex());
                break;
            case "released":
                // 待发货=audit_status 1 AND order_status 1 AND ship_status 0
                wrapper.eq(OOrder::getAuditStatus, EnumAuditStatus.APPROVED.getIndex())
                        .eq(OOrder::getOrderStatus, EnumOOrderStatus.WAIT_SHIP.getIndex())
                        .eq(OOrder::getShipStatus, EnumShipStatus.NOT.getIndex());
                break;
            case "shipped":
                // 已发货=audit_status 1 AND ship_status>0
                wrapper.eq(OOrder::getAuditStatus, EnumAuditStatus.APPROVED.getIndex())
                        .gt(OOrder::getShipStatus, EnumShipStatus.NOT.getIndex());
                break;
            case "completed":
                // 已完成=order_status 3（交易完成，与发货动作解耦，由平台状态同步推进）
                wrapper.eq(OOrder::getOrderStatus, EnumOOrderStatus.COMPLETE.getIndex());
                break;
            default:
                // 兜底走已发货口径（resolvePool 已保证白名单）
                wrapper.eq(OOrder::getAuditStatus, EnumAuditStatus.APPROVED.getIndex())
                        .gt(OOrder::getShipStatus, EnumShipStatus.NOT.getIndex());
                break;
        }
        return wrapper;
    }

    /**
     * 池列表排序：sortField 白名单（payment/orderTime/goodsSummary/skuNumText/goodsNumText），
     * 非法或缺省=下单时间倒序；商品三列取订单首条明细（o_order_item 最小 id）经关联子查询排序；
     * 末位固定 id 倒序兜底，保证同值翻页稳定。
     * 白名单只选固定 SQL 片段，用户输入不拼入 SQL；MP 分页 count 优化会自动去除 ORDER BY。
     */
    private void applyPoolSort(OrderWorkbenchQuery query, LambdaQueryWrapper<OOrder> wrapper) {
        boolean asc = "ascending".equals(query.getSortOrder());
        String dir = asc ? "ASC" : "DESC";
        String field = query.getSortField() == null ? "" : query.getSortField();
        String orderSql = switch (field) {
            case "payment" -> "o_order.payment " + dir;
            case "orderTime" -> "o_order.order_time " + dir;
            case "goodsSummary" -> "(SELECT i.goods_title FROM o_order_item i WHERE i.order_id = o_order.id ORDER BY i.id LIMIT 1) " + dir;
            case "skuNumText" -> "(SELECT i.sku_num FROM o_order_item i WHERE i.order_id = o_order.id ORDER BY i.id LIMIT 1) " + dir;
            case "goodsNumText" -> "(SELECT i.goods_num FROM o_order_item i WHERE i.order_id = o_order.id ORDER BY i.id LIMIT 1) " + dir;
            default -> "o_order.order_time DESC";
        };
        wrapper.last("ORDER BY " + orderSql + ", o_order.id DESC");
    }

    /**
     * 池列表行组装：四池统一平铺（主单行与子单行作为独立行展示）。
     * 主单行商品摘要取原始明细（item_role=0），子单行取履约明细（item_role=1）；
     * 主单行计算 splitFlag（有有效拆分子单=已拆分）与 canRelease（未拆分=数量完整，已拆分=全部子单就绪）；
     * 子单行计算自身 canRelease（明细完整），放行按子单独立执行。
     */
    private List<OrderPoolOrderVo> buildFlatRows(List<OOrder> units) {
        if (units.isEmpty()) {
            return new ArrayList<>();
        }
        List<String> unitIds = units.stream().map(OOrder::getId).collect(Collectors.toList());
        Map<String, List<OOrderItem>> itemMap = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                        .in(OOrderItem::getOrderId, unitIds))
                .stream().collect(Collectors.groupingBy(OOrderItem::getOrderId));

        // 主单的拆分子单（splitFlag 与 canRelease 计算用，不作为行返回）
        List<Long> masterIds = units.stream()
                .filter(u -> u.getOrderRole() != null && u.getOrderRole() == EnumOrderRole.MASTER.getIndex())
                .map(u -> Long.parseLong(u.getId())).collect(Collectors.toList());
        // OMS 暂无补发子单链路（order_mode 仅 0店铺/1手工），全部有效子单参与「已拆分」标识与主单汇总就绪计算；
        // 合并发货子单（MERGE_CHILD）关联链路在打单发货阶段实现后接入
        Map<Long, List<OOrder>> childMap = masterIds.isEmpty() ? Map.of()
                : orderMapper.selectList(new LambdaQueryWrapper<OOrder>()
                        .in(OOrder::getParentOrderId, masterIds)
                        .notIn(OOrder::getOrderStatus, EnumOOrderStatus.CANCEL.getIndex(),
                                EnumOOrderStatus.DELETED.getIndex()))
                .stream().collect(Collectors.groupingBy(OOrder::getParentOrderId));
        Set<String> childIds = new LinkedHashSet<>();
        childMap.values().forEach(list -> list.forEach(c -> childIds.add(c.getId())));
        Map<String, List<OOrderItem>> childItemMap = childIds.isEmpty() ? Map.of()
                : orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                        .in(OOrderItem::getOrderId, childIds)
                        .eq(OOrderItem::getItemRole, EnumOrderRole.CHILD.getIndex()))
                .stream().collect(Collectors.groupingBy(OOrderItem::getOrderId));

        List<OrderPoolOrderVo> rows = new ArrayList<>();
        for (OOrder unit : units) {
            OrderPoolOrderVo vo = toVo(unit);
            boolean master = unit.getOrderRole() != null
                    && unit.getOrderRole() == EnumOrderRole.MASTER.getIndex();
            int itemRole = master ? EnumOrderRole.MASTER.getIndex() : EnumOrderRole.CHILD.getIndex();
            List<OOrderItem> items = itemMap.getOrDefault(unit.getId(), List.of()).stream()
                    .filter(i -> i.getItemRole() != null && i.getItemRole() == itemRole)
                    .collect(Collectors.toList());
            vo.setGoodsSummary(buildGoodsSummary(items));
            vo.setSkuNumText(items.stream().map(OOrderItem::getSkuNum).filter(s -> s != null && !s.isEmpty())
                    .distinct().collect(Collectors.joining(",")));
            vo.setGoodsNumText(items.stream().map(OOrderItem::getGoodsNum).filter(s -> s != null && !s.isEmpty())
                    .distinct().collect(Collectors.joining(",")));
            vo.setItemCount(items.size());
            vo.setTotalQuantity(items.stream().map(OOrderItem::getQuantity)
                    .filter(Objects::nonNull).mapToInt(Integer::intValue).sum());
            vo.setFirstImage(items.stream().map(OOrderItem::getGoodsImg)
                    .filter(s -> s != null && !s.isEmpty()).findFirst().orElse(null));
            vo.setItems(items.stream().map(i -> {
                OrderPoolItemVo iv = new OrderPoolItemVo();
                iv.setGoodsImg(i.getGoodsImg());
                iv.setGoodsTitle(i.getGoodsTitle());
                iv.setGoodsSpec(i.getGoodsSpec());
                iv.setSkuNum(i.getSkuNum());
                iv.setGoodsNum(i.getGoodsNum());
                iv.setQuantity(i.getQuantity());
                return iv;
            }).collect(Collectors.toList()));
            if (master) {
                List<OOrder> children = childMap.getOrDefault(Long.parseLong(unit.getId()), List.of());
                vo.setSplitFlag(!children.isEmpty());
                List<OrderPoolOrderVo> childVos = new ArrayList<>();
                for (OOrder child : children) {
                    OrderPoolOrderVo cv = new OrderPoolOrderVo();
                    cv.setOrderNum(child.getOrderNum());
                    String msg = checkChildStructure(child, childItemMap.getOrDefault(child.getId(), List.of()));
                    cv.setCanRelease(msg == null);
                    cv.setCanReleaseMsg(msg);
                    childVos.add(cv);
                }
                vo.setChildren(childVos);
                String masterMsg = checkMasterStructure(unit, items, childVos);
                vo.setCanRelease(masterMsg == null);
                vo.setCanReleaseMsg(masterMsg);
                if (children.isEmpty()) {
                    vo.setAllocated(unit.getWaybillAccountId() != null);
                } else {
                    vo.setAllocated(children.stream().allMatch(c -> c.getWaybillAccountId() != null));
                    Set<Long> childAccounts = children.stream().map(OOrder::getWaybillAccountId)
                            .filter(Objects::nonNull).collect(Collectors.toSet());
                    if (childAccounts.size() == 1) {
                        vo.setWaybillAccountId(childAccounts.iterator().next());
                    }
                }
            } else {
                String msg = checkChildStructure(unit, items);
                vo.setCanRelease(msg == null);
                vo.setCanReleaseMsg(msg);
                vo.setAllocated(unit.getWaybillAccountId() != null);
            }
            rows.add(vo);
        }
        return rows;
    }

    /**
     * 主订单结构就绪校验（列表展示用）：未拆分=数量完整；已拆分=全部子单结构就绪
     * @return null=结构就绪，否则为原因
     */
    private String checkMasterStructure(OOrder master, List<OOrderItem> masterItems, List<OrderPoolOrderVo> children) {
        if (children == null || children.isEmpty()) {
            boolean anyShippable = masterItems.stream()
                    .anyMatch(i -> nz(i.getQuantity()) - nz(i.getRefundCount()) > 0);
            return anyShippable ? null : "商品可发货数量为0（已全部退款）";
        }
        for (OrderPoolOrderVo child : children) {
            if (!Boolean.TRUE.equals(child.getCanRelease())) {
                return "子单[" + child.getOrderNum() + "]未就绪：" + child.getCanReleaseMsg();
            }
        }
        return null;
    }

    /**
     * 主订单放行校验（放行时用）：结构就绪 + 各发货单元已分配面单账号
     * @return null=可放行，否则为不可放行原因
     */
    private String checkMasterRelease(OOrder master, List<OOrderItem> masterItems, List<OrderPoolOrderVo> children) {
        String structureMsg = checkMasterStructure(master, masterItems, children);
        if (structureMsg != null) {
            return structureMsg;
        }
        if (children == null || children.isEmpty()) {
            return master.getWaybillAccountId() == null ? "未分配面单账号" : null;
        }
        for (OrderPoolOrderVo child : children) {
            if (!Boolean.TRUE.equals(child.getCanRelease())) {
                return "子单[" + child.getOrderNum() + "]未就绪：" + child.getCanReleaseMsg();
            }
        }
        return null;
    }

    /**
     * 子订单结构就绪校验（列表展示用）：有商品明细
     * @return null=结构就绪，否则为原因
     */
    private String checkChildStructure(OOrder child, List<OOrderItem> items) {
        if (items.isEmpty()) {
            return "子订单无商品明细";
        }
        return null;
    }

    /**
     * 子订单放行校验（放行时用）：结构就绪 + 已分配面单账号
     * @return null=可放行，否则为不可放行原因
     */
    private String checkChildRelease(OOrder child, List<OOrderItem> items) {
        String structureMsg = checkChildStructure(child, items);
        if (structureMsg != null) {
            return structureMsg;
        }
        return child.getWaybillAccountId() == null ? "未分配面单账号" : null;
    }

    // ==================== 批量转异常/转正常 ====================

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ResultVo<String> toException(OrderExceptionBo bo, List<Long> merchantIds, String username) {
        if (bo.getTarget() == null
                || (bo.getTarget() != EnumAuditStatus.PENDING.getIndex()
                && bo.getTarget() != EnumAuditStatus.EXCEPTION.getIndex())) {
            return ResultVo.error("目标状态不正确：0=转正常，2=转异常");
        }
        if (bo.getOrderIds() == null || bo.getOrderIds().isEmpty()) {
            return ResultVo.error("请先勾选订单");
        }
        // 转异常必选异常池分类标签（必选单选，覆盖式写入订单 tag 保证一单只归属一个分类）
        OOrderTag categoryTag = null;
        Set<String> poolTagIdSet = new HashSet<>();
        if (bo.getTarget() == EnumAuditStatus.EXCEPTION.getIndex()) {
            if (bo.getTagId() == null) {
                return ResultVo.error("请选择异常分类标签");
            }
            categoryTag = tagMapper.selectById(bo.getTagId());
            if (categoryTag == null) {
                return ResultVo.error("异常分类标签不存在");
            }
            if (categoryTag.getStatus() == null || categoryTag.getStatus() != EnumEnableStatus.ENABLED.getIndex()) {
                return ResultVo.error("异常分类标签已停用：" + categoryTag.getName());
            }
            if (categoryTag.getBindPool() == null || categoryTag.getBindPool() != EnumAuditStatus.EXCEPTION.getIndex()) {
                return ResultVo.error("所选标签不是异常池分类标签：" + categoryTag.getName());
            }
            // 全部异常池分类标签ID：覆盖写时从订单 tag 串移除旧分类，普通标签（bind_pool=0）保留
            poolTagIdSet = tagMapper.selectList(new LambdaQueryWrapper<OOrderTag>()
                            .eq(OOrderTag::getBindPool, EnumAuditStatus.EXCEPTION.getIndex()))
                    .stream().map(t -> String.valueOf(t.getId())).collect(Collectors.toSet());
        }
        List<OOrder> orders = orderMapper.selectBatchIds(bo.getOrderIds());
        if (orders.size() != new LinkedHashSet<>(bo.getOrderIds()).size()) {
            return ResultVo.error("存在无效订单ID，请刷新列表后重试");
        }
        int skipped = 0;
        List<Long> allowedIds = new ArrayList<>();
        for (OOrder order : orders) {
            if (!hasScope(merchantIds, order.getMerchantId())) {
                skipped++;
                continue;
            }
            // 未放行（0/2）才可 0↔2 流转，已放行(1)不可转
            if (order.getAuditStatus() == null
                    || (order.getAuditStatus() != EnumAuditStatus.PENDING.getIndex()
                    && order.getAuditStatus() != EnumAuditStatus.EXCEPTION.getIndex())) {
                skipped++;
                continue;
            }
            allowedIds.add(Long.parseLong(order.getId()));
        }
        if (allowedIds.isEmpty()) {
            return ResultVo.error("所选订单均不满足转" + (bo.getTarget() == EnumAuditStatus.EXCEPTION.getIndex() ? "异常" : "正常") + "条件");
        }
        Integer updated = orderMapper.update(null, new LambdaUpdateWrapper<OOrder>()
                .in(OOrder::getId, allowedIds)
                .in(OOrder::getAuditStatus, EnumAuditStatus.PENDING.getIndex(), EnumAuditStatus.EXCEPTION.getIndex())
                .set(OOrder::getAuditStatus, bo.getTarget())
                .set(OOrder::getUpdateTime, new Date())
                .set(OOrder::getUpdateBy, username));
        // 转异常覆盖写分类标签：移除订单 tag 串中全部旧分类ID（bind_pool=2）→ 追加新分类ID → 去重回写
        // 转正常不动标签（分类标签由操作员按需撤标）
        if (bo.getTarget() == EnumAuditStatus.EXCEPTION.getIndex()) {
            Date now = new Date();
            Map<Long, OOrder> orderMap = orders.stream()
                    .collect(Collectors.toMap(o -> Long.parseLong(o.getId()), Function.identity(), (a, b) -> a));
            for (Long id : allowedIds) {
                OOrder order = orderMap.get(id);
                if (order == null) continue;
                overwriteExceptionTag(order.getId(), order.getTag(), bo.getTagId(), poolTagIdSet, now);
            }
        }
        log.info("======订单批量{}======操作人={}，选中={}单，更新={}单，跳过={}单，分类标签={}",
                bo.getTarget() == EnumAuditStatus.EXCEPTION.getIndex() ? "转异常" : "转正常",
                username, orders.size(), updated, skipped, bo.getTagId());
        String action = bo.getTarget() == EnumAuditStatus.EXCEPTION.getIndex() ? "转异常" : "转正常";
        if (skipped > 0) {
            return ResultVo.success(String.format("%s成功 %d 单，%d 单状态不符已跳过", action, updated, skipped));
        }
        return ResultVo.success(String.format("%s成功 %d 单", action, updated));
    }

    /**
     * 覆盖写异常池分类标签：移除订单 tag 串中全部旧分类ID（bind_pool=2）→ 追加新分类ID → 去重回写；
     * 普通标签（bind_pool=0）不受影响，结果与原串一致则不更新。转异常/撤回共用（口径同打单发货页退回）
     */
    private void overwriteExceptionTag(String orderId, String currentTag, Long reasonTagId,
                                       Set<String> poolTagIdSet, Date now) {
        LinkedHashSet<String> tagIds = parseTagIds(currentTag);
        tagIds.removeAll(poolTagIdSet);
        tagIds.add(String.valueOf(reasonTagId));
        String joined = String.join(",", tagIds);
        if (joined.equals(currentTag == null ? "" : currentTag)) {
            return;
        }
        orderMapper.update(null, new LambdaUpdateWrapper<OOrder>()
                .eq(OOrder::getId, orderId)
                .set(OOrder::getTag, joined)
                .set(OOrder::getUpdateTime, now));
    }

    /** 解析订单标签串（逗号分隔ID）为保序去重集合，过滤非法片段（与 OrderWorkbenchTagServiceImpl 同规则） */
    private LinkedHashSet<String> parseTagIds(String tag) {
        LinkedHashSet<String> result = new LinkedHashSet<>();
        if (!StringUtils.hasText(tag)) return result;
        for (String s : tag.split(",")) {
            String t = s.trim();
            if (t.matches("\\d+")) result.add(t);
        }
        return result;
    }

    // ==================== 异常池分类计数 ====================

    @Override
    public ExceptionTagCountVo exceptionTagCounts(OrderWorkbenchQuery query) {
        ExceptionTagCountVo vo = new ExceptionTagCountVo();
        // 异常池范围内订单（仅取 tag 列），内存聚合分类计数（异常池量级可控）
        LambdaQueryWrapper<OOrder> wrapper = buildPoolWrapper(query, "exception")
                .select(OOrder::getId, OOrder::getTag);
        List<OOrder> orders = orderMapper.selectList(wrapper);
        // 异常池分类字典：bind_pool=2，全系统共用（不限商户），含停用（已打订单保留计数）
        List<OOrderTag> poolTags = tagMapper.selectList(new LambdaQueryWrapper<OOrderTag>()
                .eq(OOrderTag::getBindPool, EnumAuditStatus.EXCEPTION.getIndex())
                .orderByAsc(OOrderTag::getSort)
                .orderByAsc(OOrderTag::getId));
        Map<Long, OOrderTag> tagMap = poolTags.stream()
                .collect(Collectors.toMap(OOrderTag::getId, Function.identity(), (a, b) -> a));
        Map<Long, Long> counts = new LinkedHashMap<>();
        long uncategorized = 0;
        for (OOrder order : orders) {
            List<Long> hitIds = parseTagIds(order.getTag()).stream()
                    .map(Long::valueOf)
                    .filter(tagMap::containsKey)
                    .distinct()
                    .collect(Collectors.toList());
            if (hitIds.isEmpty()) {
                uncategorized++;
            } else {
                for (Long tagId : hitIds) counts.merge(tagId, 1L, Long::sum);
            }
        }
        List<ExceptionTagCountVo.Item> items = new ArrayList<>();
        for (OOrderTag tag : poolTags) {
            ExceptionTagCountVo.Item item = new ExceptionTagCountVo.Item();
            item.setTagId(tag.getId());
            item.setName(tag.getName());
            item.setColor(tag.getColor());
            item.setStatus(tag.getStatus());
            item.setCount(counts.getOrDefault(tag.getId(), 0L));
            items.add(item);
        }
        vo.setTags(items);
        vo.setUncategorized(uncategorized);
        return vo;
    }

    // ==================== 批量放行 ====================

    @Override
    public ResultVo<OrderReleaseResultVo> release(OrderReleaseBo bo, List<Long> merchantIds, String username) {
        if (bo.getIds() == null || bo.getIds().isEmpty()) {
            return ResultVo.error("请先勾选订单");
        }
        Map<String, Long> shopAccountMap;
        try {
            shopAccountMap = buildShopAccountMap(bo.getAssignments());
        } catch (IllegalArgumentException e) {
            return ResultVo.error(e.getMessage());
        }
        OrderReleaseResultVo result = new OrderReleaseResultVo();
        List<OrderReleaseResultVo.Item> items = new ArrayList<>();
        int success = 0;
        int fail = 0;
        for (Long id : new LinkedHashSet<>(bo.getIds())) {
            OrderReleaseResultVo.Item item = new OrderReleaseResultVo.Item();
            item.setId(id);
            try {
                String msg = releaseOne(id, merchantIds, username, bo.getRemark(), shopAccountMap, item);
                if (msg == null) {
                    item.setSuccess(true);
                    success++;
                } else {
                    item.setSuccess(false);
                    item.setMsg(msg);
                    fail++;
                }
            } catch (Exception e) {
                log.error("======订单放行异常======id={}，error={}", id, e.getMessage(), e);
                item.setSuccess(false);
                item.setMsg("系统异常：" + e.getMessage());
                fail++;
            }
            items.add(item);
        }
        result.setSuccessCount(success);
        result.setFailCount(fail);
        result.setItems(items);
        log.info("======订单批量放行======操作人={}，选中={}单，成功={}单，失败={}单", username, bo.getIds().size(), success, fail);
        return ResultVo.success(result);
    }

    /**
     * 分店铺面单账号：同一店铺本次只能选一张账号
     */
    private Map<String, Long> buildShopAccountMap(List<OrderReleaseBo.ShopAssignment> assignments) {
        Map<String, Long> map = new LinkedHashMap<>();
        if (assignments == null || assignments.isEmpty()) {
            return map;
        }
        for (OrderReleaseBo.ShopAssignment assignment : assignments) {
            if (assignment == null || assignment.getShopId() == null || assignment.getShopType() == null
                    || assignment.getWaybillAccountId() == null) {
                throw new IllegalArgumentException("放行参数错误：店铺或面单账号缺失");
            }
            String key = shopKey(assignment.getShopId(), assignment.getShopType());
            Long exists = map.putIfAbsent(key, assignment.getWaybillAccountId());
            if (exists != null && !exists.equals(assignment.getWaybillAccountId())) {
                throw new IllegalArgumentException("同一店铺只能选择一个面单账号");
            }
        }
        return map;
    }

    private String shopKey(Long shopId, Integer shopType) {
        return shopId + "#" + shopType;
    }

    /**
     * 单单放行：先按店铺分配主体+面单账号，再做结构校验与条件更新（audit_status IN (0,2) 幂等守卫）
     * @return null=成功，否则为失败原因
     */
    private String releaseOne(Long id, List<Long> merchantIds, String username, String remark,
                              Map<String, Long> shopAccountMap, OrderReleaseResultVo.Item item) {
        OOrder order = orderMapper.selectById(id);
        if (order == null) {
            return "订单不存在";
        }
        item.setOrderNum(order.getOrderNum());
        if (!hasScope(merchantIds, order.getMerchantId())) {
            return "无该订单操作权限";
        }
        if (order.getOrderStatus() != null
                && (order.getOrderStatus() == EnumOOrderStatus.CANCEL.getIndex()
                || order.getOrderStatus() == EnumOOrderStatus.DELETED.getIndex())) {
            return "订单已取消/作废";
        }
        if (order.getAuditStatus() == null
                || (order.getAuditStatus() != EnumAuditStatus.PENDING.getIndex()
                && order.getAuditStatus() != EnumAuditStatus.EXCEPTION.getIndex())) {
            return "当前审核状态不允许放行";
        }
        Integer role = order.getOrderRole() == null ? EnumOrderRole.MASTER.getIndex() : order.getOrderRole();
        if (role == EnumOrderRole.CHILD.getIndex() || role == EnumOrderRole.MERGE_CHILD.getIndex()) {
            // 直接勾选子订单/合并子订单：按发货单元独立放行
            List<OOrderItem> childItems = listChildItems(id);
            String structureMsg = checkChildStructure(order, childItems);
            if (structureMsg != null) {
                return structureMsg;
            }
            String allocMsg = allocateUnit(order, shopAccountMap, username);
            if (allocMsg != null) {
                return allocMsg;
            }
            String msg = checkChildRelease(order, childItems);
            if (msg != null) {
                return msg;
            }
            if (!markReleased(order, username, remark)) {
                return "订单状态已变化，请刷新后重试";
            }
            return null;
        }
        // 主订单：先做结构预检，再对未放行发货单元分配，最后做放行校验
        List<OOrderItem> masterItems = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                .eq(OOrderItem::getOrderId, order.getId())
                .eq(OOrderItem::getItemRole, EnumOrderRole.MASTER.getIndex()));
        List<OOrder> childOrders = listValidChildOrders(Long.parseLong(order.getId()));
        if (childOrders.isEmpty()) {
            String structureMsg = checkMasterStructure(order, masterItems, List.of());
            if (structureMsg != null) {
                return structureMsg;
            }
            String allocMsg = allocateUnit(order, shopAccountMap, username);
            if (allocMsg != null) {
                return allocMsg;
            }
            String msg = checkMasterRelease(order, masterItems, List.of());
            if (msg != null) {
                return msg;
            }
        } else {
            for (OOrder child : childOrders) {
                String structureMsg = checkChildStructure(child, listChildItems(Long.parseLong(child.getId())));
                if (structureMsg != null) {
                    return "子单[" + child.getOrderNum() + "]未就绪：" + structureMsg;
                }
            }
            // 已放行子单不再重复分配/放行，仅处理未放行子单
            List<OOrder> pendingChildren = childOrders.stream()
                    .filter(c -> c.getAuditStatus() == null
                            || c.getAuditStatus() != EnumAuditStatus.APPROVED.getIndex())
                    .collect(Collectors.toList());
            for (OOrder child : pendingChildren) {
                String allocMsg = allocateUnit(child, shopAccountMap, username);
                if (allocMsg != null) {
                    return "子单[" + child.getOrderNum() + "]：" + allocMsg;
                }
            }
            String msg = checkMasterRelease(order, masterItems, listValidChildrenVo(Long.parseLong(order.getId())));
            if (msg != null) {
                return msg;
            }
            for (OOrder child : pendingChildren) {
                if (!markReleased(child, username, remark)) {
                    return "子单[" + child.getOrderNum() + "]状态已变化，请刷新后重试";
                }
            }
        }
        if (!markReleased(order, username, remark)) {
            log.info("======主订单放行跳过（并发已放行）======orderId={}", order.getId());
        }
        return null;
    }

    /**
     * 分配发货单元：按店铺取面单账号，写商品行主体字段与订单 waybill_account_id。
     * 选中账号即确定发货主体+快递+网点；店铺自用 shipperId=0 合法。
     * @return null=成功，否则为失败原因
     */
    private String allocateUnit(OOrder unit, Map<String, Long> shopAccountMap, String username) {
        Long accountId = shopAccountMap.get(shopKey(unit.getShopId(), unit.getShopType()));
        if (accountId == null) {
            accountId = unit.getWaybillAccountId();
        }
        if (accountId == null) {
            return "未选择面单账号";
        }
        ShopWaybillAccount account = shopWaybillAccountMapper.selectById(accountId);
        if (account == null) {
            return "面单账号不存在";
        }
        if (!Objects.equals(account.getShopId(), unit.getShopId())
                || !Objects.equals(account.getShopType(), unit.getShopType())) {
            return "面单账号不属于该店铺";
        }
        if (account.getMerchantId() != null && account.getMerchantId() > 0
                && unit.getMerchantId() != null && !Objects.equals(account.getMerchantId(), unit.getMerchantId())) {
            return "面单账号不属于该商户";
        }
        Integer shipperType = account.getShipperType();
        if (!isSupportedShipperType(shipperType)) {
            return "面单账号未绑定有效发货主体";
        }
        long shipperId = shipperType == EnumShipType.LOCAL.getIndex() ? 0L
                : (account.getShipperId() == null ? 0L : account.getShipperId());
        if (shipperType != EnumShipType.LOCAL.getIndex() && shipperId <= 0) {
            return "面单账号未绑定发货方";
        }
        String itemShipperType;
        String shipperName;
        String shipperNo;
        if (shipperType == EnumShipType.LOCAL.getIndex()) {
            itemShipperType = EnumShipType.LOCAL.toString();
            shipperName = "店铺自用";
            shipperNo = null;
        } else if (shipperType == EnumShipType.SUPPLIER.getIndex()) {
            ErpSupplier supplier = erpSupplierMapper.selectById(shipperId);
            if (supplier == null) {
                return "发货供应商不存在";
            }
            itemShipperType = EnumShipType.SUPPLIER.toString();
            shipperName = supplier.getName();
            shipperNo = supplier.getNumber();
        } else {
            ErpWarehouse warehouse = erpWarehouseMapper.selectById(shipperId);
            if (warehouse == null) {
                return "发货仓库不存在";
            }
            itemShipperType = warehouse.getWarehouseType();
            shipperName = warehouse.getWarehouseName();
            shipperNo = warehouse.getWarehouseNo();
        }
        // 先条件更新订单 waybill_account_id：仅放行前置态（audit_status 0/2）可写，
        // 0 行=并发下状态已变化（已被放行/转异常/撤回），本单放行失败，不再回写商品行，避免脏分配
        Integer allocUpdated = orderMapper.update(null, new LambdaUpdateWrapper<OOrder>()
                .eq(OOrder::getId, unit.getId())
                .in(OOrder::getAuditStatus, EnumAuditStatus.PENDING.getIndex(), EnumAuditStatus.EXCEPTION.getIndex())
                .set(OOrder::getWaybillAccountId, accountId)
                .set(OOrder::getUpdateTime, new Date())
                .set(OOrder::getUpdateBy, username));
        if (allocUpdated == null || allocUpdated == 0) {
            return "订单审核状态已变化，放行失败，请刷新后重试";
        }
        orderItemMapper.update(null, new LambdaUpdateWrapper<OOrderItem>()
                .eq(OOrderItem::getOrderId, unit.getId())
                .set(OOrderItem::getShipType, shipperType)
                .set(OOrderItem::getShipperId, shipperId)
                .set(OOrderItem::getShipperType, itemShipperType)
                .set(OOrderItem::getShipperName, shipperName)
                .set(OOrderItem::getShipperNo, shipperNo)
                .set(OOrderItem::getShipStatus, EnumShipStatus.BU_FEN.getIndex())
                .set(OOrderItem::getUpdateTime, new Date())
                .set(OOrderItem::getUpdateBy, username));
        unit.setWaybillAccountId(accountId);
        return null;
    }

    private boolean isSupportedShipperType(Integer shipperType) {
        return shipperType != null && (shipperType == EnumShipType.LOCAL.getIndex()
                || shipperType == EnumShipType.JD_CLOUD_WAREHOUSE.getIndex()
                || shipperType == EnumShipType.JKY_CLOUD_WAREHOUSE.getIndex()
                || shipperType == EnumShipType.CLOUD_WAREHOUSE.getIndex()
                || shipperType == EnumShipType.SUPPLIER.getIndex());
    }

    /**
     * 放行条件更新：audit_status IN (0,2) 守卫，重复请求返回当前结果
     * @return true=本次更新成功；false=状态已变化
     */
    private boolean markReleased(OOrder order, String username, String remark) {
        Integer updated = orderMapper.update(null, new LambdaUpdateWrapper<OOrder>()
                .eq(OOrder::getId, order.getId())
                .in(OOrder::getAuditStatus, EnumAuditStatus.PENDING.getIndex(), EnumAuditStatus.EXCEPTION.getIndex())
                .set(OOrder::getAuditStatus, EnumAuditStatus.APPROVED.getIndex())
                .set(OOrder::getAuditType, EnumAuditType.MANUAL.getIndex())
                .set(OOrder::getAuditTime, LocalDateTime.now())
                .set(OOrder::getAuditBy, username)
                .set(OOrder::getAuditRemark, remark)
                .set(OOrder::getUpdateTime, new Date())
                .set(OOrder::getUpdateBy, username));
        return updated != null && updated > 0;
    }

    // ==================== 已放行订单撤回异常池 ====================

    @Override
    public ResultVo<OrderReleaseResultVo> withdrawToException(OrderWithdrawBo bo, List<Long> merchantIds, String username) {
        if (bo.getOrderIds() == null || bo.getOrderIds().isEmpty()) {
            return ResultVo.error("请先勾选订单");
        }
        // 撤回必选异常池分类标签（覆盖写订单 tag，口径同打单发货页退回原因）
        if (bo.getTagId() == null) {
            return ResultVo.error("请选择异常分类标签");
        }
        OOrderTag categoryTag = tagMapper.selectById(bo.getTagId());
        if (categoryTag == null) {
            return ResultVo.error("异常分类标签不存在");
        }
        if (categoryTag.getStatus() == null || categoryTag.getStatus() != EnumEnableStatus.ENABLED.getIndex()) {
            return ResultVo.error("异常分类标签已停用：" + categoryTag.getName());
        }
        if (categoryTag.getBindPool() == null || categoryTag.getBindPool() != EnumAuditStatus.EXCEPTION.getIndex()) {
            return ResultVo.error("所选标签不是异常池分类标签：" + categoryTag.getName());
        }
        // 全部异常池分类标签ID：覆盖写时从订单 tag 串移除旧分类，普通标签（bind_pool=0）保留
        Set<String> poolTagIdSet = tagMapper.selectList(new LambdaQueryWrapper<OOrderTag>()
                        .eq(OOrderTag::getBindPool, EnumAuditStatus.EXCEPTION.getIndex()))
                .stream().map(t -> String.valueOf(t.getId())).collect(Collectors.toSet());
        // 逐单 REQUIRES_NEW 独立事务：单单失败只回滚当前单，其余单照常提交（去掉整批回滚语义）
        TransactionTemplate tx = perOrderTransaction();
        Date now = new Date();
        OrderReleaseResultVo result = new OrderReleaseResultVo();
        List<OrderReleaseResultVo.Item> items = new ArrayList<>();
        int success = 0;
        int fail = 0;
        for (Long id : new LinkedHashSet<>(bo.getOrderIds())) {
            OrderReleaseResultVo.Item item = new OrderReleaseResultVo.Item();
            item.setId(id);
            try {
                String msg = tx.execute(status ->
                        withdrawOne(id, categoryTag.getId(), poolTagIdSet, merchantIds, username, now, item));
                if (msg == null) {
                    item.setSuccess(true);
                    success++;
                } else {
                    item.setSuccess(false);
                    item.setMsg(msg);
                    fail++;
                }
            } catch (Exception e) {
                log.error("======工作台撤回异常======id={}，error={}", id, e.getMessage(), e);
                item.setSuccess(false);
                item.setMsg("系统异常：" + e.getMessage());
                fail++;
            }
            items.add(item);
        }
        result.setSuccessCount(success);
        result.setFailCount(fail);
        result.setItems(items);
        log.info("======工作台批量撤回异常======操作人={}，选中={}单，成功={}单，失败={}单，分类标签={}",
                username, bo.getOrderIds().size(), success, fail, bo.getTagId());
        return ResultVo.success(result);
    }

    /**
     * 单单撤回：按当前行独立撤回（不关联主单/其他子单），audit_status 1→2 回落异常池。
     * 与打单发货页退回同深度：清 waybill_account_id、清商品行发货主体与 ship_status→0、覆盖写异常分类标签；
     * 守卫：本行已放行且未发货（ship_status>0 或 waybill_status 2/3/10 拒绝）；
     * 已取号(waybill_status=1)禁止撤回——对齐打单台「退回不自动取消取号」口径，
     * 需先在打单发货页取消取号，撤回不引入平台取消调用
     * @return null=成功，否则为失败原因
     */
    private String withdrawOne(Long id, Long tagId, Set<String> poolTagIdSet, List<Long> merchantIds,
                               String username, Date now, OrderReleaseResultVo.Item item) {
        OOrder unit = orderMapper.selectById(id);
        if (unit == null) {
            return "订单不存在";
        }
        item.setOrderNum(unit.getOrderNum());
        if (!hasScope(merchantIds, unit.getMerchantId())) {
            return "无该订单操作权限";
        }
        Integer role = unit.getOrderRole() == null ? EnumOrderRole.MASTER.getIndex() : unit.getOrderRole();
        if (role == EnumOrderRole.MERGE_CHILD.getIndex()) {
            return "合并发货子订单不支持撤回（随打单发货阶段统一处理）";
        }
        if (unit.getAuditStatus() == null || unit.getAuditStatus() != EnumAuditStatus.APPROVED.getIndex()) {
            return "仅已放行且未发货的订单可撤回异常";
        }
        if (unit.getOrderStatus() != null
                && (unit.getOrderStatus() == EnumOOrderStatus.SHIPPED.getIndex()
                || unit.getOrderStatus() == EnumOOrderStatus.SHIPPED_BF.getIndex()
                || unit.getOrderStatus() == EnumOOrderStatus.COMPLETE.getIndex())) {
            return "订单[" + unit.getOrderNum() + "]已发货，不允许撤回";
        }
        Integer ss = unit.getShipStatus();
        if (ss != null && ss != EnumShipStatus.NOT.getIndex()) {
            return "订单[" + unit.getOrderNum() + "]已发货/部分发货，不允许撤回";
        }
        Integer ws = unit.getWaybillStatus();
        if (ws != null && ws == EnumWaybillStatus.TAKEN.getIndex()) {
            return "订单[" + unit.getOrderNum() + "]已取号，请先在打单发货页取消取号后再撤回";
        }
        if (ws != null && (ws == EnumWaybillStatus.PRINTED.getIndex()
                || ws == EnumWaybillStatus.SHIPPED.getIndex() || ws == EnumWaybillStatus.MANUAL_SHIPPED.getIndex())) {
            return "订单[" + unit.getOrderNum() + "]已打印/已发货，不允许撤回";
        }
        // 当前行条件回退：audit_status 1→2 且未发货/未取号守卫（幂等，口径同打单发货页 returnOne）；清面单账号
        Integer updated = orderMapper.update(null, new LambdaUpdateWrapper<OOrder>()
                .eq(OOrder::getId, unit.getId())
                .eq(OOrder::getAuditStatus, EnumAuditStatus.APPROVED.getIndex())
                .eq(OOrder::getShipStatus, EnumShipStatus.NOT.getIndex())
                .and(w -> w.isNull(OOrder::getWaybillStatus)
                        .or().eq(OOrder::getWaybillStatus, EnumWaybillStatus.NOT_TAKEN.getIndex()))
                .set(OOrder::getAuditStatus, EnumAuditStatus.EXCEPTION.getIndex())
                .set(OOrder::getWaybillAccountId, null)
                .set(OOrder::getUpdateTime, now)
                .set(OOrder::getUpdateBy, username));
        if (updated == null || updated == 0) {
            return "订单状态已变化，请刷新后重试";
        }
        // 清商品行发货主体与发货状态，回异常池重新决策（重分配 / 重拆）；
        // ship_type/shipper_id/ship_status 基线为 NOT NULL，按建表默认值回写（口径同打单发货页 returnOne）
        orderItemMapper.update(null, new LambdaUpdateWrapper<OOrderItem>()
                .eq(OOrderItem::getOrderId, unit.getId())
                .set(OOrderItem::getShipType, EnumShipType.LOCAL.getIndex())
                .set(OOrderItem::getShipperId, 0L)
                .set(OOrderItem::getShipperType, null)
                .set(OOrderItem::getShipperName, null)
                .set(OOrderItem::getShipperNo, null)
                .set(OOrderItem::getShipStatus, EnumShipStatus.NOT.getIndex())
                .set(OOrderItem::getUpdateTime, now)
                .set(OOrderItem::getUpdateBy, username));
        // 撤回原因覆盖写：移除订单 tag 串中全部异常池分类ID，追加本次分类（复用转异常覆盖写私有方法）
        overwriteExceptionTag(unit.getId(), unit.getTag(), tagId, poolTagIdSet, now);
        log.info("======工作台撤回异常单笔======操作人={}，订单={}，撤回当前行，分类标签={}",
                username, unit.getOrderNum(), tagId);
        return null;
    }

    /**
     * 逐单独立事务模板（REQUIRES_NEW）：单单成败互不影响，与打单发货页批量操作同实现
     */
    private TransactionTemplate perOrderTransaction() {
        TransactionTemplate template = new TransactionTemplate(transactionManager);
        template.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
        return template;
    }

    /**
     * 主订单下的有效子订单（拆分子单；OMS 暂无 o_order_item.source_order_id 列，
     * 合并发货子单关联链路随打单发货阶段接入）
     */
    private List<OOrder> listValidChildOrders(Long masterId) {
        return new ArrayList<>(orderMapper.selectList(new LambdaQueryWrapper<OOrder>()
                .eq(OOrder::getParentOrderId, masterId)
                .notIn(OOrder::getOrderStatus, EnumOOrderStatus.CANCEL.getIndex(),
                        EnumOOrderStatus.DELETED.getIndex())));
    }

    private List<OrderPoolOrderVo> listValidChildrenVo(Long masterId) {
        List<OrderPoolOrderVo> result = new ArrayList<>();
        for (OOrder child : listValidChildOrders(masterId)) {
            OrderPoolOrderVo vo = toVo(child);
            // 已放行子单不再要求面单账号（历史放行数据无账号，不能反过来卡住同主单未放行子单）
            boolean approved = child.getAuditStatus() != null
                    && child.getAuditStatus() == EnumAuditStatus.APPROVED.getIndex();
            String msg = approved ? null : checkChildRelease(child, listChildItems(Long.parseLong(child.getId())));
            vo.setCanRelease(msg == null);
            vo.setCanReleaseMsg(msg);
            vo.setAuditStatus(child.getAuditStatus());
            result.add(vo);
        }
        return result;
    }

    private List<OOrderItem> listChildItems(Long orderId) {
        return orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                .eq(OOrderItem::getOrderId, String.valueOf(orderId))
                .eq(OOrderItem::getItemRole, EnumOrderRole.CHILD.getIndex()));
    }

    // ==================== 取消订单 ====================

    @Override
    public ResultVo<Void> cancelOrder(OrderCancelBo bo, List<Long> merchantIds, String username) {
        if (bo.getOrderId() == null) {
            return ResultVo.error("订单ID不能为空");
        }
        OOrder master = orderMapper.selectById(bo.getOrderId());
        if (master == null) {
            return ResultVo.error("订单不存在");
        }
        if (!hasScope(merchantIds, master.getMerchantId())) {
            return ResultVo.error("无该订单操作权限");
        }
        if (master.getOrderRole() != null && master.getOrderRole() != EnumOrderRole.MASTER.getIndex()) {
            return ResultVo.error("仅支持主订单级取消");
        }
        Integer status = master.getOrderStatus();
        if (status != null) {
            if (status == EnumOOrderStatus.CANCEL.getIndex()) {
                return ResultVo.error("订单已取消");
            }
            if (status == EnumOOrderStatus.SHIPPED.getIndex() || status == EnumOOrderStatus.SHIPPED_BF.getIndex()
                    || status == EnumOOrderStatus.COMPLETE.getIndex()) {
                return ResultVo.error("订单已发货，不允许取消");
            }
            if (status != EnumOOrderStatus.NEW.getIndex() && status != EnumOOrderStatus.WAIT_SHIP.getIndex()
                    && status != EnumOOrderStatus.WAIT_PAY.getIndex() && status != EnumOOrderStatus.LOCKED.getIndex()) {
                return ResultVo.error("当前订单状态不允许取消");
            }
        }
        // 有效子单：已打印/已发货/手动发货的禁止取消
        List<OOrder> validChildren = listValidChildOrders(Long.parseLong(master.getId()));
        for (OOrder child : validChildren) {
            Integer ws = child.getWaybillStatus();
            if (ws != null && (ws == EnumWaybillStatus.PRINTED.getIndex()
                    || ws == EnumWaybillStatus.SHIPPED.getIndex() || ws == EnumWaybillStatus.MANUAL_SHIPPED.getIndex())) {
                return ResultVo.error("子单[" + child.getOrderNum() + "]已打印/已发货，不允许取消");
            }
        }

        // 主订单置已取消（平台回传复用现有取消回传链路，工作台不重复实现）
        OOrder masterUpdate = new OOrder();
        masterUpdate.setId(master.getId());
        masterUpdate.setOrderStatus(EnumOOrderStatus.CANCEL.getIndex());
        masterUpdate.setCancelReason(bo.getReason());
        masterUpdate.setUpdateTime(new Date());
        masterUpdate.setUpdateBy(username);
        orderMapper.updateById(masterUpdate);

        // 子单联动作废：已取号未打印的自动取消取号（waybill_status 回 0）
        List<Long> cancelledIds = new ArrayList<>();
        cancelledIds.add(Long.parseLong(master.getId()));
        for (OOrder child : validChildren) {
            OOrder childUpdate = new OOrder();
            childUpdate.setId(child.getId());
            childUpdate.setOrderStatus(EnumOOrderStatus.CANCEL.getIndex());
            if (child.getWaybillStatus() != null && child.getWaybillStatus() == EnumWaybillStatus.TAKEN.getIndex()) {
                childUpdate.setWaybillStatus(EnumWaybillStatus.NOT_TAKEN.getIndex());
            }
            childUpdate.setUpdateTime(new Date());
            childUpdate.setUpdateBy(username);
            orderMapper.updateById(childUpdate);
            cancelledIds.add(Long.parseLong(child.getId()));
        }
        // 关联执行单（o_order_stocking）同步作废
        orderStockingMapper.update(null, new LambdaUpdateWrapper<OOrderStocking>()
                .in(OOrderStocking::getOOrderId, cancelledIds)
                .notIn(OOrderStocking::getOrderStatus, EnumOOrderStatus.CANCEL.getIndex(),
                        EnumOOrderStatus.DELETED.getIndex())
                .set(OOrderStocking::getOrderStatus, EnumOOrderStatus.CANCEL.getIndex())
                .set(OOrderStocking::getUpdateBy, username)
                .set(OOrderStocking::getUpdateTime, new Date()));
        log.info("======工作台取消订单======操作人={}，主订单={}，联动作废子单={}张", username, master.getOrderNum(), validChildren.size());
        return ResultVo.success();
    }

    // ==================== 修改卖家备注/收货地址 ====================

    @Override
    public ResultVo<Void> updateMemo(OrderMemoBo bo, List<Long> merchantIds, String username) {
        if (bo.getOrderId() == null) {
            return ResultVo.error("订单ID不能为空");
        }
        OOrder order = orderMapper.selectById(bo.getOrderId());
        if (order == null) {
            return ResultVo.error("订单不存在");
        }
        if (!hasScope(merchantIds, order.getMerchantId())) {
            return ResultVo.error("无该订单操作权限");
        }
        if (!editableBeforeShip(order)) {
            return ResultVo.error("已发货订单不可修改卖家备注");
        }
        OOrder update = new OOrder();
        update.setId(order.getId());
        update.setSellerMemo(bo.getSellerMemo() == null ? "" : bo.getSellerMemo());
        update.setUpdateTime(new Date());
        update.setUpdateBy(username);
        orderMapper.updateById(update);
        return ResultVo.success();
    }

    @Override
    public ResultVo<Void> updateAddress(OrderAddressBo bo, List<Long> merchantIds, String username) {
        if (bo.getOrderId() == null) {
            return ResultVo.error("订单ID不能为空");
        }
        if (!StringUtils.hasText(bo.getReceiverName()) || !StringUtils.hasText(bo.getReceiverMobile())
                || !StringUtils.hasText(bo.getAddress())) {
            return ResultVo.error("收件人、手机号、详细地址不能为空");
        }
        OOrder order = orderMapper.selectById(bo.getOrderId());
        if (order == null) {
            return ResultVo.error("订单不存在");
        }
        if (!hasScope(merchantIds, order.getMerchantId())) {
            return ResultVo.error("无该订单操作权限");
        }
        if (!editableBeforeShip(order)) {
            return ResultVo.error("已发货订单不可修改收货地址");
        }
        if (order.getWaybillStatus() != null && order.getWaybillStatus() != EnumWaybillStatus.NOT_TAKEN.getIndex()) {
            return ResultVo.error("已取号，请先取消取号再修改地址");
        }

        List<String> updateIds = new ArrayList<>();
        updateIds.add(order.getId());
        // 主单已拆分时同步未取号子单（履约单元地址必须与主单一致）
        if (order.getOrderRole() == null || order.getOrderRole() == EnumOrderRole.MASTER.getIndex()) {
            List<OOrder> children = orderMapper.selectList(new LambdaQueryWrapper<OOrder>()
                    .eq(OOrder::getParentOrderId, Long.parseLong(order.getId()))
                    .notIn(OOrder::getOrderStatus, EnumOOrderStatus.CANCEL.getIndex(),
                            EnumOOrderStatus.DELETED.getIndex()));
            for (OOrder child : children) {
                if (child.getWaybillStatus() != null && child.getWaybillStatus() != EnumWaybillStatus.NOT_TAKEN.getIndex()) {
                    return ResultVo.error("子单[" + child.getOrderNum() + "]已取号，请先取消取号再修改地址");
                }
                updateIds.add(child.getId());
            }
        }
        Integer updated = orderMapper.update(null, new LambdaUpdateWrapper<OOrder>()
                .in(OOrder::getId, updateIds)
                .set(OOrder::getReceiverName, bo.getReceiverName())
                .set(OOrder::getReceiverMobile, bo.getReceiverMobile())
                .set(OOrder::getProvince, bo.getProvince())
                .set(OOrder::getCity, bo.getCity())
                .set(OOrder::getTown, bo.getTown())
                .set(OOrder::getAddress, bo.getAddress())
                .set(OOrder::getUpdateTime, new Date())
                .set(OOrder::getUpdateBy, username));
        log.info("======工作台修改收货地址======操作人={}，订单={}，同步更新={}行", username, order.getOrderNum(), updated);
        return ResultVo.success();
    }

    // ==================== 私有工具 ====================

    /** 未发货前可编辑（新订单/待发货/待付款/锁定） */
    private boolean editableBeforeShip(OOrder order) {
        Integer status = order.getOrderStatus();
        if (status == null) {
            return true;
        }
        return status == EnumOOrderStatus.NEW.getIndex() || status == EnumOOrderStatus.WAIT_SHIP.getIndex()
                || status == EnumOOrderStatus.WAIT_PAY.getIndex() || status == EnumOOrderStatus.LOCKED.getIndex();
    }

    /** 数据范围：merchantIds=null 总部不限；否则订单商户须在范围内 */
    private boolean hasScope(List<Long> merchantIds, Long orderMerchantId) {
        if (merchantIds == null) {
            return true;
        }
        return orderMerchantId != null && merchantIds.contains(orderMerchantId);
    }

    private int nz(Integer value) {
        return value == null ? 0 : value;
    }

    private String buildGoodsSummary(List<OOrderItem> items) {
        if (items == null || items.isEmpty()) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        int total = 0;
        for (int i = 0; i < items.size(); i++) {
            OOrderItem item = items.get(i);
            total += nz(item.getQuantity());
            if (i < 2) {
                if (i > 0) {
                    sb.append("；");
                }
                sb.append(item.getGoodsTitle()).append("(")
                        .append(item.getSkuNum()).append("/")
                        .append(item.getGoodsNum()).append(")×").append(nz(item.getQuantity()));
            }
        }
        if (items.size() > 2) {
            sb.append(" 等").append(items.size()).append("种");
        }
        sb.append("（共").append(total).append("件）");
        return sb.toString();
    }

    private OrderPoolOrderVo toVo(OOrder o) {
        OrderPoolOrderVo vo = new OrderPoolOrderVo();
        vo.setId(o.getId() == null ? null : Long.parseLong(o.getId()));
        vo.setOrderNum(o.getOrderNum());
        Integer role = o.getOrderRole() == null ? EnumOrderRole.MASTER.getIndex() : o.getOrderRole();
        vo.setOrderRole(role);
        vo.setOrderRoleName(EnumOrderRole.getName(role));
        vo.setOrderMode(o.getOrderMode());
        vo.setAuditStatus(o.getAuditStatus());
        vo.setAuditStatusName(o.getAuditStatus() == null ? null : EnumAuditStatus.getName(o.getAuditStatus()));
        vo.setParentOrderId(o.getParentOrderId());
        vo.setShopId(o.getShopId());
        vo.setShopType(o.getShopType());
        vo.setMerchantId(o.getMerchantId());
        vo.setOrderStatus(o.getOrderStatus());
        vo.setShipStatus(o.getShipStatus());
        vo.setWaybillStatus(o.getWaybillStatus());
        vo.setWaybillAccountId(o.getWaybillAccountId());
        vo.setWaybillCode(o.getWaybillCode());
        vo.setWaybillCompany(o.getWaybillCompany());
        vo.setGoodsAmount(toBigDecimal(o.getGoodsAmount()));
        vo.setPostFee(toBigDecimal(o.getPostFee()));
        vo.setAmount(toBigDecimal(o.getAmount()));
        vo.setPayment(toBigDecimal(o.getPayment()));
        vo.setReceiverName(o.getReceiverName());
        vo.setReceiverMobile(o.getReceiverMobile());
        vo.setProvince(o.getProvince());
        vo.setCity(o.getCity());
        vo.setTown(o.getTown());
        vo.setAddress(o.getAddress());
        vo.setBuyerMemo(o.getBuyerMemo());
        vo.setSellerMemo(o.getSellerMemo());
        vo.setTag(o.getTag());
        vo.setOrderTime(o.getOrderTime());
        vo.setCreateTime(o.getCreateTime());
        return vo;
    }

    private BigDecimal toBigDecimal(Double value) {
        return value == null ? null : BigDecimal.valueOf(value).setScale(2, java.math.RoundingMode.HALF_UP);
    }

    private List<String> parseOrderNums(String input) {
        if (!StringUtils.hasText(input)) {
            return new ArrayList<>();
        }
        List<String> nums = Arrays.stream(input.split("[\\s,，;；]+"))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .distinct()
                .collect(Collectors.toList());
        if (nums.size() > ORDER_NUM_LIMIT) {
            throw new RuntimeException("订单号数量超过上限" + ORDER_NUM_LIMIT + "个，请分批查询");
        }
        return nums;
    }

    private List<Long> parseLongList(String input) {
        if (!StringUtils.hasText(input)) {
            return new ArrayList<>();
        }
        return Arrays.stream(input.split("[\\s,，;；]+"))
                .map(String::trim)
                .filter(s -> s.matches("\\d+"))
                .map(Long::valueOf)
                .distinct()
                .collect(Collectors.toList());
    }

    private LocalDateTime parseTime(String input, boolean beginOfDay) {
        if (!StringUtils.hasText(input)) {
            return null;
        }
        String text = input.trim();
        try {
            if (text.length() == 10) {
                LocalDate date = LocalDate.parse(text, DATE_FORMAT);
                return beginOfDay ? date.atStartOfDay() : date.atTime(LocalTime.MAX);
            }
            return LocalDateTime.parse(text, TIME_FORMAT);
        } catch (Exception e) {
            throw new RuntimeException("时间格式错误：" + input + "，支持 yyyy-MM-dd 或 yyyy-MM-dd HH:mm:ss");
        }
    }
}
