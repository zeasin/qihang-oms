package cn.qihangerp.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * OMS售后处理表
 * @TableName o_refund_after_sale
 */
@Data
public class ORefundAfterSale implements Serializable {
    @TableId(type = IdType.AUTO)
    private String id;
    private Integer type;
    private Long shopId;
    private Long supplierId;
    private Long merchantId;
    private Integer shopType;
    private Integer hasGoodsSend;
    private String refundId;
    private String orderNum;
    private String refundNum;
    private String subOrderNum;
    private Long oOrderId;
    private Long oOrderItemId;
    private String skuId;
    private Integer quantity;
    private String title;
    private String img;
    private String skuInfo;
    private String skuCode;
    private Long oGoodsId;
    private Long oGoodsSkuId;
    private String sendLogisticsCode;
    private Long sendWarehouseId;
    private String sendWarehouseType;
    private String sendWarehouseName;
    private Integer sendShipType;
    private String returnInfo;
    private String returnLogisticsCode;
    private String returnLogisticsCompany;
    private Integer returnType;
    private Long returnWarehouseId;
    private String returnWarehouseName;
    private String returnWarehouseType;
    private String receiverName;
    private String receiverTel;
    private String receiverProvince;
    private String receiverCity;
    private String receiverTown;
    private String receiverAddress;
    private String reissueLogisticsCode;
    private String reissueLogisticsCompany;
    private Integer reissueType;
    private Long reissueWarehouseId;
    private String reissueWarehouseName;
    private String reissueWarehouseType;
    private Integer status;
    private String remark;
    private String result;
    private String exchangeSkuId;
    private Long exchangeErpGoodsSkuId;
    private Long exchangeErpGoodsId;
    private String exchangeGoodsName;
    private String exchangeGoodsImg;
    private String exchangeGoodsSkuName;
    private String exchangeGoodsSkuCode;
    private Integer exchangeGoodsNum;
    private Long exchangeErpOrderId;
    private Date createTime;
    private String createBy;
    private Date updateTime;
    private String updateBy;

    private static final long serialVersionUID = 1L;
}
