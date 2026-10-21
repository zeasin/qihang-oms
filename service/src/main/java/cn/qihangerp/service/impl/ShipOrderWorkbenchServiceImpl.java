package cn.qihangerp.service.impl;

import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.enums.EnumAuditStatus;
import cn.qihangerp.enums.EnumEnableStatus;
import cn.qihangerp.enums.EnumOOrderStatus;
import cn.qihangerp.enums.EnumOrderRole;
import cn.qihangerp.enums.EnumOrderStockingSendStatus;
import cn.qihangerp.enums.EnumShipMode;
import cn.qihangerp.enums.EnumShipStatus;
import cn.qihangerp.enums.EnumShipType;
import cn.qihangerp.enums.EnumShopType;
import cn.qihangerp.enums.EnumStockingStatus;
import cn.qihangerp.enums.EnumWaybillStatus;
import cn.qihangerp.enums.HttpStatus;
import cn.qihangerp.mapper.ErpSupplierMapper;
import cn.qihangerp.mapper.ErpWarehouseMapper;
import cn.qihangerp.mapper.goods.OGoodsSkuMapper;
import cn.qihangerp.mapper.OLogisticsCompanyMapper;
import cn.qihangerp.mapper.OOrderItemMapper;
import cn.qihangerp.mapper.OOrderMapper;
import cn.qihangerp.mapper.OOrderStockingItemMapper;
import cn.qihangerp.mapper.OOrderStockingMapper;
import cn.qihangerp.mapper.OOrderTagMapper;
import cn.qihangerp.mapper.OShipWaybillMapper;
import cn.qihangerp.mapper.OShopMapper;
import cn.qihangerp.model.bo.ShipWorkbenchCancelBo;
import cn.qihangerp.model.bo.ShipWorkbenchDistributeBo;
import cn.qihangerp.model.bo.ShipWorkbenchManualShipBo;
import cn.qihangerp.model.bo.ShipWorkbenchPrintBo;
import cn.qihangerp.model.bo.ShipWorkbenchReturnBo;
import cn.qihangerp.model.bo.ShipWorkbenchShipBo;
import cn.qihangerp.model.bo.ShipWorkbenchTakeBo;
import cn.qihangerp.model.bo.WaybillCancelBo;
import cn.qihangerp.model.bo.WaybillShipBo;
import cn.qihangerp.model.bo.WaybillTakeBo;
import cn.qihangerp.model.bo.WaybillTakeItemBo;
import cn.qihangerp.model.entity.ErpSupplier;
import cn.qihangerp.model.entity.ErpWarehouse;
import cn.qihangerp.model.entity.OLogisticsCompany;
import cn.qihangerp.model.entity.OGoodsSku;
import cn.qihangerp.model.entity.OOrder;
import cn.qihangerp.model.entity.OOrderItem;
import cn.qihangerp.model.entity.OOrderStocking;
import cn.qihangerp.model.entity.OOrderStockingItem;
import cn.qihangerp.model.entity.OOrderTag;
import cn.qihangerp.model.entity.OShipWaybill;
import cn.qihangerp.model.entity.OShop;
import cn.qihangerp.model.entity.ShopWaybillAccount;
import cn.qihangerp.model.request.ShipWorkbenchQuery;
import cn.qihangerp.model.vo.ShipWorkbenchActionResultVo;
import cn.qihangerp.model.vo.ShipWorkbenchItemVo;
import cn.qihangerp.model.vo.ShipWorkbenchOrderVo;
import cn.qihangerp.model.vo.ShipWorkbenchPoolCountsVo;
import cn.qihangerp.model.vo.WaybillShipResultVo;
import cn.qihangerp.model.vo.WaybillTakeResultVo;
import cn.qihangerp.service.ShipOrderWorkbenchService;
import cn.qihangerp.service.ShopWaybillAccountService;
import cn.qihangerp.service.waybill.PlatformWaybillAdapterRegistry;
import cn.qihangerp.service.waybill.PlatformWaybillCapability;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 打单发货统一队列服务实现
 * 参照 qihang-erp-pro ShipOrderWorkbenchWaybillServiceImpl（docs/design/16-打单发货.md
 * §4.1 队列口径 / §3.1 分配落库 / §五 整单退回 / §4.7 逐动作时序 / §六 备货单），
 * 队列校验、状态机把关、本地落库与结果汇总口径与 erp-pro 完全一致。
 * <p>
 * 与 erp-pro 的编排差异（OMS 为单体工程，无 ec-api Feign 层）：
 * - 平台动作（取号/取消取号/发货回传）直调 {@link PlatformWaybillAdapterRegistry} 路由的平台适配器；
 *   开源版未接入平台时适配器抛「开源版本不支持电子面单功能」异常，属预期行为，队列捕获后逐单返回失败原因；
 * - 面单账号直读本地 ShopWaybillAccountService（替代 ec-api accountListByIds/accountOptions）；
 * - 打单记录（o_order_ship_waybill）落库/回退/打印推进收敛为本类私有方法（替代
 *   ShipOrderWorkbenchWaybillRecordService），只服务新队列，不影响旧发货链路；
 * - 发货成功推进 o_order.order_status→已发货(2)：修正 erp-pro 已知口径（平台面单链路只回写
 *   ship_status/waybill_status 不推进订单状态，OMS 统一按发货终态收敛，见 saveShipResult）。
 *
 * @author qihang
 * @date 2026-10-22
 */
@Slf4j
@Service
@AllArgsConstructor
public class ShipOrderWorkbenchServiceImpl implements ShipOrderWorkbenchService {

    /** 商品关键词命中订单数上限，保护 IN 查询规模（与审单工作台同口径） */
    private static final int KEYWORD_ORDER_LIMIT = 2000;
    /** 行组装批量查账号的 id 上限，防止 IN 过大 */
    private static final int ACCOUNT_QUERY_LIMIT = 200;

    private final OOrderMapper orderMapper;
    private final OOrderItemMapper orderItemMapper;
    private final OShopMapper shopMapper;
    private final OOrderTagMapper tagMapper;
    private final ErpSupplierMapper supplierMapper;
    private final ErpWarehouseMapper warehouseMapper;
    private final OLogisticsCompanyMapper logisticsCompanyMapper;
    private final OGoodsSkuMapper goodsSkuMapper;
    private final OOrderStockingMapper orderStockingMapper;
    private final OOrderStockingItemMapper orderStockingItemMapper;
    private final OShipWaybillMapper shipWaybillMapper;
    private final ShopWaybillAccountService shopWaybillAccountService;
    private final PlatformWaybillAdapterRegistry waybillAdapterRegistry;
    private final PlatformTransactionManager transactionManager;

    // ==================== 队列查询 ====================

    @Override
    public PageResult<ShipWorkbenchOrderVo> page(ShipWorkbenchQuery query, PageQuery pageQuery) {
        LambdaQueryWrapper<OOrder> wrapper = buildQueueWrapper(query);
        applySort(query, wrapper);
        Page<OOrder> page = orderMapper.selectPage(pageQuery.build(), wrapper);
        PageResult<ShipWorkbenchOrderVo> result = new PageResult<>();
        result.setCode(HttpStatus.SUCCESS);
        result.setMsg("查询成功");
        result.setTotal(page.getTotal());
        result.setRecords(buildRows(page.getRecords()));
        return result;
    }

    @Override
    public ShipWorkbenchPoolCountsVo poolCounts(ShipWorkbenchQuery query) {
        ShipWorkbenchPoolCountsVo vo = new ShipWorkbenchPoolCountsVo();
        vo.setTotal(orderMapper.selectCount(buildQueueWrapper(query)));
        vo.setNotTaken(orderMapper.selectCount(buildQueueWrapper(query)
                .and(w -> w.isNull(OOrder::getWaybillStatus)
                        .or().eq(OOrder::getWaybillStatus, EnumWaybillStatus.NOT_TAKEN.getIndex()))));
        vo.setTaken(orderMapper.selectCount(buildQueueWrapper(query)
                .eq(OOrder::getWaybillStatus, EnumWaybillStatus.TAKEN.getIndex())));
        vo.setPrinted(orderMapper.selectCount(buildQueueWrapper(query)
                .eq(OOrder::getWaybillStatus, EnumWaybillStatus.PRINTED.getIndex())));
        vo.setAllocatePending(orderMapper.selectCount(buildQueueWrapper(query)
                .isNull(OOrder::getWaybillAccountId)));
        return vo;
    }

    @Override
    public ShipWorkbenchOrderVo detail(Long id, List<Long> merchantIds) {
        OOrder order = orderMapper.selectById(id);
        if (order == null || !hasScope(merchantIds, order.getMerchantId())) {
            return null;
        }
        List<ShipWorkbenchOrderVo> rows = buildRows(List.of(order));
        return rows.isEmpty() ? null : rows.get(0);
    }

