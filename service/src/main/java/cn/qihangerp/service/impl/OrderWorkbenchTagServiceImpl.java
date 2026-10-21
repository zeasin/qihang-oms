package cn.qihangerp.service.impl;

import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.enums.EnumEnableStatus;
import cn.qihangerp.mapper.OOrderMapper;
import cn.qihangerp.mapper.OOrderTagMapper;
import cn.qihangerp.model.bo.OrderTagApplyBo;
import cn.qihangerp.model.entity.OOrder;
import cn.qihangerp.model.entity.OOrderTag;
import cn.qihangerp.service.OrderWorkbenchTagService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 订单处理工作台-用户自建标签服务实现
 * 打标/撤标：逐单读取 o_order.tag → 追加/移除标签ID（LinkedHashSet 保序去重）→ 整串回写；
 * 服务端拼接（非前端整串提交）避免并发互相覆盖，前端只传订单ID+标签ID+动作
 * <p>
 * 移植 qihang-erp-pro OrderWorkbenchTagServiceImpl（只读参考），OMS 侧差异：
 * - 实体：OrderTag → OOrderTag（表 o_order_tag），操作人字段 op_by → create_by/update_by（03 建表脚本口径）
 * - 返回结构沿用 OMS common 的 PageResult/ResultVo；单据数据域收敛在 Controller（merchantIds 传入）
 *
 * @author qihang
 * @date 2026-10-21
 */
@Slf4j
@Service
@AllArgsConstructor
public class OrderWorkbenchTagServiceImpl implements OrderWorkbenchTagService {

    private final OOrderTagMapper tagMapper;
    private final OOrderMapper orderMapper;

    @Override
    public PageResult<OOrderTag> queryPageList(OOrderTag bo, Long merchantId, PageQuery pageQuery) {
        if (bo == null) bo = new OOrderTag();
        LambdaQueryWrapper<OOrderTag> wrapper = new LambdaQueryWrapper<OOrderTag>()
                .eq(merchantId != null, OOrderTag::getMerchantId, merchantId)
                .like(StringUtils.hasText(bo.getName()), OOrderTag::getName, bo.getName())
                .eq(bo.getStatus() != null, OOrderTag::getStatus, bo.getStatus())
                .orderByAsc(OOrderTag::getSort)
                .orderByAsc(OOrderTag::getId);
        Page<OOrderTag> page = tagMapper.selectPage(pageQuery.build(), wrapper);
        return PageResult.build(page);
    }

    @Override
    public List<OOrderTag> listEnabled(Long merchantId) {
        // 商户身份：本商户自建 + 总部公共（merchant_id=0）；总部身份（merchantId=null）：全部
        LambdaQueryWrapper<OOrderTag> wrapper = new LambdaQueryWrapper<OOrderTag>()
                .eq(OOrderTag::getStatus, EnumEnableStatus.ENABLED.getIndex());
        // and() 嵌套必须带条件，空体会拼出 "AND ()" 导致 SQL 语法错误（总部身份 merchantId=null 时不加此段）
        if (merchantId != null) {
            wrapper.and(w -> w.eq(OOrderTag::getMerchantId, merchantId).or().eq(OOrderTag::getMerchantId, 0L));
        }
        wrapper.orderByAsc(OOrderTag::getSort)
                .orderByAsc(OOrderTag::getId);
        return tagMapper.selectList(wrapper);
    }

    @Override
    public List<OOrderTag> listEnabledByPool(Integer bindPool) {
        // 分类标签全系统共用（2026-10-19 定版）：不走商户隔离，仅 bind_pool 匹配 + 启用
        if (bindPool == null) return new ArrayList<>();
        return tagMapper.selectList(new LambdaQueryWrapper<OOrderTag>()
                .eq(OOrderTag::getBindPool, bindPool)
                .eq(OOrderTag::getStatus, EnumEnableStatus.ENABLED.getIndex())
                .orderByAsc(OOrderTag::getSort)
                .orderByAsc(OOrderTag::getId));
    }

