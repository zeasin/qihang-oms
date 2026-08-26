package cn.qihangerp.api.controller;

import cn.qihangerp.common.AjaxResult;
import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.common.TableDataInfo;
import cn.qihangerp.model.bo.RefundProcessingBo;
import cn.qihangerp.model.bo.RefundSearchBo;
import cn.qihangerp.security.common.BaseController;
import cn.qihangerp.service.ORefundService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

@AllArgsConstructor
@RestController
@RequestMapping("/api/erp-api/refund")
public class RefundController extends BaseController {

    private final ORefundService refundService;

    @GetMapping("/list")
    public TableDataInfo list(RefundSearchBo bo, PageQuery pageQuery) {
        var pageList = refundService.queryPageList(bo, pageQuery);
        return getDataTable(pageList);
    }

    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(refundService.selectById(id));
    }

    @PostMapping("/pushErp/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return success();
    }

    @PostMapping("/processing")
    public AjaxResult refundProcessing(@RequestBody RefundProcessingBo bo) {
        if (bo.getRefundId() == null) return AjaxResult.error(500, "缺少参数refundId");
        ResultVo<Long> resultVo = refundService.refundProcessing(bo, getUsername());
        if (resultVo.getCode() == 0) return success();
        else return AjaxResult.error(resultVo.getMsg());
    }
}