    /**
     * 队列口径（设计文档 §4.1）：已放行 + 待发货 + 未发货；
     * 排除合并发货子订单（由合并主单承担履约）与已发货面单状态（3已发货/10手动发货）
     */
    private LambdaQueryWrapper<OOrder> buildQueueWrapper(ShipWorkbenchQuery query) {
        LambdaQueryWrapper<OOrder> wrapper = new LambdaQueryWrapper<OOrder>()
                .eq(OOrder::getAuditStatus, EnumAuditStatus.APPROVED.getIndex())
                .eq(OOrder::getOrderStatus, EnumOOrderStatus.WAIT_SHIP.getIndex())
                .eq(OOrder::getShipStatus, EnumShipStatus.NOT.getIndex())
                .and(w -> w.isNull(OOrder::getOrderRole)
                        .or().ne(OOrder::getOrderRole, EnumOrderRole.MERGE_CHILD.getIndex()))
                .and(w -> w.isNull(OOrder::getWaybillStatus)
                        .or().notIn(OOrder::getWaybillStatus,
                                EnumWaybillStatus.SHIPPED.getIndex(),
                                EnumWaybillStatus.MANUAL_SHIPPED.getIndex()));
        wrapper.eq(query.getMerchantId() != null, OOrder::getMerchantId, query.getMerchantId())
                .eq(query.getShopId() != null, OOrder::getShopId, query.getShopId())
                .eq(query.getShopType() != null, OOrder::getShopType, query.getShopType())
                .eq(query.getWaybillAccountId() != null, OOrder::getWaybillAccountId, query.getWaybillAccountId())
                .like(StringUtils.hasText(query.getReceiverName()), OOrder::getReceiverName, query.getReceiverName())
                .like(StringUtils.hasText(query.getReceiverMobile()), OOrder::getReceiverMobile, query.getReceiverMobile());
        // 补分配子视图：仅异常回落（账号被撤销绑定/失效）后 waybill_account_id 为空的单元
        if (Boolean.TRUE.equals(query.getAllocatePending())) {
            wrapper.isNull(OOrder::getWaybillAccountId);
        }
        // 取号状态：未取号按空值兜底（存量行 waybill_status 可能为 NULL）
        if (query.getWaybillStatus() != null) {
            int ws = query.getWaybillStatus();
            if (ws == EnumWaybillStatus.NOT_TAKEN.getIndex()) {
                wrapper.and(w -> w.isNull(OOrder::getWaybillStatus).or().eq(OOrder::getWaybillStatus, ws));
            } else {
                wrapper.eq(OOrder::getWaybillStatus, ws);
            }
        }
        // 发货主体：按明细 ship_type / shipper_id EXISTS 命中（与审单台待发货池同口径）
        if (query.getShipperType() != null && query.getShipperId() != null) {
            wrapper.exists("SELECT 1 FROM o_order_item i WHERE i.order_id = o_order.id AND i.ship_type = {0} AND i.shipper_id = {1}",
                    query.getShipperType(), query.getShipperId());
        } else if (query.getShipperType() != null) {
            wrapper.exists("SELECT 1 FROM o_order_item i WHERE i.order_id = o_order.id AND i.ship_type = {0}",
                    query.getShipperType());
        } else if (query.getShipperId() != null) {
            wrapper.exists("SELECT 1 FROM o_order_item i WHERE i.order_id = o_order.id AND i.shipper_id = {0}",
                    query.getShipperId());
        }
        // 发货方分类：self店铺自用0 / supplier供应商300 / cloud云仓100,110,200
        if (StringUtils.hasText(query.getShipperCategory())) {
            switch (query.getShipperCategory().trim().toLowerCase()) {
                case "self" -> wrapper.exists("SELECT 1 FROM o_order_item i WHERE i.order_id = o_order.id AND i.ship_type = {0}",
                        EnumShipType.LOCAL.getIndex());
                case "supplier" -> wrapper.exists("SELECT 1 FROM o_order_item i WHERE i.order_id = o_order.id AND i.ship_type = {0}",
                        EnumShipType.SUPPLIER.getIndex());
                case "cloud" -> wrapper.exists("SELECT 1 FROM o_order_item i WHERE i.order_id = o_order.id AND i.ship_type IN ({0},{1},{2})",
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
        // 商品关键词：先查命中商品行的订单ID集合（与审单台同模式）
        if (StringUtils.hasText(query.getGoodsKeyword())) {
            String keyword = query.getGoodsKeyword().trim();
            List<OOrderItem> hitItems = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                    .select(OOrderItem::getOrderId)
                    .and(w -> w.like(OOrderItem::getGoodsTitle, keyword)
                            .or().like(OOrderItem::getSkuNum, keyword)
                            .or().like(OOrderItem::getBarcode, keyword))
                    .last("LIMIT " + KEYWORD_ORDER_LIMIT));
            if (hitItems.isEmpty()) {
                wrapper.apply("1 = 0");
            } else {
                List<Long> orderIds = hitItems.stream().map(OOrderItem::getOrderId).filter(Objects::nonNull)
                        .map(Long::parseLong).distinct().collect(Collectors.toList());
                wrapper.in(OOrder::getId, orderIds);
            }
        }
        return wrapper;
    }

    /**
     * 队列排序：白名单固定 SQL 片段（OMS o_order 无 latest_delivery_time 列，最晚发货时间排序不做），
     * 末位 id 倒序兜底保证翻页稳定
     */
    private void applySort(ShipWorkbenchQuery query, LambdaQueryWrapper<OOrder> wrapper) {
        boolean asc = "ascending".equals(query.getSortOrder());
        String dir = asc ? "ASC" : "DESC";
        String field = query.getSortField() == null ? "" : query.getSortField();
        String orderSql = switch (field) {
            case "stayTime" -> "(o_order.create_time IS NULL), o_order.create_time " + dir;
            case "waybillStatus" -> "(o_order.waybill_status IS NULL), o_order.waybill_status " + dir;
            case "orderTime" -> "o_order.order_time " + dir;
            default -> "o_order.order_time DESC";
        };
        wrapper.last("ORDER BY " + orderSql + ", o_order.id DESC");
    }

    /**
     * 行组装：明细按订单角色取（主单原始行 item_role=0 / 子单履约行 item_role=1），
     * 面单账号批量查 ShopWaybillAccountService 后回填展示字段
     */
    private List<ShipWorkbenchOrderVo> buildRows(List<OOrder> units) {
        if (units == null || units.isEmpty()) {
            return new ArrayList<>();
        }
        List<String> unitIds = units.stream().map(OOrder::getId).collect(Collectors.toList());
        Map<String, List<OOrderItem>> itemMap = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                        .in(OOrderItem::getOrderId, unitIds))
                .stream().collect(Collectors.groupingBy(OOrderItem::getOrderId));

        Set<Long> shopIds = units.stream().map(OOrder::getShopId).filter(Objects::nonNull)
                .collect(Collectors.toCollection(LinkedHashSet::new));
        Map<Long, OShop> shopMap = shopIds.isEmpty() ? Map.of()
                : shopMapper.selectBatchIds(shopIds).stream()
                .collect(Collectors.toMap(OShop::getId, s -> s, (a, b) -> a));

        Set<Long> accountIds = units.stream().map(OOrder::getWaybillAccountId).filter(Objects::nonNull)
                .collect(Collectors.toCollection(LinkedHashSet::new));
        Map<Long, ShopWaybillAccount> accountMap = loadAccounts(accountIds);

        List<ShipWorkbenchOrderVo> rows = new ArrayList<>();
        for (OOrder unit : units) {
            ShipWorkbenchOrderVo vo = new ShipWorkbenchOrderVo();
            vo.setId(Long.parseLong(unit.getId()));
            vo.setOrderNum(unit.getOrderNum());
            vo.setOrderRole(unit.getOrderRole());
            vo.setOrderRoleName(unit.getOrderRole() == null ? null : EnumOrderRole.getName(unit.getOrderRole()));
            vo.setOrderMode(unit.getOrderMode());
            vo.setShopId(unit.getShopId());
            vo.setShopType(unit.getShopType());
            vo.setPlatformName(unit.getShopType() == null ? null : EnumShopType.getName(unit.getShopType()));
            OShop shop = shopMap.get(unit.getShopId());
            vo.setShopName(shop == null ? null : shop.getName());
            vo.setMerchantId(unit.getMerchantId());
            vo.setParentOrderId(unit.getParentOrderId());
            vo.setAuditStatus(unit.getAuditStatus());
            vo.setOrderStatus(unit.getOrderStatus());
            vo.setShipStatus(unit.getShipStatus());
            int ws = unit.getWaybillStatus() == null ? EnumWaybillStatus.NOT_TAKEN.getIndex() : unit.getWaybillStatus();
            vo.setWaybillStatus(ws);
            vo.setWaybillStatusName(EnumWaybillStatus.getName(ws));
            vo.setWaybillCode(unit.getWaybillCode());
            vo.setWaybillCompany(unit.getWaybillCompany());
            vo.setShippingCompanyCode(unit.getShippingCompanyCode());
            vo.setWaybillAccountId(unit.getWaybillAccountId());
            vo.setAllocated(unit.getWaybillAccountId() != null);
            vo.setReceiverName(unit.getReceiverName());
            vo.setReceiverMobile(unit.getReceiverMobile());
            vo.setProvince(unit.getProvince());
            vo.setCity(unit.getCity());
            vo.setTown(unit.getTown());
            vo.setAddress(unit.getAddress());
            vo.setBuyerMemo(unit.getBuyerMemo());
            vo.setSellerMemo(unit.getSellerMemo());
            vo.setTag(unit.getTag());
            vo.setPayment(unit.getPayment());
            vo.setOrderTime(unit.getOrderTime());
            vo.setCreateTime(unit.getCreateTime());
            vo.setStayHours(unit.getCreateTime() == null ? null
                    : Math.max(0L, (System.currentTimeMillis() - unit.getCreateTime().getTime()) / 3600000L));

            List<OOrderItem> items = loadUnitItems(unit, itemMap.getOrDefault(unit.getId(), List.of()));
            vo.setGoodsSummary(buildGoodsSummary(items));
            vo.setItemCount(items.size());
            vo.setTotalQuantity(items.stream().map(OOrderItem::getQuantity).filter(Objects::nonNull)
                    .mapToInt(Integer::intValue).sum());
            vo.setFirstImage(items.stream().map(OOrderItem::getGoodsImg)
                    .filter(StringUtils::hasText).findFirst().orElse(null));
            vo.setItems(items.stream().map(i -> {
                ShipWorkbenchItemVo iv = new ShipWorkbenchItemVo();
                iv.setId(i.getId());
                iv.setGoodsImg(i.getGoodsImg());
                iv.setGoodsTitle(i.getGoodsTitle());
                iv.setGoodsSpec(i.getGoodsSpec());
                iv.setSkuNum(i.getSkuNum());
                iv.setGoodsNum(i.getGoodsNum());
                iv.setQuantity(i.getQuantity());
                iv.setShipStatus(i.getShipStatus());
                iv.setWaybillCode(i.getWaybillCode());
                return iv;
            }).collect(Collectors.toList()));

            fillShipper(vo, items, accountMap.get(unit.getWaybillAccountId()));
            rows.add(vo);
        }
        return rows;
    }

    /**
     * 发货主体展示（设计文档 §0.2）：优先明细落库值；明细未分配时回落到账号绑定主体
     */
    private void fillShipper(ShipWorkbenchOrderVo vo, List<OOrderItem> items, ShopWaybillAccount account) {
        OOrderItem bound = items.stream()
                .filter(i -> i.getShipperType() != null || i.getShipType() != null || i.getShipperName() != null)
                .findFirst().orElse(null);
        if (bound != null) {
            vo.setShipperType(bound.getShipType());
            vo.setShipperId(bound.getShipperId());
            vo.setShipperName(bound.getShipperName());
            vo.setShipperNo(bound.getShipperNo());
            vo.setShipperTypeCode(bound.getShipperType());
        }
        if (account != null) {
            vo.setWaybillAccountName(account.getName());
            vo.setWaybillAccountCode(account.getCode());
            vo.setWaybillAccountCompany(account.getRefLogisticsName());
            if (vo.getShipperType() == null) {
                vo.setShipperType(account.getShipperType());
                vo.setShipperId(account.getShipperId());
            }
        }
        if (vo.getShipperType() != null) {
            vo.setShipperTypeName(EnumShipType.getName(vo.getShipperType()));
        }
    }

    /**
     * 批量查询面单账号：账号服务异常时降级为空（列表仍可展示账号ID与订单自身字段）
     */
    private Map<Long, ShopWaybillAccount> loadAccounts(Collection<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return Map.of();
        }
        List<Long> queryIds = ids.stream().limit(ACCOUNT_QUERY_LIMIT).collect(Collectors.toList());
        try {
            return shopWaybillAccountService.listByIds(queryIds).stream()
                    .filter(a -> a.getId() != null)
                    .collect(Collectors.toMap(ShopWaybillAccount::getId, a -> a, (a, b) -> a));
        } catch (Exception e) {
            log.warn("======打单发货队列查询面单账号异常======error={}", e.getMessage());
            return Map.of();
        }
    }

    // ==================== 面单账号可选项 ====================