    @Override
    public ResultVo<Long> add(OOrderTag bo, Long merchantId, String username) {
        if (!StringUtils.hasText(bo.getName())) return ResultVo.error("标签名称不能为空");
        if (bo.getName().length() > 50) return ResultVo.error("标签名称不能超过50个字符");
        // 同商户下标签名唯一
        Long count = tagMapper.selectCount(new LambdaQueryWrapper<OOrderTag>()
                .eq(OOrderTag::getName, bo.getName())
                .eq(OOrderTag::getMerchantId, merchantId == null ? 0L : merchantId));
        if (count != null && count > 0) return ResultVo.error("标签名称已存在：" + bo.getName());

        bo.setMerchantId(merchantId == null ? 0L : merchantId);
        bo.setCreateBy(username);
        bo.setUpdateBy(username);
        bo.setStatus(bo.getStatus() != null ? bo.getStatus() : EnumEnableStatus.ENABLED.getIndex());
        bo.setBindPool(bo.getBindPool() == null ? 0 : bo.getBindPool());
        tagMapper.insert(bo);
        return ResultVo.success(bo.getId());
    }

    @Override
    public ResultVo<Void> edit(OOrderTag bo, String username) {
        if (bo.getId() == null) return ResultVo.error("ID不能为空");
        OOrderTag exist = tagMapper.selectById(bo.getId());
        if (exist == null) return ResultVo.error("标签不存在");
        if (StringUtils.hasText(bo.getName()) && !bo.getName().equals(exist.getName())) {
            Long count = tagMapper.selectCount(new LambdaQueryWrapper<OOrderTag>()
                    .eq(OOrderTag::getName, bo.getName())
                    .eq(OOrderTag::getMerchantId, exist.getMerchantId())
                    .ne(OOrderTag::getId, bo.getId()));
            if (count != null && count > 0) return ResultVo.error("标签名称已存在：" + bo.getName());
        }

        // 标签名/颜色改字典不刷订单（订单只存标签ID），merchantId/状态不在编辑范围；bindPool 关联状态池可改
        LambdaUpdateWrapper<OOrderTag> upd = new LambdaUpdateWrapper<OOrderTag>()
                .eq(OOrderTag::getId, bo.getId())
                .set(OOrderTag::getName, StringUtils.hasText(bo.getName()) ? bo.getName() : exist.getName())
                .set(OOrderTag::getColor, StringUtils.hasText(bo.getColor()) ? bo.getColor() : exist.getColor())
                .set(OOrderTag::getSort, bo.getSort() == null ? exist.getSort() : bo.getSort())
                .set(OOrderTag::getBindPool, bo.getBindPool() == null ? exist.getBindPool() : bo.getBindPool())
                .set(OOrderTag::getUpdateBy, username)
                .set(OOrderTag::getUpdateTime, new Date());
        tagMapper.update(null, upd);
        return ResultVo.success();
    }

    @Override
    public ResultVo<Void> setStatus(Long id, Integer status, String username) {
        if (id == null) return ResultVo.error("ID不能为空");
        if (status == null || (status != EnumEnableStatus.DISABLED.getIndex() && status != EnumEnableStatus.ENABLED.getIndex())) {
            return ResultVo.error("状态值不正确");
        }
        OOrderTag update = new OOrderTag();
        update.setId(id);
        update.setStatus(status);
        update.setUpdateBy(username);
        update.setUpdateTime(new Date());
        tagMapper.updateById(update);
        return ResultVo.success();
    }

    @Override
    public ResultVo<Void> remove(Long id, String username) {
        if (id == null) return ResultVo.error("ID不能为空");
        OOrderTag exist = tagMapper.selectById(id);
        if (exist == null) return ResultVo.error("标签不存在");
        tagMapper.deleteById(id);
        return ResultVo.success();
    }

