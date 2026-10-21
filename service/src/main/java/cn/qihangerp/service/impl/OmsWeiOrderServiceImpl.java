package cn.qihangerp.service.impl;

import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.common.ResultVoEnum;
import cn.qihangerp.enums.EnumAuditStatus;
import cn.qihangerp.enums.EnumOOrderStatus;
import cn.qihangerp.enums.EnumShipStatus;
import cn.qihangerp.enums.EnumShopType;
import cn.qihangerp.enums.EnumWaybillStatus;
import cn.qihangerp.enums.WeiOrderStateEnum;
import cn.qihangerp.mapper.ErpOrderItemMapper;
import cn.qihangerp.mapper.ErpOrderMapper;
import cn.qihangerp.model.bo.WeiOrderBo;
import cn.qihangerp.model.entity.OOrder;
import cn.qihangerp.model.entity.OOrderItem;
import cn.qihangerp.model.entity.OmsWeiGoodsSku;
import cn.qihangerp.model.entity.OmsWeiOrder;
import cn.qihangerp.model.entity.OmsWeiOrderItem;
import cn.qihangerp.model.bo.WeiOrderConfirmBo;
import cn.qihangerp.mapper.OmsWeiGoodsSkuMapper;
import cn.qihangerp.mapper.OmsWeiOrderItemMapper;
import cn.qihangerp.mapper.OmsWeiOrderMapper;
import cn.qihangerp.service.OmsWeiOrderService;
import cn.qihangerp.service.OrderAuditInitService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.util.StringUtils;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
* @author TW
* @description 针对表【oms_wei_order】的数据库操作Service实现
* @createDate 2024-06-03 16:48:31
*/
@AllArgsConstructor
@Service
public class OmsWeiOrderServiceImpl extends ServiceImpl<OmsWeiOrderMapper, OmsWeiOrder>
    implements OmsWeiOrderService {
    private final OmsWeiOrderMapper mapper;
    private final OmsWeiOrderItemMapper itemMapper;
    private final OmsWeiGoodsSkuMapper goodsSkuMapper;
    private final ErpOrderMapper erpOrderMapper;
    private final ErpOrderItemMapper erpOrderItemMapper;
    private final OrderAuditInitService orderAuditInitService;
//    private final MQClientService mqClientService;
    private final String DATE_PATTERN =
        "^(?:(?:(?:\\d{4}-(?:0?[1-9]|1[0-2])-(?:0?[1-9]|1\\d|2[0-8]))|(?:(?:(?:\\d{2}(?:0[48]|[2468][048]|[13579][26])|(?:(?:0[48]|[2468][048]|[13579][26])00))-0?2-29))$)|(?:(?:(?:\\d{4}-(?:0?[13578]|1[02]))-(?:0?[1-9]|[12]\\d|30))$)|(?:(?:(?:\\d{4}-0?[13-9]|1[0-2])-(?:0?[1-9]|[1-2]\\d|30))$)|(?:(?:(?:\\d{2}(?:0[48]|[13579][26]|[2468][048])|(?:(?:0[48]|[13579][26]|[2468][048])00))-0?2-29))$)$";
    private final Pattern DATE_FORMAT = Pattern.compile(DATE_PATTERN);
    @Override
    public PageResult<OmsWeiOrder> queryPageList(WeiOrderBo bo, PageQuery pageQuery) {
        Long startTimestamp = null;
        Long endTimestamp = null;
        if(StringUtils.hasText(bo.getStartTime())){
            Matcher matcher = DATE_FORMAT.matcher(bo.getStartTime());
            boolean b = matcher.find();
            if(!b){
                bo.setStartTime("");
            }
        }
        if(StringUtils.hasText(bo.getEndTime())){
            Matcher matcher = DATE_FORMAT.matcher(bo.getEndTime());
            boolean b = matcher.find();
            if(!b){
                bo.setEndTime("");
            }
        }else{
            if(StringUtils.hasText(bo.getStartTime())) {
                bo.setEndTime(bo.getStartTime());
            }
        }
        if(StringUtils.hasText(bo.getStartTime())) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            LocalDateTime startTime = LocalDateTime.parse(bo.getStartTime()+" 00:00:00", formatter);
            LocalDateTime endTime = LocalDateTime.parse(bo.getEndTime()+" 23:59:59", formatter);

            startTimestamp = startTime.toEpochSecond(ZoneOffset.ofHours(8));
            endTimestamp = endTime.toEpochSecond(ZoneOffset.ofHours(8));
        }
        LambdaQueryWrapper<OmsWeiOrder> queryWrapper = new LambdaQueryWrapper<OmsWeiOrder>()
                .eq(bo.getShopId()!=null,OmsWeiOrder::getShopId,bo.getShopId())
                .eq(StringUtils.hasText(bo.getOrderId()),OmsWeiOrder::getOrderId,bo.getOrderId())
                .eq(bo.getStatus()!=null,OmsWeiOrder::getStatus,bo.getStatus())
                .ge(StringUtils.hasText(bo.getStartTime()), OmsWeiOrder::getCreateTime, startTimestamp)
                .le(StringUtils.hasText(bo.getEndTime()),OmsWeiOrder::getCreateTime,endTimestamp)
                ;
//        if(bo.getErpSendStatus()!=null){
//            if(bo.getErpSendStatus()==-1) {
//                queryWrapper.lt(OmsWeiOrder::getErpSendStatus,3);
//            }else {
//                queryWrapper.eq(OmsWeiOrder::getErpSendStatus, bo.getErpSendStatus());
//            }
//        }

        Page<OmsWeiOrder> page = mapper.selectPage(pageQuery.build(), queryWrapper);
        if(page.getRecords()!=null){
            for (OmsWeiOrder order:page.getRecords()) {
                order.setItems(itemMapper.selectList(new LambdaQueryWrapper<OmsWeiOrderItem>().eq(OmsWeiOrderItem::getOrderId,order.getOrderId())));
            }
        }
        return PageResult.build(page);
    }

    @Transactional
    @Override
    public ResultVo<Integer> saveOrder(Long shopId, OmsWeiOrder order) {
        try {
            List<OmsWeiOrder> orders = mapper.selectList(new LambdaQueryWrapper<OmsWeiOrder>().eq(OmsWeiOrder::getOrderId, order.getOrderId()));
            if (orders != null && orders.size() > 0) {
                // 存在，修改
                OmsWeiOrder update = new OmsWeiOrder();
                update.setId(orders.get(0).getId());
                update.setOrderId(order.getOrderId());
                update.setStatus(order.getStatus());
                update.setUpdateTime(order.getUpdateTime());
                update.setPayInfo(order.getPayInfo());
                update.setAftersaleDetail(order.getAftersaleDetail());
                update.setDeliveryProductInfo(order.getDeliveryProductInfo());

                mapper.updateById(update);
                // 更新item
                for (OmsWeiOrderItem item : order.getItems()) {
                    List<OmsWeiOrderItem> taoOrderItems = itemMapper.selectList(
                            new LambdaQueryWrapper<OmsWeiOrderItem>().eq(OmsWeiOrderItem::getSkuId, item.getSkuId()).eq(OmsWeiOrderItem::getOrderId,order.getOrderId())
                    );

                    if (taoOrderItems != null && taoOrderItems.size() > 0) {
                        // 更新
                        item.setId(taoOrderItems.get(0).getId());
                        List<OmsWeiGoodsSku> skus = goodsSkuMapper.selectList(new LambdaQueryWrapper<OmsWeiGoodsSku>().eq(OmsWeiGoodsSku::getSkuId, item.getSkuId()));
                        if (skus != null && !skus.isEmpty()) {
                            item.setOGoodsId(skus.get(0).getErpGoodsId());
                            item.setOGoodsSkuId(skus.get(0).getErpGoodsSkuId());
                        }
                        itemMapper.updateById(item);
                    } else {
                        // 新增
                        List<OmsWeiGoodsSku> skus = goodsSkuMapper.selectList(new LambdaQueryWrapper<OmsWeiGoodsSku>().eq(OmsWeiGoodsSku::getSkuId, item.getSkuId()));
                        if (skus != null && !skus.isEmpty()) {
                            item.setOGoodsId(skus.get(0).getErpGoodsId());
                            item.setOGoodsSkuId(skus.get(0).getErpGoodsSkuId());
                        }
                        item.setShopId(shopId);
                        item.setOrderId(order.getOrderId());
                        itemMapper.insert(item);
                    }
                }
                // 补转：阶段2之前拉取的历史单（平台audit_status=0 表示未转入订单库），重拉时同步转入
                if ((orders.get(0).getAuditStatus() == null
                        || orders.get(0).getAuditStatus() == EnumAuditStatus.PENDING.getIndex())
                        && canAutoTransfer(orders.get(0))) {
                    List<OmsWeiOrderItem> latestItems = itemMapper.selectList(
                            new LambdaQueryWrapper<OmsWeiOrderItem>().eq(OmsWeiOrderItem::getOrderId, orders.get(0).getOrderId()));
                    transferToOOrder(orders.get(0), latestItems, null, "拉单自动转单");
                }
                return ResultVo.error(ResultVoEnum.DataExist, "订单已经存在，更新成功");
            } else {
                // 不存在，新增

                order.setShopId(shopId);
                // 平台落地表 audit_status=0：未转入订单库
                order.setAuditStatus(EnumAuditStatus.PENDING.getIndex());
                mapper.insert(order);
                // 添加item
                for (OmsWeiOrderItem item : order.getItems()) {
                    List<OmsWeiGoodsSku> skus = goodsSkuMapper.selectList(new LambdaQueryWrapper<OmsWeiGoodsSku>().eq(OmsWeiGoodsSku::getSkuId, item.getSkuId()));
                    if (skus != null && !skus.isEmpty()) {
                        item.setOGoodsId(skus.get(0).getErpGoodsId());
                        item.setOGoodsSkuId(skus.get(0).getErpGoodsSkuId());
                    }
                    item.setShopId(shopId);
                    item.setOrderId(order.getOrderId());
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
            return ResultVo.error(ResultVoEnum.SystemException, "系统异常：" + e.getMessage());
        }
    }


    @Override
    public OmsWeiOrder queryDetailById(Long id) {
        OmsWeiOrder weiOrder = mapper.selectById(id);
        if(weiOrder!=null){
            weiOrder.setItems(itemMapper.selectList(new LambdaQueryWrapper<OmsWeiOrderItem>().eq(OmsWeiOrderItem::getOrderId,weiOrder.getOrderId())));
        }
        return weiOrder;
    }
    @Override
    public OmsWeiOrder queryDetailByOrderId(String orderId) {
        List<OmsWeiOrder> weiOrders = mapper.selectList(new LambdaQueryWrapper<OmsWeiOrder>().eq(OmsWeiOrder::getOrderId,orderId));
        if(weiOrders!=null&&weiOrders.size()>0){
            weiOrders.get(0).setItems(itemMapper.selectList(new LambdaQueryWrapper<OmsWeiOrderItem>().eq(OmsWeiOrderItem::getOrderId,orderId)));
            return weiOrders.get(0);
        }else return null;
    }
    @Transactional(rollbackFor = Exception.class)
    @Override
    public ResultVo<Long> confirmOrder(WeiOrderConfirmBo confirmBo) {
        OmsWeiOrder weiOrder = mapper.selectById(confirmBo.getOrderId());
        if(weiOrder==null) return ResultVo.error("订单数据不存在");
        if(weiOrder.getAuditStatus()==null || weiOrder.getAuditStatus()!=EnumAuditStatus.PENDING.getIndex())
            return ResultVo.error("订单已自动转入订单库");

        List<OmsWeiOrderItem> weiOrderItems = itemMapper.selectList(
                new LambdaQueryWrapper<OmsWeiOrderItem>()
                        .eq(OmsWeiOrderItem::getOrderId, weiOrder.getOrderId()));
        if(weiOrderItems==null || weiOrderItems.isEmpty()){
            return ResultVo.error("找不到订单item");
        }

        OOrder legacy = erpOrderMapper.selectOne(new LambdaQueryWrapper<OOrder>()
                .eq(OOrder::getOrderNum, weiOrder.getOrderId())
                .eq(OOrder::getParentOrderId, 0L)// 主订单；order_num 已降级为普通索引，必须限定 parent_order_id=0
                .last("limit 1"));
        if(legacy!=null) {
            // 历史口径确认过的单子（无 source_order_id），补记平台转入状态，不再重复生成
            markPlatformTransferred(weiOrder.getId());
            return ResultVo.error("订单已自动转入订单库");
        }

        return transferToOOrder(weiOrder, weiOrderItems, confirmBo, "手动确认订单");
    }

    /** 取消/售后关闭状态的平台单不转入 o_order（200 售后取消 / 250 未付款取消） */
    private boolean canAutoTransfer(OmsWeiOrder weiOrder) {
        Integer status = weiOrder.getStatus();
        if (status == null) return true;
        return status != WeiOrderStateEnum.AFTER_SALE_CANCELED.getIndex()
                && status != WeiOrderStateEnum.CANCELED.getIndex();
    }

    /**
     * 幂等转单：组装 OOrder + OOrderItem 并调用共用组件写入。
     * confirmBo==null 为拉单自动转单，收件人取平台单字段；否则取人工确认入参。
     */
    private ResultVo<Long> transferToOOrder(OmsWeiOrder weiOrder, List<OmsWeiOrderItem> weiOrderItems,
                                            WeiOrderConfirmBo confirmBo, String createBy) {
        OOrder order = buildOOrder(weiOrder, confirmBo, createBy);
        List<OOrderItem> oItems = buildOOrderItems(weiOrder, weiOrderItems, createBy);
        OOrder inserted = orderAuditInitService.syncToOOrder(order, oItems);
        // 无论本次是否新插入，平台 audit_status 回写为1（含义：已转入订单库）
        markPlatformTransferred(weiOrder.getId());
        if (inserted == null) {
            return ResultVo.error("订单已自动转入订单库");
        }
        return ResultVo.success();
    }

    /** 回写平台落地表转入状态（audit_status：0未转入 1已转入订单库） */
    private void markPlatformTransferred(Long id) {
        OmsWeiOrder orderUpdate = new OmsWeiOrder();
        orderUpdate.setId(id);
        orderUpdate.setAuditStatus(EnumAuditStatus.APPROVED.getIndex());
        orderUpdate.setAuditTime(new Date());
        mapper.updateById(orderUpdate);
    }

    private OOrder buildOOrder(OmsWeiOrder weiOrder, WeiOrderConfirmBo confirmBo, String createBy) {
        OOrder order = new OOrder();
        order.setSourceOrderId(String.valueOf(weiOrder.getId()));
        order.setOrderNum(weiOrder.getOrderId());
        order.setShopType(EnumShopType.WEI.getIndex());
        order.setShopId(weiOrder.getShopId());
        order.setBuyerMemo("");
        order.setSellerMemo("");
        order.setOrderStatus(EnumOOrderStatus.WAIT_SHIP.getIndex());
        order.setPlatformStatusCode(weiOrder.getStatus()==null?null:String.valueOf(weiOrder.getStatus()));
        order.setPlatformStatusDesc(weiStatusName(weiOrder.getStatus()));
        order.setWaybillOrderId(weiOrder.getEwaybillOrderCode());
        order.setGoodsAmount(weiOrder.getProductPrice()!=null?weiOrder.getProductPrice().doubleValue()/100:0.0);
        order.setPostFee(weiOrder.getFreight()!=null?weiOrder.getFreight().doubleValue()/100:0.0);
        order.setSellerDiscount(weiOrder.getDiscountedPrice()!=null?weiOrder.getDiscountedPrice().doubleValue()/100:0.0);
        order.setPlatformDiscount(0.0);
        order.setAmount(weiOrder.getOrderPrice()!=null?weiOrder.getOrderPrice().doubleValue()/100:0.0);
        order.setPayment(order.getAmount());
        if (confirmBo != null) {
            order.setReceiverName(confirmBo.getReceiver());
            order.setReceiverMobile(confirmBo.getMobile());
            order.setAddress(confirmBo.getAddress());
            order.setProvince(confirmBo.getProvince());
            order.setCity(confirmBo.getCity());
            order.setTown(confirmBo.getTown());
        } else {
            // 自动转单：收件人取平台单字段（视频号密文场景，发货前需换明文/人工补全）
            order.setReceiverName(weiOrder.getUserName());
            order.setReceiverMobile(weiOrder.getTelNumber());
            order.setAddress(weiOrder.getDetailInfo());
            order.setProvince(weiOrder.getProvinceName());
            order.setCity(weiOrder.getCityName());
            order.setTown(weiOrder.getCountyName());
        }
        try {
            LocalDateTime orderTime = Instant.ofEpochMilli(weiOrder.getCreateTime() * 1000)
                    .atZone(ZoneId.of("Asia/Shanghai"))
                    .toLocalDateTime();
            order.setOrderTime(orderTime);
        }catch (Exception e){}
        order.setShipStatus(EnumShipStatus.NOT.getIndex());
        order.setWaybillStatus(EnumWaybillStatus.NOT_TAKEN.getIndex());
        order.setCreateTime(new Date());
        order.setCreateBy(createBy);
        return order;
    }

    /** 平台状态编码 -> 中文描述 */
    private String weiStatusName(Integer status) {
        if (status == null) return null;
        for (WeiOrderStateEnum c : WeiOrderStateEnum.values()) {
            if (c.getIndex() == status) return c.getName();
        }
        return null;
    }

    private List<OOrderItem> buildOOrderItems(OmsWeiOrder weiOrder, List<OmsWeiOrderItem> weiOrderItems, String createBy) {
        List<OOrderItem> oItems = new ArrayList<>();
        for (OmsWeiOrderItem item : weiOrderItems) {
            OOrderItem oOrderItem = new OOrderItem();
            oOrderItem.setOrderNum(weiOrder.getOrderId());
            oOrderItem.setSubOrderNum(weiOrder.getOrderId()+"-"+item.getSkuId());
            oOrderItem.setShopType(EnumShopType.WEI.getIndex());
            oOrderItem.setShopId(weiOrder.getShopId());
            oOrderItem.setSkuId(item.getSkuId());
            oOrderItem.setGoodsId(item.getOGoodsId()!=null?item.getOGoodsId():0L);
            oOrderItem.setGoodsSkuId(item.getOGoodsSkuId()!=null?item.getOGoodsSkuId():0L);
            oOrderItem.setGoodsTitle(item.getTitle());
            oOrderItem.setGoodsImg(item.getThumbImg());
            oOrderItem.setGoodsNum(item.getOutProductId());
            oOrderItem.setGoodsSpec(item.getSkuAttrs()!=null?item.getSkuAttrs():"");
            oOrderItem.setSkuNum(item.getOutSkuId());
            oOrderItem.setGoodsPrice(item.getSalePrice()!=null?item.getSalePrice().doubleValue()/100:0.0);
            oOrderItem.setQuantity(item.getSkuCnt());
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




