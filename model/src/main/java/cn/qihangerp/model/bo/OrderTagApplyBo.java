package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 订单处理工作台-批量打标/撤标请求
 * 参照 qihang-erp-pro OrderTagApplyBo
 * 打标=追加标签ID（重复自动去重）；撤标=移除标签ID；
 * 标签串由服务端按动作拼接后整串回写 o_order.tag
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class OrderTagApplyBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 动作：1=打标（追加），0=撤标（移除） */
    private Integer action;
    /** 订单ID列表（o_order.id） */
    private List<String> orderIds;
    /** 标签ID列表（o_order_tag.id） */
    private List<Long> tagIds;
}
