package cn.qihangerp.module.service.impl;

import cn.qihangerp.common.*;
import cn.qihangerp.mapper.goods.OGoodsSkuMapper;
import cn.qihangerp.model.bo.RefundProcessingBo;
import cn.qihangerp.model.bo.RefundSearchBo;
import cn.qihangerp.model.entity.*;
import cn.qihangerp.mapper.OAfterSaleMapper;
import cn.qihangerp.mapper.OOrderItemMapper;
import cn.qihangerp.mapper.OOrderMapper;
import cn.qihangerp.mapper.ORefundMapper;
import cn.qihangerp.module.service.ORefundService;
import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import cn.qihangerp.common.enums.EnumShopType;

import lombok.AllArgsConstructor;
import lombok.extern.java.Log;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.Date;
import java.util.List;

/**
* @author qilip
* @description 针对表【o_refund(退换货表)】的数据库操作Service实现
* @createDate 2024-03-10 16:23:12
*/
@Log
@AllArgsConstructor
@Service
public class ORefundServiceImpl extends ServiceImpl<ORefundMapper, ORefund>
    implements ORefundService {
    private final ORefundMapper mapper;
    private final OAfterSaleMapper afterSaleMapper;
    private final OOrderItemMapper orderItemMapper;
    private final OOrderMapper orderMapper;
    private final OGoodsSkuMapper goodsSkuMapper;

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
        if(bo.getRefundType()== null){
//            LambdaQueryWrapper<ORefund> typeOr = new LambdaQueryWrapper<ORefund>();
//            typeOr.eq(ORefund::getRefundType,11);
//            typeOr.or().eq(ORefund::getRefundType,10);
//            typeOr.or().eq(ORefund::getRefundType,20);
            queryWrapper.and(x->x.eq(ORefund::getRefundType,11)
                    .or().eq(ORefund::getRefundType,20)
                    .or().eq(ORefund::getRefundType,10)
                    .or().eq(ORefund::getRefundType,1)
            );
        }

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
    @Transactional
    @Override
    public ResultVo<Long> refundProcessing(RefundProcessingBo processingBo, String createBy) {
        if (processingBo.getRefundId() == null) return ResultVo.error(500, "缺少参数refundId");

        ORefund refund = mapper.selectById(processingBo.getRefundId());
        if (refund == null) return ResultVo.error(500,"没有找到退款单");
        else if (refund.getHasProcessing() == 1) {
            return ResultVo.error(500,"已经处理过了");
        }

        // 查询相关订单
        List<OOrder> oOrders = orderMapper.selectList(new LambdaQueryWrapper<OOrder>().eq(OOrder::getOrderNum, refund.getOrderNum()));
        List<OOrderItem> oOrderItems = orderItemMapper.selectList(new LambdaQueryWrapper<OOrderItem>().eq(OOrderItem::getOrderNum, refund.getOrderNum()).eq(OOrderItem::getSkuId, refund.getSkuId()));
        List<OGoodsSku> oGoodsSkus = goodsSkuMapper.selectList(new LambdaQueryWrapper<OGoodsSku>().eq(OGoodsSku::getSkuCode, refund.getSkuNum()));
        // 保存售后结果
        OAfterSale afterSale = new OAfterSale();
        afterSale.setRefundNum(refund.getRefundNum());
        afterSale.setRefundId(processingBo.getRefundId().toString());
        afterSale.setType(processingBo.getType());
        afterSale.setShopId(refund.getShopId());
        afterSale.setShopType(refund.getShopType());
        afterSale.setOrderNum(refund.getOrderNum());
        afterSale.setSubOrderNum(refund.getOrderItemNum());
        afterSale.setOOrderId(oOrders.isEmpty()?"0":oOrders.get(0).getId());
        afterSale.setOOrderItemId(oOrderItems.isEmpty()?"0":oOrderItems.get(0).getId());
        afterSale.setSkuId(refund.getSkuId().toString());
        afterSale.setQuantity(refund.getQuantity().intValue());
        afterSale.setTitle(refund.getGoodsName());
        afterSale.setImg(refund.getGoodsImage());
        afterSale.setSkuInfo(refund.getGoodsSku());
        afterSale.setSkuCode(refund.getSkuNum());
        afterSale.setOGoodsId(oGoodsSkus.isEmpty()?"0":oGoodsSkus.get(0).getGoodsId().toString());
        afterSale.setOGoodsSkuId(oGoodsSkus.isEmpty()?"0":oGoodsSkus.get(0).getId().toString());
        afterSale.setHasGoodsSend(processingBo.getHasGoodsSend());
        afterSale.setSendLogisticsCode("");
        afterSale.setReturnLogisticsCode(processingBo.getReturnLogisticsCode());
        afterSale.setReceiverName(processingBo.getReceiverName());
        afterSale.setReceiverTel(processingBo.getReceiverTel());
        afterSale.setReceiverAddress(processingBo.getReceiverAddress());
        afterSale.setReissueLogisticsCode(processingBo.getReissueLogisticsCode());
        afterSale.setRemark(processingBo.getRemark());
        afterSale.setStatus(processingBo.getType() == 0?10:0);
        afterSale.setCreateTime(new Date());
        afterSale.setCreateBy(createBy);

        afterSaleMapper.insert(afterSale);


        // 更新ORefund
        ORefund update = new ORefund();
        update.setId(refund.getId());
        update.setUpdateBy(createBy+"操作售后处理");
        update.setUpdateTime(new Date());
        update.setHasProcessing(1);
        update.setAfterSaleId(afterSale.getId());
        mapper.updateById(update);

        return ResultVo.success();
    }
}




