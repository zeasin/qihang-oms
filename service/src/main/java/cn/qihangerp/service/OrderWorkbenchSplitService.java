package cn.qihangerp.service;

import cn.qihangerp.common.ResultVo;
import cn.qihangerp.model.bo.SplitSubmitBo;
import cn.qihangerp.model.vo.SplitPreviewVo;

import java.util.List;

/**
 * 订单处理工作台-拆单服务（预览/提交，事务内行锁+完整守卫）
 * 参照 qihang-erp-pro OrderWorkbenchSplitService（docs/design/15-订单处理工作台.md §2.5）
 *
 * @author qihang
 * @date 2026-10-21
 */
public interface OrderWorkbenchSplitService {

    /** 拆单预览：被拆订单商品明细（含剩余可拆数量） */
    SplitPreviewVo preview(Long orderId, List<Long> merchantIds);

    /** 提交拆单（部分拆模型：多批次统一拆分，累计拆出不超可发货数量，事务内生成子订单） */
    ResultVo<String> submit(SplitSubmitBo bo, List<Long> merchantIds, String username);
}
