package cn.qihangerp.model.request;

import lombok.Data;

@Data
public class SaleOrderAfterAddRequest {
    private String refundId;
    private Long orderItemId;
    private Integer type;
    private String reasonType;
    private Integer hasGoodReturn;
    private Double refundAmount;
    private String remark;
    private String returnLogistics;
    private String attachment;
}
