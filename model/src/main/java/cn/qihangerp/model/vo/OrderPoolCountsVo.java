package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 订单处理工作台-状态池计数VO（页签角标）
 * 参照 qihang-erp-pro OrderPoolCountsVo（docs/design/15-订单处理工作台.md §2.2）
 * 池口径：待审核=audit_status 0 AND order_status 1 AND ship_status 0；异常=audit_status 2；
 *        待发货=audit_status 1 AND order_status 1 AND ship_status 0；已发货=audit_status 1 AND ship_status>0；
 *        全池排除已取消(11)/已删除(29)
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class OrderPoolCountsVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 全部（不设池条件、不排除任何状态，含已取消/已删除） */
    private Long all;

    /** 待审核 */
    private Long pending;
    /** 异常池 */
    private Long exception;
    /** 待发货（已放行未发货） */
    private Long released;
    /** 已发货（audit_status 1 AND ship_status>0） */
    private Long shipped;
    /** 已完成（order_status=3） */
    private Long completed;
    /** 即将超时（create_time+时效配置 剩余0~12小时；基于当前状态池，不受 timeoutFilter 影响） */
    private Long aboutTimeout;
    /** 已超时（create_time+时效配置 剩余<0；基于当前状态池，不受 timeoutFilter 影响） */
    private Long timeout;
}
