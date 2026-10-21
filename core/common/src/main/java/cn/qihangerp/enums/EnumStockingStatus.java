package cn.qihangerp.enums;

/**
 * 描述：备货单状态（o_order_stocking / o_order_stocking_item.stocking_status）
 * 0待备货(待出库) 1部分备货(出库中) 2全部备货(已出库)
 * 口径对齐 qihang-erp-pro EnumStockingStatus（docs/design/16-打单发货.md §六）
 */
public enum EnumStockingStatus {
    WAIT("待备货", 0),
    BU_FEN("部分备货", 1),
    ALL("全部备货", 2)
    ;
    private String name;
    private int index;

    private EnumStockingStatus(String name, int index) {
        this.name = name;
        this.index = index;
    }

    public static String getName(int index) {
        for (EnumStockingStatus c : EnumStockingStatus.values()) {
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
