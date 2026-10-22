package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 打单发货-状态漂移自检结果VO
 * items=漂移明细；truncated=true 表示数据域内存活单量超过扫描上限，仅检测了前一部分，
 * 需先缩小数据域（按商户/店铺）再复检
 *
 * @author qihang
 * @date 2026-10-23
 */
@Data
public class ShipWorkbenchDriftResultVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 漂移明细 */
    private List<DriftVo> items = new ArrayList<>();
    /** 是否因扫描上限截断 */
    private Boolean truncated;
}
