package cn.qihangerp.enums;

/**
 * 描述：拼多多订单成交状态（pdd_order.confirm_status）
 * 0 未成交、1 已成交、2 已取消
 * 拉单转单口径：2（已取消）不转入 o_order
 */
public enum PddOrderConfirmStatusEnum {
    NOT_CONFIRMED("未成交", 0),
    CONFIRMED("已成交", 1),
    CANCELED("已取消", 2);

    private String name;
    private int index;

    private PddOrderConfirmStatusEnum(String name, int index) {
        this.name = name;
        this.index = index;
    }

    public static String getName(int index) {
        for (PddOrderConfirmStatusEnum c : PddOrderConfirmStatusEnum.values()) {
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
