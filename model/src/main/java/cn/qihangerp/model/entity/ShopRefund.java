package cn.qihangerp.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Date;

/**
 * 视频号小店退款
 * @TableName oms_shop_refund
 */
@TableName(value ="oms_shop_refund")
@Data
public class ShopRefund {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long merchantId;
    private Long shopId;
    private Integer shopType;
    private String afterId;
    private Integer type;
    private Integer status;
    private String orderId;
    private Integer orderAmount;
    private String productId;
    private String goodsName;
    private String goodsImage;
    private String skuId;
    private String skuName;
    private Integer count;
    private Integer sellCount;
    private Integer refundReason;
    private Integer refundAmount;
    private String returnWaybillId;
    private String returnDeliveryId;
    private String returnDeliveryName;
    private Long createTime;
    private Long updateTime;
    private String reason;
    private String reasonText;
    private Integer confirmStatus;
    private LocalDateTime confirmTime;
    private Integer orderShipStatus;
    private Integer userShipStatus;
    private Integer refundStatus;
    private Integer disputeRefundStatus;
    private Date createOn;
    private Date updateOn;
    private String orderStatus;
    private String refundPhase;
    private String remark;
    private String statusCode;
    private String statusName;
    private String subOrderId;
    private String outerId;
    private Integer goodsPrice;
    private Integer goodsStatus;
    private String refBoughtSkuId;
    private String exchangeSkuId;
    private String exchangeGoodsName;
    private Integer exchangeGoodsPrice;
    private Integer exchangeGoodsNum;
    private String platformSellerId;
    private String platformSellerName;
    private String orderTime;
    private String refundSuccessTime;
    private Long shopOrderId;
    private Long shopOrderItemId;
    private String platformType;
}
