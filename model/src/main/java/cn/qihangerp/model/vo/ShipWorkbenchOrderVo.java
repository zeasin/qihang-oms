package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

/**
 * 打单发货队列-发货单元行VO（未拆主单/子订单平铺）
 * 参照 qihang-erp-pro ShipWorkbenchOrderVo（docs/design/16-打单发货.md §4.1 列表列）
 * 与 erp-pro 差异：OMS o_order 无 latest_delivery_time 列，最晚发货时间不展示
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class ShipWorkbenchOrderVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    /** 平台订单号 */
    private String orderNum;
    /** 订单角色：0主订单 1子订单（EnumOrderRole） */
    private Integer orderRole;
    private String orderRoleName;
    /** 订单模式 0店铺/1手工 */
    private Integer orderMode;
    private Long shopId;
    /** 店铺类型（平台，EnumShopType） */
    private Integer shopType;
    private String shopName;
    private String platformName;
    private Long merchantId;
    private Long parentOrderId;

    private Integer auditStatus;
    private Integer orderStatus;
    private Integer shipStatus;

    /** 取号状态（EnumWaybillStatus，空按未取号返回0） */
    private Integer waybillStatus;
    private String waybillStatusName;
    private String waybillCode;
    private String waybillCompany;
    private String shippingCompanyCode;

    /** 面单账号 */
    private Long waybillAccountId;
    private String waybillAccountName;
    private String waybillAccountCode;
    /** 账号所属快递公司 */
    private String waybillAccountCompany;
    /** 是否已分配面单账号（队列正常为 true，异常回落补分配为 false） */
    private Boolean allocated;

    /** 发货主体（优先明细落库值，回落账号绑定主体；shipperType=EnumShipType 口径） */
    private Integer shipperType;
    private String shipperTypeName;
    private Long shipperId;
    private String shipperName;
    private String shipperNo;
    /** 发货主体类型字符串口径（o_order_item.shipper_type） */
    private String shipperTypeCode;

    private String receiverName;
    private String receiverMobile;
    private String province;
    private String city;
    private String town;
    private String address;
    private String buyerMemo;
    private String sellerMemo;
    private String tag;

    private Double payment;
    private LocalDateTime orderTime;
    private Date createTime;
    /** 进入当前队列的停留小时数（按订单创建时间计算） */
    private Long stayHours;
    /** 距发货超时的剩余小时数（负值=已超时小时数；createTime 或时效配置缺失为 null） */
    private Integer remainHours;

    private String goodsSummary;
    private Integer itemCount;
    private Integer totalQuantity;
    private String firstImage;
    private List<ShipWorkbenchItemVo> items;
}
