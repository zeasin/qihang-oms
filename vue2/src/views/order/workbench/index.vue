<template>
  <div class="app-container workbench-page">
    <!-- 状态池页签 + 计数角标 -->
    <div class="pool-tabs">
      <div
        v-for="tab in poolTabs"
        :key="tab.key"
        class="pool-tab"
        :class="{ active: queryParams.pool === tab.key }"
        @click="switchPool(tab.key)"
      >
        <span class="tab-name">{{ tab.name }}</span>
        <span class="tab-count">{{ poolCountMap[tab.key] || 0 }}</span>
      </div>
      <span class="timeout-badge">
        即将超时 <b class="badge-warn">{{ timeoutBadge.aboutTimeout }}</b>
        · 已超时 <b class="badge-danger">{{ timeoutBadge.timeout }}</b>
      </span>
      <div class="tab-actions">
        <el-button size="mini" icon="el-icon-price-tag" @click="openTagManage">标签管理</el-button>
      </div>
    </div>

    <!-- 筛选区（对齐 OrderWorkbenchQuery，仅做后端支持字段） -->
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="70px" class="filter-form">
      <el-form-item label="订单号" prop="orderNums">
        <el-input v-model="queryParams.orderNums" placeholder="支持多单号，逗号/换行分隔" clearable style="width: 200px" @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="商户" prop="merchantId">
        <el-select v-model="queryParams.merchantId" filterable clearable placeholder="全部商户" style="width: 160px" @change="onMerchantChange">
          <el-option v-for="m in merchantList" :key="m.id" :label="m.name" :value="m.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="店铺" prop="shopIds">
        <el-select v-model="shopIdArr" multiple collapse-tags filterable placeholder="全部店铺" clearable style="width: 220px">
          <el-option v-for="s in filteredShopList" :key="s.id" :label="s.name" :value="s.id">
            <span>{{ s.name }}</span>
            <span class="option-merchant">{{ shopMerchantName(s) }}</span>
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="平台" prop="shopType">
        <el-select v-model="queryParams.shopType" placeholder="全部平台" clearable style="width: 130px">
          <el-option v-for="p in platformList" :key="p.id" :label="p.name" :value="p.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="收件人" prop="receiverName">
        <el-input v-model="queryParams.receiverName" placeholder="姓名" clearable style="width: 110px" />
      </el-form-item>
      <el-form-item label="手机号" prop="receiverMobile">
        <el-input v-model="queryParams.receiverMobile" placeholder="手机号" clearable style="width: 130px" />
      </el-form-item>
      <el-form-item label="商品" prop="goodsKeyword">
        <el-input v-model="queryParams.goodsKeyword" placeholder="商品名/编码" clearable style="width: 140px" />
      </el-form-item>
      <el-form-item label="订单模式">
        <el-select v-model="queryParams.orderMode" clearable placeholder="全部" style="width: 110px">
          <el-option label="店铺订单" :value="0" />
          <el-option label="手工订单" :value="1" />
        </el-select>
      </el-form-item>
      <!-- 状态筛选仅"全部"tab提供（其他池口径固定由页签决定） -->
      <el-form-item v-if="currentPool === 'all'" label="订单状态">
        <el-select v-model="queryParams.orderStatus" clearable placeholder="全部状态" style="width: 150px">
          <el-option v-for="s in orderStatusOptions" :key="s.value" :label="s.label" :value="s.value" />
        </el-select>
      </el-form-item>
      <el-form-item v-if="currentPool === 'all'" label="审核状态">
        <el-select v-model="queryParams.auditStatus" clearable placeholder="全部" style="width: 120px">
          <el-option label="待审核" :value="0" />
          <el-option label="已审核通过" :value="1" />
          <el-option label="已转异常" :value="2" />
          <el-option label="已拆单" :value="3" />
        </el-select>
      </el-form-item>
      <el-form-item label="买家留言" prop="buyerMemo">
        <el-input v-model="queryParams.buyerMemo" placeholder="关键字" clearable style="width: 120px" />
      </el-form-item>
      <el-form-item label="卖家备注" prop="sellerMemo">
        <el-input v-model="queryParams.sellerMemo" placeholder="关键字" clearable style="width: 120px" />
      </el-form-item>
      <el-form-item label="实付金额">
        <el-input v-model="queryParams.amountMin" placeholder="最低" clearable style="width: 80px" />
        <span class="range-sep">-</span>
        <el-input v-model="queryParams.amountMax" placeholder="最高" clearable style="width: 80px" />
      </el-form-item>
      <el-form-item label="下单时间">
        <el-date-picker
          v-model="orderTimeRange"
          type="daterange"
          value-format="yyyy-MM-dd"
          range-separator="-"
          start-placeholder="开始"
          end-placeholder="结束"
          style="width: 220px"
        />
      </el-form-item>
      <el-form-item label="超时预警">
        <el-radio-group v-model="queryParams.timeoutFilter" size="mini" @change="handleTimeoutChange">
          <el-radio-button label="">全部</el-radio-button>
          <el-radio-button label="soon">即将超时</el-radio-button>
          <el-radio-button label="timeout">已超时</el-radio-button>
        </el-radio-group>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" v-hasPermi="['orderWorkbench:order:list']" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 标签筛选行（独立平铺，单选点选即查）：异常池=bind_pool=2 分类（带计数+未分类），其他池=通用标签 -->
    <div v-if="currentPool === 'exception' ? exceptionTagNav.length : tagFilterList.length" class="tag-filter-row">
      <template v-if="currentPool === 'exception'">
        <el-tag
          v-for="t in exceptionTagNav"
          :key="'en' + t.tagId"
          size="small"
          class="pool-pill"
          :color="t.color"
          :effect="activeExceptionTagId === t.tagId ? 'dark' : 'plain'"
          :style="{ opacity: t.status === 1 ? 1 : 0.55 }"
          @click="toggleExceptionNav(t)"
        >{{ t.name }} {{ t.count }}</el-tag>
        <el-tag size="small" class="pool-pill uncategorized" type="info" effect="plain">未分类 {{ exceptionUncategorized }}</el-tag>
        <el-button type="text" size="mini" icon="el-icon-setting" class="tag-row-btn" @click="openExceptionTagManage">管理</el-button>
      </template>
      <template v-else>
        <el-tag
          v-for="t in tagFilterList"
          :key="'tf' + t.id"
          size="small"
          class="pool-pill"
          :effect="tagIdArr.includes(t.id) ? 'dark' : 'plain'"
          @click="toggleTag(t.id)"
        >{{ t.name }}</el-tag>
      </template>
    </div>

    <!-- 批量工具条 -->
    <div class="batch-bar">
      <span v-if="selectedOrders.length" class="selected-count">已选 {{ selectedOrders.length }} 条</span>
      <template v-if="currentPool === 'pending' || currentPool === 'exception'">
        <el-button size="mini" type="success" icon="el-icon-check" :disabled="!selectedOrders.length" @click="handleRelease">批量放行</el-button>
        <el-button size="mini" icon="el-icon-price-tag" :disabled="!selectedOrders.length" @click="openApplyTag(1)">批量打标</el-button>
        <el-button size="mini" icon="el-icon-delete" :disabled="!selectedOrders.length" @click="openApplyTag(0)">批量撤标</el-button>
        <el-button v-if="currentPool === 'pending'" size="mini" type="warning" :disabled="!selectedOrders.length" @click="handleException(2)">批量转异常</el-button>
        <el-button v-if="currentPool === 'exception'" size="mini" :disabled="!selectedOrders.length" @click="handleException(0)">批量转正常</el-button>
      </template>
      <template v-else-if="currentPool === 'released'">
        <el-button size="mini" type="warning" icon="el-icon-back" :disabled="!selectedOrders.length" @click="handleWithdraw">批量撤回异常</el-button>
      </template>
      <div class="batch-tip">
        <template v-if="currentPool === 'pending'">拆单入口在各订单行操作列；已拆分主单不可再拆，子单可继续拆单</template>
        <template v-else-if="currentPool === 'exception'">异常池处理区：转正常/放行/拆单/打标/改备注地址/取消订单均可在此完成</template>
        <template v-else-if="currentPool === 'released'">待发货订单（已放行未发完，发货单元平铺），可按行撤回到异常池重新处理</template>
        <template v-else-if="currentPool === 'shipped'">已发货订单（存在已完成发货单元，子单独立发货）；打印跟踪请到打单发货</template>
        <template v-else-if="currentPool === 'completed'">已完成订单（order_status=3，交易完成，由平台状态同步推进）；只读查询，不可再操作</template>
        <template v-else-if="currentPool === 'all'">全部订单（含已取消/已删除等所有状态，口径同旧订单库，可用上方"订单状态/审核状态"筛选）；批量处理请切回对应状态页签</template>
      </div>
    </div>

    <!-- 主子订单平铺表格（树形，行内展开子单） -->
    <el-table
      v-loading="loading"
      :data="orderRows"
      ref="poolTable"
      row-key="id"
      :tree-props="{ children: 'children' }"
      default-expand-all
      @selection-change="handleSelectionChange"
      @sort-change="handleSortChange"
      size="mini"
      border
    >
      <el-table-column type="selection" width="42" :reserve-selection="true" />
      <el-table-column type="index" label="序号" width="55" align="center" :index="rowIndex" />
      <el-table-column label="订单号" min-width="190">
        <template slot-scope="{ row }">
          <div class="order-num-row">
            <el-tag size="mini" :type="row.orderRole === 0 ? 'primary' : 'info'" effect="plain">
              {{ row.orderRole === 0 ? '主' : '子' }}
            </el-tag>
            <el-tag v-if="row.orderMode === 1" size="mini" type="info" effect="plain">手工</el-tag>
            <span class="order-num">{{ row.orderNum }}</span>
          </div>
          <div class="sub-text" v-if="row.orderRole === 0 && row.splitFlag"><el-tag size="mini" type="warning">已拆分</el-tag></div>
          <div class="sub-text" v-if="row.orderTime">{{ parseTime(row.orderTime, '{y}-{m}-{d} {h}:{i}') }} 下单</div>
          <div class="sub-text" v-if="canSplitRow(row)">
            <el-link type="primary" :underline="false" icon="el-icon-scissors" @click="openSplit(row)">拆单</el-link>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="商品" prop="goodsSummary" min-width="260" sortable="custom">
        <template slot-scope="{ row }">
          <div v-for="(it, idx) in row.items || []" :key="idx" class="goods-line" title="点击查看商品明细" @click="showItems(row)">
            <el-image :src="it.goodsImg" fit="cover" class="goods-thumb" lazy>
              <div slot="error" class="goods-thumb img-fallback"><i class="el-icon-picture-outline" /></div>
            </el-image>
            <div class="goods-line-info">
              <div class="goods-line-title">{{ it.goodsTitle }}</div>
              <div class="sub-text">{{ it.goodsSpec || '-' }} × {{ it.quantity || 0 }}</div>
            </div>
          </div>
          <div v-if="!(row.items && row.items.length)" class="sub-text">{{ row.goodsSummary || '无明细' }}</div>
        </template>
      </el-table-column>
      <el-table-column label="款/件" width="75" align="center">
        <template slot-scope="{ row }">{{ row.itemCount || 0 }}款 / {{ row.totalQuantity || 0 }}件</template>
      </el-table-column>
      <el-table-column label="款式编码" prop="skuNumText" min-width="130" show-overflow-tooltip sortable="custom">
        <template slot-scope="{ row }">{{ row.skuNumText || '-' }}</template>
      </el-table-column>
      <el-table-column label="商品编码" prop="goodsNumText" min-width="130" show-overflow-tooltip sortable="custom">
        <template slot-scope="{ row }">{{ row.goodsNumText || '-' }}</template>
      </el-table-column>
      <el-table-column label="店铺/平台" width="130" show-overflow-tooltip>
        <template slot-scope="{ row }">
          <div>{{ shopName(row.shopId) }}</div>
          <div class="sub-text">{{ platformName(row.shopType) }}</div>
        </template>
      </el-table-column>
      <el-table-column label="实付金额" prop="payment" width="90" align="right" sortable="custom">
        <template slot-scope="{ row }">
          <span v-if="row.orderRole !== 0" class="sub-text">—</span>
          <span v-else>{{ row.payment != null ? '¥' + row.payment : '-' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="收货人" min-width="150">
        <template slot-scope="{ row }">
          <div>{{ row.receiverName }} {{ row.receiverMobile }}</div>
          <div class="sub-text">{{ row.province }}{{ row.city }}{{ row.town }}</div>
        </template>
      </el-table-column>
      <el-table-column label="留言/备注" min-width="130" show-overflow-tooltip>
        <template slot-scope="{ row }">
          <div v-if="row.buyerMemo" class="buyer-memo">买：{{ row.buyerMemo }}</div>
          <div v-if="row.sellerMemo" class="seller-memo">卖：{{ row.sellerMemo }}</div>
          <div v-if="!row.buyerMemo && !row.sellerMemo" class="sub-text">-</div>
        </template>
      </el-table-column>
      <el-table-column label="审核状态" width="90" align="center">
        <template slot-scope="{ row }">
          <el-tag size="mini" :type="auditTagType(row.auditStatus)">{{ row.auditStatusName || auditStatusName(row.auditStatus) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="标签" min-width="120">
        <template slot-scope="{ row }">
          <el-tag
            v-for="t in rowTags(row)"
            :key="t.id"
            size="mini"
            effect="plain"
            class="tag-pill"
            :color="t.color"
          >{{ t.name }}</el-tag>
          <span v-if="!rowTags(row).length" class="sub-text">-</span>
        </template>
      </el-table-column>
      <el-table-column :label="flatPool ? '发货状态' : '放行就绪'" width="100" align="center">
        <template slot-scope="{ row }">
          <template v-if="flatPool">
            <el-tag v-if="row.shipStatus === 2" size="mini" type="success">全部发货</el-tag>
            <el-tag v-else-if="row.shipStatus === 1" size="mini" type="warning">部分发货</el-tag>
            <el-tag v-else-if="row.shipStatus === 10" size="mini" type="info">已取号</el-tag>
            <el-tag v-else-if="row.shipStatus === 3" size="mini" type="info">无需发货</el-tag>
            <el-tag v-else size="mini" type="info">未发货</el-tag>
          </template>
          <template v-else>
            <el-tooltip v-if="row.canReleaseMsg" :content="row.canReleaseMsg" placement="top">
              <el-tag size="mini" type="danger">未就绪</el-tag>
            </el-tooltip>
            <el-tooltip v-else-if="row.allocated === false" content="放行时选择面单账号后自动分配发货主体" placement="top">
              <el-tag size="mini" type="warning">待分配面单</el-tag>
            </el-tooltip>
            <el-tag v-else size="mini" type="success">就绪</el-tag>
          </template>
        </template>
      </el-table-column>
      <el-table-column v-if="currentPool === 'released'" label="取号状态" width="150" align="center">
        <template slot-scope="{ row }">
          <el-tag size="mini" :type="waybillTagType(row.waybillStatus)">{{ waybillStatusName(row.waybillStatus) }}</el-tag>
          <div v-if="row.waybillCode" class="waybill-line">
            <span v-if="row.waybillCompany" class="sub-text">{{ row.waybillCompany }}</span>
            <div class="waybill-code">{{ row.waybillCode }}</div>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="停留" width="96" align="center">
        <template slot-scope="{ row }"><span :class="stayClass(row)">{{ stayHours(row) }}</span></template>
      </el-table-column>
      <el-table-column label="操作" width="230" fixed="right" align="center">
        <template slot-scope="{ row }">
          <el-button size="mini" type="text" icon="el-icon-view" @click="openDetail(row)">详情</el-button>
          <el-button v-if="canReleaseRow(row)" size="mini" type="text" class="op-release" @click="handleReleaseOne(row)">放行</el-button>
          <el-button v-if="currentPool === 'released' && canWithdrawRow(row)" size="mini" type="text" class="op-withdraw" @click="handleWithdrawOne(row)">撤回异常</el-button>
          <el-dropdown v-if="isMasterActionable(row)" size="mini" @command="cmd => handleRowCommand(cmd, row)" style="margin-left: 6px">
            <span class="el-dropdown-link more-link">更多<i class="el-icon-arrow-down" /></span>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="memo">改卖家备注</el-dropdown-item>
              <el-dropdown-item command="address">改收货地址</el-dropdown-item>
              <el-dropdown-item command="cancel" divided>取消订单</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </el-table-column>
    </el-table>

    <div class="pagination-bar">
      <span v-if="selectedOrders.length" class="selected-count">已选 {{ selectedOrders.length }} 条</span>
      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="pageQuery.pageNum"
        :limit.sync="pageQuery.pageSize"
        @pagination="getList"
      />
    </div>

    <!-- 转异常弹窗（必选单选异常分类标签，覆盖式归属；分类平铺点选 + 弹窗内快捷新建） -->
    <el-dialog title="批量转异常" :visible.sync="exceptionVisible" width="480px" append-to-body>
      <div class="cancel-tip">
        将把选中的 {{ selectionCount }} 张订单转入异常池。必须选择一个异常分类（单选），订单将归属该分类并计入异常池导航计数。
      </div>
      <div class="exception-tag-wall">
        <span
          v-for="t in exceptionTagList"
          :key="t.id"
          class="exception-tag-pill"
          :class="{ active: exceptionTagId === t.id }"
          :style="exceptionTagId === t.id
            ? { background: t.color || '#409eff', borderColor: t.color || '#409eff', color: '#fff' }
            : { color: t.color || '#606266', borderColor: t.color || '#dcdfe6' }"
          @click="exceptionTagId = t.id"
        ><span class="pill-check"><i v-if="exceptionTagId === t.id" class="el-icon-check" /></span>{{ t.name }}</span>
        <span v-if="!exceptionTagList.length" class="sub-text">暂无异常池分类标签，在下方输入名称直接新建</span>
      </div>
      <div class="exception-tag-create">
        <el-button v-if="!creatingTag" type="text" icon="el-icon-plus" size="small" @click="openCreateTag('newTagInput')">新建分类</el-button>
        <template v-else>
          <el-input
            ref="newTagInput"
            v-model="newTagName"
            size="mini"
            maxlength="20"
            placeholder="分类名称（回车确认）"
            style="width: 180px"
            @keyup.enter.native="createExceptionTag"
          />
          <el-button size="mini" type="primary" :loading="creatingTagLoading" @click="createExceptionTag">确定</el-button>
          <el-button size="mini" @click="creatingTag = false">取消</el-button>
        </template>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button size="small" @click="exceptionVisible = false">取 消</el-button>
        <el-button size="small" type="primary" @click="doException(2)">确认转异常</el-button>
      </div>
    </el-dialog>

    <!-- 撤回异常弹窗（必选单选异常分类标签，覆盖式归属；已取号需先在打单发货页取消取号） -->
    <el-dialog title="撤回异常" :visible.sync="withdrawVisible" width="480px" append-to-body>
      <div class="cancel-tip">
        将把选中的 {{ withdrawIds.length }} 张订单退回异常池（仅当前所选订单，不联动主/子单）。必须选择一个异常分类（单选），撤回后归属该分类并计入异常池导航计数；已取号的订单请先在打单发货页取消取号，已打印/已发货不可撤回。
      </div>
      <div class="exception-tag-wall">
        <span
          v-for="t in exceptionTagList"
          :key="t.id"
          class="exception-tag-pill"
          :class="{ active: withdrawTagId === t.id }"
          :style="withdrawTagId === t.id
            ? { background: t.color || '#409eff', borderColor: t.color || '#409eff', color: '#fff' }
            : { color: t.color || '#606266', borderColor: t.color || '#dcdfe6' }"
          @click="withdrawTagId = t.id"
        ><span class="pill-check"><i v-if="withdrawTagId === t.id" class="el-icon-check" /></span>{{ t.name }}</span>
        <span v-if="!exceptionTagList.length" class="sub-text">暂无异常池分类标签，在下方输入名称直接新建</span>
      </div>
      <div class="exception-tag-create">
        <el-button v-if="!creatingTag" type="text" icon="el-icon-plus" size="small" @click="openCreateTag('newTagInputWithdraw')">新建分类</el-button>
        <template v-else>
          <el-input
            ref="newTagInputWithdraw"
            v-model="newTagName"
            size="mini"
            maxlength="20"
            placeholder="分类名称（回车确认）"
            style="width: 180px"
            @keyup.enter.native="createExceptionTag"
          />
          <el-button size="mini" type="primary" :loading="creatingTagLoading" @click="createExceptionTag">确定</el-button>
          <el-button size="mini" @click="creatingTag = false">取消</el-button>
        </template>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button size="small" @click="withdrawVisible = false">取 消</el-button>
        <el-button size="small" type="primary" @click="doWithdraw">确认撤回</el-button>
      </div>
    </el-dialog>

    <!-- 打标/撤标弹窗（标签平铺多选，打标支持弹窗内快捷新建，与转异常弹窗同构） -->
    <el-dialog :title="applyAction === 1 ? '批量打标' : '批量撤标'" :visible.sync="applyTagVisible" width="480px" append-to-body>
      <div class="cancel-tip">
        {{ applyAction === 1 ? '选择要打的标签（可多选），将追加到所选订单。' : '选择要撤除的标签（可多选）。' }}
      </div>
      <div class="exception-tag-wall">
        <span
          v-for="t in tagOptionsList"
          :key="t.id"
          class="exception-tag-pill"
          :class="{ active: applyTagIds.includes(t.id) }"
          :style="applyTagIds.includes(t.id)
            ? { background: t.color || '#409eff', borderColor: t.color || '#409eff', color: '#fff' }
            : { color: t.color || '#606266', borderColor: t.color || '#dcdfe6' }"
          @click="toggleApplyTag(t)"
        ><span class="pill-check"><i v-if="applyTagIds.includes(t.id)" class="el-icon-check" /></span>{{ t.name }}</span>
        <span v-if="!tagOptionsList.length" class="sub-text">暂无标签{{ applyAction === 1 ? '，在下方输入名称直接新建' : '' }}</span>
      </div>
      <div v-if="applyAction === 1" class="exception-tag-create">
        <el-button v-if="!creatingCommonTag" type="text" icon="el-icon-plus" size="small" @click="openCreateCommonTag">新建标签</el-button>
        <template v-else>
          <el-input
            ref="newCommonTagInput"
            v-model="newCommonTagName"
            size="mini"
            maxlength="20"
            placeholder="标签名称（回车确认）"
            style="width: 180px"
            @keyup.enter.native="createCommonTag"
          />
          <el-button size="mini" type="primary" :loading="creatingCommonTagLoading" @click="createCommonTag">确定</el-button>
          <el-button size="mini" @click="creatingCommonTag = false">取消</el-button>
        </template>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button size="small" @click="applyTagVisible = false">取 消</el-button>
        <el-button size="small" type="primary" @click="doApplyTag">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 改卖家备注弹窗 -->
    <el-dialog title="修改卖家备注" :visible.sync="memoVisible" width="420px" append-to-body>
      <el-input v-model="memoForm.sellerMemo" type="textarea" :rows="3" maxlength="500" show-word-limit placeholder="卖家备注内容" />
      <div slot="footer" class="dialog-footer">
        <el-button size="small" @click="memoVisible = false">取 消</el-button>
        <el-button size="small" type="primary" @click="doUpdateMemo">保 存</el-button>
      </div>
    </el-dialog>

    <!-- 改收货地址弹窗 -->
    <el-dialog title="修改收货地址" :visible.sync="addressVisible" width="500px" append-to-body>
      <el-form :model="addressForm" label-width="80px" size="small">
        <el-form-item label="收件人" required>
          <el-input v-model="addressForm.receiverName" />
        </el-form-item>
        <el-form-item label="手机号" required>
          <el-input v-model="addressForm.receiverMobile" />
        </el-form-item>
        <el-form-item label="省/市/区">
          <el-col :span="8"><el-input v-model="addressForm.province" placeholder="省" /></el-col>
          <el-col :span="8"><el-input v-model="addressForm.city" placeholder="市" /></el-col>
          <el-col :span="8"><el-input v-model="addressForm.town" placeholder="区/县" /></el-col>
        </el-form-item>
        <el-form-item label="详细地址" required>
          <el-input v-model="addressForm.address" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button size="small" @click="addressVisible = false">取 消</el-button>
        <el-button size="small" type="primary" @click="doUpdateAddress">保 存</el-button>
      </div>
    </el-dialog>

    <!-- 取消订单弹窗 -->
    <el-dialog title="取消订单" :visible.sync="cancelVisible" width="420px" append-to-body>
      <div class="cancel-tip">
        将取消主订单及其全部未取号子单（已取号未打印的面单自动取消取号），已打印/已发货的子单会阻止取消。
      </div>
      <el-input v-model="cancelReason" type="textarea" :rows="2" maxlength="200" placeholder="取消原因（选填）" />
      <div slot="footer" class="dialog-footer">
        <el-button size="small" @click="cancelVisible = false">取 消</el-button>
        <el-button size="small" type="danger" @click="doCancel">确认取消订单</el-button>
      </div>
    </el-dialog>

    <!-- 放行确认弹窗：按店铺分组选择面单账号 -->
    <el-dialog title="放行确认" :visible.sync="releaseVisible" width="720px" append-to-body :close-on-click-modal="false">
      <div class="release-summary">
        <span>本次放行 <b>{{ releaseIds.length }}</b> 张订单，涉及 <b>{{ releaseGroups.length }}</b> 个店铺</span>
        <span v-if="releaseUnreadyCount" class="release-warn-inline">其中 {{ releaseUnreadyCount }} 张未就绪，提交后跳过并返回原因</span>
      </div>
      <el-form size="small" label-width="70px" class="release-remark">
        <el-form-item label="放行备注">
          <el-input v-model="releaseRemark" placeholder="可选，随放行一并写入" maxlength="200" />
        </el-form-item>
      </el-form>
      <el-table :data="releaseGroups" size="mini" border v-loading="releaseOptionsLoading">
        <el-table-column label="店铺" min-width="130" show-overflow-tooltip>
          <template slot-scope="{ row }">{{ row.shopName }}</template>
        </el-table-column>
        <el-table-column label="订单数" width="70" align="center">
          <template slot-scope="{ row }">{{ row.orderCount }}</template>
        </el-table-column>
        <el-table-column label="面单账号（快递 + 网点）" min-width="320">
          <template slot-scope="{ row }">
            <el-select v-model="row.accountId" size="mini" filterable clearable placeholder="请选择面单账号" style="width: 100%">
              <el-option v-for="a in row.accounts" :key="a.id" :label="waybillAccountLabel(a)" :value="a.id" />
            </el-select>
            <div v-if="!row.accountsLoading && !row.accounts.length" class="release-warn">
              该店铺未绑定可用电子面单账号，请先到「电子面单账号」维护
            </div>
          </template>
        </el-table-column>
      </el-table>
      <div class="release-tip">
        同一店铺一次放行只使用一个面单账号；未选择账号的店铺将沿用订单已分配账号，仍无账号的订单会失败并留在池中。
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button size="small" @click="releaseVisible = false">取 消</el-button>
        <el-button size="small" type="primary" :loading="releaseSubmitting" @click="doRelease">确认放行</el-button>
      </div>
    </el-dialog>

    <!-- 详情抽屉（使用行内数据 + 内嵌子单，无独立详情接口） -->
    <el-drawer :visible.sync="detailVisible" title="订单详情" size="640px" append-to-body>
      <div class="detail-body" v-if="detailData && detailData.length">
        <div class="detail-block" v-for="node in detailData" :key="node.id">
          <div class="detail-title">
            <el-tag size="mini" :type="node.orderRole === 0 ? 'primary' : 'info'" effect="plain">
              {{ node.orderRole === 0 ? '主订单' : '子订单' }}
            </el-tag>
            <span style="margin-left: 8px">{{ node.orderNum }}</span>
          </div>
          <el-descriptions :column="2" size="small" border>
            <el-descriptions-item label="审核状态">{{ node.auditStatusName || auditStatusName(node.auditStatus) }}</el-descriptions-item>
            <el-descriptions-item label="发货状态">{{ shipStatusName(node.shipStatus) }}</el-descriptions-item>
            <el-descriptions-item label="店铺">{{ shopName(node.shopId) || '-' }}</el-descriptions-item>
            <el-descriptions-item label="平台">{{ platformName(node.shopType) }}</el-descriptions-item>
            <el-descriptions-item label="下单时间">{{ node.orderTime ? parseTime(node.orderTime, '{y}-{m}-{d} {h}:{i}:{s}') : '-' }}</el-descriptions-item>
            <el-descriptions-item label="停留时长">
              <span :class="stayClass(node)">{{ stayHours(node) }}</span>
            </el-descriptions-item>
            <el-descriptions-item label="收件人">{{ node.receiverName }} {{ node.receiverMobile }}</el-descriptions-item>
            <el-descriptions-item label="实付金额">{{ node.payment }}</el-descriptions-item>
            <el-descriptions-item label="收货地址" :span="2">{{ node.province }}{{ node.city }}{{ node.town }} {{ node.address }}</el-descriptions-item>
            <el-descriptions-item label="面单" :span="2">{{ node.waybillCompany || '-' }} {{ node.waybillCode || '' }}</el-descriptions-item>
            <el-descriptions-item v-if="node.tag" label="标签" :span="2">
              <el-tag v-for="t in rowTags(node)" :key="t.id" size="mini" effect="plain" class="tag-pill" :color="t.color">{{ t.name }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="买家留言" :span="2">{{ node.buyerMemo || '-' }}</el-descriptions-item>
            <el-descriptions-item label="卖家备注" :span="2">{{ node.sellerMemo || '-' }}</el-descriptions-item>
          </el-descriptions>
          <el-table :data="node.items || []" size="mini" border style="margin-top: 8px">
            <el-table-column label="商品" prop="goodsTitle" min-width="160" show-overflow-tooltip />
            <el-table-column label="规格" prop="goodsSpec" min-width="90" show-overflow-tooltip />
            <el-table-column label="款式编码" prop="skuNum" min-width="110" show-overflow-tooltip />
            <el-table-column label="数量" prop="quantity" width="60" align="center" />
          </el-table>
        </div>
      </div>
    </el-drawer>

    <!-- 商品明细弹窗（行内 items 展示） -->
    <el-dialog :visible.sync="itemsVisible" :title="`商品明细 - ${itemsOrderNum}`" width="760px" append-to-body>
      <el-table :data="itemsList" size="mini" border max-height="480">
        <el-table-column label="图片" width="70" align="center">
          <template slot-scope="{ row }">
            <el-image v-if="row.goodsImg" :src="row.goodsImg" :preview-src-list="[row.goodsImg]" fit="cover" style="width: 40px; height: 40px" />
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column label="商品名称" prop="goodsTitle" min-width="150" show-overflow-tooltip />
        <el-table-column label="规格" prop="goodsSpec" min-width="90" show-overflow-tooltip />
        <el-table-column label="款式编码" prop="skuNum" min-width="110" show-overflow-tooltip />
        <el-table-column label="商品编码" prop="goodsNum" min-width="110" show-overflow-tooltip />
        <el-table-column label="数量" prop="quantity" width="60" align="center" />
      </el-table>
    </el-dialog>

    <!-- 组件弹窗 -->
    <tag-manage-dialog ref="tagManage" @refresh="onTagDictChanged" />
    <split-dialog ref="splitDialog" @success="refresh" />
  </div>
</template>

<script>
import {
  poolPage, poolCounts, toException, releaseOrders, withdrawToException, cancelWorkOrder,
  updateOrderMemo, updateOrderAddress, waybillAccountOptions,
  tagOptions, applyTags, exceptionTagCounts, poolTagOptions, addTag
} from '@/api/order/workbench'
import { listShop, listPlatform } from '@/api/shop/shop'
import { listAllMerchant } from '@/api/shop/merchant'
import TagManageDialog from './components/TagManageDialog.vue'
import SplitDialog from './components/SplitDialog.vue'

/** 剩余时效不足该小时数按即将超时着色（与后端 ABOUT_TIMEOUT_WARN_HOURS 同口径） */
const REMAIN_WARN_HOURS = 12

export default {
  name: 'OrderWorkbench',
  components: { TagManageDialog, SplitDialog },
  data() {
    return {
      loading: false,
      // 状态池
      poolTabs: [
        { key: 'pending', name: '待审核' },
        { key: 'exception', name: '异常池' },
        { key: 'released', name: '待发货' },
        { key: 'shipped', name: '已发货' },
        { key: 'completed', name: '已完成' },
        { key: 'all', name: '全部' }
      ],
      // 全部tab订单状态筛选项（对齐 EnumOOrderStatus/o_order.order_status 注释）
      orderStatusOptions: [
        { value: 0, label: '新订单' },
        { value: 21, label: '待付款' },
        { value: 1, label: '待发货' },
        { value: 101, label: '部分发货' },
        { value: 2, label: '已发货' },
        { value: 3, label: '已完成' },
        { value: 11, label: '已取消' },
        { value: 12, label: '退款中' },
        { value: 13, label: '已关闭' },
        { value: 22, label: '锁定' },
        { value: 31, label: '售后中' },
        { value: 29, label: '已删除' }
      ],
      poolCountMap: {},
      // 查询
      queryParams: this.emptyQuery(),
      pageQuery: { pageNum: 1, pageSize: 50 },
      total: 0,
      orderRows: [],
      selectedOrders: [],
      // 下拉数据
      shopList: [],
      merchantList: [],
      platformList: [],
      tagOptionsList: [],
      tagIdArr: [],
      shopIdArr: [],
      orderTimeRange: [],
      // 弹窗状态
      applyTagVisible: false,
      applyAction: 1,
      applyTagIds: [],
      creatingCommonTag: false,
      newCommonTagName: '',
      creatingCommonTagLoading: false,
      memoVisible: false,
      memoForm: { orderId: null, sellerMemo: '' },
      addressVisible: false,
      addressForm: {},
      cancelVisible: false,
      cancelTarget: null,
      cancelReason: '',
      selectionCount: 0,
      // 放行确认（按店铺分组选面单账号）
      releaseVisible: false,
      releaseSubmitting: false,
      releaseOptionsLoading: false,
      releaseIds: [],
      releaseGroups: [],
      releaseUnreadyCount: 0,
      releaseRemark: '',
      // 转异常弹窗（必选分类标签）
      exceptionVisible: false,
      exceptionTagId: null,
      exceptionTagList: [],
      creatingTag: false,
      newTagName: '',
      creatingTagLoading: false,
      // 撤回异常弹窗（必选分类标签，覆盖写归属，口径同打单发货页退回）
      withdrawVisible: false,
      withdrawTagId: null,
      withdrawIds: [],
      // 异常池分类导航
      exceptionTagNav: [],
      exceptionUncategorized: 0,
      activeExceptionTagId: null,
      // 详情/商品明细（使用行内数据）
      detailVisible: false,
      detailData: null,
      itemsVisible: false,
      itemsList: [],
      itemsOrderNum: ''
    }
  },
  computed: {
    currentPool() {
      return this.queryParams.pool
    },
    // 发货单元平铺池（待发货/已发货/已完成/全部）
    flatPool() {
      return ['shipped', 'released', 'completed', 'all'].includes(this.queryParams.pool)
    },
    // 超时预警角标：poolCounts 返回的全量口径（不受 timeoutFilter 影响）
    timeoutBadge() {
      return {
        aboutTimeout: this.poolCountMap.aboutTimeout || 0,
        timeout: this.poolCountMap.timeout || 0
      }
    },
    // 非异常池标签筛选行：仅通用标签（bind_pool 空/0）
    tagFilterList() {
      return this.tagOptionsList.filter(t => !t.bindPool)
    },
    // 店铺下拉联动：选中商户后仅显示该商户的店铺
    filteredShopList() {
      if (!this.queryParams.merchantId) return this.shopList
      return this.shopList.filter(s => String(s.merchantId) === String(this.queryParams.merchantId))
    }
  },
  created() {
    this.getList()
    this.getCounts()
    this.loadShops()
    this.loadMerchants()
    this.loadPlatforms()
    this.loadTagOptions()
  },
  methods: {
    emptyQuery() {
      return {
        pool: 'pending',
        orderNums: '',
        shopType: null,
        orderMode: null,
        merchantId: null,
        orderStatus: null,
        auditStatus: null,
        receiverName: '',
        receiverMobile: '',
        goodsKeyword: '',
        buyerMemo: '',
        sellerMemo: '',
        amountMin: '',
        amountMax: '',
        orderTimeBegin: '',
        orderTimeEnd: '',
        shopIds: '',
        tagIds: '',
        sortField: '',
        sortOrder: '',
        timeoutFilter: ''
      }
    },
    // ---------- 数据加载 ----------
    buildQuery() {
      const q = { ...this.queryParams }
      q.shopIds = this.shopIdArr.length ? this.shopIdArr.join(',') : ''
      q.tagIds = this.tagIdArr.length ? this.tagIdArr.join(',') : ''
      if (this.orderTimeRange && this.orderTimeRange.length === 2) {
        q.orderTimeBegin = this.orderTimeRange[0]
        q.orderTimeEnd = this.orderTimeRange[1]
      } else {
        q.orderTimeBegin = ''
        q.orderTimeEnd = ''
      }
      return q
    },
    getList() {
      this.loading = true
      poolPage({ ...this.buildQuery(), pageNum: this.pageQuery.pageNum, pageSize: this.pageQuery.pageSize })
        .then(res => {
          this.orderRows = res.rows || []
          this.total = res.total || 0
        })
        .finally(() => { this.loading = false })
    },
    // 列头排序：白名单字段（goodsSummary/skuNumText/goodsNumText/payment），取消回默认下单时间倒序
    handleSortChange({ prop, order }) {
      this.queryParams.sortField = order ? prop : ''
      this.queryParams.sortOrder = order || ''
      this.pageQuery.pageNum = 1
      this.getList()
    },
    rowIndex(index) {
      return (this.pageQuery.pageNum - 1) * this.pageQuery.pageSize + index + 1
    },
    getCounts() {
      poolCounts(this.buildQuery()).then(res => {
        this.poolCountMap = res.data || {}
      })
    },
    loadShops() {
      listShop({}).then(res => {
        this.shopList = res.rows || res.data || []
      })
    },
    loadMerchants() {
      listAllMerchant({ pageNum: 1, pageSize: 100 }).then(res => {
        this.merchantList = res.data || res.rows || []
      })
    },
    onMerchantChange() {
      const allowed = this.filteredShopList.map(s => String(s.id))
      this.shopIdArr = this.shopIdArr.filter(id => allowed.includes(String(id)))
    },
    shopMerchantName(s) {
      if (s.merchantName) return s.merchantName
      const m = this.merchantList.find(x => String(x.id) === String(s.merchantId))
      return m ? m.name : ''
    },
    loadPlatforms() {
      listPlatform({}).then(res => {
        this.platformList = res.rows || res.data || []
      })
    },
    loadTagOptions(cb) {
      // 打标/撤标用启用标签（含通用与分类）；筛选行按 bindPool 分组使用
      tagOptions().then(res => {
        this.tagOptionsList = res.data || []
        if (typeof cb === 'function') cb()
      })
    },
    // ---------- 池/筛选 ----------
    switchPool(key) {
      this.queryParams.pool = key
      this.tagIdArr = []
      this.activeExceptionTagId = null
      this.pageQuery.pageNum = 1
      this.getList()
      this.getCounts()
      if (key !== 'all') {
        // 订单状态/审核状态筛选仅"全部"tab支持，切走时清掉避免误解
        this.queryParams.orderStatus = null
        this.queryParams.auditStatus = null
      }
      if (key === 'exception') this.loadExceptionNav()
    },
    handleQuery() {
      this.activeExceptionTagId = null
      this.pageQuery.pageNum = 1
      this.getList()
      this.getCounts()
    },
    // 超时预警筛选：时效数值由后端 sys_config 决定，前端只传 ''/soon/timeout
    handleTimeoutChange() {
      this.pageQuery.pageNum = 1
      this.getList()
      this.getCounts()
    },
    resetQuery() {
      this.queryParams = this.emptyQuery()
      this.$refs.poolTable && this.$refs.poolTable.clearSort()
      this.shopIdArr = []
      this.tagIdArr = []
      this.orderTimeRange = []
      this.activeExceptionTagId = null
      this.handleQuery()
    },
    // 标签筛选行点选（单选，点选即查；再点取消）
    toggleTag(id) {
      this.tagIdArr = this.tagIdArr[0] === id ? [] : [id]
      this.pageQuery.pageNum = 1
      this.getList()
    },
    // 异常池分类导航（分类 + 实时计数）
    loadExceptionNav() {
      exceptionTagCounts({ pool: 'exception' }).then(res => {
        if (res.code === 200 && res.data) {
          this.exceptionTagNav = res.data.tags || []
          this.exceptionUncategorized = res.data.uncategorized || 0
        }
      })
    },
    // 导航点击过滤当前异常池列表（再点取消）
    toggleExceptionNav(item) {
      this.activeExceptionTagId = this.activeExceptionTagId === item.tagId ? null : item.tagId
      this.tagIdArr = this.activeExceptionTagId ? [this.activeExceptionTagId] : []
      this.pageQuery.pageNum = 1
      this.getList()
    },
    openExceptionTagManage() {
      this.$refs.tagManage.open(2)
    },
    // ---------- 选择 ----------
    handleSelectionChange(rows) {
      this.selectedOrders = rows
    },
    // 权威源=表格实时 selection（reserve-selection 数据刷新后事件数组可能与视觉脱节，提交校验一律走这里）
    getTableSelection() {
      const table = this.$refs.poolTable
      const rows = (table && table.store && table.store.states.selection) || this.selectedOrders || []
      return rows
    },
    resolveSelectedRowIds() {
      return this.getTableSelection().map(r => r.id)
    },
    isMasterActionable(row) {
      return row.orderRole === 0 && row.shipStatus !== 2
    },
    // 拆单入口：主单/子单均可拆，已放行、单明细单件订单隐藏按钮
    canSplitRow(row) {
      if (row.auditStatus === 1) return false
      if (row.orderRole !== 0 && row.orderRole !== 1) return false
      if (row.itemCount === 1 && row.totalQuantity === 1) return false
      return true
    },
    canReleaseRow(row) {
      return row.auditStatus !== 1 && row.canRelease
    },
    handleRowCommand(cmd, row) {
      if (cmd === 'memo') this.openMemo(row)
      if (cmd === 'address') this.openAddress(row)
      if (cmd === 'cancel') this.openCancel(row)
    },
    // ---------- 商品明细弹窗（行内 items） ----------
    showItems(row) {
      this.itemsOrderNum = row.orderNum
      this.itemsList = row.items || []
      this.itemsVisible = true
    },
    // ---------- 批量放行 ----------
    handleRelease() {
      const rows = this.getTableSelection()
      if (!rows.length) {
        this.$modal.msgError('请先勾选订单')
        return
      }
      this.openReleaseDialog(rows)
    },
    handleReleaseOne(row) {
      this.openReleaseDialog([row])
    },
    // 放行粒度=发货单元：勾主单整单放行（覆盖其下子单）；只勾子单时按子单独立放行
    openReleaseDialog(rows) {
      const selectedMasterIds = new Set(rows.filter(r => !r.parentOrderId).map(r => r.id))
      const units = rows.filter(r => !(r.parentOrderId && selectedMasterIds.has(r.parentOrderId)))
      const seen = new Set()
      const groupMap = new Map()
      const releaseIds = []
      let unreadyCount = 0
      units.forEach(row => {
        if (seen.has(row.id)) return
        seen.add(row.id)
        releaseIds.push(row.id)
        if (row.canRelease === false) unreadyCount++
        const key = row.shopId + '#' + row.shopType
        let group = groupMap.get(key)
        if (!group) {
          group = {
            key,
            shopId: row.shopId,
            shopType: row.shopType,
            shopName: this.shopName(row.shopId),
            orderCount: 0,
            accountId: null,
            accounts: [],
            accountsLoading: true,
            preferredAccounts: []
          }
          groupMap.set(key, group)
        }
        group.orderCount++
        if (row.waybillAccountId) group.preferredAccounts.push(String(row.waybillAccountId))
      })
      this.releaseIds = releaseIds
      this.releaseGroups = Array.from(groupMap.values())
      this.releaseUnreadyCount = unreadyCount
      this.releaseRemark = ''
      this.releaseVisible = true
      const tasks = this.releaseGroups.map(g => {
        if (g.shopId == null || g.shopType == null) {
          g.accountsLoading = false
          return Promise.resolve()
        }
        return waybillAccountOptions({ shopId: g.shopId, shopType: g.shopType })
          .then(res => { g.accounts = (res && res.data) || [] })
          .catch(() => { g.accounts = [] })
          .finally(() => { g.accountsLoading = false })
      })
      this.releaseOptionsLoading = true
      Promise.all(tasks).then(() => {
        this.releaseGroups.forEach(g => this.applyDefaultReleaseAccount(g))
        this.releaseOptionsLoading = false
      })
    },
    // 默认账号优先级：本批订单已分配账号（唯一时）→ 唯一可选账号
    applyDefaultReleaseAccount(group) {
      const accounts = group.accounts || []
      if (!accounts.length) return
      const findById = id => accounts.find(a => String(a.id) === String(id))
      const preferred = Array.from(new Set(group.preferredAccounts || []))
      if (preferred.length === 1 && findById(preferred[0])) {
        group.accountId = findById(preferred[0]).id
        return
      }
      if (accounts.length === 1) group.accountId = accounts[0].id
    },
    doRelease() {
      const missing = this.releaseGroups.filter(g => g.accounts.length && !g.accountId)
      if (missing.length) {
        this.$modal.msgError('请为店铺「' + missing.map(g => g.shopName).join('、') + '」选择面单账号')
        return
      }
      const assignments = this.releaseGroups
        .filter(g => g.accountId)
        .map(g => ({ shopId: g.shopId, shopType: g.shopType, waybillAccountId: g.accountId }))
      this.releaseSubmitting = true
      releaseOrders({ ids: this.releaseIds, remark: this.releaseRemark || undefined, assignments }).then(res => {
        if (res.code === 200) {
          this.releaseVisible = false
          this.showActionResult(res.data, '放行')
          this.refresh()
        } else {
          this.$modal.msgError(res.msg || '批量放行失败')
        }
      }).finally(() => { this.releaseSubmitting = false })
    },
    // 逐单成败结果弹层（部分失败留池并展示原因；放行/撤回共用）
    showActionResult(data, action) {
      if (!data) return
      const fails = (data.items || []).filter(i => !i.success)
      if (fails.length === 0) {
        this.$modal.msgSuccess(`${action}成功 ${data.successCount} 单`)
        return
      }
      const h = this.$createElement
      const list = fails.map(f => h('div', { key: f.id }, `订单 ${f.orderNum || f.id}：${f.msg}`))
      this.$msgbox({
        title: `${action}结果：成功 ${data.successCount} 单，失败 ${data.failCount} 单`,
        message: h('div', null, list),
        confirmButtonText: '知道了'
      })
    },
    // ---------- 撤回异常（按当前行独立退回，必选异常分类标签） ----------
    canWithdrawRow(row) {
      return this.notShipped(row)
    },
    notShipped(row) {
      const shipped = s => s === 1 || s === 2
      const printed = w => w === 2 || w === 3 || w === 10
      return !shipped(row.shipStatus) && !printed(row.waybillStatus)
    },
    openWithdrawDialog(ids) {
      this.withdrawIds = ids
      if (!this.exceptionTagList.length) this.loadExceptionTags()
      this.withdrawTagId = null
      this.creatingTag = false
      this.withdrawVisible = true
    },
    doWithdraw() {
      if (!this.withdrawTagId) {
        this.$modal.msgError('请选择异常分类标签')
        return
      }
      withdrawToException({ orderIds: this.withdrawIds, tagId: this.withdrawTagId }).then(res => {
        if (res.code === 200) {
          this.withdrawVisible = false
          this.showActionResult(res.data, '撤回')
          this.refresh()
        } else {
          this.$modal.msgError(res.msg || '撤回失败')
        }
      })
    },
    handleWithdraw() {
      const ids = this.resolveSelectedRowIds()
      if (!ids.length) {
        this.$modal.msgError('请先勾选订单')
        return
      }
      this.openWithdrawDialog(ids)
    },
    handleWithdrawOne(row) {
      this.openWithdrawDialog([row.id])
    },
    // ---------- 转异常/转正常 ----------
    handleException(target) {
      const sel = this.getTableSelection()
      if (!sel.length) {
        this.$modal.msgError('请先勾选订单')
        return
      }
      this.selectionCount = sel.length
      if (target === 2) {
        if (!this.exceptionTagList.length) this.loadExceptionTags()
        this.exceptionTagId = null
        this.creatingTag = false
        this.newTagName = ''
        this.exceptionVisible = true
        return
      }
      this.$confirm(`确认将选中 ${sel.length} 张订单转正常？转正常不自动清除分类标签`, '转正常', { type: 'warning' })
        .then(() => this.doException(0))
        .catch(() => {})
    },
    doException(target) {
      const ids = this.resolveSelectedRowIds()
      if (!ids.length) {
        this.$modal.msgError('请先勾选订单')
        return
      }
      const data = { orderIds: ids, target }
      if (target === 2) {
        if (!this.exceptionTagId) {
          this.$modal.msgError('请选择异常分类标签')
          return
        }
        data.tagId = this.exceptionTagId
      }
      const action = target === 2 ? '转异常' : '转正常'
      toException(data).then(res => {
        if (res.code === 200) {
          this.$modal.msgSuccess(res.data || action + '成功')
          this.exceptionVisible = false
          this.refresh()
        } else {
          this.$modal.msgError(res.msg || (action + '失败'))
        }
      })
    },
    // 转异常弹窗分类选项（bind_pool=2 启用标签，全系统共用）
    loadExceptionTags(cb) {
      poolTagOptions(2).then(res => {
        if (res.code === 200) this.exceptionTagList = res.data || []
        if (cb) cb()
      })
    },
    // 弹窗内快捷新建异常池分类（bind_pool=2；成功后自动选中当前打开弹窗的标签项）
    openCreateTag(refName) {
      this.creatingTag = true
      this.newTagName = ''
      this.$nextTick(() => {
        if (refName && this.$refs[refName]) this.$refs[refName].focus()
      })
    },
    createExceptionTag() {
      const name = (this.newTagName || '').trim()
      if (!name) {
        this.$modal.msgError('请输入分类名称')
        return
      }
      this.creatingTagLoading = true
      addTag({ name, color: '#409eff', sort: 0, status: 1, bindPool: 2 }).then(res => {
        if (res.code === 200) {
          this.$modal.msgSuccess('分类「' + name + '」已创建')
          this.creatingTag = false
          this.newTagName = ''
          this.loadExceptionTags(() => {
            if (!res.data) return
            if (this.withdrawVisible) this.withdrawTagId = res.data
            else this.exceptionTagId = res.data
          })
        }
      }).finally(() => { this.creatingTagLoading = false })
    },
    // ---------- 打标/撤标 ----------
    openApplyTag(action) {
      const sel = this.getTableSelection()
      if (!sel.length) {
        this.$modal.msgError('请先勾选订单')
        return
      }
      this.selectionCount = sel.length
      this.applyAction = action
      this.applyTagIds = this.presetApplyTags(action)
      this.creatingCommonTag = false
      this.newCommonTagName = ''
      this.applyTagVisible = true
    },
    // 打标=选中订单共有标签交集；撤标=并集；仅限通用标签选项内
    presetApplyTags(action) {
      const valid = new Set(this.tagFilterList.map(t => String(t.id)))
      const sets = this.getTableSelection()
        .map(r => (r.tag || '').split(',').map(s => s.trim()).filter(Boolean))
      if (!sets.length) return []
      if (action === 1) {
        return sets[0].filter(id => valid.has(id) && sets.every(set => set.includes(id))).map(Number)
      }
      return [...new Set([].concat(...sets))].filter(id => valid.has(id)).map(Number)
    },
    toggleApplyTag(t) {
      const i = this.applyTagIds.indexOf(t.id)
      if (i >= 0) this.applyTagIds.splice(i, 1)
      else this.applyTagIds.push(t.id)
    },
    openCreateCommonTag() {
      this.creatingCommonTag = true
      this.newCommonTagName = ''
      this.$nextTick(() => {
        if (this.$refs.newCommonTagInput) this.$refs.newCommonTagInput.focus()
      })
    },
    // 弹窗内快捷新建通用标签（bind_pool=0），成功后自动勾选
    createCommonTag() {
      const name = (this.newCommonTagName || '').trim()
      if (!name) {
        this.$modal.msgError('请输入标签名称')
        return
      }
      this.creatingCommonTagLoading = true
      addTag({ name, color: '#409eff', sort: 0, status: 1, bindPool: 0 }).then(res => {
        if (res.code === 200) {
          this.$modal.msgSuccess('标签「' + name + '」已创建')
          this.creatingCommonTag = false
          this.newCommonTagName = ''
          this.loadTagOptions(() => {
            if (res.data && this.applyTagIds.indexOf(res.data) < 0) this.applyTagIds.push(res.data)
          })
        }
      }).finally(() => { this.creatingCommonTagLoading = false })
    },
    doApplyTag() {
      if (!this.applyTagIds.length) {
        this.$modal.msgError('请选择标签')
        return
      }
      applyTags({
        action: this.applyAction,
        orderIds: Array.from(new Set(this.getTableSelection().map(r => String(r.parentOrderId || r.id)))),
        tagIds: this.applyTagIds
      }).then(res => {
        if (res.code === 200) {
          this.$modal.msgSuccess(res.data || '操作成功')
          this.applyTagVisible = false
          this.refresh()
        } else {
          this.$modal.msgError(res.msg || '操作失败')
        }
      })
    },
    // ---------- 拆单 ----------
    openSplit(row) {
      if (!row || (row.orderRole !== 0 && row.orderRole !== 1)) return
      if (row.itemCount === 1 && row.totalQuantity === 1) {
        this.$modal.msgError('该订单仅 1 条明细且商品数量只有 1 件，不允许拆单')
        return
      }
      this.$refs.splitDialog.open(row.id)
    },
    // ---------- 备注/地址/取消 ----------
    openMemo(row) {
      this.memoForm = { orderId: row.id, sellerMemo: row.sellerMemo || '' }
      this.memoVisible = true
    },
    doUpdateMemo() {
      updateOrderMemo(this.memoForm).then(res => {
        if (res.code === 200) {
          this.$modal.msgSuccess('卖家备注已保存')
          this.memoVisible = false
          this.refresh()
        } else {
          this.$modal.msgError(res.msg || '保存失败')
        }
      })
    },
    openAddress(row) {
      this.addressForm = {
        orderId: row.id,
        receiverName: row.receiverName,
        receiverMobile: row.receiverMobile,
        province: row.province,
        city: row.city,
        town: row.town,
        address: row.address
      }
      this.addressVisible = true
    },
    doUpdateAddress() {
      const f = this.addressForm
      if (!f.receiverName || !f.receiverMobile || !f.address) {
        this.$modal.msgError('收件人、手机号、详细地址不能为空')
        return
      }
      updateOrderAddress(f).then(res => {
        if (res.code === 200) {
          this.$modal.msgSuccess('收货地址已保存')
          this.addressVisible = false
          this.refresh()
        } else {
          this.$modal.msgError(res.msg || '保存失败')
        }
      })
    },
    openCancel(row) {
      this.cancelTarget = row
      this.cancelReason = ''
      this.cancelVisible = true
    },
    doCancel() {
      cancelWorkOrder({ orderId: this.cancelTarget.id, reason: this.cancelReason }).then(res => {
        if (res.code === 200) {
          this.$modal.msgSuccess('订单已取消')
          this.cancelVisible = false
          this.refresh()
        } else {
          this.$modal.msgError(res.msg || '取消失败')
        }
      })
    },
    // ---------- 详情（行内数据 + 内嵌子单） ----------
    openDetail(row) {
      const nodes = [row]
      ;(row.children || []).forEach(c => nodes.push(c))
      this.detailData = nodes
      this.detailVisible = true
    },
    // ---------- 工具 ----------
    refresh() {
      this.getList()
      this.getCounts()
      if (this.currentPool === 'exception') this.loadExceptionNav()
      this.$nextTick(() => {
        if (this.$refs.poolTable) this.$refs.poolTable.clearSelection()
      })
    },
    openTagManage() {
      this.$refs.tagManage.open()
    },
    // 标签字典变更后刷新标签选项与异常池分类数据
    onTagDictChanged() {
      this.loadTagOptions()
      this.loadExceptionTags()
      if (this.currentPool === 'exception') this.loadExceptionNav()
    },
    shopName(shopId) {
      const s = this.shopList.find(x => String(x.id) === String(shopId))
      return s ? s.name : (shopId || '-')
    },
    platformName(shopType) {
      const p = this.platformList.find(x => String(x.id) === String(shopType))
      return p ? p.name : '-'
    },
    rowTags(row) {
      if (!row.tag) return []
      return row.tag.split(',').map(id => this.tagOptionsList.find(t => String(t.id) === String(id))).filter(Boolean)
    },
    waybillAccountLabel(a) {
      const express = a.refLogisticsName || a.name || a.code || ('账号#' + a.id)
      const branch = a.branchName && a.branchName !== express ? ' / ' + a.branchName : ''
      const balance = a.num != null ? '（余' + a.num + '）' : ''
      return express + branch + balance
    },
    // 取号状态（对齐 EnumWaybillStatus：0未取号 1已取号 2已打印 3已发货 10手动发货）
    waybillStatusName(status) {
      const map = { 0: '未取号', 1: '已取号', 2: '已打印', 3: '已发货', 10: '手动发货' }
      return map[status] || '未取号'
    },
    waybillTagType(status) {
      const map = { 1: 'warning', 2: 'primary', 3: 'success' }
      return map[status] || 'info'
    },
    // 审核状态（对齐 EnumAuditStatus：0待审核 1已审核通过 2已转异常 3已拆单）
    auditStatusName(status) {
      const map = { 0: '待审核', 1: '已审核通过', 2: '已转异常', 3: '已拆单' }
      return map[status] || '-'
    },
    auditTagType(status) {
      const map = { 0: 'info', 1: 'success', 2: 'danger', 3: 'warning' }
      return map[status] || 'info'
    },
    // 发货状态（对齐 EnumShipStatus：0未发货 1部分发货 2全部发货 3无需发货 10已取号）
    shipStatusName(status) {
      const map = { 0: '未发货', 1: '部分发货', 2: '全部发货', 3: '无需发货', 10: '已取号' }
      return map[status] != null ? map[status] : '-'
    },
    // 停留小时数（orderTime 距今，行无 remainHours 时兜底）
    stayHourNum(orderTime) {
      if (!orderTime) return null
      const t = new Date(String(orderTime).replace(/-/g, '/')).getTime()
      if (isNaN(t)) return null
      return Math.floor((Date.now() - t) / 3600000)
    },
    // 停留文案：优先后端剩余时效小时（负=已超时），无该字段时按下单时间距今
    stayHours(row) {
      const remain = row ? row.remainHours : null
      if (remain != null) {
        return remain < 0 ? '超时' + Math.abs(remain) + '时' : '剩余' + remain + '时'
      }
      const hours = this.stayHourNum(row ? row.orderTime : null)
      if (hours == null) return '-'
      if (hours < 24) return hours + '时'
      return Math.floor(hours / 24) + '天' + (hours % 24) + '时'
    },
    // 停留着色：已超时红 / 剩余 0~12 小时橙黄 / 其余灰，无时效数据沿用原停留分级
    stayClass(row) {
      const remain = row ? row.remainHours : null
      if (remain != null) {
        if (remain < 0) return 'remain-over'
        if (remain <= REMAIN_WARN_HOURS) return 'remain-warn'
        return 'remain-normal'
      }
      const hours = this.stayHourNum(row ? row.orderTime : null)
      if (hours == null) return ''
      if (hours >= 48) return 'stay-over'
      if (hours >= 24) return 'stay-warn'
      return ''
    }
  }
}
</script>

<style scoped>
.tag-pill { margin: 1px 3px 1px 0; border: none; }
.option-merchant { float: right; color: #8492a6; font-size: 12px; margin-left: 12px; }
.stay-warn { color: #e6a23c; font-weight: 600; }
.stay-over { color: #f56c6c; font-weight: 600; }
.goods-line { display: flex; align-items: flex-start; padding: 2px 0; cursor: pointer; border-radius: 4px; }
.goods-line:hover { background: rgba(24, 144, 255, 0.05); }
.goods-line-info { flex: 1; min-width: 0; }
.goods-line-title { line-height: 1.4; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
.goods-thumb { width: 28px; height: 28px; border-radius: 4px; margin-right: 6px; vertical-align: middle; flex-shrink: 0; }
.img-fallback { display: flex; align-items: center; justify-content: center; background: #f5f7fa; color: #c0c4cc; }
.pool-tabs { display: flex; align-items: center; margin-bottom: 10px; gap: 4px; }
.pool-tab { display: inline-flex; align-items: center; padding: 6px 14px; border-radius: 4px; cursor: pointer; background: #f4f4f5; margin-right: 8px; user-select: none; }
.pool-tab .tab-name { margin-right: 6px; }
.pool-tab .tab-count { background: #909399; color: #fff; border-radius: 8px; padding: 0 7px; font-size: 12px; line-height: 16px; }
.pool-tab.active { background: #1890ff; color: #fff; }
.pool-tab.active .tab-count { background: rgba(255,255,255,.3); }
.tab-actions { margin-left: auto; }
.tag-filter-row { display: flex; flex-wrap: wrap; align-items: center; padding: 6px 0 2px; }
.tag-filter-row .pool-pill { margin-right: 8px; border: none; color: #fff; }
.tag-filter-row .uncategorized { color: #606266; background: #f4f4f5; }
.tag-row-btn { padding: 0; margin-left: 4px; }
.exception-tag-wall { display: flex; flex-wrap: wrap; gap: 8px; margin: 12px 0 4px; }
.exception-tag-pill { display: inline-block; padding: 4px 12px; border: 1px solid #dcdfe6; border-radius: 4px; font-size: 12px; line-height: 18px; cursor: pointer; user-select: none; }
.exception-tag-pill:hover { opacity: 0.85; }
.exception-tag-pill .pill-check { display: inline-block; width: 13px; height: 13px; border: 1px solid currentColor; border-radius: 2px; margin-right: 5px; vertical-align: -2px; text-align: center; line-height: 12px; font-size: 10px; }
.exception-tag-pill.active .pill-check { border-color: #fff; color: #fff; }
.exception-tag-create { margin-top: 10px; min-height: 28px; }
.batch-bar { display: flex; align-items: center; margin-bottom: 8px; flex-wrap: wrap; }
.batch-tip { color: #909399; font-size: 12px; margin-left: 12px; }
.order-num-row { display: flex; align-items: center; }
.order-num { margin-left: 4px; }
.sub-text { color: #909399; font-size: 12px; }
.waybill-line { margin-top: 3px; line-height: 1.4; }
.waybill-code { color: #303133; font-size: 12px; word-break: break-all; }
.buyer-memo { color: #e6a23c; font-size: 12px; }
.seller-memo { color: #409eff; font-size: 12px; }
.more-link { font-size: 12px; color: #409eff; }
.cancel-tip { color: #909399; font-size: 12px; margin-bottom: 10px; line-height: 1.5; }
.detail-body { padding: 0 16px; }
.detail-block { margin-bottom: 16px; }
.detail-title { margin-bottom: 6px; font-weight: bold; }
.op-release { color: #67c23a; font-weight: bold; }
.op-withdraw { color: #e6a23c; font-weight: bold; }
.range-sep { padding: 0 4px; }
.release-summary { display: flex; align-items: center; justify-content: space-between; margin-bottom: 6px; font-size: 13px; }
.release-remark { margin-bottom: 6px; }
.release-warn-inline { color: #e6a23c; font-size: 12px; }
.release-warn { color: #f56c6c; font-size: 12px; line-height: 1.5; margin-top: 4px; }
.release-tip { color: #909399; font-size: 12px; line-height: 1.6; margin-top: 10px; }
.selected-count { color: #409eff; font-size: 12px; font-weight: 600; margin-right: 12px; white-space: nowrap; }
.pagination-bar { display: flex; align-items: center; }
.pagination-bar .pagination-container { flex: 1; }
.timeout-badge { color: #909399; font-size: 12px; margin-left: auto; margin-right: 10px; white-space: nowrap; }
.timeout-badge b { font-weight: 600; }
.badge-warn { color: #e6a23c; }
.badge-danger { color: #f56c6c; }
.timeout-badge + .tab-actions { margin-left: 0; }
.remain-warn { color: #e6a23c; font-weight: 600; }
.remain-over { color: #f56c6c; font-weight: 600; }
.remain-normal { color: #909399; }
</style>
