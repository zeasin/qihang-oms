package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 订单处理工作台-异常池分类计数VO（分类导航节点数据源）
 * 参照 qihang-erp-pro ExceptionTagCountVo（docs/design/15-订单处理工作台.md §2.2/§2.4）
 * 分类=bind_pool=2 的标签（全系统共用）；「未分类」兜底统计未选分类的异常单
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class ExceptionTagCountVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 分类计数列表（含未命中的分类，count=0） */
    private List<Item> tags;
    /** 未分类兜底计数（tag 串中不含任何分类标签ID的异常单） */
    private Long uncategorized;

    @Data
    public static class Item implements Serializable {
        private static final long serialVersionUID = 1L;
        /** 标签ID */
        private Long tagId;
        /** 标签名称 */
        private String name;
        /** 标签颜色 */
        private String color;
        /** 状态（0停用 1启用；停用分类灰显保留计数） */
        private Integer status;
        /** 当前池内订单数 */
        private Long count;
    }
}
