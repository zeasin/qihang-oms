package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 打单发货-状态漂移修复参数
 * 漂移类型与修复动作由后端 detectDrift 检测确定，本 BO 仅提交发货单元ID列表
 *
 * @author qihang
 * @date 2026-10-23
 */
@Data
public class ShipWorkbenchDriftFixBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 发货单元ID列表（o_order.id，取自漂移检测结果） */
    private List<Long> orderIds;
}
