package cn.qihangerp.enums;

public enum EnumShopRefundPhase {
    ON_SALE("售中", "ON_SALE"),
    AFTER_SALE("售后", "AFTER_SALE");

    private String name;
    private String code;

    private EnumShopRefundPhase(String name, String code) {
        this.name = name;
        this.code = code;
    }

    public static String getName(String code) {
        for (EnumShopRefundPhase c : EnumShopRefundPhase.values()) {
            if (code.equals(c.getCode())) {
                return c.name;
            }
        }
        return null;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
}
