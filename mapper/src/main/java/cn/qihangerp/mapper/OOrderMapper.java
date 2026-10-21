package cn.qihangerp.mapper;

import cn.qihangerp.model.entity.OOrder;
import cn.qihangerp.model.vo.OrderDiscountVo;
import cn.qihangerp.model.vo.SalesDailyVo;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
* @author qilip
* @description 针对表【o_order(OMS订单表)】的数据库操作Mapper
* @createDate 2025-06-01 14:05:14
* @Entity cn.qihangerp.model.entity.OOrder
*/
public interface OOrderMapper extends BaseMapper<OOrder> {
    List<OrderDiscountVo> getTaoOrderDiscount(String tid);
    List<OrderDiscountVo> getJdOrderDiscount(String orderId);

    List<SalesDailyVo> salesDaily();
    SalesDailyVo getTodaySalesDaily();
    Integer getWaitShipOrderAllCount();

    /**
     * 按ID锁定订单行（审单工作台拆单事务内 SELECT ... FOR UPDATE，防并发拆分）
     */
    @Select("SELECT * FROM o_order WHERE id = #{id} FOR UPDATE")
    OOrder lockById(@Param("id") Long id);
}




