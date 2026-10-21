package cn.qihangerp.enums;

/**
 * 描述：订单审核类型（o_order.audit_type）
 * 0自动审核（系统按规则/开关直接放行，audit_by 记 system） 1人工审核（审单工作台操作，audit_by 记用户名）
 * 迁移脚本：docs/sql/20261021-order-audit/01_o_order_audit_and_ship_columns.sql
 */
public enum EnumAuditType {
    AUTO("自动审核", 0),
    MANUAL("人工审核", 1);

    private String name;
    private int index;

    private EnumAuditType(String name, int index) {
        this.name = name;
        this.index = index;
    }

    public static String getName(int index) {
        for (EnumAuditType c : EnumAuditType.values()) {
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
