package cn.qihangerp.mapper;

import cn.qihangerp.model.bo.OrderItemListBo;
import cn.qihangerp.model.entity.OOrderItem;
import cn.qihangerp.model.vo.OrderItemListVo;
import cn.qihangerp.model.vo.SalesTopSkuVo;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
* @author qilip
* @description 针对表【o_order_item(OMS订单明细表)】的数据库操作Mapper
* @createDate 2025-06-01 14:08:04
* @Entity cn.qihangerp.model.entity.OOrderItem
*/
public interface OOrderItemMapper extends BaseMapper<OOrderItem> {
    Page<OrderItemListVo> selectPageVo(@Param("page") Page<OrderItemListVo> page, @Param("qw") OrderItemListBo qw);
    List<OrderItemListVo> selectOrderItemListByOrderId(@Param("orderId") Long orderId);
    List<SalesTopSkuVo> selectTopSku(@Param("startDate") String startDate, @Param("endDate") String endDate);

    /**
     * 按订单ID锁定商品行（审单工作台拆单/合并事务内 SELECT ... FOR UPDATE，防并发分配）
     */
    @Select("SELECT * FROM o_order_item WHERE order_id = #{orderId} FOR UPDATE")
    List<OOrderItem> lockByOrderId(@Param("orderId") Long orderId);
}




