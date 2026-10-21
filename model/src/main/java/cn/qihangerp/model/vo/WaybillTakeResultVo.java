package cn.qihangerp.model.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 统一电子面单-取号结果 VO（平台返回，队列负责落库回写 o_order）
 * 字段对齐 qihang-erp-pro PlatformWaybillTakeResult（docs/design/16-打单发货.md §1.1 / §4.4）
 *
 * @author qihang
 * @date 2026-10-22
 */
@Data
public class WaybillTakeResultVo implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 快递单号（平台 trackNo，回写 o_order.waybill_code） */
    private String waybillCode;

    /** 平台快递公司编码（取消取号/发货回传时回传平台，回写 o_order.shipping_company_code） */
    private String logisticsCode;

    /** 快递公司名称（展示用，回写 o_order.waybill_company） */
    private String waybillCompany;

    /** 平台电子面单订单标识（视频号等平台使用，回写 o_order.waybill_order_id） */
    private String waybillOrderId;

    /** 打印数据（平台原生打印协议载荷） */
    private String printData;

    /** 平台打印签名 */
    private String sign;

    /** 平台打印参数 */
    private String params;

    /** 打印模板地址 */
    private String templateUrl;

    /** 商品明细快照 */
    private String goodsDetail;
}
