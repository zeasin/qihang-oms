package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 订单处理工作台-已放行订单撤回异常池请求（audit_status 1→2，按勾选行独立退回）
 * 参照 qihang-erp-pro OrderWithdrawBo（docs/design/15-订单处理工作台.md §2.8）
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class OrderWithdrawBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 订单ID列表（待发货池发货单元行：未拆分主单或拆分子单） */
    private List<Long> orderIds;

    /** 异常分类标签ID（bind_pool=2，必选单选；撤回成功后覆盖写订单分类，口径同打单发货页退回） */
    private Long tagId;
}
