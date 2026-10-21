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
import cn.qihangerp.enums.TaoOrderStateEnum;
import cn.qihangerp.mapper.*;
import cn.qihangerp.model.entity.OOrder;
import cn.qihangerp.model.entity.OOrderItem;
import cn.qihangerp.model.entity.TaoGoodsSku;
import cn.qihangerp.model.entity.TaoOrder;
import cn.qihangerp.model.entity.TaoOrderItem;
import cn.qihangerp.model.entity.TaoOrderPromotion;
import cn.qihangerp.model.bo.TaoOrderBo;
import cn.qihangerp.model.bo.TaoOrderConfirmBo;
import cn.qihangerp.service.OrderAuditInitService;
import cn.qihangerp.service.TaoGoodsSkuService;
import cn.qihangerp.service.TaoOrderService;
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
* @description 针对表【tao_order(淘宝订单表)】的数据库操作Service实现
* @createDate 2024-02-29 19:01:11
*/
@Log
@AllArgsConstructor
@Service
public class TaoOrderServiceImpl extends ServiceImpl<TaoOrderMapper, TaoOrder>
    implements TaoOrderService {
    private final TaoOrderMapper mapper;
    private final TaoOrderItemMapper itemMapper;
    private final TaoOrderPromotionMapper promotionDetailsMapper;
    private final TaoGoodsSkuService goodsSkuService;
    private final ErpOrderMapper erpOrderMapper;
    private final ErpOrderItemMapper erpOrderItemMapper;
    private final OrderAuditInitService orderAuditInitService;


    private final String DATE_PATTERN =
            "^(?:(?:(?:\\d{4}-(?:0?[1-9]|1[0-2])-(?:0?[1-9]|1\\d|2[0-8]))|(?:(?:(?:\\d{2}(?:0[48]|[2468][048]|[13579][26])|(?:(?:0[48]|[2468][048]|[13579][26])00))-0?2-29))$)|(?:(?:(?:\\d{4}-(?:0?[13578]|1[02]))-(?:0?[1-9]|[12]\\d|30))$)|(?:(?:(?:\\d{4}-0?[13-9]|1[0-2])-(?:0?[1-9]|[1-2]\\d|30))$)|(?:(?:(?:\\d{2}(?:0[48]|[13579][26]|[2468][048])|(?:(?:0[48]|[13579][26]|[2468][048])00))-0?2-29))$)$";
    private final Pattern DATE_FORMAT = Pattern.compile(DATE_PATTERN);
    @Override
    public PageResult<TaoOrder> queryPageList(TaoOrderBo bo, PageQuery pageQuery) {
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
        }

        LambdaQueryWrapper<TaoOrder> queryWrapper = new LambdaQueryWrapper<TaoOrder>()
                .eq(bo.getShopId()!=null,TaoOrder::getShopId,bo.getShopId())
                .eq(StringUtils.hasText(bo.getTid()),TaoOrder::getTid,bo.getTid())
                .eq(StringUtils.hasText(bo.getStatus()),TaoOrder::getStatus,bo.getStatus())
                .ge(StringUtils.hasText(bo.getStartTime()),TaoOrder::getCreated,bo.getStartTime()+" 00:00:00")
                .le(StringUtils.hasText(bo.getEndTime()),TaoOrder::getCreated,bo.getEndTime()+" 23:59:59")
                ;
        pageQuery.setOrderByColumn("created");
        pageQuery.setIsAsc("desc");
        Page<TaoOrder> taoGoodsPage = mapper.selectPage(pageQuery.build(), queryWrapper);
        if(taoGoodsPage.getRecords()!=null){
            for (TaoOrder order:taoGoodsPage.getRecords()) {
                order.setItems(itemMapper.selectList(new LambdaQueryWrapper<TaoOrderItem>().eq(TaoOrderItem::getTid,order.getTid())));
            }
        }
        return PageResult.build(taoGoodsPage);
    }

    @Override
    public TaoOrder queryDetailById(Long id) {
        return mapper.selectById(id);
    }

    @Override
    public TaoOrder queryDetailByTid(String tid) {
        List<TaoOrder> taoOrders = mapper.selectList(new LambdaQueryWrapper<TaoOrder>().eq(TaoOrder::getTid, tid));
        if(taoOrders.isEmpty())
            return null;
        else{
            taoOrders.get(0).setItems(itemMapper.selectList(new LambdaQueryWrapper<TaoOrderItem>().eq(TaoOrderItem::getTid,tid)));
            taoOrders.get(0).setPromotions(promotionDetailsMapper.selectList(new LambdaQueryWrapper<TaoOrderPromotion>().eq(TaoOrderPromotion::getId,tid)));
            return taoOrders.get(0);
        }
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ResultVo<Long> saveOrder(Long shopId, TaoOrder order) {
        if(order == null ) return ResultVo.error(ResultVoEnum.SystemException);
        try {

            List<TaoOrder> taoOrders = mapper.selectList(new LambdaQueryWrapper<TaoOrder>().eq(TaoOrder::getTid, order.getTid()));
            if (taoOrders != null && taoOrders.size() > 0) {
                // 存在，修改
                TaoOrder update = new TaoOrder();
                update.setId(taoOrders.get(0).getId());
                if(order.getStatus().equals("WAIT_SELLER_SEND_GOODS")) {
                    update.setReceiverName(order.getReceiverName());
                    update.setReceiverMobile(order.getReceiverMobile());
                    update.setReceiverAddress(order.getReceiverAddress());
                }
                update.setSid(order.getSid());
                update.setSellerRate(order.getSellerRate());
                update.setBuyerRate(order.getBuyerRate());
                update.setStatus(order.getStatus());
                update.setModified(order.getModified());
                update.setEndTime(order.getEndTime());
                update.setConsignTime(order.getConsignTime());

                update.setUpdateTime(new Date());
                update.setReceivedPayment(order.getReceivedPayment());
                update.setAvailableConfirmFee(order.getAvailableConfirmFee());
                mapper.updateById(update);
                // 更新item
                for (TaoOrderItem item : order.getItems()) {
                    List<TaoOrderItem> taoOrderItems = itemMapper.selectList(new LambdaQueryWrapper<TaoOrderItem>().eq(TaoOrderItem::getOid, item.getOid()));
                    if (taoOrderItems != null && taoOrderItems.size() > 0) {
                        // 更新
                        TaoOrderItem itemUpdate = new TaoOrderItem();
                        itemUpdate.setId(taoOrderItems.get(0).getId());
                        itemUpdate.setRefundId(item.getRefundId());
                        itemUpdate.setRefundStatus(item.getRefundStatus());
                        itemUpdate.setStatus(item.getStatus());
                        itemUpdate.setBuyerRate(item.getBuyerRate());
                        itemUpdate.setSellerRate(item.getSellerRate());
                        itemUpdate.setEndTime(item.getEndTime());
                        itemUpdate.setConsignTime(item.getConsignTime());
                        itemUpdate.setTotalFee(item.getTotalFee());
                        itemUpdate.setDiscountFee(item.getDiscountFee());
                        itemUpdate.setAdjustFee(item.getAdjustFee());
                        itemUpdate.setDivideOrderFee(item.getDivideOrderFee());
                        itemUpdate.setPartMjzDiscount(item.getPartMjzDiscount());
                        itemUpdate.setPayment(item.getPayment());
                        itemUpdate.setShippingType(item.getShippingType());
                        itemUpdate.setLogisticsCompany(item.getLogisticsCompany());
                        itemUpdate.setInvoiceNo(item.getInvoiceNo());
                        List<TaoGoodsSku> skus = goodsSkuService.list(new LambdaQueryWrapper<TaoGoodsSku>().eq(TaoGoodsSku::getSkuId, item.getSkuId()));
                        if (skus != null && !skus.isEmpty()) {
                            itemUpdate.setoGoodsId(skus.get(0).getErpGoodsId().toString());
                            itemUpdate.setoGoodsSkuId(skus.get(0).getErpGoodsSkuId().toString());
                        }

                        itemMapper.updateById(itemUpdate);
                    } else {
                        // 新增
                        List<TaoGoodsSku> skus = goodsSkuService.list(new LambdaQueryWrapper<TaoGoodsSku>().eq(TaoGoodsSku::getSkuId, item.getSkuId()));
                        if (skus != null && !skus.isEmpty()) {
                            item.setoGoodsId(skus.get(0).getErpGoodsId().toString());
                            item.setoGoodsSkuId(skus.get(0).getErpGoodsSkuId().toString());
                        }
                        itemMapper.insert(item);
                    }
                }
                // 补转：阶段2之前拉取的历史单（平台audit_status=0 表示未转入订单库），重拉时同步转入
                if ((taoOrders.get(0).getAuditStatus() == null
                        || taoOrders.get(0).getAuditStatus() == EnumAuditStatus.PENDING.getIndex())
                        && canAutoTransfer(taoOrders.get(0))) {
                    List<TaoOrderItem> latestItems = itemMapper.selectList(
                            new LambdaQueryWrapper<TaoOrderItem>().eq(TaoOrderItem::getTid, taoOrders.get(0).getTid()));
                    transferToOOrder(taoOrders.get(0), latestItems, null, "拉单自动转单");
                }
                return ResultVo.error(ResultVoEnum.DataExist.getIndex(), "订单已经存在，更新成功",Long.parseLong(update.getId()));
            } else {
                // 不存在，新增
                order.setShopId(shopId);
                // 平台落地表 audit_status=0：未转入订单库
                order.setAuditStatus(EnumAuditStatus.PENDING.getIndex());
                order.setCreateTime(new Date());
                mapper.insert(order);
                // 添加item
                for (TaoOrderItem item : order.getItems()) {
                    itemMapper.insert(item);
                }
                // 添加 优惠信息
                if(order.getPromotions()!=null){
                    for (TaoOrderPromotion p:order.getPromotions()) {
                        promotionDetailsMapper.insert(p);
                    }
                }

                // 拉单落库直接转单：不依赖MQ，同步生成 o_order + o_order_item
                if (canAutoTransfer(order)) {
                    transferToOOrder(order, order.getItems(), null, "拉单自动转单");
                }

                return ResultVo.success(Long.parseLong(order.getId()));
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
    public ResultVo<Integer> updateOrder(TaoOrder order) {
        if(order == null ) return ResultVo.error(ResultVoEnum.SystemException);
        List<TaoOrder> taoOrders = mapper.selectList(new LambdaQueryWrapper<TaoOrder>().eq(TaoOrder::getTid, order.getTid()));
        if (taoOrders != null && taoOrders.size() > 0) {
            TaoOrder update = new TaoOrder();
            update.setId(taoOrders.get(0).getId());
            update.setSid(order.getSid());
            update.setSellerRate(order.getSellerRate());
            update.setBuyerRate(order.getBuyerRate());
            update.setStatus(order.getStatus());
            update.setModified(order.getModified());
            update.setEndTime(order.getEndTime());
            update.setConsignTime(order.getConsignTime());
            update.setUpdateTime(new Date());
            mapper.updateById(update);

            return ResultVo.error(ResultVoEnum.SUCCESS, "订单更新成功");
        } else {
            // 不存在，新增
            return ResultVo.error(ResultVoEnum.NotFound, "订单不存在");
        }
    }


    @Transactional(rollbackFor = Exception.class)
    @Override
    public ResultVo<Long> confirmOrder(TaoOrderConfirmBo confirmBo) {
        TaoOrder taoOrder = mapper.selectById(confirmBo.getOrderId());
        if(taoOrder==null) return ResultVo.error("订单数据不存在");
        if(taoOrder.getAuditStatus()==null || taoOrder.getAuditStatus()!=EnumAuditStatus.PENDING.getIndex())
            return ResultVo.error("订单已自动转入订单库");

        List<TaoOrderItem> taoOrderItems = itemMapper.selectList(
                new LambdaQueryWrapper<TaoOrderItem>()
                        .eq(TaoOrderItem::getTid, taoOrder.getTid()));
        if(taoOrderItems==null || taoOrderItems.isEmpty()){
            return ResultVo.error("找不到订单item");
        }

        OOrder legacy = erpOrderMapper.selectOne(new LambdaQueryWrapper<OOrder>()
                .eq(OOrder::getOrderNum, taoOrder.getTid())
                .eq(OOrder::getParentOrderId, 0L)// 主订单；order_num 已降级为普通索引，必须限定 parent_order_id=0
                .last("limit 1"));
        if(legacy!=null) {
            // 历史口径确认过的单子（无 source_order_id），补记平台转入状态，不再重复生成
            markPlatformTransferred(taoOrder.getId());
            return ResultVo.error("订单已自动转入订单库");
        }

        return transferToOOrder(taoOrder, taoOrderItems, confirmBo, "手动确认订单");
    }

    /** 交易关闭/退款关闭状态的平台单不转入 o_order */
    private boolean canAutoTransfer(TaoOrder taoOrder) {
        String status = taoOrder.getStatus();
        if (!StringUtils.hasText(status)) return true;
        return !TaoOrderStateEnum.TRADE_CLOSED.getCode().equals(status)
                && !TaoOrderStateEnum.TRADE_CLOSED_BY_TAOBAO.getCode().equals(status);
    }

    /** 平台状态编码 -> 中文描述 */
    private String taoStateName(String code) {
        for (TaoOrderStateEnum c : TaoOrderStateEnum.values()) {
            if (c.getCode().equals(code)) return c.getName();
        }
        return null;
    }

    /**
     * 幂等转单：组装 OOrder + OOrderItem 并调用共用组件写入。
     * confirmBo==null 为拉单自动转单，收件人取平台单字段；否则取人工确认入参。
     */
    private ResultVo<Long> transferToOOrder(TaoOrder taoOrder, List<TaoOrderItem> taoOrderItems,
                                            TaoOrderConfirmBo confirmBo, String createBy) {
        OOrder order = buildOOrder(taoOrder, confirmBo, createBy);
        List<OOrderItem> oItems = buildOOrderItems(taoOrder, taoOrderItems, createBy);
        OOrder inserted = orderAuditInitService.syncToOOrder(order, oItems);
        // 无论本次是否新插入，平台 audit_status 回写为1（含义：已转入订单库）
        markPlatformTransferred(taoOrder.getId());
        if (inserted == null) {
            return ResultVo.error("订单已自动转入订单库");
        }
        return ResultVo.success(Long.parseLong(order.getId()));
    }

    /** 回写平台落地表转入状态（audit_status：0未转入 1已转入订单库） */
    private void markPlatformTransferred(String id) {
        TaoOrder orderUpdate = new TaoOrder();
        orderUpdate.setId(id);
        orderUpdate.setAuditStatus(EnumAuditStatus.APPROVED.getIndex());
        orderUpdate.setAuditTime(new Date());
        mapper.updateById(orderUpdate);
    }

    private OOrder buildOOrder(TaoOrder taoOrder, TaoOrderConfirmBo confirmBo, String createBy) {
        OOrder order = new OOrder();
        order.setSourceOrderId(taoOrder.getId());
        order.setOrderNum(taoOrder.getTid());
        order.setShopType(EnumShopType.TAO.getIndex());
        order.setShopId(taoOrder.getShopId());
        order.setBuyerMemo(taoOrder.getBuyerMemo());
        order.setSellerMemo(taoOrder.getSellerMemo());
        order.setOrderStatus(EnumOOrderStatus.WAIT_SHIP.getIndex());
        order.setPlatformStatusCode(taoOrder.getStatus());
        order.setPlatformStatusDesc(taoStateName(taoOrder.getStatus()));
        order.setOpenAddressId(taoOrder.getOaid());
        order.setGoodsAmount(taoOrder.getTotalFee()!=null?taoOrder.getTotalFee():0.0);
        order.setPostFee(taoOrder.getPostFee()!=null?taoOrder.getPostFee().doubleValue():0.0);
        order.setSellerDiscount(taoOrder.getDiscountFee()!=null?taoOrder.getDiscountFee().doubleValue():0.0);
        order.setPlatformDiscount(0.0);
        order.setAmount(taoOrder.getTotalFee()!=null?taoOrder.getTotalFee().doubleValue():0.0);
        order.setPayment(taoOrder.getPayment()!=null?taoOrder.getPayment().doubleValue():0.0);
        if (confirmBo != null) {
            order.setReceiverName(confirmBo.getReceiver());
            order.setReceiverMobile(confirmBo.getMobile());
            order.setAddress(confirmBo.getAddress());
            order.setProvince(confirmBo.getProvince());
            order.setCity(confirmBo.getCity());
            order.setTown(confirmBo.getTown());
        } else {
            // 自动转单：收件人取平台单字段（密文下单场景可能为空，放行前由人工补全）
            order.setReceiverName(taoOrder.getReceiverName());
            order.setReceiverMobile(taoOrder.getReceiverMobile());
            order.setAddress(taoOrder.getReceiverAddress());
            order.setProvince(taoOrder.getReceiverState());
            order.setCity(taoOrder.getReceiverCity());
            order.setTown(taoOrder.getReceiverDistrict());
        }
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            LocalDateTime orderTime = LocalDateTime.parse(taoOrder.getCreated(), formatter);
            order.setOrderTime(orderTime);
        }catch (Exception e){}
        order.setShipStatus(EnumShipStatus.NOT.getIndex());
        order.setWaybillStatus(EnumWaybillStatus.NOT_TAKEN.getIndex());
        order.setCreateTime(new Date());
        order.setCreateBy(createBy);
        return order;
    }

    private List<OOrderItem> buildOOrderItems(TaoOrder taoOrder, List<TaoOrderItem> taoOrderItems, String createBy) {
        List<OOrderItem> oItems = new ArrayList<>();
        for (TaoOrderItem item : taoOrderItems) {
            OOrderItem oOrderItem = new OOrderItem();
            oOrderItem.setOrderNum(taoOrder.getTid());
            oOrderItem.setSubOrderNum(item.getOid().toString());
            oOrderItem.setShopType(EnumShopType.TAO.getIndex());
            oOrderItem.setShopId(taoOrder.getShopId());
            oOrderItem.setSkuId(item.getSkuId()==null?null:item.getSkuId().toString());
            oOrderItem.setGoodsId(StringUtils.hasText(item.getoGoodsId())?Long.parseLong(item.getoGoodsId()):0L);
            oOrderItem.setGoodsSkuId(StringUtils.hasText(item.getoGoodsSkuId())?Long.parseLong(item.getoGoodsSkuId()):0L);
            oOrderItem.setGoodsTitle(item.getTitle());
            oOrderItem.setGoodsImg(item.getPicPath());
            oOrderItem.setGoodsNum(item.getOuterIid());
            oOrderItem.setGoodsSpec(item.getSkuPropertiesName());
            oOrderItem.setSkuNum(item.getOuterSkuId());
            oOrderItem.setGoodsPrice(item.getPrice()!=null?item.getPrice().doubleValue():0.0);
            oOrderItem.setQuantity(item.getNum());
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
    //    @Transactional(rollbackFor = Exception.class)
//    @Override
//    public ResultVo<Integer> manualShipmentOrder(ShopOrderShipBo shipBo, String createBy) {
//        if (StringUtils.isEmpty(shipBo.getId()) || shipBo.getId().equals("0"))
//            return ResultVo.error(ResultVoEnum.ParamsError, "缺少参数：id");
//
//        ErpOrder erpOrder = mapper.selectById(shipBo.getId());
//        if (erpOrder == null) {
//            return ResultVo.error("找不到订单数据");
//        } else if (erpOrder.getOrderStatus().intValue() != 1 && erpOrder.getRefundStatus().intValue() != 1) {
//            return ResultVo.error("订单状态不对，不允许发货");
//        }
//        ErpLogisticsCompany erpLogisticsCompany = erpLogisticsCompanyMapper.selectById(shipBo.getShippingCompany());
//        if(erpLogisticsCompany==null) return ResultVo.error("快递公司选择错误");
//
//        // 自己发货的list
//        List<ErpOrderItem> oOrderItems = orderItemMapper.selectList(
//                new LambdaQueryWrapper<ErpOrderItem>()
//                        .eq(ErpOrderItem::getOrderId, erpOrder.getId())
//                        .eq(ErpOrderItem::getShipStatus,0)
//                        .eq(ErpOrderItem::getShipType,0)
//        );
//        if(oOrderItems==null) return ResultVo.error("订单 item 数据错误，无法发货！");
//        // 添加发货记录
//        ErpShipment erpShipment = new ErpShipment();
//        erpShipment.setShipper(0);//发货方 0 仓库发货 1 供应商发货】
//        erpShipment.setTenantId(erpOrder.getTenantId());
//        erpShipment.setShopId(erpOrder.getShopId());
//        erpShipment.setShopType(erpOrder.getShopType());
//        erpShipment.setOrderId(erpOrder.getId());
//        erpShipment.setOrderNum(erpOrder.getOrderNum());
//        erpShipment.setOrderTime(erpOrder.getOrderTime());
//        erpShipment.setShipType(1);//发货类型（1订单发货2商品补发3商品换货）
//        erpShipment.setShipCompany(erpLogisticsCompany.getName());
//        erpShipment.setShipCompanyCode(erpLogisticsCompany.getCode());
//        erpShipment.setShipCode(shipBo.getShippingNumber());
//        erpShipment.setShipFee(shipBo.getShippingCost());
//        erpShipment.setShipTime(new Date());
//        erpShipment.setShipOperator(shipBo.getShippingMan());
//        erpShipment.setShipStatus(1);//物流状态（0 待发货1已发货2已完成）
//
//        erpShipment.setPackageHeight(shipBo.getHeight());
//        erpShipment.setPackageWeight(shipBo.getWeight());
//        erpShipment.setPackageLength(shipBo.getLength());
//        erpShipment.setPackageWidth(shipBo.getWidth());
//        erpShipment.setPacksgeOperator(shipBo.getShippingMan());
////        erpShipment.setPackages(JSONObject.toJSONString(oOrderItems));
//        erpShipment.setRemark(shipBo.getRemark());
//        erpShipment.setCreateBy(createBy);
//        erpShipment.setCreateTime(new Date());
//
//        shipmentMapper.insert(erpShipment);
//
//        for(ErpOrderItem orderItem:oOrderItems){
//            ErpShipmentItem erpShipmentItem = new ErpShipmentItem();
//            erpShipmentItem.setShipper(erpShipment.getShipper());
//            erpShipmentItem.setTenantId(erpShipment.getTenantId());
//            erpShipmentItem.setShopId(erpShipment.getShopId());
//            erpShipmentItem.setShopType(erpShipment.getShopType());
//            erpShipmentItem.setShipmentId(erpShipment.getId());
//            erpShipmentItem.setOrderId(erpShipment.getOrderId());
//            erpShipmentItem.setOrderNum(erpShipment.getOrderNum());
//            erpShipmentItem.setOrderTime(erpShipment.getOrderTime());
//            erpShipmentItem.setOrderItemId(orderItem.getId());
//            erpShipmentItem.setErpGoodsId(orderItem.getErpGoodsId());
//            erpShipmentItem.setErpSkuId(orderItem.getErpSkuId());
//            erpShipmentItem.setGoodsTitle(orderItem.getGoodsTitle());
//            erpShipmentItem.setGoodsNum(orderItem.getGoodsNum());
//            erpShipmentItem.setGoodsImg(orderItem.getGoodsImg());
//            erpShipmentItem.setGoodsSpec(orderItem.getGoodsSpec());
//            erpShipmentItem.setSkuNum(orderItem.getSkuNum());
//            erpShipmentItem.setQuantity(orderItem.getQuantity());
//            erpShipmentItem.setRemark(orderItem.getRemark());
//            erpShipmentItem.setStockStatus(0);
//            erpShipmentItem.setCreateBy(createBy);
//            erpShipmentItem.setCreateTime(new Date());
//            shipmentItemMapper.insert(erpShipmentItem);
//
//            // 更新订单item发货状态
//            ErpOrderItem orderItemUpdate = new ErpOrderItem();
//            orderItemUpdate.setId( orderItem.getId());
//            orderItemUpdate.setUpdateBy("手动发货");
//            orderItemUpdate.setUpdateTime(new Date());
//            orderItemUpdate.setShipStatus(1);//发货状态 0 待发货 1 已发货
//            orderItemMapper.updateById(orderItemUpdate);
//        }
//
//
//        // 更新状态、发货方式
//        ErpOrder update = new ErpOrder();
//        update.setId(erpOrder.getId());
//        update.setShipStatus(2);
//        update.setOrderStatus(2);
//        update.setUpdateTime(new Date());
//        update.setUpdateBy("手动发货");
//        mapper.updateById(update);
//
//        return ResultVo.success();
//    }
}




