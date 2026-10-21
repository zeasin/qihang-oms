package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;

/**
 * 订单处理工作台-取消订单请求（主订单级，单张取消）
 * 参照 qihang-erp-pro OrderCancelBo（docs/design/15-订单处理工作台.md §2.6）
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class OrderCancelBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 主订单ID */
    private Long orderId;
    /** 取消原因（可选） */
    private String reason;
}
