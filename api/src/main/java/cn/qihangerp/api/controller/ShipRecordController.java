package cn.qihangerp.api.controller;

import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.TableDataInfo;
import cn.qihangerp.model.bo.ShipRecordQueryRequest;
import cn.qihangerp.model.bo.SupplierShipOrderSearchRequest;
import cn.qihangerp.security.common.BaseController;
import cn.qihangerp.service.OOrderStockingService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 统一发货记录查询Controller
 */
@AllArgsConstructor
@RestController
@RequestMapping("/api/erp-api/ship/record")
public class ShipRecordController extends BaseController {

    private final OOrderStockingService stockingService;

    /**
     * 供应商发货列表（type=300）
     */
    @GetMapping("/record_list")
    public TableDataInfo recordList(SupplierShipOrderSearchRequest bo, PageQuery pageQuery) {
        var pageList = stockingService.querySupplierShipPageList(bo, pageQuery);
        return getDataTable(pageList);
    }

    /**
     * 统一发货记录查询（支持供应商+云仓）
     */
    @GetMapping("/ship_record_list")
    public TableDataInfo shipRecordList(ShipRecordQueryRequest request, PageQuery pageQuery) {
        var pageList = stockingService.queryShipRecordPageList(request, pageQuery);
        return getDataTable(pageList);
    }

}
