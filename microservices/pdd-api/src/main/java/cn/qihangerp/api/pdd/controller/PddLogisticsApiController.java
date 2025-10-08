package cn.qihangerp.api.pdd.controller;

import cn.qihangerp.api.pdd.PddApiCommon;
import cn.qihangerp.api.pdd.PddPullRequest;
import cn.qihangerp.common.AjaxResult;
import cn.qihangerp.common.ResultVo;
import cn.qihangerp.common.ResultVoEnum;
import cn.qihangerp.common.enums.EnumShopType;
import cn.qihangerp.common.enums.HttpStatus;
import cn.qihangerp.model.entity.OLogisticsCompany;
import cn.qihangerp.model.entity.OShopPlatform;
import cn.qihangerp.model.entity.OShopPullLasttime;
import cn.qihangerp.model.entity.OShopPullLogs;
import cn.qihangerp.module.open.pdd.domain.PddGoods;
import cn.qihangerp.module.open.pdd.domain.PddGoodsSku;
import cn.qihangerp.module.open.pdd.service.PddGoodsService;
import cn.qihangerp.module.service.OLogisticsCompanyService;
import cn.qihangerp.module.service.OShopPlatformService;
import cn.qihangerp.module.service.OShopPullLasttimeService;
import cn.qihangerp.module.service.OShopPullLogsService;
import cn.qihangerp.open.common.ApiResultVo;
import cn.qihangerp.open.pdd.PddGoodsApiHelper;
import cn.qihangerp.open.pdd.PddLogisticsApiHelper;
import cn.qihangerp.open.pdd.model.GoodsResultVo;
import cn.qihangerp.open.pdd.model.LogisticsCompany;
import cn.qihangerp.open.pdd.model.WaybillCodeModule;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Slf4j
@RequestMapping("/pdd/logistics")
@RestController
@AllArgsConstructor
public class PddLogisticsApiController {
    private final OShopPlatformService platformService;
    private final OLogisticsCompanyService companyService;
    /**
     * 拉取快递公司
     * @param
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/pull_logistics", method = RequestMethod.POST)
    public AjaxResult pullSkuList() throws Exception {
        OShopPlatform platform = platformService.getById(EnumShopType.PDD.getIndex());

        if (!StringUtils.hasText(platform.getAppKey())) {
            return AjaxResult.error( "平台配置错误，没有找到AppKey");
        }
        if (!StringUtils.hasText(platform.getAppSecret())) {
            return AjaxResult.error("平台配置错误，没有找到AppSercet");
        }
        ApiResultVo<LogisticsCompany> resultVo = PddLogisticsApiHelper.getLogisticsCompany(platform.getAppKey(), platform.getAppSecret());
        if (resultVo.getCode() == ResultVoEnum.SUCCESS.getIndex()) {
            for (var item:resultVo.getList()){
                OLogisticsCompany oLogisticsCompany = new OLogisticsCompany();
                oLogisticsCompany.setPlatformId(EnumShopType.PDD.getIndex());
                oLogisticsCompany.setShopId(0L);
                oLogisticsCompany.setLogisticsId(item.getId().toString());
                oLogisticsCompany.setCode(item.getCode());
                oLogisticsCompany.setName(item.getLogisticsCompany());
                oLogisticsCompany.setStatus(0);
                companyService.save(oLogisticsCompany);
                log.info("=========添加物流快递公司===========");
            }
            log.info("=========PDD物流快递公司添加完成========");
        }else{
            return AjaxResult.error(resultVo.getMsg());
        }
        return AjaxResult.success("开源版本暂未实现");
    }
}
