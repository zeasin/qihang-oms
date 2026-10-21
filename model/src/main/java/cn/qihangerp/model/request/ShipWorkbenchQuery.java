package cn.qihangerp.model.request;

import lombok.Data;

import java.io.Serializable;

/**
 * 打单发货统一队列查询对象
 * 参照 qihang-erp-pro ShipWorkbenchQuery（docs/design/16-打单发货.md §4.1）
 * 与 erp-pro 差异：OMS o_order 无 latest_delivery_time 列，最晚发货时间排序不做
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class ShipWorkbenchQuery implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 平台订单号：支持多号输入，换行/英文逗号/中文逗号/分号/空白分隔，上限50个 */
    private String orderNums;
    /** 店铺ID */
    private Long shopId;
    /** 店铺ID列表（多选，逗号分隔） */
    private String shopIds;
    /** 店铺类型（平台，EnumShopType） */
    private Integer shopType;
    /** 商户ID（前端不传，由 Controller 按登录身份填充；null=总部不限） */
    private Long merchantId;
    /** 取号状态（EnumWaybillStatus：0未取号 1已取号 2已打印；未取号查询按 NULL 兜底） */
    private Integer waybillStatus;
    /** 面单账号ID（电子面单分组筛选） */
    private Long waybillAccountId;
    /** 发货方分类：self店铺自用 / supplier供应商 / cloud云仓 */
    private String shipperCategory;
    /** 发货主体类型（匹配订单明细 ship_type，EnumShipType） */
    private Integer shipperType;
    /** 发货主体ID（匹配订单明细 shipper_id） */
    private Long shipperId;
    /** 仅看未分配面单账号（异常回落补分配子视图：waybill_account_id IS NULL） */
    private Boolean allocatePending;
    /** 收件人姓名（模糊） */
    private String receiverName;
    /** 收件人手机号（模糊） */
    private String receiverMobile;
    /** 商品关键词：匹配商品标题/规格编码/条码（模糊） */
    private String goodsKeyword;
    /** 排序列白名单：stayTime停留时长 / waybillStatus取号状态（空=下单时间倒序） */
    private String sortField;
    /** 排序方向：ascending正序 / 其他=倒序 */
    private String sortOrder;
}
