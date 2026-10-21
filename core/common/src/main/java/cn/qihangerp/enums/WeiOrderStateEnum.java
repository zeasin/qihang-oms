package cn.qihangerp.enums;

/**
 * 描述：视频号（微信小店）订单状态（oms_wei_order.status）
 * 10 待付款；20 待发货；21 部分发货；30 待收货；100 完成；
 * 200 全部商品售后之后订单取消；250 未付款用户主动取消或超时未付款订单自动取消
 * 拉单转单口径：200/250（取消、售后关闭）不转入 o_order
 */
public enum WeiOrderStateEnum {
    WAIT_PAY("待付款", 10),
    WAIT_SEND("待发货", 20),
    PART_SEND("部分发货", 21),
    WAIT_RECEIVE("待收货", 30),
    FINISHED("完成", 100),
    AFTER_SALE_CANCELED("售后取消", 200),
    CANCELED("取消", 250);

    private String name;
    private int index;

    private WeiOrderStateEnum(String name, int index) {
        this.name = name;
        this.index = index;
    }

    public static String getName(int index) {
        for (WeiOrderStateEnum c : WeiOrderStateEnum.values()) {
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
