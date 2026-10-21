package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 订单处理工作台-拆单预览VO（进入拆单界面初始化）
 * 参照 qihang-erp-pro SplitPreviewVo（docs/design/15-订单处理工作台.md §2.5）
 * 部分拆模型：每行填拆分数量加入待拆明细（可多批次），统一拆分；
 * 原单保留剩余，有剩余即可再拆；已拆出数量=现有子单明细聚合（OMS 按 sku 聚合，见拆单服务注释）
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class SplitPreviewVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 被拆订单ID */
    private Long orderId;
    /** 平台订单号 */
    private String orderNum;
    /** 审核状态（0待审核 2已转异常） */
    private Integer auditStatus;
    /** 商品行（含剩余可拆数量） */
    private List<Item> items;

    /**
     * 商品行
     */
    @Data
    public static class Item implements Serializable {
        private static final long serialVersionUID = 1L;
        /** 商品行ID */
        private Long itemId;
        private String goodsTitle;
        private String goodsImg;
        private String skuNum;
        private String goodsSpec;
        private String barcode;
        /** 第三方平台skuId（OMS 子单明细溯源按 sku_id 聚合已拆出数量） */
        private String skuId;
        /** 原始数量 */
        private Integer quantity;
        /** 已退款数量 */
        private Integer refundCount;
        /** 可发货数量（quantity - refundCount） */
        private Integer available;
        /** 已拆出数量（同主单下子单明细按 sku 聚合） */
        private Integer splitOut;
    }
}
