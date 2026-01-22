package cn.qihangerp.module.service.impl;


import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.common.ResultVoEnum;
import cn.qihangerp.model.entity.PddGoodsSku;
import cn.qihangerp.model.entity.PddOrder;
import cn.qihangerp.model.entity.PddRefund;
import cn.qihangerp.model.bo.PddRefundBo;
import cn.qihangerp.mapper.PddGoodsSkuMapper;
import cn.qihangerp.mapper.PddRefundMapper;
import cn.qihangerp.module.service.PddRefundService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
* @author TW
* @description 针对表【pdd_refund(拼多多订单退款表)】的数据库操作Service实现
* @createDate 2024-06-06 09:48:28
*/
@AllArgsConstructor
@Service
public class PddRefundServiceImpl extends ServiceImpl<PddRefundMapper, PddRefund>
    implements PddRefundService {
    private final PddRefundMapper mapper;
    private final PddGoodsSkuMapper goodsSkuMapper;
    private final String DATE_PATTERN =
            "^(?:(?:(?:\\d{4}-(?:0?[1-9]|1[0-2])-(?:0?[1-9]|1\\d|2[0-8]))|(?:(?:(?:\\d{2}(?:0[48]|[2468][048]|[13579][26])|(?:(?:0[48]|[2468][048]|[13579][26])00))-0?2-29))$)|(?:(?:(?:\\d{4}-(?:0?[13578]|1[02]))-(?:0?[1-9]|[12]\\d|30))$)|(?:(?:(?:\\d{4}-0?[13-9]|1[0-2])-(?:0?[1-9]|[1-2]\\d|30))$)|(?:(?:(?:\\d{2}(?:0[48]|[13579][26]|[2468][048])|(?:(?:0[48]|[13579][26]|[2468][048])00))-0?2-29))$)$";
    private final Pattern DATE_FORMAT = Pattern.compile(DATE_PATTERN);
    @Override
    public PageResult<PddRefund> queryPageList(PddRefundBo bo, PageQuery pageQuery) {
        if(StringUtils.hasText(bo.getUpdateTime())){
            Matcher matcher = DATE_FORMAT.matcher(bo.getUpdateTime());
            boolean b = matcher.find();
            if(!b){
                bo.setUpdateTime("");
            }
        }

        LambdaQueryWrapper<PddRefund> queryWrapper = new LambdaQueryWrapper<PddRefund>()
                .eq(bo.getShopId()!=null,PddRefund::getShopId,bo.getShopId())
                .eq(StringUtils.hasText(bo.getRefundId()),PddRefund::getId,bo.getRefundId())
                .eq(StringUtils.hasText(bo.getOrderSn()),PddRefund::getOrderSn,bo.getOrderSn())
                .eq(StringUtils.hasText(bo.getAfterSalesType()),PddRefund::getAfterSalesType,bo.getAfterSalesType())
                .ge(StringUtils.hasText(bo.getUpdateTime()), PddRefund::getUpdatedTime,bo.getUpdateTime()+" 00:00:00")
                .le(StringUtils.hasText(bo.getUpdateTime()),PddRefund::getUpdatedTime,bo.getUpdateTime()+" 23:59:59")
                ;

        Page<PddRefund> page = mapper.selectPage(pageQuery.build(), queryWrapper);

        return PageResult.build(page);
    }
    @Override
    public ResultVo<Integer>  saveRefund(Long shopId, PddRefund refund){
        PddRefund origin = mapper.selectById(refund.getId());
        if(origin!=null){
            // 存在，修改
            PddRefund update = new PddRefund();
            update.setId(origin.getId());
            update.setOrderSn(refund.getOrderSn());
            update.setAfterSalesStatus(refund.getAfterSalesStatus());
            update.setDisputeRefundStatus(refund.getDisputeRefundStatus());
            update.setRefundAmount(refund.getRefundAmount());
            update.setRefundOperatorRole(refund.getRefundOperatorRole());
            update.setShippingName(refund.getShippingName());
            update.setTrackingNumber(refund.getTrackingNumber());
            update.setSpeedRefundFlag(refund.getSpeedRefundFlag());
            update.setSpeedRefundStatus(refund.getSpeedRefundStatus());
            update.setUpdatedTime(refund.getUpdatedTime());
            update.setUpdateTime(new Date());
            mapper.updateById(update);
            List<PddGoodsSku> pddGoodsSku = goodsSkuMapper.selectList(new LambdaQueryWrapper<PddGoodsSku>().eq(PddGoodsSku::getSkuId, refund.getSkuId()));
            if (pddGoodsSku != null && !pddGoodsSku.isEmpty()) {
                refund.setOGoodsId(pddGoodsSku.get(0).getErpGoodsId().toString());
                refund.setOGoodsSkuId(pddGoodsSku.get(0).getErpGoodsSkuId().toString());
            }
            return ResultVo.error(ResultVoEnum.DataExist, "退款已经存在，更新成功");

        }else{
            List<PddGoodsSku> pddGoodsSku = goodsSkuMapper.selectList(new LambdaQueryWrapper<PddGoodsSku>().eq(PddGoodsSku::getSkuId, refund.getSkuId()));
            if (pddGoodsSku != null && !pddGoodsSku.isEmpty()) {
                refund.setOGoodsId(pddGoodsSku.get(0).getErpGoodsId().toString());
                refund.setOGoodsSkuId(pddGoodsSku.get(0).getErpGoodsSkuId().toString());
            }
            refund.setShopId(shopId);
            refund.setCreateTime(new Date());
            mapper.insert(refund);
            return ResultVo.success();
        }

    }
}




