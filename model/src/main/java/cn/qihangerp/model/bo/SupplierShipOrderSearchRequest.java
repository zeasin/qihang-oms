package cn.qihangerp.model.bo;

import lombok.Data;

@Data
public class SupplierShipOrderSearchRequest {

    private String orderNum;
    private Integer sendStatus;
    private Integer orderStatus;
    private String startTime;
    private String endTime;
    private Long supplierId;
    private Long warehouseId;
    private Integer waybillStatus;
    private Integer stockingStatus;
    private Long shopId;
    private Integer shopType;
    private Long merchantId;
    /**
     * 类型：0本地仓库备货  300供应商发货 100京东云仓发货 110吉客云云仓发货 200系统云仓发货
     */
    private Integer type;

}
