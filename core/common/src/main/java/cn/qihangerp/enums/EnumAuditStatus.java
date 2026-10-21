package cn.qihangerp.enums;

/**
 * 描述：订单审核状态（o_order.audit_status）
 * 0待审核 1已审核通过 2已转异常 3已拆单（主订单拆单后终态，退出全部状态池）
 * 状态池语义与 o_order_tag.bind_pool 对齐：0=待审核池 2=异常池
 * 落库口径：人工审单开关（sys_config：order.manual_audit.enabled，OMS默认true）开启时
 * 建单/拉单链路显式置 PENDING(0)，放行后置 APPROVED(1)；开关关闭时落库即 APPROVED(1)。
 * 迁移脚本：docs/sql/20261021-order-audit/01_o_order_audit_and_ship_columns.sql
 */
public enum EnumAuditStatus {
    PENDING("待审核", 0),
    APPROVED("已审核通过", 1),
    EXCEPTION("已转异常", 2),
    SPLIT("已拆单", 3);

    private String name;
    private int index;

    private EnumAuditStatus(String name, int index) {
        this.name = name;
        this.index = index;
    }

    public static String getName(int index) {
        for (EnumAuditStatus c : EnumAuditStatus.values()) {
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
