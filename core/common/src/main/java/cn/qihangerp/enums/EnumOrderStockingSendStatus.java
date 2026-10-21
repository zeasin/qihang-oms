package cn.qihangerp.enums;

/**
 * 描述：发货单发送状态（o_order_stocking / o_order_stocking_item.send_status，供应商发货单/备货单）
 * 0待发货 1部分发货 2全部发货 3已推送（发货指令推送成功：平台发货回传成功/云仓推送成功）
 * 口径对齐 qihang-erp-pro EnumOrderStockingSendStatus（docs/design/16-打单发货.md §六）
 */
public enum EnumOrderStockingSendStatus {
    NOT("待发货", 0),
    BU_FEN("部分发货", 1),
    ALL("全部发货", 2),
    PUSHED("已推送", 3)
    ;
    private String name;
    private int index;

    private EnumOrderStockingSendStatus(String name, int index) {
        this.name = name;
        this.index = index;
    }

    public static String getName(int index) {
        for (EnumOrderStockingSendStatus c : EnumOrderStockingSendStatus.values()) {
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
