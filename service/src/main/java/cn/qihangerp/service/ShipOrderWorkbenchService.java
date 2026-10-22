package cn.qihangerp.service;

import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.model.bo.ShipWorkbenchCancelBo;
import cn.qihangerp.model.bo.ShipWorkbenchDistributeBo;
import cn.qihangerp.model.bo.ShipWorkbenchManualShipBo;
import cn.qihangerp.model.bo.ShipWorkbenchPrintBo;
import cn.qihangerp.model.bo.ShipWorkbenchReturnBo;
import cn.qihangerp.model.bo.ShipWorkbenchShipBo;
import cn.qihangerp.model.bo.ShipWorkbenchTakeBo;
import cn.qihangerp.model.entity.ShopWaybillAccount;
import cn.qihangerp.model.request.ShipWorkbenchQuery;
import cn.qihangerp.model.vo.ShipWorkbenchActionResultVo;
import cn.qihangerp.model.vo.ShipWorkbenchDriftFixResultVo;
import cn.qihangerp.model.vo.ShipWorkbenchDriftResultVo;
import cn.qihangerp.model.vo.ShipWorkbenchOrderVo;
import cn.qihangerp.model.vo.ShipWorkbenchPoolCountsVo;
import cn.qihangerp.service.waybill.PlatformWaybillCapability;

import java.util.List;

/**
 * 打单发货统一队列服务（阶段4b）
 * 参照 qihang-erp-pro ShipOrderWorkbenchWaybillService（docs/design/16-打单发货.md §四/§五/§六/§8.1）
 * <p>
 * 编排口径差异：erp-pro 为微服务（ship-api 经 ec-api Feign 调平台与账号）；OMS 为单体工程，
 * 队列直接本地调用 {@link cn.qihangerp.service.waybill.PlatformWaybillAdapterRegistry} 路由平台适配器、
 * 面单账号直接读 ShopWaybillAccountService，状态机与落库口径与 erp-pro 完全一致。
 *
 * @author qihang
 * @date 2026-10-21
 */
public interface ShipOrderWorkbenchService {

    /** 队列分页：已放行且未发货的发货单元平铺（未拆主单 + 拆分子单；排除合并子单与已发货面单状态） */
    PageResult<ShipWorkbenchOrderVo> page(ShipWorkbenchQuery query, PageQuery pageQuery);

    /** 队列页签计数（待取号/待打印/待发货/待补分配 + 合计） */
    ShipWorkbenchPoolCountsVo poolCounts(ShipWorkbenchQuery query);

    /** 发货单元详情 */
    ShipWorkbenchOrderVo detail(Long id, List<Long> merchantIds);

    /**
     * 按店铺 + 发货主体查询可用面单账号（分配弹窗数据源；口径同审单台 waybillAccountOptions）
     * 与 erp-pro 差异：单体直返 ShopWaybillAccount 实体列表（含 shipperType/shipperId），
     * 不经 ec-api 组装 EcWaybillAccountVo；merchantId 由 Controller 按登录身份收敛（null=总部不限）
     */
    ResultVo<List<ShopWaybillAccount>> accountOptions(Long shopId, Integer shopType, Integer shipperType,
                                                      Long shipperId, Long merchantId);

    /** 分配 / 改派：选中面单账号即确定发货主体 + 快递 + 网点；已取号须先取消取号 */
    ResultVo<ShipWorkbenchActionResultVo> distribute(ShipWorkbenchDistributeBo bo, List<Long> merchantIds,
                                                     String username);

    /** 整单退回异常池（必选退回原因；已取号未打印先自动取消取号，取消失败阻止退回） */
    ResultVo<ShipWorkbenchActionResultVo> returnToException(ShipWorkbenchReturnBo bo, List<Long> merchantIds,
                                                            String username);

    /**
     * 取号：按订单已分配的面单账号调平台适配器，成功后落打单记录
     *
     * @param shopId 店铺端数据范围（非店铺端传 null）
     */
    ResultVo<ShipWorkbenchActionResultVo> take(ShipWorkbenchTakeBo bo, List<Long> merchantIds, Long shopId,
                                               String username);

    /** 取消取号：已取号未打印 → 平台取消成功后本地回未取号（保留面单账号供重取沿用） */
    ResultVo<ShipWorkbenchActionResultVo> cancel(ShipWorkbenchCancelBo bo, List<Long> merchantIds, Long shopId,
                                                 String username);

    /** 平台面单动作能力（前端按钮开放依据，§4.4 能力矩阵） */
    ResultVo<PlatformWaybillCapability> capabilities(Integer shopType);

    /** 打印：已取号 → 已打印（waybill_status 1→2；物理打印由前端打印组件负责） */
    ResultVo<ShipWorkbenchActionResultVo> print(ShipWorkbenchPrintBo bo, List<Long> merchantIds, Long shopId,
                                                String username);

    /** 发货（平台面单链路）：已打印 → 已发货（2→3），平台回传 + 本地仓落备货单 */
    ResultVo<ShipWorkbenchActionResultVo> ship(ShipWorkbenchShipBo bo, List<Long> merchantIds, Long shopId,
                                               String username);

    /** 手动发货（兜底通道）：人工录入物流公司与单号 → waybill_status=10，本地仓落备货单 */
    ResultVo<ShipWorkbenchActionResultVo> manualShip(ShipWorkbenchManualShipBo bo, List<Long> merchantIds,
                                                    Long shopId, String username);

    /**
     * 状态漂移自检：数据域内比对 o_order.waybill_status 与打单记录（o_order_ship_waybill）一致性，
     * 扫描上限保护（超限 truncated=true）
     */
    ShipWorkbenchDriftResultVo detectDrift(List<Long> merchantIds);

    /** 状态漂移修复：逐单重新检测确认后按类型修复（REQUIRES_NEW 单单独立事务） */
    ResultVo<ShipWorkbenchDriftFixResultVo> fixDrift(List<Long> orderIds, String username, List<Long> merchantIds);
}
