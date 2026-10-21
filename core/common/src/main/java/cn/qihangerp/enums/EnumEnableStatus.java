package cn.qihangerp.enums;

/**
 * 描述：通用启用/停用状态（字典、标签等主数据）
 * 参照 qihang-erp-pro cn.qihangerp.enums.EnumEnableStatus
 *
 * @author qihang
 * @date 2026-10-21
 */
public enum EnumEnableStatus {
    DISABLED("禁用", 0),
    ENABLED("启用", 1)
    ;
    private String name;
    private int index;

    // 构造方法
    private EnumEnableStatus(String name, int index) {
        this.name = name;
        this.index = index;
    }

    // 普通方法
    public static String getName(int index) {
        for (EnumEnableStatus c : EnumEnableStatus.values()) {
            if (c.getIndex() == index) {
                return c.name;
            }
        }
        return null;
    }

    // get set 方法
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
