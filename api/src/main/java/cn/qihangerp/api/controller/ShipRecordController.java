package cn.qihangerp.api.controller;

import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.TableDataInfo;
import cn.qihangerp.model.bo.SupplierShipOrderSearchRequest;
import cn.qihangerp.security.common.BaseController;
import cn.qihangerp.service.OOrderStockingService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 统一发货记录查询Controller
 * 根据 type 区分发货人类型：0=本地仓, 300=供应商
 */
@AllArgsConstructor
@RestController
@RequestMapping("/api/erp-api/ship/record")
public class ShipRecordController extends BaseController {

    private final OOrderStockingService stockingService;

    /**
     * 统一发货记录查询（供应商发货：type=300）
     */
    @GetMapping("/record_list")
    public TableDataInfo recordList(SupplierShipOrderSearchRequest bo, PageQuery pageQuery) {
        var pageList = stockingService.querySupplierShipPageList(bo, pageQuery);
        return getDataTable(pageList);
    }

}
