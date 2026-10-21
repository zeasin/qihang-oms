package cn.qihangerp.service.impl;

import cn.qihangerp.enums.EnumShipType;
import cn.qihangerp.mapper.ShopWaybillAccountMapper;
import cn.qihangerp.model.entity.ShopWaybillAccount;
import cn.qihangerp.service.ShopWaybillAccountService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * 店铺电子面单账号查询实现
 * <p>
 * 口径完全移植 qihang-erp-pro ec-api ShopWaybillAccountServiceImpl.listByShipper（只读参考工程）：
 * 所有条件均为「非空才拼接」的等值过滤；shipper_type/shipper_id 为 04 增量 SQL 补齐的「发货主体」列，
 * 放行 allocateUnit 依赖「选中账号即同时确定 发货主体+快递+网点」。
 * <p>
 * 差异说明（OMS 为单体工程，无 ec-api Feign 层）：
 * - erp-pro 该实现继承 ServiceImpl 并提供 CRUD；OMS 工作台仅需要查询能力，故只做只读查询，
 *   CRUD 仍由既有面单账号维护入口负责（本次不动，避免影响其他链路）。
 * - 工作台账号选项与 allocateUnit 校验共用 listByShipper 单一口径（不设 accountOptions 冗余方法）；
 *   erp-pro 无同名 Java 方法，仅有 /ewaybill/account_options HTTP 端点，OMS 对应端点为
 *   /orderWorkbench/order/waybillAccountOptions（在 Controller 按登录身份收敛 merchantId 后调用本方法）。
 * - 数据域（总部/商户/店铺）收敛在 Controller 层完成，Service 层保持与 erp-pro 一致的纯条件查询。
 *
 * @author qihang
 * @date 2026-10-21
 */
@Service
public class ShopWaybillAccountServiceImpl implements ShopWaybillAccountService {

    private final ShopWaybillAccountMapper shopWaybillAccountMapper;

    public ShopWaybillAccountServiceImpl(ShopWaybillAccountMapper shopWaybillAccountMapper) {
        this.shopWaybillAccountMapper = shopWaybillAccountMapper;
    }

    @Override
    public List<ShopWaybillAccount> listByShipper(Long merchantId, Long shopId, Integer shopType,
                                                  Integer shipperType, Long shipperId) {
        LambdaQueryWrapper<ShopWaybillAccount> queryWrapper = new LambdaQueryWrapper<ShopWaybillAccount>()
                .eq(merchantId != null, ShopWaybillAccount::getMerchantId, merchantId)
                .eq(shopId != null, ShopWaybillAccount::getShopId, shopId)
                .eq(shopType != null, ShopWaybillAccount::getShopType, shopType)
                .eq(shipperType != null, ShopWaybillAccount::getShipperType, shipperType)
                // 与 erp-pro 一致：本地发货（店铺自用）账号的 shipper_id 恒为 0，不按 shipperId 过滤
                .eq(shipperType != null && shipperType != EnumShipType.LOCAL.getIndex() && shipperId != null,
                        ShopWaybillAccount::getShipperId, shipperId)
                .orderByAsc(ShopWaybillAccount::getId);
        return shopWaybillAccountMapper.selectList(queryWrapper);
    }

    /**
     * 打单发货队列本地化数据源（替代 erp-pro ship-api → ec-api Feign accountListByIds）：
     * 行组装批量取账号名 + 分配/取号单账号回查共用；空集合直接返回空列表，不触发 IN() 全表风险
     */
    @Override
    public List<ShopWaybillAccount> listByIds(Collection<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return new ArrayList<>();
        }
        return shopWaybillAccountMapper.selectBatchIds(ids);
    }
}
