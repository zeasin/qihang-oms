package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;

/**
 * 打单发货-手动发货参数（兜底通道）
 * 参照 qihang-erp-pro ShipWorkbenchManualShipBo（docs/design/16-打单发货.md §2.4 / §4.4）
 * 人工录入物流公司与单号直接发货 → waybill_status=10；平台回传按能力尽力而为、失败不阻断
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class ShipWorkbenchManualShipBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 发货单元ID（o_order.id） */
    private Long orderId;
    /** 物流公司ID（erp_logistics_company.id） */
    private Long logisticsCompanyId;
    /** 快递单号（人工录入） */
    private String trackingNumber;
}
