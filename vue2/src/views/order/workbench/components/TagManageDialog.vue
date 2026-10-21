<template>
  <el-dialog title="标签管理" :visible.sync="visible" width="640px" append-to-body>
    <div class="toolbar">
      <el-button size="mini" type="primary" icon="el-icon-plus" @click="openAdd">新增标签</el-button>
      <span class="tip">标签为用户自建字典；工作台所有意图（快递公司、供应商分组等）统一用标签表达；删除后订单上已打的该标签不再显示</span>
    </div>
    <el-table v-loading="loading" :data="rows" size="mini" border>
      <el-table-column label="标签名" prop="name" min-width="120" />
      <el-table-column label="颜色" width="90">
        <template slot-scope="{ row }">
          <span class="color-dot" :style="{ background: row.color || '#409eff' }" />
        </template>
      </el-table-column>
      <el-table-column label="排序" prop="sort" width="70" align="center" />
      <el-table-column label="关联池" width="90" align="center">
        <template slot-scope="{ row }">
          <el-tag v-if="row.bindPool === 2" size="mini" type="danger">异常池</el-tag>
          <span v-else class="pool-none">通用</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" width="90" align="center">
        <template slot-scope="{ row }">
          <el-tag size="mini" :type="row.status === 1 ? 'success' : 'info'">{{ row.status === 1 ? '启用' : '停用' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" align="center">
        <template slot-scope="{ row }">
          <el-button size="mini" type="text" @click="openEdit(row)">编辑</el-button>
          <el-button size="mini" type="text" @click="toggleStatus(row)">{{ row.status === 1 ? '停用' : '启用' }}</el-button>
          <el-button size="mini" type="text" class="danger-btn" @click="doRemove(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="query.pageNum"
      :limit.sync="query.pageSize"
      @pagination="getList"
    />

    <el-dialog :title="form.id ? '编辑标签' : '新增标签'" :visible.sync="formVisible" width="380px" append-to-body>
      <el-form :model="form" label-width="70px" size="small">
        <el-form-item label="标签名" required>
          <el-input v-model="form.name" maxlength="30" placeholder="如：京东发货、急单、A供应商" />
        </el-form-item>
        <el-form-item label="颜色">
          <el-color-picker v-model="form.color" :predefine="predefineColors" size="small" />
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="form.sort" :min="0" :max="999" size="small" />
        </el-form-item>
        <el-form-item label="关联池">
          <el-select v-model="form.bindPool" size="small" style="width: 100%">
            <el-option label="通用标签（不挂池）" :value="0" />
            <el-option label="异常池（分类标签）" :value="2" />
          </el-select>
          <div class="pool-tip">异常池分类标签全系统共用；转异常时必选单选，异常池按其分组计数</div>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button size="small" @click="formVisible = false">取 消</el-button>
        <el-button size="small" type="primary" @click="doSave">保 存</el-button>
      </div>
    </el-dialog>
  </el-dialog>
</template>

<script>
import { listTags, addTag, editTag, setTagStatus, deleteTag } from '@/api/order/workbench'

export default {
  name: 'TagManageDialog',
  data() {
    return {
      visible: false,
      loading: false,
      rows: [],
      total: 0,
      query: { pageNum: 1, pageSize: 10 },
      // 打开时传入的默认关联池（异常池标签行入口传 2，新增时预选）
      defaultBindPool: 0,
      formVisible: false,
      form: {},
      predefineColors: ['#409eff', '#67c23a', '#e6a23c', '#f56c6c', '#909399', '#9c27b0', '#00bcd4']
    }
  },
  methods: {
    open(defaultBindPool) {
      this.defaultBindPool = defaultBindPool || 0
      this.visible = true
      this.getList()
    },
    getList() {
      this.loading = true
      listTags(this.query).then(res => {
        this.rows = res.rows || []
        this.total = res.total || 0
      }).finally(() => { this.loading = false })
    },
    openAdd() {
      this.form = { name: '', color: '#409eff', sort: 0, bindPool: this.defaultBindPool }
      this.formVisible = true
    },
    openEdit(row) {
      this.form = { id: row.id, name: row.name, color: row.color, sort: row.sort, bindPool: row.bindPool || 0 }
      this.formVisible = true
    },
    doSave() {
      if (!this.form.name || !this.form.name.trim()) {
        this.$modal.msgError('标签名不能为空')
        return
      }
      const req = this.form.id ? editTag(this.form) : addTag(this.form)
      req.then(res => {
        if (res.code === 200) {
          this.$modal.msgSuccess('保存成功')
          this.formVisible = false
          this.getList()
          this.$emit('refresh')
        }
      })
    },
    toggleStatus(row) {
      setTagStatus({ id: row.id, status: row.status === 1 ? 0 : 1 }).then(res => {
        if (res.code === 200) {
          this.$modal.msgSuccess(row.status === 1 ? '已停用' : '已启用')
          this.getList()
          this.$emit('refresh')
        }
      })
    },
    // 删除标签（物理删除；订单已打该标签不再显示）
    doRemove(row) {
      this.$confirm('确认删除标签「' + row.name + '」？删除后订单上已打的该标签将不再显示', '提示', { type: 'warning' }).then(() => {
        deleteTag(row.id).then(res => {
          if (res.code === 200) {
            this.$modal.msgSuccess('已删除')
            this.getList()
            this.$emit('refresh')
          }
        })
      }).catch(() => {})
    }
  }
}
</script>

<style scoped>
.toolbar { display: flex; align-items: center; margin-bottom: 10px; }
.tip { color: #909399; font-size: 12px; margin-left: 10px; }
.pool-tip { color: #909399; font-size: 11px; line-height: 1.4; margin-top: 2px; }
.pool-none { color: #909399; font-size: 12px; }
.color-dot { display: inline-block; width: 16px; height: 16px; border-radius: 3px; }
.danger-btn { color: #f56c6c; }
</style>
