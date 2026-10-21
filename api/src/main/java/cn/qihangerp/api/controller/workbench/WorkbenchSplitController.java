package cn.qihangerp.api.controller.workbench;

import cn.qihangerp.common.AjaxResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.enums.EnumUserType;
import cn.qihangerp.model.bo.SplitSubmitBo;
import cn.qihangerp.security.common.BaseController;
import cn.qihangerp.security.common.SecurityUtils;
import cn.qihangerp.service.OrderWorkbenchSplitService;
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
 * 订单处理工作台-拆单（拆单预览 / 提交拆单 / 重新拆分）
 * 参照 qihang-erp-pro WorkbenchSplitController（docs/design/15-订单处理工作台.md §2.5）
 * 一单一单真实拆单，事务内行锁 + 全量分配强校验；仅总部与商户端可用
 * <p>
 * OMS 单体工程：路由带 /api/erp-api 前缀，末段与 erp-pro 对齐（/orderWorkbench/split）
 *
 * @author qihang
 * @date 2026-10-21
 */
@Slf4j
@AllArgsConstructor
@RestController
@RequestMapping("/api/erp-api/orderWorkbench/split")
public class WorkbenchSplitController extends BaseController {

    private final OrderWorkbenchSplitService splitService;

    /**
     * 数据范围：null=总部（全部）；商户=本商户ID；其余身份返回 [-1] 表示拒绝（Service 内查不到订单）
     */
    private List<Long> resolveMerchantIds() {
        Integer identity = SecurityUtils.getLoginUser().getUserIdentity();
        if (identity == null) return List.of(-1L);
        if (identity == EnumUserType.SUPPER.getIndex()) return null;
        if (identity == EnumUserType.MERCHANT.getIndex()) return List.of(SecurityUtils.getDeptId());
        return List.of(-1L);
    }

    /**
     * 拆单预览：被拆订单原始明细（含剩余可拆数量）+ 当前有效子订单（重新拆分恢复用）
     */
    @GetMapping("/preview")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:order:list')")
    public AjaxResult preview(@RequestParam Long orderId) {
        log.info("======工作台拆单预览======orderId={}", orderId);
        try {
            return AjaxResult.success(splitService.preview(orderId, resolveMerchantIds()));
        } catch (Exception e) {
            return AjaxResult.error(e.getMessage());
        }
    }

    /**
     * 提交拆单（多批次统一拆分，累计拆出不超可发货数量，事务内生成子订单）
     */
    @PostMapping("/submit")
    @PreAuthorize("@ss.hasPermi('orderWorkbench:order:list')")
    public AjaxResult submit(@RequestBody SplitSubmitBo bo) {
        log.info("======工作台提交拆单======orderId={}", bo.getOrderId());
        try {
            ResultVo<String> result = splitService.submit(bo, resolveMerchantIds(), getUsername());
            if (result.getCode() == 0) return AjaxResult.success(result.getData());
            return AjaxResult.error(result.getMsg());
        } catch (Exception e) {
            log.error("======工作台提交拆单失败======orderId={}，error={}", bo.getOrderId(), e.getMessage(), e);
            return AjaxResult.error(e.getMessage());
        }
    }
}
