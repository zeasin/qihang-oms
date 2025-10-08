<template>
  <div class="app-container">
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <el-tab-pane label="商品管理" name="orderList" >
        <goods-list></goods-list>
      </el-tab-pane>
      <el-tab-pane label="商品SKU" name="orderItemList" lazy>
        <goods-sku></goods-sku>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import GoodsList  from "@/views/goods/goods_list.vue";
import GoodsSku  from "@/views/goods//spec/index.vue";


export default {
  name: "Order",
  components:{ GoodsList, GoodsSku},
  data() {
    return {
      activeName: 'orderList',
      typeList: [],
    };
  },
  created() {

  },
  mounted() {

  },
  methods: {
    handleClick(tab, event) {
      console.log(tab, event);
    }
  }
};
</script>
