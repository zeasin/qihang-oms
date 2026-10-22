package cn.qihangerp.api.controller.workbench;

import cn.qihangerp.common.AjaxResult;
import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.common.TableDataInfo;
import cn.qihangerp.enums.EnumUserType;
import cn.qihangerp.model.bo.OrderAddressBo;
import cn.qihangerp.model.bo.OrderCancelBo;
import cn.qihangerp.model.bo.OrderExceptionBo;
import cn.qihangerp.model.bo.OrderMemoBo;
import cn.qihangerp.model.bo.OrderReleaseBo;
import cn.qihangerp.model.bo.OrderWithdrawBo;
import cn.qihangerp.model.entity.ShopWaybillAccount;
import cn.qihangerp.model.request.OrderWorkbenchQuery;
import cn.qihangerp.model.vo.OrderReleaseResultVo;
import cn.qihangerp.security.common.BaseController;
import cn.qihangerp.security.common.SecurityUtils;
import cn.qihangerp.service.OrderWorkbenchOrderService;
import cn.qihangerp.service.ShopWaybillAccountService;
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

/**
 * 订单处理工作台-订单域（四池查询/池计数/批量转异常转正常/异常分类计数/批量放行/撤回/取消/备注/地址）
 * 参照 qihang-erp-pro WorkbenchOrderController（docs/design/15-订单处理工作台.md §2.2/§2.6/§2.7/§2.8）
 * 工作台仅总部与商户端可用
 * <p>
 * OMS 为单体工程：路由带 /api/erp-api 前缀（与 OMS 既有 Controller 命名一致），
 * 末段与 erp-pro 完全对齐（/orderWorkbench/order），前端可无差别移植。
 *
 * @author qihang
 * @date 2026-10-21
 */
@Slf4j
@AllArgsConstructor
@RestController
@RequestMapping("/api/erp-api/orderWorkbench/order")
public class WorkbenchOrderController extends BaseController {

    private final OrderWorkbenchOrderService orderService;
    private final ShopWaybillAccountService shopWaybillAccountService;

    /**
     * 数据范围：null=总部（全部），非空=本商户ID；工作台外身份返回 -1 表示拒绝
     */
    private Long resolveMerchantId() {
        Integer identity = SecurityUtils.getLoginUser().getUserIdentity();
        if (identity == null) return -1L;
        if (identity == EnumUserType.SUPPER.getIndex()) return null;
        if (identity == EnumUserType.MERCHANT.getIndex()) return SecurityUtils.getDeptId();
        return -1L;
    }

    /**
     * 状态池分页查询（主订单行 + 内嵌子订单行/合并子订单行，含 canRelease）
     */
    @GetMapping("/page")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:order:list')")
    public TableDataInfo page(OrderWorkbenchQuery query, PageQuery pageQuery) {
        log.info("======工作台状态池page======pool={}，query={}", query.getPool(), query);
        Long merchantId = resolveMerchantId();
        if (merchantId != null && merchantId == -1L) {
            return rejectTable();
        }
        if (merchantId != null) {
            // 商户端强制锁定本商户；总部端(null)不覆盖前端传入的商户筛选
            query.setMerchantId(merchantId);
        }
        return getDataTable(orderService.poolPage(query, pageQuery));
    }

    /**
     * 状态池计数（页签角标）
     */
    @GetMapping("/poolCounts")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:order:list')")
    public AjaxResult poolCounts(OrderWorkbenchQuery query) {
        Long merchantId = resolveMerchantId();
        if (merchantId != null && merchantId == -1L) {
            return AjaxResult.error("仅总部与商户端可操作");
        }
        if (merchantId != null) {
            // 商户端强制锁定本商户；总部端(null)不覆盖前端传入的商户筛选
            query.setMerchantId(merchantId);
        }
        return AjaxResult.success(orderService.poolCounts(query));
    }

