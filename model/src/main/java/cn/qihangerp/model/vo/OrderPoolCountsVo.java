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

    /** 待审核 */
    private Long pending;
    /** 异常池 */
    private Long exception;
    /** 待发货（已放行未发货） */
    private Long released;
    /** 已发货 */
    private Long shipped;
}
