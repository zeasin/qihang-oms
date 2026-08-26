package cn.qihangerp.service;

import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.model.entity.ShopRefund;
import cn.qihangerp.model.request.SaleOrderAfterAddRequest;
import com.baomidou.mybatisplus.extension.service.IService;

public interface ShopRefundService extends IService<ShopRefund> {
    PageResult<ShopRefund> queryPageList(ShopRefund bo, PageQuery pageQuery);
    ResultVo<Long> saveRefund(Long shopId, ShopRefund bo);
    ResultVo<Long> addRefund(SaleOrderAfterAddRequest addRequest);
}
