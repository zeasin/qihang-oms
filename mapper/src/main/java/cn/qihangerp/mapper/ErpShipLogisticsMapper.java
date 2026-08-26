package cn.qihangerp.mapper;

import cn.qihangerp.model.entity.ErpShipLogistics;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 发货常用快递公司表 Mapper 接口
 */
public interface ErpShipLogisticsMapper extends BaseMapper<ErpShipLogistics> {

    List<ErpShipLogistics> selectByEntity();

    int cancelDefault(@Param("entityType") String entityType, @Param("entityId") Long entityId);

    int checkExists(@Param("entityType") String entityType, @Param("entityId") Long entityId, @Param("logisticsId") Long logisticsId, @Param("shopType") Integer shopType);

    ErpShipLogistics selectDefault(@Param("entityType") String entityType, @Param("entityId") Long entityId);
}
