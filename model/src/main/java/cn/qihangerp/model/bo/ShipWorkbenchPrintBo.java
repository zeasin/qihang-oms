package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 打单发货-打印参数
 * 参照 qihang-erp-pro ShipWorkbenchPrintBo（docs/design/16-打单发货.md §4.5）
 * 本接口仅推进面单状态 1→2；打印数据取号时已落 o_order_ship_waybill，物理打印由前端打印组件负责
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class ShipWorkbenchPrintBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 发货单元ID列表 */
    private List<Long> orderIds;
}
