package cn.qihangerp.service.waybill;

import cn.qihangerp.model.bo.WaybillCancelBo;
import cn.qihangerp.model.bo.WaybillShipBo;
import cn.qihangerp.model.bo.WaybillTakeBo;
import cn.qihangerp.model.vo.WaybillShipResultVo;
import cn.qihangerp.model.vo.WaybillTakeResultVo;

/**
 * 平台电子面单动作适配器契约
 * 参照 qihang-erp-pro PlatformWaybillAdapter（docs/design/16-打单发货.md §2.3 / §4.1 / §4.4）：
 * 打单发货统一队列的「取号 → 打印 → 发货 → 回传」全部经本契约收口调用平台能力，
 * 队列不感知平台协议，适配器不感知队列状态机。
 * 打印数据随取号返回（WaybillTakeResultVo.printData），print 能力仅描述平台是否支持打印动作。
 *
 * <p>扩展点：新平台实现本接口并注册为 Spring Bean（shopType() 返回 EnumShopType 对应值）即对队列生效，
 * 无需修改队列与注册表代码。开源版默认由 {@link DefaultUnsupportedWaybillAdapter} 兜底。</p>
 *
 * @author qihang
 * @date 2026-10-22
 */
public interface PlatformWaybillAdapter {

    /**
     * 适配的店铺类型（EnumShopType.getIndex()；默认兜底桩返回 null，不参与路由）
     */
    Integer shopType();

    /**
     * 平台动作能力矩阵（取号/取消/打印/发货）
     */
    PlatformWaybillCapability capability();

    /**
     * 取号（含获取打印数据）
     * 成功返回快递单号与打印数据；失败抛 IllegalStateException 并携带平台错误信息，由队列捕获落日志
     */
    WaybillTakeResultVo take(WaybillTakeBo bo);

    /**
     * 取消取号（仅未打印/未发货状态允许，成功后订单面单状态回 NOT_TAKEN）
     */
    void cancel(WaybillCancelBo bo);

    /**
     * 发货回传（平台确认发货，回写 platform_ship_status/platform_ship_result）
     */
    WaybillShipResultVo ship(WaybillShipBo bo);
}
