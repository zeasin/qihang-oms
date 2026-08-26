package cn.qihangerp.model.request;

import lombok.Data;

@Data
public class RefundPullRequest {
    private Long shopId;
    private String orderId;
    private String refundId;
    private String afterId;
    private String createTime;
    private String updateTime;
}
