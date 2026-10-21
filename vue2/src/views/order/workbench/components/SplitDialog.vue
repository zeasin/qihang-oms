<!--
  订单处理工作台 - 拆单弹窗（部分拆模型）
  交互：在商品行填入拆分数量 → 添加到待拆分（可反复多批次）→ 立即拆分统一生成子单；
  原单保留剩余，有剩余即可再次拆；发货主体后置到打单发货，弹窗内不选仓库/供应商
-->
<template>
  <el-dialog
    title="订单拆单"
    :visible.sync="visible"
    width="1150px"
    append-to-body
    :close-on-click-modal="false"
    @closed="resetData"
  >
    <div v-loading="loading">
      <div class="split-header">
        <span>订单号：<b>{{ preview ? preview.orderNum : '' }}</b></span>
        <span class="tip-text">请在需要拆分成新订单的商品行填入拆分数量，加入待拆明细后统一拆分；原单保留剩余</span>
      </div>

      <el-table :data="preview ? preview.items : []" size="mini" border max-height="380">
        <el-table-column label="商品" min-width="280">
          <template slot-scope="{row}">
            <div class="goods-cell">
              <el-image
                :src="row.goodsImg"
                style="width:42px;height:42px;flex-shrink:0;border-radius:4px"
                fit="cover">
                <div slot="error" class="img-fallback"><i class="el-icon-picture-outline"/></div>
              </el-image>
              <div class="goods-info">
                <div class="goods-title" :title="row.goodsTitle">{{ row.goodsTitle }}</div>
                <div class="goods-sub">{{ row.skuNum }}{{ row.goodsSpec ? ' / ' + row.goodsSpec : '' }}</div>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="quantity" label="数量" width="60" align="center"/>
        <el-table-column prop="refundCount" label="退款" width="60" align="center"/>
        <el-table-column label="可发货" width="65" align="center">
          <template slot-scope="{row}">{{ row.available }}</template>
        </el-table-column>
        <el-table-column label="已拆出" width="65" align="center">
          <template slot-scope="{row}">
            <span :class="{'red-text': row.splitOut > 0}">{{ row.splitOut }}</span>
          </template>
        </el-table-column>
        <el-table-column label="剩余可拆" width="80" align="center">
          <template slot-scope="{row}">
            <b :class="{'grey-text': remainOf(row) <= 0}">{{ remainOf(row) }}</b>
          </template>
        </el-table-column>
        <el-table-column label="本次拆分数量" width="115" align="center">
          <template slot-scope="{row}">
            <el-input-number
              v-model="splitQty[row.itemId]"
              :min="0"
              :max="remainOf(row)"
              size="mini"
              controls-position="right"
              style="width:92px"
              :disabled="remainOf(row) <= 0"/>
          </template>
        </el-table-column>
      </el-table>

      <div class="batch-actions">
        <el-button size="mini" type="primary" plain icon="el-icon-plus" @click="addToBatch">添加到待拆分</el-button>
        <span class="tip-text">可反复添加多个批次（每批生成一个子订单），最后一次性拆分</span>
      </div>

      <div class="batch-list" v-if="batches.length">
        <div class="batch-title">待拆明细（共 {{ batches.length }} 批，本次拆出 {{ batchTotal }} 件）</div>
        <div class="batch-item" v-for="(b, i) in batches" :key="i">
          <el-tag size="small" type="primary">批次{{ i + 1 }}</el-tag>
          <span class="batch-summary">{{ batchSummary(b) }}</span>
          <el-button size="mini" type="text" icon="el-icon-delete" class="danger-text" @click="batches.splice(i, 1)">删除</el-button>
        </div>
      </div>

      <div class="remain-tip-line" v-if="preview">
        合计：下单 {{ totalQuantity }} 件 / 可发货 {{ totalAvailable }} 件 / 已拆出 {{ totalSplitOut }} 件
      </div>
    </div>
    <div slot="footer">
      <el-button size="small" @click="visible = false">取 消</el-button>
      <el-button size="small" type="primary" :loading="submitting" :disabled="!batches.length" @click="doSubmit">立即拆分</el-button>
    </div>
  </el-dialog>
</template>

<script>
import { splitPreview, splitSubmit } from '@/api/order/workbench'

