package cn.qihangerp.service.waybill;

import cn.qihangerp.enums.EnumShopType;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 平台面单适配器注册表（按店铺类型路由）
 * 参照 qihang-erp-pro PlatformWaybillAdapterRegistry（docs/design/16-打单发货.md §0.2 / §4.1）：
 * 「订单已指定面单账号 → 账号所属平台 → 平台适配器」，平台键取 {@link EnumShopType#getIndex()}，禁止魔法数字。
 * Spring 自动收集所有 {@link PlatformWaybillAdapter} Bean；未注册平台回落
 * {@link DefaultUnsupportedWaybillAdapter}（动作调用抛不支持异常），能力查询返回 unsupported。
 *
 * @author qihang
 * @date 2026-10-22
 */
@Slf4j
@Component
public class PlatformWaybillAdapterRegistry {

    private final Map<Integer, PlatformWaybillAdapter> adapterMap = new HashMap<>();
    private final DefaultUnsupportedWaybillAdapter defaultAdapter;

    public PlatformWaybillAdapterRegistry(List<PlatformWaybillAdapter> adapters,
                                          DefaultUnsupportedWaybillAdapter defaultAdapter) {
        this.defaultAdapter = defaultAdapter;
        if (adapters != null) {
            for (PlatformWaybillAdapter adapter : adapters) {
                if (adapter instanceof DefaultUnsupportedWaybillAdapter) {
                    continue;
                }
                Integer shopType = adapter.shopType();
                if (shopType == null) {
                    log.warn("面单适配器 {} 未声明 shopType（EnumShopType.getIndex()），已跳过注册",
                            adapter.getClass().getName());
                    continue;
                }
                PlatformWaybillAdapter exists = adapterMap.put(shopType, adapter);
                if (exists != null) {
                    log.warn("平台[{}={}]重复注册面单适配器，后者覆盖前者：{} -> {}",
                            shopType, EnumShopType.getName(shopType), exists.getClass().getName(),
                            adapter.getClass().getName());
                }
            }
        }
        log.info("电子面单适配器注册完成，已接入平台数={}（开源版默认为 0，全部回落默认桩）", adapterMap.size());
    }

    /**
     * 按店铺类型取适配器；未注册平台返回默认兜底桩（调用动作即抛「开源版本不支持」异常）
     */
    public PlatformWaybillAdapter get(Integer shopType) {
        if (shopType == null) {
            return defaultAdapter;
        }
        return adapterMap.getOrDefault(shopType, defaultAdapter);
    }

    /**
     * 是否已为该平台注册真实适配器（队列按钮兜底判断用）
     */
    public boolean isSupported(Integer shopType) {
        return shopType != null && adapterMap.containsKey(shopType);
    }

    /**
     * 平台动作能力矩阵；未注册平台返回 unsupported（能力全 false）
     */
    public PlatformWaybillCapability capability(Integer shopType) {
        PlatformWaybillAdapter adapter = shopType == null ? null : adapterMap.get(shopType);
        if (adapter == null) {
            return PlatformWaybillCapability.unsupported(shopType);
        }
        return adapter.capability();
    }
}
