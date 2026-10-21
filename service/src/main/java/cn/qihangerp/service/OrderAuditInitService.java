package cn.qihangerp.service;

import cn.qihangerp.model.entity.OOrder;
import cn.qihangerp.model.entity.OOrderItem;

import java.util.List;

/**
 * 订单审核初始化 / 拉单转单共用组件（阶段2：平台拉单落库直接生成 o_order）
 *
 * 职责：
 * 1. 读取 sys_config：order.manual_audit.enabled（OMS 口径：默认 true，订单进来必须人工审核）；
 * 2. applyAuditInit：按开关初始化 o_order 审核字段与主/子订单字段；
 * 3. syncToOOrder：以 sourceOrderId(平台落地表订单主键字符串)+shopType 为幂等键，
 *    幂等写入 o_order + o_order_item，已存在则跳过。
 */
public interface OrderAuditInitService {

    /** 人工审单开关（sys_config：order.manual_audit.enabled，带本地缓存） */
    boolean isManualAuditEnabled();

    /**
     * 初始化审核字段与父子订单字段。拉单入库的都是主订单。
     * manualAudit=true  → auditStatus=PENDING(0)、auditType=MANUAL(1)，等待审单工作台放行；
     * manualAudit=false → auditStatus=APPROVED(1)、auditType=AUTO(0)、auditTime=now、auditBy=system；
     * 两种情况均强制 orderRole=MASTER(0)、parentOrderId=0。
     */
    void applyAuditInit(OOrder order, boolean manualAudit);

    /**
     * 幂等转单：先按 sourceOrderId+shopType 查 o_order，已存在则整单跳过不写。
     * 写入前调用 applyAuditInit（按开关决定自动/人工审核），明细 itemRole 缺省置 MASTER(0)。
     *
     * @param order 平台侧组装好的主订单（必须已设置 sourceOrderId、shopType）
     * @param items 平台侧组装好的订单明细（orderId 由本方法回填，可为空由调用方保证）
     * @return 插入成功返回带 id 的 OOrder；已存在（跳过）返回 null
     */
    OOrder syncToOOrder(OOrder order, List<OOrderItem> items);
}
