package cn.qihangerp.service;

import cn.qihangerp.common.ResultVo;
import cn.qihangerp.model.entity.ErpShipLogistics;

import java.util.List;

/**
 * 发货常用快递公司表 Service 接口
 */
public interface ErpShipLogisticsService {

    List<ErpShipLogistics> queryListByEntity();

    ResultVo<Integer> add(ErpShipLogistics entity);

    ResultVo<Integer> delete(Long id);

    ResultVo<Integer> setDefault(Long id);

    ErpShipLogistics getDefault(String entityType, Long entityId);
}
