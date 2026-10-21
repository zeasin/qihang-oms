package cn.qihangerp.enums;

/**
 * 描述：订单角色（o_order.order_role；o_order_item.item_role 同口径）
 * 0主订单MASTER 1子订单CHILD 2合并发货子订单MERGE_CHILD
 * 主订单 parent_order_id 固定为0；子订单 parent_order_id 指向主订单id。
 * 迁移脚本：docs/sql/20261021-order-audit/01_o_order_audit_and_ship_columns.sql
 */
public enum EnumOrderRole {
    MASTER("主订单", 0),
    CHILD("子订单", 1),
    MERGE_CHILD("合并发货子订单", 2);

    private String name;
    private int index;

    private EnumOrderRole(String name, int index) {
        this.name = name;
        this.index = index;
    }

    public static String getName(int index) {
        for (EnumOrderRole c : EnumOrderRole.values()) {
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
