package cn.qihangerp.service.impl;

import cn.qihangerp.common.ResultVo;
import cn.qihangerp.mapper.ErpShipLogisticsMapper;
import cn.qihangerp.model.entity.ErpShipLogistics;
import cn.qihangerp.service.ErpShipLogisticsService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 发货常用快递公司表 Service 实现类
 */
@Slf4j
@AllArgsConstructor
@Service
public class ErpShipLogisticsServiceImpl extends ServiceImpl<ErpShipLogisticsMapper, ErpShipLogistics>
        implements ErpShipLogisticsService {

    private final ErpShipLogisticsMapper shipLogisticsMapper;

    @Override
    public List<ErpShipLogistics> queryListByEntity() {
        return shipLogisticsMapper.selectByEntity();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ResultVo<Integer> add(ErpShipLogistics entity) {
        int count = shipLogisticsMapper.checkExists(entity.getEntityType(), entity.getEntityId(), entity.getLogisticsId(), entity.getShopType());
        if (count > 0) {
            return ResultVo.error("该平台的快递公司已添加到常用列表");
        }

        if (entity.getIsDefault() == null) {
            entity.setIsDefault(0);
        }
        if (entity.getSort() == null) {
            entity.setSort(0);
        }
        entity.setCreateTime(LocalDateTime.now());
        entity.setUpdateTime(LocalDateTime.now());

        if (entity.getIsDefault() == 1) {
            shipLogisticsMapper.cancelDefault(entity.getEntityType(), entity.getEntityId());
        }

        int result = shipLogisticsMapper.insert(entity);
        if (result > 0) {
            return ResultVo.success();
        } else {
            return ResultVo.error("添加失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ResultVo<Integer> delete(Long id) {
        ErpShipLogistics entity = shipLogisticsMapper.selectById(id);
        if (entity == null) {
            return ResultVo.error("记录不存在");
        }

        int result = shipLogisticsMapper.deleteById(id);
        if (result > 0) {
            return ResultVo.success();
        } else {
            return ResultVo.error("删除失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ResultVo<Integer> setDefault(Long id) {
        ErpShipLogistics entity = shipLogisticsMapper.selectById(id);
        if (entity == null) {
            return ResultVo.error("记录不存在");
        }

        shipLogisticsMapper.cancelDefault(entity.getEntityType(), entity.getEntityId());

        ErpShipLogistics update = new ErpShipLogistics();
        update.setId(id);
        update.setIsDefault(1);
        update.setUpdateTime(LocalDateTime.now());
        int result = shipLogisticsMapper.updateById(update);

        if (result > 0) {
            return ResultVo.success();
        } else {
            return ResultVo.error("设置失败");
        }
    }

    @Override
    public ErpShipLogistics getDefault(String entityType, Long entityId) {
        return shipLogisticsMapper.selectDefault(entityType, entityId);
    }
}
