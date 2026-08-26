package cn.qihangerp.service;

import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.model.bo.SupplierShipOrderSearchRequest;
import cn.qihangerp.model.entity.OOrderStocking;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * 针对表【o_supplier_ship_order(供应商发货订单)】的数据库操作Service
 */
public interface OOrderStockingService extends IService<OOrderStocking> {

    /**
     * 已分配给供应商发货的订单list
     */
    PageResult<OOrderStocking> querySupplierShipPageList(SupplierShipOrderSearchRequest bo, PageQuery pageQuery);

}
