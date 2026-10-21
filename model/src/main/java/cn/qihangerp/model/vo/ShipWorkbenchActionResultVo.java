package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 打单发货-批量操作逐单结果（分配/退回/取号/取消/打印/发货/手动发货共用）
 * 参照 qihang-erp-pro ShipWorkbenchActionResultVo（docs/design/16-打单发货.md §4.7 批量语义）
 * 逐单独立事务，部分成功属正常结果；失败单携带逐单原因
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class ShipWorkbenchActionResultVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 成功单数 */
    private int successCount;
    /** 失败单数 */
    private int failCount;
    /** 逐单成败明细 */
    private List<Item> items = new ArrayList<>();

    @Data
    public static class Item implements Serializable {
        private static final long serialVersionUID = 1L;

        /** 发货单元ID（o_order.id） */
        private Long id;
        /** 平台订单号（回填便于前端展示） */
        private String orderNum;
        /** 是否成功 */
        private boolean success;
        /** 失败原因 */
        private String msg;
    }
}
