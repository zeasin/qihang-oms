package cn.qihangerp.api.dou.controller;


import cn.qihangerp.api.dou.DouApiCommon;
import cn.qihangerp.api.dou.DouPullRequest;
import cn.qihangerp.common.AjaxResult;
import cn.qihangerp.common.ResultVoEnum;
import cn.qihangerp.common.enums.EnumShopType;
import cn.qihangerp.common.enums.HttpStatus;
import cn.qihangerp.common.mq.MqMessage;
import cn.qihangerp.common.mq.MqType;
import cn.qihangerp.common.mq.MqUtils;
import cn.qihangerp.model.entity.OLogisticsCompany;
import cn.qihangerp.model.entity.OShop;
import cn.qihangerp.model.entity.OShopPullLasttime;
import cn.qihangerp.model.entity.OShopPullLogs;
import cn.qihangerp.module.open.dou.domain.DouRefund;
import cn.qihangerp.module.open.dou.service.DouRefundService;
import cn.qihangerp.module.service.OLogisticsCompanyService;
import cn.qihangerp.module.service.OShopPullLasttimeService;
import cn.qihangerp.module.service.OShopPullLogsService;
import cn.qihangerp.module.service.OShopService;
import cn.qihangerp.open.common.ApiResultVo;
import cn.qihangerp.open.dou.DouLogisticsApiHelper;
import cn.qihangerp.open.dou.DouRefundApiHelper;
import cn.qihangerp.open.dou.DouTokenApiHelper;
import cn.qihangerp.open.dou.model.DouLogisticsCompany;
import cn.qihangerp.open.dou.model.Token;
import cn.qihangerp.open.dou.model.after.AfterSale;
import com.alibaba.fastjson2.JSONObject;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;

/**
 *
 */
@Slf4j
@AllArgsConstructor
@RestController
@RequestMapping("/dou/logistics")
public class DouLogisticsApiController {
    private final OShopService shopService;
    private final DouApiCommon douApiCommon;
    private final OLogisticsCompanyService companyService;
    /**
     *
     * @param
     * @
     * @throws
     */
    @PostMapping("/pull_logistics")
    @ResponseBody
    public AjaxResult pullRefundList()   {
        log.info("/**************增量拉取dou快递公司****************/");

        List<OShop> shopList = shopService.selectShopByShopType(EnumShopType.DOU);
        if(shopList == null || shopList.isEmpty()) {
            return AjaxResult.error("没有找到Dou店铺");
        }
        Date currDateTime = new Date();
        Long currTimeMillis = System.currentTimeMillis();

        var checkResult = douApiCommon.checkBefore(shopList.get(0).getId());
        if (checkResult.getCode() != HttpStatus.SUCCESS) {
            return AjaxResult.error(checkResult.getCode(), checkResult.getMsg(),checkResult.getData());
        }

        String appKey = checkResult.getData().getAppKey();
        String appSecret = checkResult.getData().getAppSecret();
        Long douShopId = checkResult.getData().getSellerId();
        String accessToken = checkResult.getData().getAccessToken();

        ApiResultVo<DouLogisticsCompany> resultVo = DouLogisticsApiHelper.getLogisticsCompanyList(appKey, appSecret, accessToken);

        if (resultVo.getCode() != 0) return AjaxResult.error(resultVo.getCode(), resultVo.getMsg());
        for (var item:resultVo.getList()){
            OLogisticsCompany oLogisticsCompany = new OLogisticsCompany();
            oLogisticsCompany.setPlatformId(EnumShopType.DOU.getIndex());
            oLogisticsCompany.setShopId(0L);
            oLogisticsCompany.setLogisticsId(item.getId().toString());
            oLogisticsCompany.setCode(item.getCode());
            oLogisticsCompany.setName(item.getName());
            oLogisticsCompany.setStatus(0);
            companyService.save(oLogisticsCompany);
            log.info("=========添加物流快递公司===========");
        }
        log.info("=========DOU物流快递公司添加完成========");



        return AjaxResult.success();
    }



}
