package cn.qihangerp.service;

import cn.qihangerp.model.entity.ORefund;
import cn.qihangerp.model.bo.RefundProcessingBo;
import cn.qihangerp.model.bo.RefundSearchBo;
import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.extension.service.IService;
import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;

import java.util.List;

public interface ORefundService extends IService<ORefund> {
    ResultVo<Integer> jdRefundMessage(String serviceId, JSONObject refundDetail);
    ResultVo<Integer> jdvcRefundMessage(String returnId, JSONObject refundDetail);
    ResultVo<Integer> taoRefundMessage(String refundId, JSONObject refundDetail);
    ResultVo<Integer> pddRefundMessage(String refundId, JSONObject refundDetail);
    ResultVo<Integer> douRefundMessage(String refundId, JSONObject refundDetail);
    ResultVo<Integer> weiRefundMessage(String refundId, JSONObject refundDetail);
    ResultVo<Long> shopRefundMessage(Long shopRefundId);
    List<ORefund> selectList(ORefund refund);
    PageResult<ORefund> queryPageList(RefundSearchBo bo, PageQuery pageQuery);
    PageResult<ORefund> queryPageWaitPushErpList(PageQuery pageQuery);
    ORefund selectById(Long id);
    ResultVo<Long> refundProcessing(RefundProcessingBo processingBo, String createBy);
}
