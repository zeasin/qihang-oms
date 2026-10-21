package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;

/**
 * 统一电子面单-取消取号入参 BO
 * 参照 qihang-erp-pro WaybillCancelContext 契约（docs/design/16-打单发货.md §4.2）：
 * 字段惯例 logisticsCode=平台快递公司编码、waybillCode=快递单号；
 * 取消仅允许未打印/未发货状态，成功后 waybill_status 回 0，原账号保留在 waybill_account_id 供重取沿用。
 *
 * @author qihang
 * @date 2026-10-22
 */
@Data
public class WaybillCancelBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 发货单元订单主键（o_order.id） */
    private Long orderId;

    /** 平台订单号 */
    private String orderNum;

    /** 平台类型（EnumShopType.getIndex()） */
    private Integer shopType;

    /** 面单账号 id（取号时实际使用账号，取消沿用） */
    private Long waybillAccountId;

    /** 平台快递公司编码（取号成功后回写的实际值） */
    private String logisticsCode;

    /** 快递单号 */
    private String waybillCode;

    /** 平台电子面单订单标识（视频号等平台取消用） */
    private String waybillOrderId;
}
