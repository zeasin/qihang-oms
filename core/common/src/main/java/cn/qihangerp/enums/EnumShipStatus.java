package cn.qihangerp.enums;

/**
 * 描述：发货状态
 * o_order.ship_status：0未发货 1部分发货 2全部发货 3无需发货（拆单后的主订单，履约由子订单承担）
 * o_order_item.ship_status：0待发货 1已分配发货 2全部发货 10已取号（中间态，仅明细行使用）
 * 与平台回传状态 o_order.platform_ship_status 完全分离，后者不使用本枚举。
 * 迁移脚本：docs/sql/20261021-order-audit/01_o_order_audit_and_ship_columns.sql
 */
public enum EnumShipStatus {
    NOT("未发货", 0),
    BU_FEN("部分发货", 1),
    ALL("全部发货", 2),
    NO_SHIP("无需发货", 3),
    TAKEN("已取号", 10);

    private String name;
    private int index;

    private EnumShipStatus(String name, int index) {
        this.name = name;
        this.index = index;
    }

    public static String getName(int index) {
        for (EnumShipStatus c : EnumShipStatus.values()) {
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
