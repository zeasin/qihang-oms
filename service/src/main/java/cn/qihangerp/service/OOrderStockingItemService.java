package cn.qihangerp.service;

import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.model.entity.OOrderStockingItem;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
 * 针对表【o_supplier_ship_order_item】的数据库操作Service
 */
public interface OOrderStockingItemService extends IService<OOrderStockingItem> {

    /**
     * 根据shipOrderId查询明细列表
     */
    List<OOrderStockingItem> listByShipOrderId(Long shipOrderId);

}
