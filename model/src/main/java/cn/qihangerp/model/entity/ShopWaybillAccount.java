package cn.qihangerp.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;

/**
 * 店铺电子面单账号（物流网点）表
 * @TableName oms_shop_waybill_account
 * 审单工作台批量放行依赖：账号绑定发货主体（shipper_type/shipper_id），
 * 选中账号即同时确定 发货主体+快递+网点（增量列见 docs/sql/20261021-order-audit/04）
 */
@TableName(value = "oms_shop_waybill_account")
@Data
public class ShopWaybillAccount implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 自增ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 商家物流网点信息的唯一key，商家物流新增/编辑时，只回传该字段即可指定网点
     */
    private String key1;

    /**
     * 类型：DIANSAN，PT
     */
    private String type;

    /**
     * 外部logistics_id（点三使用）
     */
    private String outerLogisticsId;

    /**
     * 编码
     */
    private String code;

    /**
     * 网点名称
     */
    private String name;

    /**
     * 面单平台类型：WB_TB菜鸟 / WB_JD_ALPHA京东无界 / WB_PDD拼多多 / WB_DY抖音 / WB_WX_VS视频号 等
     */
    private String waybillPlatformType;

    /**
     * 网点品牌编号，目前仅顺丰具有
     */
    private String brandCode;

    /**
     * 平台物流编码
     */
    private String refLogisticsCode;

    /**
     * 平台物流id
     */
    private Integer refLogisticsId;

    /**
     * 平台物流名称
     */
    private String refLogisticsName;

    /**
     * 平台物流类型：DIRECT-直营，JOIN-加盟，CONF-落地配，DIRECT_NETSITE-直营带网点
     */
    private String refLogisticsType;

    /**
     * 结算账户
     */
    private String settleAccount;

    /**
     * 源键
     */
    private String sourceKey;

    /**
     * 省份
     */
    private String province;

    /**
     * 城市
     */
    private String city;

    /**
     * 详细地址
     */
    private String detail;

    /**
     * 区县
     */
    private String district;

    /**
     * 电子面单余额数量
     */
    private Integer num;

    /**
     * 地址（详细）
     */
    private String addressAddress;

    /**
     * 城市 ID
     */
    private Integer cityId;

    /**
     * 城市名称
     */
    private String cityName;

    /**
     * 区id
     */
    private Integer countryId;

    /**
     * 区名称
     */
    private String countryName;

    /**
     * 乡镇 ID
     */
    private Integer countrysideId;

    /**
     * 乡镇名称
     */
    private String countrysideName;

    /**
     * 省份 ID
     */
    private Integer provinceId;

    /**
     * 省份名称
     */
    private String provinceName;

    /**
     * 金额
     */
    private Integer amount;

    /**
     * 分支编码
     */
    private String branchCode;

    /**
     * 分支名称
     */
    private String branchName;

    /**
     * 操作类型
     */
    private Integer operationType;

    /**
     * 提供者编码
     */
    private String providerCode;

    /**
     * 提供者ID
     */
    private Long providerId;

    /**
     * 提供者名称
     */
    private String providerName;

    /**
     * 提供者类型
     */
    private Integer providerType;

    /**
     * 是否支持货到付款
     */
    private Integer supportCod;

    /**
     * 镇
     */
    private String town;

    /**
     * 发货人
     */
    private String deliverName;

    /**
     * 发货手机号
     */
    private String deliverMobile;

    /**
     * 发货固定电话
     */
    private String deliverPhone;

    /**
     * 打印模版url
     */
    private String templateUrl;

    /**
     * 模板id
     */
    private String templateId;

    /**
     * 店铺id
     */
    private Long shopId;

    /**
     * 店铺类型
     */
    private Integer shopType;

    /**
     * 商户id（0=总部）
     */
    private Long merchantId;

    /**
     * 发货主体类型（对齐 EnumShipType）：0店铺自用（本地仓）100京东云仓 110吉客云云仓 200系统云仓 300供应商
     */
    private Integer shipperType;

    /**
     * 发货主体ID：0=店铺自用（本地仓）；供应商/云仓为对应 erp_supplier / erp_warehouse 主键
     */
    private Long shipperId;

    /**
     * 是否支持线下打单 0不支持 1支持
     */
    private Integer supportOffline;
}
