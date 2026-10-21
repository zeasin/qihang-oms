package cn.qihangerp.enums;

/**
 * 描述：店铺订单售后状态（shop_order/pdd_order 等平台落地表 refund_status 等同语义字段）
 * 售后状态 1：无售后或售后关闭，2：售后处理中，3：退款中，4： 退款成功
 * 移植自 qihang-erp-pro EnumOrderRefundStatus
 */
public enum EnumOrderRefundStatus {
    NOT_REFUND("无售后或售后关闭", "NOT_REFUND", 1),
    AFTER("售后处理中", "AFTER", 2),
    REFUNDING("退款中", "REFUNDING", 3),
    COMPLETE("售后完成", "COMPLETE", 4),
    NONE("未知", "NONE", 0)
    ;
    private String name;
    private String code;
    private Integer status;

    // 构造方法
    private EnumOrderRefundStatus(String name, String code, Integer status) {
        this.name = name;
        this.code = code;
        this.status = status;
    }

    // 普通方法
    public static String getName(String code) {
        for (EnumOrderRefundStatus c : EnumOrderRefundStatus.values()) {
            if (code.equals(c.getCode())) {
                return c.name;
            }
        }
        return null;
    }

    // 普通方法
    public static String getName(Integer status) {
        for (EnumOrderRefundStatus c : EnumOrderRefundStatus.values()) {
            if (status == c.status) {
                return c.name;
            }
        }
        return null;
    }

    public static String getCode(Integer status) {
        for (EnumOrderRefundStatus c : EnumOrderRefundStatus.values()) {
            if (status == c.status) {
                return c.code;
            }
        }
        return null;
    }

    public static int getStatus(String code) {
        for (EnumOrderRefundStatus c : EnumOrderRefundStatus.values()) {
            if (code.equals(c.getCode())) {
                return c.status;
            }
        }
        return -1;
    }

    // get set 方法
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
}
