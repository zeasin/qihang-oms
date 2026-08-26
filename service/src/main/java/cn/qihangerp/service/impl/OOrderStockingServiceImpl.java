package cn.qihangerp.service.impl;

import cn.qihangerp.common.DateHelper;
import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.enums.EnumShipType;
import cn.qihangerp.mapper.OOrderStockingMapper;
import cn.qihangerp.model.bo.SupplierShipOrderSearchRequest;
import cn.qihangerp.model.entity.OOrderStocking;
import cn.qihangerp.model.entity.OOrderStockingItem;
import cn.qihangerp.service.OOrderStockingItemService;
import cn.qihangerp.service.OOrderStockingService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

/**
 * 针对表【o_supplier_ship_order(供应商发货订单)】的数据库操作Service实现
 */
@Slf4j
@AllArgsConstructor
@Service
public class OOrderStockingServiceImpl extends ServiceImpl<OOrderStockingMapper, OOrderStocking>
    implements OOrderStockingService {

    private final OOrderStockingMapper shipOrderMapper;
    private final OOrderStockingItemService shipOrderItemService;

    @Override
    public PageResult<OOrderStocking> querySupplierShipPageList(SupplierShipOrderSearchRequest bo, PageQuery pageQuery) {
        if(StringUtils.hasText(bo.getStartTime())){
            boolean b = DateHelper.isValidDate(bo.getStartTime());
            if(!b){
                bo.setStartTime("");
            }
        }
        if(StringUtils.hasText(bo.getEndTime())){
            boolean b = DateHelper.isValidDate(bo.getEndTime());
            if(!b){
                bo.setEndTime("");
            }
        }else {
            bo.setEndTime(bo.getStartTime());
        }

        LambdaQueryWrapper<OOrderStocking> queryWrapper = new LambdaQueryWrapper<OOrderStocking>()
                .eq(OOrderStocking::getType, EnumShipType.SUPPLIER.getIndex())
                .eq(bo.getSupplierId()!=null, OOrderStocking::getShipperId, bo.getSupplierId())
                .eq(bo.getWarehouseId()!=null, OOrderStocking::getWarehouseId, bo.getWarehouseId())
                .eq(bo.getMerchantId()!=null, OOrderStocking::getMerchantId, bo.getMerchantId())
                .eq(bo.getShopId()!=null, OOrderStocking::getShopId, bo.getShopId())
                .eq(StringUtils.hasText(bo.getOrderNum()), OOrderStocking::getOrderNum, bo.getOrderNum())
                .eq(bo.getSendStatus()!=null, OOrderStocking::getSendStatus, bo.getSendStatus())
                .eq(bo.getWaybillStatus()!=null, OOrderStocking::getWaybillStatus, bo.getWaybillStatus())
                .eq(bo.getShopType()!=null, OOrderStocking::getShopType, bo.getShopType())
                .ge(StringUtils.hasText(bo.getStartTime()), OOrderStocking::getOrderTime, bo.getStartTime()+" 00:00:00")
                .le(StringUtils.hasText(bo.getEndTime()), OOrderStocking::getOrderTime, bo.getEndTime()+" 23:59:59")
                .eq(bo.getOrderStatus()!=null, OOrderStocking::getOrderStatus, bo.getOrderStatus());

        Page<OOrderStocking> pages = shipOrderMapper.selectPage(pageQuery.build(), queryWrapper);

        // 查询子订单
        if(pages.getRecords()!=null){
            for (OOrderStocking order:pages.getRecords()) {
                order.setItemList(shipOrderItemService.list(new LambdaQueryWrapper<OOrderStockingItem>().eq(OOrderStockingItem::getShipOrderId, order.getId())));
            }
        }

        return PageResult.build(pages);
    }

}
