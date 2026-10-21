package cn.qihangerp.enums;

/**
 * 描述：电子面单取号状态
 * 共用字段：o_order.waybill_status、o_order_stocking.waybill_status、
 *          o_order_stocking_item.waybill_status、o_order_ship_waybill.status
 * 0未取号 1已取号 2已打印 3已发货 10手动发货（无面单账号/线下寄出，人工填单号）
 * 注意：o_order_ship_waybill.status 从1开始，不使用0。
 * 迁移脚本：docs/sql/20261021-order-audit/01_o_order_audit_and_ship_columns.sql
 */
public enum EnumWaybillStatus {
    NOT_TAKEN("未取号", 0),
    TAKEN("已取号", 1),
    PRINTED("已打印", 2),
    SHIPPED("已发货", 3),
    MANUAL_SHIPPED("手动发货", 10);

    private String name;
    private int index;

    private EnumWaybillStatus(String name, int index) {
        this.name = name;
        this.index = index;
    }

    public static String getName(int index) {
        for (EnumWaybillStatus c : EnumWaybillStatus.values()) {
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
