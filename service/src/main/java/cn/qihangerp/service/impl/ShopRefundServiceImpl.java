package cn.qihangerp.service.impl;

import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.enums.EnumShopOrderStatus;
import cn.qihangerp.enums.EnumShopRefundPhase;
import cn.qihangerp.mapper.*;
import cn.qihangerp.model.entity.*;
import cn.qihangerp.model.request.SaleOrderAfterAddRequest;
import cn.qihangerp.service.ShopRefundService;
import cn.qihangerp.service.OShopService;
import com.alibaba.fastjson2.util.DateUtils;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;

@AllArgsConstructor
@Service
public class ShopRefundServiceImpl extends ServiceImpl<ShopRefundMapper, ShopRefund>
    implements ShopRefundService {
    private final OShopService shopService;
    private final ShopOrderItemMapper shopOrderItemMapper;
    private final ShopOrderMapper shopOrderMapper;
    private final OOrderItemMapper orderItemMapper;
    private final OOrderMapper orderMapper;

    @Override
    public PageResult<ShopRefund> queryPageList(ShopRefund bo, PageQuery pageQuery) {
        LambdaQueryWrapper<ShopRefund> queryWrapper = new LambdaQueryWrapper<ShopRefund>()
                .eq(ShopRefund::getMerchantId, bo.getMerchantId())
                .eq(StringUtils.hasText(bo.getAfterId()), ShopRefund::getAfterId, bo.getAfterId())
                .eq(bo.getType() != null, ShopRefund::getType, bo.getType())
                .eq(bo.getShopType() != null, ShopRefund::getShopType, bo.getShopType())
                .eq(bo.getShopId() != null, ShopRefund::getShopId, bo.getShopId())
                .eq(StringUtils.hasText(bo.getOrderId()), ShopRefund::getOrderId, bo.getOrderId());

        Page<ShopRefund> taoGoodsPage = this.baseMapper.selectPage(pageQuery.build(), queryWrapper);
        return PageResult.build(taoGoodsPage);
    }

    @Override
    public ResultVo<Long> saveRefund(Long shopId, ShopRefund refund) {
        if (refund == null) return ResultVo.error("缺少参数");
        Integer shopType = null;
        Long merchantId = 0L;
        if (StringUtils.hasText(refund.getPlatformSellerId())) {
            OShop shop = shopService.selectShopBySellerId(refund.getPlatformSellerId());
            if (shop == null) return ResultVo.error("店铺不存在");
            merchantId = shop.getMerchantId();
            shopId = shop.getId();
            shopType = shop.getType();
        } else {
            OShop shop = shopService.getById(shopId);
            if (shop == null) return ResultVo.error("店铺不存在");
            merchantId = shop.getMerchantId();
            shopId = shop.getId();
            shopType = shop.getType();
        }

        refund.setShopId(shopId);
        refund.setShopType(shopType);
        refund.setMerchantId(merchantId);
        List<ShopRefund> shopRefundList = this.baseMapper.selectList(new LambdaQueryWrapper<ShopRefund>()
                .eq(ShopRefund::getShopId, refund.getShopId())
                .eq(ShopRefund::getAfterId, refund.getAfterId())
                .eq(ShopRefund::getSkuId, refund.getSkuId()));
        if (shopRefundList != null && shopRefundList.size() > 0) {
            refund.setId(shopRefundList.get(0).getId());
            refund.setUpdateOn(new Date());
            this.baseMapper.updateById(refund);
        } else {
            if (refund.getOrderAmount() == null) refund.setOrderAmount(0);
            refund.setCreateOn(new Date());
            this.baseMapper.insert(refund);
        }
        return ResultVo.success(refund.getId());
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ResultVo<Long> addRefund(SaleOrderAfterAddRequest addRequest) {
        ShopOrderItem shopOrderItem = shopOrderItemMapper.selectById(addRequest.getOrderItemId());
        if (shopOrderItem == null) return ResultVo.error("订单item数据不存在");
        else if (shopOrderItem.getRefundStatus() != 1) {
            return ResultVo.error("已申请售后，不能继续申请！");
        } else if (shopOrderItem.getShipStatus() == 0) {
            return ResultVo.error("未发货子订单，不能申请售后，如需取消请到订单列表中取消！");
        }

        ShopOrder shopOrder = shopOrderMapper.selectById(shopOrderItem.getShopOrderId());
        if (shopOrder == null) return ResultVo.error("订单数据不存在");
        else if (shopOrder.getOrderStatus().intValue() == 1) {
            return ResultVo.error("未发货订单不能售后，可以前去订单列表中取消！");
        } else if (shopOrder.getOrderStatus().intValue() == EnumShopOrderStatus.CANCEL.getStatus()) {
            return ResultVo.error("已取消的订单，不允许添加售后！");
        } else if (shopOrder.getOrderStatus().intValue() == EnumShopOrderStatus.CLOSED.getStatus()) {
            return ResultVo.error("已关闭的订单，不允许添加售后！");
        } else if (shopOrder.getOrderStatus().intValue() == EnumShopOrderStatus.WAIT_PAY.getStatus()) {
            return ResultVo.error("未付款的订单，不允许添加售后！");
        } else if (shopOrder.getOrderStatus().intValue() == EnumShopOrderStatus.NEW.getStatus()) {
            return ResultVo.error("新订单，不允许添加售后！");
        } else if (shopOrder.getOrderStatus().intValue() == EnumShopOrderStatus.DELETED.getStatus()) {
            return ResultVo.error("已删除的订单，不允许添加售后！");
        } else if (shopOrder.getOrderStatus().intValue() == EnumShopOrderStatus.LOCKED.getStatus()) {
            return ResultVo.error("已锁定的订单，不允许添加售后！");
        } else if (shopOrder.getOrderStatus().intValue() == EnumShopOrderStatus.REFUND.getStatus()) {
            return ResultVo.error("退款中的订单，不允许添加售后！");
        }

        ShopRefund refund = new ShopRefund();
        refund.setMerchantId(shopOrder.getMerchantId());
        refund.setShopId(shopOrder.getShopId());
        refund.setShopType(shopOrder.getShopType());
        refund.setShopOrderId(shopOrder.getId());
        refund.setShopOrderId(shopOrderItem.getId());
        String refundId = shopOrder.getShopId() + "-" + DateUtils.format(new Date(), "yyyyMMdd") + "-" + System.currentTimeMillis() / 1000;
        refund.setAfterId(StringUtils.hasText(addRequest.getRefundId()) ? addRequest.getRefundId() : refundId);
        refund.setType(addRequest.getType());
        refund.setOrderId(shopOrderItem.getOrderId());
        refund.setSubOrderId(shopOrderItem.getSubOrderId());
        refund.setOrderAmount(shopOrderItem.getItemAmount());
        try {
            Instant instant = Instant.ofEpochSecond(shopOrderItem.getOrderTime());
            LocalDateTime dateTime = LocalDateTime.ofInstant(instant, ZoneId.of("Asia/Shanghai"));
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            refund.setOrderTime(dateTime.format(formatter));
        } catch (Exception e) {
        }
        refund.setOrderStatus(EnumShopOrderStatus.getCode(shopOrder.getOrderStatus()));
        refund.setOrderShipStatus(shopOrderItem.getShipStatus() == 0 ? 0 : 1);
        refund.setProductId(shopOrderItem.getProductId());
        refund.setSkuId(shopOrderItem.getSkuId());
        refund.setSkuName(shopOrderItem.getSkuName());
        refund.setGoodsName(shopOrderItem.getTitle());
        refund.setGoodsImage(shopOrderItem.getImg());
        refund.setGoodsPrice(shopOrderItem.getSalePrice());
        refund.setOuterId(shopOrderItem.getOuterSkuId());
        refund.setSellCount(shopOrderItem.getQuantity());
        refund.setCount(shopOrderItem.getQuantity());
        refund.setRefundAmount(BigDecimal.valueOf(addRequest.getRefundAmount()).multiply(BigDecimal.valueOf(100)).intValue());
        refund.setReason(addRequest.getReasonType());
        refund.setReturnWaybillId(addRequest.getReturnLogistics());
        refund.setUserShipStatus(0);
        refund.setDisputeRefundStatus(0);
        refund.setGoodsStatus(addRequest.getHasGoodReturn());
        refund.setRefundStatus(1);
        refund.setRefundPhase(EnumShopRefundPhase.AFTER_SALE.getCode());
        refund.setRemark(addRequest.getRemark());
        refund.setCreateTime(System.currentTimeMillis() / 1000);
        refund.setUpdateTime(0L);
        refund.setCreateOn(new Date());
        this.baseMapper.insert(refund);

        ShopOrderItem itemUpdate = new ShopOrderItem();
        itemUpdate.setId(addRequest.getOrderItemId());
        itemUpdate.setRefundStatus(2);
        itemUpdate.setUpdateBy("手动添加售后");
        itemUpdate.setUpdateOn(new Date());
        shopOrderItemMapper.updateById(itemUpdate);

        OOrderItem orderItem = new OOrderItem();
        orderItem.setRefundStatus(2);
        orderItem.setRefundCount(shopOrderItem.getQuantity());
        orderItem.setUpdateBy("手动添加售后");
        orderItem.setUpdateTime(new Date());
        orderItemMapper.update(orderItem, new LambdaQueryWrapper<OOrderItem>().eq(OOrderItem::getSubOrderNum, shopOrderItem.getSubOrderId()));

        return ResultVo.success();
    }
}
