package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 打单发货-状态漂移修复结果VO（逐单结果，口径同队列批量动作）
 *
 * @author qihang
 * @date 2026-10-23
 */
@Data
public class ShipWorkbenchDriftFixResultVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer successCount = 0;
    private Integer failCount = 0;
    private List<Item> items = new ArrayList<>();

    @Data
    public static class Item implements Serializable {

        private static final long serialVersionUID = 1L;

        private Long orderId;
        /** 平台订单号 */
        private String orderNum;
        /** 漂移类型（NO_WAYBILL_RECORD / ORPHAN_RECORD / RECORD_NOT_SHIPPED；未检出漂移为空） */
        private String type;
        /** 修复动作描述 */
        private String action;
        private Boolean success;
        /** 失败原因（成功为空） */
        private String msg;
    }
}
