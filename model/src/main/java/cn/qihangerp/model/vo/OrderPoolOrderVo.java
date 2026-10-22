package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

/**
 * 订单处理工作台-状态池订单行VO（四池平铺：主订单行与拆分子订单行各自成行）
 * 参照 qihang-erp-pro OrderPoolOrderVo（docs/design/15-订单处理工作台.md §2.1/§2.2）
 * 与 erp-pro 差异：OMS o_order 无 member_id / shipping_time / latest_delivery_time 列，本阶段不展示
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class OrderPoolOrderVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 订单ID */
    private Long id;
    /** 平台订单号 */
    private String orderNum;
    /** 订单角色：0主订单 1子订单 2合并发货子订单（EnumOrderRole） */
    private Integer orderRole;
    /** 订单角色名称 */
    private String orderRoleName;
    /** 订单模式 0店铺订单 1手工订单（OMS 口径） */
    private Integer orderMode;
    /** 审核状态：0待审核 1已放行 2已转异常 3已拆单（EnumAuditStatus） */
    private Integer auditStatus;
    private String auditStatusName;
    /** 拆分子单所属主单ID（子单行有值） */
    private Long parentOrderId;
    private Long shopId;
    /** 店铺类型（平台） */
    private Integer shopType;
    private Long merchantId;
    /** 订单状态 */
    private Integer orderStatus;
    /** 发货状态：0未发货 1部分 2全部 3无需发货（EnumShipStatus） */
    private Integer shipStatus;
    /** 取号状态（EnumWaybillStatus） */
    private Integer waybillStatus;
    /** 面单账号ID */
    private Long waybillAccountId;
    private String waybillCode;
    private String waybillCompany;
    private BigDecimal goodsAmount;
    private BigDecimal postFee;
    private BigDecimal amount;
    private BigDecimal payment;
    private String receiverName;
    private String receiverMobile;
    private String province;
    private String city;
    private String town;
    private String address;
    private String buyerMemo;
    private String sellerMemo;
    /** 标签ID列表（逗号分隔） */
    private String tag;
    /** 下单时间 */
    private LocalDateTime orderTime;
    private Date createTime;
    /** 距发货超时的剩余小时数（负值=已超时小时数；createTime 或时效配置缺失为 null） */
    private Integer remainHours;

    /** 已拆分标记：主单存在有效拆分子单（主订单行，四池平铺展示用） */
    private Boolean splitFlag;
    /** 是否可放行（结构就绪：未拆分主单=数量完整；已拆分主单=全部子单结构就绪；子单=明细完整） */
    private Boolean canRelease;
    /** 不可放行原因（可放行为空） */
    private String canReleaseMsg;
    /** 是否已分配面单账号（未拆分主单/子单=自身有账号；已拆分主单=全部有效子单都有账号） */
    private Boolean allocated;
    /** 商品摘要（商品名(款式编码/商品编码)×数量 拼接） */
    private String goodsSummary;
    /** 款式编码（明细去重逗号拼接） */
    private String skuNumText;
    /** 商品编码（明细去重逗号拼接） */
    private String goodsNumText;
    /** 明细首图（列表缩略图展示） */
    private String firstImage;
    /** 商品款数（展示明细行数） */
    private Integer itemCount;
    /** 商品件数合计 */
    private Integer totalQuantity;

    /** 子订单行（主订单行内嵌：拆分子订单，只读展示） */
    private List<OrderPoolOrderVo> children;

    /** 商品明细全量（列表平铺展示，原始明细或履约明细按行角色） */
    private List<OrderPoolItemVo> items;
}
