package cn.qihangerp.api.controller.workbench;

import cn.qihangerp.common.AjaxResult;
import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.common.TableDataInfo;
import cn.qihangerp.enums.EnumUserType;
import cn.qihangerp.model.bo.ShipWorkbenchCancelBo;
import cn.qihangerp.model.bo.ShipWorkbenchDriftFixBo;
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
import cn.qihangerp.model.vo.ShipWorkbenchOrderVo;
import cn.qihangerp.security.common.BaseController;
import cn.qihangerp.security.common.SecurityUtils;
import cn.qihangerp.service.ShipOrderWorkbenchService;
import cn.qihangerp.service.waybill.PlatformWaybillCapability;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Objects;

/**
 * 打单发货统一队列（/api/erp-api/orderWorkbench/waybill）
 * 参照 qihang-erp-pro ShipOrderWorkbenchWaybillController（docs/design/16-打单发货.md §4.1 / §8.2）
 * 交付队列查询/计数、详情、分配/改派、整单退回、取号/取消取号、能力查询、打印、发货、手动发货、面单账号选项。
 * <p>
 * OMS 为单体工程：路由带 /api/erp-api 前缀（与既有 Controller 命名一致），末段与 erp-pro 对齐
 * （/orderWorkbench/waybill），前端可无差别移植；erp-pro 经 Feign 透传的 Authorization token
 * 在 OMS 由 SecurityUtils 直读登录态，服务层签名不带 token。
 *
 * @author qihang
 * @date 2026-10-22
 */
@Slf4j
@AllArgsConstructor
@RestController
@RequestMapping("/api/erp-api/orderWorkbench/waybill")
public class WaybillWorkbenchController extends BaseController {

    private final ShipOrderWorkbenchService waybillService;

    /**
     * 当前登录身份
     */
    private Integer identity() {
        return SecurityUtils.getLoginUser().getUserIdentity();
    }

    /**
     * 队列查看身份：总部 / 商户 / 店铺（店铺只读+可发起取号等动作，分配与退回由总部/商户发起）
     */
    private boolean canViewQueue(Integer identity) {
        return identity != null && (identity == EnumUserType.SUPPER.getIndex()
                || identity == EnumUserType.MERCHANT.getIndex()
                || identity == EnumUserType.STORE.getIndex());
    }

    /**
     * 分配/退回身份：总部 / 商户
     */
    private boolean canDispatch(Integer identity) {
        return identity != null && (identity == EnumUserType.SUPPER.getIndex()
                || identity == EnumUserType.MERCHANT.getIndex());
    }

    /**
     * 数据范围：null=总部（全部），[商户ID]=本商户；店铺端不收敛商户（与 erp-pro 同口径，靠 shopId 收敛）
     */
    private List<Long> resolveMerchantIds(Integer identity) {
        if (identity != null && identity == EnumUserType.MERCHANT.getIndex()) {
            return List.of(SecurityUtils.getDeptId());
        }
        return null;
    }

    /**
     * 店铺端数据范围：店铺身份限本店，其余返回 null（设计文档 §七 店铺可发起取号）
     */
    private Long resolveShopId(Integer identity) {
        return identity != null && identity == EnumUserType.STORE.getIndex() ? SecurityUtils.getDeptId() : null;
    }

    /**
     * 越权拒绝的分页壳（保持前端 TableDataInfo 结构可解析）
     */
    private TableDataInfo errorTable(String msg) {
        TableDataInfo table = new TableDataInfo();
        table.setCode(500);
        table.setMsg(msg);
        return table;
    }

    /**
     * 队列分页：已放行且未发货的发货单元平铺（总部不限 / 商户限本商户 / 店铺限本店）
     */
    @GetMapping("/page")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:waybill:list')")
    public TableDataInfo page(ShipWorkbenchQuery query, PageQuery pageQuery) {
        Integer identity = identity();
        if (!canViewQueue(identity)) {
            return errorTable("仅总部、商户、店铺端可查看打单发货队列");
        }
        if (identity == EnumUserType.SUPPER.getIndex()) {
            query.setMerchantId(null);
        } else if (identity == EnumUserType.MERCHANT.getIndex()) {
            query.setMerchantId(SecurityUtils.getDeptId());
        } else {
            query.setShopId(SecurityUtils.getDeptId());
        }
        return getDataTable(waybillService.page(query, pageQuery));
    }

    /**
     * 队列页签计数（待取号/待打印/待发货/待补分配 + 合计）
     */
    @GetMapping("/poolCounts")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:waybill:list')")
    public AjaxResult poolCounts(ShipWorkbenchQuery query) {
        Integer identity = identity();
        if (!canViewQueue(identity)) {
            return AjaxResult.error("仅总部、商户、店铺端可查看打单发货队列");
        }
        if (identity == EnumUserType.SUPPER.getIndex()) {
            query.setMerchantId(null);
        } else if (identity == EnumUserType.MERCHANT.getIndex()) {
            query.setMerchantId(SecurityUtils.getDeptId());
        } else {
            query.setShopId(SecurityUtils.getDeptId());
        }
        return AjaxResult.success(waybillService.poolCounts(query));
    }

