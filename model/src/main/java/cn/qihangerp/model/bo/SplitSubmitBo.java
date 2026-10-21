package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 订单处理工作台-拆单提交请求（一单一单真实拆单，部分拆模型）
 * 参照 qihang-erp-pro SplitSubmitBo（docs/design/15-订单处理工作台.md §2.5）
 * 2026-10-19 定版：弹窗内可反复「添加到待拆分」攒多个批次，最后统一拆分；
 * 每批生成一个子单平挂顶层主单下，原单保留剩余；校验口径=各商品行
 * 「本次累计拆出 + 已拆出 ≤ 可发货数量」；发货主体可空（后置到打单发货分配）
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class SplitSubmitBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 被拆订单ID（未拆分主订单或未发货子订单） */
    private Long orderId;

    /** 拆单分组列表（每组将生成一个子订单） */
    private List<SplitGroupBo> groups;

    /**
     * 拆单分组（待拆单列表中的一组）
     */
    @Data
    public static class SplitGroupBo implements Serializable {
        private static final long serialVersionUID = 1L;
        /** 分组名（仅界面标识，默认 分组1/2/N） */
        private String groupName;
        /** 发货方式（EnumShipType）：0本地仓库发货 / 300供应商发货；可空=后置到打单发货分配 */
        private Integer shipType;
        /** 仓库ID（shipType=0 时必填） */
        private Long warehouseId;
        /** 供应商ID（shipType=300 时必填） */
        private Long supplierId;
        /** 物流公司ID（erp_logistics_company.id，选填；填写时写 waybill_company+shipping_company_code） */
        private Long logisticsId;
        /** 本组明细分配 */
        private List<SplitItemBo> items;
    }

    /**
     * 分组明细行
     */
    @Data
    public static class SplitItemBo implements Serializable {
        private static final long serialVersionUID = 1L;
        /** 被拆订单商品行ID（o_order_item.id，主单=原始行 item_role=0；子单=履约行 item_role=1） */
        private Long sourceOrderItemId;
        /** 分配数量（同一明细可跨组拆分） */
        private Integer quantity;
    }
}
