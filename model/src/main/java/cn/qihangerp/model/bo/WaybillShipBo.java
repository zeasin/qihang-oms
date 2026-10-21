package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;

/**
 * 统一电子面单-发货回传入参 BO
 * 参照 qihang-erp-pro WaybillShipContext 契约（docs/design/16-打单发货.md §4.4）：
 * 字段名沿用取消惯例 logisticsCode=快递公司编码、waybillCode=快递单号。
 *
 * @author qihang
 * @date 2026-10-22
 */
@Data
public class WaybillShipBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 发货单元订单主键（o_order.id） */
    private Long orderId;

    /** 平台订单号 */
    private String orderNum;

    /** 店铺 id */
    private Long shopId;

    /** 平台类型（EnumShopType.getIndex()） */
    private Integer shopType;

    /** 面单账号 id */
    private Long waybillAccountId;

    /** 平台快递公司编码（o_order.shipping_company_code） */
    private String logisticsCode;

    /** 快递单号（o_order.waybill_code） */
    private String waybillCode;
}
