package cn.qihangerp.enums;

/**
 * 描述：发货类型
 */
public enum EnumShipType {
    LOCAL("本地发货", 0),
    JD_CLOUD_WAREHOUSE("京东云仓发货", 100),
    JKY_CLOUD_WAREHOUSE("吉客云云仓发货", 110),
    CLOUD_WAREHOUSE("系统云仓发货", 200),
    SUPPLIER("供应商发货", 300),
    OTHER("其他", 999)
    ;
    private String name;
    private int index;

    private EnumShipType(String name, int index) {
        this.name = name;
        this.index = index;
    }

    public static String getName(int index) {
        for (EnumShipType c : EnumShipType.values()) {
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
