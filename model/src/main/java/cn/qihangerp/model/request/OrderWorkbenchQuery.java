package cn.qihangerp.model.request;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 订单处理工作台查询对象
 * 参照 qihang-erp-pro OrderWorkbenchQuery（docs/design/15-订单处理工作台.md §2.2/§2.3）
 * 与 erp-pro 差异：OMS o_order 无 latest_delivery_time / shipping_time / member_id 列，
 * 相应筛选（最晚发货区间、发货时间排序）本阶段不做
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class OrderWorkbenchQuery implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 订单号：支持多号输入，换行/英文逗号/中文逗号/分号/空白分隔，上限50个 */
    private String orderNums;
    /** 状态池：pending待审核 / exception异常池 / released待发货 / shipped已发货（默认pending） */
    private String pool;
    /** 店铺ID */
    private Long shopId;
    /** 店铺类型（平台） */
    private Integer shopType;
    /** 商户ID（前端不传时由 Controller 按登录身份填充；null=总部不限） */
    private Long merchantId;
    /** 商品关键词：匹配商品标题/规格编码/条码（模糊） */
    private String goodsKeyword;
    /** 订单时间起（yyyy-MM-dd 或 yyyy-MM-dd HH:mm:ss） */
    private String orderTimeBegin;
    /** 订单时间止（yyyy-MM-dd 或 yyyy-MM-dd HH:mm:ss） */
    private String orderTimeEnd;
    /** 店铺ID列表（多选，逗号分隔） */
    private String shopIds;
    /** 收件人姓名（模糊） */
    private String receiverName;
    /** 收件人手机号（模糊） */
    private String receiverMobile;
    /** 收货省份 */
    private String province;
    /** 收货城市 */
    private String city;
    /** 收货区/县 */
    private String district;
    /** 订单模式：0店铺订单 1手工订单（OMS 口径） */
    private Integer orderMode;
    /** 订单状态（EnumOOrderStatus，仅"全部"tab生效；不传=全部状态含已取消/已删除） */
    private Integer orderStatus;
    /** 审核状态（EnumAuditStatus，仅"全部"tab生效） */
    private Integer auditStatus;
    /** 发货主体类型（匹配订单明细 ship_type，EnumShipType） */
    private Integer shipperType;
    /** 发货主体ID（匹配订单明细 shipper_id） */
    private Long shipperId;
    /** 发货方分类（仅待发货池生效）：self店铺自用 / supplier供应商 / cloud云仓 */
    private String shipperCategory;
    /** 是否含买家留言（true=buyer_memo 非空） */
    private Boolean hasBuyerMemo;
    /** 标签ID列表（多选，逗号分隔；命中任一标签即返回） */
    private String tagIds;
    /** 买家留言（模糊） */
    private String buyerMemo;
    /** 卖家备注（模糊） */
    private String sellerMemo;
    /** 实付金额下限 */
    private BigDecimal amountMin;
    /** 实付金额上限 */
    private BigDecimal amountMax;
    /** 排序列白名单：payment实付金额 / orderTime下单时间 / goodsSummary / skuNumText / goodsNumText（空=默认下单时间倒序） */
    private String sortField;
    /** 排序方向：ascending正序 / 其他=倒序 */
    private String sortOrder;
    /** 超时预警筛选：空=不过滤 / soon即将超时（剩余0~12小时） / timeout已超时（剩余<0），口径=sys_config order.ship.timeout.hours + create_time */
    private String timeoutFilter;
}
