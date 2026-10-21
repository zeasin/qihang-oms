package cn.qihangerp.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * 订单处理工作台-用户自建标签字典（o_order_tag）
 * 标签用途自由：异常原因、分组标记、供应商标记、快递公司标记等；
 * 订单上的标签以 ID 列表反范式保存在 o_order.tag（逗号分隔），本表只承载标签主数据
 * 建表脚本：docs/sql/20261021-order-audit/03_o_order_tag.sql
 *
 * @author qihang
 * @date 2026-10-21
 */
@Data
@TableName("o_order_tag")
public class OOrderTag implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 标签名称（如：发供应商A/顺丰/断货跟进） */
    private String name;

    /** 标签颜色（预置10色色板色值，如#6366F1） */
    private String color;

    /** 商户ID（0=总部公共标签，商户端可见可用） */
    private Long merchantId;

    /** 排序号，越小越靠前 */
    private Integer sort;

    /**
     * 关联状态池（对齐 EnumAuditStatus：0=通用标签不挂池；2=异常池分类标签）；
     * 转异常时必选一个 bind_pool=2 的标签并覆盖写入订单 tag，异常池按分类实时计数；
     * 分类标签全系统共用，不走商户隔离
     */
    private Integer bindPool;

    /** 状态（EnumEnableStatus：0停用 1启用）；停用不再出现在打标选项，已打订单保留数据 */
    private Integer status;

    private Date createTime;
    private String createBy;
    private Date updateTime;
    private String updateBy;
}
