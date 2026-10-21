package cn.qihangerp.service.impl;

import cn.qihangerp.enums.EnumAuditStatus;
import cn.qihangerp.enums.EnumAuditType;
import cn.qihangerp.enums.EnumOrderRole;
import cn.qihangerp.mapper.OOrderItemMapper;
import cn.qihangerp.mapper.OOrderMapper;
import cn.qihangerp.mapper.SysConfigMapper;
import cn.qihangerp.model.entity.OOrder;
import cn.qihangerp.model.entity.OOrderItem;
import cn.qihangerp.model.entity.SysConfig;
import cn.qihangerp.service.OrderAuditInitService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

/**
 * 订单审核初始化 / 拉单转单共用组件实现。
 * 参照 qihang-erp-pro ShopOrderServiceImpl#applyAuditInit / #syncOOrder，
 * 差异：OMS 口径 order.manual_audit.enabled 默认 true（订单进来必须审核）。
 */
@Slf4j
@AllArgsConstructor
@Service
public class OrderAuditInitServiceImpl implements OrderAuditInitService {

    private static final String MANUAL_AUDIT_CONFIG_KEY = "order.manual_audit.enabled";
    /** 人工审单配置本地缓存时长（毫秒），避免批量拉单逐单查询 sys_config */
    private static final long AUDIT_CONFIG_CACHE_MS = 60_000L;
    /** 缓存刷新时间戳；manualAuditEnabled==null 表示未加载 */
    private static volatile Boolean manualAuditEnabled;
    private static volatile long manualAuditConfigLoadTime;

    private final SysConfigMapper sysConfigMapper;
    private final OOrderMapper oOrderMapper;
    private final OOrderItemMapper oOrderItemMapper;

    @Override
    public boolean isManualAuditEnabled() {
        if (manualAuditEnabled == null
                || System.currentTimeMillis() - manualAuditConfigLoadTime > AUDIT_CONFIG_CACHE_MS) {
            SysConfig config = sysConfigMapper.selectOne(new LambdaQueryWrapper<SysConfig>()
                    .eq(SysConfig::getConfigKey, MANUAL_AUDIT_CONFIG_KEY)
                    .last("limit 1"));
            String configValue = config == null ? null : config.getConfigValue();
            // OMS 口径：缺省/空值按人工审核（true）处理，与 erp-pro（缺省自动）相反
            manualAuditEnabled = !("false".equalsIgnoreCase(configValue) || "0".equals(configValue));
            manualAuditConfigLoadTime = System.currentTimeMillis();
        }
        return Boolean.TRUE.equals(manualAuditEnabled);
    }

    @Override
    public void applyAuditInit(OOrder order, boolean manualAudit) {
        if (manualAudit) {
            // 人工审核模式：待审核，等待审单工作台放行
            order.setAuditStatus(EnumAuditStatus.PENDING.getIndex());
            order.setAuditType(EnumAuditType.MANUAL.getIndex());
        } else {
            // 自动审核模式：直接放行
            order.setAuditStatus(EnumAuditStatus.APPROVED.getIndex());
            order.setAuditType(EnumAuditType.AUTO.getIndex());
            order.setAuditTime(LocalDateTime.now());
            order.setAuditBy("system");
        }
        order.setOrderRole(EnumOrderRole.MASTER.getIndex());
        order.setParentOrderId(0L);
    }

    @Override
    public OOrder syncToOOrder(OOrder order, List<OOrderItem> items) {
        if (order == null || !StringUtils.hasText(order.getSourceOrderId()) || order.getShopType() == null) {
            log.warn("syncToOOrder 缺少幂等键 sourceOrderId/shopType，跳过转单 orderNum={}",
                    order == null ? null : order.getOrderNum());
            return null;
        }
        // 幂等键：sourceOrderId（平台落地表订单主键字符串）+ shopType，只认主订单
        OOrder exist = oOrderMapper.selectOne(new LambdaQueryWrapper<OOrder>()
                .eq(OOrder::getSourceOrderId, order.getSourceOrderId())
                .eq(OOrder::getShopType, order.getShopType())
                .eq(OOrder::getOrderRole, EnumOrderRole.MASTER.getIndex())
                .last("limit 1"));
        if (exist == null) {
            // 兜底：升级前人工 confirmOrder 转入的存量单没有 source_order_id，
            // 重拉补转时按 orderNum+shopType 的主订单再判一次重，防止重复生成
            exist = oOrderMapper.selectOne(new LambdaQueryWrapper<OOrder>()
                    .eq(OOrder::getOrderNum, order.getOrderNum())
                    .eq(OOrder::getShopType, order.getShopType())
                    .eq(OOrder::getParentOrderId, 0L)
                    .last("limit 1"));
        }
        if (exist != null) {
            // 已转入订单库，幂等跳过
            return null;
        }

        applyAuditInit(order, isManualAuditEnabled());
        if (order.getCreateTime() == null) order.setCreateTime(new Date());
        oOrderMapper.insert(order);

        if (items != null) {
            for (OOrderItem item : items) {
                item.setOrderId(order.getId());
                if (item.getItemRole() == null) {
                    item.setItemRole(EnumOrderRole.MASTER.getIndex());
                }
                if (item.getCreateTime() == null) item.setCreateTime(new Date());
                oOrderItemMapper.insert(item);
            }
        }
        return order;
    }
}