    @Override
    public ResultVo<String> applyTags(OrderTagApplyBo bo, List<Long> merchantIds, String username) {
        if (bo.getAction() == null || (bo.getAction() != 1 && bo.getAction() != 0)) {
            return ResultVo.error("动作不正确：1=打标，0=撤标");
        }
        if (bo.getOrderIds() == null || bo.getOrderIds().isEmpty()) return ResultVo.error("请先勾选订单");
        if (bo.getTagIds() == null || bo.getTagIds().isEmpty()) return ResultVo.error("请选择标签");

        List<Long> orderIds = bo.getOrderIds().stream()
                .filter(StringUtils::hasText)
                .map(s -> s.trim())
                .filter(s -> s.matches("\\d+"))
                .map(Long::valueOf)
                .distinct()
                .collect(Collectors.toList());
        if (orderIds.isEmpty()) return ResultVo.error("订单ID不正确");

        // 标签必须存在且启用（撤标允许针对已停用标签，因此仅打标时校验启用）
        Map<Long, OOrderTag> tagMap = tagMapper.selectBatchIds(bo.getTagIds()).stream()
                .collect(Collectors.toMap(OOrderTag::getId, Function.identity()));
        for (Long tagId : bo.getTagIds()) {
            OOrderTag tag = tagMap.get(tagId);
            if (tag == null) return ResultVo.error("标签不存在：ID=" + tagId);
            if (bo.getAction() == 1 && tag.getStatus() != EnumEnableStatus.ENABLED.getIndex()) {
                return ResultVo.error("标签已停用，不能打标：" + tag.getName());
            }
        }

        // 逐单更新：追加/移除标签ID，保序去重后整串回写
        Set<String> tagIdSet = bo.getTagIds().stream().map(String::valueOf).collect(Collectors.toSet());
        List<OOrder> orders = orderMapper.selectBatchIds(orderIds);
        if (orders.size() != orderIds.size()) {
            return ResultVo.error("存在无效订单ID，请刷新列表后重试");
        }

        int updated = 0;
        int skipped = 0;
        Date now = new Date();
        for (OOrder order : orders) {
            // 数据权限：非总部（merchantIds 有限定）时，越权订单跳过
            if (merchantIds != null && !merchantIds.contains(order.getMerchantId())) {
                skipped++;
                continue;
            }
            LinkedHashSet<String> ids = parseTagIds(order.getTag());
            if (bo.getAction() == 1) {
                ids.addAll(tagIdSet);
            } else {
                ids.removeAll(tagIdSet);
            }
            String joined = String.join(",", ids);
            if (joined.equals(order.getTag() == null ? "" : order.getTag())) {
                continue;
            }
            orderMapper.update(null, new LambdaUpdateWrapper<OOrder>()
                    .eq(OOrder::getId, order.getId())
                    .set(OOrder::getTag, joined)
                    .set(OOrder::getUpdateTime, now));
            updated++;
        }
        log.info("======订单批量{}======操作人={}，选中={}单，更新={}单，越权跳过={}单",
                bo.getAction() == 1 ? "打标" : "撤标", username, orders.size(), updated, skipped);
        String msg = bo.getAction() == 1 ? "打标" : "撤标";
        if (skipped > 0) {
            return ResultVo.success(String.format("%s成功 %d 单，%d 单无权限已跳过", msg, updated, skipped));
        }
        return ResultVo.success(String.format("%s成功 %d 单", msg, updated));
    }

    @Override
    public List<OOrderTag> listByIds(String tagIds) {
        if (!StringUtils.hasText(tagIds)) return new ArrayList<>();
        List<Long> ids = parseTagIds(tagIds).stream()
                .map(Long::valueOf)
                .filter(id -> id > 0)
                .collect(Collectors.toList());
        if (ids.isEmpty()) return new ArrayList<>();
        return tagMapper.selectBatchIds(ids);
    }

    /** 解析订单标签串（逗号分隔ID）为保序去重集合，过滤非法片段 */
    private LinkedHashSet<String> parseTagIds(String tag) {
        LinkedHashSet<String> result = new LinkedHashSet<>();
        if (!StringUtils.hasText(tag)) return result;
        Arrays.stream(tag.split(","))
                .map(String::trim)
                .filter(s -> s.matches("\\d+"))
                .forEach(result::add);
        return result;
    }
}
