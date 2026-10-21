package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;

/**
 * 订单处理工作台-修改收货地址请求（未发货前可改；已取号需先取消取号）
 * 参照 qihang-erp-pro OrderAddressBo（docs/design/15-订单处理工作台.md §2.7）
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class OrderAddressBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 订单ID */
    private Long orderId;
    /** 收件人姓名 */
    private String receiverName;
    /** 收件人手机号 */
    private String receiverMobile;
    /** 省 */
    private String province;
    /** 市 */
    private String city;
    /** 区 */
    private String town;
    /** 详细地址 */
    private String address;
}
