<template>
  <div class="app-container waybill-workbench">
    <!-- 子视图切换：全部待发货 / 待补分配（异常回落） -->
    <div class="view-bar">
      <el-radio-group v-model="query.allocatePending" size="small" @change="handleViewChange">
        <el-radio-button :label="false">全部待发货（{{ counts.total }}）</el-radio-button>
        <el-radio-button :label="true">待补分配（{{ counts.allocatePending }}）</el-radio-button>
      </el-radio-group>
      <span class="pool-tip">
        队列口径：已放行 · 待发货 · 未发货｜待取号 {{ counts.notTaken }} ·
        待打印 {{ counts.taken }} · 待发货 {{ counts.printed }}
      </span>
      <el-button size="mini" type="text" icon="el-icon-refresh" @click="getList">刷新</el-button>
    </div>

    <!-- 筛选区 -->
    <el-form :inline="true" size="small" class="filter-form">
      <el-form-item label="订单号">
        <el-input
          v-model="query.orderNums"
          placeholder="多个订单号换行/逗号分隔"
          clearable
          style="width: 200px"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="店铺">
        <el-select v-model="query.shopId" clearable filterable placeholder="全部店铺" style="width: 170px" @change="onShopChange">
          <el-option v-for="s in shopList" :key="s.id" :label="s.name" :value="s.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="平台">
        <el-select v-model="query.shopType" clearable placeholder="全部平台" style="width: 120px" @change="handleQuery">
          <el-option v-for="p in platformList" :key="p.id" :label="p.name" :value="p.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="取号状态">
        <el-select v-model="query.waybillStatus" clearable placeholder="全部" style="width: 110px" @change="handleQuery">
          <el-option label="未取号" :value="0" />
          <el-option label="已取号" :value="1" />
          <el-option label="已打印" :value="2" />
          <el-option label="已发货" :value="3" />
        </el-select>
      </el-form-item>
      <el-form-item label="发货主体类型">
        <el-select v-model="query.shipperType" clearable placeholder="全部" style="width: 130px" @change="handleQuery">
          <el-option v-for="t in shipperTypeOptions" :key="t.value" :label="t.label" :value="t.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="商品">
        <el-input
          v-model="query.goodsKeyword"
          placeholder="标题/规格编码/条码"
          clearable
          style="width: 160px"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="收件人">
        <el-input v-model="query.receiverName" placeholder="姓名" clearable style="width: 110px" @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="手机号">
        <el-input v-model="query.receiverMobile" placeholder="手机号" clearable style="width: 130px" @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="排序">
        <el-select v-model="query.sortField" clearable placeholder="默认（下单时间倒序）" style="width: 150px" @change="handleQuery">
          <el-option label="停留时长" value="stayTime" />
          <el-option label="取号状态" value="waybillStatus" />
          <el-option label="下单时间" value="orderTime" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button
          :type="query.sortField ? 'primary' : 'default'"
          :plain="!query.sortField"
          size="small"
          @click="toggleSortOrder"
        >{{ query.sortOrder === 'ascending' ? '正序' : '倒序' }}</el-button>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="handleQuery">查询</el-button>
        <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 发货主体分类 + 电子面单账号分组筛选 -->
    <div class="account-group-bar">
      <span class="bar-label">发货主体分类：</span>
      <el-tag
        size="small"
        :effect="!query.shipperCategory && !query.waybillAccountId ? 'dark' : 'plain'"
        @click="selectAllGroup"
      >全部</el-tag>
      <el-tag
        v-for="c in categoryChips"
        :key="c.value"
        size="small"
        :effect="query.shipperCategory === c.value && !query.waybillAccountId ? 'dark' : 'plain'"
        @click="selectCategory(c.value)"
      >{{ c.label }}</el-tag>
      <template v-if="accountGroups.length">
        <el-divider direction="vertical" />
        <span v-for="g in accountGroups" :key="g.key" class="account-group">
          <span class="group-name">{{ g.name }}：</span>
          <el-tag
            v-for="a in g.accounts"
            :key="a.id"
            size="small"
            :effect="query.waybillAccountId === a.id ? 'dark' : 'plain'"
            @click="selectAccount(a)"
          >{{ accountLabel(a) }}</el-tag>
        </span>
      </template>
      <span v-else class="sub-text">选择店铺后可按电子面单账号筛选</span>
    </div>

    <el-alert
      v-if="unsupportedTip"
      class="capability-alert"
      type="warning"
      :closable="false"
      show-icon
      :title="unsupportedTip"
    />
    <el-alert
      v-if="query.waybillStatus === 3"
      class="capability-alert"
      type="info"
      :closable="false"
      show-icon
      title="本队列为未发货口径，「已发货」终态单不在此列表，请到「发货 → 发货记录」查询"
    />

    <!-- 批量工具条 -->
    <div class="toolbar">
      <el-button
        v-hasPermi="['orderWorkbench:waybill:distribute']"
        size="small"
        type="primary"
        :disabled="!selection.length"
        @click="openDistribute(null)"
      >分配/改派</el-button>
      <el-button
        v-hasPermi="['orderWorkbench:waybill:take']"
        size="small"
        type="success"
        :disabled="!selection.length"
        @click="handleTake(null)"
      >取号</el-button>
      <el-button
        v-hasPermi="['orderWorkbench:waybill:print']"
        size="small"
        :disabled="!selection.length"
        @click="handlePrint(null)"
      >标记已打印</el-button>
      <el-button
        v-hasPermi="['orderWorkbench:waybill:ship']"
        size="small"
        type="primary"
        :disabled="!selection.length"
        @click="handleShip(null)"
      >发货</el-button>
      <el-button
        v-hasPermi="['orderWorkbench:waybill:cancel']"
        size="small"
        :disabled="!selection.length"
        @click="handleCancel(null)"
      >取消取号</el-button>
      <el-button
        v-hasPermi="['orderWorkbench:waybill:manualShip']"
        size="small"
        type="info"
        :disabled="selection.length !== 1"
        @click="openManualShip(selection.length === 1 ? selection[0] : null)"
      >手动发货</el-button>
      <el-button
        v-hasPermi="['orderWorkbench:waybill:return']"
        size="small"
        type="warning"
        :disabled="!selection.length"
        @click="openReturn(null)"
      >退回异常池</el-button>
      <span class="selection-tip">已选 {{ selection.length }} 单（手动发货/退回需先取消取号）</span>
    </div>

    <el-table
      v-loading="loading"
      :data="rows"
      border
      size="small"
      row-key="id"
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="45" align="center" />
      <el-table-column type="expand">
        <template slot-scope="{ row }">
          <div class="expand-panel">
            <div class="expand-head">
              发货主体：{{ row.shipperTypeName || '-' }}（ship_type={{ row.shipperType == null ? '-' : row.shipperType }}）
              · {{ row.shipperName || '未分配发货人' }}
              <span v-if="row.shipperTypeCode" class="sub-text">主体类型码 {{ row.shipperTypeCode }}</span>
              <span v-if="row.shipperNo" class="sub-text">主体编号 {{ row.shipperNo }}</span>
            </div>
            <el-table :data="row.items || []" border size="mini">
              <el-table-column label="图片" width="60">
                <template slot-scope="scope">
                  <image-preview v-if="scope.row.goodsImg" :src="scope.row.goodsImg" :width="36" :height="36" />
                </template>
              </el-table-column>
              <el-table-column label="商品标题" prop="goodsTitle" min-width="200" :show-overflow-tooltip="true" />
              <el-table-column label="规格" prop="goodsSpec" width="140" :show-overflow-tooltip="true" />
              <el-table-column label="规格编码" prop="skuNum" width="140" :show-overflow-tooltip="true" />
              <el-table-column label="商品编码" prop="goodsNum" width="140" :show-overflow-tooltip="true" />
              <el-table-column label="数量" prop="quantity" width="60" align="center" />
              <el-table-column label="发货状态" width="100" align="center">
                <template slot-scope="scope">
                  <el-tag size="mini" :type="itemShipTagType(scope.row.shipStatus)">
                    {{ itemShipStatusName(scope.row.shipStatus) }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="明细快递单号" min-width="170">
                <template slot-scope="scope">{{ scope.row.waybillCode || '-' }}</template>
              </el-table-column>
            </el-table>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="订单号" min-width="180">
        <template slot-scope="{ row }">
          <div class="order-num" @click="openDetail(row)">{{ row.orderNum }}</div>
          <el-tag v-if="row.orderRole === 1" size="mini" type="success">子订单</el-tag>
          <el-tag v-if="row.orderMode === 1" size="mini" type="warning">手工单</el-tag>
          <div v-if="row.tag" class="sub-text">标签 {{ row.tag }}</div>
        </template>
      </el-table-column>
      <el-table-column label="店铺/平台" min-width="140">
        <template slot-scope="{ row }">
          <div>{{ row.shopName || ('店铺#' + row.shopId) }}</div>
          <span class="sub-text">{{ row.platformName || platformNameOf(row.shopType) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="收件人" min-width="190">
        <template slot-scope="{ row }">
          <div>{{ row.receiverName }} {{ row.receiverMobile }}</div>
          <span class="sub-text">{{ fullAddress(row) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="商品明细" min-width="230">
        <template slot-scope="{ row }">
          <div v-for="(it, idx) in (row.items || []).slice(0, 2)" :key="idx" class="goods-line">
            <span class="goods-title">{{ it.goodsTitle }}</span>
            <span class="sub-text">{{ it.goodsSpec }} × {{ it.quantity }}</span>
          </div>
          <span v-if="(row.items || []).length > 2" class="sub-text">
            展开查看 共 {{ row.itemCount }} 种 / {{ row.totalQuantity }} 件
          </span>
        </template>
      </el-table-column>
      <el-table-column label="发货主体" min-width="130">
        <template slot-scope="{ row }">
          <div>{{ row.shipperName || '-' }}</div>
          <span class="sub-text">{{ row.shipperTypeName || '-' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="面单账号" min-width="160">
        <template slot-scope="{ row }">
          <template v-if="row.allocated">
            <div>{{ row.waybillAccountName || ('账号#' + row.waybillAccountId) }}</div>
            <span class="sub-text">{{ row.waybillAccountCompany || '-' }}</span>
          </template>
          <el-tag v-else size="mini" type="danger">未分配</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="取号状态" width="150">
        <template slot-scope="{ row }">
          <el-tag size="mini" :type="waybillTagType(row.waybillStatus)">{{ row.waybillStatusName }}</el-tag>
          <div v-if="row.waybillCode" class="sub-text">{{ row.waybillCompany }} {{ row.waybillCode }}</div>
        </template>
      </el-table-column>
      <el-table-column label="停留" width="90">
        <template slot-scope="{ row }">
          <span :class="stayClass(row.stayHours)">{{ stayText(row.stayHours) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="360" fixed="right">
        <template slot-scope="{ row }">
          <el-button type="text" size="mini" @click="openDetail(row)">详情</el-button>
          <el-button
            v-hasPermi="['orderWorkbench:waybill:distribute']"
            type="text"
            size="mini"
            @click="openDistribute(row)"
          >{{ row.allocated ? '改派' : '分配' }}</el-button>
          <el-tooltip :disabled="canTake(row)" :content="capTip(row, 'take')" placement="top">
            <el-button
              v-hasPermi="['orderWorkbench:waybill:take']"
              type="text"
              size="mini"
              :disabled="!canTake(row)"
              @click="handleTake(row)"
            >取号</el-button>
          </el-tooltip>
          <el-button
            v-hasPermi="['orderWorkbench:waybill:print']"
            type="text"
            size="mini"
            :disabled="!canPrint(row)"
            @click="handlePrint(row)"
          >打印</el-button>
          <el-tooltip :disabled="canShip(row)" :content="capTip(row, 'ship')" placement="top">
            <el-button
              v-hasPermi="['orderWorkbench:waybill:ship']"
              type="text"
              size="mini"
              :disabled="!canShip(row)"
              @click="handleShip(row)"
            >发货</el-button>
          </el-tooltip>
          <el-tooltip :disabled="canCancel(row)" :content="capTip(row, 'cancel')" placement="top">
            <el-button
              v-hasPermi="['orderWorkbench:waybill:cancel']"
              type="text"
              size="mini"
              :disabled="!canCancel(row)"
              @click="handleCancel(row)"
            >取消取号</el-button>
          </el-tooltip>
          <el-button
            v-hasPermi="['orderWorkbench:waybill:manualShip']"
            type="text"
            size="mini"
            :disabled="!canManualShip(row)"
            @click="openManualShip(row)"
          >手动发货</el-button>
          <el-button
            v-hasPermi="['orderWorkbench:waybill:return']"
            type="text"
            size="mini"
            class="danger-text"
            :disabled="!canReturn(row)"
            @click="openReturn(row)"
          >退回</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="pageQuery.pageNum"
      :limit.sync="pageQuery.pageSize"
      @pagination="getList"
    />

    <!-- 分配 / 改派弹窗 -->
    <el-dialog title="分配 / 改派面单账号" :visible.sync="distributeVisible" width="720px" append-to-body>
      <div class="dialog-tip">
        已选 {{ distributeOrders.length }} 单；店铺：{{ distributeShopName }}。
        选中账号即同时确定 发货主体 + 快递 + 网点；已取号/已打印的订单需先取消取号才能改派。
      </div>
      <el-empty
        v-if="!distributeGroups.length"
        description="该店铺暂无可用电子面单账号（请先在「发货 → 电子面单账号」维护；无绑定账号的发货主体只能走手动发货）"
      />
      <div v-for="g in distributeGroups" :key="g.key" class="account-option-group">
        <div class="group-title">{{ g.name }}</div>
        <el-radio-group v-model="selectedAccountId">
          <el-radio v-for="a in g.accounts" :key="a.id" :label="a.id" border class="account-radio">
            {{ accountLabel(a) }}
            <span class="sub-text">余额 {{ a.num == null ? '-' : a.num }}</span>
          </el-radio>
        </el-radio-group>
      </div>
      <span slot="footer">
        <el-button @click="distributeVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" :disabled="!selectedAccountId" @click="submitDistribute">
          确定分配
        </el-button>
      </span>
    </el-dialog>

    <!-- 退回异常池弹窗 -->
    <el-dialog title="整单退回异常池" :visible.sync="returnVisible" width="540px" append-to-body>
      <el-alert
        type="warning"
        :closable="false"
        show-icon
        title="退回将清空发货主体与面单账号，订单回到异常池重新分配或拆分；已取号请先取消取号，已打印/已发货不可退回。"
      />
      <el-form label-width="90px" size="small" style="margin-top: 16px">
        <el-form-item label="退回原因">
          <el-select v-model="returnTagId" placeholder="请选择异常分类标签" filterable style="width: 100%">
            <el-option v-for="t in reasonOptions" :key="t.id" :label="t.name" :value="t.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="退回订单">
          <span>{{ returnOrders.length }} 单（{{ returnOrders.map(o => o.orderNum).join('，') }}）</span>
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="returnVisible = false">取消</el-button>
        <el-button type="warning" :loading="submitting" :disabled="!returnTagId" @click="submitReturn">确认退回</el-button>
      </span>
    </el-dialog>

    <!-- 手动发货弹窗 -->
    <el-dialog title="手动发货" :visible.sync="manualShipVisible" width="540px" append-to-body>
      <el-alert
        type="info"
        :closable="false"
        show-icon
        title="手动发货为兜底通道：无面单账号或线下已寄出的订单，人工录入物流公司与快递单号后直接置为已发货；已取号/已打印请先取消取号。"
      />
      <el-form ref="manualShipForm" :model="manualShipForm" :rules="manualShipRules" label-width="90px" size="small" style="margin-top: 16px">
        <el-form-item label="订单号">
          <span>{{ manualShipOrder ? manualShipOrder.orderNum : '-' }}</span>
        </el-form-item>
        <el-form-item label="物流公司" prop="logisticsCompanyId">
          <el-select v-model="manualShipForm.logisticsCompanyId" filterable placeholder="请选择快递公司" style="width: 100%">
            <el-option v-for="c in logisticsOptions" :key="c.id" :label="c.name" :value="c.id">
              <span style="float: left">{{ c.name }}</span>
              <span style="float: right; color: #8492a6; font-size: 13px">{{ c.code || '' }}</span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="快递单号" prop="trackingNumber">
          <el-input v-model="manualShipForm.trackingNumber" placeholder="请输入快递单号" style="width: 100%" />
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="manualShipVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="submitManualShip">确认发货</el-button>
      </span>
    </el-dialog>

    <!-- 批量结果弹层 -->
    <el-dialog :title="resultTitle" :visible.sync="resultVisible" width="640px" append-to-body>
      <div class="result-summary">
        本次{{ resultAction }}：成功
        <span class="text-success">{{ resultData.successCount }}</span> 单，失败
        <span class="text-danger">{{ resultData.failCount }}</span> 单
      </div>
      <el-table :data="resultData.items || []" border size="mini" max-height="320">
        <el-table-column label="订单号" min-width="180">
          <template slot-scope="{ row }">{{ row.orderNum || ('发货单元#' + row.id) }}</template>
        </el-table-column>
        <el-table-column label="结果" width="70" align="center">
          <template slot-scope="{ row }">
            <el-tag size="mini" :type="row.success ? 'success' : 'danger'">{{ row.success ? '成功' : '失败' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="说明" min-width="240">
          <template slot-scope="{ row }">{{ row.msg || '-' }}</template>
        </el-table-column>
      </el-table>
      <span slot="footer">
        <el-button type="primary" @click="resultVisible = false">知道了</el-button>
      </span>
    </el-dialog>

    <!-- 详情抽屉 -->
    <el-drawer title="发货单元详情" :visible.sync="detailVisible" size="680px" append-to-body>
      <div v-if="detail" class="detail-panel">
        <el-descriptions :column="2" border size="small">
          <el-descriptions-item label="订单号">{{ detail.orderNum }}</el-descriptions-item>
          <el-descriptions-item label="店铺">{{ detail.shopName || '-' }}</el-descriptions-item>
          <el-descriptions-item label="平台">{{ detail.platformName || platformNameOf(detail.shopType) }}</el-descriptions-item>
          <el-descriptions-item label="订单角色">{{ detail.orderRoleName || '主订单' }}</el-descriptions-item>
          <el-descriptions-item label="发货主体">{{ detail.shipperName || detail.shipperTypeName || '-' }}</el-descriptions-item>
          <el-descriptions-item label="主体类型">{{ detail.shipperTypeName || '-' }}</el-descriptions-item>
          <el-descriptions-item label="面单账号">
            {{ detail.waybillAccountName || (detail.allocated ? '账号#' + detail.waybillAccountId : '未分配') }}
          </el-descriptions-item>
          <el-descriptions-item label="快递公司">{{ detail.waybillAccountCompany || detail.waybillCompany || '-' }}</el-descriptions-item>
          <el-descriptions-item label="取号状态">{{ detail.waybillStatusName }}</el-descriptions-item>
          <el-descriptions-item label="快递单号">{{ detail.waybillCode || '-' }}</el-descriptions-item>
          <el-descriptions-item label="收件人">{{ detail.receiverName }} {{ detail.receiverMobile }}</el-descriptions-item>
          <el-descriptions-item label="收货地址">{{ fullAddress(detail) }}</el-descriptions-item>
          <el-descriptions-item label="下单时间">{{ parseTime(detail.orderTime) }}</el-descriptions-item>
          <el-descriptions-item label="停留时长">{{ stayText(detail.stayHours) }}</el-descriptions-item>
          <el-descriptions-item label="金额">{{ detail.payment }}</el-descriptions-item>
          <el-descriptions-item label="平台标签">{{ detail.tag || '-' }}</el-descriptions-item>
          <el-descriptions-item label="买家留言" :span="2">{{ detail.buyerMemo || '-' }}</el-descriptions-item>
          <el-descriptions-item label="卖家备注" :span="2">{{ detail.sellerMemo || '-' }}</el-descriptions-item>
        </el-descriptions>
        <div class="detail-goods-title">商品明细</div>
        <el-table :data="detail.items || []" border size="small">
          <el-table-column label="图片" width="60">
            <template slot-scope="{ row }">
              <image-preview v-if="row.goodsImg" :src="row.goodsImg" :width="36" :height="36" />
            </template>
          </el-table-column>
          <el-table-column label="商品" prop="goodsTitle" min-width="160" :show-overflow-tooltip="true" />
          <el-table-column label="规格" prop="goodsSpec" width="110" />
          <el-table-column label="规格编码" prop="skuNum" width="120" />
          <el-table-column label="数量" prop="quantity" width="60" />
          <el-table-column label="发货状态" width="90">
            <template slot-scope="{ row }">
              <el-tag size="mini" :type="itemShipTagType(row.shipStatus)">{{ itemShipStatusName(row.shipStatus) }}</el-tag>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-drawer>
  </div>
</template>

<script>
import {
  pageWaybillOrders,
  getWaybillPoolCounts,
  getWaybillOrderDetail,
  getWaybillAccountOptions,
  distributeWaybill,
  returnWaybill,
  takeWaybill,
  cancelWaybill,
  printWaybill,
  shipWaybill,
  manualShipWaybill,
  getWaybillCapabilities,
  getWaybillReturnTagOptions
} from '@/api/shipping/waybillWorkbench'
import { getFavoriteList, getAvailableList } from '@/api/shipping/ship_logistics'
import { listShop, listPlatform } from '@/api/shop/shop'

const UNSUPPORTED_TIP = '开源版本不支持该电子面单功能，请用手动发货'

const EMPTY_QUERY = {
  orderNums: '',
  shopId: null,
  shopType: null,
  waybillStatus: null,
  waybillAccountId: null,
  shipperCategory: null,
  shipperType: null,
  receiverName: '',
  receiverMobile: '',
  goodsKeyword: '',
  sortField: '',
  sortOrder: 'descending',
  allocatePending: false
}

const EMPTY_COUNTS = { notTaken: 0, taken: 0, printed: 0, allocatePending: 0, total: 0 }

export default {
  name: 'WaybillWorkbench',
  data() {
    return {
      query: { ...EMPTY_QUERY },
      pageQuery: { pageNum: 1, pageSize: 50 },
      rows: [],
      total: 0,
      counts: { ...EMPTY_COUNTS },
      loading: false,
      submitting: false,
      selection: [],
      shopList: [],
      platformList: [],
      accountGroups: [],
      // 平台动作能力矩阵：key=shopType，value=capabilities 返回体
      capabilities: {},
      categoryChips: [
        { label: '店铺自用', value: 'self' },
        { label: '供应商', value: 'supplier' },
        { label: '云仓', value: 'cloud' }
      ],
      shipperTypeOptions: [
        { label: '本地发货（店铺自用）', value: 0 },
        { label: '京东云仓发货', value: 100 },
        { label: '吉客云云仓发货', value: 110 },
        { label: '系统云仓发货', value: 200 },
        { label: '供应商发货', value: 300 }
      ],
      distributeVisible: false,
      distributeOrders: [],
      distributeGroups: [],
      selectedAccountId: null,
      returnVisible: false,
      returnOrders: [],
      returnTagId: null,
      reasonOptions: [],
      manualShipVisible: false,
      manualShipOrder: null,
      logisticsOptions: [],
      manualShipForm: { logisticsCompanyId: null, trackingNumber: '' },
      manualShipRules: {
        logisticsCompanyId: [{ required: true, message: '请选择物流公司', trigger: 'change' }],
        trackingNumber: [{ required: true, message: '请输入快递单号', trigger: 'blur' }]
      },
      resultVisible: false,
      resultAction: '',
      resultData: {},
      detailVisible: false,
      detail: null
    }
  },
  computed: {
    distributeShopName() {
      if (!this.distributeOrders.length) return '-'
      const first = this.distributeOrders[0]
      return first.shopName || ('店铺#' + first.shopId)
    },
    /** 当前列表涉及的、开源版未接入面单适配器的平台提示（能力全 false 时引导手动发货） */
    unsupportedTip() {
      const names = []
      this.rows.forEach(row => {
        const cap = this.capOf(row.shopType)
        if (cap.loading || cap.supported) return
        const name = row.platformName || this.platformNameOf(row.shopType)
        if (name && names.indexOf(name) < 0) names.push(name)
      })
      if (!names.length) return ''
      return names.join('、') + '：' + UNSUPPORTED_TIP + '（取号/取消取号/发货回传不可用，已取号订单的「标记已打印」仅推进状态）'
    }
  },
  created() {
    this.loadShops()
    this.loadPlatforms()
    this.getList()
  },
  methods: {
    /** 查询参数：过滤空值，避免后端把空串当条件 */
    buildParams(withAllocatePending) {
      const params = {}
      Object.keys(this.query).forEach(key => {
        const value = this.query[key]
        if (value === null || value === undefined || value === '') return
        if (key === 'allocatePending' && value === false) return
        if (key === 'sortOrder' && !this.query.sortField) return
        params[key] = value
      })
      if (!withAllocatePending) delete params.allocatePending
      return params
    },
    getList() {
      this.loading = true
      const params = this.buildParams(true)
      params.pageNum = this.pageQuery.pageNum
      params.pageSize = this.pageQuery.pageSize
      pageWaybillOrders(params).then(res => {
        this.rows = res.rows || []
        this.total = res.total || 0
        this.loadCapabilities()
      }).catch(() => {
        this.rows = []
        this.total = 0
      }).finally(() => {
        this.loading = false
      })
      // 页签计数按当前筛选条件统计，且不随子视图（待补分配）收敛
      getWaybillPoolCounts(this.buildParams(false)).then(res => {
        this.counts = { ...EMPTY_COUNTS, ...(res.data || {}) }
      }).catch(() => {})
    },
    handleQuery() {
      this.pageQuery.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.query = { ...EMPTY_QUERY }
      this.accountGroups = []
      this.handleQuery()
    },
    handleViewChange() {
      this.pageQuery.pageNum = 1
      this.getList()
    },
    toggleSortOrder() {
      if (!this.query.sortField) {
        this.$message.info('请先选择排序字段')
        return
      }
      this.query.sortOrder = this.query.sortOrder === 'ascending' ? 'descending' : 'ascending'
      this.handleQuery()
    },
    loadShops() {
      listShop({}).then(res => {
        this.shopList = res.rows || []
      }).catch(() => {})
    },
    loadPlatforms() {
      listPlatform({ status: '0' }).then(res => {
        this.platformList = res.rows || []
      }).catch(() => {})
    },
    /** 选中店铺后加载该店铺面单账号，用于列表分组筛选 */
    onShopChange(shopId) {
      this.query.waybillAccountId = null
      this.accountGroups = []
      if (!shopId) {
        this.handleQuery()
        return
      }
      const shop = this.shopList.find(s => String(s.id) === String(shopId))
      if (shop) {
        this.query.shopType = shop.type
        this.loadAccountGroups(shop.id, shop.type).then(() => this.handleQuery())
      } else {
        this.handleQuery()
      }
    },
    loadAccountGroups(shopId, shopType) {
      if (shopId == null || shopType == null) return Promise.resolve()
      return getWaybillAccountOptions({ shopId, shopType }).then(res => {
        this.accountGroups = this.groupAccounts(res.data || [])
      }).catch(() => {
        this.accountGroups = []
      })
    },
    /** 面单账号按发货主体分组（本地发货 shipper_id=0 置顶） */
    groupAccounts(list) {
      const map = {}
      list.forEach(a => {
        const key = (a.shipperType == null ? 'none' : a.shipperType) + '#' + (a.shipperId || 0)
        if (!map[key]) {
          map[key] = {
            key,
            name: a.shipperName || a.providerName || this.shipperTypeLabel(a.shipperType),
            accounts: []
          }
        }
        map[key].accounts.push(a)
      })
      return Object.keys(map).map(k => map[k]).sort((a, b) => {
        if (a.key.indexOf('0#') === 0) return -1
        if (b.key.indexOf('0#') === 0) return 1
        return a.name.localeCompare(b.name)
      })
    },
    accountLabel(a) {
      return (a.refLogisticsName || a.waybillPlatformType || a.providerName || '-') + ' · ' + (a.name || a.code || ('账号#' + a.id))
    },
    selectAllGroup() {
      this.query.waybillAccountId = null
      this.query.shipperCategory = null
      this.handleQuery()
    },
    selectCategory(value) {
      this.query.waybillAccountId = null
      this.query.shipperCategory = this.query.shipperCategory === value ? null : value
      this.handleQuery()
    },
    selectAccount(account) {
      this.query.shipperCategory = null
      this.query.waybillAccountId = this.query.waybillAccountId === account.id ? null : account.id
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.selection = selection
    },
    /** 按当前页涉及平台加载动作能力，已加载平台不重复请求 */
    loadCapabilities() {
      const shopTypes = [...new Set(this.rows.map(r => r.shopType).filter(t => t != null))]
      shopTypes.forEach(shopType => {
        if (this.capabilities[shopType] !== undefined) return
        this.$set(this.capabilities, shopType, { loading: true })
        getWaybillCapabilities(shopType).then(res => {
          this.$set(this.capabilities, shopType, res.data || {})
        }).catch(() => {
          this.$set(this.capabilities, shopType, {})
        })
      })
    },
    capOf(shopType) {
      return this.capabilities[shopType] || {}
    },
    /** 按钮不可用时的原因提示：优先平台能力（开源版未接入 → 引导手动发货），其次单据状态 */
    capTip(row, action) {
      const cap = this.capOf(row.shopType)
      if (cap.loading) return '平台面单能力加载中，请稍候'
      if (!cap[action]) return cap.remark || UNSUPPORTED_TIP
      if (action === 'take') return row.allocated ? '该订单已取号/已打印，不能重复取号' : '请先分配面单账号'
      if (action === 'cancel') return '仅已取号未打印的订单可取消取号'
      if (action === 'ship') return row.waybillStatus !== 2 ? '仅已打印的订单可发货' : '缺少快递单号，无法发货'
      return ''
    },
    canTake(row) {
      const cap = this.capOf(row.shopType)
      return !!cap.take && !!row.allocated && row.waybillStatus === 0
    },
    canCancel(row) {
      const cap = this.capOf(row.shopType)
      return !!cap.cancel && row.waybillStatus === 1
    },
    /** 打印：后端仅推进 waybill_status 1→2，不调用平台，故不受平台能力限制 */
    canPrint(row) {
      return row.waybillStatus === 1
    },
    canShip(row) {
      const cap = this.capOf(row.shopType)
      return !!cap.ship && row.waybillStatus === 2 && !!row.waybillCode
    },
    canManualShip(row) {
      return row.waybillStatus === 0
    },
    canReturn(row) {
      return row.waybillStatus === 0
    },
    /** 目标单筛选：行内操作取当前行，工具条操作过滤选中单，不满足条件的跳过 */
    pickOrders(row, predicate, emptyMsg) {
      const source = row ? [row] : this.selection.slice()
      if (!source.length) {
        this.$message.warning('请先勾选订单')
        return []
      }
      const matched = source.filter(predicate)
      if (!matched.length) {
        this.$message.warning(emptyMsg)
        return []
      }
      if (matched.length < source.length) {
        this.$message.info(`已跳过不符合条件的 ${source.length - matched.length} 单，本次操作 ${matched.length} 单`)
      }
      return matched
    },
    handleTake(row) {
      const orders = this.pickOrders(row, o => this.canTake(o), `所选订单均不满足取号条件：需平台支持取号、已分配面单账号且未取号。${UNSUPPORTED_TIP}`)
      if (!orders.length) return
      this.runAfterConfirm(`将对 ${orders.length} 单按已分配的面单账号发起取号，取号成功回写快递单号（未取号→已取号），是否继续？`, '取号确认', takeWaybill, orders, '取号')
    },
    handleCancel(row) {
      const orders = this.pickOrders(row, o => this.canCancel(o), '所选订单均不能取消取号：需平台支持取消且处于已取号未打印')
      if (!orders.length) return
      this.runAfterConfirm(`将取消 ${orders.length} 单的平台快递单号并回到未取号（面单账号保留供重取沿用），是否继续？`, '取消取号确认', cancelWaybill, orders, '取消取号')
    },
    handlePrint(row) {
      const orders = this.pickOrders(row, o => this.canPrint(o), '所选订单均不满足打印条件：仅已取号未打印的订单可标记为已打印')
      if (!orders.length) return
      this.runAfterConfirm(`将把 ${orders.length} 单标记为已打印（已取号→已打印）。本页不连接本地打印组件，物理打印请使用各平台打单页。`, '打印确认', printWaybill, orders, '标记已打印')
    },
    handleShip(row) {
      const orders = this.pickOrders(row, o => this.canShip(o), `所选订单均不满足发货条件：需平台支持发货回传、已打印且有快递单号。${UNSUPPORTED_TIP}`)
      if (!orders.length) return
      this.runAfterConfirm(`将对 ${orders.length} 单回传平台并发货（已打印→已发货），发货后不可撤销，是否继续？`, '发货确认', shipWaybill, orders, '发货')
    },
    runAfterConfirm(message, title, api, orders, action) {
      this.$confirm(message, title, { type: 'warning' }).then(() => {
        this.submitAction(api, orders, action)
      }).catch(() => {})
    },
    submitAction(api, orders, action) {
      this.submitting = true
      return api({ orderIds: orders.map(o => o.id) }).then(res => {
        this.notifyResult(res.data, action)
        this.getList()
      }).catch(() => {}).finally(() => {
        this.submitting = false
      })
    },
    /** 分配 / 改派 */
    openDistribute(row) {
      const orders = row ? [row] : this.selection.slice()
      if (!orders.length) {
        this.$message.warning('请先勾选订单')
        return
      }
      const shopKeys = [...new Set(orders.map(o => o.shopId + '#' + o.shopType))]
      if (shopKeys.length > 1) {
        this.$message.warning('一次分配只能选择同一店铺的订单，请分店铺操作')
        return
      }
      const taken = orders.filter(o => o.waybillStatus !== 0)
      if (taken.length) {
        this.$message.warning('已取号/已打印的订单需先取消取号才能分配或改派')
        return
      }
      this.distributeOrders = orders
      this.selectedAccountId = null
      this.distributeGroups = []
      getWaybillAccountOptions({ shopId: orders[0].shopId, shopType: orders[0].shopType }).then(res => {
        this.distributeGroups = this.groupAccounts(res.data || [])
        const accountIds = [...new Set(orders.map(o => o.waybillAccountId).filter(Boolean))]
        const availableIds = this.distributeGroups.reduce((acc, g) => acc.concat(g.accounts.map(a => a.id)), [])
        if (accountIds.length === 1 && availableIds.indexOf(accountIds[0]) >= 0) {
          this.selectedAccountId = accountIds[0]
        } else if (availableIds.length === 1) {
          this.selectedAccountId = availableIds[0]
        }
        this.distributeVisible = true
      })
    },
    submitDistribute() {
      if (!this.selectedAccountId) {
        this.$message.warning('请选择面单账号')
        return
      }
      this.submitting = true
      distributeWaybill({
        orderIds: this.distributeOrders.map(o => o.id),
        waybillAccountId: this.selectedAccountId
      }).then(res => {
        this.notifyResult(res.data, '分配')
        this.distributeVisible = false
        this.getList()
      }).catch(() => {}).finally(() => {
        this.submitting = false
      })
    },
    /** 退回异常池（退回原因=异常池分类标签 bind_pool=2） */
    openReturn(row) {
      const orders = row ? [row] : this.selection.slice()
      if (!orders.length) {
        this.$message.warning('请先勾选订单')
        return
      }
      const matched = orders.filter(o => this.canReturn(o))
      if (!matched.length) {
        this.$message.warning('所选订单均不可退回：已取号请先取消取号，已打印/已发货不可退回')
        return
      }
      if (matched.length < orders.length) {
        this.$message.info(`已跳过不符合条件的 ${orders.length - matched.length} 单，本次退回 ${matched.length} 单`)
      }
      this.returnOrders = matched
      this.returnTagId = null
      getWaybillReturnTagOptions(2).then(res => {
        this.reasonOptions = res.data || []
        if (!this.reasonOptions.length) {
          this.$message.warning('暂无异常池分类标签，请先在订单审核工作台的标签管理中新建（关联异常池）')
          return
        }
        this.returnVisible = true
      })
    },
    submitReturn() {
      if (!this.returnTagId) {
        this.$message.warning('请选择退回原因')
        return
      }
      this.submitting = true
      returnWaybill({
        orderIds: this.returnOrders.map(o => o.id),
        tagId: this.returnTagId
      }).then(res => {
        this.notifyResult(res.data, '退回')
        this.returnVisible = false
        this.getList()
      }).catch(() => {}).finally(() => {
        this.submitting = false
      })
    },
    /** 手动发货（兜底通道：物流公司的 id 即 erp_logistics_company.id） */
    openManualShip(row) {
      if (!row) return
      if (!this.canManualShip(row)) {
        this.$message.warning('已取号/已打印的订单请先取消取号后再手动发货')
        return
      }
      this.manualShipOrder = row
      this.manualShipForm = { logisticsCompanyId: null, trackingNumber: '' }
      this.logisticsOptions = []
      getFavoriteList({ shopType: row.shopType, status: 1 }).then(res => {
        const favorites = (res.data || []).filter(f => String(f.shopType) === String(row.shopType))
          .map(f => ({ id: f.logisticsId, name: f.logisticsName, code: f.logisticsCode }))
        if (favorites.length) {
          this.logisticsOptions = favorites
          return null
        }
        // 该平台无常用快递时回落快递公司库
        return getAvailableList({ platformId: row.shopType }).then(resp => {
          this.logisticsOptions = (resp.data || []).map(c => ({ id: c.id, name: c.name, code: c.code }))
        })
      }).then(() => {
        this.manualShipVisible = true
        if (!this.logisticsOptions.length) {
          this.$message.warning('该平台没有可选的快递公司，请先在「发货 → 常用快递公司」中添加')
        }
        this.$nextTick(() => {
          if (this.$refs.manualShipForm) this.$refs.manualShipForm.clearValidate()
        })
      }).catch(() => {
        this.manualShipVisible = true
      })
    },
    submitManualShip() {
      this.$refs.manualShipForm.validate(valid => {
        if (!valid) return
        this.submitting = true
        manualShipWaybill({
          orderId: this.manualShipOrder.id,
          logisticsCompanyId: this.manualShipForm.logisticsCompanyId,
          trackingNumber: this.manualShipForm.trackingNumber
        }).then(res => {
          this.notifyResult(res.data, '手动发货')
          this.manualShipVisible = false
          this.getList()
        }).catch(() => {}).finally(() => {
          this.submitting = false
        })
      })
    },
    openDetail(row) {
      getWaybillOrderDetail(row.id).then(res => {
        this.detail = res.data
        this.detailVisible = true
      })
    },
    /** 逐单成败结果：有失败单弹层展示原因，全部成功仅提示 */
    notifyResult(data, action) {
      if (!data) {
        this.$message.success(action + '成功')
        return
      }
      if (data.failCount > 0) {
        this.resultAction = action
        this.resultData = data
        this.resultTitle = `${action}结果：成功 ${data.successCount} 单 / 失败 ${data.failCount} 单`
        this.resultVisible = true
        return
      }
      this.$message.success(`${action}成功 ${data.successCount} 单`)
    },
    platformNameOf(shopType) {
      if (shopType == null) return '-'
      const platform = this.platformList.find(p => String(p.id) === String(shopType))
      return platform ? platform.name : '平台#' + shopType
    },
    shipperTypeLabel(type) {
      const map = { 0: '店铺自用', 100: '京东云仓', 110: '吉客云云仓', 200: '系统云仓', 300: '供应商', 999: '其他' }
      return map[type] || '未绑定主体'
    },
    waybillTagType(status) {
      if (status === 1) return 'success'
      if (status === 2) return 'primary'
      if (status === 3 || status === 10) return 'info'
      return 'warning'
    },
    /** 明细行发货状态：0待发货 1已分配 10已取号 2已发货 */
    itemShipStatusName(status) {
      const map = { 0: '待发货', 1: '已分配', 2: '已发货', 3: '无需发货', 10: '已取号' }
      return map[status] || '待发货'
    },
    itemShipTagType(status) {
      if (status === 2) return 'success'
      if (status === 10) return 'warning'
      if (status === 1) return 'primary'
      return 'info'
    },
    fullAddress(row) {
      return [row.province, row.city, row.town, row.address].filter(item => !!item).join('')
    },
    stayText(hours) {
      if (hours == null) return '-'
      if (hours < 24) return hours + ' 小时'
      return Math.floor(hours / 24) + ' 天 ' + (hours % 24) + ' 小时'
    },
    stayClass(hours) {
      if (hours == null) return ''
      if (hours >= 48) return 'stay-over'
      if (hours >= 24) return 'stay-warn'
      return ''
    }
  }
}
</script>

<style scoped>
.view-bar {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 10px;
}
.pool-tip {
  color: #909399;
  font-size: 12px;
}
.waybill-workbench .filter-form {
  margin-bottom: 4px;
}
.account-group-bar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
  padding: 8px 10px;
  margin-bottom: 8px;
  background: #f7f8fa;
  border-radius: 4px;
}
.account-group-bar .bar-label {
  color: #606266;
  font-size: 13px;
}
.account-group-bar .el-tag {
  cursor: pointer;
}
.account-group {
  display: inline-flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 6px;
  margin-right: 12px;
}
.account-group .group-name {
  color: #909399;
  font-size: 12px;
}
.capability-alert {
  margin-bottom: 8px;
}
.toolbar {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 8px;
}
.selection-tip {
  color: #909399;
  font-size: 12px;
}
.order-num {
  color: #409eff;
  cursor: pointer;
}
.goods-line {
  display: flex;
  justify-content: space-between;
  gap: 8px;
}
.goods-title {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.sub-text {
  color: #909399;
  font-size: 12px;
}
.expand-panel {
  padding: 6px 12px 10px;
}
.expand-head {
  margin-bottom: 6px;
  color: #606266;
  font-size: 12px;
}
.expand-head .sub-text {
  margin-left: 12px;
}
.danger-text {
  color: #f56c6c;
}
.stay-warn {
  color: #e6a23c;
}
.stay-over {
  color: #f56c6c;
  font-weight: 600;
}
.dialog-tip {
  margin-bottom: 12px;
  color: #606266;
  font-size: 13px;
}
.account-option-group {
  margin-bottom: 14px;
}
.account-option-group .group-title {
  margin-bottom: 8px;
  font-weight: 600;
  color: #303133;
}
.account-radio {
  margin-bottom: 8px;
}
.result-summary {
  margin-bottom: 12px;
  font-size: 13px;
}
.text-success {
  color: #67c23a;
  font-weight: 600;
}
.text-danger {
  color: #f56c6c;
  font-weight: 600;
}
.detail-panel {
  padding: 0 16px 16px;
}
.detail-goods-title {
  margin: 16px 0 8px;
  font-weight: 600;
}
</style>