    /**
     * 批量转异常/转正常（audit_status 0↔2 流转）
     */
    @PostMapping("/exception")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:order:list')")
    public AjaxResult exception(@RequestBody OrderExceptionBo bo) {
        log.info("======工作台转异常/转正常======{}", bo);
        Long merchantId = resolveMerchantId();
        if (merchantId != null && merchantId == -1L) {
            return AjaxResult.error("仅总部与商户端可操作");
        }
        List<Long> merchantIds = merchantId == null ? null : List.of(merchantId);
        ResultVo<String> result = orderService.toException(bo, merchantIds, getUsername());
        if (result.getCode() == 0) return AjaxResult.success(result.getData());
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 异常池分类计数（bind_pool=2 标签聚合 + 未分类兜底；分类导航节点数据源）
     */
    @GetMapping("/exceptionTagCounts")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:order:list')")
    public AjaxResult exceptionTagCounts(OrderWorkbenchQuery query) {
        Long merchantId = resolveMerchantId();
        if (merchantId != null && merchantId == -1L) {
            return AjaxResult.error("仅总部与商户端可操作");
        }
        if (merchantId != null) {
            // 商户端强制锁定本商户；总部端(null)不覆盖前端传入的商户筛选
            query.setMerchantId(merchantId);
        }
        return AjaxResult.success(orderService.exceptionTagCounts(query));
    }

    /**
     * 批量审核放行（部分失败留池并返回逐单原因）
     */
    @PostMapping("/release")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:order:list')")
    public AjaxResult release(@RequestBody OrderReleaseBo bo) {
        log.info("======工作台批量放行======{}", bo);
        Long merchantId = resolveMerchantId();
        if (merchantId != null && merchantId == -1L) {
            return AjaxResult.error("仅总部与商户端可操作");
        }
        List<Long> merchantIds = merchantId == null ? null : List.of(merchantId);
        ResultVo<OrderReleaseResultVo> result = orderService.release(bo, merchantIds, getUsername());
        if (result.getCode() == 0) return AjaxResult.success(result.getData());
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 已放行订单撤回异常池（audit_status 1→2 逐单退回并返回逐单原因；必带异常分类标签；已取号需先在打单发货页取消取号）
     */
    @PostMapping("/withdrawException")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:order:list')")
    public AjaxResult withdrawException(@RequestBody OrderWithdrawBo bo) {
        log.info("======工作台撤回异常======{}", bo);
        Long merchantId = resolveMerchantId();
        if (merchantId != null && merchantId == -1L) {
            return AjaxResult.error("仅总部与商户端可操作");
        }
        List<Long> merchantIds = merchantId == null ? null : List.of(merchantId);
        ResultVo<OrderReleaseResultVo> result = orderService.withdrawToException(bo, merchantIds, getUsername());
        if (result.getCode() == 0) return AjaxResult.success(result.getData());
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 取消订单（主订单级单张，未发货前置，子单联动作废）
     */
    @PostMapping("/cancel")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:order:list')")
    public AjaxResult cancel(@RequestBody OrderCancelBo bo) {
        log.info("======工作台取消订单======{}", bo);
        Long merchantId = resolveMerchantId();
        if (merchantId != null && merchantId == -1L) {
            return AjaxResult.error("仅总部与商户端可操作");
        }
        List<Long> merchantIds = merchantId == null ? null : List.of(merchantId);
        ResultVo<Void> result = orderService.cancelOrder(bo, merchantIds, getUsername());
        if (result.getCode() == 0) return AjaxResult.success();
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 修改卖家备注（未发货前可改）
     */
    @PostMapping("/memo")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:order:list')")
    public AjaxResult memo(@RequestBody OrderMemoBo bo) {
        log.info("======工作台修改卖家备注======{}", bo);
        Long merchantId = resolveMerchantId();
        if (merchantId != null && merchantId == -1L) {
            return AjaxResult.error("仅总部与商户端可操作");
        }
        List<Long> merchantIds = merchantId == null ? null : List.of(merchantId);
        ResultVo<Void> result = orderService.updateMemo(bo, merchantIds, getUsername());
        if (result.getCode() == 0) return AjaxResult.success();
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 修改收货地址（未发货前可改，已取号需先取消取号，主单同步未取号子单）
     */
    @PostMapping("/address")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:order:list')")
    public AjaxResult address(@RequestBody OrderAddressBo bo) {
        log.info("======工作台修改收货地址======{}", bo);
        Long merchantId = resolveMerchantId();
        if (merchantId != null && merchantId == -1L) {
            return AjaxResult.error("仅总部与商户端可操作");
        }
        List<Long> merchantIds = merchantId == null ? null : List.of(merchantId);
        ResultVo<Void> result = orderService.updateAddress(bo, merchantIds, getUsername());
        if (result.getCode() == 0) return AjaxResult.success();
        return AjaxResult.error(result.getMsg());
    }

    /**
     * 分店铺电子面单账号选项（放行弹窗数据源）
     * 口径对齐 erp-pro ec-api /ewaybill/account_options：
     * 总部不限商户；商户仅本商户（merchant_id=deptId）；店铺身份需为该店铺且仅看本店账号；其余身份拒绝
     */
    @GetMapping("/waybillAccountOptions")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:order:list')")
    public AjaxResult waybillAccountOptions(@RequestParam Long shopId, @RequestParam Integer shopType,
                                            @RequestParam(required = false) Integer shipperType,
                                            @RequestParam(required = false) Long shipperId) {
        if (shopId == null || shopType == null) {
            return AjaxResult.error("缺少参数：shopId/shopType");
        }
        Integer identity = SecurityUtils.getLoginUser().getUserIdentity();
        if (identity == null) return AjaxResult.error("登录状态异常");
        Long merchantId = null;
        if (identity == EnumUserType.SUPPER.getIndex()) {
            // 总部：不限商户、不限发货主体（按入参可选过滤）
        } else if (identity == EnumUserType.MERCHANT.getIndex()) {
            merchantId = SecurityUtils.getDeptId();
        } else if (identity == EnumUserType.STORE.getIndex()) {
            if (!shopId.equals(SecurityUtils.getDeptId())) {
                return AjaxResult.error("无该店铺操作权限");
            }
        } else {
            return AjaxResult.error("仅总部与商户端可操作");
        }
        List<ShopWaybillAccount> list = shopWaybillAccountService.listByShipper(
                merchantId, shopId, shopType, shipperType, shipperId);
        return AjaxResult.success(list);
    }

    /**
     * 越权拒绝的分页壳（保持前端 TableDataInfo 结构可解析）
     */
    private TableDataInfo rejectTable() {
        TableDataInfo table = new TableDataInfo();
        table.setCode(500);
        table.setMsg("仅总部与商户端可操作");
        return table;
    }
}
