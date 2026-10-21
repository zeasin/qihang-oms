package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 统一电子面单-发货回传结果 VO
 * 对齐 qihang-erp-pro WaybillShipResult（docs/design/16-打单发货.md §4.4）
 *
 * @author qihang
 * @date 2026-10-22
 */
@Data
public class WaybillShipResultVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 平台返回消息（落 o_order.platform_ship_result） */
    private String platformMsg;
}
