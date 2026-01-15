package cn.qihangerp.api.request;

import lombok.Data;

@Data
public class OrderItemSpecIdUpdateBo {
    private Long orderItemId;
    private Long erpGoodsSpecId;
}
