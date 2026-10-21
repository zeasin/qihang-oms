package cn.qihangerp.service;

import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.model.bo.OrderAddressBo;
import cn.qihangerp.model.bo.OrderCancelBo;
import cn.qihangerp.model.bo.OrderExceptionBo;
import cn.qihangerp.model.bo.OrderMemoBo;
import cn.qihangerp.model.bo.OrderReleaseBo;
import cn.qihangerp.model.bo.OrderWithdrawBo;
import cn.qihangerp.model.request.OrderWorkbenchQuery;
import cn.qihangerp.model.vo.ExceptionTagCountVo;
import cn.qihangerp.model.vo.OrderPoolCountsVo;
import cn.qihangerp.model.vo.OrderPoolOrderVo;
import cn.qihangerp.model.vo.OrderReleaseResultVo;

import java.util.List;

/**
 * 订单处理工作台-订单域服务（四池查询/池计数/批量转异常转正常/批量放行/撤回/取消/备注/地址）
 * 参照 qihang-erp-pro OrderWorkbenchOrderService（docs/design/15-订单处理工作台.md §2.2/§2.6/§2.7/§2.8）
 *
 * @author qihang
 * @date 2026-10-21
 */
public interface OrderWorkbenchOrderService {

    /** 状态池分页查询（四池平铺：主单行/子单行各自成行，含 canRelease） */
    PageResult<OrderPoolOrderVo> poolPage(OrderWorkbenchQuery query, PageQuery pageQuery);

    /** 状态池计数（页签角标） */
    OrderPoolCountsVo poolCounts(OrderWorkbenchQuery query);

    /** 批量转异常/转正常（audit_status 0↔2 流转；转异常必带 bind_pool=2 分类标签并覆盖写） */
    ResultVo<String> toException(OrderExceptionBo bo, List<Long> merchantIds, String username);

    /** 异常池分类计数（bind_pool=2 标签聚合 + 未分类兜底） */
    ExceptionTagCountVo exceptionTagCounts(OrderWorkbenchQuery query);

    /** 批量审核放行（逐单成功/失败+原因，部分失败留池） */
    ResultVo<OrderReleaseResultVo> release(OrderReleaseBo bo, List<Long> merchantIds, String username);

    /** 已放行订单撤回异常池（audit_status 1→2，逐单独立事务退回并返回逐单原因；必带异常分类标签覆盖写；已取号需先在打单发货页取消取号） */
    ResultVo<OrderReleaseResultVo> withdrawToException(OrderWithdrawBo bo, List<Long> merchantIds, String username);

    /** 取消订单（主订单级单张，未发货前置，子单联动作废） */
    ResultVo<Void> cancelOrder(OrderCancelBo bo, List<Long> merchantIds, String username);

    /** 修改卖家备注（未发货前可改） */
    ResultVo<Void> updateMemo(OrderMemoBo bo, List<Long> merchantIds, String username);

    /** 修改收货地址（未发货前可改，已取号需先取消取号，主单同步未取号子单） */
    ResultVo<Void> updateAddress(OrderAddressBo bo, List<Long> merchantIds, String username);
}