export default {
  name: 'SplitDialog',
  data() {
    return {
      visible: false,
      loading: false,
      submitting: false,
      orderId: null,
      preview: null,
      // 各商品行本次填写的拆分数量 {itemId: qty}
      splitQty: {},
      // 待拆明细批次 [{groupName, items:[{sourceOrderItemId, quantity, goodsTitle, skuNum}]}]
      batches: []
    }
  },
  computed: {
    totalQuantity() {
      return (this.preview ? this.preview.items : []).reduce((s, r) => s + (r.quantity || 0), 0)
    },
    totalAvailable() {
      return (this.preview ? this.preview.items : []).reduce((s, r) => s + (r.available || 0), 0)
    },
    totalSplitOut() {
      return (this.preview ? this.preview.items : []).reduce((s, r) => s + (r.splitOut || 0), 0)
    },
    batchTotal() {
      return this.batches.reduce((s, b) => s + b.items.reduce((x, it) => x + it.quantity, 0), 0)
    }
  },
  methods: {
    open(orderId) {
      this.orderId = orderId
      this.visible = true
      this.loading = true
      splitPreview(orderId).then(res => {
        this.preview = res.data
      }).finally(() => { this.loading = false })
    },
    // 行剩余可拆 = 可发货 - 已拆出 - 已加入待拆批次的数量
    remainOf(row) {
      return (row.available || 0) - (row.splitOut || 0) - this.batchUsed(row.itemId)
    },
    batchUsed(itemId) {
      let sum = 0
      this.batches.forEach(b => {
        b.items.forEach(it => {
          if (it.sourceOrderItemId === itemId) sum += it.quantity
        })
      })
      return sum
    },
    addToBatch() {
      if (!this.preview) return
      const items = this.preview.items
        .filter(r => this.splitQty[r.itemId] > 0)
        .map(r => ({
          sourceOrderItemId: r.itemId,
          quantity: this.splitQty[r.itemId],
          goodsTitle: r.goodsTitle,
          skuNum: r.skuNum
        }))
      if (!items.length) {
        this.$modal.msgError('请先在商品行填入拆分数量')
        return
      }
      this.batches.push({ groupName: '批次' + (this.batches.length + 1), items })
      this.splitQty = {}
    },
    batchSummary(b) {
      return b.items.map(it => `${it.skuNum || it.goodsTitle} × ${it.quantity}`).join('；')
    },
    doSubmit() {
      if (!this.batches.length) {
        this.$modal.msgError('请先添加待拆明细')
        return
      }
      const payload = {
        orderId: this.orderId,
        groups: this.batches.map(b => ({
          groupName: b.groupName,
          items: b.items.map(it => ({ sourceOrderItemId: it.sourceOrderItemId, quantity: it.quantity }))
        }))
      }
      this.submitting = true
      splitSubmit(payload).then(res => {
        if (res.code === 200) {
          this.$modal.msgSuccess(res.data || '拆单成功')
          this.visible = false
          this.$emit('success')
        } else {
          this.$modal.msgError(res.msg || '拆单失败')
        }
      }).catch(() => {}).finally(() => { this.submitting = false })
    },
    resetData() {
      this.orderId = null
      this.preview = null
      this.splitQty = {}
      this.batches = []
    }
  }
}
</script>

<style scoped>
.split-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 10px;
  font-size: 13px;
}
.tip-text {
  color: #909399;
  font-size: 12px;
}
.goods-cell {
  display: flex;
  align-items: center;
  gap: 8px;
}
.goods-info {
  min-width: 0;
}
.goods-title {
  font-size: 12px;
  line-height: 1.4;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 200px;
}
.goods-sub {
  font-size: 11px;
  color: #909399;
  margin-top: 2px;
}
.img-fallback {
  width: 42px;
  height: 42px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f7fa;
  color: #c0c4cc;
}
.red-text {
  color: #f56c6c;
  font-weight: bold;
}
.grey-text {
  color: #c0c4cc;
}
.batch-actions {
  margin: 10px 0;
  display: flex;
  align-items: center;
  gap: 10px;
}
.batch-list {
  border: 1px solid #ebeef5;
  border-radius: 4px;
  padding: 8px 12px;
  margin-bottom: 10px;
  background: #fafafa;
}
.batch-title {
  font-size: 12px;
  font-weight: bold;
  color: #606266;
  margin-bottom: 6px;
}
.batch-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 3px 0;
  font-size: 12px;
}
.batch-summary {
  flex: 1;
  color: #606266;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.danger-text {
  color: #f56c6c;
}
.remain-tip-line {
  font-size: 12px;
  color: #909399;
}
</style>
