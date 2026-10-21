package cn.qihangerp.service;

import cn.qihangerp.model.entity.ShopWaybillAccount;

import java.util.Collection;
import java.util.List;

/**
 * 店铺电子面单账号查询服务（oms_shop_waybill_account）
 * 参照 qihang-erp-pro ShopWaybillAccountService 的 listByShipper 口径：
 * 审单工作台批量放行 allocateUnit 与「分店铺账号选项」数据源
 *
 * @author qihang
 * @date 2026-10-21
 */
public interface ShopWaybillAccountService {

    /**
     * 按发货主体过滤的账号清单（merchantId/shopId/shopType/shipperType/shipperId 均可选，非空才拼接条件）
     * <p>
     * 工作台唯一数据源方法：放行弹窗账号选项（Controller 端点 /waybillAccountOptions，
     * 按登录身份收敛 merchantId 后调用，语义与 erp-pro /ewaybill/account_options 完全一致）
     * 与 allocateUnit 校验共用同一口径，不再另设 accountOptions 冗余方法。
     */
    List<ShopWaybillAccount> listByShipper(Long merchantId, Long shopId, Integer shopType,
                                           Integer shipperType, Long shipperId);

    /**
     * 按账号ID集合批量回查（打单发货队列行组装 loadAccounts / 分配与取号账号校验的数据源，
     * 对应 erp-pro ship-api 经 ec-api Feign accountListByIds 的本地化替代；空集合返回空列表）
     */
    List<ShopWaybillAccount> listByIds(Collection<Long> ids);
}
