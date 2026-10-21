package cn.qihangerp.service.impl;

import cn.qihangerp.common.ResultVo;
import cn.qihangerp.mapper.*;
import cn.qihangerp.model.bo.OfflineOrderConfirmBo;
import cn.qihangerp.model.bo.OfflineOrderCreateBo;
import cn.qihangerp.model.bo.OfflineOrderCreateItemBo;
import cn.qihangerp.model.bo.OfflineOrderShipBo;
import cn.qihangerp.model.entity.*;
import cn.qihangerp.service.OfflineOrderService;
import cn.qihangerp.service.OrderAuditInitService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.enums.EnumAuditStatus;
import cn.qihangerp.enums.EnumOOrderStatus;
import cn.qihangerp.enums.EnumShipStatus;
import cn.qihangerp.enums.EnumWaybillStatus;
import cn.qihangerp.enums.EnumShopType;
import cn.qihangerp.common.mq.MqMessage;
import cn.qihangerp.common.mq.MqType;
import cn.qihangerp.common.mq.MqUtils;

import cn.qihangerp.request.OrderSearchRequest;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
* @author qilip
* @description 针对表【offline_order(线下渠道订单表)】的数据库操作Service实现
* @createDate 2024-07-27 23:03:38
*/
@AllArgsConstructor
@Service
public class OfflineOrderServiceImpl extends ServiceImpl<OfflineOrderMapper, OfflineOrder>
    implements OfflineOrderService {
    private final OOrderMapper oOrderMapper;
    private final OOrderItemMapper oOrderItemMapper;
    private final OShopMapper shopMapper;
    private final OfflineOrderMapper orderMapper;
    private final OfflineOrderItemMapper orderItemMapper;
    private final MqUtils mqUtils;
    private final OrderAuditInitService orderAuditInitService;
    private final String DATE_PATTERN =
            "^(?:(?:(?:\\d{4}-(?:0?[1-9]|1[0-2])-(?:0?[1-9]|1\\d|2[0-8]))|(?:(?:(?:\\d{2}(?:0[48]|[2468][048]|[13579][26])|(?:(?:0[48]|[2468][048]|[13579][26])00))-0?2-29))$)|(?:(?:(?:\\d{4}-(?:0?[13578]|1[02]))-(?:0?[1-9]|[12]\\d|30))$)|(?:(?:(?:\\d{4}-0?[13-9]|1[0-2])-(?:0?[1-9]|[1-2]\\d|30))$)|(?:(?:(?:\\d{2}(?:0[48]|[13579][26]|[2468][048])|(?:(?:0[48]|[13579][26]|[2468][048])00))-0?2-29))$)$";
    private final Pattern DATE_FORMAT = Pattern.compile(DATE_PATTERN);

    @Override
    public PageResult<OfflineOrder> queryPageList(OrderSearchRequest bo, PageQuery pageQuery) {
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

        LambdaQueryWrapper<OfflineOrder> queryWrapper = new LambdaQueryWrapper<OfflineOrder>()
                .eq(bo.getShopId()!=null,OfflineOrder::getShopId,bo.getShopId())
                .eq(org.springframework.util.StringUtils.hasText(bo.getOrderNum()),OfflineOrder::getOrderNum,bo.getOrderNum())
                .eq(bo.getOrderStatus()!=null,OfflineOrder::getOrderStatus,bo.getOrderStatus())
                .ge(org.springframework.util.StringUtils.hasText(bo.getStartTime()),OfflineOrder::getOrderTime,bo.getStartTime()+" 00:00:00")
                .le(org.springframework.util.StringUtils.hasText(bo.getEndTime()),OfflineOrder::getOrderTime,bo.getEndTime()+" 23:59:59")
                .like(org.springframework.util.StringUtils.hasText(bo.getReceiverName()),OfflineOrder::getReceiverName,bo.getReceiverName())
                .like(org.springframework.util.StringUtils.hasText(bo.getReceiverMobile()),OfflineOrder::getReceiverMobile,bo.getReceiverMobile())
                .like(org.springframework.util.StringUtils.hasText(bo.getShippingNumber()),OfflineOrder::getShippingNumber,bo.getShippingNumber())
                ;

        pageQuery.setOrderByColumn("order_time");
        pageQuery.setIsAsc("desc");
        Page<OfflineOrder> pages = orderMapper.selectPage(pageQuery.build(), queryWrapper);

        // 查询子订单
        if(pages.getRecords()!=null){
            for (OfflineOrder order:pages.getRecords()) {
                order.setItemList(orderItemMapper.selectList(new LambdaQueryWrapper<OfflineOrderItem>().eq(OfflineOrderItem::getOrderId, order.getId())));
            }
        }

        return PageResult.build(pages);
    }

    @Override
    public OfflineOrder queryDetailById(Long id) {
        OfflineOrder oOrder = orderMapper.selectById(id);
        if(oOrder!=null) {
           oOrder.setItemList(orderItemMapper.selectList(new LambdaQueryWrapper<OfflineOrderItem>().eq(OfflineOrderItem::getOrderId, oOrder.getId())));
        }

        return oOrder;
    }


    /**
     * 新增订单
     *
     * @param bo 订单
     * @return 结果
     */
    @Transactional
    @Override
    public Long insertOfflineOrder(OfflineOrderCreateBo bo, String createBy)
    {
        List<OfflineOrder> oOrders = orderMapper.selectList(new LambdaQueryWrapper<OfflineOrder>()
                .eq(OfflineOrder::getOrderNum, bo.getOrderNum())
                .eq(OfflineOrder::getShopId,bo.getShopId()));

        if (oOrders!=null&& oOrders.size()>0) return -1L;// 订单号已存在
//        erpOrder.setCreateTime(DateUtils.getNowDate());
//        int rows = erpOrderMapper.insertErpOrder(erpOrder);
//        insertErpOrderItem(erpOrder);
//        return rows;
        if(bo.getItemList() == null || bo.getItemList().size() == 0) return -2L;
        else{
            // 循环查找是否缺少specId
            for (OfflineOrderCreateItemBo itemBo : bo.getItemList()) {
                if(itemBo.getSkuId()==null || itemBo.getQuantity()<=0) return -3L;
            }
        }

        OShop shop = shopMapper.selectById(bo.getShopId());
        Integer shopType = 0;
        if(shop!=null){
            shopType = shop.getType();
        }else return -4L;

        // 开始组合订单信息
        OfflineOrder order = new OfflineOrder();
        order.setOrderNum(bo.getOrderNum());
        order.setShopId(bo.getShopId());
        order.setShopType(shopType);
        order.setBuyerMemo(bo.getBuyerMemo());
        order.setRemark(bo.getRemark());
        order.setRefundStatus(1);
        order.setOrderStatus(1);
        order.setGoodsAmount(bo.getGoodsAmount());
        order.setPostFee(bo.getPostage());
        order.setAmount(bo.getGoodsAmount()+bo.getPostage());
        order.setSellerDiscount(bo.getSellerDiscount());
        order.setPlatformDiscount(0.0);
        order.setPayment(bo.getGoodsAmount()+bo.getPostage()-bo.getSellerDiscount());
        order.setReceiverName(bo.getReceiverName());
        order.setReceiverMobile(bo.getReceiverPhone());
        order.setProvince(bo.getProvince());
        order.setCity(bo.getCity());
        order.setTown(bo.getTown());
        order.setAddress(bo.getAddress());
        order.setOrderTime(LocalDateTime.now());
        order.setCreateTime(new Date());
        order.setShipType(0);
        order.setCreateBy(createBy);
        // 平台落地表 audit_status=0：未转入订单库
        order.setAuditStatus(EnumAuditStatus.PENDING.getIndex());
        orderMapper.insert(order);

//        List<OOrderItem> itemList = new ArrayList<OOrderItem>();
        for (int i = 0; i < bo.getItemList().size(); i++) {
            OfflineOrderCreateItemBo itemBo = bo.getItemList().get(i);
            OfflineOrderItem orderItem = new OfflineOrderItem();

            orderItem.setOrderId(order.getId());
            orderItem.setOrderNum(bo.getOrderNum());
            if(bo.getItemList().size()==1) {
                orderItem.setSubOrderNum(bo.getOrderNum());
            }else{
                orderItem.setSubOrderNum(bo.getOrderNum()+(i+1));
            }
            orderItem.setSkuId(itemBo.getSkuId());
            orderItem.setGoodsId(0L);
            orderItem.setGoodsSkuId(Long.parseLong(itemBo.getSkuId()));
            orderItem.setGoodsTitle(itemBo.getGoodsName());
            orderItem.setGoodsImg(itemBo.getGoodsImg());
            orderItem.setGoodsSpec(itemBo.getSkuName());
            orderItem.setSkuNum(itemBo.getSkuCode());
            orderItem.setGoodsPrice(itemBo.getSalePrice().doubleValue());
            orderItem.setItemAmount(itemBo.getItemAmount().doubleValue());
            orderItem.setPayment(itemBo.getItemAmount().doubleValue());
            orderItem.setQuantity(itemBo.getQuantity());
            orderItem.setRefundCount(0);
            orderItem.setRefundStatus(1);
            orderItem.setOrderStatus(order.getOrderStatus());
            orderItem.setShipStatus(0);
            orderItem.setCreateTime(new Date());
            orderItem.setCreateBy(createBy);
            orderItemMapper.insert(orderItem);
//            itemList.add(orderItem);
        }

        // 建单落库直接转单：同步生成 o_order + o_order_item（收件人信息取建单入参，已明文）
        List<OfflineOrderItem> createdItems = orderItemMapper.selectList(
                new LambdaQueryWrapper<OfflineOrderItem>().eq(OfflineOrderItem::getOrderId, order.getId()));
        if (canAutoTransfer(order)) {
            transferToOOrder(order, createdItems, null, createBy);
        }

        return Long.parseLong(order.getId());
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ResultVo<Long> confirmOrder(OfflineOrderConfirmBo orderConfirmBo) {
        OfflineOrder offlineOrder = orderMapper.selectById(orderConfirmBo.getId());
        if(offlineOrder==null) return ResultVo.error("订单数据不存在");
        if(offlineOrder.getAuditStatus()==null || offlineOrder.getAuditStatus()!=EnumAuditStatus.PENDING.getIndex())
            return ResultVo.error("订单已自动转入订单库");
        List<OfflineOrderItem> offlineOrderItems = orderItemMapper.selectList(new LambdaQueryWrapper<OfflineOrderItem>()
                .eq(OfflineOrderItem::getOrderId, offlineOrder.getId())
                .eq(OfflineOrderItem::getShipStatus, EnumShipStatus.NOT.getIndex()));
        if(offlineOrderItems==null || offlineOrderItems.isEmpty()){
            return ResultVo.error("找不到订单item");
        }
        OOrder legacy = oOrderMapper.selectOne(new LambdaQueryWrapper<OOrder>()
                .eq(OOrder::getOrderNum, offlineOrder.getOrderNum())
                .eq(OOrder::getParentOrderId, 0L)// 主订单；order_num 已降级为普通索引，必须限定 parent_order_id=0
                .last("limit 1"));
        if(legacy!=null) {
            // 历史口径确认过的单子（无 source_order_id），补记平台转入状态，不再重复生成
            markPlatformTransferred(offlineOrder.getId());
            return ResultVo.error("订单已自动转入订单库");
        }
        return transferToOOrder(offlineOrder, offlineOrderItems, orderConfirmBo, "手动确认订单");
    }

    /** 已取消(11)/退款中(12)的线下单不转入 o_order */
    private boolean canAutoTransfer(OfflineOrder offlineOrder) {
        Integer status = offlineOrder.getOrderStatus();
        if (status == null) return true;
        return status != EnumOOrderStatus.CANCEL.getIndex()
                && status != EnumOOrderStatus.REFUND.getIndex()
                && status != EnumOOrderStatus.CLOSED.getIndex();
    }

    /**
     * 幂等转单：组装 OOrder + OOrderItem 并调用共用组件写入。
     * confirmBo==null 为建单自动转单，收件人取平台单字段；否则取人工确认入参。
     */
    private ResultVo<Long> transferToOOrder(OfflineOrder offlineOrder, List<OfflineOrderItem> offlineOrderItems,
                                            OfflineOrderConfirmBo confirmBo, String createBy) {
        OOrder order = buildOOrder(offlineOrder, confirmBo, createBy);
        List<OOrderItem> oItems = buildOOrderItems(offlineOrder, order.getShopType(), order.getShopId(), offlineOrderItems, createBy);
        OOrder inserted = orderAuditInitService.syncToOOrder(order, oItems);
        // 无论本次是否新插入，平台 audit_status 回写为1（含义：已转入订单库）
        markPlatformTransferred(offlineOrder.getId());
        if (inserted == null) {
            return ResultVo.error("订单已自动转入订单库");
        }
        return ResultVo.success();
    }

    /** 回写平台落地表转入状态（audit_status：0未转入 1已转入订单库） */
    private void markPlatformTransferred(String id) {
        OfflineOrder orderUpdate = new OfflineOrder();
        orderUpdate.setId(id);
        orderUpdate.setAuditStatus(EnumAuditStatus.APPROVED.getIndex());
        orderUpdate.setAuditTime(new Date());
        orderMapper.updateById(orderUpdate);
    }

    private OOrder buildOOrder(OfflineOrder offlineOrder, OfflineOrderConfirmBo confirmBo, String createBy) {
        OOrder order = new OOrder();
        order.setSourceOrderId(offlineOrder.getId());
        order.setOrderNum(offlineOrder.getOrderNum());
        order.setShopType(offlineOrder.getShopType());
        order.setShopId(offlineOrder.getShopId());
        order.setBuyerMemo(offlineOrder.getBuyerMemo());
        order.setSellerMemo(offlineOrder.getSellerMemo());
        // 与其余平台转单口径一致：转入订单库强制待发货，不透传平台落地表状态（发货状态由打单发货链路推进）
        order.setOrderStatus(EnumOOrderStatus.WAIT_SHIP.getIndex());
        order.setGoodsAmount(offlineOrder.getGoodsAmount());
        order.setPostFee(offlineOrder.getPostFee());
        order.setSellerDiscount(offlineOrder.getSellerDiscount());
        order.setPlatformDiscount(offlineOrder.getPlatformDiscount());
        order.setAmount(offlineOrder.getAmount());
        order.setPayment(offlineOrder.getPayment());
        if (confirmBo != null) {
            order.setReceiverName(confirmBo.getReceiver());
            order.setReceiverMobile(confirmBo.getMobile());
            order.setAddress(confirmBo.getAddress());
            order.setProvince(confirmBo.getProvince());
            order.setCity(confirmBo.getCity());
            order.setTown(confirmBo.getTown());
        } else {
            order.setReceiverName(offlineOrder.getReceiverName());
            order.setReceiverMobile(offlineOrder.getReceiverMobile());
            order.setAddress(offlineOrder.getAddress());
            order.setProvince(offlineOrder.getProvince());
            order.setCity(offlineOrder.getCity());
            order.setTown(offlineOrder.getTown());
        }
        order.setOrderTime(offlineOrder.getOrderTime());
        order.setShipStatus(EnumShipStatus.NOT.getIndex());
        order.setWaybillStatus(EnumWaybillStatus.NOT_TAKEN.getIndex());
        order.setCreateTime(new Date());
        order.setCreateBy(createBy);
        return order;
    }

    private List<OOrderItem> buildOOrderItems(OfflineOrder offlineOrder, Integer shopType, Long shopId,
                                              List<OfflineOrderItem> offlineOrderItems, String createBy) {
        List<OOrderItem> oItems = new ArrayList<>();
        for (OfflineOrderItem item : offlineOrderItems) {
            OOrderItem oOrderItem = new OOrderItem();
            oOrderItem.setOrderNum(item.getOrderNum());
            oOrderItem.setSubOrderNum(item.getSubOrderNum());
            oOrderItem.setShopType(shopType);
            oOrderItem.setShopId(shopId);
            oOrderItem.setSkuId(item.getSkuId());
            oOrderItem.setGoodsId(item.getGoodsId());
            oOrderItem.setGoodsSkuId(item.getGoodsSkuId());
            oOrderItem.setGoodsTitle(item.getGoodsTitle());
            oOrderItem.setGoodsImg(item.getGoodsImg());
            oOrderItem.setGoodsNum(item.getGoodsNum());
            oOrderItem.setGoodsSpec(item.getGoodsSpec());
            oOrderItem.setSkuNum(item.getSkuNum());
            oOrderItem.setGoodsPrice(item.getGoodsPrice());
            oOrderItem.setItemAmount(item.getItemAmount());
            oOrderItem.setDiscountAmount(0.0);
            oOrderItem.setPayment(item.getPayment());
            oOrderItem.setQuantity(item.getQuantity());
            oOrderItem.setRefundCount(item.getRefundCount());
            oOrderItem.setRefundStatus(item.getRefundStatus());
            oOrderItem.setShipStatus(EnumShipStatus.NOT.getIndex());
            oOrderItem.setCreateTime(new Date());
            oOrderItem.setCreateBy(createBy);
            oItems.add(oOrderItem);
        }
        return oItems;
    }

    @Transactional
    @Override
    public int orderLogistics(OfflineOrderShipBo bo, String operator) {
        if(!StringUtils.hasText(bo.getOrderNum())) return -1;
        if(!StringUtils.hasText(bo.getShippingNumber()) || !StringUtils.hasText(bo.getShippingCompany())) return -2;
        List<OfflineOrder> offlineOrders = orderMapper.selectList(new LambdaQueryWrapper<OfflineOrder>().eq(OfflineOrder::getOrderNum, bo.getOrderNum()));
        if(offlineOrders==null || offlineOrders.size()==0) return -3;
        else if(offlineOrders.get(0).getOrderStatus()!=1) return -4;
        if(offlineOrders.get(0).getRefundStatus()!=1) return -5;

        OfflineOrder update = new OfflineOrder();
        update.setId(offlineOrders.get(0).getId());
        update.setShippingCompany(bo.getShippingCompany());
        update.setShippingNumber(bo.getShippingNumber());
        update.setUpdateBy(operator);
        update.setUpdateTime(new Date());
        int rows = orderMapper.updateById(update);
        if (rows > 0){
            // TODO 通知OMS系统备货
            mqUtils.sendApiMessage(MqMessage.build(EnumShopType.OFFLINE, MqType.SHIP_STOCKUP_MESSAGE, bo.getOrderNum()));
        }
        return 1;
    }
}




