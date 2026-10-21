package cn.qihangerp.model.bo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 订单处理工作台-批量审核放行请求
 * 参照 qihang-erp-pro OrderReleaseBo（docs/design/15-订单处理工作台.md §2.8）
 * 支持主订单/子订单混合勾选；部分失败留池并返回逐单原因，成功单不回滚
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
public class OrderReleaseBo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 订单ID列表（主订单或子订单） */
    private List<Long> ids;
    /** 放行备注（可选） */
    private String remark;
    /** 分店铺面单账号（同一店铺一次放行只选一张账号，选中账号即确定发货主体+快递+网点） */
    private List<ShopAssignment> assignments;

    /**
     * 店铺面单账号
     */
    @Data
    public static class ShopAssignment implements Serializable {
        private static final long serialVersionUID = 1L;
        private Long shopId;
        private Integer shopType;
        private Long waybillAccountId;
    }
}
