package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 打单发货队列-页签计数（待取号/待打印/待发货/待补分配角标）
 * 参照 qihang-erp-pro 队列口径（docs/design/16-打单发货.md §4.1/§0.1 状态流页签），
 * 计数范围=同一队列口径（已放行+待发货+未发货+非合并子单，排除已发货面单状态）
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class ShipWorkbenchPoolCountsVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 待取号（waybill_status 0/NULL） */
    private Long notTaken;
    /** 待打印（waybill_status=1 已取号） */
    private Long taken;
    /** 待发货（waybill_status=2 已打印） */
    private Long printed;
    /** 待补分配（waybill_account_id IS NULL，异常回落子视图） */
    private Long allocatePending;
    /** 队列合计（不含已发货终态） */
    private Long total;
}
