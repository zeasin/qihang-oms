package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 打单发货-整单退回异常池参数
 * 参照 qihang-erp-pro ShipWorkbenchReturnBo（docs/design/16-打单发货.md §五）
 * 退回=转异常的一种形式：必选退回原因（异常池分类标签 bind_pool=2），覆盖写口径与阶段3转异常一致
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class ShipWorkbenchReturnBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 发货单元ID列表（未拆主单或子订单行） */
    private List<Long> orderIds;
    /** 退回原因（异常池分类标签ID，o_order_tag.id） */
    private Long tagId;
}
