package cn.qihangerp.service.impl;

import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.common.ResultVoEnum;
import cn.qihangerp.enums.EnumAuditStatus;
import cn.qihangerp.enums.EnumOOrderStatus;
import cn.qihangerp.enums.EnumOrderRefundStatus;
import cn.qihangerp.enums.EnumShipStatus;
import cn.qihangerp.enums.EnumWaybillStatus;
import cn.qihangerp.enums.EnumShopOrderStatus;
import cn.qihangerp.enums.EnumShopType;
import cn.qihangerp.enums.PddOrderConfirmStatusEnum;
import cn.qihangerp.mapper.ErpOrderItemMapper;
import cn.qihangerp.mapper.ErpOrderMapper;
import cn.qihangerp.model.entity.OOrder;
import cn.qihangerp.model.entity.OOrderItem;
import cn.qihangerp.model.entity.PddGoodsSku;
import cn.qihangerp.model.entity.PddOrder;
import cn.qihangerp.model.entity.PddOrderItem;
import cn.qihangerp.model.bo.PddOrderBo;
import cn.qihangerp.model.bo.PddOrderConfirmBo;
import cn.qihangerp.mapper.PddGoodsSkuMapper;
import cn.qihangerp.mapper.PddOrderItemMapper;
import cn.qihangerp.mapper.PddOrderMapper;
import cn.qihangerp.service.OrderAuditInitService;
import cn.qihangerp.service.PddOrderService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.AllArgsConstructor;
import lombok.extern.java.Log;
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
* @author TW
* @description 针对表【pdd_order(拼多多订单表)】的数据库操作Service实现
* @createDate 2024-06-05 10:58:43
*/
@Log
@AllArgsConstructor
@Service
public class PddOrderServiceImpl extends ServiceImpl<PddOrderMapper, PddOrder>
    implements PddOrderService {
    private final PddOrderMapper mapper;
    private final PddOrderItemMapper itemMapper;
    private final PddGoodsSkuMapper goodsSkuMapper;
    private final ErpOrderMapper erpOrderMapper;
    private final ErpOrderItemMapper erpOrderItemMapper;
    private final OrderAuditInitService orderAuditInitService;

    private final String DATE_PATTERN =
            "^(?:(?:(?:\\d{4}-(?:0?[1-9]|1[0-2])-(?:0?[1-9]|1\\d|2[0-8]))|(?:(?:(?:\\d{2}(?:0[48]|[2468][048]|[13579][26])|(?:(?:0[48]|[2468][048]|[13579][26])00))-0?2-29))$)|(?:(?:(?:\\d{4}-(?:0?[13578]|1[02]))-(?:0?[1-9]|[12]\\d|30))$)|(?:(?:(?:\\d{4}-0?[13-9]|1[0-2])-(?:0?[1-9]|[1-2]\\d|30))$)|(?:(?:(?:\\d{2}(?:0[48]|[13579][26]|[2468][048])|(?:(?:0[48]|[13579][26]|[2468][048])00))-0?2-29))$)$";
    private final Pattern DATE_FORMAT = Pattern.compile(DATE_PATTERN);
    @Override
    public PageResult<PddOrder> queryPageList(PddOrderBo bo, PageQuery pageQuery) {
        if(StringUtils.hasText(bo.getStartTime())){
            Matcher matcher = DATE_FORMAT.matcher(bo.getStartTime());
            boolean b = matcher.find();
            if(b){
                bo.setStartTime(bo.getStartTime()+" 00:00:00");
            }
        }
        if(StringUtils.hasText(bo.getEndTime())){
            Matcher matcher = DATE_FORMAT.matcher(bo.getEndTime());
            boolean b = matcher.find();
            if(b){
                bo.setEndTime(bo.getEndTime()+" 23:59:59");
            }
        }else{
            if(StringUtils.hasText(bo.getStartTime())) {
                bo.setEndTime(bo.getStartTime() + " 23:59:59");
            }
        }

        LambdaQueryWrapper<PddOrder> queryWrapper = new LambdaQueryWrapper<PddOrder>()
                .eq(bo.getShopId()!=null,PddOrder::getShopId,bo.getShopId())
                .eq(StringUtils.hasText(bo.getOrderSn()),PddOrder::getOrderSn,bo.getOrderSn())
                .eq(StringUtils.hasText(bo.getOrderStatus()),PddOrder::getOrderStatus,bo.getOrderStatus())
                .ge(StringUtils.hasText(bo.getStartTime()),PddOrder::getCreateTime,bo.getStartTime())
                .le(StringUtils.hasText(bo.getEndTime()),PddOrder::getCreateTime,bo.getEndTime())
                ;
        pageQuery.setOrderByColumn("created_time");
        pageQuery.setIsAsc("desc");
        Page<PddOrder> taoGoodsPage = mapper.selectPage(pageQuery.build(), queryWrapper);
        if(taoGoodsPage.getRecords()!=null){
            for (PddOrder order:taoGoodsPage.getRecords()) {
                order.setItems(itemMapper.selectList(new LambdaQueryWrapper<PddOrderItem>().eq(PddOrderItem::getOrderSn,order.getOrderSn())));
            }
        }
        return PageResult.build(taoGoodsPage);
    }

    @Override
    public PddOrder queryDetailById(Long id) {
        PddOrder pddOrder = mapper.selectById(id);
        if(pddOrder!=null) {
            pddOrder.setItems(itemMapper.selectList(new LambdaQueryWrapper<PddOrderItem>().eq(PddOrderItem::getOrderSn,pddOrder.getOrderSn())));
        }
        return pddOrder;
    }

    @Override
    public PddOrder queryDetailBySn(String orderSn) {
        List<PddOrder> pddOrders = mapper.selectList(new LambdaQueryWrapper<PddOrder>().eq(PddOrder::getOrderSn,orderSn));
        if(!pddOrders.isEmpty()) {
            pddOrders.get(0).setItems(itemMapper.selectList(new LambdaQueryWrapper<PddOrderItem>().eq(PddOrderItem::getOrderSn,pddOrders.get(0).getOrderSn())));
            return pddOrders.get(0);
        }else
            return null;
    }

    @Transactional
    @Override
    public ResultVo<Integer> saveOrder(Long shopId, PddOrder order) {
        if(order == null ) return ResultVo.error(ResultVoEnum.SystemException);
        try {
            List<PddOrder> pddOrders = mapper.selectList(new LambdaQueryWrapper<PddOrder>().eq(PddOrder::getOrderSn, order.getOrderSn()));
            if (pddOrders != null && pddOrders.size() > 0) {
                // 存在，修改
                PddOrder update = new PddOrder();
                update.setId(pddOrders.get(0).getId());
                update.setGroupStatus(order.getGroupStatus());
                update.setConfirmStatus(order.getConfirmStatus());
                update.setOrderStatus(order.getOrderStatus());
                update.setRefundStatus(order.getRefundStatus());
                update.setPayAmount(order.getPayAmount());
                update.setDuoDuoPayReduction(order.getDuoDuoPayReduction());
                update.setRemark(order.getRemark());
                update.setRemarkTag(order.getRemarkTag());
                update.setRemarkTagName(order.getRemarkTagName());
                update.setBuyerMemo(order.getBuyerMemo());
                update.setUpdatedAt(order.getUpdatedAt());
                update.setShippingTime(order.getShippingTime());
                update.setTrackingNumber(order.getTrackingNumber());
                update.setTrackingCompany(order.getTrackingCompany());
                update.setPayType(order.getPayType());
                update.setPayNo(order.getPayNo());
                if(order.getOrderStatus()==1&&order.getRefundStatus()==1) {
                    // 待发货订单才更新收货地址信息
                    if(StringUtils.hasText(order.getAddress())) {
                        update.setAddress(order.getAddress());
                    }
                    if(StringUtils.hasText(order.getReceiverAddress())) {
                        update.setReceiverAddress(order.getReceiverAddress());
                    }
                    if(StringUtils.hasText(order.getReceiverName())) {
                        update.setReceiverName(order.getReceiverName());
                    }
                    if(StringUtils.hasText(order.getReceiverPhone())) {
                        update.setReceiverPhone(order.getReceiverPhone());
                    }
                    if(StringUtils.hasText(order.getReceiverAddressMask())) {
                        update.setReceiverAddressMask(order.getReceiverAddressMask());
                    }
                    if(StringUtils.hasText(order.getReceiverNameMask())) {
                        update.setReceiverNameMask(order.getReceiverNameMask());
                    }
                    if(StringUtils.hasText(order.getReceiverPhoneMask())) {
                        update.setReceiverPhoneMask(order.getReceiverPhoneMask());
                    }
                    if(StringUtils.hasText(order.getAddressMask())) {
                        update.setAddressMask(order.getAddressMask());
                    }
                }
                if(!StringUtils.hasText(pddOrders.get(0).getProvince()) && StringUtils.hasText(order.getProvince())){
                    update.setProvinceId(order.getProvinceId());
                    update.setProvince(order.getProvince());
                }
                if(!StringUtils.hasText(pddOrders.get(0).getCity()) && StringUtils.hasText(order.getCity())){
                    update.setCityId(order.getCityId());
                    update.setCity(order.getCity());
                }
                if(!StringUtils.hasText(pddOrders.get(0).getTown()) && StringUtils.hasText(order.getTown())){
                    update.setTownId(order.getTownId());
                    update.setTown(order.getTown());
                }
                update.setCreatedTime(order.getCreatedTime());
                update.setPayTime(order.getPayTime());
                update.setConfirmTime(order.getConfirmTime());
                update.setReceiveTime(order.getReceiveTime());
                update.setAfterSalesStatus(order.getAfterSalesStatus());
                update.setLastShipTime(order.getLastShipTime());
                update.setIsStockOut(order.getIsStockOut());
                update.setLogisticsId(order.getLogisticsId());
                update.setOrderChangeAmount(order.getOrderChangeAmount());
                update.setRiskControlStatus(order.getRiskControlStatus());
                update.setUrgeShippingTime(order.getUrgeShippingTime());
//                update.setAuditStatus(0);
                update.setUpdateTime(new Date());

                mapper.updateById(update);
                // 删除item
                itemMapper.delete(new LambdaQueryWrapper<PddOrderItem>().eq(PddOrderItem::getOrderSn,order.getOrderSn()));

                // 添加item
                for (PddOrderItem item : order.getItems()) {
                    List<PddGoodsSku> pddGoodsSku = goodsSkuMapper.selectList(new LambdaQueryWrapper<PddGoodsSku>().eq(PddGoodsSku::getSkuId, item.getSkuId()));
                    if (pddGoodsSku != null && !pddGoodsSku.isEmpty()) {
                        item.setOGoodsId(pddGoodsSku.get(0).getErpGoodsId().toString());
                        item.setOGoodsSkuId(pddGoodsSku.get(0).getErpGoodsSkuId().toString());
                    }
                    item.setOrderSn(order.getOrderSn());
                    itemMapper.insert(item);
                }
                // 补转：阶段2之前拉取的历史单（平台audit_status=0 表示未转入订单库），重拉时同步转入
                if ((pddOrders.get(0).getAuditStatus() == null
                        || pddOrders.get(0).getAuditStatus() == EnumAuditStatus.PENDING.getIndex())
                        && canAutoTransfer(pddOrders.get(0))) {
                    List<PddOrderItem> latestItems = itemMapper.selectList(
                            new LambdaQueryWrapper<PddOrderItem>().eq(PddOrderItem::getOrderSn, pddOrders.get(0).getOrderSn()));
                    transferToOOrder(pddOrders.get(0), latestItems, null, "拉单自动转单");
                }
                return ResultVo.error(ResultVoEnum.DataExist, "订单已经存在，更新成功");
            } else {
                // 不存在，新增
                // 平台落地表 audit_status=0：未转入订单库
                order.setAuditStatus(EnumAuditStatus.PENDING.getIndex());
                order.setShopId(shopId);
                order.setCreateTime(new Date());
                mapper.insert(order);
                // 添加item
                for (PddOrderItem item : order.getItems()) {
                    List<PddGoodsSku> pddGoodsSku = goodsSkuMapper.selectList(new LambdaQueryWrapper<PddGoodsSku>().eq(PddGoodsSku::getSkuId, item.getSkuId()));
                    if (pddGoodsSku != null && !pddGoodsSku.isEmpty()) {
                        item.setOGoodsId(pddGoodsSku.get(0).getErpGoodsId().toString());
                        item.setOGoodsSkuId(pddGoodsSku.get(0).getErpGoodsSkuId().toString());
                    }
                    item.setOrderSn(order.getOrderSn());
                    itemMapper.insert(item);
                }

                // 拉单落库直接转单：不依赖MQ（开源版无消费端实现），同步生成 o_order + o_order_item
                if (canAutoTransfer(order)) {
                    transferToOOrder(order, order.getItems(), null, "拉单自动转单");
                }

                return ResultVo.success();
            }
        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            e.printStackTrace();
            log.info("保存订单数据错误："+e.getMessage());
            return ResultVo.error(ResultVoEnum.SystemException, "系统异常：" + e.getMessage());
        }
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ResultVo<Long> confirmOrder(PddOrderConfirmBo confirmBo) {
        PddOrder pddOrder = mapper.selectById(confirmBo.getOrderId());
        if(pddOrder==null) return ResultVo.error("订单数据不存在");
        if(pddOrder.getAuditStatus()==null || pddOrder.getAuditStatus()!=EnumAuditStatus.PENDING.getIndex())
            return ResultVo.error("订单已自动转入订单库");

        List<PddOrderItem> pddOrderItems = itemMapper.selectList(
                new LambdaQueryWrapper<PddOrderItem>()
                        .eq(PddOrderItem::getOrderSn, pddOrder.getOrderSn()));
        if(pddOrderItems==null || pddOrderItems.isEmpty()){
            return ResultVo.error("找不到订单item");
        }

        OOrder legacy = erpOrderMapper.selectOne(new LambdaQueryWrapper<OOrder>()
                .eq(OOrder::getOrderNum, pddOrder.getOrderSn())
                .eq(OOrder::getParentOrderId, 0L)// 主订单；order_num 已降级为普通索引，必须限定 parent_order_id=0
                .last("limit 1"));
        if(legacy!=null) {
            // 历史口径确认过的单子（无 source_order_id），补记平台转入状态，不再重复生成
            markPlatformTransferred(pddOrder.getId());
            return ResultVo.error("订单已自动转入订单库");
        }

        return transferToOOrder(pddOrder, pddOrderItems, confirmBo, "手动确认订单");
    }

    /**
     * 已取消/售后终态的平台单不转入 o_order（只挡终态，非终态照常转）。
     * 挡掉：
     * 1) confirm_status=2 已取消（PddOrderConfirmStatusEnum.CANCELED）；
     * 2) refund_status=4 退款成功 且 未发货（order_status 为空或=1待发货）：
     *    即「发货前退款完成」终态，全单已退款无发货义务（口径对齐 Dou REFUND_BEFORE_SHIP_DONE 不转）；
     * 不挡：refund_status=2 售后处理中 / 3 退款中（非终态，转单后由审单/售后链路处理）；
     * 已发货(2)/已签收(3)后的退款成功走售后链路，保守不挡
     */
    private boolean canAutoTransfer(PddOrder pddOrder) {
        Integer confirmStatus = pddOrder.getConfirmStatus();
        if (confirmStatus != null && confirmStatus == PddOrderConfirmStatusEnum.CANCELED.getIndex()) {
            return false;
        }
        Integer refundStatus = pddOrder.getRefundStatus();
        Integer orderStatus = pddOrder.getOrderStatus();
        boolean unshipped = orderStatus == null || orderStatus == EnumShopOrderStatus.WAIT_SHIP.getStatus().intValue();
        return refundStatus == null || refundStatus != EnumOrderRefundStatus.COMPLETE.getStatus().intValue() || !unshipped;
    }

    /**
     * 幂等转单：组装 OOrder + OOrderItem 并调用共用组件写入。
     * confirmBo==null 为拉单自动转单，收件人取平台单字段；否则取人工确认入参。
     */
    private ResultVo<Long> transferToOOrder(PddOrder pddOrder, List<PddOrderItem> pddOrderItems,
                                            PddOrderConfirmBo confirmBo, String createBy) {
        OOrder order = buildOOrder(pddOrder, confirmBo, createBy);
        List<OOrderItem> oItems = buildOOrderItems(pddOrder, pddOrderItems, createBy);
        OOrder inserted = orderAuditInitService.syncToOOrder(order, oItems);
        // 无论本次是否新插入，平台 audit_status 回写为1（含义：已转入订单库）
        markPlatformTransferred(pddOrder.getId());
        if (inserted == null) {
            return ResultVo.error("订单已自动转入订单库");
        }
        return ResultVo.success();
    }

    /** 回写平台落地表转入状态（audit_status：0未转入 1已转入订单库） */
    private void markPlatformTransferred(String id) {
        PddOrder orderUpdate = new PddOrder();
        orderUpdate.setId(id);
        orderUpdate.setAuditStatus(EnumAuditStatus.APPROVED.getIndex());
        orderUpdate.setAuditTime(new Date());
        mapper.updateById(orderUpdate);
    }

    private OOrder buildOOrder(PddOrder pddOrder, PddOrderConfirmBo confirmBo, String createBy) {
        OOrder order = new OOrder();
        order.setSourceOrderId(pddOrder.getId());
        order.setOrderNum(pddOrder.getOrderSn());
        order.setShopType(EnumShopType.PDD.getIndex());
        order.setShopId(pddOrder.getShopId());
        order.setBuyerMemo(pddOrder.getBuyerMemo());
        order.setSellerMemo(pddOrder.getRemark());
        order.setOrderStatus(EnumOOrderStatus.WAIT_SHIP.getIndex());
        order.setPlatformStatusCode(pddOrder.getOrderStatus()==null?null:String.valueOf(pddOrder.getOrderStatus()));
        order.setGoodsAmount(pddOrder.getGoodsAmount()!=null?pddOrder.getGoodsAmount():0.0);
        order.setPostFee(pddOrder.getPostage()!=null?pddOrder.getPostage():0.0);
        order.setSellerDiscount(pddOrder.getSellerDiscount()!=null?pddOrder.getSellerDiscount():0.0);
        order.setPlatformDiscount(pddOrder.getPlatformDiscount()!=null?pddOrder.getPlatformDiscount():0.0);
        order.setAmount(pddOrder.getPayAmount()!=null?pddOrder.getPayAmount():0.0);
        order.setPayment(pddOrder.getPayAmount()!=null?pddOrder.getPayAmount():0.0);
        if (confirmBo != null) {
            order.setReceiverName(confirmBo.getReceiver());
            order.setReceiverMobile(confirmBo.getMobile());
            order.setAddress(confirmBo.getAddress());
            order.setProvince(confirmBo.getProvince());
            order.setCity(confirmBo.getCity());
            order.setTown(confirmBo.getTown());
        } else {
            // 自动转单：收件人取平台单字段（脱敏场景可能为掩码值，放行前由人工补全）
            order.setReceiverName(StringUtils.hasText(pddOrder.getReceiverName())?pddOrder.getReceiverName():pddOrder.getReceiverNameMask());
            order.setReceiverMobile(StringUtils.hasText(pddOrder.getReceiverPhone())?pddOrder.getReceiverPhone():pddOrder.getReceiverPhoneMask());
            order.setAddress(StringUtils.hasText(pddOrder.getReceiverAddress())?pddOrder.getReceiverAddress():pddOrder.getReceiverAddressMask());
            order.setProvince(pddOrder.getProvince());
            order.setCity(pddOrder.getCity());
            order.setTown(pddOrder.getTown());
        }
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            LocalDateTime orderTime = LocalDateTime.parse(pddOrder.getCreatedTime(), formatter);
            order.setOrderTime(orderTime);
        }catch (Exception e){}
        order.setShipStatus(EnumShipStatus.NOT.getIndex());
        order.setWaybillStatus(EnumWaybillStatus.NOT_TAKEN.getIndex());
        order.setCreateTime(new Date());
        order.setCreateBy(createBy);
        return order;
    }

    private List<OOrderItem> buildOOrderItems(PddOrder pddOrder, List<PddOrderItem> pddOrderItems, String createBy) {
        List<OOrderItem> oItems = new ArrayList<>();
        for (PddOrderItem item : pddOrderItems) {
            OOrderItem oOrderItem = new OOrderItem();
            oOrderItem.setOrderNum(pddOrder.getOrderSn());
            oOrderItem.setSubOrderNum(pddOrder.getOrderSn()+"-"+item.getSkuId());
            oOrderItem.setShopType(EnumShopType.PDD.getIndex());
            oOrderItem.setShopId(pddOrder.getShopId());
            oOrderItem.setSkuId(item.getSkuId()==null?null:item.getSkuId().toString());
            oOrderItem.setGoodsId(StringUtils.hasText(item.getOGoodsId())?Long.parseLong(item.getOGoodsId()):0L);
            oOrderItem.setGoodsSkuId(StringUtils.hasText(item.getOGoodsSkuId())?Long.parseLong(item.getOGoodsSkuId()):0L);
            oOrderItem.setGoodsTitle(item.getGoodsName());
            oOrderItem.setGoodsImg(item.getGoodsImg());
            oOrderItem.setGoodsNum(item.getOuterGoodsId());
            oOrderItem.setGoodsSpec(item.getGoodsSpec());
            oOrderItem.setSkuNum(item.getOuterId());
            oOrderItem.setGoodsPrice(item.getGoodsPrice()!=null?item.getGoodsPrice():0.0);
            oOrderItem.setQuantity(item.getGoodsCount());
            oOrderItem.setItemAmount(oOrderItem.getGoodsPrice()*oOrderItem.getQuantity());
            oOrderItem.setDiscountAmount(0.0);
            oOrderItem.setPayment(0.0);
            oOrderItem.setRefundCount(0);
            oOrderItem.setRefundStatus(1);
            oOrderItem.setShipStatus(EnumShipStatus.NOT.getIndex());
            oOrderItem.setCreateTime(new Date());
            oOrderItem.setCreateBy(createBy);
            oItems.add(oOrderItem);
        }
        return oItems;
    }
}




