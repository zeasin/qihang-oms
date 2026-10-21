package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 订单处理工作台-批量放行结果VO（逐单结果，部分失败留池）
 * 参照 qihang-erp-pro OrderReleaseResultVo（docs/design/15-订单处理工作台.md §2.8）
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class OrderReleaseResultVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 成功单数 */
    private Integer successCount;
    /** 失败单数 */
    private Integer failCount;
    /** 逐单结果 */
    private List<Item> items;

    /**
     * 逐单放行结果行
     */
    @Data
    public static class Item implements Serializable {
        private static final long serialVersionUID = 1L;
        /** 订单ID */
        private Long id;
        /** 订单号 */
        private String orderNum;
        /** 是否成功 */
        private Boolean success;
        /** 失败原因（成功为空） */
        private String msg;
    }
}
