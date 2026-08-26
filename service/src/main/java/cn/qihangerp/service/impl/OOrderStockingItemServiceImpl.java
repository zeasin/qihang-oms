package cn.qihangerp.service.impl;

import cn.qihangerp.mapper.OOrderStockingItemMapper;
import cn.qihangerp.model.entity.OOrderStockingItem;
import cn.qihangerp.service.OOrderStockingItemService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 针对表【o_supplier_ship_order_item】的数据库操作Service实现
 */
@Slf4j
@AllArgsConstructor
@Service
public class OOrderStockingItemServiceImpl extends ServiceImpl<OOrderStockingItemMapper, OOrderStockingItem>
    implements OOrderStockingItemService {

    @Override
    public List<OOrderStockingItem> listByShipOrderId(Long shipOrderId) {
        return list(new LambdaQueryWrapper<OOrderStockingItem>().eq(OOrderStockingItem::getShipOrderId, shipOrderId));
    }

}
