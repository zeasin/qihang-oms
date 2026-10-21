package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 打单发货-取号参数
 * 参照 qihang-erp-pro ShipWorkbenchTakeBo（docs/design/16-打单发货.md §4.3）
 * 取号沿用订单已分配的 waybill_account_id，不接收平台路由参数
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class ShipWorkbenchTakeBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 发货单元ID列表（未拆主单或子订单行） */
    private List<Long> orderIds;
}
