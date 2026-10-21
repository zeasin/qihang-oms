package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 打单发货-发货参数（平台面单链路）
 * 参照 qihang-erp-pro ShipWorkbenchShipBo（docs/design/16-打单发货.md §4.6）
 * 单号与快递公司编码取订单取号时回写的实际值，不接收动作级平台参数
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class ShipWorkbenchShipBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 发货单元ID列表 */
    private List<Long> orderIds;
}
