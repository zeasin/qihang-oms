package cn.qihangerp.erp.service;

import cn.qihangerp.common.ResultVo;
import cn.qihangerp.common.ResultVoEnum;
import cn.qihangerp.common.api.ShopApiParams;
import cn.qihangerp.enums.HttpStatus;
import cn.qihangerp.model.entity.OShop;
import cn.qihangerp.model.entity.OShopPlatform;
import cn.qihangerp.service.OShopPlatformService;
import cn.qihangerp.service.OShopService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@AllArgsConstructor
@Component
public class ShopApiCommon {
    private final OShopService shopService;
    private final OShopPlatformService platformService;

    /**
     * 拉取前的检查，校验店铺与平台配置，并组装API调用参数
     *
     * @param shopId       店铺ID
     * @param expectedType 期望的店铺类型（平台类型编码）
     * @return
     */
    public ResultVo<ShopApiParams> checkBefore(Long shopId, int expectedType) {
        OShop shop = shopService.getById(shopId);
        if (shop == null) {
            return ResultVo.error(HttpStatus.PARAMS_ERROR, "参数错误，没有找到店铺");
        }

        if (shop.getType() == null || shop.getType() != expectedType) {
            return ResultVo.error(HttpStatus.PARAMS_ERROR, "参数错误，店铺类型不匹配");
        }

        OShopPlatform platform = platformService.selectById(expectedType);
        if (platform == null) {
            return ResultVo.error(HttpStatus.PARAMS_ERROR, "平台配置错误，没有找到平台配置");
        }
        if (!StringUtils.hasText(platform.getAppKey())) {
            return ResultVo.error(HttpStatus.PARAMS_ERROR, "平台配置错误，没有找到AppKey");
        }
        if (!StringUtils.hasText(platform.getAppSecret())) {
            return ResultVo.error(HttpStatus.PARAMS_ERROR, "第三方平台配置错误，没有找到AppSercet");
        }

        ShopApiParams params = new ShopApiParams();
        params.setAppKey(platform.getAppKey());
        params.setAppSecret(platform.getAppSecret());
        params.setAccessToken(shop.getAccessToken());
        params.setRedirectUri(platform.getRedirectUri());
        params.setServerUrl(platform.getServerUrl());
        params.setSellerId(shop.getSellerId());

        if (!StringUtils.hasText(shop.getAccessToken())) {
            return ResultVo.error(ResultVoEnum.UNAUTHORIZED.getIndex(), "Token已过期，请重新授权", params);
        }

        return ResultVo.success(HttpStatus.SUCCESS, params);
    }

}
