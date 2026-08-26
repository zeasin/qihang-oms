package cn.qihangerp.service.impl;

import cn.qihangerp.common.DateHelper;
import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.enums.EnumShipType;
import cn.qihangerp.mapper.OOrderStockingMapper;
import cn.qihangerp.model.bo.ShipRecordQueryRequest;
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

    @Override
    public PageResult<OOrderStocking> queryShipRecordPageList(ShipRecordQueryRequest request, PageQuery pageQuery) {
        if(StringUtils.hasText(request.getStartTime())){
            boolean b = DateHelper.isValidDate(request.getStartTime());
            if(!b) request.setStartTime("");
        }
        if(StringUtils.hasText(request.getEndTime())){
            boolean b = DateHelper.isValidDate(request.getEndTime());
            if(!b) request.setEndTime("");
        }else if(StringUtils.hasText(request.getStartTime())){
            request.setEndTime(request.getStartTime());
        }

        Integer type = request.getType();
        LambdaQueryWrapper<OOrderStocking> queryWrapper = new LambdaQueryWrapper<OOrderStocking>();

        if(type != null){
            if(type == EnumShipType.SUPPLIER.getIndex()){
                queryWrapper.eq(OOrderStocking::getType, EnumShipType.SUPPLIER.getIndex())
                        .eq(request.getSupplierId()!=null, OOrderStocking::getShipperId, request.getSupplierId());
            } else if(type >= 100 && type <= 200){
                queryWrapper.eq(OOrderStocking::getType, type);
            } else if(type == EnumShipType.LOCAL.getIndex()){
                queryWrapper.eq(OOrderStocking::getType, EnumShipType.LOCAL.getIndex());
            } else {
                queryWrapper.eq(OOrderStocking::getId, -1L);
            }
        } else if(Boolean.TRUE.equals(request.getAllCloud())){
            queryWrapper.ge(OOrderStocking::getType, 100).le(OOrderStocking::getType, 200);
        }

        queryWrapper
                .eq(request.getMerchantId()!=null, OOrderStocking::getMerchantId, request.getMerchantId())
                .eq(request.getShopId()!=null, OOrderStocking::getShopId, request.getShopId())
                .eq(StringUtils.hasText(request.getOrderNum()), OOrderStocking::getOrderNum, request.getOrderNum())
                .eq(StringUtils.hasText(request.getWaybillCode()), OOrderStocking::getWaybillCode, request.getWaybillCode())
                .eq(request.getSendStatus()!=null, OOrderStocking::getSendStatus, request.getSendStatus())
                .eq(request.getWaybillStatus()!=null, OOrderStocking::getWaybillStatus, request.getWaybillStatus())
                .eq(request.getShopType()!=null, OOrderStocking::getShopType, request.getShopType())
                .eq(request.getOrderStatus()!=null, OOrderStocking::getOrderStatus, request.getOrderStatus())
                .eq(request.getErpPushStatus()!=null, OOrderStocking::getErpPushStatus, request.getErpPushStatus())
                .eq(StringUtils.hasText(request.getShippingErpOrderCode()), OOrderStocking::getShippingErpOrderCode, request.getShippingErpOrderCode())
                .eq(StringUtils.hasText(request.getShippingOrderCode()), OOrderStocking::getShippingOrderCode, request.getShippingOrderCode())
                .ge(StringUtils.hasText(request.getStartTime()) && type!=null && type==EnumShipType.SUPPLIER.getIndex(),
                        OOrderStocking::getOrderTime, request.getStartTime()+" 00:00:00")
                .le(StringUtils.hasText(request.getEndTime()) && type!=null && type==EnumShipType.SUPPLIER.getIndex(),
                        OOrderStocking::getOrderTime, request.getEndTime()+" 23:59:59")
                .ge(StringUtils.hasText(request.getStartTime()) && (type!=null && type>=100 || Boolean.TRUE.equals(request.getAllCloud())),
                        OOrderStocking::getCreateTime, request.getStartTime()+" 00:00:00")
                .le(StringUtils.hasText(request.getEndTime()) && (type!=null && type>=100 || Boolean.TRUE.equals(request.getAllCloud())),
                        OOrderStocking::getCreateTime, request.getEndTime()+" 23:59:59")
                .orderByDesc(OOrderStocking::getId);

        Page<OOrderStocking> pages = shipOrderMapper.selectPage(pageQuery.build(), queryWrapper);

        if(pages.getRecords()!=null){
            for (OOrderStocking order:pages.getRecords()) {
                order.setItemList(shipOrderItemService.list(new LambdaQueryWrapper<OOrderStockingItem>()
                        .eq(OOrderStockingItem::getShipOrderId, order.getId())));
            }
        }

        return PageResult.build(pages);
    }

}
