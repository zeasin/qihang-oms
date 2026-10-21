package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;

/**
 * 统一电子面单-取号商品明细行
 * 参照 qihang-erp-pro DouPlatformWaybillAdapter.buildOrderInfo 的 items 契约（商品名/规格/数量）
 *
 * @author qihang
 * @date 2026-10-22
 */
@Data
public class WaybillTakeItemBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 订单明细行 id（o_order_item.id，供平台按行取号/明细快照） */
    private Long orderItemId;

    /** 商品名称 */
    private String goodsName;

    /** SKU 规格名称 */
    private String skuName;

    /** 商家商品编码/SKU 编码（平台要求回传时使用） */
    private String skuCode;

    /** 数量（&gt;0 才入明细） */
    private Integer quantity;
}
