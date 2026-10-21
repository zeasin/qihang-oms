package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 打单发货队列-商品明细行VO
 * 参照 qihang-erp-pro ShipWorkbenchItemVo（docs/design/16-打单发货.md §4.1 列表列）
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class ShipWorkbenchItemVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 发货单元内明细行ID（o_order_item.id） */
    private String id;
    private String goodsImg;
    private String goodsTitle;
    private String goodsSpec;
    private String skuNum;
    private String goodsNum;
    private Integer quantity;
    /** 行发货状态（0待发货 1已分配 10已取号 2已发货，EnumShipStatus） */
    private Integer shipStatus;
    /** 行快递单号快照（取号后回写） */
    private String waybillCode;
}
