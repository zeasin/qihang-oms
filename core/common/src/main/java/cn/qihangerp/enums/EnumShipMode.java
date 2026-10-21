package cn.qihangerp.enums;

/**
 * 描述：备货单发货方式（o_order_stocking.ship_mode）
 * 0手动发货 1电子面单发货
 * 打单发货统一队列落备货单时使用：面单链路发货=1，手动发货兜底通道=0
 * （口径对齐 qihang-erp-pro EnumShipMode，docs/design/16-打单发货.md §六）
 */
public enum EnumShipMode {
    MANUAL("手动发货", 0),
    ELECTRONIC("电子面单发货", 1)
    ;
    private String name;
    private int index;

    private EnumShipMode(String name, int index) {
        this.name = name;
        this.index = index;
    }

    public static String getName(int index) {
        for (EnumShipMode c : EnumShipMode.values()) {
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
