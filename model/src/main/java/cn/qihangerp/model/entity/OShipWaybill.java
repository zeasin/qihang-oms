package cn.qihangerp.model.entity;

import java.io.Serializable;
import java.util.Date;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 发货电子面单记录表（打单记录）
 * @TableName o_order_ship_waybill
 * 定位=打印数据载体（docs/design/16-打单发货.md §1.3）：print_data/sign/params/template_url/goods_detail
 * 随取号落库；状态权威一律以 o_order.waybill_status 为准，本表 status 仅过程记录（1已取号2已打印3已发货）。
 * 关联列口径：order_id 存平台订单号、ship_order_id 存发货单元 id（o_order.id）。
 * <p>
 * 注意：实体类名历史遗留为 OShipWaybill（无 @TableName 时 MyBatis-Plus 默认映射 o_ship_waybill，
 * 与库中实际表名不符），本批显式声明 @TableName 修正；此前无业务代码使用该实体，不影响存量链路。
 */
@TableName("o_order_ship_waybill")
@Data
public class OShipWaybill implements Serializable {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 订单号（平台订单号 o_order.order_num）
     */
    private String orderId;

    /**
     * 发货单元ID（o_order.id；历史数据存在 o_order_stocking.id 混用，按现值只读兼容）
     */
    private Long shipOrderId;

    /**
     * 店铺id
     */
    private Long shopId;

    /**
     * 店铺类型
     */
    private Integer shopType;

    /**
     * 电子面单订单id(仅视频号)
     */
    private String waybillOrderId;

    /**
     * 快递单号
     */
    private String waybillCode;

    /**
     * 快递公司编码
     */
    private String logisticsCode;

    /**
     * 打印数据
     */
    private String printData;

    /**
     * 打印加密数据（抖音）
     */
    private String sign;

    /**
     * 打印参数（抖音）
     */
    private String params;

    /**
     * 打印模版url
     */
    private String templateUrl;

    /**
     * 打印的商品明细（快照）
     */
    private String goodsDetail;

    /**
     * 商户ID
     */
    private Long merchantId;

    /**
     * 状态（1已取号2已打印3已发货，EnumWaybillStatus 子集，本表不使用0）
     */
    private Integer status;

    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * 创建人
     */
    private String createBy;

    /**
     * 更新时间
     */
    private Date updateTime;

    /**
     * 更新人
     */
    private String updateBy;

    private static final long serialVersionUID = 1L;
}