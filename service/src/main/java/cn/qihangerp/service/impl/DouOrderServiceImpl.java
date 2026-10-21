package cn.qihangerp.service.impl;


import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.common.ResultVoEnum;
import cn.qihangerp.enums.DouOrderStateEnum;
import cn.qihangerp.enums.EnumAuditStatus;
import cn.qihangerp.enums.EnumOOrderStatus;
import cn.qihangerp.enums.EnumShopType;
import cn.qihangerp.enums.EnumShipStatus;
import cn.qihangerp.enums.EnumWaybillStatus;
import cn.qihangerp.mapper.*;
import cn.qihangerp.model.bo.DouOrderConfirmBo;
import cn.qihangerp.model.entity.OOrder;
import cn.qihangerp.model.entity.OOrderItem;
import cn.qihangerp.model.entity.DouGoodsSku;
import cn.qihangerp.model.entity.DouOrder;
import cn.qihangerp.model.entity.DouOrderItem;
import cn.qihangerp.model.bo.DouOrderBo;
import cn.qihangerp.service.DouOrderService;
import cn.qihangerp.service.OrderAuditInitService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.AllArgsConstructor;
import lombok.extern.java.Log;
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
* @description 针对表【dou_order(抖店订单表)】的数据库操作Service实现
* @createDate 2024-06-05 15:06:31
*/
@Log
@AllArgsConstructor
@Service
public class DouOrderServiceImpl extends ServiceImpl<DouOrderMapper, DouOrder>
    implements DouOrderService {
    private final DouOrderMapper mapper;
    private final DouOrderItemMapper itemMapper;
    private final DouGoodsSkuMapper goodsSkuMapper;
    private final ErpOrderMapper oOrderMapper;
    private final ErpOrderItemMapper oOrderItemMapper;
    private final OrderAuditInitService orderAuditInitService;

    private final String DATE_PATTERN =
            "^(?:(?:(?:\\d{4}-(?:0?[1-9]|1[0-2])-(?:0?[1-9]|1\\d|2[0-8]))|(?:(?:(?:\\d{2}(?:0[48]|[2468][048]|[13579][26])|(?:(?:0[48]|[2468][048]|[13579][26])00))-0?2-29))$)|(?:(?:(?:\\d{4}-(?:0?[13578]|1[02]))-(?:0?[1-9]|[12]\\d|30))$)|(?:(?:(?:\\d{4}-0?[13-9]|1[0-2])-(?:0?[1-9]|[1-2]\\d|30))$)|(?:(?:(?:\\d{2}(?:0[48]|[13579][26]|[2468][048])|(?:(?:0[48]|[13579][26]|[2468][048])00))-0?2-29))$)$";
    private final Pattern DATE_FORMAT = Pattern.compile(DATE_PATTERN);
    @Override
    public PageResult<DouOrder> queryPageList(DouOrderBo bo, PageQuery pageQuery) {
        Long startTimestamp = null;
        Long endTimestamp = null;
        if(StringUtils.hasText(bo.getEndTime())){
            Matcher matcher = DATE_FORMAT.matcher(bo.getEndTime());
            boolean b = matcher.find();
            if(b){
                bo.setEndTime(bo.getEndTime()+" 23:59:59");
            }
        }else{
            bo.setEndTime(bo.getStartTime()+" 23:59:59");
        }
        if(StringUtils.hasText(bo.getStartTime())){
            Matcher matcher = DATE_FORMAT.matcher(bo.getStartTime());
            boolean b = matcher.find();
            if(b){
                bo.setStartTime(bo.getStartTime()+" 00:00:00");
            }
        }
        if(StringUtils.hasText(bo.getStartTime())) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            LocalDateTime startTime = LocalDateTime.parse(bo.getStartTime(), formatter);
            LocalDateTime endTime = LocalDateTime.parse(bo.getEndTime(), formatter);

            startTimestamp = startTime.toEpochSecond(ZoneOffset.ofHours(8));
            endTimestamp = endTime.toEpochSecond(ZoneOffset.ofHours(8));
        }
        LambdaQueryWrapper<DouOrder> queryWrapper = new LambdaQueryWrapper<DouOrder>()
                .eq(bo.getShopId()!=null,DouOrder::getShopId,bo.getShopId())
                .eq(StringUtils.hasText(bo.getOrderId()),DouOrder::getOrderId,bo.getOrderId())
                .eq(StringUtils.hasText(bo.getOrderStatus()),DouOrder::getOrderStatus,bo.getOrderStatus())
                .ge(StringUtils.hasText(bo.getStartTime()),DouOrder::getCreateTime, startTimestamp)
                .le(StringUtils.hasText(bo.getEndTime()),DouOrder::getCreateTime,endTimestamp)
                ;
        pageQuery.setOrderByColumn("create_time");
        pageQuery.setIsAsc("desc");
        Page<DouOrder> taoGoodsPage = mapper.selectPage(pageQuery.build(), queryWrapper);
        if(taoGoodsPage.getRecords()!=null){
            for (DouOrder order:taoGoodsPage.getRecords()) {
                order.setItems(itemMapper.selectList(new LambdaQueryWrapper<DouOrderItem>().eq(DouOrderItem::getParentOrderId,order.getOrderId())));
            }
        }
        return PageResult.build(taoGoodsPage);
    }

    @Override
    public DouOrder queryDetailById(Long id) {
        DouOrder douOrder = mapper.selectById(id);
        if(douOrder!=null) {
            douOrder.setItems(itemMapper.selectList(new LambdaQueryWrapper<DouOrderItem>().eq(DouOrderItem::getParentOrderId,douOrder.getOrderId())));
        }
        return  douOrder;
    }

    @Override
    public DouOrder queryDetailByOrderId(String orderId) {
        List<DouOrder> douOrders = mapper.selectList(new LambdaQueryWrapper<DouOrder>().eq(DouOrder::getOrderId,orderId));
        if(!douOrders.isEmpty()) {
            douOrders.get(0).setItems(itemMapper.selectList(new LambdaQueryWrapper<DouOrderItem>().eq(DouOrderItem::getParentOrderId,douOrders.get(0).getOrderId())));
            return douOrders.get(0);
        }else return null;
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ResultVo<Integer> saveOrder(Long shopId, DouOrder order) {
        if(order == null ) return ResultVo.error(ResultVoEnum.SystemException);
        try {

            List<DouOrder> taoOrders = mapper.selectList(new LambdaQueryWrapper<DouOrder>().eq(DouOrder::getOrderId, order.getOrderId()));
            if (taoOrders != null && taoOrders.size() > 0) {
                // 存在，修改
                DouOrder update = new DouOrder();
                update.setId(taoOrders.get(0).getId());
                update.setOrderStatus(order.getOrderStatus());
                update.setOrderStatusDesc(order.getOrderStatusDesc());
                update.setBuyerWords(order.getBuyerWords());
                update.setSellerWords(order.getSellerWords());
                update.setSellerRemarkStars(order.getSellerRemarkStars());
                update.setCancelReason(order.getCancelReason());
                update.setChannelPaymentNo(order.getChannelPaymentNo());
                update.setPayTime(order.getPayTime());
                update.setUpdateTime(order.getUpdateTime());
                update.setFinishTime(order.getFinishTime());
                update.setOrderExpireTime(order.getOrderExpireTime());
                update.setLogisticsInfo(order.getLogisticsInfo());
                update.setMainStatus(order.getMainStatus());
                update.setMainStatusDesc(order.getMainStatusDesc());
                update.setMaskPostReceiver(order.getMaskPostReceiver());
                update.setMaskPostTel(order.getMaskPostTel());
                update.setMaskPostAddress(order.getMaskPostAddress());
                update.setPayAmount(order.getPayAmount());
                update.setPayType(order.getPayType());
                update.setShipTime(order.getShipTime());
                update.setTotalPromotionAmount(order.getTotalPromotionAmount());
                update.setModifyAmount(order.getModifyAmount());
                update.setModifyPostAmount(order.getModifyPostAmount());
                update.setLastPullTime(new Date());

                mapper.updateById(update);
                // 删除item
                itemMapper.delete(new LambdaQueryWrapper<DouOrderItem>().eq(DouOrderItem::getParentOrderId,order.getOrderId()));
                for (DouOrderItem item : order.getItems()) {
                    // 新增
                    DouGoodsSku goodsSku = goodsSkuMapper.selectById(item.getSkuId());
                    if (goodsSku != null) {
                        item.setOGoodsId(goodsSku.getErpGoodsId().toString());
                        item.setOGoodsSkuId(goodsSku.getErpGoodsSkuId().toString());
                    }
                    itemMapper.insert(item);
                }
                // 补转：阶段2之前拉取的历史单（平台audit_status=0 表示未转入订单库），重拉时同步转入
                if ((taoOrders.get(0).getAuditStatus() == null
                        || taoOrders.get(0).getAuditStatus() == EnumAuditStatus.PENDING.getIndex())
                        && canAutoTransfer(order)) {
                    transferToOOrder(taoOrders.get(0), order.getItems(), null, "拉单自动转单");
                }
                return ResultVo.error(ResultVoEnum.DataExist, "订单已经存在，更新成功");
            } else {
                // 不存在，新增
                order.setShopId(shopId);
                // 平台落地表 audit_status=0：未转入订单库
                order.setAuditStatus(EnumAuditStatus.PENDING.getIndex());
                order.setPullTime(new Date());
                mapper.insert(order);
                // 添加item
                for (DouOrderItem item : order.getItems()) {
                    DouGoodsSku goodsSku = goodsSkuMapper.selectById(item.getSkuId());
                    if (goodsSku != null) {
                        item.setOGoodsId(goodsSku.getErpGoodsId().toString());
                        item.setOGoodsSkuId(goodsSku.getErpGoodsSkuId().toString());
                    }
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
    public ResultVo<Long> confirmOrder(DouOrderConfirmBo confirmBo) {
        DouOrder douOrder = mapper.selectById(confirmBo.getOrderId());
        if(douOrder==null) return ResultVo.error("订单数据不存在");
        if(douOrder.getAuditStatus()==null || douOrder.getAuditStatus()!=EnumAuditStatus.PENDING.getIndex())
            return ResultVo.error("订单已自动转入订单库");

        List<DouOrderItem> douOrderItems = itemMapper.selectList(new LambdaQueryWrapper<DouOrderItem>().eq(DouOrderItem::getParentOrderId, douOrder.getOrderId()));
        if(douOrderItems==null || douOrderItems.isEmpty()){
            return ResultVo.error("找不到订单item");
        }

        OOrder legacy = oOrderMapper.selectOne(new LambdaQueryWrapper<OOrder>()
                .eq(OOrder::getOrderNum, douOrder.getOrderId())
                .eq(OOrder::getParentOrderId, 0L)// 主订单；order_num 已降级为普通索引，必须限定 parent_order_id=0
                .last("limit 1"));
        if(legacy!=null) {
            // 历史口径确认过的单子（无 source_order_id），补记平台转入状态，不再重复生成
            markPlatformTransferred(douOrder.getId());
            return ResultVo.error("订单已自动转入订单库");
        }

        return transferToOOrder(douOrder, douOrderItems, confirmBo, "手动确认订单");
    }

    /** 取消/退款关闭状态的平台单不转入 o_order（4 已取消 / 21 发货前退款完结） */
    private boolean canAutoTransfer(DouOrder douOrder) {
        Integer status = douOrder.getOrderStatus();
        if (status == null) return true;
        return status != DouOrderStateEnum.CANCELED.getIndex()
                && status != DouOrderStateEnum.REFUND_BEFORE_SHIP_DONE.getIndex();
    }

    /**
     * 幂等转单：组装 OOrder + OOrderItem 并调用共用组件写入。
     * confirmBo==null 为拉单自动转单，收件人取平台单脱敏字段；否则取人工确认入参。
     * 已转入（sourceOrderId+shopType 或历史 orderNum 命中）时不重复生成，仅回写平台转入状态。
     */
    private ResultVo<Long> transferToOOrder(DouOrder douOrder, List<DouOrderItem> douOrderItems,
                                            DouOrderConfirmBo confirmBo, String createBy) {
        OOrder order = buildOOrder(douOrder, confirmBo, createBy);
        List<OOrderItem> oItems = buildOOrderItems(douOrder, douOrderItems, createBy);
        OOrder inserted = orderAuditInitService.syncToOOrder(order, oItems);
        // 无论本次是否新插入，平台 audit_status 回写为1（含义：已转入订单库）
        markPlatformTransferred(douOrder.getId());
        if (inserted == null) {
            return ResultVo.error("订单已自动转入订单库");
        }
        return ResultVo.success();
    }

    /** 回写平台落地表转入状态（audit_status：0未转入 1已转入订单库） */
    private void markPlatformTransferred(String id) {
        DouOrder douOrderUpdate = new DouOrder();
        douOrderUpdate.setId(id);
        douOrderUpdate.setAuditStatus(EnumAuditStatus.APPROVED.getIndex());
        douOrderUpdate.setAuditTime(new Date());
        mapper.updateById(douOrderUpdate);
    }

    private OOrder buildOOrder(DouOrder douOrder, DouOrderConfirmBo confirmBo, String createBy) {
        OOrder order = new OOrder();
        order.setSourceOrderId(douOrder.getId());
        order.setOrderNum(douOrder.getOrderId());
        order.setShopType(EnumShopType.DOU.getIndex());
        order.setShopId(douOrder.getSShopId());
        order.setBuyerMemo(douOrder.getBuyerWords());
        order.setSellerMemo(douOrder.getSellerWords());
        order.setOrderStatus(EnumOOrderStatus.WAIT_SHIP.getIndex());
        order.setPlatformStatusCode(douOrder.getOrderStatus()==null?null:String.valueOf(douOrder.getOrderStatus()));
        order.setPlatformStatusDesc(douOrder.getOrderStatusDesc());
        order.setGoodsAmount(douOrder.getOrderAmount()!=null?douOrder.getOrderAmount().doubleValue()/100:0.0);
        order.setPostFee(douOrder.getPostAmount()!=null?douOrder.getPostAmount().doubleValue()/100:0.0);
        order.setSellerDiscount(douOrder.getPromotionShopAmount()!=null?douOrder.getPromotionShopAmount().doubleValue()/100:0.0);
        order.setPlatformDiscount(douOrder.getPromotionPlatformAmount()!=null?douOrder.getPromotionPlatformAmount().doubleValue()/100:0.0);
        order.setAmount(douOrder.getOrderAmount()!=null?douOrder.getOrderAmount().doubleValue()/100:0.0);
        order.setPayment(douOrder.getPayAmount()!=null?douOrder.getPayAmount().doubleValue()/100:0.0);
        order.setOpenAddressId(douOrder.getOpenAddressId());
        if (confirmBo != null) {
            order.setReceiverName(confirmBo.getReceiver());
            order.setReceiverMobile(confirmBo.getMobile());
            order.setAddress(confirmBo.getAddress());
            order.setProvince(confirmBo.getProvince());
            order.setCity(confirmBo.getCity());
            order.setTown(confirmBo.getTown());
        } else {
            // 自动转单：收件人信息取平台单脱敏字段，放行/发货前由人工补全
            order.setReceiverName(douOrder.getMaskPostReceiver());
            order.setReceiverMobile(douOrder.getMaskPostTel());
            order.setAddress(douOrder.getMaskPostAddress());
            order.setProvince(douOrder.getProvinceName());
            order.setCity(douOrder.getCityName());
            order.setTown(douOrder.getTownName());
        }
        try {
            LocalDateTime orderTime = Instant.ofEpochMilli(douOrder.getCreateTime() * 1000)
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

    private List<OOrderItem> buildOOrderItems(DouOrder douOrder, List<DouOrderItem> douOrderItems, String createBy) {
        List<OOrderItem> oItems = new ArrayList<>();
        for (DouOrderItem item : douOrderItems) {
            OOrderItem oOrderItem = new OOrderItem();
            oOrderItem.setOrderNum(douOrder.getOrderId());
            oOrderItem.setSubOrderNum(item.getOrderId());
            oOrderItem.setShopType(EnumShopType.DOU.getIndex());
            oOrderItem.setShopId(douOrder.getSShopId());
            oOrderItem.setSkuId(item.getSkuId().toString());
            oOrderItem.setGoodsId(StringUtils.hasText(item.getOGoodsId())?Long.parseLong(item.getOGoodsId()):0L);
            oOrderItem.setGoodsSkuId(StringUtils.hasText(item.getOGoodsSkuId())?Long.parseLong(item.getOGoodsSkuId()):0L);
            oOrderItem.setGoodsTitle(item.getProductName());
            oOrderItem.setGoodsImg(item.getProductPic());
            oOrderItem.setGoodsNum(item.getOutProductId());
            oOrderItem.setGoodsSpec(item.getSpec());
            oOrderItem.setSkuNum(item.getOutSkuId());
            oOrderItem.setGoodsPrice(item.getGoodsPrice()!=null?item.getGoodsPrice().doubleValue()/100:0.0);
            oOrderItem.setItemAmount(item.getOrderAmount()!=null?item.getOrderAmount().doubleValue()/100:0.0);
            oOrderItem.setDiscountAmount(item.getPromotionAmount()!=null?item.getPromotionAmount().doubleValue()/100:0.0);
            oOrderItem.setPayment(item.getPayAmount()!=null?item.getPayAmount().doubleValue()/100:0.0);
            oOrderItem.setQuantity(item.getItemNum());
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




