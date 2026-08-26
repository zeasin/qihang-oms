package cn.qihangerp.service.impl;

import cn.qihangerp.common.*;
import cn.qihangerp.enums.EnumOOrderStatus;
import cn.qihangerp.enums.EnumShipType;
import cn.qihangerp.mapper.*;
import cn.qihangerp.mapper.goods.OGoodsSkuMapper;
import cn.qihangerp.model.entity.*;
import cn.qihangerp.model.entity.ErpSupplier;
import cn.qihangerp.model.bo.RefundProcessingBo;
import cn.qihangerp.model.bo.RefundSearchBo;
import cn.qihangerp.service.ORefundService;
import cn.qihangerp.service.ShopGoodsSkuService;
import com.alibaba.fastjson2.JSONObject;
import com.alibaba.fastjson2.util.DateUtils;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import cn.qihangerp.enums.EnumShopType;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
* @author qilip
* @description 针对表【o_refund(退换货表)】的数据库操作Service实现
* @createDate 2024-03-10 16:23:12
*/
@Slf4j
@AllArgsConstructor
@Service
public class ORefundServiceImpl extends ServiceImpl<ORefundMapper, ORefund>
    implements ORefundService {
    private final ORefundMapper mapper;
    private final ORefundAfterSaleMapper afterSaleMapper;
    private final OOrderItemMapper orderItemMapper;
    private final OOrderMapper orderMapper;
    private final OOrderStockingMapper orderStockingMapper;
    private final OOrderStockingItemMapper orderStockingItemMapper;
    private final OGoodsSkuMapper goodsSkuMapper;
//    private final ShopGoodsSkuMappingService shopGoodsSkuMappingService;
    private final ShopGoodsSkuService shopGoodsSkuService;
    private final ShopGoodsMapper shopGoodsMapper;
    private final ErpWarehouseMapper erpWarehouseMapper;
    private final ErpSupplierMapper goodsSupplierMapper;
    private final ShopRefundMapper shopRefundMapper;

//    private final PddApiService pddApiService;
//    private final TaoApiService taoApiService;
//    private final JdApiService jdApiService;
//    private final DouApiService douApiService;
//    private final WeiApiService weiApiService;

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ResultVo<Integer> jdRefundMessage(String serviceId,JSONObject refundDetail) {
        log.info("京东退款消息处理"+serviceId);
//        log.info("=====jd refund message===退款单:"+JSONObject.toJSONString(refundDetail));
        // TODO:业务问题：一个订单退款单是否包含多个商品；一个京东订单是否包含多个ITEM
        /**
         * 状态（10001待审核 10002等待买家退货 10003等待平台审核 10004待买家处理 10005等待卖家处理 10006等待卖家发货 14000拒绝退款 10011退款关闭 10010退款完成 10020售后成功 10021售后失败 10090退款中 10091换货成功 10092换货失败 10093维修关闭 10094维修成功 ）
         *
         * 新状态：售后状态 0：售后申请 1：售后关闭，2：售后处理中，3：退款中，4： 售后成功
         */
        Integer refundStatus = 0;
        Integer hasProcessing=0;//是否处理0未处理1已处理9无需处理
//        Integer status = 0;
        String platformStatus = "";
        String platformStatusText = "";
        String orderNum = refundDetail.getString("orderId");
        Long shopId = refundDetail.getLong("shopId");
        String platformSkuId = refundDetail.getString("skuId");
        // 类型不同处理
        if(refundDetail.getInteger("customerExpect") == 1){
            // 售前退款，状态处理
            platformStatus = refundDetail.getInteger("refundStatus")+"";
            // refund_status
            //退款申请单状态
            // 0、未审核  10001
            // 1、审核通过 5、人工审核通过 10004待买家处理
            // 2、审核不通过 4、京东财务审核不通过 (14000)
            // 3、京东财务审核通过 6、京东拦截并退款 9、强制关单并退款 10010 退款完成
            // 11、用户撤销 18、协商关闭    10011-退款关闭（取消）

            // 7、青龙拦截成功 8、青龙拦截失败 10、物流待跟进(线下拦截) 27、京东承诺拦截 10005等待卖家处理
            // 16、拒收后退款 17、协商退货退款 10002等待买家退货
            //
            // 19、纠纷介入
            if(refundDetail.getInteger("refundStatus")  == 0){
                // 10001-待审核
                platformStatusText = "未审核";
//                status = 10001;
                refundStatus = 0;
            }
            else if(refundDetail.getInteger("refundStatus") == 1 || refundDetail.getInteger("refundStatus") == 5){
                //  10004待买家处理
                if(refundDetail.getInteger("refundStatus") == 1)
                    platformStatusText = "审核通过";
                else if(refundDetail.getInteger("refundStatus") == 5)
                    platformStatusText = "人工审核通过";
//                status = 10004;
                refundStatus = 2;
            }else if(refundDetail.getInteger("refundStatus") == 16 || refundDetail.getInteger("refundStatus") == 17 ){
                // 10002等待买家退货
//                status = 10002;
                refundStatus = 2;
                if(refundDetail.getInteger("refundStatus") == 16)
                    platformStatusText = "拒收后退款";
                else if(refundDetail.getInteger("refundStatus") == 17)
                    platformStatusText = "协商退货退款";
            }
            else if(refundDetail.getInteger("refundStatus") == 3 || refundDetail.getInteger("refundStatus") == 6 || refundDetail.getInteger("refundStatus") == 9){
                // 10010-退款成功（完成）
//                status = 10010;
                refundStatus = 4;
                if(refundDetail.getInteger("refundStatus") == 3)
                    platformStatusText = "京东财务审核通过";
                else if(refundDetail.getInteger("refundStatus") == 6)
                    platformStatusText = "京东拦截并退款";
                else if(refundDetail.getInteger("refundStatus") == 9)
                    platformStatusText = "强制关单并退款";
            }
            else if(refundDetail.getInteger("refundStatus") == 2 || refundDetail.getInteger("refundStatus") == 4){
                // 14000-卖家拒绝退款
//                status = 14000;
                refundStatus = 2;
                if(refundDetail.getInteger("refundStatus") == 2)
                    platformStatusText = "审核不通过";
                else if(refundDetail.getInteger("refundStatus") == 4)
                    platformStatusText = "京东财务审核不通过";
            }else if(refundDetail.getInteger("refundStatus") == 11 || refundDetail.getInteger("refundStatus") == 18){
                // 10011-退款关闭（取消）
//                status = 10011;
                refundStatus = 1;
                hasProcessing = 9;
                if(refundDetail.getInteger("refundStatus") == 11)
                    platformStatusText = "用户撤销";
                else if(refundDetail.getInteger("refundStatus") == 18)
                    platformStatusText = "协商关闭";
            }else if(refundDetail.getInteger("refundStatus") == 7 || refundDetail.getInteger("refundStatus") == 8|| refundDetail.getInteger("refundStatus") == 10 || refundDetail.getInteger("refundStatus") == 27){
                // 10005等待卖家处理
//                status = 10005;
                refundStatus = 2;
                if(refundDetail.getInteger("refundStatus") == 7)
                    platformStatusText = "青龙拦截成功";
                else if(refundDetail.getInteger("refundStatus") == 8)
                    platformStatusText = "青龙拦截失败";
                if(refundDetail.getInteger("refundStatus") == 10)
                    platformStatusText = "物流待跟进(线下拦截) ";
                else if(refundDetail.getInteger("refundStatus") == 27)
                    platformStatusText = "京东承诺拦截";
            }

        }else{
            //服务单状态（10000-待审核领取 10001-待审核 10002-待客户反馈 10004-审核关闭 10005-待收货 10006-待处理领取 10007-待处理
            // 10009-待用户确认 10010-完成 10011-取消 10012-客户已反馈 10013-待审核和待客户反馈 10041-提交退款申请 1100-待下发维修中心接单
            Integer status = refundDetail.getInteger("serviceStatus");
            platformStatus = status.toString();
            if(status == 10000){
                refundStatus = 0;
                platformStatusText = "待审核领取";
            }
            else if(status == 10001) {
                refundStatus = 0;
                platformStatusText = "待审核";
            }
            else if(status == 10002) {
                refundStatus = 2;
                platformStatusText = "待客户反馈";
            }
            else if(status == 10004) {
                refundStatus = 1;
                hasProcessing = 9;
                platformStatusText = "审核关闭";
            }
            else if(status == 10005) {
                refundStatus = 2;
                platformStatusText = "待收货";
            }
            else if(status == 10006){
                refundStatus = 2;
                platformStatusText = "待处理领取";
            }
            else if(status == 10007) {
                refundStatus = 2;
                platformStatusText = "待处理";
            }
            else if(status == 10009) {
                refundStatus = 2;
                platformStatusText = "待用户确认";
            }
            else if(status == 10010) {
                refundStatus = 4;
                platformStatusText = "完成";
            }
            else if(status == 10011){
                refundStatus = 1;
                hasProcessing = 9;
                platformStatusText = "取消";
            }
            else if(status == 10012){
                refundStatus = 2;
                platformStatusText = "客户已反馈";
            }
            else if(status == 10013) {
                refundStatus = 2;
                platformStatusText = "待审核和待客户反馈";
            }
            else if(status == 10041) {
                refundStatus = 0;
                platformStatusText = "提交退款申请";
            }
            else if(status == 1100){
                refundStatus = 2;
                platformStatusText = "待下发维修中心接单";
            }
            else if(status == 12000){
                refundStatus = 2;
                platformStatusText = "上门维修中";
            }
            else if(status == 14000){
                refundStatus = 2;
                platformStatusText = "上门检测中";
            }
            else if(status == 13000){
                refundStatus = 2;
                platformStatusText = "商家催收待处理";
            }
        }

        List<ORefund> oRefunds = mapper.selectList(new LambdaQueryWrapper<ORefund>()
                .eq(ORefund::getRefundNum, serviceId));
        if(oRefunds == null || oRefunds.isEmpty()) {
            // 新增
            ORefund insert = new ORefund();
            insert.setRefundNum(refundDetail.getString("serviceId"));
            insert.setRefundType(refundDetail.getInteger("customerExpect"));
            insert.setShopId(refundDetail.getLong("shopId"));
            insert.setShopType(EnumShopType.JD.getIndex());
            insert.setMerchantId(refundDetail.getLong("merchantId"));
            insert.setOrderNum(refundDetail.getString("orderId"));
            insert.setSkuId(refundDetail.getString("skuId"));
//            if(refundDetail.getInteger("customerExpect")==1) {
//                List<OOrderItem> oOrderItems = orderItemMapper.selectList(
//                        new LambdaQueryWrapper<OOrderItem>()
//                                .eq(OOrderItem::getOrderNum, insert.getOrderNum())
//                                .eq(OOrderItem::getSkuId, insert.getSkuId())
//                );
//                insert.setOrderItemNum(oOrderItems.isEmpty() ? insert.getOrderNum() : oOrderItems.get(0).getSubOrderNum());
//            }
            List<OOrderItem> oOrderItems = orderItemMapper.selectList(
                    new LambdaQueryWrapper<OOrderItem>()
                            .eq(OOrderItem::getOrderNum, insert.getOrderNum())
                            .eq(OOrderItem::getSkuId, insert.getSkuId())
            );
            insert.setOrderItemNum(oOrderItems.isEmpty() ? insert.getOrderNum()+"-"+insert.getSkuId() : oOrderItems.get(0).getSubOrderNum());
            ShopGoodsSku shopGoodsSku = shopGoodsSkuService.selectByPlatformSkuId(platformSkuId, shopId);

            // 查找skuId绑定的商品库关系
//            ShopGoodsSkuMapping shopGoodsSkuMapping = shopGoodsSkuMappingService.selectByPlatformSkuId(platformSkuId, shopId);
//            if (shopGoodsSkuMapping != null) {
            if (shopGoodsSku != null) {
                insert.setGoodsId(shopGoodsSku.getErpGoodsId());
                insert.setGoodsSkuId(shopGoodsSku.getErpGoodsSkuId());
            } else {
                insert.setGoodsId(0L);
                insert.setGoodsSkuId(0L);
            }

//            insert.setGoodsId(refundDetail.getLong("erpGoodsId"));
//            insert.setGoodsSkuId(refundDetail.getLong("erpGoodsSkuId"));
//            insert.setSkuNum(orderItem.getSkuNum());
            insert.setGoodsName(refundDetail.getString("wareName"));
//            insert.setGoodsSku(orderItem.getGoodsSpec());
//            insert.setGoodsImage(orderItem.getGoodsImg());
            insert.setQuantity(refundDetail.getInteger("serviceCount"));
//            insert.setContactperson(jdAfter.getCustomerName());
//            insert.setMobile(jdAfter.getCustomerTel());
//            insert.setAddress(jdAfter.getPickwareAddress());
            insert.setRefundFee(refundDetail.getDouble("applyRefundSum")!=null?refundDetail.getDouble("applyRefundSum")/100:0.0);
            if(refundDetail.getInteger("customerExpect") == 1){
                insert.setRefundReason(refundDetail.getString("refundReason"));
            }else {
                insert.setRefundReason(refundDetail.getString("questionDesc"));
            }
            insert.setShippingStatus(refundDetail.getInteger("shippingStatus"));
            insert.setStatus(refundStatus);
            insert.setHasProcessing(hasProcessing);
            insert.setPlatformStatus(platformStatus);
            insert.setPlatformStatusText(platformStatusText);
            insert.setErpStatus(0);
            insert.setCreateTime(new Date());
            insert.setCreateBy("REFUND_MESSAGE");
            mapper.insert(insert);
            //更新子订单状态
            if(oOrderItems!=null && oOrderItems.size()>0){
                for (OOrderItem oOrderItem : oOrderItems) {
                    // 更新订单库子订单状态
                    OOrderItem itemUpdate = new OOrderItem();
                    itemUpdate.setRefundStatus(2);
                    itemUpdate.setUpdateBy("退款消息");
                    itemUpdate.setUpdateTime(new Date());
                    itemUpdate.setId(oOrderItem.getId());
                    orderItemMapper.updateById(itemUpdate);
                    // 更新发货子订单状态
                    List<OOrderStockingItem> oOrderStockingItems = orderStockingItemMapper.selectList(new LambdaQueryWrapper<OOrderStockingItem>().eq(OOrderStockingItem::getOOrderItemId, oOrderItem.getId()));
                    if(oOrderStockingItems!=null && oOrderStockingItems.size()>0){
                        for (OOrderStockingItem oOrderStockingItem : oOrderStockingItems) {
                            OOrderStockingItem stockingItem = new OOrderStockingItem();
                            stockingItem.setId(oOrderStockingItem.getId());
                            stockingItem.setRefundStatus(2);
                            stockingItem.setUpdateTime(new Date());
                            stockingItem.setUpdateBy("退款消息");
                            orderStockingItemMapper.updateById(stockingItem);
                        }
                    }
                }
            }

        }else{
            // 修改
            ORefund update = new ORefund();
            update.setId(oRefunds.get(0).getId());
            if(refundDetail.getInteger("customerExpect")==1) {
                List<OOrderItem> oOrderItems = orderItemMapper.selectList(
                        new LambdaQueryWrapper<OOrderItem>()
                                .eq(OOrderItem::getOrderNum, oRefunds.get(0).getOrderNum())
                                .eq(OOrderItem::getSkuId, oRefunds.get(0).getSkuId())
                );
                update.setOrderItemNum(oOrderItems.isEmpty() ? oRefunds.get(0).getOrderNum() : oOrderItems.get(0).getSubOrderNum());
            }
            update.setRefundFee(refundDetail.getDouble("applyRefundSum")!=null?refundDetail.getDouble("applyRefundSum")/100:0.0);
            // 类型不同处理
            if(refundDetail.getInteger("customerExpect") == 1){
                // 售前退款，状态处理
                update.setRefundReason(refundDetail.getString("refundReason"));
            }else{
                update.setRefundReason(refundDetail.getString("questionDesc"));
            }
            update.setStatus(refundStatus);
            if(oRefunds.get(0).getHasProcessing().intValue() ==0) update.setHasProcessing(hasProcessing);
            update.setShippingStatus(refundDetail.getInteger("shippingStatus"));
            update.setPlatformStatus(platformStatus);
            update.setPlatformStatusText(platformStatusText);
            // 查找skuId绑定的商品库关系
            ShopGoodsSku shopGoodsSku = shopGoodsSkuService.selectByPlatformSkuId(platformSkuId, shopId);
//            ShopGoodsSkuMapping shopGoodsSkuMapping = shopGoodsSkuMappingService.selectByPlatformSkuId(platformSkuId, shopId);
            if (shopGoodsSku != null) {
                update.setGoodsId(shopGoodsSku.getErpGoodsId());
                update.setGoodsSkuId(shopGoodsSku.getErpGoodsSkuId());
            } else {
                update.setGoodsId(0L);
                update.setGoodsSkuId(0L);
            }
            update.setUpdateTime(new Date());
            update.setUpdateBy("REFUND_MESSAGE");
            mapper.updateById(update);
        }

        // 更新主订单状态
        List<OOrder> oOrders = orderMapper.selectList(new LambdaQueryWrapper<OOrder>().eq(OOrder::getOrderNum, orderNum).eq(OOrder::getShopId, shopId).eq(OOrder::getShopType, EnumShopType.JD.getIndex()));
        if(oOrders!=null && oOrders.size()>0){
            for (OOrder oOrder : oOrders) {
                // 查询子订单是否全部退款
                List<OOrderItem> oOrderItems = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                        .eq(OOrderItem::getOrderId, oOrder.getId())
                        .eq(OOrderItem::getRefundStatus, 1)
                );
                // 找出没有退款的子订单，如果没有，那么把主订单直接更新成取消状态
                if (oOrderItems == null || oOrderItems.isEmpty()) {
                    OOrder orderUpdate = new OOrder();
                    orderUpdate.setId(oOrder.getId());
                    orderUpdate.setOrderStatus(11);
                    orderUpdate.setCancelReason("子订单全部退款");
                    orderUpdate.setUpdateBy("子订单全部退款");
                    orderUpdate.setUpdateTime(new Date());
                    orderMapper.updateById(orderUpdate);
                }

                // 查找发货订单
                List<OOrderStocking> oOrderStockings = orderStockingMapper.selectList(new LambdaQueryWrapper<OOrderStocking>().eq(OOrderStocking::getOOrderId, oOrder.getId()));
                if(oOrderStockings!=null && oOrderStockings.size()>0){
                    for (OOrderStocking oOrderStocking : oOrderStockings) {
                        // 查找发货子订单是否全部退款
                        List<OOrderStockingItem> shipOrderItemList = orderStockingItemMapper.selectList(
                                new LambdaQueryWrapper<OOrderStockingItem>()
                                        .eq(OOrderStockingItem::getShipOrderId, oOrderStocking.getId())
                                        .eq(OOrderStockingItem::getRefundStatus, 1)
                        );
                        // 找出没有退款的子订单，如果没有，那么把主订单直接更新成取消状态
                        if (shipOrderItemList == null || shipOrderItemList.isEmpty()) {
                            OOrderStocking updateShip = new OOrderStocking();
                            updateShip.setId(oOrderStocking.getId());
                            updateShip.setOrderStatus(11);
                            updateShip.setUpdateBy("子订单全部退款");
                            updateShip.setUpdateTime(new Date());
                            orderStockingMapper.updateById(updateShip);
                        }
                    }
                }
            }
        }
        log.info("==========jd退款同步成功=======");
        return ResultVo.success();
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ResultVo<Integer> jdvcRefundMessage(String returnId,JSONObject refundDetail) {
        log.info("京东VC退货消息处理" + returnId);
//        log.info("=====jdvc refund message===消息处理" + returnId);
//        JSONObject jsonObject = jdApiService.getRefundDetail(Long.parseLong(returnId),1);
//        if(jsonObject.getInteger("code")!=200 || jsonObject.getJSONObject("data") ==null){
//            log.info("=====jdvc refund message===没有找到退款单");
//            return ResultVo.error(404,"没有找到退款单");
//        }
//
//        JSONObject refundDetail = jsonObject.getJSONObject("data");
//        log.info("=====jdvc refund message===退款单:"+JSONObject.toJSONString(refundDetail));



//        List<JdVcRefund> returnList = jdVcRefundMapper.selectList(new LambdaQueryWrapper<JdVcRefund>().eq(JdVcRefund::getId, returnId));
//        if (returnList == null || returnList.size() == 0) {
//            // 没有找到订单信息
//            return ResultVo.error(ResultVoEnum.NotFound, "没有找到京东VC退货单：" + returnId);
//        }
//        JdVcRefund jdVcRefund = returnList.get(0);
        // 对JSON做处理
//        JSONArray jsonArray = JSONArray.parseArray(jdVcRefund.getOrderDetailList());
        String orderNum = refundDetail.getString("customOrderId");
        Long shopId = refundDetail.getLong("shopId");
        String platformSkuId = refundDetail.getString("skuId");
        //类型(10-退货 20-换货 30-维修 40-大家电安装 50-大家电移机 60-大家电增值服务 70-上门维修 90-优鲜赔 80-补发商品 100-试用收回 11-仅退款)
        Integer refundType=null;
        Integer hasReturnGoods = null;
        if(refundDetail.getInteger("orderState")==29 ) {
            if (refundDetail.getInteger("operatorState") == 5 || refundDetail.getInteger("operatorState") == 10) {
                refundType = 11;//这是没有发货的退货
                hasReturnGoods = 0;
            } else if (refundDetail.getInteger("operatorState") == 16) {
                refundType = 10;//这是发货了的退款
                hasReturnGoods = 1;
            }
        }
        String platformStatus = refundDetail.getString("orderState");
        String platformStatusText = "";
        /**
         * 状态（10001待审核 10002等待买家退货 10003等待平台审核 10004待买家处理 10005等待卖家处理 10006等待卖家发货 14000拒绝退款 10011退款关闭 10010退款完成 10020售后成功 10021售后失败 10090退款中 10091换货成功 10092换货失败 10093维修关闭 10094维修成功 ）
         *
         * 新状态：售后状态 0：售后申请 1：售后关闭，2：售后处理中，3：退款中，4： 售后成功
         */
        Integer refundStatus = 0;
        Integer hasProcessing=0;//是否处理0未处理1已处理9无需处理
        //服务单状态（10000-待审核领取 10001-待审核 10002-待客户反馈 10004-审核关闭 10005-待收货 10006-待处理领取 10007-待处理 10009-待用户确认 10010-完成 10011-取消 10012-客户已反馈 10013-待审核和待客户反馈 10041-提交退款申请 1100-待下发维修中心接单 12000-上门维修中 14000-上门检测中 13000-商家催收待处理 13000-未收货，待收款 13000-已收货，待收款）
//        Integer status=10010;
        //审核状态0未审核 1审核通过 2审核不通过
        if(refundDetail.getInteger("approvalState")==0){
            // 10001-待审核
//            status = 10001;
            refundStatus = 0;
        }else if(refundDetail.getInteger("approvalState")==1){
//            status = 10010;
            refundStatus = 2;
        }else if(refundDetail.getInteger("approvalState")==2){
//            status = 14000;
            refundStatus = 2;
        }else {
            refundStatus = 2;
        }


        List<ORefund> oRefunds = mapper.selectList(new LambdaQueryWrapper<ORefund>().eq(ORefund::getRefundNum, returnId));

        if (oRefunds == null || oRefunds.isEmpty()) {
            // 新增
            ORefund insert = new ORefund();
            insert.setRefundNum(refundDetail.getString("id"));
            insert.setRefundType(refundType);
            insert.setHasGoodReturn(hasReturnGoods);
            insert.setShopId(refundDetail.getLong("shopId"));
            insert.setShopType(EnumShopType.JDVC.getIndex());
            insert.setMerchantId(refundDetail.getLong("merchantId"));
            // 查询ERP订单
//            OOrder order = null;
//            OOrderItem orderItem = null;
//            List<OOrder> oOrders = orderMapper.selectList(new LambdaQueryWrapper<OOrder>().eq(OOrder::getOrderNum, jdVcRefund.getCustomOrderId()).eq(OOrder::getShopId, jdVcRefund.getShopId()));
//            if(oOrders!=null && oOrders.size()>0){
//                order = oOrders.get(0);
//                List<OOrderItem> oOrderItems = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>().eq(OOrderItem::getOrderId, oOrders.get(0).getId()).eq(OOrderItem::getSkuId, jdVcRefund.getSkuId()));
//                if(oOrderItems!=null && oOrderItems.size()>0){
//                    orderItem = oOrderItems.get(0);
//                }else{
//                    log.info("没有找到TAO子订单erp信息：");
//                    return ResultVo.error(ResultVoEnum.NotFound,"没有找到TAO子订单erp信息：");
//                }
//            }else{
//                log.info("没有找到TAO订单erp信息："+jdVcRefund.getCustomOrderId());
//                return ResultVo.error(ResultVoEnum.NotFound,"没有找到TAO订单erp信息："+jdVcRefund.getCustomOrderId());
//            }

            insert.setOrderNum(refundDetail.getString("customOrderId"));
            insert.setSkuId(refundDetail.getString("skuId"));
            List<OOrderItem> oOrderItems = orderItemMapper.selectList(
                    new LambdaQueryWrapper<OOrderItem>()
                            .eq(OOrderItem::getOrderNum, insert.getOrderNum())
                            .eq(OOrderItem::getSkuId, insert.getSkuId())
            );
            insert.setOrderItemNum(oOrderItems.isEmpty() ? insert.getOrderNum()+"-"+insert.getSkuId() : oOrderItems.get(0).getSubOrderNum());
//            insert.setOrderItemNum(refundDetail.getString("customOrderId")+"-"+refundDetail.getString("skuId"));
            // 查找skuId绑定的商品库关系

            ShopGoodsSku shopGoodsSku = shopGoodsSkuService.selectByPlatformSkuId(platformSkuId, shopId);
            if (shopGoodsSku != null) {
                insert.setGoodsId(shopGoodsSku.getErpGoodsId());
                insert.setGoodsSkuId(shopGoodsSku.getErpGoodsSkuId());
            } else {
                insert.setGoodsId(0L);
                insert.setGoodsSkuId(0L);
            }
//            insert.setGoodsId(refundDetail.getLong("erpGoodsId"));
//            insert.setGoodsSkuId(refundDetail.getLong("erpGoodsSkuId"));
            insert.setSkuNum(refundDetail.getString("skuId"));
            insert.setGoodsName(refundDetail.getString("commodityName"));
            insert.setGoodsSku("");
            insert.setGoodsImage("");
            insert.setQuantity(refundDetail.getInteger("commodityNum"));

            insert.setRefundReason(refundDetail.getString("roReason"));
            insert.setShippingStatus(refundDetail.getInteger("shippingStatus"));
            insert.setStatus(refundStatus);
            insert.setHasProcessing(hasProcessing);
            insert.setPlatformStatus(platformStatus);
            insert.setPlatformStatusText(platformStatusText);
            insert.setErpStatus(0);
            insert.setRefundFee(refundDetail.getDouble("roApplyFee"));
            // todo:少了一個退款申請時間
            insert.setCreateTime(new Date());
            insert.setCreateBy("REFUND_MESSAGE");
            mapper.insert(insert);
            //更新子订单状态
            if(oOrderItems!=null && oOrderItems.size()>0){
                for (OOrderItem oOrderItem : oOrderItems) {
                    // 更新订单库子订单状态
                    OOrderItem itemUpdate = new OOrderItem();
                    itemUpdate.setRefundStatus(2);
                    itemUpdate.setUpdateBy("退款消息");
                    itemUpdate.setUpdateTime(new Date());
                    itemUpdate.setId(oOrderItem.getId());
                    orderItemMapper.updateById(itemUpdate);
                    // 更新发货子订单状态
                    List<OOrderStockingItem> oOrderStockingItems = orderStockingItemMapper.selectList(new LambdaQueryWrapper<OOrderStockingItem>().eq(OOrderStockingItem::getOOrderItemId, oOrderItem.getId()));
                    if(oOrderStockingItems!=null && oOrderStockingItems.size()>0){
                        for (OOrderStockingItem oOrderStockingItem : oOrderStockingItems) {
                            OOrderStockingItem stockingItem = new OOrderStockingItem();
                            stockingItem.setId(oOrderStockingItem.getId());
                            stockingItem.setRefundStatus(2);
                            stockingItem.setUpdateTime(new Date());
                            stockingItem.setUpdateBy("退款消息");
                            orderStockingItemMapper.updateById(stockingItem);
                        }
                    }
                }
            }
        } else {
            // 修改
            ORefund update = new ORefund();
            update.setId(oRefunds.get(0).getId());
            update.setRefundType(refundType);
            update.setHasGoodReturn(hasReturnGoods);
            // 查找skuId绑定的商品库关系
            ShopGoodsSku shopGoodsSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(platformSkuId, shopId);
            if (shopGoodsSkuMapping != null) {
                update.setGoodsId(shopGoodsSkuMapping.getErpGoodsId());
                update.setGoodsSkuId(shopGoodsSkuMapping.getErpGoodsSkuId());
            } else {
                update.setGoodsId(0L);
                update.setGoodsSkuId(0L);
            }
//            update.setGoodsId(refundDetail.getLong("erpGoodsId"));
//            update.setGoodsSkuId(refundDetail.getLong("erpGoodsSkuId"));
            update.setRefundFee(refundDetail.getDouble("roApplyFee"));
            update.setShippingStatus(refundDetail.getInteger("shippingStatus"));
            update.setStatus(refundStatus);
            if(oRefunds.get(0).getHasProcessing().intValue() ==0) update.setHasProcessing(hasProcessing);
            update.setPlatformStatus(platformStatus);
            update.setPlatformStatusText(platformStatusText);
//                update.setStatus(jdAfter.getServiceStatus());
            update.setUpdateTime(new Date());
            update.setUpdateBy("REFUND_MESSAGE");
            mapper.updateById(update);
        }
        // 更新主订单状态
        List<OOrder> oOrders = orderMapper.selectList(new LambdaQueryWrapper<OOrder>().eq(OOrder::getOrderNum, orderNum).eq(OOrder::getShopId, shopId).eq(OOrder::getShopType, EnumShopType.JDVC.getIndex()));
        if(oOrders!=null && oOrders.size()>0){
            for (OOrder oOrder : oOrders) {
                // 查询子订单是否全部退款
                List<OOrderItem> oOrderItems = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                        .eq(OOrderItem::getOrderId, oOrder.getId())
                        .eq(OOrderItem::getRefundStatus, 1)
                );
                // 找出没有退款的子订单，如果没有，那么把主订单直接更新成取消状态
                if (oOrderItems == null || oOrderItems.isEmpty()) {
                    OOrder orderUpdate = new OOrder();
                    orderUpdate.setId(oOrder.getId());
                    orderUpdate.setOrderStatus(11);
                    orderUpdate.setCancelReason("子订单全部退款");
                    orderUpdate.setUpdateBy("子订单全部退款");
                    orderUpdate.setUpdateTime(new Date());
                    orderMapper.updateById(orderUpdate);
                }

                // 查找发货订单
                List<OOrderStocking> oOrderStockings = orderStockingMapper.selectList(new LambdaQueryWrapper<OOrderStocking>().eq(OOrderStocking::getOOrderId, oOrder.getId()));
                if(oOrderStockings!=null && oOrderStockings.size()>0){
                    for (OOrderStocking oOrderStocking : oOrderStockings) {
                        // 查找发货子订单是否全部退款
                        List<OOrderStockingItem> shipOrderItemList = orderStockingItemMapper.selectList(
                                new LambdaQueryWrapper<OOrderStockingItem>()
                                        .eq(OOrderStockingItem::getShipOrderId, oOrderStocking.getId())
                                        .eq(OOrderStockingItem::getRefundStatus, 1)
                        );
                        // 找出没有退款的子订单，如果没有，那么把主订单直接更新成取消状态
                        if (shipOrderItemList == null || shipOrderItemList.isEmpty()) {
                            OOrderStocking updateShip = new OOrderStocking();
                            updateShip.setId(oOrderStocking.getId());
                            updateShip.setOrderStatus(11);
                            updateShip.setUpdateBy("子订单全部退款");
                            updateShip.setUpdateTime(new Date());
                            orderStockingMapper.updateById(updateShip);
                        }
                    }
                }
            }
        }
        log.info("==========jdvc退款同步成功=======");

        return ResultVo.success();
    }

    @Transactional
    @Override
    public ResultVo<Integer> taoRefundMessage(String refundId,JSONObject refundDetail) {
        log.info("TAO退款消息处理" + refundId);
//        log.info("=====tao refund message===消息处理" + refundId);
//        JSONObject jsonObject = taoApiService.getRefundDetail(Long.parseLong(refundId));
//        if(jsonObject.getInteger("code")!=200 || jsonObject.getJSONObject("data") ==null){
//            log.info("=====tao refund message===没有找到退款单");
//            return ResultVo.error(404,"没有找到退款单");
//        }
//
//        JSONObject refundDetail = jsonObject.getJSONObject("data");
//        log.info("=====tao refund message===退款单:"+JSONObject.toJSONString(refundDetail));
//        List<TaoRefund> refundList = taoRefundMapper.selectList(new LambdaQueryWrapper<TaoRefund>().eq(TaoRefund::getRefundId, refundId));
//        if (refundList == null || refundList.size() == 0) {
//            // 没有找到订单信息
//            log.info("没有找到TAO售后单："+refundId);
//            return ResultVo.error(ResultVoEnum.NotFound, "没有找到TAO售后单：" + refundId);
//        }
//        TaoRefund taoRefund = refundList.get(0);
//        List<TaoOrderItem> taoOrderItems = taoOrderItemMapper.selectList(new LambdaQueryWrapper<TaoOrderItem>().eq(TaoOrderItem::getOid, taoRefund.getOid()));
//        if(taoOrderItems == null || taoOrderItems.size()==0) {
//            log.info("没有找到TAO子订单："+taoRefund.getOid());
//            return ResultVo.error(ResultVoEnum.NotFound, "没有找到TAO子订单：" + taoRefund.getOid());
//        }
        // 查询ERP订单
//        OOrder order = null;
//        OOrderItem orderItem = null;
//        List<OOrder> oOrders = orderMapper.selectList(new LambdaQueryWrapper<OOrder>().eq(OOrder::getOrderNum, taoRefund.getTid()).eq(OOrder::getShopId, taoRefund.getShopId()));
//        if(oOrders!=null && oOrders.size()>0){
//            order = oOrders.get(0);
//            List<OOrderItem> oOrderItems = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>().eq(OOrderItem::getOrderId, oOrders.get(0).getId()).eq(OOrderItem::getSubOrderNum, taoRefund.getOid()));
//            if(oOrderItems!=null && oOrderItems.size()>0){
//                orderItem = oOrderItems.get(0);
//            }else{
//                log.info("没有找到TAO子订单erp信息："+taoRefund.getOid());
//                return ResultVo.error(ResultVoEnum.NotFound,"没有找到TAO子订单erp信息："+taoRefund.getOid());
//            }
//        }else{
//            log.info("没有找到TAO订单erp信息："+taoRefund.getOid());
//            return ResultVo.error(ResultVoEnum.NotFound,"没有找到TAO订单erp信息："+taoRefund.getTid());
//        }
        String orderNum = refundDetail.getString("tid");
        Long shopId = refundDetail.getLong("shopId");
        String platformSkuId = refundDetail.getString("skuId");
        List<ORefund> oRefunds = mapper.selectList(new LambdaQueryWrapper<ORefund>().eq(ORefund::getRefundNum, refundId));
        /**
         * 状态（10001待审核 10002等待买家退货 10003等待平台审核 10004待买家处理 10005等待卖家处理 10006等待卖家发货 14000拒绝退款 10011退款关闭 10010退款完成 10020售后成功 10021售后失败 10090退款中 10091换货成功 10092换货失败 10093维修关闭 10094维修成功 ）
         *
         * 新状态：售后状态 0：售后申请 1：售后关闭，2：售后处理中，3：退款中，4： 售后成功
         */
        Integer refundStatus = 0;
        Integer hasProcessing=0;//是否处理0未处理1已处理9无需处理
        String platformStatus = refundDetail.getString("status");
        String platformStatusText = "";
        //退款状态。WAIT_SELLER_AGREE(买家已经申请退款，等待卖家同意) WAIT_BUYER_RETURN_GOODS(卖家已经同意退款，等待买家退货) WAIT_SELLER_CONFIRM_GOODS(买家已经退货，等待卖家确认收货)
        // SELLER_REFUSE_BUYER(卖家拒绝退款) CLOSED(退款关闭) SUCCESS(退款成功)
        if(refundDetail.getString("status").equals("WAIT_SELLER_AGREE")){
            // 10001-待审核
//            status = 10001;
            refundStatus = 0;
            platformStatusText = "买家已经申请退款，等待卖家同意";
        }else if(refundDetail.getString("status").equals("WAIT_BUYER_RETURN_GOODS")){
            // 10002-等待买家退货(待客户反馈)
//            status = 10002;
            refundStatus = 2;
            platformStatusText="卖家已经同意退款，等待买家退货";
        }else if(refundDetail.getString("status").equals("WAIT_SELLER_CONFIRM_GOODS")){
            // 10005-等待卖家确认收货(待收货)
//            status = 10005;
            refundStatus = 2;
            platformStatusText = "买家已经退货，等待卖家确认收货";
        }else if(refundDetail.getString("status").equals("SELLER_REFUSE_BUYER")){
            // 14000-卖家拒绝退款
//            status = 14000;
            refundStatus = 2;
            platformStatusText ="卖家拒绝退款";
        }else if(refundDetail.getString("status").equals("CLOSED")){
            // 10011-退款关闭（取消）
//            status = 10011;
            refundStatus = 1;
            hasProcessing = 9;
            platformStatusText ="退款关闭";
        }else if(refundDetail.getString("status").equals("SUCCESS")){
            // 10010-退款成功（完成）
//            status = 10010;
            refundStatus = 4;
            platformStatusText = "退款成功";
        }
        if (oRefunds == null || oRefunds.isEmpty()) {
            log.info("TAO退款消息处理=======新增：{}",refundId);
            // 新增
            ORefund insert = new ORefund();
            insert.setRefundNum(refundId);
            // (1-售前退款 10-退货 20-换货 30-维修 40-大家电安装 50-大家电移机 60-大家电增值服务 70-上门维修 90-优鲜赔 80-补发商品 100-试用收回 11-仅退款)
            Integer refundType = null;
            // REFUND(仅退款),REFUND_AND_RETURN(退货退款),TMALL_EXCHANGE(天猫换货),TAOBAO_EXCHANGE(淘宝换货),REPAIR(维修),RESHIPPING(补寄),OTHERS(其他)
            if (refundDetail.getString("disputeType").equals("REFUND")) {
                refundType = 11;
            } else if (refundDetail.getString("disputeType").equals("REFUND_AND_RETURN")) {
                refundType = 10;
            } else if (refundDetail.getString("disputeType").equals("TMALL_EXCHANGE") || refundDetail.getString("disputeType").equals("TAOBAO_EXCHANGE")) {
                refundType = 20;
            } else if (refundDetail.getString("disputeType").equals("REPAIR")) {
                refundType = 30;
            } else if (refundDetail.getString("disputeType").equals("RESHIPPING")) {
                refundType = 80;
            } else if (refundDetail.getString("disputeType").equals("OTHERS")) {
                refundType = 0;
            }
            insert.setRefundType(refundType);
            insert.setHasGoodReturn(refundDetail.getInteger("hasGoodReturn"));
            insert.setShopId(refundDetail.getLong("shopId"));
            insert.setShopType(EnumShopType.TAO.getIndex());
            insert.setMerchantId(refundDetail.getLong("merchantId"));
            insert.setOrderNum(refundDetail.getString("tid"));
            insert.setOrderItemNum(refundDetail.getString("oid"));
            insert.setSkuId(refundDetail.getString("skuId"));
            // 查找skuId绑定的商品库关系
            var shopGoodsSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(platformSkuId, shopId);
            if (shopGoodsSkuMapping != null) {
                insert.setGoodsId(shopGoodsSkuMapping.getErpGoodsId());
                insert.setGoodsSkuId(shopGoodsSkuMapping.getErpGoodsSkuId());
            } else {
                insert.setGoodsId(0L);
                insert.setGoodsSkuId(0L);
            }
//            insert.setGoodsId(refundDetail.getLong("erpGoodsId"));
//            insert.setGoodsSkuId(refundDetail.getLong("erpGoodsSkuId"));
            insert.setSkuNum(refundDetail.getString("outerId"));
            insert.setGoodsName(refundDetail.getString("title"));
            insert.setGoodsSku(refundDetail.getString("sku"));
//            insert.setGoodsImage(refundDetail.getString("oGoodsSkuId"));
            insert.setQuantity(refundDetail.getInteger("num"));
            insert.setShippingStatus(refundDetail.getInteger("shippingStatus"));
            insert.setStatus(refundStatus);
            insert.setHasProcessing(hasProcessing);
            insert.setPlatformStatus(platformStatus);
            insert.setPlatformStatusText(platformStatusText);
            insert.setErpStatus(0);
            insert.setRefundFee(refundDetail.getDouble("refundFee"));
            insert.setOrderAmount(refundDetail.getDouble("totalFee"));
            insert.setRefundReason(refundDetail.getString("reason"));
            insert.setRemark(refundDetail.getString("desc1"));
//            insert.setContactperson(taoRefund.getCustomerName());
//            insert.setMobile(taoRefund.getCustomerTel());
//            insert.setAddress(taoRefund.getPickwareAddress());

            insert.setCreateTime(new Date());
            insert.setCreateBy("REFUND_MESSAGE");
            mapper.insert(insert);

            //更新子订单状态
            List<OOrderItem> oOrderItems = orderItemMapper.selectList(
                    new LambdaQueryWrapper<OOrderItem>()
                            .eq(OOrderItem::getSubOrderNum, insert.getOrderItemNum())
            );
            if(oOrderItems!=null && oOrderItems.size()>0){
                for (OOrderItem oOrderItem : oOrderItems) {
                    // 更新订单库子订单状态
                    OOrderItem itemUpdate = new OOrderItem();
                    itemUpdate.setRefundStatus(2);
                    itemUpdate.setUpdateBy("退款消息");
                    itemUpdate.setUpdateTime(new Date());
                    itemUpdate.setId(oOrderItem.getId());
                    orderItemMapper.updateById(itemUpdate);
                    // 更新发货子订单状态
                    List<OOrderStockingItem> oOrderStockingItems = orderStockingItemMapper.selectList(new LambdaQueryWrapper<OOrderStockingItem>().eq(OOrderStockingItem::getOOrderItemId, oOrderItem.getId()));
                    if(oOrderStockingItems!=null && oOrderStockingItems.size()>0){
                        for (OOrderStockingItem oOrderStockingItem : oOrderStockingItems) {
                            OOrderStockingItem stockingItem = new OOrderStockingItem();
                            stockingItem.setId(oOrderStockingItem.getId());
                            stockingItem.setRefundStatus(2);
                            stockingItem.setUpdateTime(new Date());
                            stockingItem.setUpdateBy("退款消息");
                            orderStockingItemMapper.updateById(stockingItem);
                        }
                    }
                }
            }
        } else {
            log.info("TAO退款消息处理=======修改：{}",refundId);
            // 修改
            ORefund update = new ORefund();
            update.setId(oRefunds.get(0).getId());
            update.setHasGoodReturn(refundDetail.getInteger("hasGoodReturn"));
//            Integer status= null;
//            //退款状态。WAIT_SELLER_AGREE(买家已经申请退款，等待卖家同意) WAIT_BUYER_RETURN_GOODS(卖家已经同意退款，等待买家退货) WAIT_SELLER_CONFIRM_GOODS(买家已经退货，等待卖家确认收货)
//            // SELLER_REFUSE_BUYER(卖家拒绝退款) CLOSED(退款关闭) SUCCESS(退款成功)
//            if(taoRefund.getStatus().equals("WAIT_SELLER_AGREE")){
//                // 10001-待审核
//                status = 10001;
//            }else if(taoRefund.getStatus().equals("WAIT_BUYER_RETURN_GOODS")){
//                // 10002-等待买家退货(待客户反馈)
//                status = 10002;
//            }else if(taoRefund.getStatus().equals("WAIT_SELLER_CONFIRM_GOODS")){
//                // 10005-等待卖家确认收货(待收货)
//                status = 10005;
//            }else if(taoRefund.getStatus().equals("SELLER_REFUSE_BUYER")){
//                // 14000-卖家拒绝退款
//                status = 14000;
//            }else if(taoRefund.getStatus().equals("CLOSED")){
//                // 10011-退款关闭（取消）
//                status = 10011;
//            }else if(taoRefund.getStatus().equals("SUCCESS")){
//                // 10010-退款成功（完成）
//                status = 10010;
//            }
            update.setOrderNum(refundDetail.getString("tid"));
            update.setOrderItemNum(refundDetail.getString("oid"));
            update.setSkuId(refundDetail.getString("skuId"));

            // 查找skuId绑定的商品库关系
            var shopGoodsSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(platformSkuId, shopId);
            if (shopGoodsSkuMapping != null) {
                update.setGoodsId(shopGoodsSkuMapping.getErpGoodsId());
                update.setGoodsSkuId(shopGoodsSkuMapping.getErpGoodsSkuId());
            } else {
                update.setGoodsId(0L);
                update.setGoodsSkuId(0L);
            }
//            update.setGoodsId(refundDetail.getLong("erpGoodsId"));
//            update.setGoodsSkuId(refundDetail.getLong("erpGoodsSkuId"));
            update.setSkuNum(refundDetail.getString("outerId"));
            update.setRefundFee(refundDetail.getDouble("refundFee"));
            update.setOrderAmount(refundDetail.getDouble("totalFee"));
            update.setShippingStatus(refundDetail.getInteger("shippingStatus"));
            update.setStatus(refundStatus);
            if(oRefunds.get(0).getHasProcessing().intValue() ==0) update.setHasProcessing(hasProcessing);
            update.setPlatformStatus(platformStatus);
            update.setPlatformStatusText(platformStatusText);
            update.setUpdateTime(new Date());
            update.setUpdateBy("REFUND_MESSAGE");
            mapper.updateById(update);
        }
        // 更新主订单状态
        List<OOrder> oOrders = orderMapper.selectList(new LambdaQueryWrapper<OOrder>().eq(OOrder::getOrderNum, orderNum).eq(OOrder::getShopId, shopId).eq(OOrder::getShopType, EnumShopType.TAO.getIndex()));
        if(oOrders!=null && oOrders.size()>0){
            for (OOrder oOrder : oOrders) {
                // 查询子订单是否全部退款
                List<OOrderItem> oOrderItems = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                        .eq(OOrderItem::getOrderId, oOrder.getId())
                        .eq(OOrderItem::getRefundStatus, 1)
                );
                // 找出没有退款的子订单，如果没有，那么把主订单直接更新成取消状态
                if (oOrderItems == null || oOrderItems.isEmpty()) {
                    OOrder orderUpdate = new OOrder();
                    orderUpdate.setId(oOrder.getId());
                    orderUpdate.setOrderStatus(11);
                    orderUpdate.setCancelReason("子订单全部退款");
                    orderUpdate.setUpdateBy("子订单全部退款");
                    orderUpdate.setUpdateTime(new Date());
                    orderMapper.updateById(orderUpdate);
                }

                // 查找发货订单
                List<OOrderStocking> oOrderStockings = orderStockingMapper.selectList(new LambdaQueryWrapper<OOrderStocking>().eq(OOrderStocking::getOOrderId, oOrder.getId()));
                if(oOrderStockings!=null && oOrderStockings.size()>0){
                    for (OOrderStocking oOrderStocking : oOrderStockings) {
                        // 查找发货子订单是否全部退款
                        List<OOrderStockingItem> shipOrderItemList = orderStockingItemMapper.selectList(
                                new LambdaQueryWrapper<OOrderStockingItem>()
                                        .eq(OOrderStockingItem::getShipOrderId, oOrderStocking.getId())
                                        .eq(OOrderStockingItem::getRefundStatus, 1)
                        );
                        // 找出没有退款的子订单，如果没有，那么把主订单直接更新成取消状态
                        if (shipOrderItemList == null || shipOrderItemList.isEmpty()) {
                            OOrderStocking updateShip = new OOrderStocking();
                            updateShip.setId(oOrderStocking.getId());
                            updateShip.setOrderStatus(11);
                            updateShip.setUpdateBy("子订单全部退款");
                            updateShip.setUpdateTime(new Date());
                            orderStockingMapper.updateById(updateShip);
                        }
                    }
                }
            }
        }
        log.info("==========tao退款同步成功=======");
        return ResultVo.success();
    }

    @Transactional
    @Override
    public ResultVo<Integer> pddRefundMessage(String refundId,JSONObject refundDetail) {
        log.info("=====pdd refund message===消息处理" + refundId);
//        JSONObject jsonObject = pddApiService.getRefundDetail(Long.parseLong(refundId));
//        if(jsonObject.getInteger("code")!=200 || jsonObject.getJSONObject("data") ==null){
//            log.info("=====pdd refund message===没有找到退款单");
//            return ResultVo.error(404,"没有找到退款单");
//        }
//
//        JSONObject refundDetail = jsonObject.getJSONObject("data");
//        log.info("=====pdd refund message===退款单:"+JSONObject.toJSONString(refundDetail));

//        List<PddRefund> refundList = pddRefundMapper.selectList(new LambdaQueryWrapper<PddRefund>().eq(PddRefund::getId, refundId));
//        if (refundList == null || refundList.size() == 0) {
//            // 没有找到订单信息
//            log.info("没有找到PDD售后单："+refundId);
//            return ResultVo.error(ResultVoEnum.NotFound, "没有找到PDD售后单：" + refundId);
//        }
//        PddRefund originRefund = refundList.get(0);

        // 查询ERP订单
//        OOrder order = null;
//        OOrderItem orderItem = null;
//        List<OOrder> oOrders = orderMapper.selectList(
//                new LambdaQueryWrapper<OOrder>()
//                        .eq(OOrder::getOrderNum, originRefund.getOrderSn())
//                        .eq(OOrder::getShopId, originRefund.getShopId())
//        );
//
//        if(oOrders!=null && oOrders.size()>0){
//            order = oOrders.get(0);
//            List<OOrderItem> oOrderItems = orderItemMapper.selectList(
//                    new LambdaQueryWrapper<OOrderItem>()
//                            .eq(OOrderItem::getOrderNum, oOrders.get(0).getId())
//                            .eq(OOrderItem::getSkuId, originRefund.getSkuId())
//            );

//            if(oOrderItems!=null && oOrderItems.size()>0){
//                orderItem = oOrderItems.get(0);
//            }else{
//                log.info("没有找到PDD子订单erp信息："+originRefund.getOrderSn()+"===="+originRefund.getSkuId());
//                return ResultVo.error(ResultVoEnum.NotFound,"没有找到PDD子订单erp信息："+originRefund.getOrderSn()+"===="+originRefund.getSkuId());
//            }
//        }else{
//            log.info("没有找到PDD订单erp信息："+originRefund.getOrderSn());
//            return ResultVo.error(ResultVoEnum.NotFound,"没有找到PDD订单erp信息："+originRefund.getOrderSn());
//        }
        String orderNum = refundDetail.getString("orderSn");
        Long shopId = refundDetail.getLong("shopId");
        String platformSkuId = refundDetail.getString("skuId");
        /**
         * 状态（10001待审核 10002等待买家退货 10003等待平台审核 10004待买家处理 10005等待卖家处理 10006等待卖家发货 14000拒绝退款 10011退款关闭 10010退款完成 10020售后成功 10021售后失败 10090退款中 10091换货成功 10092换货失败 10093维修关闭 10094维修成功 ）
         *
         * 新状态：售后状态 0：售后申请 1：售后关闭，2：售后处理中，3：退款中，4： 售后成功
         */
        Integer refundStatus = 0;
        Integer hasProcessing=0;//是否处理0未处理1已处理9无需处理

        String platformStatus = refundDetail.getString("afterSalesStatus");
        String platformStatusText = "";
        //退款状态O_Refund
        // 状态（10001待审核 10002等待买家退货 10003等待平台审核 10004待买家处理 10005等待卖家处理 10006等待卖家发货 14000拒绝退款 10011退款关闭 10010退款完成 10090退款中 10091换货成功 10092换货失败 10093维修关闭 10094维修成功 ）

        // PDD 售后状态
        // (10001) 2：买家申请退款，待商家处理 3：退货退款，待商家处理
        // (10090) 4：商家同意退款，退款中 5：平台同意退款，退款中
        // (10004) 6：驳回退款，待买家处理
        // (10002) 7：已同意退货退款,待用户发货
        // (10003) 8：平台处理中
        // (10011) 9：平台拒绝退款，退款关闭
        // (10010) 10：退款成功
        // (10011) 11：买家撤销  12：买家逾期未处理，退款失败 13：买家逾期，超过有效期
        // (10005) 14：换货补寄待商家处理  21：待商家同意维修 33：待商家召回
        // (10004) 15：换货补寄待用户处理 18：换货补寄待用户确认完成  27：待用户确认收货 22：待用户确认发货  31：已同意拒收退款，待用户拒收
        // (10091) 16：换货补寄成功
        // (10092) 17：换货补寄失败
        // (10093) 24：维修关闭
        // (10094) 25：维修成功
        // (10006) 32：补寄待商家发货
        Integer afterSalesStatus = refundDetail.getInteger("afterSalesStatus");
        if(afterSalesStatus== 2 ||afterSalesStatus == 3){
            // 10001-待审核(待商家处理)
//            status = 10001;
            refundStatus = 0;
            if(afterSalesStatus == 2) platformStatusText = "买家申请退款，待商家处理";
            else if(afterSalesStatus == 3) platformStatusText = "退货退款，待商家处理";

        }else if(afterSalesStatus==4 ||afterSalesStatus== 5){
            // 10090退款中
//            status = 10090;
            refundStatus = 3;
            if(afterSalesStatus == 4) platformStatusText = "商家同意退款，退款中";
            else if(afterSalesStatus == 5) platformStatusText = "平台同意退款，退款中";

        }else if(afterSalesStatus == 6 ){
            // 10004 驳回退款，待买家处理
//            status = 10004;
            refundStatus = 2;
            platformStatusText = "驳回退款，待买家处理";
        }else if(afterSalesStatus == 7 ){
            // 10002等待买家退货
//            status = 10002;
            refundStatus = 2;
            platformStatusText = "已同意退货退款,待用户发货";
        }else if(afterSalesStatus == 8 ){
            // 10003等待平台审核
//            status = 10003;
            refundStatus = 2;
            platformStatusText = "平台处理中";
        }else if(afterSalesStatus == 9 ||afterSalesStatus == 11||afterSalesStatus == 12||afterSalesStatus == 13){
            // 10011退款关闭
//            status = 10011;
            refundStatus = 1;
            hasProcessing = 9;
            if(afterSalesStatus == 9) platformStatusText = "平台拒绝退款，退款关闭";
            else if(afterSalesStatus == 11) platformStatusText = "买家撤销";
            else if(afterSalesStatus == 12) platformStatusText = "买家逾期未处理，退款失败";
            else if(afterSalesStatus == 13) platformStatusText = "买家逾期，超过有效期";
        }else if(afterSalesStatus == 10 ){
            // 10010退款完成
//            status = 10010;
            refundStatus = 4;
            platformStatusText = "退款成功";
        }else if(afterSalesStatus == 14 ||afterSalesStatus == 21||afterSalesStatus== 33){
            // 10005等待卖家处理
//            status = 10005;
            refundStatus = 2;
            if(afterSalesStatus == 14) platformStatusText = "换货补寄待商家处理";
            else if(afterSalesStatus == 21) platformStatusText = "待商家同意维修";
            else if(afterSalesStatus == 33) platformStatusText = "待商家召回";
        }else if(afterSalesStatus == 15 ||afterSalesStatus== 18||afterSalesStatus == 22||afterSalesStatus == 27||afterSalesStatus == 31){
            // 10004待买家处理
//            status = 10004;
            refundStatus = 2;
            if(afterSalesStatus == 15) platformStatusText = "换货补寄待用户处理";
            else if(afterSalesStatus == 18) platformStatusText = "换货补寄待用户确认完成";
            else if(afterSalesStatus == 22) platformStatusText = "待用户确认发货";
            else if(afterSalesStatus == 27) platformStatusText = "待用户确认收货";
            else if(afterSalesStatus == 31) platformStatusText = "已同意拒收退款，待用户拒收";
        }else if(afterSalesStatus == 32 ){
            // 10006等待卖家发货
//            status = 10006;
            refundStatus = 2;
            platformStatusText = "补寄待商家发货";
        }else if(afterSalesStatus == 16 ){
            // 10091换货成功
//            status = 10091;
            refundStatus = 4;
            platformStatusText = "换货补寄成功";
        }else if(afterSalesStatus == 17 ){
            // 10092换货失败
//            status = 10092;
            refundStatus = 2;
            platformStatusText = "换货补寄失败";
        }else if(afterSalesStatus == 24 ){
            // 10093维修关闭
//            status = 10093;
            refundStatus = 1;
            hasProcessing = 9;
            platformStatusText = "维修关闭";
        }else if(afterSalesStatus == 25 ){
            // 10094维修成功
//            status = 10094;
            refundStatus = 4;
            platformStatusText = "维修成功";
        }
        // O_Refund (类型(1-售前退款 10-退货 20-换货 30-维修 40-大家电安装 50-大家电移机 60-大家电增值服务 70-上门维修 90-优鲜赔 80-补发商品 100-试用收回 11-仅退款)
        Integer hasGoodReturn = 0;
        Integer refundType = null;
        // PDD 售后类型 售后类型 1-仅退款，2-退货退款，3-换货，4-补寄，5-维修
        if (refundDetail.getInteger("afterSalesType")==1) {
            refundType = 11;
        } else if (refundDetail.getInteger("afterSalesType")==2) {
            refundType = 10;
            hasGoodReturn = 1;
        } else if (refundDetail.getInteger("afterSalesType")==3) {
            refundType = 20;
            hasGoodReturn = 1;
        } else if (refundDetail.getInteger("afterSalesType")==5) {
            refundType = 30;

        } else if (refundDetail.getInteger("afterSalesType")==4) {
            refundType = 80;
        }
        List<ORefund> oRefunds = mapper.selectList(new LambdaQueryWrapper<ORefund>().eq(ORefund::getRefundNum, refundId));
        if (oRefunds == null || oRefunds.isEmpty()) {
            // 新增
            ORefund insert = new ORefund();
            insert.setRefundNum(refundId);

            insert.setRefundType(refundType);
            insert.setHasGoodReturn(hasGoodReturn);
            insert.setShopId(refundDetail.getLong("shopId"));
            insert.setShopType(EnumShopType.PDD.getIndex());
            insert.setMerchantId(refundDetail.getLong("merchantId"));
            insert.setOrderNum(refundDetail.getString("orderSn"));
            insert.setSkuId(refundDetail.getString("skuId"));
            List<OOrderItem> oOrderItems = orderItemMapper.selectList(
                    new LambdaQueryWrapper<OOrderItem>()
                            .eq(OOrderItem::getOrderNum, insert.getOrderNum())
                            .eq(OOrderItem::getSkuId, insert.getSkuId())
            );
            insert.setOrderItemNum(oOrderItems.isEmpty()?insert.getOrderNum()+"-"+insert.getSkuId():oOrderItems.get(0).getSubOrderNum());
            // 查找skuId绑定的商品库关系
            var shopGoodsSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(platformSkuId, shopId);
            if (shopGoodsSkuMapping != null) {
                insert.setGoodsId(shopGoodsSkuMapping.getErpGoodsId());
                insert.setGoodsSkuId(shopGoodsSkuMapping.getErpGoodsSkuId());
            } else {
                insert.setGoodsId(0L);
                insert.setGoodsSkuId(0L);
            }
//            insert.setGoodsId(refundDetail.getLong("erpGoodsId"));
//            insert.setGoodsSkuId(refundDetail.getLong("erpGoodsSkuId"));
            insert.setSkuNum(refundDetail.getString("outerId"));
            insert.setGoodsName(refundDetail.getString("goodsName"));
            insert.setGoodsSku(refundDetail.getString("goodsSpec"));
            insert.setGoodsImage(refundDetail.getString("goodsImage"));
            insert.setQuantity(refundDetail.getInteger("goodsNumber"));
            insert.setOrderAmount(refundDetail.getDouble("orderAmount"));
            insert.setReturnLogisticsCompany(refundDetail.getString("shippingName"));
            insert.setReturnLogisticsCode(refundDetail.getString("trackingNumber"));
            insert.setShippingStatus(refundDetail.getInteger("shippingStatus"));
            insert.setStatus(refundStatus);
            insert.setHasProcessing(hasProcessing);
            insert.setPlatformStatus(platformStatus);
            insert.setPlatformStatusText(platformStatusText);
            insert.setErpStatus(0);
            insert.setRefundFee(refundDetail.getDouble("refundAmount"));
            insert.setRefundReason(refundDetail.getString("afterSaleReason"));
            insert.setRemark("");
//            insert.setContactperson(taoRefund.getCustomerName());
//            insert.setMobile(taoRefund.getCustomerTel());
//            insert.setAddress(taoRefund.getPickwareAddress());

            insert.setCreateTime(new Date());
            insert.setCreateBy("REFUND_MESSAGE");
            mapper.insert(insert);

            //更新子订单状态
            if(oOrderItems!=null && oOrderItems.size()>0){
                for (OOrderItem oOrderItem : oOrderItems) {
                    // 更新订单库子订单状态
                    OOrderItem itemUpdate = new OOrderItem();
                    itemUpdate.setRefundStatus(2);
                    itemUpdate.setUpdateBy("退款消息");
                    itemUpdate.setUpdateTime(new Date());
                    itemUpdate.setId(oOrderItem.getId());
                    orderItemMapper.updateById(itemUpdate);
                    // 更新发货子订单状态
                    List<OOrderStockingItem> oOrderStockingItems = orderStockingItemMapper.selectList(new LambdaQueryWrapper<OOrderStockingItem>().eq(OOrderStockingItem::getOOrderItemId, oOrderItem.getId()));
                    if(oOrderStockingItems!=null && oOrderStockingItems.size()>0){
                        for (OOrderStockingItem oOrderStockingItem : oOrderStockingItems) {
                            OOrderStockingItem stockingItem = new OOrderStockingItem();
                            stockingItem.setId(oOrderStockingItem.getId());
                            stockingItem.setRefundStatus(2);
                            stockingItem.setUpdateTime(new Date());
                            stockingItem.setUpdateBy("退款消息");
                            orderStockingItemMapper.updateById(stockingItem);
                        }
                    }
                }
            }
        } else {
            // 修改
            ORefund update = new ORefund();
            update.setId(oRefunds.get(0).getId());
            List<OOrderItem> oOrderItems = orderItemMapper.selectList(
                    new LambdaQueryWrapper<OOrderItem>()
                            .eq(OOrderItem::getOrderNum, oRefunds.get(0).getOrderNum())
                            .eq(OOrderItem::getSkuId, oRefunds.get(0).getSkuId())
            );

            update.setOrderItemNum(oOrderItems.isEmpty()?update.getOrderNum():oOrderItems.get(0).getSubOrderNum());
            // 查找skuId绑定的商品库关系
            var shopGoodsSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(platformSkuId, shopId);
            if (shopGoodsSkuMapping != null) {
                update.setGoodsId(shopGoodsSkuMapping.getErpGoodsId());
                update.setGoodsSkuId(shopGoodsSkuMapping.getErpGoodsSkuId());
            } else {
                update.setGoodsId(0L);
                update.setGoodsSkuId(0L);
            }
            update.setSkuNum(refundDetail.getString("outerId"));
            update.setGoodsName(refundDetail.getString("goodsName"));
            update.setGoodsSku(refundDetail.getString("goodsSpec"));
            update.setGoodsImage(refundDetail.getString("goodsImage"));
            update.setQuantity(refundDetail.getInteger("goodsNumber"));
            update.setOrderAmount(refundDetail.getDouble("orderAmount"));
            update.setReturnLogisticsCompany(refundDetail.getString("shippingName"));
            update.setReturnLogisticsCode(refundDetail.getString("trackingNumber"));
            update.setShippingStatus(refundDetail.getInteger("shippingStatus"));
            update.setStatus(refundStatus);
            if(oRefunds.get(0).getHasProcessing().intValue() ==0) update.setHasProcessing(hasProcessing);
//            update.setGoodsId(refundDetail.getLong("erpGoodsId"));
//            update.setGoodsSkuId(refundDetail.getLong("erpGoodsSkuId"));
            update.setRefundType(refundType);
            update.setHasGoodReturn(hasGoodReturn);
            update.setPlatformStatus(platformStatus);
            update.setPlatformStatusText(platformStatusText);
            update.setUpdateTime(new Date());
            update.setUpdateBy("REFUND_MESSAGE");
            mapper.updateById(update);
        }
        // 更新主订单状态
        List<OOrder> oOrders = orderMapper.selectList(new LambdaQueryWrapper<OOrder>().eq(OOrder::getOrderNum, orderNum).eq(OOrder::getShopId, shopId).eq(OOrder::getShopType, EnumShopType.PDD.getIndex()));
        if(oOrders!=null && oOrders.size()>0){
            for (OOrder oOrder : oOrders) {
                // 查询子订单是否全部退款
                List<OOrderItem> oOrderItems = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                        .eq(OOrderItem::getOrderId, oOrder.getId())
                        .eq(OOrderItem::getRefundStatus, 1)
                );
                // 找出没有退款的子订单，如果没有，那么把主订单直接更新成取消状态
                if (oOrderItems == null || oOrderItems.isEmpty()) {
                    OOrder orderUpdate = new OOrder();
                    orderUpdate.setId(oOrder.getId());
                    orderUpdate.setOrderStatus(EnumOOrderStatus.CLOSED.getIndex());
                    orderUpdate.setCancelReason("子订单全部退款");
                    orderUpdate.setUpdateBy("子订单全部退款");
                    orderUpdate.setUpdateTime(new Date());
                    orderMapper.updateById(orderUpdate);
                }

                // 查找发货订单
                List<OOrderStocking> oOrderStockings = orderStockingMapper.selectList(new LambdaQueryWrapper<OOrderStocking>().eq(OOrderStocking::getOOrderId, oOrder.getId()));
                if(oOrderStockings!=null && oOrderStockings.size()>0){
                    for (OOrderStocking oOrderStocking : oOrderStockings) {
                        // 查找发货子订单是否全部退款
                        List<OOrderStockingItem> shipOrderItemList = orderStockingItemMapper.selectList(
                                new LambdaQueryWrapper<OOrderStockingItem>()
                                        .eq(OOrderStockingItem::getShipOrderId, oOrderStocking.getId())
                                        .eq(OOrderStockingItem::getRefundStatus, 1)
                        );
                        // 找出没有退款的子订单，如果没有，那么把主订单直接更新成取消状态
                        if (shipOrderItemList == null || shipOrderItemList.isEmpty()) {
                            OOrderStocking updateShip = new OOrderStocking();
                            updateShip.setId(oOrderStocking.getId());
                            updateShip.setOrderStatus(EnumOOrderStatus.CLOSED.getIndex());
                            updateShip.setUpdateBy("子订单全部退款");
                            updateShip.setUpdateTime(new Date());
                            orderStockingMapper.updateById(updateShip);
                        }
                    }
                }
            }
        }
        log.info("==========pdd退款同步成功=======");
        return ResultVo.success();
    }

    @Transactional
    @Override
    public ResultVo<Integer> douRefundMessage(String refundId,JSONObject refundDetail) {
        log.info("DOU退款消息处理" + refundId);
//        JSONObject jsonObject = douApiService.getRefundDetail(refundId);
//        if(jsonObject.getInteger("code")!=200 || jsonObject.getJSONObject("data") ==null){
//            log.info("=====dou refund message===没有找到退款单");
//            return ResultVo.error(404,"没有找到退款单");
//        }
//
//        JSONObject refundDetail = jsonObject.getJSONObject("data");
//        log.info("=====dou refund message===退款单:"+JSONObject.toJSONString(refundDetail));

//        List<DouRefund> refundList = douRefundMapper.selectList(new LambdaQueryWrapper<DouRefund>().eq(DouRefund::getAftersaleId, refundId));
//        if (refundList == null || refundList.size() == 0) {
//            // 没有找到订单信息
//            log.info("没有找到DOU售后单："+refundId);
//            return ResultVo.error(ResultVoEnum.NotFound, "没有找到DOU售后单：" + refundId);
//        }
//        DouRefund originRefund = refundList.get(0);

        // 查询ERP订单
//        OOrder order = null;
//        OOrderItem orderItem = null;
//        List<OOrder> oOrders = orderMapper.selectList(
//                new LambdaQueryWrapper<OOrder>()
//                        .eq(OOrder::getOrderNum, originRefund.getRelatedId())
//                        .eq(OOrder::getShopId, originRefund.getShopId()));
//
//        if(oOrders!=null && oOrders.size()>0){
//            order = oOrders.get(0);
//            List<OOrderItem> oOrderItems = orderItemMapper.selectList(
//                    new LambdaQueryWrapper<OOrderItem>()
//                            .eq(OOrderItem::getOrderId, oOrders.get(0).getId())
//                            .eq(OOrderItem::getSubOrderNum, originRefund.getOrderSkuOrderId())
//            );
//            if(oOrderItems!=null && oOrderItems.size()>0){
//                orderItem = oOrderItems.get(0);
//            }else{
//                log.info("没有找到DOU子订单erp信息："+ originRefund.getAftersaleId());
//                return ResultVo.error(ResultVoEnum.NotFound,"没有找到DOU子订单erp信息："+originRefund.getAftersaleId());
//            }
//        }else{
//            log.info("没有找到DOU订单erp信息："+originRefund.getAftersaleId());
//            return ResultVo.error(ResultVoEnum.NotFound,"没有找到DOU订单erp信息："+originRefund.getAftersaleId());
//        }
        String orderNum = refundDetail.getString("relatedId");
        Long shopId = refundDetail.getLong("shopId");
        String platformSkuId = refundDetail.getString("skuId");
        //退款状态O_Refund
        // 状态（10001待审核 10002等待买家退货 10003等待平台审核 10004待买家处理 10005等待卖家处理 10006等待卖家发货 14000拒绝退款 10011退款关闭 10010退款完成 10020售后成功 10021售后失败 10090退款中 10091换货成功 10092换货失败 10093维修关闭 10094维修成功 ）
        Integer platformStatus = refundDetail.getInteger("aftersaleStatus");
        String platformStatusText = "";

        /**
         * 状态（10001待审核 10002等待买家退货 10003等待平台审核 10004待买家处理 10005等待卖家处理 10006等待卖家发货 14000拒绝退款 10011退款关闭 10010退款完成 10020售后成功 10021售后失败 10090退款中 10091换货成功 10092换货失败 10093维修关闭 10094维修成功 ）
         *
         * 新状态：售后状态 0：售后申请 1：售后关闭，2：售后处理中，3：退款中，4： 售后成功
         */
        Integer refundStatus = 0;
        Integer hasProcessing=0;//是否处理0未处理1已处理9无需处理

        //DOU退款状态。3-换货待买家收货；6-待商家同意；7-待买家退货；8-待商家发货；11-待商家二次同意；12-售后成功；14-换货成功；27-商家一次拒绝；28-售后失败；29-商家二次拒绝；

        if(platformStatus==3){
            // 10004待买家处理
//            status = 10004;
            refundStatus = 2;
            platformStatusText = "换货待买家收货";
        }else if(platformStatus==6||platformStatus==11){
            // 10005等待卖家处理
//            status = 10005;
            refundStatus = 2;
            if(platformStatus == 6) platformStatusText="待商家同意";
            if(platformStatus == 11) platformStatusText="待商家二次同意";
        }else if(platformStatus==7){
            // 10002等待买家退货
//            status = 10002;
            refundStatus = 2;
            platformStatusText = "待买家退货";
        }else if(platformStatus==8){
            // 10006等待卖家发货
//            status = 10006;
            refundStatus = 2;
            platformStatusText = "待商家发货";
        }else if(platformStatus==12){
            // 10020售后成功
//            status = 10020;
            refundStatus = 4;
            platformStatusText  = "售后成功";
        }else if(platformStatus==14){
            // 10091换货成功
//            status = 10091;
            refundStatus = 4;
            platformStatusText = "换货成功";
        }else if(platformStatus==28){
            // 10021售后失败
//            status = 10021;
            refundStatus = 2;
            platformStatusText="售后失败";
        }else if(platformStatus==27||platformStatus==29){
            // 14000拒绝退款
//            status = 14000;
            refundStatus = 2;
            if(platformStatus==27) platformStatusText="商家一次拒绝";
            if(platformStatus==29) platformStatusText="商家二次拒绝";
        }
        // O_Refund(类型(1-售前退款 10-退货 20-换货 30-维修 40-大家电安装 50-大家电移机 60-大家电增值服务 70-上门维修 90-优鲜赔 80-补发商品 100-试用收回 11-仅退款))
        Integer refundType = null;
        Integer hasGoodReturn = 0;
        // dou_refund售后类型；0-退货退款；1-已发货仅退款；2-未发货仅退款；3-换货；6-价保；7-补寄；8-维修
        if (refundDetail.getInteger("aftersaleType")==0) {
            refundType = 10;
            if(refundDetail.getInteger("gotPkg")==1) {
                hasGoodReturn = 1;
            }
        } else if (refundDetail.getInteger("aftersaleType")==1) {
            refundType = 11;
            if(refundDetail.getInteger("gotPkg")==1) {
                hasGoodReturn = 1;
            }
        } else if (refundDetail.getInteger("aftersaleType")==2) {
            refundType = 1;
        } else if (refundDetail.getInteger("aftersaleType")==3) {
            refundType = 20;
            hasGoodReturn = 1;
        } else if (refundDetail.getInteger("aftersaleType")==7) {
            refundType = 80;
        } else if (refundDetail.getInteger("aftersaleType")==8) {
            refundType = 30;
        }else if (refundDetail.getInteger("aftersaleType")==6) {
            refundType = 0;
        }
        List<ORefund> oRefunds = mapper.selectList(new LambdaQueryWrapper<ORefund>().eq(ORefund::getRefundNum, refundId));
        if (oRefunds == null || oRefunds.isEmpty()) {
            // 新增
            ORefund insert = new ORefund();
            insert.setRefundNum(refundId);
            insert.setRefundType(refundType);
            insert.setHasGoodReturn(hasGoodReturn);
            insert.setShopId(refundDetail.getLong("shopId"));
            insert.setShopType(EnumShopType.DOU.getIndex());
            insert.setMerchantId(refundDetail.getLong("merchantId"));
            insert.setOrderNum(refundDetail.getString("relatedId"));
            insert.setOrderItemNum(refundDetail.getString("orderSkuOrderId"));
            insert.setSkuId(refundDetail.getString("skuId"));

//            insert.setGoodsId(refundDetail.getLong("erpGoodsId"));
//            insert.setGoodsSkuId(refundDetail.getLong("erpGoodsSkuId"));
            // 查找skuId绑定的商品库关系
            var shopGoodsSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(platformSkuId, shopId);
            if (shopGoodsSkuMapping != null) {
                insert.setGoodsId(shopGoodsSkuMapping.getErpGoodsId());
                insert.setGoodsSkuId(shopGoodsSkuMapping.getErpGoodsSkuId());
            } else {
                insert.setGoodsId(0L);
                insert.setGoodsSkuId(0L);
            }
            insert.setSkuNum(refundDetail.getString("outSkuId"));
            insert.setGoodsName(refundDetail.getString("orderProductName"));
            insert.setGoodsSku(refundDetail.getString("orderSkuSpec"));
            insert.setGoodsImage(refundDetail.getString("orderProductImage"));
            insert.setQuantity(refundDetail.getInteger("aftersaleNum"));
            insert.setErpStatus(0);
            insert.setShippingStatus(refundDetail.getInteger("shippingStatus"));
            insert.setStatus(refundStatus);
            insert.setHasProcessing(hasProcessing);
            insert.setPlatformStatus(platformStatus+"");
            insert.setPlatformStatusText(platformStatusText);
            insert.setRefundFee(refundDetail.getDouble("refundAmount")/100);
            insert.setRefundReason("");
            insert.setRemark("");
//            insert.setContactperson(taoRefund.getCustomerName());
//            insert.setMobile(taoRefund.getCustomerTel());
//            insert.setAddress(taoRefund.getPickwareAddress());

            insert.setCreateTime(new Date());
            insert.setCreateBy("REFUND_MESSAGE");
            mapper.insert(insert);

            //更新子订单状态
            List<OOrderItem> oOrderItems = orderItemMapper.selectList(
                    new LambdaQueryWrapper<OOrderItem>()
                            .eq(OOrderItem::getSubOrderNum, insert.getOrderItemNum())
            );
            if(oOrderItems!=null && oOrderItems.size()>0){
                for (OOrderItem oOrderItem : oOrderItems) {
                    // 更新订单库子订单状态
                    OOrderItem itemUpdate = new OOrderItem();
                    itemUpdate.setRefundStatus(2);
                    itemUpdate.setUpdateBy("退款消息");
                    itemUpdate.setUpdateTime(new Date());
                    itemUpdate.setId(oOrderItem.getId());
                    orderItemMapper.updateById(itemUpdate);
                    // 更新发货子订单状态
                    List<OOrderStockingItem> oOrderStockingItems = orderStockingItemMapper.selectList(new LambdaQueryWrapper<OOrderStockingItem>().eq(OOrderStockingItem::getOOrderItemId, oOrderItem.getId()));
                    if(oOrderStockingItems!=null && oOrderStockingItems.size()>0){
                        for (OOrderStockingItem oOrderStockingItem : oOrderStockingItems) {
                            OOrderStockingItem stockingItem = new OOrderStockingItem();
                            stockingItem.setId(oOrderStockingItem.getId());
                            stockingItem.setRefundStatus(2);
                            stockingItem.setUpdateTime(new Date());
                            stockingItem.setUpdateBy("退款消息");
                            orderStockingItemMapper.updateById(stockingItem);
                        }
                    }
                }
            }
        } else {
            // 修改
            ORefund update = new ORefund();
            update.setId(oRefunds.get(0).getId());
            update.setRefundType(refundType);
            update.setHasGoodReturn(hasGoodReturn);
            // 查找skuId绑定的商品库关系
            var shopGoodsSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(platformSkuId, shopId);
            if (shopGoodsSkuMapping != null) {
                update.setGoodsId(shopGoodsSkuMapping.getErpGoodsId());
                update.setGoodsSkuId(shopGoodsSkuMapping.getErpGoodsSkuId());
            } else {
                update.setGoodsId(0L);
                update.setGoodsSkuId(0L);
            }
//            update.setGoodsId(refundDetail.getLong("erpGoodsId"));
//            update.setGoodsSkuId(refundDetail.getLong("erpGoodsSkuId"));
            update.setShippingStatus(refundDetail.getInteger("shippingStatus"));
            update.setStatus(refundStatus);
            if(oRefunds.get(0).getHasProcessing().intValue() ==0) update.setHasProcessing(hasProcessing);
            update.setPlatformStatus(platformStatus+"");
            update.setPlatformStatusText(platformStatusText);
            update.setUpdateTime(new Date());
            update.setUpdateBy("REFUND_MESSAGE");
            mapper.updateById(update);
        }
        // 更新主订单状态
        List<OOrder> oOrders = orderMapper.selectList(new LambdaQueryWrapper<OOrder>().eq(OOrder::getOrderNum, orderNum).eq(OOrder::getShopId, shopId).eq(OOrder::getShopType, EnumShopType.DOU.getIndex()));
        if(oOrders!=null && oOrders.size()>0){
            for (OOrder oOrder : oOrders) {
                // 查询子订单是否全部退款
                List<OOrderItem> oOrderItems = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                        .eq(OOrderItem::getOrderId, oOrder.getId())
                        .eq(OOrderItem::getRefundStatus, 1)
                );
                // 找出没有退款的子订单，如果没有，那么把主订单直接更新成取消状态
                if (oOrderItems == null || oOrderItems.isEmpty()) {
                    OOrder orderUpdate = new OOrder();
                    orderUpdate.setId(oOrder.getId());
                    orderUpdate.setOrderStatus(11);
                    orderUpdate.setCancelReason("子订单全部退款");
                    orderUpdate.setUpdateBy("子订单全部退款");
                    orderUpdate.setUpdateTime(new Date());
                    orderMapper.updateById(orderUpdate);
                }

                // 查找发货订单
                List<OOrderStocking> oOrderStockings = orderStockingMapper.selectList(new LambdaQueryWrapper<OOrderStocking>().eq(OOrderStocking::getOOrderId, oOrder.getId()));
                if(oOrderStockings!=null && oOrderStockings.size()>0){
                    for (OOrderStocking oOrderStocking : oOrderStockings) {
                        // 查找发货子订单是否全部退款
                        List<OOrderStockingItem> shipOrderItemList = orderStockingItemMapper.selectList(
                                new LambdaQueryWrapper<OOrderStockingItem>()
                                        .eq(OOrderStockingItem::getShipOrderId, oOrderStocking.getId())
                                        .eq(OOrderStockingItem::getRefundStatus, 1)
                        );
                        // 找出没有退款的子订单，如果没有，那么把主订单直接更新成取消状态
                        if (shipOrderItemList == null || shipOrderItemList.isEmpty()) {
                            OOrderStocking updateShip = new OOrderStocking();
                            updateShip.setId(oOrderStocking.getId());
                            updateShip.setOrderStatus(11);
                            updateShip.setUpdateBy("子订单全部退款");
                            updateShip.setUpdateTime(new Date());
                            orderStockingMapper.updateById(updateShip);
                        }
                    }
                }
            }
        }
        log.info("==========dou退款同步成功=======");
        return ResultVo.success();
    }

    @Transactional
    @Override
    public ResultVo<Integer> weiRefundMessage(String refundId,JSONObject refundDetail) {
        log.info("WEI退款消息处理" + refundId);
//        JSONObject jsonObject = weiApiService.getRefundDetail(refundId);
//        if (jsonObject.getInteger("code") != 200 || jsonObject.getJSONObject("data") == null) {
//            log.info("=====wei refund message===没有找到退款单");
//            return ResultVo.error(404, "没有找到退款单");
//        }
//
//        JSONObject refundDetail = jsonObject.getJSONObject("data");
//        log.info("=====wei refund message===退款单:" + JSONObject.toJSONString(refundDetail));
        String orderNum = refundDetail.getString("orderId");
        Long shopId = refundDetail.getLong("shopId");
        String platformSkuId = refundDetail.getString("skuId");
        String platformStatus = refundDetail.getString("status");
        String platformStatusText = "";
        String type = refundDetail.getString("type");

        /**
         * 状态（10001待审核 10002等待买家退货 10003等待平台审核 10004待买家处理 10005等待卖家处理 10006等待卖家发货 14000拒绝退款 10011退款关闭 10010退款完成 10020售后成功 10021售后失败 10090退款中 10091换货成功 10092换货失败 10093维修关闭 10094维修成功 ）
         *
         * 新状态：售后状态 0：售后申请 1：售后关闭，2：售后处理中，3：退款中，4： 售后成功
         */
        Integer refundStatus = 0;
        Integer hasProcessing=0;//是否处理0未处理1已处理9无需处理

        Integer refundType = null;
        Integer hasGoodReturn = 0;
        if(platformStatus.equals("USER_CANCELD")||platformStatus.equals("RETURN_CLOSED")||platformStatus.equals("MERCHANT_REFUND_RETRY_FAIL")||platformStatus.equals("MERCHANT_FAIL")){
            //RETURN_CLOSED	退货退款关闭
            //USER_CANCELD	用户取消申请
            //MERCHANT_REFUND_RETRY_FAIL	商家打款失败，客服关闭售后
            //MERCHANT_FAIL	售后关闭
//            refundStatus =10011;
            refundStatus = 1;
            hasProcessing = 9;
            if (platformStatus.equals("USER_CANCELD")) platformStatusText="用户取消申请";
            else if (platformStatus.equals("RETURN_CLOSED")) platformStatusText="退货退款关闭";
            else if (platformStatus.equals("MERCHANT_REFUND_RETRY_FAIL")) platformStatusText="商家打款失败，客服关闭售后";
            else if (platformStatus.equals("MERCHANT_FAIL")) platformStatusText="售后关闭";

        } else if (platformStatus.equals("MERCHANT_REFUND_SUCCESS")||platformStatus.equals("MERCHANT_RETURN_SUCCESS")) {
            //MERCHANT_REFUND_SUCCESS	退款完成
            //MERCHANT_RETURN_SUCCESS	退货退款完成
//            refundStatus =10010;
            refundStatus = 4;
            if (platformStatus.equals("MERCHANT_REFUND_SUCCESS")) platformStatusText="退款完成";
            else if (platformStatus.equals("MERCHANT_RETURN_SUCCESS")) platformStatusText="退货退款完成";

        } else if (platformStatus.equals("MERCHANT_EXCHANGE_SUCCESS")) {
            //MERCHANT_EXCHANGE_SUCCESS	换货完成
//            refundStatus =10091;
            refundStatus = 4;
            platformStatusText="换货完成";
        }else if (platformStatus.equals("MERCHANT_REJECT_RETURN")||platformStatus.equals("MERCHANT_REJECT_REFUND")||platformStatus.equals("MERCHANT_OVERDUE_REFUND")||platformStatus.equals("MERCHANT_REJECT_EXCHANGE")||platformStatus.equals("MERCHANT_REJECT_RESHIP")) {
            //MERCHANT_REJECT_REFUND	商家拒绝退款
            //MERCHANT_REJECT_RETURN	商家拒绝退货退款
            //MERCHANT_OVERDUE_REFUND	商家逾期未退款
            //MERCHANT_REJECT_EXCHANGE	商家拒绝换货
            //MERCHANT_REJECT_RESHIP	商家拒绝发货
//            refundStatus =14000;
            refundStatus = 2;
            if (platformStatus.equals("MERCHANT_REJECT_REFUND")) platformStatusText="商家拒绝退款";
            else if (platformStatus.equals("MERCHANT_REJECT_RETURN")) platformStatusText="商家拒绝退货退款";
            else if (platformStatus.equals("MERCHANT_OVERDUE_REFUND")) platformStatusText="商家逾期未退款";
            else if (platformStatus.equals("MERCHANT_REJECT_EXCHANGE")) platformStatusText="商家拒绝换货";
            else if (platformStatus.equals("MERCHANT_REJECT_RESHIP")) platformStatusText="商家拒绝发货";

        }else if (platformStatus.equals("USER_WAIT_RETURN")) {
            //USER_WAIT_RETURN	待买家退货
//            refundStatus =10002;
            refundStatus = 2;
            platformStatusText="待买家退货";
        }else if (platformStatus.equals("USER_WAIT_RECEIPT")||platformStatus.equals("USER_WAIT_CONFIRM")||platformStatus.equals("USER_WAIT_CONFIRM_UPDATE")||platformStatus.equals("USER_WAIT_HANDLE_MERCHANT_AFTER_SALE")) {
            //USER_WAIT_RECEIPT	待用户收货
            //USER_WAIT_CONFIRM	待用户确认
            //USER_WAIT_CONFIRM_UPDATE	待用户处理商家协商
            //USER_WAIT_HANDLE_MERCHANT_AFTER_SALE	待用户处理商家代发起的售后申请
//            refundStatus =10004;
            refundStatus = 2;
            if (platformStatus.equals("USER_WAIT_RECEIPT")) platformStatusText="待用户收货";
            else if (platformStatus.equals("USER_WAIT_CONFIRM")) platformStatusText="待用户确认";
            else if (platformStatus.equals("USER_WAIT_CONFIRM_UPDATE")) platformStatusText="待用户处理商家协商";
            else if (platformStatus.equals("USER_WAIT_HANDLE_MERCHANT_AFTER_SALE")) platformStatusText="待用户处理商家代发起的售后申请";

        }else if (platformStatus.equals("MERCHANT_PROCESSING")||platformStatus.equals("MERCHANT_WAIT_RECEIPT")||platformStatus.equals("WAIT_PACKAGE_INTERCEPT")) {
            //MERCHANT_PROCESSING	商家受理中
            //MERCHANT_WAIT_RECEIPT	待商家收货
            //WAIT_PACKAGE_INTERCEPT	物流线上拦截中
            refundStatus = 2;
//            refundStatus =10005;
            if (platformStatus.equals("MERCHANT_PROCESSING")) platformStatusText="商家受理中";
            else if (platformStatus.equals("MERCHANT_WAIT_RECEIPT")) platformStatusText="待商家收货";
            else if (platformStatus.equals("WAIT_PACKAGE_INTERCEPT")) platformStatusText="物流线上拦截中";

        }else if (platformStatus.equals("PLATFORM_REFUNDING")||platformStatus.equals("PLATFORM_REFUND_FAIL")) {

            //PLATFORM_REFUNDING	平台退款中
            //PLATFORM_REFUND_FAIL	平台退款失败

            refundStatus = 2;
//            refundStatus = 10090;
            if (platformStatus.equals("PLATFORM_REFUNDING")) platformStatusText = "平台退款中";
            else if (platformStatus.equals("PLATFORM_REFUND_FAIL")) platformStatusText = "平台退款失败";
        }
        //类型(1-售前退款 10-退货 20-换货 30-维修 40-大家电安装 50-大家电移机 60-大家电增值服务 70-上门维修 90-优鲜赔 80-补发商品 100-试用收回 11-仅退款)
        if (type.equals("REFUND")){
            refundType = 11;
            hasGoodReturn =0;
        }else if (type.equals("RETURN")){
            refundType = 10;
            hasGoodReturn =1;
        } else if (type.equals("EXCHANGE")) {
            refundType = 20;
            hasGoodReturn =1;
        }
        List<ORefund> oRefunds = mapper.selectList(new LambdaQueryWrapper<ORefund>().eq(ORefund::getRefundNum, refundId));
        if (oRefunds == null || oRefunds.isEmpty()) {
            // 新增
            ORefund insert = new ORefund();
            insert.setRefundNum(refundId);
            insert.setRefundType(refundType);
            insert.setHasGoodReturn(hasGoodReturn);
            insert.setShopId(refundDetail.getLong("shopId"));
            insert.setShopType(EnumShopType.WEI.getIndex());
            insert.setMerchantId(refundDetail.getLong("merchantId"));
            insert.setOrderNum(refundDetail.getString("orderId"));
            insert.setSkuId(refundDetail.getString("skuId"));

            List<OOrderItem> oOrderItems = orderItemMapper.selectList(
                    new LambdaQueryWrapper<OOrderItem>()
                            .eq(OOrderItem::getOrderNum, insert.getOrderNum())
                            .eq(OOrderItem::getSkuId, insert.getSkuId())
            );
            insert.setOrderItemNum(oOrderItems.isEmpty()?insert.getOrderNum()+"-"+insert.getSkuId():oOrderItems.get(0).getSubOrderNum());
            // 查找skuId绑定的商品库关系
            var shopGoodsSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(platformSkuId, shopId);
            if (shopGoodsSkuMapping != null) {
                insert.setGoodsId(shopGoodsSkuMapping.getErpGoodsId());
                insert.setGoodsSkuId(shopGoodsSkuMapping.getErpGoodsSkuId());
            } else {
                insert.setGoodsId(0L);
                insert.setGoodsSkuId(0L);
            }
//            insert.setGoodsId(refundDetail.getLong("erpGoodsId"));
//            insert.setGoodsSkuId(refundDetail.getLong("erpGoodsSkuId"));
//            insert.setSkuNum(refundDetail.getString("outSkuId"));
            insert.setGoodsName(refundDetail.getString("title"));
            insert.setGoodsSku(refundDetail.getString("skuAttrs"));
            insert.setGoodsImage(refundDetail.getString("img"));
            insert.setQuantity(refundDetail.getInteger("count"));
            insert.setPlatformStatus(platformStatus);
            insert.setPlatformStatusText(platformStatusText);
            insert.setShippingStatus(refundDetail.getInteger("shippingStatus"));
            insert.setStatus(refundStatus);
            insert.setHasProcessing(hasProcessing);
            insert.setErpStatus(0);
            insert.setRefundFee(refundDetail.getDouble("refundAmount")/100);
            insert.setRefundReason(refundDetail.getString("reasonText"));
            insert.setRemark("");
//            insert.setContactperson(taoRefund.getCustomerName());
//            insert.setMobile(taoRefund.getCustomerTel());
//            insert.setAddress(taoRefund.getPickwareAddress());

            insert.setCreateTime(new Date());
            insert.setCreateBy("REFUND_MESSAGE");
            mapper.insert(insert);

            //更新子订单状态
            if(oOrderItems!=null && oOrderItems.size()>0){
                for (OOrderItem oOrderItem : oOrderItems) {
                    // 更新订单库子订单状态
                    OOrderItem itemUpdate = new OOrderItem();
                    itemUpdate.setRefundStatus(2);
                    itemUpdate.setUpdateBy("退款消息");
                    itemUpdate.setUpdateTime(new Date());
                    itemUpdate.setId(oOrderItem.getId());
                    orderItemMapper.updateById(itemUpdate);
                    // 更新发货子订单状态
                    List<OOrderStockingItem> oOrderStockingItems = orderStockingItemMapper.selectList(new LambdaQueryWrapper<OOrderStockingItem>().eq(OOrderStockingItem::getOOrderItemId, oOrderItem.getId()));
                    if(oOrderStockingItems!=null && oOrderStockingItems.size()>0){
                        for (OOrderStockingItem oOrderStockingItem : oOrderStockingItems) {
                            OOrderStockingItem stockingItem = new OOrderStockingItem();
                            stockingItem.setId(oOrderStockingItem.getId());
                            stockingItem.setRefundStatus(2);
                            stockingItem.setUpdateTime(new Date());
                            stockingItem.setUpdateBy("退款消息");
                            orderStockingItemMapper.updateById(stockingItem);
                        }
                    }
                }
            }
        } else {
            // 修改
            ORefund update = new ORefund();
            update.setId(oRefunds.get(0).getId());
            update.setRefundType(refundType);
            update.setHasGoodReturn(hasGoodReturn);
            // 查找skuId绑定的商品库关系
            var shopGoodsSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(platformSkuId, shopId);
            if (shopGoodsSkuMapping != null) {
                update.setGoodsId(shopGoodsSkuMapping.getErpGoodsId());
                update.setGoodsSkuId(shopGoodsSkuMapping.getErpGoodsSkuId());
            } else {
                update.setGoodsId(0L);
                update.setGoodsSkuId(0L);
            }
//            update.setGoodsId(refundDetail.getLong("erpGoodsId"));
//            update.setGoodsSkuId(refundDetail.getLong("erpGoodsSkuId"));
            update.setGoodsName(refundDetail.getString("title"));
            update.setGoodsSku(refundDetail.getString("skuAttrs"));
            update.setGoodsImage(refundDetail.getString("img"));
            update.setShippingStatus(refundDetail.getInteger("shippingStatus"));
            update.setStatus(refundStatus);
            if(oRefunds.get(0).getHasProcessing().intValue() ==0) update.setHasProcessing(hasProcessing);
            update.setPlatformStatus(platformStatus);
            update.setPlatformStatusText(platformStatusText);
            update.setUpdateTime(new Date());
            update.setUpdateBy("REFUND_MESSAGE");
            mapper.updateById(update);
        }
        // 更新主订单状态
        List<OOrder> oOrders = orderMapper.selectList(new LambdaQueryWrapper<OOrder>().eq(OOrder::getOrderNum, orderNum).eq(OOrder::getShopId, shopId).eq(OOrder::getShopType, EnumShopType.WEI.getIndex()));
        if(oOrders!=null && oOrders.size()>0){
            for (OOrder oOrder : oOrders) {
                // 查询子订单是否全部退款
                List<OOrderItem> oOrderItems = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                        .eq(OOrderItem::getOrderId, oOrder.getId())
                        .eq(OOrderItem::getRefundStatus, 1)
                );
                // 找出没有退款的子订单，如果没有，那么把主订单直接更新成取消状态
                if (oOrderItems == null || oOrderItems.isEmpty()) {
                    OOrder orderUpdate = new OOrder();
                    orderUpdate.setId(oOrder.getId());
                    orderUpdate.setOrderStatus(11);
                    orderUpdate.setCancelReason("子订单全部退款");
                    orderUpdate.setUpdateBy("子订单全部退款");
                    orderUpdate.setUpdateTime(new Date());
                    orderMapper.updateById(orderUpdate);
                }

                // 查找发货订单
                List<OOrderStocking> oOrderStockings = orderStockingMapper.selectList(new LambdaQueryWrapper<OOrderStocking>().eq(OOrderStocking::getOOrderId, oOrder.getId()));
                if(oOrderStockings!=null && oOrderStockings.size()>0){
                    for (OOrderStocking oOrderStocking : oOrderStockings) {
                        // 查找发货子订单是否全部退款
                        List<OOrderStockingItem> shipOrderItemList = orderStockingItemMapper.selectList(
                                new LambdaQueryWrapper<OOrderStockingItem>()
                                        .eq(OOrderStockingItem::getShipOrderId, oOrderStocking.getId())
                                        .eq(OOrderStockingItem::getRefundStatus, 1)
                        );
                        // 找出没有退款的子订单，如果没有，那么把主订单直接更新成取消状态
                        if (shipOrderItemList == null || shipOrderItemList.isEmpty()) {
                            OOrderStocking updateShip = new OOrderStocking();
                            updateShip.setId(oOrderStocking.getId());
                            updateShip.setOrderStatus(11);
                            updateShip.setUpdateBy("子订单全部退款");
                            updateShip.setUpdateTime(new Date());
                            orderStockingMapper.updateById(updateShip);
                        }
                    }
                }
            }
        }
        log.info("==========wei退款同步成功=======");
        return ResultVo.success();
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ResultVo<Long> shopRefundMessage(Long shopRefundId) {
//        log.info("============处理店铺售后通知=============");
        ShopRefund shopRefund = shopRefundMapper.selectById(shopRefundId);
        String orderNum = shopRefund.getOrderId();
        Long shopId = shopRefund.getShopId();
        if(shopRefund!=null){
            // 售后状态转换
            Integer hasProcessing = 0;//是否处理0未处理1已处理9无需处理
            //售后状态 0：售后申请 1：售后关闭，2：售后处理中，3：退款中，4： 售后成功
            if(shopRefund.getStatus().intValue()==1){
                hasProcessing = 9;
            }
            // 数据库唯一索引检查
            String refundNum = shopRefund.getAfterId();
            String skuId = shopRefund.getSkuId();
//            Long shopId = shopRefund.getShopId();

            // 使用 SELECT FOR UPDATE 锁定记录
            List<ORefund> oRefunds = mapper.selectList(new LambdaQueryWrapper<ORefund>()
                    .eq(ORefund::getRefundNum, refundNum)
                    .eq(ORefund::getSkuId, skuId)
                    .eq(ORefund::getShopId, shopId)
                    .last("FOR UPDATE") // 行级锁
            );

//            List<ORefund> oRefunds = mapper.selectList(new LambdaQueryWrapper<ORefund>()
//                    .eq(ORefund::getRefundNum, shopRefund.getAfterId())
//                            .eq(ORefund::getSkuId, shopRefund.getSkuId())
//                    .eq(ORefund::getShopId, shopRefund.getShopId())
//            );
//            log.info("=====售后消息：AfterId:{}，SkuId:{}",shopRefund.getAfterId(),shopRefund.getSkuId());
//            log.info("=====售后消息：{}",JSONObject.toJSONString(shopRefund));
//            log.info("=======售后消息，查找到售后库：{}",JSONObject.toJSONString(oRefunds));
            if (oRefunds == null || oRefunds.isEmpty()) {
                // 新增
                ORefund insert = new ORefund();
                insert.setShopId(shopRefund.getShopId());
                insert.setShopType(shopRefund.getShopType());
                insert.setMerchantId(shopRefund.getMerchantId());
                insert.setRefundNum(shopRefund.getAfterId());
                insert.setOrderNum(shopRefund.getOrderId());
                insert.setOrderItemNum(shopRefund.getSubOrderId());
                insert.setRefundType(shopRefund.getType());
                //售后类型。(1-售前退款(取消订单) 10-退货 20-换货 30-维修 40-上门服务 80-补发商品 90-补款 91-返现 11-仅退款)
                if (shopRefund.getType().intValue() == 20 || shopRefund.getType().intValue() == 10) {
                    insert.setHasGoodReturn(1);
                } else {
                    insert.setHasGoodReturn(0);
                }
                Double a = shopRefund.getOrderAmount().doubleValue() / 100;
                insert.setOrderAmount(a);
                BigDecimal refundAmount = new BigDecimal(shopRefund.getRefundAmount()).divide(new BigDecimal(100));
                insert.setRefundFee(refundAmount.doubleValue());
                insert.setRefundReason(shopRefund.getReason());
                insert.setRemark(shopRefund.getRemark());
                insert.setSkuId(shopRefund.getSkuId());
                // 查找skuId绑定的商品库关系
                var shopGoodsSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(shopRefund.getSkuId(), shopRefund.getShopId());
                if (shopGoodsSkuMapping != null) {
                    insert.setGoodsId(shopGoodsSkuMapping.getErpGoodsId());
                    insert.setGoodsSkuId(shopGoodsSkuMapping.getErpGoodsSkuId());
                } else {
                    insert.setGoodsId(0L);
                    insert.setGoodsSkuId(0L);
                }
                insert.setSkuNum(shopRefund.getOuterId());
                insert.setGoodsName(shopRefund.getGoodsName());
                insert.setGoodsImage(shopRefund.getGoodsImage());
                insert.setGoodsSku("");
                insert.setQuantity(shopRefund.getCount());
                insert.setShippingStatus(shopRefund.getOrderShipStatus());
                insert.setPlatformStatus(shopRefund.getStatusCode());
                insert.setPlatformStatusText(shopRefund.getStatusName());
                insert.setReturnLogisticsCompany(shopRefund.getReturnDeliveryName());
                insert.setReturnLogisticsCode(shopRefund.getReturnWaybillId());
                //状态（
                // 10001待审核 10002等待买家退货 10003等待平台审核 10004待买家处理 10005等待卖家处理 10006等待卖家发货
                // 14000拒绝退款 10011退款关闭 10010退款完成 10020售后成功 10021售后失败
                // 10090退款中 10091换货成功 10092换货失败 10093维修关闭 10094维修成功 ）

                // 售后状态 0：售后申请 1：售后关闭，2：售后处理中，3：退款中，4： 售后成功

                insert.setStatus(shopRefund.getStatus());
                insert.setErpPushStatus(0);
                insert.setErpStatus(0);
                insert.setHasProcessing(hasProcessing);
                insert.setRemark("");
                if(StringUtils.hasText(shopRefund.getExchangeSkuId())){
                    insert.setExchangeSkuId(shopRefund.getExchangeSkuId());
                    insert.setExchangeGoodsName(shopRefund.getExchangeGoodsName());
                    insert.setExchangeGoodsPrice(shopRefund.getExchangeGoodsPrice());
                    insert.setExchangeGoodsNum(shopRefund.getExchangeGoodsNum());
                    // 查找要换货的商品库sku
                    var exchangeSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(shopRefund.getExchangeSkuId(), shopRefund.getShopId());
                    if (exchangeSkuMapping != null) {
                        insert.setExchangeErpGoodsSkuId(exchangeSkuMapping.getErpGoodsSkuId());
                    } else {
                        insert.setExchangeErpGoodsSkuId(0L);
                    }
                }else{
                    insert.setExchangeErpGoodsSkuId(0L);
                }
                insert.setExchangeErpOrderId(0L);
                insert.setCreateTime(new Date());
                insert.setCreateBy("REFUND_MESSAGE");
                mapper.insert(insert);

                //更新子订单状态
                List<OOrderItem> oOrderItems = orderItemMapper.selectList(
                        new LambdaQueryWrapper<OOrderItem>()
                                .eq(OOrderItem::getSubOrderNum, insert.getOrderItemNum())
                );
                if(oOrderItems!=null && oOrderItems.size()>0){
                    for (OOrderItem oOrderItem : oOrderItems) {
                        // 更新订单库子订单状态
                        OOrderItem itemUpdate = new OOrderItem();
                        itemUpdate.setRefundStatus(2);
                        itemUpdate.setUpdateBy("退款消息");
                        itemUpdate.setUpdateTime(new Date());
                        itemUpdate.setId(oOrderItem.getId());
                        orderItemMapper.updateById(itemUpdate);
                        // 更新发货子订单状态
                        List<OOrderStockingItem> oOrderStockingItems = orderStockingItemMapper.selectList(new LambdaQueryWrapper<OOrderStockingItem>().eq(OOrderStockingItem::getOOrderItemId, oOrderItem.getId()));
                        if(oOrderStockingItems!=null && oOrderStockingItems.size()>0){
                            for (OOrderStockingItem oOrderStockingItem : oOrderStockingItems) {
                                OOrderStockingItem stockingItem = new OOrderStockingItem();
                                stockingItem.setId(oOrderStockingItem.getId());
                                stockingItem.setRefundStatus(2);
                                stockingItem.setUpdateTime(new Date());
                                stockingItem.setUpdateBy("退款消息");
                                orderStockingItemMapper.updateById(stockingItem);
                            }
                        }
                    }
                }
                log.info("=====售后消息，新增成功");
            } else {
                // 修改
                ORefund update = new ORefund();
                update.setId(oRefunds.get(0).getId());
                update.setRefundType(shopRefund.getType());
                //售后类型。(1-售前退款(取消订单) 10-退货 20-换货 30-维修 40-上门服务 80-补发商品 90-补款 91-返现 11-仅退款)
                if (shopRefund.getType().intValue() == 20 || shopRefund.getType().intValue() == 10) {
                    update.setHasGoodReturn(1);
                } else {
                    update.setHasGoodReturn(0);
                }
                // 查找skuId绑定的商品库关系
                var shopGoodsSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(shopRefund.getSkuId(), shopRefund.getShopId());
                if (shopGoodsSkuMapping != null) {
                    update.setGoodsId(shopGoodsSkuMapping.getErpGoodsId());
                    update.setGoodsSkuId(shopGoodsSkuMapping.getErpGoodsSkuId());
                } else {
                    update.setGoodsId(0L);
                    update.setGoodsSkuId(0L);
                }
                update.setShippingStatus(shopRefund.getOrderShipStatus());
                update.setStatus(shopRefund.getStatus());
                if(oRefunds.get(0).getHasProcessing().intValue()==0) {
                    update.setHasProcessing(hasProcessing);
                }
                update.setPlatformStatus(shopRefund.getStatusCode());
                update.setPlatformStatusText(shopRefund.getStatusName());
                update.setReturnLogisticsCompany(shopRefund.getReturnDeliveryName());
                update.setReturnLogisticsCode(shopRefund.getReturnWaybillId());
                BigDecimal refundAmount = new BigDecimal(shopRefund.getRefundAmount()).divide(new BigDecimal(100));
                update.setRefundFee(refundAmount.doubleValue());
                update.setRemark(shopRefund.getRemark());
                update.setRefundReason(shopRefund.getReason());
                update.setUpdateTime(new Date());
                update.setUpdateBy("REFUND_MESSAGE");
                if(StringUtils.hasText(shopRefund.getExchangeSkuId())) {
                    if(shopRefund.getExchangeSkuId().equals(oRefunds.get(0).getExchangeSkuId())) {
                        // 换货数据没有改变
                        if (oRefunds.get(0).getExchangeErpGoodsSkuId() == null || oRefunds.get(0).getExchangeErpGoodsSkuId().longValue() <= 0) {
                            if (StringUtils.hasText(shopRefund.getExchangeSkuId())) {
                                // 查找要换货的商品库sku
                                var exchangeSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(shopRefund.getExchangeSkuId(), shopRefund.getShopId());
                                if (exchangeSkuMapping != null) {
                                    update.setExchangeErpGoodsSkuId(exchangeSkuMapping.getErpGoodsSkuId());
                                } else {
                                    update.setExchangeErpGoodsSkuId(0L);
                                }
                            } else {
                                update.setExchangeErpGoodsSkuId(0L);
                            }
                        }
                    }else{
                        // 换货数据变了
                        update.setExchangeSkuId(shopRefund.getExchangeSkuId());
                        update.setExchangeGoodsName(shopRefund.getExchangeGoodsName());
                        update.setExchangeGoodsPrice(shopRefund.getExchangeGoodsPrice());
                        update.setExchangeGoodsNum(shopRefund.getExchangeGoodsNum());
                        // 查找要换货的商品库sku
                        var exchangeSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(shopRefund.getExchangeSkuId(), shopRefund.getShopId());

                        if (exchangeSkuMapping != null) {
                            update.setExchangeErpGoodsSkuId(exchangeSkuMapping.getErpGoodsSkuId());
                        } else {
                            update.setExchangeErpGoodsSkuId(0L);
                        }
                    }
                }
                mapper.updateById(update);
                log.info("======售后消息，新增成功");
            }

            // 更新主订单状态
            List<OOrder> oOrders = orderMapper.selectList(new LambdaQueryWrapper<OOrder>().eq(OOrder::getOrderNum, orderNum).eq(OOrder::getShopId, shopId));
            if(oOrders!=null && oOrders.size()>0){
                for (OOrder oOrder : oOrders) {
                    // 查询子订单是否全部退款
                    List<OOrderItem> oOrderItems = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                            .eq(OOrderItem::getOrderId, oOrder.getId())
                            .eq(OOrderItem::getRefundStatus, 1)
                    );
                    // 找出没有退款的子订单，如果没有，那么把主订单直接更新成取消状态
                    if (oOrderItems == null || oOrderItems.isEmpty()) {
                        OOrder orderUpdate = new OOrder();
                        orderUpdate.setId(oOrder.getId());
                        orderUpdate.setOrderStatus(11);
                        orderUpdate.setCancelReason("子订单全部退款");
                        orderUpdate.setUpdateBy("子订单全部退款");
                        orderUpdate.setUpdateTime(new Date());
                        orderMapper.updateById(orderUpdate);
                    }

                    // 查找发货订单
                    List<OOrderStocking> oOrderStockings = orderStockingMapper.selectList(new LambdaQueryWrapper<OOrderStocking>().eq(OOrderStocking::getOOrderId, oOrder.getId()));
                    if(oOrderStockings!=null && oOrderStockings.size()>0){
                        for (OOrderStocking oOrderStocking : oOrderStockings) {
                            // 查找发货子订单是否全部退款
                            List<OOrderStockingItem> shipOrderItemList = orderStockingItemMapper.selectList(
                                    new LambdaQueryWrapper<OOrderStockingItem>()
                                            .eq(OOrderStockingItem::getShipOrderId, oOrderStocking.getId())
                                            .eq(OOrderStockingItem::getRefundStatus, 1)
                            );
                            // 找出没有退款的子订单，如果没有，那么把主订单直接更新成取消状态
                            if (shipOrderItemList == null || shipOrderItemList.isEmpty()) {
                                OOrderStocking updateShip = new OOrderStocking();
                                updateShip.setId(oOrderStocking.getId());
                                updateShip.setOrderStatus(11);
                                updateShip.setUpdateBy("子订单全部退款");
                                updateShip.setUpdateTime(new Date());
                                orderStockingMapper.updateById(updateShip);
                            }
                        }
                    }
                }
            }
            log.info("==========shopOrder退款同步成功=======");

        }else{
            log.error("店铺售后不存在");
        }
        return ResultVo.success();
    }

    @Override
    public List<ORefund> selectList(ORefund refund) {
        List<ORefund> list = mapper.selectList(new LambdaQueryWrapper<>());
        return list;
    }

    @Override
    public PageResult<ORefund> queryPageList(RefundSearchBo bo, PageQuery pageQuery) {
        LambdaQueryWrapper<ORefund> queryWrapper = new LambdaQueryWrapper<ORefund>()
                .eq(StringUtils.hasText(bo.getRefundNum()),ORefund::getRefundNum,bo.getRefundNum())
                .eq(StringUtils.hasText(bo.getOrderNum()),ORefund::getOrderNum,bo.getOrderNum())
                .eq(bo.getRefundType()!=null,ORefund::getRefundType,bo.getRefundType())
                .eq(bo.getShopId()!=null,ORefund::getShopId,bo.getShopId())
                .eq(bo.getHasProcessing()!=null,ORefund::getHasProcessing,bo.getHasProcessing())
                .eq(bo.getErpPushStatus()!=null && bo.getErpPushStatus() == 0,ORefund::getErpPushStatus,0)
                .eq(bo.getErpPushStatus()!=null && bo.getErpPushStatus() == 200,ORefund::getErpPushStatus,200)
                .gt(bo.getErpPushStatus()!=null && bo.getErpPushStatus() == 500,ORefund::getErpPushStatus,200)
                ;
//        if(bo.getRefundType()== null){
////            LambdaQueryWrapper<ORefund> typeOr = new LambdaQueryWrapper<ORefund>();
////            typeOr.eq(ORefund::getRefundType,11);
////            typeOr.or().eq(ORefund::getRefundType,10);
////            typeOr.or().eq(ORefund::getRefundType,20);
//            queryWrapper.and(x->x.eq(ORefund::getRefundType,11)
//                    .or().eq(ORefund::getRefundType,20)
//                    .or().eq(ORefund::getRefundType,10)
//                    .or().eq(ORefund::getRefundType,30)
//                    .or().eq(ORefund::getRefundType,1)
//            );
//        }

        Page<ORefund> pages = mapper.selectPage(pageQuery.build(), queryWrapper);
        return PageResult.build(pages);
    }

    @Override
    public PageResult<ORefund> queryPageWaitPushErpList(PageQuery pageQuery) {
        LambdaQueryWrapper<ORefund> queryWrapper = new LambdaQueryWrapper<ORefund>()
                .and(x->x.eq(ORefund::getRefundType,11).or().eq(ORefund::getRefundType,20).or().eq(ORefund::getRefundType,10)
                );


        Page<ORefund> pages = mapper.selectPage(pageQuery.build(), queryWrapper);
        return PageResult.build(pages);
    }

    @Override
    public ORefund selectById(Long id) {
        return mapper.selectById(id);
    }

    /**
     * 售后处理
     * @param processingBo
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
    @Override
    public ResultVo<Long> refundProcessing(RefundProcessingBo processingBo, String createBy) {
        if (processingBo.getRefundId() == null) return ResultVo.error(500, "缺少参数refundId");
        if(processingBo.getType()==null) return ResultVo.error("缺少参数：type");
        ORefund refund = mapper.selectById(processingBo.getRefundId());
        if (refund == null) return ResultVo.error(500,"没有找到退款单");
        else if (refund.getHasProcessing() == 1) {
            return ResultVo.error(500,"已经处理过了");
        }

        if(processingBo.getType()==0){
            // 无需处理的，直接更新状态
            ORefund updateRefund = new ORefund();
            updateRefund.setId(refund.getId());
            updateRefund.setHasProcessing(9);
            updateRefund.setProcessType(processingBo.getType());
//            updateRefund.setStatus(10010);
            updateRefund.setStatus(4);
            updateRefund.setUpdateBy("管理员操作");
            updateRefund.setUpdateTime(new Date());
            mapper.updateById(updateRefund);
            return ResultVo.success();
        }

        // 查询相关订单
        Long erpOrderId = null;
        Long erpOrderItemId = null;
        List<OOrder> oOrders = orderMapper.selectList(new LambdaQueryWrapper<OOrder>().eq(OOrder::getOrderNum, refund.getOrderNum()));
        if(oOrders==null||oOrders.isEmpty()){
            return ResultVo.error("没有找到订单数据");
        }
        erpOrderId = Long.parseLong(oOrders.get(0).getId());

        List<OOrderItem> oOrderItemList = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>()
                .eq(OOrderItem::getOrderNum, refund.getOrderNum())
                .eq(OOrderItem::getSkuId, refund.getSkuId()));
        if(oOrderItemList==null||oOrderItemList.isEmpty()){
            return ResultVo.error("没有找到订单Item数据");
        }
        OOrderItem shipOrderItem = oOrderItemList.get(0);
        //判断是否发货
        if(shipOrderItem.getShipStatus().intValue() == 0){
            return ResultVo.error("订单未发货");
        }
        if(shipOrderItem.getShipperId()==null||shipOrderItem.getShipperId()==0){
            return ResultVo.error("没有找到发货人信息");
        }

        erpOrderItemId = Long.parseLong(oOrderItemList.get(0).getId());

        Long goodsId= 0L;
        Long goodsSkuId= 0L;


        if(refund.getGoodsSkuId()==null||refund.getGoodsSkuId()==0){
            // 如果没有goodsSkuId，那么使用平台skuid查询商品数据
            var shopGoodsSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(refund.getSkuId(), refund.getShopId());

            if (shopGoodsSkuMapping == null) {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                log.error("==映射关系中没有找到售后商品===={}",refund.getSkuId());
                return ResultVo.error("映射关系中没有找到售后商品");
            } else {
                goodsSkuId = shopGoodsSkuMapping.getErpGoodsSkuId();
                goodsId = shopGoodsSkuMapping.getErpGoodsId();
            }
        }else{
            goodsSkuId = refund.getGoodsSkuId();
            goodsId = refund.getGoodsId();
        }
        // 换货数据
        Long exchangeErpGoodsSkuId = 0L;
        Long exchangeErpGoodsId = 0L;
        String exchangeGoodsName = "";
        String exchangeGoodsImg = "";
        String exchangeGoodsSkuName = "";
        String exchangeSkuCode = "";
        if(processingBo.getType().intValue()==20){
            // 如果是换货
            if(StringUtils.isEmpty(refund.getExchangeSkuId())){
                log.error("==换货处理没有找到换货sku:{}====",refund.getExchangeSkuId());
                return ResultVo.error("换货处理没有找到换货sku");
            }
//            if(refund.getExchangeErpGoodsSkuId()==null||refund.getExchangeErpGoodsSkuId().longValue()<=0){
//                log.error("==换货处理没有找到换货sku:{}====",refund.getExchangeSkuId());
//                return ResultVo.error("换货处理没有找到换货sku");
//            }
            if(refund.getExchangeErpGoodsSkuId()==null||refund.getExchangeErpGoodsSkuId()==0) {
                var exchangeSkuMapping = shopGoodsSkuService.selectByPlatformSkuId(refund.getExchangeSkuId(), refund.getShopId());
                if (exchangeSkuMapping == null) {
                    log.error("==映射关系中没有找到换货商品{}====",refund.getExchangeSkuId());
                    return ResultVo.error("映射关系中没有找到换货商品");
                }else{
                    exchangeErpGoodsSkuId = exchangeSkuMapping.getErpGoodsSkuId();
                }
            }else{
                exchangeErpGoodsSkuId = refund.getExchangeErpGoodsSkuId();
            }

            // 查询换货商品
            OGoodsSku exchangeSku = goodsSkuMapper.selectById(exchangeErpGoodsSkuId);
            if(exchangeSku==null){
                return ResultVo.error("商品库中找不到换货的商品");
            }else{
                exchangeErpGoodsId = Long.parseLong(exchangeSku.getGoodsId());
                exchangeGoodsName = exchangeSku.getGoodsName();
                exchangeGoodsImg = exchangeSku.getColorImage();
                exchangeGoodsSkuName = exchangeSku.getSkuName();
                exchangeSkuCode = exchangeSku.getSkuCode();
            }
        }



//        List<OGoodsSku> oGoodsSkus = goodsSkuMapper.selectList(new LambdaQueryWrapper<OGoodsSku>().eq(OGoodsSku::getSkuCode, refund.getSkuNum()));

        // 保存售后结果
        ORefundAfterSale afterSale = new ORefundAfterSale();
        afterSale.setRefundNum(refund.getRefundNum());
        afterSale.setRefundId(processingBo.getRefundId().toString());
        afterSale.setType(processingBo.getType());
        afterSale.setShopId(refund.getShopId());
        afterSale.setShopType(refund.getShopType());
        afterSale.setOrderNum(refund.getOrderNum());
        afterSale.setSubOrderNum(refund.getOrderItemNum());
        afterSale.setOOrderId(erpOrderId);
        afterSale.setOOrderItemId(erpOrderItemId);
        afterSale.setSkuId(refund.getSkuId());
        afterSale.setQuantity(refund.getQuantity().intValue());
        afterSale.setTitle(refund.getGoodsName());
        afterSale.setImg(refund.getGoodsImage());
        afterSale.setSkuInfo(refund.getGoodsSku());
        afterSale.setSkuCode(refund.getSkuNum());
        afterSale.setOGoodsId(goodsId);
        afterSale.setOGoodsSkuId(goodsSkuId);
        afterSale.setHasGoodsSend(processingBo.getHasGoodsSend());
        afterSale.setSendLogisticsCode(processingBo.getSendLogisticsCode());
        afterSale.setReturnLogisticsCode(processingBo.getReturnLogisticsCode());
        afterSale.setReceiverName(processingBo.getReceiverName());
        afterSale.setReceiverTel(processingBo.getReceiverTel());
        afterSale.setReceiverAddress(processingBo.getReceiverAddress());
        afterSale.setReissueLogisticsCode(processingBo.getReissueLogisticsCode());
        afterSale.setRemark(processingBo.getRemark());
        if(processingBo.getType()==10||processingBo.getType()==20||processingBo.getType()==80){
            // 换货 退货 补发
            afterSale.setStatus(0);
        }else{
            afterSale.setStatus(10);
        }
//        afterSale.setStatus(processingBo.getType() == 0?10:0);
        afterSale.setCreateTime(new Date());
        afterSale.setCreateBy(createBy);
        //发货信息
        afterSale.setSendShipType(shipOrderItem.getShipType());
        afterSale.setSendWarehouseId(shipOrderItem.getShipperId());
        // 查询仓库信息
        if(shipOrderItem.getShipType().intValue() == EnumShipType.JD_CLOUD_WAREHOUSE.getIndex()
                || shipOrderItem.getShipType().intValue() == EnumShipType.CLOUD_WAREHOUSE.getIndex()
                || shipOrderItem.getShipType().intValue() == EnumShipType.LOCAL.getIndex() ){
            log.info("===========仓库发货===分配给仓库处理=====");
            // 仓库发货
            ErpWarehouse erpWarehouse = erpWarehouseMapper.selectById(shipOrderItem.getShipperId());
            if(erpWarehouse!=null){
                afterSale.setSendWarehouseType(erpWarehouse.getWarehouseType());
                afterSale.setSendWarehouseName(erpWarehouse.getWarehouseName());
            }
            afterSale.setReturnType(0);//退回类型（0退回仓库；300退回供应商）
            afterSale.setReissueType(0);
        }else if(shipOrderItem.getShipType()== EnumShipType.SUPPLIER.getIndex() ){
            log.info("===========供应商发货===分配给供应商处理=====");
            // 供应商发货
            ErpSupplier erpSupplier = goodsSupplierMapper.selectById(shipOrderItem.getShipperId());
            if(erpSupplier !=null){
                afterSale.setSendWarehouseType("SUPPLIER");
                afterSale.setSendWarehouseName(erpSupplier.getName());
            }
            afterSale.setReturnType(300);//退回类型（0退回仓库；300退回供应商）
            afterSale.setReissueType(300);
        }else{
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            log.error("==订单发货类型错误，无法处理=");
            return ResultVo.error("订单发货类型错误，无法处理！");
        }
        afterSale.setMerchantId(refund.getMerchantId());
        afterSale.setReturnWarehouseId(shipOrderItem.getShipperId());
        afterSale.setExchangeSkuId(refund.getExchangeSkuId());
        afterSale.setExchangeErpGoodsId(exchangeErpGoodsId);
        afterSale.setExchangeErpGoodsSkuId(exchangeErpGoodsSkuId);
        afterSale.setExchangeGoodsName(exchangeGoodsName);
        afterSale.setExchangeGoodsSkuName(exchangeGoodsSkuName);
        afterSale.setExchangeGoodsSkuCode(exchangeSkuCode);
        afterSale.setExchangeGoodsNum(refund.getExchangeGoodsNum());
        afterSale.setExchangeGoodsImg(exchangeGoodsImg);
        afterSaleMapper.insert(afterSale);


        // 更新ORefund
        ORefund update = new ORefund();
        update.setId(refund.getId());
        update.setUpdateBy(createBy+"操作售后处理");
        update.setUpdateTime(new Date());
        update.setProcessType(processingBo.getType());
        update.setHasProcessing(1);
//        if(refund.getStatus()==10001){
//        update.setStatus(10010);
//        }
        update.setAfterSaleId(afterSale.getId());
        mapper.updateById(update);

        return ResultVo.success();
    }
}




