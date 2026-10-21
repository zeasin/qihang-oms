package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 打单发货-取消取号参数
 * 参照 qihang-erp-pro ShipWorkbenchCancelBo（docs/design/16-打单发货.md §4.2）
 * 仅 waybill_status=1（已取号未打印）可取消；取消后回未取号并保留面单账号供重取沿用
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class ShipWorkbenchCancelBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 发货单元ID列表（未拆主单或子订单行） */
    private List<Long> orderIds;
}
