package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 打单发货-状态漂移行VO（o_order.waybill_status 与打单记录 o_order_ship_waybill 不一致）
 * 类型：NO_WAYBILL_RECORD 已取号/已打印但无活记录 / ORPHAN_RECORD 未取号但残留status=1记录 /
 * RECORD_NOT_SHIPPED 已发货但记录未推进到3
 *
 * @author qihang
 * @date 2026-10-23
 */
@Data
public class DriftVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 发货单元ID（o_order.id） */
    private Long orderId;
    /** 平台订单号 */
    private String orderNum;
    private Long shopId;
    private Integer shopType;
    /** 订单面单状态（EnumWaybillStatus） */
    private Integer waybillStatus;
    /** 面单账号ID */
    private Long waybillAccountId;
    /** 漂移类型：NO_WAYBILL_RECORD / ORPHAN_RECORD / RECORD_NOT_SHIPPED */
    private String driftType;
    /** 该发货单元打单记录状态摘要（如 "1,2"；无记录为 "无"） */
    private String recordStatusText;
    /** 漂移说明 */
    private String description;
}