    /**
     * 发货单元详情
     */
    @GetMapping("/detail")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:waybill:list')")
    public AjaxResult detail(@RequestParam Long id) {
        Integer identity = identity();
        if (!canViewQueue(identity)) {
            return AjaxResult.error("仅总部、商户、店铺端可查看打单发货队列");
        }
        ShipWorkbenchOrderVo vo = waybillService.detail(id, resolveMerchantIds(identity));
        if (vo == null) {
            return AjaxResult.error("订单不存在或无操作权限");
        }
        if (identity == EnumUserType.STORE.getIndex() && !Objects.equals(vo.getShopId(), SecurityUtils.getDeptId())) {
            return AjaxResult.error("无该订单操作权限");
        }
        return AjaxResult.success(vo);
    }

    /**
     * 按店铺 + 发货主体查询可用面单账号（分配弹窗数据源；口径同审单台 waybillAccountOptions）
     * 总部不限商户；商户仅本商户；店铺身份需为该店铺；其余身份拒绝
     */
    @GetMapping("/accountOptions")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:waybill:list')")
    public AjaxResult accountOptions(@RequestParam Long shopId, @RequestParam Integer shopType,
                                     @RequestParam(required = false) Integer shipperType,
                                     @RequestParam(required = false) Long shipperId) {
        if (shopId == null || shopType == null) {
            return AjaxResult.error("缺少参数：shopId/shopType");
        }
        Integer identity = identity();
        if (!canViewQueue(identity)) {
            return AjaxResult.error("仅总部、商户、店铺端可查看打单发货队列");
        }
        if (identity == EnumUserType.STORE.getIndex() && !Objects.equals(shopId, SecurityUtils.getDeptId())) {
            return AjaxResult.error("无该店铺操作权限");
        }
        Long merchantId = identity == EnumUserType.MERCHANT.getIndex() ? SecurityUtils.getDeptId() : null;
        ResultVo<List<ShopWaybillAccount>> result = waybillService.accountOptions(
                shopId, shopType, shipperType, shipperId, merchantId);
        if (result.getCode() == 0) {
            return AjaxResult.success(result.getData());
        }
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 分配 / 改派（选中面单账号 = 发货主体 + 快递 + 网点；已取号须先取消取号）
     */
    @PostMapping("/distribute")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:waybill:distribute')")
    public AjaxResult distribute(@RequestBody ShipWorkbenchDistributeBo bo) {
        Integer identity = identity();
        if (!canDispatch(identity)) {
            return AjaxResult.error("仅总部与商户端可分配面单账号");
        }
        log.info("======打单发货分配/改派======{}", bo);
        ResultVo<ShipWorkbenchActionResultVo> result = waybillService.distribute(
                bo, resolveMerchantIds(identity), getUsername());
        if (result.getCode() == 0) {
            return AjaxResult.success(result.getData());
        }
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 整单退回异常池（必选退回原因；已取号未打印先自动取消取号，取消失败阻止退回）
     */
    @PostMapping("/return")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:waybill:return')")
    public AjaxResult returnToException(@RequestBody ShipWorkbenchReturnBo bo) {
        Integer identity = identity();
        if (!canDispatch(identity)) {
            return AjaxResult.error("仅总部与商户端可退回订单");
        }
        log.info("======打单发货整单退回======{}", bo);
        ResultVo<ShipWorkbenchActionResultVo> result = waybillService.returnToException(
                bo, resolveMerchantIds(identity), getUsername());
        if (result.getCode() == 0) {
            return AjaxResult.success(result.getData());
        }
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 取号：按订单已分配的面单账号调平台适配器取运单号（总部 / 商户 / 店铺均可发起）
     */
    @PostMapping("/take")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:waybill:take')")
    public AjaxResult take(@RequestBody ShipWorkbenchTakeBo bo) {
        Integer identity = identity();
        if (!canViewQueue(identity)) {
            return AjaxResult.error("仅总部、商户、店铺端可发起取号");
        }
        log.info("======打单发货取号======身份={}，{}", identity, bo);
        ResultVo<ShipWorkbenchActionResultVo> result = waybillService.take(
                bo, resolveMerchantIds(identity), resolveShopId(identity), getUsername());
        if (result.getCode() == 0) {
            return AjaxResult.success(result.getData());
        }
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 取消取号：已取号未打印 → 平台取消成功后本地回未取号（原面单账号保留供重取沿用）
     */
    @PostMapping("/cancel")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:waybill:cancel')")
    public AjaxResult cancel(@RequestBody ShipWorkbenchCancelBo bo) {
        Integer identity = identity();
        if (!canViewQueue(identity)) {
            return AjaxResult.error("仅总部、商户、店铺端可取消取号");
        }
        log.info("======打单发货取消取号======身份={}，{}", identity, bo);
        ResultVo<ShipWorkbenchActionResultVo> result = waybillService.cancel(
                bo, resolveMerchantIds(identity), resolveShopId(identity), getUsername());
        if (result.getCode() == 0) {
            return AjaxResult.success(result.getData());
        }
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 平台面单动作能力（前端按能力开放取号 / 取消 / 打印 / 发货按钮，§4.4 能力矩阵）
     */
    @GetMapping("/capabilities")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:waybill:list')")
    public AjaxResult capabilities(@RequestParam Integer shopType) {
        Integer identity = identity();
        if (!canViewQueue(identity)) {
            return AjaxResult.error("仅总部、商户、店铺端可查看打单发货队列");
        }
        ResultVo<PlatformWaybillCapability> result = waybillService.capabilities(shopType);
        if (result.getCode() == 0) {
            return AjaxResult.success(result.getData());
        }
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 打印：已取号 → 已打印（打印数据取号时已落库，物理打印由前端打印组件负责，本接口仅推进状态）
     */
    @PostMapping("/print")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:waybill:print')")
    public AjaxResult print(@RequestBody ShipWorkbenchPrintBo bo) {
        Integer identity = identity();
        if (!canViewQueue(identity)) {
            return AjaxResult.error("仅总部、商户、店铺端可发起打印");
        }
        log.info("======打单发货打印======身份={}，{}", identity, bo);
        ResultVo<ShipWorkbenchActionResultVo> result = waybillService.print(
                bo, resolveMerchantIds(identity), resolveShopId(identity), getUsername());
        if (result.getCode() == 0) {
            return AjaxResult.success(result.getData());
        }
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 发货（平台面单链路）：已打印 → 已发货，平台回传 + 本地仓落备货单
     */
    @PostMapping("/ship")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:waybill:ship')")
    public AjaxResult ship(@RequestBody ShipWorkbenchShipBo bo) {
        Integer identity = identity();
        if (!canViewQueue(identity)) {
            return AjaxResult.error("仅总部、商户、店铺端可发起发货");
        }
        log.info("======打单发货发货======身份={}，{}", identity, bo);
        ResultVo<ShipWorkbenchActionResultVo> result = waybillService.ship(
                bo, resolveMerchantIds(identity), resolveShopId(identity), getUsername());
        if (result.getCode() == 0) {
            return AjaxResult.success(result.getData());
        }
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 手动发货（兜底通道）：人工录入物流公司与单号，不依赖平台适配器；本地仓落备货单
     */
    @PostMapping("/manualShip")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:waybill:manualShip')")
    public AjaxResult manualShip(@RequestBody ShipWorkbenchManualShipBo bo) {
        Integer identity = identity();
        if (!canViewQueue(identity)) {
            return AjaxResult.error("仅总部、商户、店铺端可发起手动发货");
        }
        log.info("======打单发货手动发货======身份={}，{}", identity, bo);
        ResultVo<ShipWorkbenchActionResultVo> result = waybillService.manualShip(
                bo, resolveMerchantIds(identity), resolveShopId(identity), getUsername());
        if (result.getCode() == 0) {
            return AjaxResult.success(result.getData());
        }
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 状态漂移自检：比对 waybill_status 与打单记录一致性（数据域=总部不限 / 商户本商户；店铺端拒绝）
     */
    @GetMapping("/drift")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:waybill:list')")
    public AjaxResult drift() {
        Integer identity = identity();
        if (identity == null || identity != EnumUserType.SUPPER.getIndex()
                && identity != EnumUserType.MERCHANT.getIndex()) {
            return AjaxResult.error("仅总部、商户端可执行状态漂移自检");
        }
        return AjaxResult.success(waybillService.detectDrift(resolveMerchantIds(identity)));
    }

    /**
     * 状态漂移修复：逐单重新检测确认后按类型修复（数据域同 /drift）
     */
    @PostMapping("/fixDrift")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:waybill:list')")
    public AjaxResult fixDrift(@RequestBody ShipWorkbenchDriftFixBo bo) {
        Integer identity = identity();
        if (identity == null || identity != EnumUserType.SUPPER.getIndex()
                && identity != EnumUserType.MERCHANT.getIndex()) {
            return AjaxResult.error("仅总部、商户端可执行状态漂移修复");
        }
        log.info("======状态漂移修复======身份={}，{}", identity, bo);
        ResultVo<ShipWorkbenchDriftFixResultVo> result = waybillService.fixDrift(
                bo == null ? null : bo.getOrderIds(), getUsername(), resolveMerchantIds(identity));
        if (result.getCode() == 0) {
            return AjaxResult.success(result.getData());
        }
        return AjaxResult.error(result.getMsg());
    }
}
