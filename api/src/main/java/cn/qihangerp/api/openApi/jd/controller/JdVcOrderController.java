package cn.qihangerp.api.openApi.jd.controller;

import cn.qihangerp.common.AjaxResult;
import cn.qihangerp.common.PageQuery;
import cn.qihangerp.common.PageResult;
import cn.qihangerp.common.TableDataInfo;
import cn.qihangerp.common.enums.EnumShopType;
import cn.qihangerp.common.mq.MqMessage;
import cn.qihangerp.common.mq.MqType;
import cn.qihangerp.common.mq.MqUtils;
import cn.qihangerp.module.open.jd.domain.JdVcOrder;
import cn.qihangerp.module.open.jd.domain.bo.JdOrderBo;
import cn.qihangerp.module.open.jd.domain.bo.JdOrderPushBo;
import cn.qihangerp.module.open.jd.service.JdVcOrderService;

import cn.qihangerp.security.common.BaseController;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

@AllArgsConstructor
@RestController
@RequestMapping("/api/open-api/jdvc/order")
public class JdVcOrderController extends BaseController {
    private final JdVcOrderService orderService;
    private final MqUtils mqUtils;
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public TableDataInfo orderList(JdOrderBo bo, PageQuery pageQuery) {
        PageResult<JdVcOrder> result = orderService.queryPageList(bo, pageQuery);

        return getDataTable(result);
    }
    @PostMapping("/push_oms")
    @ResponseBody
    public AjaxResult pushOms(@RequestBody JdOrderPushBo bo) {
        // TODO:需要优化消息格式
        if(bo!=null && bo.getIds()!=null) {
            for(String id: bo.getIds()) {
                mqUtils.sendApiMessage(MqMessage.build(EnumShopType.JDVC, MqType.ORDER_MESSAGE, id));
            }
        }
        return success();
    }
}
