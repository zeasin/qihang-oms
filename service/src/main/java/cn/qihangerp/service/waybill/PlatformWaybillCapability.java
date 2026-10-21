package cn.qihangerp.service.waybill;

import cn.qihangerp.enums.EnumShopType;
import lombok.Data;

import java.io.Serializable;

/**
 * 平台电子面单动作能力（取号/取消/打印/发货）
 * 参照 qihang-erp-pro PlatformWaybillCapability（docs/design/16-打单发货.md §4.4 能力矩阵）：
 * 能力矩阵是统一队列按钮开放与兜底通道的依据，前端按本对象决定取号/取消/打印/发货按钮是否可用。
 *
 * @author qihang
 * @date 2026-10-22
 */
@Data
public class PlatformWaybillCapability implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 店铺类型（EnumShopType.getIndex()） */
    private Integer shopType;

    /** 平台名称（EnumShopType 解析，禁止散写魔法值） */
    private String platformName;

    /** 是否已接入统一面单适配器 */
    private Boolean supported;

    /** 是否支持取号（含获取打印数据） */
    private Boolean take;

    /** 是否支持取消取号 */
    private Boolean cancel;

    /** 是否支持打印 */
    private Boolean print;

    /** 是否支持平台发货回传 */
    private Boolean ship;

    /** 能力说明 */
    private String remark;

    public static PlatformWaybillCapability of(Integer shopType, boolean supported, boolean take,
                                               boolean cancel, boolean print, boolean ship, String remark) {
        PlatformWaybillCapability capability = new PlatformWaybillCapability();
        capability.setShopType(shopType);
        capability.setPlatformName(shopType == null ? null : EnumShopType.getName(shopType));
        capability.setSupported(supported);
        capability.setTake(take);
        capability.setCancel(cancel);
        capability.setPrint(print);
        capability.setShip(ship);
        capability.setRemark(remark);
        return capability;
    }

    public static PlatformWaybillCapability unsupported(Integer shopType) {
        return of(shopType, false, false, false, false, false, "该平台暂未接入统一面单动作");
    }
}
