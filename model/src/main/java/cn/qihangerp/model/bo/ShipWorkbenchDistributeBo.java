package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 打单发货-分配/改派参数
 * 参照 qihang-erp-pro ShipWorkbenchDistributeBo（docs/design/16-打单发货.md §3.1 / §3.2）
 * 选中面单账号即同时确定 发货主体 + 快递 + 网点（快递与网点由账号自带，不单独传参）
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class ShipWorkbenchDistributeBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 发货单元ID列表（未拆主单或子订单行 o_order.id） */
    private List<Long> orderIds;
    /** 面单账号ID（oms_shop_waybill_account.id） */
    private Long waybillAccountId;
}
