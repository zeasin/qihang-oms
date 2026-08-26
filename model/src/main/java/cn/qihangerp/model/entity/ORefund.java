package cn.qihangerp.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * 退换货表
 * @TableName o_refund
 */
@Data
public class ORefund implements Serializable {
    @TableId(type = IdType.AUTO)
    private String id;
    private String refundNum;
    private Integer refundType;
    private Long shopId;
    private Integer shopType;
    private String orderNum;
    private Double orderAmount;
    private Double refundFee;
    private String refundReason;
    private String orderItemNum;
    private String skuId;
    private Long goodsId;
    private Long goodsSkuId;
    private Integer hasGoodReturn;
    private String skuNum;
    private String goodsName;
    private String goodsSku;
    private String goodsImage;
    private Integer quantity;
    private String returnLogisticsCompany;
    private String sendLogisticsCompany;
    private String returnLogisticsCode;
    private String sendLogisticsCode;
    private Date receiveTime;
    private String remark;
    private Integer status;
    private Date createTime;
    private String createBy;
    private Date updateTime;
    private String updateBy;
    private Integer erpPushStatus;
    private String erpPushResult;
    private Date erpPushTime;
    private Integer hasProcessing;
    private Integer processType;
    private String afterSaleId;
    private Long merchantId;
    private String platformStatus;
    private String platformStatusText;
    private Integer erpStatus;
    private Integer shippingStatus;
    private String exchangeSkuId;
    private String exchangeGoodsName;
    private Integer exchangeGoodsPrice;
    private Integer exchangeGoodsNum;
    private Long exchangeErpGoodsSkuId;
    private Long exchangeErpOrderId;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}
