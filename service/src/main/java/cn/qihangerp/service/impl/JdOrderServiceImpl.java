package cn.qihangerp.service.impl;

import cn.qihangerp.model.entity.JdGoodsSku;
import cn.qihangerp.model.entity.JdOrder;
import cn.qihangerp.model.entity.JdOrderCoupon;
import cn.qihangerp.model.entity.OOrder;
import cn.qihangerp.model.entity.OOrderItem;
import cn.qihangerp.mapper.JdGoodsSkuMapper;
import cn.qihangerp.service.JdOrderService;
import cn.qihangerp.service.OrderAuditInitService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.common.ResultVoEnum;
import cn.qihangerp.enums.EnumOOrderStatus;
import cn.qihangerp.enums.EnumShipStatus;
import cn.qihangerp.enums.EnumShopType;
import cn.qihangerp.enums.EnumWaybillStatus;
import cn.qihangerp.enums.JdOrderStateEnum;
import cn.qihangerp.model.entity.JdOrderItem;
import cn.qihangerp.model.bo.JdOrderBo;
import cn.qihangerp.mapper.JdOrderCouponMapper;
import cn.qihangerp.mapper.JdOrderItemMapper;
import cn.qihangerp.mapper.JdOrderMapper;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
* @author qilip
* @description 针对表【jd_order(京东订单表)】的数据库操作Service实现
* @createDate 2024-03-09 11:29:59
*/
@AllArgsConstructor
@Service
public class JdOrderServiceImpl extends ServiceImpl<JdOrderMapper, JdOrder>
    implements JdOrderService {
    private final JdOrderMapper mapper;
    private final JdOrderItemMapper itemMapper;
    private final JdOrderCouponMapper couponMapper;
    private final JdGoodsSkuMapper goodsSkuMapper;
    private final OrderAuditInitService orderAuditInitService;
    private final String DATE_PATTERN =
            "^(?:(?:(?:\\d{4}-(?:0?[1-9]|1[0-2])-(?:0?[1-9]|1\\d|2[0-8]))|(?:(?:(?:\\d{2}(?:0[48]|[2468][048]|[13579][26])|(?:(?:0[48]|[2468][048]|[13579][26])00))-0?2-29))$)|(?:(?:(?:\\d{4}-(?:0?[13578]|1[02]))-(?:0?[1-9]|[12]\\d|30))$)|(?:(?:(?:\\d{4}-0?[13-9]|1[0-2])-(?:0?[1-9]|[1-2]\\d|30))$)|(?:(?:(?:\\d{2}(?:0[48]|[13579][26]|[2468][048])|(?:(?:0[48]|[13579][26]|[2468][048])00))-0?2-29))$)$";
    private final Pattern DATE_FORMAT = Pattern.compile(DATE_PATTERN);

    @Override
    public PageResult<JdOrder> queryPageList(JdOrderBo bo, PageQuery pageQuery) {
        if(org.springframework.util.StringUtils.hasText(bo.getStartTime())){
            Matcher matcher = DATE_FORMAT.matcher(bo.getStartTime());
            boolean b = matcher.find();
            if(b){
                bo.setStartTime(bo.getStartTime()+" 00:00:00");
            }
        }
        if(org.springframework.util.StringUtils.hasText(bo.getEndTime())){
            Matcher matcher = DATE_FORMAT.matcher(bo.getEndTime());
            boolean b = matcher.find();
            if(b){
                bo.setEndTime(bo.getEndTime()+" 23:59:59");
            }
        }

        LambdaQueryWrapper<JdOrder> queryWrapper = new LambdaQueryWrapper<JdOrder>()
                .eq(bo.getShopId()!=null,JdOrder::getShopId,bo.getShopId())
                .eq(StringUtils.hasText(bo.getOrderId()),JdOrder::getOrderId,bo.getOrderId())
                .eq(StringUtils.hasText(bo.getOrderState()),JdOrder::getOrderState,bo.getOrderState())
                .ge(org.springframework.util.StringUtils.hasText(bo.getStartTime()),JdOrder::getOrderStartTime,bo.getStartTime())
                .le(org.springframework.util.StringUtils.hasText(bo.getEndTime()),JdOrder::getOrderStartTime,bo.getEndTime())
                ;

        pageQuery.setOrderByColumn("order_start_time");
        pageQuery.setIsAsc("desc");
        Page<JdOrder> taoGoodsPage = mapper.selectPage(pageQuery.build(), queryWrapper);
        if(taoGoodsPage.getRecords()!=null){
            for (JdOrder order:taoGoodsPage.getRecords()) {
                order.setItems(itemMapper.selectList(new LambdaQueryWrapper<JdOrderItem>().eq(JdOrderItem::getOrderId,order.getId())));
            }
        }
        return PageResult.build(taoGoodsPage);
    }

    @Transactional
    @Override
    public ResultVo<Integer> saveOrder(Long shopId, JdOrder order) {
        try {
            List<JdOrder> jdOrders = mapper.selectList(new LambdaQueryWrapper<JdOrder>().eq(JdOrder::getOrderId, order.getOrderId()));
            if (jdOrders != null && jdOrders.size() > 0) {
                // 存在，修改
                JdOrder update = new JdOrder();
                update.setId(jdOrders.get(0).getId());
                update.setOrderState(order.getOrderState());
                update.setOrderStateRemark(order.getOrderStateRemark());
                update.setInvoiceCode(order.getInvoiceCode());
                update.setOrderEndTime(order.getOrderEndTime());
                update.setModified(order.getModified());
                update.setVenderRemark(order.getVenderRemark());
                update.setReturnOrder(order.getReturnOrder());
                update.setPaymentConfirmTime(order.getPaymentConfirmTime());
                update.setWaybill(order.getWaybill());
                update.setLogisticsId(order.getLogisticsId());
                update.setOrderTotalPrice(order.getOrderTotalPrice());
                update.setOrderSellerPrice(order.getOrderSellerPrice());
                update.setOrderPayment(order.getOrderPayment());
                update.setFreightPrice(order.getFreightPrice());
                update.setSellerDiscount(order.getSellerDiscount());
              
                mapper.updateById(update);
                // 删除item
                itemMapper.delete(new LambdaQueryWrapper<JdOrderItem>().eq(JdOrderItem::getOrderId,jdOrders.get(0).getId()));

                // 添加item
                for (JdOrderItem item : order.getItems()) {
                    List<JdGoodsSku> pddGoodsSku = goodsSkuMapper.selectList(new LambdaQueryWrapper<JdGoodsSku>().eq(JdGoodsSku::getSkuId, item.getSkuId()));
                    if (pddGoodsSku != null && !pddGoodsSku.isEmpty()) {
                        item.setErpGoodsId(pddGoodsSku.get(0).getErpGoodsId().toString());
                        item.setErpGoodsSkuId(pddGoodsSku.get(0).getErpGoodsSkuId());
                    }
                    item.setOrderId(jdOrders.get(0).getId());
                    itemMapper.insert(item);
                }
                // 更新item
//                for (var item : order.getItems()) {
//                    List<JdOrderItem> taoOrderItems = itemMapper.selectList(
//                            new LambdaQueryWrapper<JdOrderItem>().eq(JdOrderItem::getSkuId, item.getSkuId()).eq(JdOrderItem::getOrderId,jdOrders.get(0).getId())
//                    );
//                    if (taoOrderItems != null && taoOrderItems.size() > 0) {
//                        // 不处理
//                    } else {
//                        // 新增
//                        item.setOrderId(update.getId());
//                        itemMapper.insert(item);
//                    }
//                }
                // 删除优惠信息
                couponMapper.delete(new LambdaQueryWrapper<JdOrderCoupon>().eq(JdOrderCoupon::getOrderId,jdOrders.get(0).getOrderId()));

                // 添加优惠信息
                if(order.getCoupons()!= null){
                    for (JdOrderCoupon coupon:order.getCoupons()) {
                        if(coupon.getOrderId()==null){
                            coupon.setOrderId(Long.parseLong(jdOrders.get(0).getOrderId()));
                        }
                        couponMapper.insert(coupon);
                    }
                }
                // 补转：阶段2之前拉取的历史单（jd_order 无 audit_status，幂等键 sourceOrderId 判重），重拉时同步转入
                List<JdOrderItem> latestItems = itemMapper.selectList(
                        new LambdaQueryWrapper<JdOrderItem>().eq(JdOrderItem::getOrderId, jdOrders.get(0).getId()));
                transferToOOrder(jdOrders.get(0), latestItems);
                return ResultVo.error(ResultVoEnum.DataExist, "订单已经存在，更新成功");
            } else {
                // 不存在，新增

                order.setShopId(shopId);
                order.setCreateTime(new Date());
                mapper.insert(order);
                // 添加item
                for (JdOrderItem item : order.getItems()) {
                    List<JdGoodsSku> pddGoodsSku = goodsSkuMapper.selectList(new LambdaQueryWrapper<JdGoodsSku>().eq(JdGoodsSku::getSkuId, item.getSkuId()));
                    if (pddGoodsSku != null && !pddGoodsSku.isEmpty()) {
                        item.setErpGoodsId(pddGoodsSku.get(0).getErpGoodsId().toString());
                        item.setErpGoodsSkuId(pddGoodsSku.get(0).getErpGoodsSkuId());
                    }
                    item.setOrderId(order.getId());
                    itemMapper.insert(item);
                }

                // 添加优惠信息
                if(order.getCoupons()!= null){
                    for (JdOrderCoupon coupon:order.getCoupons()) {
                        if(coupon.getOrderId()==null){
                            coupon.setOrderId(Long.parseLong(order.getOrderId()));
                        }
                        couponMapper.insert(coupon);
                    }
                }
                // 拉单落库直接转单：不依赖MQ（开源版无消费端实现），同步生成 o_order + o_order_item
                transferToOOrder(order, order.getItems());
                return ResultVo.success();
            }
        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            e.printStackTrace();
            return ResultVo.error(ResultVoEnum.SystemException, "系统异常：" + e.getMessage());
        }
    }

    @Override
    public JdOrder queryDetailByOrderId(Long orderId) {
        LambdaQueryWrapper<JdOrder> queryWrapper = new LambdaQueryWrapper<JdOrder>().eq(JdOrder::getOrderId,orderId);
        List<JdOrder> jdOrders = mapper.selectList(queryWrapper);
        if(jdOrders.isEmpty()) return null;
        else{
            jdOrders.get(0).setItems(itemMapper.selectList(new LambdaQueryWrapper<JdOrderItem>().eq(JdOrderItem::getOrderId,jdOrders.get(0).getId())));
            return jdOrders.get(0);
        }
    }

    /** 已取消(映射11)状态的平台单不转入 o_order */
    private boolean canAutoTransfer(JdOrder jdOrder) {
        if (!StringUtils.hasText(jdOrder.getOrderState())) return true;
        return JdOrderStateEnum.getIndex(jdOrder.getOrderState()) != EnumOOrderStatus.CANCEL.getIndex();
    }

    /**
     * 拉单落库幂等转单（jd_order 无 audit_status，判重完全依赖共用组件的
     * sourceOrderId+shopType 幂等键）；取消/已删除明细的场景直接跳过。
     */
    private void transferToOOrder(JdOrder jdOrder, List<JdOrderItem> jdOrderItems) {
        if (jdOrder == null || jdOrderItems == null || jdOrderItems.isEmpty()) return;
        if (!canAutoTransfer(jdOrder)) return;
        OOrder order = buildOOrder(jdOrder);
        List<OOrderItem> oItems = buildOOrderItems(jdOrder, jdOrderItems);
        orderAuditInitService.syncToOOrder(order, oItems);
    }

    private OOrder buildOOrder(JdOrder jdOrder) {
        OOrder order = new OOrder();
        order.setSourceOrderId(jdOrder.getId());
        order.setOrderNum(jdOrder.getOrderId());
        order.setShopType(EnumShopType.JD.getIndex());
        order.setShopId(jdOrder.getShopId());
        order.setBuyerMemo(jdOrder.getOrderRemark());
        order.setSellerMemo(jdOrder.getVenderRemark());
        order.setOrderStatus(EnumOOrderStatus.WAIT_SHIP.getIndex());
        order.setPlatformStatusCode(jdOrder.getOrderState());
        order.setPlatformStatusDesc(jdStateName(jdOrder.getOrderState()));
        double total = parseAmount(jdOrder.getOrderTotalPrice());
        order.setAmount(total);
        order.setGoodsAmount(parseAmount(jdOrder.getOrderSellerPrice())>0?parseAmount(jdOrder.getOrderSellerPrice()):total);
        order.setPostFee(parseAmount(jdOrder.getFreightPrice()));
        order.setSellerDiscount(parseAmount(jdOrder.getSellerDiscount()));
        order.setPlatformDiscount(0.0);
        order.setPayment(parseAmount(jdOrder.getOrderPayment())>0?parseAmount(jdOrder.getOrderPayment()):total);
        // 自动转单：收件人取平台单字段（京东加密场景可能为掩码值，放行前由人工补全）
        order.setReceiverName(jdOrder.getFullname());
        order.setReceiverMobile(StringUtils.hasText(jdOrder.getMobile())?jdOrder.getMobile():jdOrder.getTelephone());
        order.setAddress(jdOrder.getFullAddress());
        order.setProvince(jdOrder.getProvince());
        order.setCity(jdOrder.getCity());
        order.setTown(jdOrder.getTown());
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            order.setOrderTime(LocalDateTime.parse(jdOrder.getOrderStartTime(), formatter));
        }catch (Exception e){}
        order.setShipStatus(EnumShipStatus.NOT.getIndex());
        order.setWaybillStatus(EnumWaybillStatus.NOT_TAKEN.getIndex());
        order.setCreateTime(new Date());
        order.setCreateBy("拉单自动转单");
        return order;
    }

    private List<OOrderItem> buildOOrderItems(JdOrder jdOrder, List<JdOrderItem> jdOrderItems) {
        List<OOrderItem> oItems = new ArrayList<>();
        for (JdOrderItem item : jdOrderItems) {
            OOrderItem oOrderItem = new OOrderItem();
            oOrderItem.setOrderNum(jdOrder.getOrderId());
            oOrderItem.setSubOrderNum(jdOrder.getOrderId()+"-"+item.getSkuId());
            oOrderItem.setShopType(EnumShopType.JD.getIndex());
            oOrderItem.setShopId(jdOrder.getShopId());
            oOrderItem.setSkuId(item.getSkuId());
            oOrderItem.setGoodsId(StringUtils.hasText(item.getWareId())?parseLongSafe(item.getWareId()):0L);
            oOrderItem.setGoodsSkuId(item.getErpGoodsSkuId()!=null?item.getErpGoodsSkuId():
                    (StringUtils.hasText(item.getErpGoodsId())?parseLongSafe(item.getErpGoodsId()):0L));
            oOrderItem.setGoodsTitle(item.getSkuName());
            oOrderItem.setGoodsNum(item.getOuterSkuId());
            oOrderItem.setSkuNum(item.getOuterSkuId());
            double price = parseAmount(item.getJdPrice());
            int quantity = (int) parseAmount(item.getItemTotal());
            oOrderItem.setGoodsPrice(price);
            oOrderItem.setQuantity(quantity);
            oOrderItem.setItemAmount(price*quantity);
            oOrderItem.setDiscountAmount(0.0);
            oOrderItem.setPayment(price*quantity);
            oOrderItem.setRefundCount(0);
            oOrderItem.setRefundStatus(1);
            oOrderItem.setShipStatus(EnumShipStatus.NOT.getIndex());
            oOrderItem.setCreateTime(new Date());
            oOrderItem.setCreateBy("拉单自动转单");
            oItems.add(oOrderItem);
        }
        return oItems;
    }

    /** 平台状态编码 -> 中文描述 */
    private String jdStateName(String code) {
        if (!StringUtils.hasText(code)) return null;
        for (JdOrderStateEnum c : JdOrderStateEnum.values()) {
            if (c.getCode().equals(code)) return c.getName();
        }
        return null;
    }

    /** 京东金额字符串（元）转 double，异常/空回退0 */
    private double parseAmount(String value) {
        if (!StringUtils.hasText(value)) return 0.0;
        try { return Double.parseDouble(value.trim()); } catch (Exception e) { return 0.0; }
    }

    private long parseLongSafe(String value) {
        try { return Long.parseLong(value.trim()); } catch (Exception e) { return 0L; }
    }
}




