package cn.qihangerp.api.order;

import lombok.Data;

@Data
public class OrderItemSpecIdUpdateBo {
    private Long orderItemId;
    private Long erpGoodsSpecId;
}
