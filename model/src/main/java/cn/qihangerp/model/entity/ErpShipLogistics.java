package cn.qihangerp.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 发货常用快递公司表
 * @TableName erp_ship_logistics
 */
@Data
@TableName("erp_ship_logistics")
public class ErpShipLogistics implements Serializable {
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 实体类型
     */
    private String entityType;

    /**
     * 实体ID
     */
    private Long entityId;

    /**
     * 快递公司ID
     */
    private Long logisticsId;

    /**
     * 平台类型
     */
    private Integer shopType;

    /**
     * 是否默认：0-否，1-是
     */
    private Integer isDefault;

    /**
     * 排序号
     */
    private Integer sort;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;

    @TableField(exist = false)
    private String logisticsName;

    @TableField(exist = false)
    private String logisticsCode;

    @TableField(exist = false)
    private Integer platformId;
}
