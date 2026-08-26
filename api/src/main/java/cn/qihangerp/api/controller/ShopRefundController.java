package cn.qihangerp.api.controller;

import cn.qihangerp.common.AjaxResult;
import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.common.TableDataInfo;
import cn.qihangerp.model.entity.ShopRefund;
import cn.qihangerp.model.request.RefundPullRequest;
import cn.qihangerp.security.common.BaseController;
import cn.qihangerp.service.ShopRefundService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@AllArgsConstructor
@RestController
@RequestMapping("/api/oms-api/shop/refund")
public class ShopRefundController extends BaseController {

    private final ShopRefundService shopRefundService;

    @GetMapping("/list")
    public TableDataInfo list(ShopRefund bo, PageQuery pageQuery) {
        PageResult<ShopRefund> pageList = shopRefundService.queryPageList(bo, pageQuery);
        return getDataTable(pageList);
    }

    @PostMapping("/pull_list")
    public AjaxResult pullList(@RequestBody RefundPullRequest req) {

        return AjaxResult.error("");
    }

    @PostMapping("/pull_detail")
    public AjaxResult pullDetail(@RequestBody RefundPullRequest req) {
        return AjaxResult.error("");
    }

    @PostMapping("/push_oms")
    public AjaxResult pushOms(@RequestBody Map<String, Object> body) {
        return AjaxResult.error("");
    }
}
