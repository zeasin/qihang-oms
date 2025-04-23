//package cn.qihangerp.open.jd.service.impl;
//
//import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
//import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
//import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
//import cn.qihangerp.common.PageQuery;
//import cn.qihangerp.common.PageResult;
//import cn.qihangerp.common.ResultVo;
//import cn.qihangerp.common.ResultVoEnum;
//import cn.qihangerp.open.jd.domain.JdOrderAfter;
//import cn.qihangerp.open.jd.domain.bo.JdAfterBo;
//import cn.qihangerp.open.jd.service.JdOrderAfterService;
//import cn.qihangerp.open.jd.mapper.JdOrderAfterMapper;
//import lombok.AllArgsConstructor;
//import org.springframework.stereotype.Service;
//import org.springframework.transaction.interceptor.TransactionAspectSupport;
//
//import java.util.List;
//
///**
//* @author qilip
//* @description 针对表【jd_order_after(京东售后)】的数据库操作Service实现
//* @createDate 2024-03-10 18:37:36
//*/
//@AllArgsConstructor
//@Service
//public class JdOrderAfterServiceImpl extends ServiceImpl<JdOrderAfterMapper, JdOrderAfter>
//    implements JdOrderAfterService{
//    private final JdOrderAfterMapper mapper;
//
//    @Override
//    public PageResult<JdOrderAfter> queryPageList(JdAfterBo bo, PageQuery pageQuery) {
//        LambdaQueryWrapper<JdOrderAfter> queryWrapper = new LambdaQueryWrapper<JdOrderAfter>()
//                .eq(bo.getShopId()!=null,JdOrderAfter::getShopId,bo.getShopId());
//
//        Page<JdOrderAfter> page = mapper.selectPage(pageQuery.build(), queryWrapper);
//
//        return PageResult.build(page);
//    }
//
//    @Override
//    public ResultVo<Integer> saveAfter(Integer shopId, JdOrderAfter after) {
//       try {
//           List<JdOrderAfter> jdOrderAfters = mapper.selectList(new LambdaQueryWrapper<JdOrderAfter>().eq(JdOrderAfter::getApplyId, after.getApplyId()));
//           if (jdOrderAfters != null && jdOrderAfters.size() > 0) {
//               // 存在，修改
//               JdOrderAfter update = new JdOrderAfter();
//               update.setId(jdOrderAfters.get(0).getId());
//               update.setServiceStatus(after.getServiceStatus());
//               update.setServiceStatusName(after.getServiceStatusName());
//               update.setApprovePin(after.getApprovePin());
//               update.setApproveName(after.getApproveName());
//               update.setApproveTime(after.getApproveTime());
//               update.setApproveResult(after.getApproveResult());
//               update.setApproveResultName(after.getApproveResultName());
//               update.setProcessPin(after.getProcessPin());
//               update.setProcessName(after.getProcessName());
//               update.setProcessTime(after.getProcessTime());
//               update.setProcessResult(after.getProcessResult());
//               update.setProcessResultName(after.getProcessResultName());
//               mapper.updateById(update);
//               return ResultVo.error(ResultVoEnum.DataExist, "退款已经存在，更新成功");
//           } else {
//               // 新增
//               after.setShopId(shopId);
//               mapper.insert(after);
//               return ResultVo.success();
//           }
//
//       } catch (Exception e) {
//           TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
//           return ResultVo.error(ResultVoEnum.SystemException, "系统异常：" + e.getMessage());
//       }
//    }
//
//    @Override
//    public ResultVo<Long> updateAfterStatusByServiceId(JdOrderAfter after) {
//        List<JdOrderAfter> jdOrderAfters = mapper.selectList(new LambdaQueryWrapper<JdOrderAfter>().eq(JdOrderAfter::getServiceId, after.getServiceId()));
//        if (jdOrderAfters != null && jdOrderAfters.size() > 0) {
//            // 存在，修改
//            JdOrderAfter update = new JdOrderAfter();
//            update.setId(jdOrderAfters.get(0).getId());
//            update.setServiceStatus(after.getServiceStatus());
//            mapper.updateById(update);
//            return ResultVo.success(update.getId());
//        }
//        return ResultVo.error(ResultVoEnum.NotFound, "没有找到退款数据");
//    }
//}
//
//
//
//