    @Override
    public ResultVo<List<ShopWaybillAccount>> accountOptions(Long shopId, Integer shopType, Integer shipperType,
                                                             Long shipperId, Long merchantId) {
        if (shopId == null || shopType == null) {
            return ResultVo.error("缺少参数：shopId/shopType");
        }
        try {
            // 数据域收敛在 Controller 按登录身份完成（总部=不限、商户=本商户、店铺=本店），
            // 本方法与审单台 waybillAccountOptions 共用 listByShipper 单一口径
            List<ShopWaybillAccount> list = shopWaybillAccountService.listByShipper(
                    merchantId, shopId, shopType, shipperType, shipperId);
            return ResultVo.success(list);
        } catch (Exception e) {
            log.error("======查询面单账号异常======shopId={}，error={}", shopId, e.getMessage(), e);
            return ResultVo.error("查询面单账号失败：" + e.getMessage());
        }
    }

    // ==================== 分配 / 改派 ====================

    @Override
    public ResultVo<ShipWorkbenchActionResultVo> distribute(ShipWorkbenchDistributeBo bo, List<Long> merchantIds,
                                                            String username) {
        if (bo.getOrderIds() == null || bo.getOrderIds().isEmpty()) {
            return ResultVo.error("请先勾选订单");
        }
        if (bo.getWaybillAccountId() == null) {
            return ResultVo.error("请选择面单账号");
        }
        ShopWaybillAccount account = loadAccount(bo.getWaybillAccountId());
        if (account == null) {
            return ResultVo.error("面单账号不存在或无权访问");
        }
        ShipperSubject subject;
        try {
            subject = resolveSubject(account);
        } catch (IllegalArgumentException e) {
            return ResultVo.error(e.getMessage());
        }
        Date now = new Date();
        TransactionTemplate tx = perOrderTransaction();
        ShipWorkbenchActionResultVo result = new ShipWorkbenchActionResultVo();
        for (Long id : new LinkedHashSet<>(bo.getOrderIds())) {
            ShipWorkbenchActionResultVo.Item item = new ShipWorkbenchActionResultVo.Item();
            item.setId(id);
            try {
                String msg = tx.execute(status -> distributeOne(id, account, subject, merchantIds, username, now));
                if (msg == null) {
                    item.setSuccess(true);
                    result.setSuccessCount(result.getSuccessCount() + 1);
                } else {
                    item.setSuccess(false);
                    item.setMsg(msg);
                    result.setFailCount(result.getFailCount() + 1);
                }
                item.setOrderNum(msg == null ? null : orderNumOf(id));
            } catch (Exception e) {
                // 单单独立事务：系统异常只回滚当前单，其余单继续
                log.error("======打单发货分配异常======orderId={}，error={}", id, e.getMessage(), e);
                item.setSuccess(false);
                item.setMsg("系统异常：" + e.getMessage());
                result.setFailCount(result.getFailCount() + 1);
            }
            result.getItems().add(item);
        }
        log.info("======打单发货分配/改派======操作人={}，账号={}，选中={}单，成功={}单，失败={}单",
                username, bo.getWaybillAccountId(), bo.getOrderIds().size(),
                result.getSuccessCount(), result.getFailCount());
        return ResultVo.success(result);
    }

    /**
     * 单单分配：账号归属/主体校验 + 已取号守卫 + 条件更新（audit_status=1 AND ship_status=0 AND 面单未取号）
     * 落库口径与审单台 allocateUnit 完全一致（设计文档 §3.1：分配=选账号即确定主体+快递+网点）
     *
     * @return null=成功，否则为失败原因
     */
    private String distributeOne(Long id, ShopWaybillAccount account, ShipperSubject subject,
                                 List<Long> merchantIds, String username, Date now) {
        OOrder order = orderMapper.selectById(id);
        if (order == null) {
            return "订单不存在";
        }
        if (!hasScope(merchantIds, order.getMerchantId())) {
            return "无该订单操作权限";
        }
        String stateMsg = checkQueueState(order);
        if (stateMsg != null) {
            return stateMsg;
        }
        if (order.getWaybillStatus() != null
                && order.getWaybillStatus() != EnumWaybillStatus.NOT_TAKEN.getIndex()) {
            return "已取号/已打印，请先取消取号后再改派";
        }
        if (!Objects.equals(account.getShopId(), order.getShopId())
                || !Objects.equals(account.getShopType(), order.getShopType())) {
            return "面单账号不属于该店铺";
        }
        if (account.getMerchantId() != null && account.getMerchantId() > 0
                && !Objects.equals(account.getMerchantId(), order.getMerchantId())) {
            return "面单账号不属于该商户";
        }
        Integer updated = orderMapper.update(null, new LambdaUpdateWrapper<OOrder>()
                .eq(OOrder::getId, order.getId())
                .eq(OOrder::getAuditStatus, EnumAuditStatus.APPROVED.getIndex())
                .eq(OOrder::getShipStatus, EnumShipStatus.NOT.getIndex())
                .and(w -> w.isNull(OOrder::getWaybillStatus)
                        .or().eq(OOrder::getWaybillStatus, EnumWaybillStatus.NOT_TAKEN.getIndex()))
                .set(OOrder::getWaybillAccountId, account.getId())
                .set(OOrder::getUpdateTime, now)
                .set(OOrder::getUpdateBy, username));
        if (updated == null || updated == 0) {
            return "订单状态已变化，请刷新后重试";
        }
        orderItemMapper.update(null, new LambdaUpdateWrapper<OOrderItem>()
                .eq(OOrderItem::getOrderId, order.getId())
                .set(OOrderItem::getShipType, subject.shipType)
                .set(OOrderItem::getShipperId, subject.shipperId)
                .set(OOrderItem::getShipperType, subject.shipperTypeCode)
                .set(OOrderItem::getShipperName, subject.shipperName)
                .set(OOrderItem::getShipperNo, subject.shipperNo)
                .set(OOrderItem::getShipStatus, EnumShipStatus.BU_FEN.getIndex())
                .set(OOrderItem::getUpdateTime, now)
                .set(OOrderItem::getUpdateBy, username));
        return null;
    }

    /**
     * 解析账号绑定的发货主体（设计文档 §2.2 建账号即绑定主体）：
     * LOCAL→shipperId=0；供应商(300)→查 erp_supplier；云仓(100/110/200)→查 erp_warehouse
     */
    private ShipperSubject resolveSubject(ShopWaybillAccount account) {
        Integer shipperType = account.getShipperType();
        if (!isSupportedShipperType(shipperType)) {
            throw new IllegalArgumentException("面单账号未绑定有效发货主体");
        }
        if (shipperType == EnumShipType.LOCAL.getIndex()) {
            return new ShipperSubject(EnumShipType.LOCAL.getIndex(), 0L,
                    EnumShipType.LOCAL.toString(), "店铺自用", null);
        }
        Long shipperId = account.getShipperId();
        if (shipperId == null || shipperId <= 0) {
            throw new IllegalArgumentException("面单账号未绑定发货方");
        }
        if (shipperType == EnumShipType.SUPPLIER.getIndex()) {
            ErpSupplier supplier = supplierMapper.selectById(shipperId);
            if (supplier == null) {
                throw new IllegalArgumentException("发货供应商不存在");
            }
            return new ShipperSubject(EnumShipType.SUPPLIER.getIndex(), shipperId,
                    EnumShipType.SUPPLIER.toString(), supplier.getName(), supplier.getNumber());
        }
        ErpWarehouse warehouse = warehouseMapper.selectById(shipperId);
        if (warehouse == null) {
            throw new IllegalArgumentException("发货仓库不存在");
        }
        return new ShipperSubject(shipperType, shipperId, warehouse.getWarehouseType(),
                warehouse.getWarehouseName(), warehouse.getWarehouseNo());
    }

    private boolean isSupportedShipperType(Integer shipperType) {
        return shipperType != null && (shipperType == EnumShipType.LOCAL.getIndex()
                || shipperType == EnumShipType.JD_CLOUD_WAREHOUSE.getIndex()
                || shipperType == EnumShipType.JKY_CLOUD_WAREHOUSE.getIndex()
                || shipperType == EnumShipType.CLOUD_WAREHOUSE.getIndex()
                || shipperType == EnumShipType.SUPPLIER.getIndex());
    }

    // ==================== 整单退回异常池 ====================

    @Override
    public ResultVo<ShipWorkbenchActionResultVo> returnToException(ShipWorkbenchReturnBo bo, List<Long> merchantIds,
                                                                   String username) {
        if (bo.getOrderIds() == null || bo.getOrderIds().isEmpty()) {
            return ResultVo.error("请先勾选订单");
        }
        if (bo.getTagId() == null) {
            return ResultVo.error("请选择退回原因（异常分类标签）");
        }
        OOrderTag reasonTag = tagMapper.selectById(bo.getTagId());
        if (reasonTag == null) {
            return ResultVo.error("退回原因标签不存在");
        }
        if (reasonTag.getStatus() == null || reasonTag.getStatus() != EnumEnableStatus.ENABLED.getIndex()) {
            return ResultVo.error("退回原因标签已停用：" + reasonTag.getName());
        }
        if (reasonTag.getBindPool() == null || reasonTag.getBindPool() != EnumAuditStatus.EXCEPTION.getIndex()) {
            return ResultVo.error("所选标签不是异常池分类标签：" + reasonTag.getName());
        }
        // 异常池分类标签全集：覆盖写时移除旧分类，普通标签（bind_pool=0）保留（口径同阶段3转异常）
        Set<String> poolTagIdSet = tagMapper.selectList(new LambdaQueryWrapper<OOrderTag>()
                        .eq(OOrderTag::getBindPool, EnumAuditStatus.EXCEPTION.getIndex()))
                .stream().map(t -> String.valueOf(t.getId())).collect(Collectors.toSet());

        Date now = new Date();
        TransactionTemplate tx = perOrderTransaction();
        ShipWorkbenchActionResultVo result = new ShipWorkbenchActionResultVo();
        for (Long id : new LinkedHashSet<>(bo.getOrderIds())) {
            ShipWorkbenchActionResultVo.Item item = new ShipWorkbenchActionResultVo.Item();
            item.setId(id);
            try {
                // 已取号未打印：先取消平台单号并回未取号，再执行退回；取消失败阻止退回（设计文档 §五）
                String msg = cancelBeforeReturnIfTaken(id, merchantIds, null, username);
                if (msg == null) {
                    msg = tx.execute(status -> returnOne(id, reasonTag.getId(), poolTagIdSet, merchantIds, username, now));
                }
                if (msg == null) {
                    item.setSuccess(true);
                    result.setSuccessCount(result.getSuccessCount() + 1);
                } else {
                    item.setSuccess(false);
                    item.setMsg(msg);
                    result.setFailCount(result.getFailCount() + 1);
                }
                if (msg != null) {
                    item.setOrderNum(orderNumOf(id));
                }
            } catch (Exception e) {
                // 单单独立事务：系统异常只回滚当前单，其余单继续
                log.error("======打单发货退回异常======orderId={}，error={}", id, e.getMessage(), e);
                item.setSuccess(false);
                item.setMsg("系统异常：" + e.getMessage());
                result.setFailCount(result.getFailCount() + 1);
            }
            result.getItems().add(item);
        }
        log.info("======打单发货整单退回======操作人={}，原因标签={}，选中={}单，成功={}单，失败={}单",
                username, bo.getTagId(), bo.getOrderIds().size(), result.getSuccessCount(), result.getFailCount());
        return ResultVo.success(result);
    }

