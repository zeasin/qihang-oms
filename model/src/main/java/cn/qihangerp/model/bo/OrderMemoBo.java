package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;

/**
 * 订单处理工作台-修改卖家备注请求（未发货前可改）
 * 参照 qihang-erp-pro OrderMemoBo（docs/design/15-订单处理工作台.md §2.7）
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class OrderMemoBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 订单ID */
    private Long orderId;
    /** 卖家备注内容 */
    private String sellerMemo;
}
