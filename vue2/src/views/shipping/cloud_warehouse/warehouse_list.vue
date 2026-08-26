<template>
  <div class="app-container">
    <el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="small" :inline="true" label-width="68px">
      <el-form-item label="仓库编号" prop="warehouseNo">
        <el-input v-model="queryParams.warehouseNo" placeholder="请输入仓库编号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="仓库名" prop="warehouseName">
        <el-input v-model="queryParams.warehouseName" placeholder="请输入仓库名" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable @change="handleQuery">
          <el-option label="启用" value="1" />
          <el-option label="禁用" value="0" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增仓库</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="locationList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="仓库编号" align="center" prop="warehouseNo" width="120" />
      <el-table-column label="仓库名称" align="center" prop="warehouseName" width="150" />
      <el-table-column label="仓库类型" align="center" prop="warehouseType" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.warehouseType==='LOCAL'" size="small">本地仓</el-tag>
          <el-tag v-else-if="scope.row.warehouseType==='JDYC'" size="small" type="warning">京东云仓</el-tag>
          <el-tag v-else-if="scope.row.warehouseType==='CLOUD'" size="small" type="warning">系统云仓</el-tag>
          <el-tag v-else-if="scope.row.warehouseType==='JKYYC'" size="small">吉客云云仓</el-tag>
          <el-tag v-else size="small" type="info">{{ scope.row.warehouseType }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="联系人" align="center" prop="contacts" width="100" />
      <el-table-column label="联系电话" align="center" prop="phone" width="120" />
      <el-table-column label="详细地址" align="center" prop="address" min-width="200" show-overflow-tooltip />
      <el-table-column label="备注" align="center" prop="remark" width="150" show-overflow-tooltip />
      <el-table-column label="状态" align="center" prop="status" width="80">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status=='1'" type="success" size="small">启用</el-tag>
          <el-tag v-else size="small">禁用</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="150">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="550px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="仓库编号" prop="warehouseNo">
          <el-input v-model="form.warehouseNo" placeholder="请输入仓库编号" />
        </el-form-item>
        <el-form-item label="仓库名" prop="warehouseName">
          <el-input v-model="form.warehouseName" placeholder="请输入仓库名" />
        </el-form-item>
        <el-form-item label="仓库类型" prop="warehouseType">
          <el-select v-model="form.warehouseType" placeholder="请选择仓库类型" @change="warehouseTypeChange">
            <el-option label="系统云仓" value="CLOUD" />
            <el-option label="京东云仓" value="JDYC" />
            <el-option label="吉客云云仓" value="JKYYC" />
          </el-select>
        </el-form-item>
        <el-form-item v-if="form.warehouseType==='JKYYC'" label="货主编码" prop="ownerNo">
          <el-input v-model="form.ownerNo" placeholder="请输入货主编码" />
        </el-form-item>
        <el-form-item v-if="form.warehouseType==='JDYC'" label="AppKey" prop="appKey">
          <el-input v-model="form.appKey" placeholder="请输入AppKey" />
        </el-form-item>
        <el-form-item v-if="form.warehouseType==='JDYC'" label="AppSecret" prop="appSecret">
          <el-input v-model="form.appSecret" placeholder="请输入AppSecret" type="password" />
        </el-form-item>
        <el-form-item v-if="form.warehouseType==='JDYC'" label="Token/Pin" prop="accountToken">
          <el-input v-model="form.accountToken" placeholder="请输入Token或Pin" />
        </el-form-item>
        <el-form-item v-if="form.warehouseType!=='JDYC'" label="详细地址" prop="address">
          <el-input v-model="form.address" placeholder="请输入详细地址" />
        </el-form-item>
        <el-form-item label="联系人" prop="contacts">
          <el-input v-model="form.contacts" placeholder="请输入联系人" />
        </el-form-item>
        <el-form-item label="联系电话" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入联系电话" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="备注" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio label="1">启用</el-radio>
            <el-radio label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listWarehouse, getLocation, addLocation, updateLocation, delLocation } from "@/api/wms/warehouse";

export default {
  name: "WarehouseList",
  data() {
    return {
      loading: true,
      showSearch: true,
      total: 0,
      locationList: [],
      ids: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        warehouseNo: null,
        warehouseName: null,
        status: null
      },
      form: {},
      rules: {
        warehouseNo: [{ required: true, message: "不能为空", trigger: "blur" }],
        warehouseName: [{ required: true, message: "不能为空", trigger: "blur" }],
        warehouseType: [{ required: true, message: "请选择仓库类型", trigger: "change" }]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listWarehouse(this.queryParams).then(response => {
        this.locationList = response.rows || [];
        this.total = response.total || 0;
        this.loading = false;
      }).catch(() => {
        this.loading = false;
      });
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.queryParams.warehouseNo = null;
      this.queryParams.warehouseName = null;
      this.queryParams.status = null;
      this.handleQuery();
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id);
    },
    handleAdd() {
      this.reset();
      this.title = "新增仓库";
      this.open = true;
    },
    handleUpdate(row) {
      this.reset();
      getLocation(row.id).then(response => {
        this.form = response.data || {};
        this.title = "修改仓库";
        this.open = true;
      });
    },
    handleDelete(row) {
      this.$confirm('确认删除？').then(() => {
        return delLocation(row.id);
      }).then(() => {
        this.getList();
        this.msgSuccess("删除成功");
      }).catch(() => {});
    },
    warehouseTypeChange() {},
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (!valid) return;
        const api = this.form.id ? updateLocation : addLocation;
        api(this.form).then(() => {
          this.msgSuccess("保存成功");
          this.open = false;
          this.getList();
        });
      });
    },
    cancel() {
      this.open = false;
      this.reset();
    },
    reset() {
      this.form = {
        warehouseNo: null,
        warehouseName: null,
        warehouseType: "CLOUD",
        contacts: null,
        phone: null,
        address: null,
        remark: null,
        status: "1",
        ownerNo: null,
        appKey: null,
        appSecret: null,
        accountToken: null
      };
      this.resetForm("form");
    }
  }
};
</script>
