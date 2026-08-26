package cn.qihangerp.enums;

public enum EnumShopOrderStatus {
    WAIT_SHIP("待发货", "WAIT_SHIP", 1),
    PART_SHIP("部分发货", "PART_SHIP", 101),
    SHIPPED("已发货", "SHIPPED", 2),
    COMPLETE("已完成", "COMPLETE", 3),
    CANCEL("已取消", "COMPLETE", 11),
    REFUND("退款中", "REFUND", 12),
    CLOSED("已关闭", "CLOSED", 13),
    WAIT_PAY("待付款", "WAIT_PAY", 21),
    LOCKED("锁定", "LOCKED", 22),
    DELETED("删除", "DELETED", 29),
    NEW("新订单", "NEW", 0);

    private String name;
    private String code;
    private Integer status;

    private EnumShopOrderStatus(String name, String code, Integer status) {
        this.name = name;
        this.code = code;
        this.status = status;
    }

    public static String getName(String code) {
        for (EnumShopOrderStatus c : EnumShopOrderStatus.values()) {
            if (code.equals(c.getCode())) {
                return c.name;
            }
        }
        return null;
    }

    public static String getName(Integer status) {
        for (EnumShopOrderStatus c : EnumShopOrderStatus.values()) {
            if (status == c.status) {
                return c.name;
            }
        }
        return null;
    }

    public static String getCode(Integer status) {
        for (EnumShopOrderStatus c : EnumShopOrderStatus.values()) {
            if (status == c.status) {
                return c.code;
            }
        }
        return null;
    }

    public static Integer getStatus(String code) {
        for (EnumShopOrderStatus c : EnumShopOrderStatus.values()) {
            if (code.equals(c.getCode())) {
                return c.status;
            }
        }
        return null;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
}
