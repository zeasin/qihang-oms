package cn.qihangerp.model.bo;

import lombok.Data;

/**
 * 统一发货记录查询请求
 * type: 0=本地仓, 300=供应商, 100=京东云仓, 110=吉客云, 200=系统云仓
 */
@Data
public class ShipRecordQueryRequest {
    private Integer type;
    private Long shipperId;
    private String orderNum;
    private String waybillCode;
    private Long shopId;
    private Integer shopType;
    private Integer sendStatus;
    private Integer waybillStatus;
    private Integer erpPushStatus;
    private String startTime;
    private String endTime;
    private String shippingErpOrderCode;
    private String shippingOrderCode;
    private Long merchantId;
    private Long warehouseId;
    private Long supplierId;
    private Integer orderStatus;
    private Integer stockingStatus;
    private Boolean allCloud;
}
