package cn.qihangerp.enums;

/**
 * 描述：抖店订单状态（dou_order.order_status / main_status 主流程口径一致）
 * 1 待确认/待支付 105 已支付 2 备货中 101 部分发货 3 已发货 4 已取消 5 已完成
 * 21 发货前退款完结 22 发货后退款完结 39 收货后退款完结
 * 拉单转单口径：4/21（取消、发货前退款完结）不转入 o_order
 */
public enum DouOrderStateEnum {
    WAIT_CONFIRM("待确认/待支付", 1),
    PAID("已支付", 105),
    PREPARING("备货中", 2),
    PART_CONSIGNED("部分发货", 101),
    CONSIGNED("已发货", 3),
    CANCELED("已取消", 4),
    FINISHED("已完成", 5),
    REFUND_BEFORE_SHIP_DONE("发货前退款完结", 21),
    REFUND_AFTER_SHIP_DONE("发货后退款完结", 22),
    REFUND_RECEIVED_DONE("收货后退款完结", 39);

    private String name;
    private int index;

    private DouOrderStateEnum(String name, int index) {
        this.name = name;
        this.index = index;
    }

    public static String getName(int index) {
        for (DouOrderStateEnum c : DouOrderStateEnum.values()) {
            if (c.getIndex() == index) {
                return c.name;
            }
        }
        return null;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }
}
