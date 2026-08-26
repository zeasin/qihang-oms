package cn.qihangerp.enums;

public enum EnumOOrderStatus {
    WAIT_SHIP("待发货", 1),
    SHIPPED("已发货", 2),
    COMPLETE("已完成", 3),
    CANCEL("已取消", 11),
    REFUND("退款中", 12),
    CLOSED("已关闭", 13),
    WAIT_PAY("待付款", 21),
    LOCKED("已锁定", 22),
    SHIPPED_BF("部分发货", 101),
    NEW("新订单", 0);

    private String name;
    private int index;

    private EnumOOrderStatus(String name, int index) {
        this.name = name;
        this.index = index;
    }

    public static String getName(int index) {
        for (EnumOOrderStatus c : EnumOOrderStatus.values()) {
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
