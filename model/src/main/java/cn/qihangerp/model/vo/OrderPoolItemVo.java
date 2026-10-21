package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 订单处理工作台-状态池订单行内嵌商品明细VO（列表平铺展示用，简版字段）
 * 参照 qihang-erp-pro OrderPoolItemVo
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class OrderPoolItemVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 商品图片 */
    private String goodsImg;
    /** 商品标题 */
    private String goodsTitle;
    /** 商品规格 */
    private String goodsSpec;
    /** 商品规格编码 */
    private String skuNum;
    /** 商品编码 */
    private String goodsNum;
    /** 商品数量 */
    private Integer quantity;
}
