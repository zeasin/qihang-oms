package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 统一电子面单-取号入参 BO
 * 参照 qihang-erp-pro WaybillTakeContext/PlatformWaybillTakeResult 契约（docs/design/16-打单发货.md §2.3 / §4.3），
 * 由打单发货队列组装后交给 PlatformWaybillAdapter.take；平台适配器不感知队列，只感知本 BO。
 * 取号唯一判据（§2.3）：waybillAccountId 必带（放行前分配），适配器按账号内平台参数调用。
 *
 * @author qihang
 * @date 2026-10-22
 */
@Data
public class WaybillTakeBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 发货单元订单主键（o_order.id，子订单行） */
    private Long orderId;

    /** 平台订单号（o_order.order_num） */
    private String orderNum;

    /** 店铺 id */
    private Long shopId;

    /** 平台类型（EnumShopType.getIndex()，路由依据） */
    private Integer shopType;

    /** 面单账号 id（oms_shop_waybill_account.id，审单分配写入，§2.3） */
    private Long waybillAccountId;

    /** 面单账号实体（含网点/快递编码/发货人/模板，取号沿用账号，不再重选） */
    private ShopWaybillAccountRef waybillAccount;

    /** 收件人姓名 */
    private String receiverName;

    /** 收件人手机号 */
    private String receiverMobile;

    /** 收件省 */
    private String receiverProvince;

    /** 收件市 */
    private String receiverCity;

    /** 收件区/县 */
    private String receiverDistrict;

    /** 收件乡镇/街道 */
    private String receiverTown;

    /** 收件详细地址 */
    private String receiverDetail;

    /** 收件信息加密串（平台密文收件，抖音等使用；无值时适配器回退明文） */
    private String receiverOpenId;

    /** 商品明细（本发货单元内，退款成功行已由队列剔除） */
    private List<WaybillTakeItemBo> items;

    /**
     * 面单账号引用：仅承载取号所需平台参数，避免 model 反向依赖实体细节；
     * 队列装配时由 ShopWaybillAccount 转换填充。
     */
    @Data
    public static class ShopWaybillAccountRef implements Serializable {

        private static final long serialVersionUID = 1L;

        /** 账号 id */
        private Long id;

        /** 平台快递公司编码（抖店 provider_code / 菜鸟 cpCode 等） */
        private String providerCode;

        /** 平台物流公司名称（展示用） */
        private String refLogisticsName;

        /** 发货人姓名（账号配置） */
        private String deliverName;

        /** 发货人手机号（账号配置） */
        private String deliverMobile;

        /** 发货人所在省/市/区/镇（账号签约地址） */
        private String provinceName;
        private String cityName;
        private String districtName;
        private String townName;

        /** 发货人详细地址（账号签约地址） */
        private String senderDetail;

        /** 打印模板地址 */
        private String templateUrl;
    }
}
