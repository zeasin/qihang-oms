package cn.qihangerp.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Date;

/**
 * 订单明细表
 * @TableName o_order_item
 */
@Data
public class OOrderItem implements Serializable {
    /**
     * id，自增
     */
    @TableId(type = IdType.AUTO)
    private String id;

    /**
     * 商品行角色：0=主订单原始行，1=子订单履约行，2=合并发货子订单行（EnumOrderRole 同口径）
     */
    private Integer itemRole;

    /**
     * 订单ID（o_order外键）
     */
    private String orderId;

    /**
     * 子订单号（第三方平台）
     */
    private String subOrderNum;
    private String orderNum;

    /**
     * 第三方平台skuId
     */
    private String skuId;

    /**
     * 第三方平台skuId
     */
    private String productId;

    /**
     * erp系统商品id
     */
    private Long goodsId;

    /**
     * erp系统商品规格id
     */
    private Long goodsSkuId;

    /**
     * 商品标题
     */
    private String goodsTitle;

    /**
     * 商品图片
     */
    private String goodsImg;

    /**
     * 商品编码
     */
    private String goodsNum;

    /**
     * 商品规格
     */
    private String goodsSpec;

    /**
     * 商品规格编码
     */
    private String skuNum;
    private String barcode;

    /**
     * 商品单价
     */
    private Double goodsPrice;

    /**
     * 子订单金额
     */
    private Double itemAmount;
    private Double discountAmount;
    private Double payment;

    /**
     * 商品数量
     */
    private Integer quantity;

    /**
     * 备注
     */
    private String remark;

    /**
     * 已退货数量
     */
    private Integer refundCount;

    /**
     * 售后状态 1：无售后或售后关闭，2：售后处理中，3：退款中，4： 退款成功 
     */
    private Integer refundStatus;
//    private Integer orderStatus;



    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * 创建人
     */
    private String createBy;

    /**
     * 更新时间
     */
    private Date updateTime;
    private LocalDateTime orderTime;

    /**
     * 更新人
     */
    private String updateBy;

    //发货类型 EnumShipType
    private Integer shipType;
    /**
     * 发货状态：0待发货 1已分配发货 2全部发货 10已取号（EnumShipStatus）
     */
    private Integer shipStatus;
//    private Long shipSupplier;
    /**
     * 发货主体ID：本地仓/云仓/供应商主键（打单发货队列分配写入）
     */
    private Long shipperId;
    /**
     * 发货主体名称
     */
    private String shipperName;
    /**
     * 发货主体编码
     */
    private String shipperNo;
    /**
     * 发货主体类型（字符串口径，取值对齐 EnumShipType：0本地仓 100京东云仓 110吉客云云仓 200系统云仓 300供应商）
     */
    private String shipperType;

    private Integer hasPushErp;//是否推送到ERP（是否推送到供应商发货）0未推送1已推送

    private String waybillCode;
    private String waybillCompany;
//    private Integer waybillStatus;
    private Integer isGift;

    private Long shopId;
    private Integer shopType;
    private Long merchantId;

    private static final long serialVersionUID = 1L;


}