    /**
     * 退回前自动取消：仅已取号且未打印的订单触发；取消失败则阻止退回
     */
    private String cancelBeforeReturnIfTaken(Long id, List<Long> merchantIds, Long shopId, String username) {
        OOrder order = orderMapper.selectById(id);
        if (order == null || order.getWaybillStatus() == null
                || order.getWaybillStatus() != EnumWaybillStatus.TAKEN.getIndex()) {
            return null;
        }
        return cancelOne(id, merchantIds, shopId, username);
    }

    /**
     * 单单退回：audit_status 1→2 条件更新、清面单账号、清明细主体与 ship_status→0、覆盖写退回原因分类；
     * 已取号未打印由 cancelBeforeReturnIfTaken 先自动取消取号，已打印/已发货拒绝
     *
     * @return null=成功，否则为失败原因
     */
    private String returnOne(Long id, Long reasonTagId, Set<String> poolTagIdSet,
                             List<Long> merchantIds, String username, Date now) {
        OOrder order = orderMapper.selectById(id);
        if (order == null) {
            return "订单不存在";
        }
        if (!hasScope(merchantIds, order.getMerchantId())) {
            return "无该订单操作权限";
        }
        String stateMsg = checkQueueState(order);
        if (stateMsg != null) {
            return stateMsg;
        }
        Integer ws = order.getWaybillStatus();
        if (ws != null && ws == EnumWaybillStatus.TAKEN.getIndex()) {
            return "已取号，请先取消取号后再退回";
        }
        if (ws != null && (ws == EnumWaybillStatus.PRINTED.getIndex()
                || ws == EnumWaybillStatus.SHIPPED.getIndex()
                || ws == EnumWaybillStatus.MANUAL_SHIPPED.getIndex())) {
            return "已打印/已发货，不能退回";
        }
        Integer updated = orderMapper.update(null, new LambdaUpdateWrapper<OOrder>()
                .eq(OOrder::getId, order.getId())
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
        // 清发货主体与分配状态，回异常池重新决策（重分配 / 重拆），设计文档 §五①；
        // ship_type/shipper_id/ship_status 基线为 NOT NULL，按建表默认值回写，不可置 null
        orderItemMapper.update(null, new LambdaUpdateWrapper<OOrderItem>()
                .eq(OOrderItem::getOrderId, order.getId())
                .set(OOrderItem::getShipType, EnumShipType.LOCAL.getIndex())
                .set(OOrderItem::getShipperId, 0L)
                .set(OOrderItem::getShipperType, null)
                .set(OOrderItem::getShipperName, null)
                .set(OOrderItem::getShipperNo, null)
                .set(OOrderItem::getShipStatus, EnumShipStatus.NOT.getIndex())
                .set(OOrderItem::getUpdateTime, now)
                .set(OOrderItem::getUpdateBy, username));
        // 退回原因覆盖写：移除订单 tag 串中全部异常池分类ID，追加本次原因（复用阶段3转异常口径）
        LinkedHashSet<String> tagIds = parseTagIds(order.getTag());
        tagIds.removeAll(poolTagIdSet);
        tagIds.add(String.valueOf(reasonTagId));
        String joined = String.join(",", tagIds);
        if (!joined.equals(order.getTag() == null ? "" : order.getTag())) {
            orderMapper.update(null, new LambdaUpdateWrapper<OOrder>()
                    .eq(OOrder::getId, order.getId())
                    .set(OOrder::getTag, joined)
                    .set(OOrder::getUpdateTime, now));
        }
        return null;
    }

    // ==================== 取号 / 取消取号 ====================

    @Override
    public ResultVo<ShipWorkbenchActionResultVo> take(ShipWorkbenchTakeBo bo, List<Long> merchantIds, Long shopId,
                                                      String username) {
        if (bo.getOrderIds() == null || bo.getOrderIds().isEmpty()) {
            return ResultVo.error("请先勾选订单");
        }
        TransactionTemplate tx = perOrderTransaction();
        ShipWorkbenchActionResultVo result = new ShipWorkbenchActionResultVo();
        for (Long id : new LinkedHashSet<>(bo.getOrderIds())) {
            ShipWorkbenchActionResultVo.Item item = new ShipWorkbenchActionResultVo.Item();
            item.setId(id);
            try {
                String msg = takeOne(id, merchantIds, shopId, username, tx);
                if (msg == null) {
                    item.setSuccess(true);
                    result.setSuccessCount(result.getSuccessCount() + 1);
                } else {
                    item.setSuccess(false);
                    item.setMsg(msg);
                    result.setFailCount(result.getFailCount() + 1);
                    item.setOrderNum(orderNumOf(id));
                }
            } catch (Exception e) {
                log.error("======打单发货取号异常======orderId={}，error={}", id, e.getMessage(), e);
                item.setSuccess(false);
                item.setMsg("系统异常：" + e.getMessage());
                result.setFailCount(result.getFailCount() + 1);
            }
            result.getItems().add(item);
        }
        log.info("======打单发货取号======操作人={}，选中={}单，成功={}单，失败={}单",
                username, bo.getOrderIds().size(), result.getSuccessCount(), result.getFailCount());
        return ResultVo.success(result);
    }

    /**
     * 单号取号（设计文档 §4.7 取号时序）：
     * ① 队列状态/账号/主体逐项校验，任一不满足该单直接判失败不发平台请求
     * ② 平台适配器取号 ③ 本地落单独立事务 ④ 平台已成功、本地落库失败 → 尽力取消补偿
     *
     * @return null=成功，否则为失败原因
     */
    private String takeOne(Long id, List<Long> merchantIds, Long shopId, String username, TransactionTemplate tx) {
        OOrder order = orderMapper.selectById(id);
        if (order == null) {
            return "订单不存在";
        }
        String scopeMsg = checkUnitScope(merchantIds, shopId, order);
        if (scopeMsg != null) {
            return scopeMsg;
        }
        String stateMsg = checkQueueState(order);
        if (stateMsg != null) {
            return stateMsg;
        }
        Integer ws = order.getWaybillStatus();
        if (ws != null && ws != EnumWaybillStatus.NOT_TAKEN.getIndex()) {
            return "订单已取号/已打印/已发货，不能重复取号";
        }
        if (order.getWaybillAccountId() == null) {
            return "请先分配面单账号";
        }
        ShopWaybillAccount account = loadAccount(order.getWaybillAccountId());
        if (account == null) {
            return "面单账号不存在或无权访问";
        }
        String accountMsg = checkTakeAccount(order, account);
        if (accountMsg != null) {
            return accountMsg;
        }
        List<OOrderItem> unitItems = loadUnitItems(order);
        String subjectMsg = checkTakeSubject(unitItems, account);
        if (subjectMsg != null) {
            return subjectMsg;
        }

        WaybillTakeResultVo takeResult;
        try {
            takeResult = waybillAdapterRegistry.get(order.getShopType()).take(buildTakeBo(order, account, unitItems));
        } catch (Exception e) {
            log.error("======打单发货取号失败======orderId={}，error={}", id, e.getMessage(), e);
            return "取号失败：" + e.getMessage();
        }
        if (takeResult == null || !StringUtils.hasText(takeResult.getWaybillCode())) {
            return "平台未返回快递单号";
        }
        try {
            String txMsg = tx.execute(status -> saveTakeResult(order, unitItems, takeResult, username));
            if (txMsg != null) {
                // 平台已占号但本地落单失败：尽力回滚平台单号，避免产生无法追踪的运单（设计文档 §4.7⑤）
                compensateCancel(order, takeResult);
                return txMsg;
            }
            return null;
        } catch (Exception e) {
            log.error("======打单发货取号落库异常======orderId={}，error={}", id, e.getMessage(), e);
            compensateCancel(order, takeResult);
            return "保存取号结果失败：" + e.getMessage();
        }
    }

    /**
     * 取号账号守卫：账号归属店铺/平台/商户与订单一致（设计文档 §4.3 前置条件3）
     */
    private String checkTakeAccount(OOrder order, ShopWaybillAccount account) {
        if (!Objects.equals(account.getShopId(), order.getShopId())) {
            return "面单账号不属于该店铺";
        }
        if (account.getShopType() != null && !Objects.equals(account.getShopType(), order.getShopType())) {
            return "面单账号平台与订单不一致";
        }
        if (account.getMerchantId() != null && account.getMerchantId() > 0
                && !Objects.equals(account.getMerchantId(), order.getMerchantId())) {
            return "面单账号不属于该商户";
        }
        return null;
    }

    /**
     * 取号前核对账号绑定主体与订单已分配主体一致（设计文档 §3.2 守卫）
     */
    private String checkTakeSubject(List<OOrderItem> items, ShopWaybillAccount account) {
        if (items.isEmpty()) {
            return "订单没有可发货的商品明细";
        }
        Integer shipperType = account.getShipperType();
        if (shipperType == null) {
            return "面单账号未绑定发货主体";
        }
        for (OOrderItem item : items) {
            if (item.getShipType() == null) {
                return "请先分配发货主体";
            }
            if (!Objects.equals(item.getShipType(), shipperType)) {
                return "面单账号与已分配发货主体不一致";
            }
            if (shipperType != EnumShipType.LOCAL.getIndex()
                    && !Objects.equals(item.getShipperId(), account.getShipperId())) {
                return "面单账号与已分配发货主体不一致";
            }
        }
        return null;
    }

    /**
     * 组装统一取号契约 BO：收件人取订单行、发货人/快递/模板取账号、明细取本发货单元商品行
     */
    private WaybillTakeBo buildTakeBo(OOrder order, ShopWaybillAccount account, List<OOrderItem> unitItems) {
        WaybillTakeBo bo = new WaybillTakeBo();
        bo.setOrderId(Long.parseLong(order.getId()));
        bo.setOrderNum(order.getOrderNum());
        bo.setShopId(order.getShopId());
        bo.setShopType(order.getShopType());
        bo.setWaybillAccountId(account.getId());
        WaybillTakeBo.ShopWaybillAccountRef ref = new WaybillTakeBo.ShopWaybillAccountRef();
        ref.setId(account.getId());
        ref.setProviderCode(account.getProviderCode());
        ref.setRefLogisticsName(account.getRefLogisticsName());
        ref.setDeliverName(account.getDeliverName());
        ref.setDeliverMobile(account.getDeliverMobile());
        ref.setProvinceName(account.getProvinceName());
        ref.setCityName(account.getCityName());
        ref.setDistrictName(account.getCountryName());
        ref.setTownName(account.getCountrysideName());
        ref.setSenderDetail(account.getDetail());
        ref.setTemplateUrl(account.getTemplateUrl());
        bo.setWaybillAccount(ref);
        bo.setReceiverName(order.getReceiverName());
        bo.setReceiverMobile(order.getReceiverMobile());
        bo.setReceiverProvince(order.getProvince());
        bo.setReceiverCity(order.getCity());
        bo.setReceiverTown(order.getTown());
        bo.setReceiverDetail(order.getAddress());
        bo.setReceiverOpenId(order.getOpenAddressId());
        bo.setItems(unitItems.stream().map(i -> {
            WaybillTakeItemBo itemBo = new WaybillTakeItemBo();
            itemBo.setOrderItemId(i.getId() == null ? null : Long.parseLong(i.getId()));
            itemBo.setGoodsName(i.getGoodsTitle());
            itemBo.setSkuName(i.getGoodsSpec());
            itemBo.setSkuCode(i.getSkuNum());
            itemBo.setQuantity(i.getQuantity());
            return itemBo;
        }).collect(Collectors.toList()));
        return bo;
    }

    /**
     * 取号落单（设计文档 §1.6）：只写 o_order / o_order_item / o_order_ship_waybill，不生成备货单
     */
    private String saveTakeResult(OOrder order, List<OOrderItem> unitItems,
                                  WaybillTakeResultVo takeResult, String username) {
        Date now = new Date();
        Integer updated = orderMapper.update(null, new LambdaUpdateWrapper<OOrder>()
                .eq(OOrder::getId, order.getId())
                .eq(OOrder::getAuditStatus, EnumAuditStatus.APPROVED.getIndex())
                .eq(OOrder::getOrderStatus, EnumOOrderStatus.WAIT_SHIP.getIndex())
                .eq(OOrder::getShipStatus, EnumShipStatus.NOT.getIndex())
                .and(w -> w.isNull(OOrder::getWaybillStatus)
                        .or().eq(OOrder::getWaybillStatus, EnumWaybillStatus.NOT_TAKEN.getIndex()))
                .set(OOrder::getWaybillStatus, EnumWaybillStatus.TAKEN.getIndex())
                .set(OOrder::getWaybillCode, takeResult.getWaybillCode())
                .set(OOrder::getWaybillCompany, takeResult.getWaybillCompany())
                .set(OOrder::getShippingCompanyCode, takeResult.getLogisticsCode())
                .set(OOrder::getWaybillOrderId, takeResult.getWaybillOrderId())
                .set(OOrder::getUpdateTime, now)
                .set(OOrder::getUpdateBy, username));
        if (updated == null || updated == 0) {
            return "订单状态已变化，请刷新后重试";
        }
        List<String> itemIds = unitItems.stream().map(OOrderItem::getId)
                .filter(Objects::nonNull).collect(Collectors.toList());
        if (!itemIds.isEmpty()) {
            orderItemMapper.update(null, new LambdaUpdateWrapper<OOrderItem>()
                    .in(OOrderItem::getId, itemIds)
                    .set(OOrderItem::getWaybillCode, takeResult.getWaybillCode())
                    .set(OOrderItem::getWaybillCompany, takeResult.getWaybillCompany())
                    .set(OOrderItem::getShipStatus, EnumShipStatus.TAKEN.getIndex())
                    .set(OOrderItem::getUpdateTime, now)
                    .set(OOrderItem::getUpdateBy, username));
        }
        saveTakeRecord(order, takeResult, username);
        return null;
    }

    /**
     * 取号落单失败的补偿取消：尽力调 adapter.cancel，失败记告警日志不静默吞掉（设计文档 §4.7 补偿规则）
     */
    private void compensateCancel(OOrder order, WaybillTakeResultVo takeResult) {
        try {
            String msg = callCancel(order, takeResult.getWaybillCode(), takeResult.getLogisticsCode(),
                    takeResult.getWaybillOrderId(), order.getWaybillAccountId());
            if (msg == null) {
                log.info("======取号落单失败已补偿取消平台单号======orderId={}，waybillCode={}",
                        order.getId(), takeResult.getWaybillCode());
            } else {
                log.error("======取号落单失败补偿取消失败======orderId={}，waybillCode={}，msg={}",
                        order.getId(), takeResult.getWaybillCode(), msg);
            }
        } catch (Exception e) {
            log.error("======取号落单失败补偿取消异常======orderId={}，waybillCode={}，error={}",
                    order.getId(), takeResult.getWaybillCode(), e.getMessage(), e);
        }
    }

    @Override
    public ResultVo<ShipWorkbenchActionResultVo> cancel(ShipWorkbenchCancelBo bo, List<Long> merchantIds, Long shopId,
                                                        String username) {
        if (bo.getOrderIds() == null || bo.getOrderIds().isEmpty()) {
            return ResultVo.error("请先勾选订单");
        }
        ShipWorkbenchActionResultVo result = new ShipWorkbenchActionResultVo();
        for (Long id : new LinkedHashSet<>(bo.getOrderIds())) {
            ShipWorkbenchActionResultVo.Item item = new ShipWorkbenchActionResultVo.Item();
            item.setId(id);
            try {
                String msg = cancelOne(id, merchantIds, shopId, username);
                if (msg == null) {
                    item.setSuccess(true);
                    result.setSuccessCount(result.getSuccessCount() + 1);
                } else {
                    item.setSuccess(false);
                    item.setMsg(msg);
                    result.setFailCount(result.getFailCount() + 1);
                    item.setOrderNum(orderNumOf(id));
                }
            } catch (Exception e) {
                log.error("======打单发货取消取号异常======orderId={}，error={}", id, e.getMessage(), e);
                item.setSuccess(false);
                item.setMsg("系统异常：" + e.getMessage());
                result.setFailCount(result.getFailCount() + 1);
            }
            result.getItems().add(item);
        }
        log.info("======打单发货取消取号======操作人={}，选中={}单，成功={}单，失败={}单",
                username, bo.getOrderIds().size(), result.getSuccessCount(), result.getFailCount());
        return ResultVo.success(result);
    }

    /**
     * 单号取消取号（设计文档 §4.7 取消时序）：仅已取号未打印 → 平台取消 → 平台成功后本地回未取号；
     * 平台取消失败不做本地回退（避免"本地未取号、平台已占号"）
     *
     * @return null=成功，否则为失败原因
     */
    private String cancelOne(Long id, List<Long> merchantIds, Long shopId, String username) {
        OOrder order = orderMapper.selectById(id);
        if (order == null) {
            return "订单不存在";
        }
        String scopeMsg = checkUnitScope(merchantIds, shopId, order);
        if (scopeMsg != null) {
            return scopeMsg;
        }
        String stateMsg = checkQueueState(order);
        if (stateMsg != null) {
            return stateMsg;
        }
        Integer ws = order.getWaybillStatus();
        if (ws == null || ws == EnumWaybillStatus.NOT_TAKEN.getIndex()) {
            return "该订单未取号";
        }
        if (ws != EnumWaybillStatus.TAKEN.getIndex()) {
            return "已打印/已发货，不能取消取号";
        }
        OShipWaybill record = getTakenRecord(order);
        String waybillCode = record != null && StringUtils.hasText(record.getWaybillCode())
                ? record.getWaybillCode() : order.getWaybillCode();
        String logisticsCode = record != null && StringUtils.hasText(record.getLogisticsCode())
                ? record.getLogisticsCode() : order.getShippingCompanyCode();
        if (!StringUtils.hasText(logisticsCode)) {
            logisticsCode = order.getWaybillCompany();
        }
        if (!StringUtils.hasText(waybillCode) || !StringUtils.hasText(logisticsCode)) {
            return "缺少快递单号/快递公司编码，无法取消取号";
        }
        String waybillOrderId = record != null && StringUtils.hasText(record.getWaybillOrderId())
                ? record.getWaybillOrderId() : order.getWaybillOrderId();
        String platformMsg = callCancel(order, waybillCode, logisticsCode, waybillOrderId, order.getWaybillAccountId());
        if (platformMsg != null) {
            return platformMsg;
        }
        try {
            return perOrderTransaction().execute(status -> resetTakeResult(order, waybillCode, username));
        } catch (Exception e) {
            log.error("======打单发货取消取号本地保存异常======orderId={}，error={}", id, e.getMessage(), e);
            return "平台取消成功但本地保存失败：" + e.getMessage();
        }
    }

    /**
     * 平台取消调用统一出口：适配器契约失败即抛异常，转逐单失败原因
     *
     * @return null=平台取消成功，否则为失败原因
     */
    private String callCancel(OOrder order, String waybillCode, String logisticsCode,
                              String waybillOrderId, Long accountId) {
        WaybillCancelBo cancelBo = new WaybillCancelBo();
        cancelBo.setOrderId(Long.parseLong(order.getId()));
        cancelBo.setOrderNum(order.getOrderNum());
        cancelBo.setShopType(order.getShopType());
        cancelBo.setWaybillAccountId(accountId);
        cancelBo.setWaybillCode(waybillCode);
        cancelBo.setLogisticsCode(logisticsCode);
        cancelBo.setWaybillOrderId(waybillOrderId);
        try {
            waybillAdapterRegistry.get(order.getShopType()).cancel(cancelBo);
            return null;
        } catch (Exception e) {
            log.warn("======打单发货取消取号平台失败======orderId={}，error={}", order.getId(), e.getMessage());
            return "取消取号失败：" + e.getMessage();
        }
    }

    /**
     * 取消取号落单：清运单字段回未取号，明细回已分配；保留面单账号与发货主体（设计文档 §1.6 取消行）
     */
    private String resetTakeResult(OOrder order, String waybillCode, String username) {
        Date now = new Date();
        Integer updated = orderMapper.update(null, new LambdaUpdateWrapper<OOrder>()
                .eq(OOrder::getId, order.getId())
                .eq(OOrder::getWaybillStatus, EnumWaybillStatus.TAKEN.getIndex())
                .set(OOrder::getWaybillStatus, EnumWaybillStatus.NOT_TAKEN.getIndex())
                .set(OOrder::getWaybillCode, null)
                .set(OOrder::getWaybillCompany, null)
                .set(OOrder::getShippingCompanyCode, null)
                .set(OOrder::getWaybillOrderId, null)
                .set(OOrder::getUpdateTime, now)
                .set(OOrder::getUpdateBy, username));
        if (updated == null || updated == 0) {
            return "订单状态已变化，请刷新后重试";
        }
        List<String> itemIds = loadUnitItems(order).stream().map(OOrderItem::getId)
                .filter(Objects::nonNull).collect(Collectors.toList());
        if (!itemIds.isEmpty()) {
            orderItemMapper.update(null, new LambdaUpdateWrapper<OOrderItem>()
                    .in(OOrderItem::getId, itemIds)
                    .set(OOrderItem::getWaybillCode, null)
                    .set(OOrderItem::getWaybillCompany, null)
                    .set(OOrderItem::getShipStatus, EnumShipStatus.BU_FEN.getIndex())
                    .set(OOrderItem::getUpdateTime, now)
                    .set(OOrderItem::getUpdateBy, username));
        }
        deleteTakeRecord(order, waybillCode);
        return null;
    }

    // ==================== 平台能力 ====================

    @Override
    public ResultVo<PlatformWaybillCapability> capabilities(Integer shopType) {
        if (shopType == null) {
            return ResultVo.error("缺少参数：shopType");
        }
        // 单体直调注册表能力矩阵（设计文档 §4.4）：开源版未接入平台返回 supported=false 全 false，
        // 前端据此隐藏取号/取消/打印/发货按钮并引导手动发货兜底通道
        return ResultVo.success(waybillAdapterRegistry.capability(shopType));
    }

    // ==================== 打印 ====================

    @Override
    public ResultVo<ShipWorkbenchActionResultVo> print(ShipWorkbenchPrintBo bo, List<Long> merchantIds, Long shopId,
                                                       String username) {
        if (bo.getOrderIds() == null || bo.getOrderIds().isEmpty()) {
            return ResultVo.error("请先勾选订单");
        }
        TransactionTemplate tx = perOrderTransaction();
        ShipWorkbenchActionResultVo result = new ShipWorkbenchActionResultVo();
        for (Long id : new LinkedHashSet<>(bo.getOrderIds())) {
            ShipWorkbenchActionResultVo.Item item = new ShipWorkbenchActionResultVo.Item();
            item.setId(id);
            try {
                String msg = tx.execute(status -> printOne(id, merchantIds, shopId, username));
                if (msg == null) {
                    item.setSuccess(true);
                    result.setSuccessCount(result.getSuccessCount() + 1);
                } else {
                    item.setSuccess(false);
                    item.setMsg(msg);
                    result.setFailCount(result.getFailCount() + 1);
                    item.setOrderNum(orderNumOf(id));
                }
            } catch (Exception e) {
                log.error("======打单发货打印异常======orderId={}，error={}", id, e.getMessage(), e);
                item.setSuccess(false);
                item.setMsg("系统异常：" + e.getMessage());
                result.setFailCount(result.getFailCount() + 1);
            }
            result.getItems().add(item);
        }
        log.info("======打单发货打印======操作人={}，选中={}单，成功={}单，失败={}单",
                username, bo.getOrderIds().size(), result.getSuccessCount(), result.getFailCount());
        return ResultVo.success(result);
    }

    /**
     * 单单打印：校验已取号 → waybill_status 1→2；打印数据已在取号时存入 o_order_ship_waybill，
     * 物理打印由前端统一打印调度器 + 本地打印组件完成（设计文档 §4.5），与 erp-pro 现状一致：
     * 后端只推进状态，不与打印机/打印客户端交互
     */
    private String printOne(Long id, List<Long> merchantIds, Long shopId, String username) {
        OOrder order = orderMapper.selectById(id);
        if (order == null) {
            return "订单不存在";
        }
        String scopeMsg = checkUnitScope(merchantIds, shopId, order);
        if (scopeMsg != null) {
            return scopeMsg;
        }
        String stateMsg = checkQueueState(order);
        if (stateMsg != null) {
            return stateMsg;
        }
        Integer ws = order.getWaybillStatus();
        if (ws == null || ws != EnumWaybillStatus.TAKEN.getIndex()) {
            return "仅已取号订单可打印（当前状态：" + (ws == null ? "未取号" : EnumWaybillStatus.getName(ws)) + "）";
        }
        Date now = new Date();
        Integer updated = orderMapper.update(null, new LambdaUpdateWrapper<OOrder>()
                .eq(OOrder::getId, order.getId())
                .eq(OOrder::getWaybillStatus, EnumWaybillStatus.TAKEN.getIndex())
                .set(OOrder::getWaybillStatus, EnumWaybillStatus.PRINTED.getIndex())
                .set(OOrder::getUpdateTime, now)
                .set(OOrder::getUpdateBy, username));
        if (updated == null || updated == 0) {
            return "订单状态已变化，请刷新后重试";
        }
        updateRecordPrintStatus(order, username);
        return null;
    }

    // ==================== 发货（平台面单链路） ====================

    @Override
    public ResultVo<ShipWorkbenchActionResultVo> ship(ShipWorkbenchShipBo bo, List<Long> merchantIds, Long shopId,
                                                      String username) {
        if (bo.getOrderIds() == null || bo.getOrderIds().isEmpty()) {
            return ResultVo.error("请先勾选订单");
        }
        TransactionTemplate tx = perOrderTransaction();
        ShipWorkbenchActionResultVo result = new ShipWorkbenchActionResultVo();
        for (Long id : new LinkedHashSet<>(bo.getOrderIds())) {
            ShipWorkbenchActionResultVo.Item item = new ShipWorkbenchActionResultVo.Item();
            item.setId(id);
            try {
                String msg = shipOne(id, merchantIds, shopId, username, tx);
                if (msg == null) {
                    item.setSuccess(true);
                    result.setSuccessCount(result.getSuccessCount() + 1);
                } else {
                    item.setSuccess(false);
                    item.setMsg(msg);
                    result.setFailCount(result.getFailCount() + 1);
                    item.setOrderNum(orderNumOf(id));
                }
            } catch (Exception e) {
                log.error("======打单发货发货异常======orderId={}，error={}", id, e.getMessage(), e);
                item.setSuccess(false);
                item.setMsg("系统异常：" + e.getMessage());
                result.setFailCount(result.getFailCount() + 1);
            }
            result.getItems().add(item);
        }
        log.info("======打单发货发货======操作人={}，选中={}单，成功={}单，失败={}单",
                username, bo.getOrderIds().size(), result.getSuccessCount(), result.getFailCount());
        return ResultVo.success(result);
    }

    /**
     * 单单发货：校验已打印 + 单号/快递编码完整 → 平台回传（失败状态不变返回原因）→
     * 本地落库（waybill_status→3 等，含 order_status→已发货修正）→ 本地仓落备货单
     */
    private String shipOne(Long id, List<Long> merchantIds, Long shopId, String username, TransactionTemplate tx) {
        OOrder order = orderMapper.selectById(id);
        if (order == null) {
            return "订单不存在";
        }
        String scopeMsg = checkUnitScope(merchantIds, shopId, order);
        if (scopeMsg != null) {
            return scopeMsg;
        }
        String stateMsg = checkQueueState(order);
        if (stateMsg != null) {
            return stateMsg;
        }
        Integer ws = order.getWaybillStatus();
        if (ws == null || ws != EnumWaybillStatus.PRINTED.getIndex()) {
            return "仅已打印订单可发货（当前状态：" + (ws == null ? "未取号" : EnumWaybillStatus.getName(ws)) + "）";
        }
        if (!StringUtils.hasText(order.getWaybillCode()) || !StringUtils.hasText(order.getShippingCompanyCode())) {
            return "缺少快递单号或快递公司编码，无法发货";
        }
        StringBuilder platformResult = new StringBuilder();
        String platformMsg = callShip(order, order.getWaybillCode(), order.getShippingCompanyCode(),
                order.getWaybillAccountId(), platformResult);
        if (platformMsg != null) {
            return platformMsg;
        }
        try {
            return tx.execute(status -> saveShipResult(order, username, EnumWaybillStatus.SHIPPED,
                    order.getWaybillCode(), order.getWaybillCompany(), order.getShippingCompanyCode(),
                    EnumShipMode.ELECTRONIC, platformResult.toString()));
        } catch (Exception e) {
            log.error("======打单发货发货落库异常======orderId={}，error={}", id, e.getMessage(), e);
            return "发货落库失败：" + e.getMessage();
        }
    }

    /**
     * 平台发货回传调用统一出口：适配器契约失败即抛异常，转逐单失败原因（状态不变可重试）。
     * platformResult 非空时回填平台回执文案（取适配器 platformMsg，无值回落「发货成功」），
     * 供落库 platform_ship_result 使用；为 null 表示调用方不关心回执（如手动发货尽力而为场景）。
     *
     * @return null=平台回传成功，否则为失败原因
     */
    private String callShip(OOrder order, String waybillCode, String logisticsCode, Long accountId,
                            StringBuilder platformResult) {
        WaybillShipBo shipBo = new WaybillShipBo();
        shipBo.setOrderId(Long.parseLong(order.getId()));
        shipBo.setOrderNum(order.getOrderNum());
        shipBo.setShopId(order.getShopId());
        shipBo.setShopType(order.getShopType());
        shipBo.setWaybillAccountId(accountId);
        shipBo.setWaybillCode(waybillCode);
        shipBo.setLogisticsCode(logisticsCode);
        try {
            WaybillShipResultVo result = waybillAdapterRegistry.get(order.getShopType()).ship(shipBo);
            if (platformResult != null) {
                platformResult.append(result == null || !StringUtils.hasText(result.getPlatformMsg())
                        ? "发货成功" : result.getPlatformMsg());
            }
            return null;
        } catch (Exception e) {
            log.warn("======打单发货平台回传失败======orderId={}，error={}", order.getId(), e.getMessage());
            return "平台发货回传失败：" + e.getMessage();
        }
    }

    // ==================== 手动发货（兜底通道） ====================

    @Override
    public ResultVo<ShipWorkbenchActionResultVo> manualShip(ShipWorkbenchManualShipBo bo, List<Long> merchantIds,
                                                            Long shopId, String username) {
        if (bo.getOrderId() == null) {
            return ResultVo.error("缺少参数：orderId");
        }
        if (!StringUtils.hasText(bo.getTrackingNumber())) {
            return ResultVo.error("请填写快递单号");
        }
        if (bo.getLogisticsCompanyId() == null) {
            return ResultVo.error("请选择物流公司");
        }
        OLogisticsCompany company = logisticsCompanyMapper.selectById(bo.getLogisticsCompanyId());
        if (company == null) {
            return ResultVo.error("物流公司不存在");
        }
        TransactionTemplate tx = perOrderTransaction();
        ShipWorkbenchActionResultVo result = new ShipWorkbenchActionResultVo();
        ShipWorkbenchActionResultVo.Item item = new ShipWorkbenchActionResultVo.Item();
        item.setId(bo.getOrderId());
        try {
            String msg = manualShipOne(bo.getOrderId(), company, bo.getTrackingNumber(),
                    merchantIds, shopId, username, tx);
            if (msg == null) {
                item.setSuccess(true);
                result.setSuccessCount(1);
            } else {
                item.setSuccess(false);
                item.setMsg(msg);
                result.setFailCount(1);
                item.setOrderNum(orderNumOf(bo.getOrderId()));
            }
        } catch (Exception e) {
            log.error("======打单发货手动发货异常======orderId={}，error={}", bo.getOrderId(), e.getMessage(), e);
            item.setSuccess(false);
            item.setMsg("系统异常：" + e.getMessage());
            result.setFailCount(1);
        }
        result.getItems().add(item);
        log.info("======打单发货手动发货======操作人={}，orderId={}，成功={}单，失败={}单",
                username, bo.getOrderId(), result.getSuccessCount(), result.getFailCount());
        return ResultVo.success(result);
    }

    /**
     * 单手动发货（设计文档 §2.4 兜底通道）：不依赖面单适配器可用性——
     * 校验已放行/待发货/未发货/面单未到已发货终态，已取号或已打印必须先取消取号；
     * 平台回传按能力尽力而为（失败只记日志不阻断）；落库复用 saveShipResult，目标 waybill_status=10
     */
    private String manualShipOne(Long id, OLogisticsCompany company, String trackingNumber,
                                 List<Long> merchantIds, Long shopId, String username, TransactionTemplate tx) {
        OOrder order = orderMapper.selectById(id);
        if (order == null) {
            return "订单不存在";
        }
        String scopeMsg = checkUnitScope(merchantIds, shopId, order);
        if (scopeMsg != null) {
            return scopeMsg;
        }
        if (order.getAuditStatus() == null || order.getAuditStatus() != EnumAuditStatus.APPROVED.getIndex()) {
            return "仅已放行订单可手动发货";
        }
        if (order.getOrderStatus() == null || order.getOrderStatus() != EnumOOrderStatus.WAIT_SHIP.getIndex()) {
            return "订单当前状态不在待发货队列";
        }
        Integer ss = order.getShipStatus();
        if (ss != null && (ss == EnumShipStatus.BU_FEN.getIndex() || ss == EnumShipStatus.ALL.getIndex())) {
            return "订单已部分/全部发货，不能重复发货";
        }
        Integer ws = order.getWaybillStatus();
        if (ws != null && (ws == EnumWaybillStatus.SHIPPED.getIndex()
                || ws == EnumWaybillStatus.MANUAL_SHIPPED.getIndex())) {
            return "订单已发货，不能重复操作";
        }
        if (ws != null && (ws == EnumWaybillStatus.TAKEN.getIndex() || ws == EnumWaybillStatus.PRINTED.getIndex())) {
            return "已取号/已打印的订单请先取消取号后再手动发货";
        }
        // 平台回传尽力而为：平台已接入且声明支持发货回传才尝试，失败不阻断本地终态（设计文档 §2.4/§4.4）
        PlatformWaybillCapability capability = waybillAdapterRegistry.capability(order.getShopType());
        if (capability != null && Boolean.TRUE.equals(capability.getSupported())
                && Boolean.TRUE.equals(capability.getShip())) {
            String msg = callShip(order, trackingNumber, company.getCode(), order.getWaybillAccountId(), null);
            if (msg != null) {
                log.warn("======手动发货平台回传失败（不阻断）======orderId={}，msg={}", order.getId(), msg);
            } else {
                log.info("======手动发货平台回传成功======orderId={}，waybillCode={}", order.getId(), trackingNumber);
            }
        }
        try {
            return tx.execute(status -> saveShipResult(order, username, EnumWaybillStatus.MANUAL_SHIPPED,
                    trackingNumber, company.getName(), company.getCode(), EnumShipMode.MANUAL, "手动发货"));
        } catch (Exception e) {
            log.error("======打单发货手动发货落库异常======orderId={}，error={}", id, e.getMessage(), e);
            return "手动发货落库失败：" + e.getMessage();
        }
    }

    // ==================== 发货落库（面单发货 + 手动发货共用） ====================

    /**
     * 发货成功落库（设计文档 §4.7 发货 / §1.6 动作×表）：
     * 条件更新 o_order 状态 → 更新 o_order_item → 本地仓场景生成备货单。
     * <p>
     * 与 erp-pro 已知口径差异（修正）：erp-pro 平台面单链路发货成功只回写
     * ship_status/waybill_status，不推进 order_status（订单停留在待发货(1)，依赖后续仓库回写收敛）；
     * OMS 在发货成功定稿时同步推进 order_status→已发货(2)，与 OMS 审单工作台
     * 「已发货池=ship_status>0」及订单状态字典口径保持一致。
     */
    private String saveShipResult(OOrder order, String username, EnumWaybillStatus targetStatus,
                                  String waybillCode, String waybillCompany, String shippingCompanyCode,
                                  EnumShipMode shipMode, String platformResult) {
        Date now = new Date();
        Integer updated = orderMapper.update(null, new LambdaUpdateWrapper<OOrder>()
                .eq(OOrder::getId, order.getId())
                .eq(OOrder::getAuditStatus, EnumAuditStatus.APPROVED.getIndex())
                .eq(OOrder::getShipStatus, EnumShipStatus.NOT.getIndex())
                .set(OOrder::getWaybillStatus, targetStatus.getIndex())
                .set(OOrder::getShipStatus, EnumShipStatus.ALL.getIndex())
                .set(OOrder::getOrderStatus, EnumOOrderStatus.SHIPPED.getIndex())
                .set(OOrder::getShippingTime, now)
                .set(OOrder::getWaybillCode, waybillCode)
                .set(OOrder::getWaybillCompany, waybillCompany)
                .set(OOrder::getShippingCompanyCode, shippingCompanyCode)
                .set(OOrder::getPlatformShipStatus, EnumEnableStatus.ENABLED.getIndex())
                .set(OOrder::getPlatformShipResult, platformResult)
                .set(OOrder::getUpdateTime, now)
                .set(OOrder::getUpdateBy, username));
        if (updated == null || updated == 0) {
            return "订单状态已变化，请刷新后重试";
        }
        List<OOrderItem> unitItems = loadUnitItems(order);
        List<String> itemIds = unitItems.stream().map(OOrderItem::getId)
                .filter(Objects::nonNull).collect(Collectors.toList());
        if (!itemIds.isEmpty()) {
            orderItemMapper.update(null, new LambdaUpdateWrapper<OOrderItem>()
                    .in(OOrderItem::getId, itemIds)
                    .set(OOrderItem::getShipStatus, EnumShipStatus.ALL.getIndex())
                    .set(OOrderItem::getWaybillCode, waybillCode)
                    .set(OOrderItem::getWaybillCompany, waybillCompany)
                    .set(OOrderItem::getUpdateTime, now)
                    .set(OOrderItem::getUpdateBy, username));
        }
        // 本地仓场景生成备货单（供应商/云仓已在分配推单时落单，不再重复生成，设计文档 §6.2）
        if (isLocalWarehouse(unitItems)) {
            generateStockingOrder(order, unitItems, username, shipMode, waybillCode, waybillCompany,
                    shippingCompanyCode, targetStatus, now);
        }
        return null;
    }

    private boolean isLocalWarehouse(List<OOrderItem> items) {
        if (items == null || items.isEmpty()) {
            return false;
        }
        return items.stream().allMatch(i -> i.getShipType() != null
                && i.getShipType() == EnumShipType.LOCAL.getIndex());
    }

    /**
     * 发货成功后生成备货单（o_order_stocking + o_order_stocking_item）：
     * 「订单 → 仓库」对接中间表，仓库按备货单作业（设计文档 §6.1/§6.2）；
     * 明细插行同时写成本快照②（unit_cost=o_goods_sku.unit_cost 当时值，档案无值留空=成本③未维护）
     */
    private void generateStockingOrder(OOrder order, List<OOrderItem> unitItems, String username,
                                       EnumShipMode shipMode, String waybillCode, String waybillCompany,
                                       String shippingCompanyCode, EnumWaybillStatus waybillStatus, Date now) {
        OOrderStocking stocking = new OOrderStocking();
        stocking.setShopType(order.getShopType());
        stocking.setShopId(order.getShopId());
        stocking.setType(EnumShipType.LOCAL.getIndex());
        stocking.setShipperId(0L);
        stocking.setShipMode(shipMode.getIndex());
        stocking.setOOrderId(Long.parseLong(order.getId()));
        stocking.setOrderNum(order.getOrderNum());
        stocking.setOrderTime(order.getOrderTime());
        stocking.setSendStatus(EnumOrderStockingSendStatus.ALL.getIndex());
        stocking.setStockingStatus(EnumStockingStatus.WAIT.getIndex());
        stocking.setRemark(order.getRemark());
        stocking.setBuyerMemo(order.getBuyerMemo());
        stocking.setSellerMemo(order.getSellerMemo());
        stocking.setShippingTime(now);
        stocking.setShippingCompany(waybillCompany);
        stocking.setShippingCompanyCode(shippingCompanyCode);
        stocking.setShippingNumber(waybillCode);
        stocking.setWaybillCode(waybillCode);
        stocking.setWaybillCompany(waybillCompany);
        stocking.setWaybillStatus(waybillStatus.getIndex());
        // 备货单订单状态快照取发货终态（本实现发货即推进 order_status→2，与订单侧收敛一致）
        stocking.setOrderStatus(EnumOOrderStatus.SHIPPED.getIndex());
        stocking.setProvince(order.getProvince());
        stocking.setCity(order.getCity());
        stocking.setTown(order.getTown());
        stocking.setAddress(order.getAddress());
        stocking.setReceiverName(order.getReceiverName());
        stocking.setReceiverMobile(order.getReceiverMobile());
        stocking.setMerchantId(order.getMerchantId());
        stocking.setCreateTime(now);
        stocking.setCreateBy(username);
        orderStockingMapper.insert(stocking);

        // 成本快照②：批量查 o_goods_sku 单位成本，随插行落定（档案无值→两列留 null=成本③未维护）
        Map<Long, BigDecimal> skuUnitCosts = loadSkuUnitCosts(unitItems);

        for (OOrderItem item : unitItems) {
            OOrderStockingItem si = new OOrderStockingItem();
            si.setShipOrderId(stocking.getId());
            si.setOrderNum(item.getOrderNum());
            si.setSubOrderNum(item.getSubOrderNum());
            si.setOOrderId(Long.parseLong(order.getId()));
            si.setOOrderItemId(item.getId() != null ? Long.parseLong(item.getId()) : null);
            si.setSupplierId(stocking.getShipperId());
            si.setProductId(item.getProductId());
            // sku_id 列 NOT NULL：取平台 skuId，无值回退内部 goodsSkuId（口径对齐本地手动发货）
            si.setSkuId(StringUtils.hasText(item.getSkuId())
                    ? item.getSkuId()
                    : (item.getGoodsSkuId() != null ? item.getGoodsSkuId().toString() : ""));
            si.setGoodsId(item.getGoodsId());
            si.setGoodsSkuId(item.getGoodsSkuId());
            si.setGoodsName(item.getGoodsTitle());
            si.setGoodsImg(item.getGoodsImg());
            si.setGoodsNum(item.getGoodsNum());
            si.setSkuName(item.getGoodsSpec());
            si.setSkuCode(item.getSkuNum());
            si.setBarcode(item.getBarcode());
            si.setQuantity(item.getQuantity());
            BigDecimal unitCost = item.getGoodsSkuId() != null ? skuUnitCosts.get(item.getGoodsSkuId()) : null;
            if (unitCost != null && unitCost.signum() > 0 && item.getQuantity() != null) {
                si.setUnitCost(unitCost);
                si.setTotalCost(unitCost.multiply(BigDecimal.valueOf(item.getQuantity())));
            }
            si.setUnshippedQuantity(0);
            si.setSendStatus(EnumOrderStockingSendStatus.ALL.getIndex());
            si.setStockingStatus(EnumStockingStatus.WAIT.getIndex());
            si.setWaybillCode(waybillCode);
            si.setWaybillStatus(waybillStatus.getIndex());
            si.setMerchantId(order.getMerchantId());
            si.setCreateTime(now);
            si.setCreateBy(username);
            orderStockingItemMapper.insert(si);
        }
        log.info("======发货成功生成备货单======orderId={}，stockingId={}，明细={}条",
                order.getId(), stocking.getId(), unitItems.size());
    }

    /**
     * 成本快照②取数：按本发货单元的商品 skuId 批量查 o_goods_sku 单位成本，返回 id→unitCost
     */
    private Map<Long, BigDecimal> loadSkuUnitCosts(List<OOrderItem> unitItems) {
        Set<Long> skuIds = unitItems.stream()
                .map(OOrderItem::getGoodsSkuId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        if (skuIds.isEmpty()) {
            return Map.of();
        }
        Map<Long, BigDecimal> result = new HashMap<>(skuIds.size());
        for (OGoodsSku sku : goodsSkuMapper.selectBatchIds(skuIds)) {
            if (sku.getId() != null) {
                result.put(Long.valueOf(sku.getId()), sku.getUnitCost());
            }
        }
        return result;
    }

    // ==================== 打单记录（o_order_ship_waybill，本类私有服务） ====================

    /**
     * 取号落打单记录（status=1已取号）：print_data/template_url/goods_detail/sign/params
     * 全部来自平台取号回执（设计文档 §1.3 打印数据载体）
     */
    private void saveTakeRecord(OOrder order, WaybillTakeResultVo takeResult, String username) {
        OShipWaybill record = new OShipWaybill();
        record.setMerchantId(order.getMerchantId());
        record.setShopId(order.getShopId());
        record.setShopType(order.getShopType());
        record.setOrderId(order.getOrderNum());
        record.setShipOrderId(Long.parseLong(order.getId()));
        record.setWaybillCode(takeResult.getWaybillCode());
        record.setLogisticsCode(takeResult.getLogisticsCode());
        record.setWaybillOrderId(takeResult.getWaybillOrderId());
        record.setPrintData(takeResult.getPrintData());
        record.setSign(takeResult.getSign());
        record.setParams(takeResult.getParams());
        record.setTemplateUrl(takeResult.getTemplateUrl());
        record.setGoodsDetail(takeResult.getGoodsDetail());
        record.setStatus(EnumWaybillStatus.TAKEN.getIndex());
        record.setCreateTime(new Date());
        record.setCreateBy(username);
        record.setUpdateTime(new Date());
        record.setUpdateBy(username);
        shipWaybillMapper.insert(record);
    }

    /**
     * 定位本发货单元最近一条打单记录（取消取号/回传参数数据源）：
     * 关联列口径 order_id=平台订单号 + ship_order_id=发货单元id + shop_id 组合定位（设计文档 §1.3）
     */
    private OShipWaybill getTakenRecord(OOrder order) {
        List<OShipWaybill> list = shipWaybillMapper.selectList(new LambdaQueryWrapper<OShipWaybill>()
                .eq(OShipWaybill::getShipOrderId, Long.parseLong(order.getId()))
                .eq(OShipWaybill::getOrderId, order.getOrderNum())
                .eq(OShipWaybill::getShopId, order.getShopId())
                .orderByDesc(OShipWaybill::getId)
                .last("LIMIT 1"));
        return list.isEmpty() ? null : list.get(0);
    }

    /**
     * 取消取号删记录：只删本次这一行，历史行不动（设计文档 §4.7 取消时序③）
     */
    private void deleteTakeRecord(OOrder order, String waybillCode) {
        LambdaQueryWrapper<OShipWaybill> wrapper = new LambdaQueryWrapper<OShipWaybill>()
                .eq(OShipWaybill::getShipOrderId, Long.parseLong(order.getId()))
                .eq(OShipWaybill::getOrderId, order.getOrderNum())
                .eq(OShipWaybill::getShopId, order.getShopId());
        if (StringUtils.hasText(waybillCode)) {
            wrapper.eq(OShipWaybill::getWaybillCode, waybillCode);
        }
        shipWaybillMapper.delete(wrapper);
    }

    /**
     * 打印推进：本表 status 1→2（过程记录），状态权威仍是 o_order.waybill_status（设计文档 §1.3）
     */
    private void updateRecordPrintStatus(OOrder order, String username) {
        shipWaybillMapper.update(null, new LambdaUpdateWrapper<OShipWaybill>()
                .eq(OShipWaybill::getShipOrderId, Long.parseLong(order.getId()))
                .eq(OShipWaybill::getOrderId, order.getOrderNum())
                .eq(OShipWaybill::getShopId, order.getShopId())
                .eq(OShipWaybill::getStatus, EnumWaybillStatus.TAKEN.getIndex())
                .set(OShipWaybill::getStatus, EnumWaybillStatus.PRINTED.getIndex())
                .set(OShipWaybill::getUpdateTime, new Date())
                .set(OShipWaybill::getUpdateBy, username));
    }

    // ==================== 私有工具 ====================

    /**
     * 本发货单元的商品行：拆单子单取 item_role=1 履约行，未拆主单取 item_role=0 原始行；
     * 历史空值兜底全部（与审单工作台同口径）
     */
    private List<OOrderItem> loadUnitItems(OOrder order) {
        return loadUnitItems(order, orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                .eq(OOrderItem::getOrderId, order.getId())));
    }

    private List<OOrderItem> loadUnitItems(OOrder order, List<OOrderItem> all) {
        int itemRole = order.getOrderRole() != null && order.getOrderRole() == EnumOrderRole.CHILD.getIndex()
                ? EnumOrderRole.CHILD.getIndex() : EnumOrderRole.MASTER.getIndex();
        List<OOrderItem> unit = all.stream()
                .filter(i -> i.getItemRole() != null && i.getItemRole() == itemRole)
                .collect(Collectors.toList());
        return unit.isEmpty() ? all : unit;
    }

    /**
     * 单单独立事务：批量操作部分失败时，已成功单正常提交（设计文档 §4.7 并发规则·批量事务边界）
     */
    private TransactionTemplate perOrderTransaction() {
        TransactionTemplate template = new TransactionTemplate(transactionManager);
        template.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
        return template;
    }

    /**
     * 队列单元公共状态校验（设计文档 §4.2/§4.3）
     *
     * @return null=可操作，否则为失败原因
     */
    private String checkQueueState(OOrder order) {
        if (order.getAuditStatus() == null || order.getAuditStatus() != EnumAuditStatus.APPROVED.getIndex()) {
            return "仅已放行订单可操作";
        }
        if (order.getOrderStatus() != null
                && (order.getOrderStatus() == EnumOOrderStatus.CANCEL.getIndex()
                || order.getOrderStatus() == EnumOOrderStatus.DELETED.getIndex())) {
            return "订单已取消/作废";
        }
        if (order.getOrderStatus() == null || order.getOrderStatus() != EnumOOrderStatus.WAIT_SHIP.getIndex()) {
            return "订单当前状态不在待发货队列";
        }
        Integer ss = order.getShipStatus();
        if (ss != null && ss == EnumShipStatus.BU_FEN.getIndex()) {
            return "订单已部分发货，不能操作";
        }
        if (ss != null && ss == EnumShipStatus.ALL.getIndex()) {
            return "订单已全部发货，不能操作";
        }
        if (order.getOrderRole() != null && order.getOrderRole() == EnumOrderRole.MERGE_CHILD.getIndex()) {
            return "合并发货子订单不支持该操作";
        }
        return null;
    }

    /**
     * 失败明细回填平台订单号（查询失败静默返回 null，不影响主流程）
     */
    private String orderNumOf(Long id) {
        try {
            OOrder order = orderMapper.selectById(id);
            return order == null ? null : order.getOrderNum();
        } catch (Exception e) {
            return null;
        }
    }

    private ShopWaybillAccount loadAccount(Long accountId) {
        try {
            return shopWaybillAccountService.listByIds(List.of(accountId)).stream()
                    .filter(a -> Objects.equals(a.getId(), accountId)).findFirst().orElse(null);
        } catch (Exception e) {
            log.warn("======查询面单账号异常======accountId={}，error={}", accountId, e.getMessage());
            return null;
        }
    }

    private boolean hasScope(List<Long> merchantIds, Long merchantId) {
        if (merchantIds == null || merchantIds.isEmpty()) {
            return true;
        }
        return merchantId != null && merchantIds.contains(merchantId);
    }

    /**
     * 发货单元操作范围：商户端限本商户，店铺端限本店（设计文档 §七 店铺可发起取号）
     *
     * @return null=有权限，否则为失败原因
     */
    private String checkUnitScope(List<Long> merchantIds, Long shopId, OOrder order) {
        if (!hasScope(merchantIds, order.getMerchantId())
                || (shopId != null && !Objects.equals(shopId, order.getShopId()))) {
            return "无该订单操作权限";
        }
        return null;
    }

    private List<String> parseOrderNums(String value) {
        if (!StringUtils.hasText(value)) {
            return List.of();
        }
        return Arrays.stream(value.split("[,，;；\\s]+"))
                .map(String::trim).filter(s -> !s.isEmpty()).distinct().limit(50)
                .collect(Collectors.toList());
    }

    private List<Long> parseLongList(String value) {
        if (!StringUtils.hasText(value)) {
            return List.of();
        }
        List<Long> result = new ArrayList<>();
        for (String s : value.split("[,，;；\\s]+")) {
            String t = s.trim();
            if (t.matches("\\d+")) {
                result.add(Long.parseLong(t));
            }
        }
        return result;
    }

    /** 解析订单标签串（逗号分隔ID）为保序去重集合，过滤非法片段（与工作台同规则） */
    private LinkedHashSet<String> parseTagIds(String tag) {
        LinkedHashSet<String> result = new LinkedHashSet<>();
        if (!StringUtils.hasText(tag)) {
            return result;
        }
        for (String s : tag.split(",")) {
            String t = s.trim();
            if (t.matches("\\d+")) {
                result.add(t);
            }
        }
        return result;
    }

    /** 商品摘要：前两种「标题(规格编码/商品编码)×数量」，超出加「等N种」 */
    private String buildGoodsSummary(List<OOrderItem> items) {
        if (items == null || items.isEmpty()) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < items.size(); i++) {
            OOrderItem item = items.get(i);
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
        return sb.toString();
    }

    private int nz(Integer value) {
        return value == null ? 0 : value;
    }

    /**
     * 解析后的发货主体快照（分配时落 o_order_item 主体字段）
     */
    private static class ShipperSubject {
        private final Integer shipType;
        private final Long shipperId;
        private final String shipperTypeCode;
        private final String shipperName;
        private final String shipperNo;

        private ShipperSubject(Integer shipType, Long shipperId, String shipperTypeCode,
                               String shipperName, String shipperNo) {
            this.shipType = shipType;
            this.shipperId = shipperId;
            this.shipperTypeCode = shipperTypeCode;
            this.shipperName = shipperName;
            this.shipperNo = shipperNo;
        }
    }
}
