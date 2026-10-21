package cn.qihangerp.service;

import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.model.bo.OrderTagApplyBo;
import cn.qihangerp.model.entity.OOrderTag;

import java.util.List;

/**
 * 订单处理工作台-用户自建标签服务（标签 CRUD + 批量打标/撤标）
 * 参照 qihang-erp-pro OrderWorkbenchTagService（docs/design/15-订单处理工作台.md §2.4）
 * 标签按商户隔离，merchant_id=0 为总部公共标签；bind_pool=2 异常池分类标签全系统共用
 *
 * @author qihang
 * @date 2026-10-21
 */
public interface OrderWorkbenchTagService {

    /** 标签管理分页列表（merchantId=null 总部看全部，商户看本商户） */
    PageResult<OOrderTag> queryPageList(OOrderTag bo, Long merchantId, PageQuery pageQuery);

    /** 打标选项清单（仅启用标签，商户=本商户自建+总部公共；总部=全部） */
    List<OOrderTag> listEnabled(Long merchantId);

    /** 状态池分类标签选项（bind_pool 匹配 + 启用，全系统共用不限商户） */
    List<OOrderTag> listEnabledByPool(Integer bindPool);

    /** 新建标签 */
    ResultVo<Long> add(OOrderTag bo, Long merchantId, String username);

    /** 编辑标签（名称/颜色/排序/关联池） */
    ResultVo<Void> edit(OOrderTag bo, String username);

    /** 停用/启用标签 */
    ResultVo<Void> setStatus(Long id, Integer status, String username);

    /** 删除标签（物理删除） */
    ResultVo<Void> remove(Long id, String username);

    /** 批量打标/撤标：action 1=打标（追加去重）、0=撤标（移除） */
    ResultVo<String> applyTags(OrderTagApplyBo bo, List<Long> merchantIds, String username);

    /** 按订单 tag ID 串反查标签字典（详情展示用） */
    List<OOrderTag> listByIds(String tagIds);
}
