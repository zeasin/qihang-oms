package cn.qihangerp.service.waybill;

import cn.qihangerp.model.bo.WaybillCancelBo;
import cn.qihangerp.model.bo.WaybillShipBo;
import cn.qihangerp.model.bo.WaybillTakeBo;
import cn.qihangerp.model.vo.WaybillShipResultVo;
import cn.qihangerp.model.vo.WaybillTakeResultVo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * 电子面单默认兜底桩（开源版）
 * 参照 qihang-erp-pro 平台适配契约（docs/design/16-打单发货.md §4.4）：开源版未内置任何平台面单协议实现，
 * 能力矩阵全 false，任何动作调用一律抛 IllegalStateException，与各平台旧 ewaybill Controller
 * 统一返回「开源版本不支持电子面单功能」的口径一致。
 *
 * <p>扩展点：实现 {@link PlatformWaybillAdapter} 并注册为 Spring Bean（shopType() 返回
 * EnumShopType.getIndex() 对应平台值），{@link PlatformWaybillAdapterRegistry} 自动收集路由，
 * 打单发货队列即对该平台生效，无需改动本桩与队列代码。</p>
 *
 * @author qihang
 * @date 2026-10-22
 */
@Slf4j
@Component
public class DefaultUnsupportedWaybillAdapter implements PlatformWaybillAdapter {

    /** 开源版统一不支持提示（与旧平台 ewaybill Controller 返回口径一致） */
    public static final String UNSUPPORTED_MESSAGE = "开源版本不支持电子面单功能，请接入平台适配器实现";

    /** 兜底桩不参与按平台路由，shopType 置空由注册表识别 */
    @Override
    public Integer shopType() {
        return null;
    }

    @Override
    public PlatformWaybillCapability capability() {
        return PlatformWaybillCapability.of(null, false, false, false, false, false, UNSUPPORTED_MESSAGE);
    }

    @Override
    public WaybillTakeResultVo take(WaybillTakeBo bo) {
        throw new IllegalStateException(UNSUPPORTED_MESSAGE);
    }

    @Override
    public void cancel(WaybillCancelBo bo) {
        throw new IllegalStateException(UNSUPPORTED_MESSAGE);
    }

    @Override
    public WaybillShipResultVo ship(WaybillShipBo bo) {
        throw new IllegalStateException(UNSUPPORTED_MESSAGE);
    }
}
