/*
 Navicat Premium Dump SQL

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80043 (8.0.43)
 Source Host           : localhost:3306
 Source Schema         : qihang-oms

 Target Server Type    : MySQL
 Target Server Version : 80043 (8.0.43)
 File Encoding         : 65001

 Date: 08/10/2025 16:09:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for erp_stock_in
-- ----------------------------
DROP TABLE IF EXISTS `erp_stock_in`;
CREATE TABLE `erp_stock_in`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `stock_in_num` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '入库单据编号',
  `stock_in_type` int NOT NULL COMMENT '来源类型（1采购订单2退货订单）',
  `source_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源单号',
  `source_id` bigint NULL DEFAULT NULL COMMENT '来源单id',
  `source_goods_unit` int NULL DEFAULT NULL COMMENT '采购订单商品数',
  `source_spec_unit_total` int NULL DEFAULT NULL COMMENT '采购订单总件数',
  `source_spec_unit` int NULL DEFAULT NULL COMMENT '采购订单商品规格数',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `stock_in_operator_id` bigint NULL DEFAULT NULL COMMENT '操作入库人id',
  `stock_in_operator` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作入库人',
  `stock_in_time` datetime NULL DEFAULT NULL COMMENT '入库时间',
  `status` int NOT NULL DEFAULT 0 COMMENT '状态（0待入库1部分入库2全部入库）',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '入库单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of erp_stock_in
-- ----------------------------

-- ----------------------------
-- Table structure for erp_stock_in_item
-- ----------------------------
DROP TABLE IF EXISTS `erp_stock_in_item`;
CREATE TABLE `erp_stock_in_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `stock_in_id` bigint NOT NULL COMMENT '入库单id',
  `stock_in_type` int NULL DEFAULT NULL COMMENT '来源类型（1采购订单2退货订单）',
  `source_no` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源单号',
  `source_id` bigint NULL DEFAULT NULL COMMENT '来源单id',
  `source_item_id` bigint NOT NULL COMMENT '来源单itemId',
  `goods_id` bigint NOT NULL COMMENT '商品id',
  `goods_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品编码',
  `goods_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `goods_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `sku_id` bigint NOT NULL COMMENT '商品规格id',
  `sku_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品规格编码',
  `sku_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '颜色',
  `quantity` int NOT NULL COMMENT '原始数量',
  `in_quantity` int NOT NULL DEFAULT 0 COMMENT '入库数量',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `status` int NULL DEFAULT 0 COMMENT '状态（0待入库1部分入库2全部入库）',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `specIndex`(`sku_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '入库单明细' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of erp_stock_in_item
-- ----------------------------

-- ----------------------------
-- Table structure for erp_stock_out
-- ----------------------------
DROP TABLE IF EXISTS `erp_stock_out`;
CREATE TABLE `erp_stock_out`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `stock_out_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '出库单编号',
  `source_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源单据号',
  `source_id` bigint NULL DEFAULT NULL COMMENT '来源单据Id',
  `stock_out_type` int NOT NULL DEFAULT 1 COMMENT '出库类型1订单拣货出库2采购退货出库3盘点出库4报损出库',
  `goods_unit` int NOT NULL COMMENT '商品数',
  `spec_unit` int NOT NULL COMMENT '商品规格数',
  `spec_unit_total` int NOT NULL COMMENT '总件数',
  `out_total` int NULL DEFAULT NULL COMMENT '已出库数量',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` int NOT NULL COMMENT '状态：0待出库1部分出库2全部出库',
  `print_status` int NOT NULL COMMENT '打印状态：是否打印1已打印0未打印',
  `print_time` datetime NULL DEFAULT NULL COMMENT '打印时间',
  `out_time` datetime NULL DEFAULT NULL COMMENT '出库时间',
  `complete_time` datetime NULL DEFAULT NULL COMMENT '完成出库时间',
  `operator_id` int NULL DEFAULT 0 COMMENT '出库操作人userid',
  `operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '出库操作人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '出库单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of erp_stock_out
-- ----------------------------

-- ----------------------------
-- Table structure for erp_stock_out_item
-- ----------------------------
DROP TABLE IF EXISTS `erp_stock_out_item`;
CREATE TABLE `erp_stock_out_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `stock_out_type` int NOT NULL COMMENT '出库类型1订单拣货出库2采购退货出库3盘点出库4报损出库',
  `entry_id` bigint NOT NULL COMMENT '出库单id（外键）',
  `source_order_id` bigint NOT NULL COMMENT '来源订单id',
  `source_order_item_id` bigint NOT NULL COMMENT '来源订单itemId出库对应的itemId，如：order_item表id、invoice_info表id',
  `source_order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '来源订单号',
  `goods_id` bigint NOT NULL COMMENT '商品id',
  `spec_id` bigint NOT NULL COMMENT '商品规格id',
  `spec_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '规格编码',
  `original_quantity` int NOT NULL COMMENT '总数量',
  `out_quantity` int NOT NULL DEFAULT 0 COMMENT '已出库数量',
  `complete_time` datetime NULL DEFAULT NULL COMMENT '完成出库时间',
  `picked_time` datetime NULL DEFAULT NULL COMMENT '完成拣货时间',
  `status` int NOT NULL DEFAULT 0 COMMENT '状态：0待出库1部分出库2全部出库',
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `specIndex`(`spec_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '出库单明细' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of erp_stock_out_item
-- ----------------------------

-- ----------------------------
-- Table structure for erp_stock_out_item_position
-- ----------------------------
DROP TABLE IF EXISTS `erp_stock_out_item_position`;
CREATE TABLE `erp_stock_out_item_position`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `entry_id` bigint NOT NULL COMMENT '出库单ID',
  `entry_item_id` bigint NOT NULL DEFAULT 0 COMMENT '出库单ItemID',
  `goods_inventory_id` bigint NOT NULL DEFAULT 0 COMMENT '库存ID',
  `goods_inventory_detail_id` bigint NOT NULL DEFAULT 0 COMMENT '库存详情ID',
  `quantity` int NOT NULL DEFAULT 0 COMMENT '出库数量',
  `warehouse_id` bigint NULL DEFAULT NULL COMMENT '仓库ID',
  `position_id` bigint NULL DEFAULT NULL COMMENT '仓位id',
  `position_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '仓位编码',
  `operator_id` bigint NULL DEFAULT 0 COMMENT '出库操作人userid',
  `operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '出库操作人',
  `out_time` datetime NULL DEFAULT NULL COMMENT '出库时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `goods_stock_info_item_id_index`(`goods_inventory_detail_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '出库仓位详情' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of erp_stock_out_item_position
-- ----------------------------

-- ----------------------------
-- Table structure for erp_warehouse
-- ----------------------------
DROP TABLE IF EXISTS `erp_warehouse`;
CREATE TABLE `erp_warehouse`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '仓库编号',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '仓库名称',
  `province` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省',
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市',
  `district` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区',
  `street` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '街道',
  `address` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` int NOT NULL DEFAULT 0 COMMENT '状态0禁用  1正常',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '仓库表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of erp_warehouse
-- ----------------------------

-- ----------------------------
-- Table structure for erp_warehouse_position
-- ----------------------------
DROP TABLE IF EXISTS `erp_warehouse_position`;
CREATE TABLE `erp_warehouse_position`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `warehouse_id` int NOT NULL COMMENT '仓库id',
  `number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '仓库/货架编号',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '仓位/货架名称',
  `parent_id` int NOT NULL COMMENT '上级id',
  `depth` int NULL DEFAULT 1 COMMENT '层级深度1级2级3级',
  `parent_id1` int NOT NULL COMMENT '一级类目id',
  `parent_id2` int NOT NULL COMMENT '二级类目id',
  `address` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `is_delete` int NOT NULL DEFAULT 0 COMMENT '0正常  1删除',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '仓库仓位表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of erp_warehouse_position
-- ----------------------------

-- ----------------------------
-- Table structure for o_after_sale
-- ----------------------------
DROP TABLE IF EXISTS `o_after_sale`;
CREATE TABLE `o_after_sale`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type` int NULL DEFAULT NULL COMMENT '类型（0无需处理；10退货；20换货；80补发；99订单拦截；）',
  `shop_id` bigint NULL DEFAULT NULL COMMENT '店铺id',
  `shop_type` int NULL DEFAULT NULL COMMENT '店铺类型',
  `refund_id` bigint NULL DEFAULT NULL COMMENT '退款id（o_refund表主键）',
  `refund_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '售后单号',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `sub_order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子订单号',
  `o_order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单id（o_order表主键id）',
  `o_order_item_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子订单id（o_order_item表主键id）',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '平台商品skuid',
  `quantity` int NULL DEFAULT NULL COMMENT '售后数量',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题',
  `img` varchar(555) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `sku_info` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku描述',
  `sku_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku编码',
  `o_goods_id` bigint NULL DEFAULT NULL COMMENT '系统商品id（o_goods表主键id）',
  `o_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '系统商品skuId（o_goods表主键id）',
  `has_goods_send` int NULL DEFAULT NULL COMMENT ' 是否发货',
  `send_logistics_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货物流单号',
  `return_info` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退回人信息json',
  `return_logistics_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退回快递单号',
  `return_logistics_company` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退回物流公司名称',
  `receiver_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人姓名',
  `receiver_tel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人联系电话',
  `receiver_province` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省',
  `receiver_city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市',
  `receiver_town` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区',
  `receiver_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人详细地址',
  `reissue_logistics_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货快递单号（补发、换货发货）',
  `reissue_logistics_company` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货快递公司',
  `status` int NULL DEFAULT NULL COMMENT '状态:0待处理；1已发出；2已收货；10已完成',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `update_by` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'OMS售后处理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_after_sale
-- ----------------------------

-- ----------------------------
-- Table structure for o_goods
-- ----------------------------
DROP TABLE IF EXISTS `o_goods`;
CREATE TABLE `o_goods`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '商品名称',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品图片地址',
  `outer_erp_goods_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品唯一ID',
  `goods_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '商品编号',
  `unit_name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '单位名称',
  `category_id` bigint NULL DEFAULT 0 COMMENT '商品分类ID',
  `bar_code` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '条码',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态1销售中2已下架',
  `length` float NOT NULL DEFAULT 0 COMMENT '衣长/裙长/裤长',
  `height` float NOT NULL DEFAULT 0 COMMENT '高度/袖长',
  `width` float NOT NULL DEFAULT 0 COMMENT '宽度/胸阔(围)',
  `width1` float NOT NULL DEFAULT 0 COMMENT '肩阔',
  `width2` float NOT NULL DEFAULT 0 COMMENT '腰阔',
  `width3` float NOT NULL DEFAULT 0 COMMENT '臀阔',
  `weight` float NOT NULL DEFAULT 0 COMMENT '重量',
  `disable` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0启用   1禁用',
  `period` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '保质期',
  `pur_price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '预计采购价格',
  `whole_price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '建议批发价',
  `retail_price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '建议零售价',
  `unit_cost` decimal(8, 2) NULL DEFAULT NULL COMMENT '单位成本',
  `supplier_id` bigint NULL DEFAULT 0 COMMENT '供应商id',
  `brand_id` bigint NULL DEFAULT 0 COMMENT '品牌id',
  `attr1` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '属性1：季节',
  `attr2` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '属性2：分类',
  `attr3` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '属性3：风格',
  `attr4` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '属性4：年份',
  `attr5` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '属性5：面料',
  `link_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '外链url',
  `low_qty` int NULL DEFAULT 0 COMMENT '最低库存（预警）',
  `high_qty` int NULL DEFAULT 0 COMMENT '最高库存（预警）',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `province` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发货地省',
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发货地市',
  `town` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发货地区',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `goods_id_unique`(`outer_erp_goods_id` ASC) USING BTREE,
  INDEX `number`(`goods_num` ASC) USING BTREE,
  INDEX `id`(`id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'OMS商品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_goods
-- ----------------------------
INSERT INTO `o_goods` VALUES (16, '雷士照明led吸顶灯管灯芯改造灯板圆形灯盘节能灯泡替换光源模组', 'https://cbu01.alicdn.com/img/ibank/O1CN01LUp3xX1UZhfp9zoR1_!!2215604672532-0-cib.jpg', NULL, 'LSDX001', '', 3, '', '', 1, 0, 0, 0, 0, 0, 0, 0, 0, '0', 25.00, 0.00, 0.00, NULL, 1975713491747684353, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'admin', '2025-10-08 10:57:17', NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for o_goods_brand
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_brand`;
CREATE TABLE `o_goods_brand`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '品牌名',
  `status` int NULL DEFAULT NULL COMMENT '状态',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_goods_brand
-- ----------------------------

-- ----------------------------
-- Table structure for o_goods_category
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_category`;
CREATE TABLE `o_goods_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `number` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类编码',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类名称',
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `parent_id` bigint NULL DEFAULT NULL COMMENT '上架分类id',
  `path` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '分类路径',
  `sort` int NULL DEFAULT 0 COMMENT '排序值',
  `image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片',
  `isDelete` tinyint(1) NULL DEFAULT 0 COMMENT '0正常  1删除',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_goods_category
-- ----------------------------
INSERT INTO `o_goods_category` VALUES (3, 'ZM', '照明', NULL, 0, '', 0, NULL, 0, 'admin', '2025-10-08 08:02:22', NULL, NULL);

-- ----------------------------
-- Table structure for o_goods_category_attribute
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_category_attribute`;
CREATE TABLE `o_goods_category_attribute`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `category_id` bigint NOT NULL,
  `type` int NOT NULL DEFAULT 0 COMMENT '类型：0属性1规格',
  `title` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '\'属性名\'',
  `code` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '固定值color颜色size尺码style款式',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_goods_category_attribute
-- ----------------------------
INSERT INTO `o_goods_category_attribute` VALUES (2, 3, 1, '颜色', 'color');
INSERT INTO `o_goods_category_attribute` VALUES (3, 3, 1, '亮度', 'size');

-- ----------------------------
-- Table structure for o_goods_category_attribute_value
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_category_attribute_value`;
CREATE TABLE `o_goods_category_attribute_value`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键，属性值id',
  `category_attribute_id` bigint NULL DEFAULT NULL COMMENT '属性id',
  `value` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '属性值文本',
  `sku_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成SKU的编码',
  `orderNum` int NULL DEFAULT 0,
  `isDelete` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 432 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_goods_category_attribute_value
-- ----------------------------
INSERT INTO `o_goods_category_attribute_value` VALUES (427, 2, '白光', '00', 0, 0);
INSERT INTO `o_goods_category_attribute_value` VALUES (428, 3, '12W', '12W', 0, 0);
INSERT INTO `o_goods_category_attribute_value` VALUES (429, 3, '18W', '18W', 0, 0);
INSERT INTO `o_goods_category_attribute_value` VALUES (430, 3, '24W', '24W', 0, 0);
INSERT INTO `o_goods_category_attribute_value` VALUES (431, 3, '36W', '36W', 0, 0);

-- ----------------------------
-- Table structure for o_goods_inventory
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_inventory`;
CREATE TABLE `o_goods_inventory`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `goods_id` bigint NOT NULL COMMENT '商品id',
  `goods_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品编码',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名',
  `goods_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `sku_id` bigint NOT NULL COMMENT '商品规格id',
  `sku_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '规格编码（唯一）',
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'SKU名',
  `quantity` bigint NOT NULL DEFAULT 0 COMMENT '当前库存',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0正常  1删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `specIdIndex`(`sku_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品库存表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_goods_inventory
-- ----------------------------
INSERT INTO `o_goods_inventory` VALUES (45, 16, 'LSDX001', NULL, NULL, 45, 'LSDX0010012W', NULL, -2, 0, '2025-10-08 10:57:17', '添加商品', '2025-10-08 15:58:59', '发货出库');
INSERT INTO `o_goods_inventory` VALUES (46, 16, 'LSDX001', NULL, NULL, 46, 'LSDX0010018W', NULL, 0, 0, '2025-10-08 10:57:17', '添加商品', '2025-10-08 02:57:16', NULL);
INSERT INTO `o_goods_inventory` VALUES (47, 16, 'LSDX001', NULL, NULL, 47, 'LSDX0010024W', NULL, 0, 0, '2025-10-08 10:57:17', '添加商品', '2025-10-08 02:57:16', NULL);
INSERT INTO `o_goods_inventory` VALUES (48, 16, 'LSDX001', NULL, NULL, 48, 'LSDX0010036W', NULL, 0, 0, '2025-10-08 10:57:17', '添加商品', '2025-10-08 02:57:16', NULL);

-- ----------------------------
-- Table structure for o_goods_inventory_batch
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_inventory_batch`;
CREATE TABLE `o_goods_inventory_batch`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `inventory_id` bigint NOT NULL COMMENT '库存id',
  `batch_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '批次号',
  `qty` int NOT NULL COMMENT '操作数量',
  `origin_qty` int NOT NULL COMMENT '初始数量',
  `current_qty` int NOT NULL DEFAULT 0 COMMENT '当前数量',
  `pur_price` double NOT NULL DEFAULT 0 COMMENT '采购价',
  `pur_id` bigint NOT NULL DEFAULT 0 COMMENT '采购单id',
  `pur_item_id` bigint NOT NULL DEFAULT 0 COMMENT '采购单itemId',
  `remark` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `sku_id` bigint NOT NULL COMMENT '规格id',
  `goods_id` bigint NOT NULL COMMENT '商品id',
  `sku_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku编码',
  `warehouse_id` bigint NOT NULL COMMENT '仓库id',
  `position_id` bigint NOT NULL COMMENT '仓位id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品库存批次' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_goods_inventory_batch
-- ----------------------------
INSERT INTO `o_goods_inventory_batch` VALUES (2, 45, '20251008154746', -1, 0, -1, 0, 0, 0, '发货出库250929-351611154071222', 45, 16, 'LSDX0010012W', 0, 0, '2025-10-08 15:47:46', '发货出库', '2025-10-08 15:47:46', NULL);
INSERT INTO `o_goods_inventory_batch` VALUES (3, 45, '20251008155858', 1, -1, -2, 0, 0, 0, '发货出库250929-351611154071222', 45, 16, 'LSDX0010012W', 0, 0, '2025-10-08 15:58:59', '发货出库', '2025-10-08 15:58:59', NULL);

-- ----------------------------
-- Table structure for o_goods_inventory_operation
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_inventory_operation`;
CREATE TABLE `o_goods_inventory_operation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `goods_id` bigint NOT NULL COMMENT '商品id',
  `goods_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品编码',
  `sku_id` bigint NOT NULL COMMENT '商品规格id',
  `sku_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '规格编码（唯一）',
  `batch_id` bigint NOT NULL COMMENT '库存批次id',
  `batch_num` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '库存批次号',
  `type` int NOT NULL COMMENT '库存类型（1增加库存2减少库存3锁定库存）',
  `inventory_detail_id` bigint NOT NULL COMMENT '商品库存id（本表id减库存的时候关联）',
  `quantity` int NOT NULL DEFAULT 0 COMMENT '操作库存数量',
  `locked_quantity` int NOT NULL COMMENT '锁定库存数量（status变成已结算时把该字段值更新到quantity）',
  `price` double NULL DEFAULT 0 COMMENT '价格（type=1采购价格；type=2出库时的价格）',
  `biz_type` int NOT NULL COMMENT '业务类型（10采购入库20采购退货30退货入库40订单出库）',
  `biz_id` bigint NOT NULL COMMENT '业务单id',
  `biz_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务单号',
  `biz_item_id` bigint NOT NULL COMMENT '业务单itemId',
  `status` int NOT NULL COMMENT '状态（0待结算1已结算）',
  `remark` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `warehouse_id` bigint NOT NULL COMMENT '仓库id',
  `position_id` bigint NOT NULL COMMENT '仓位id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '仓库库存操作记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_goods_inventory_operation
-- ----------------------------

-- ----------------------------
-- Table structure for o_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_sku`;
CREATE TABLE `o_goods_sku`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `goods_id` bigint NOT NULL COMMENT '外键（o_goods）',
  `outer_erp_goods_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '外部erp系统商品id',
  `outer_erp_sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '外部erp系统skuId(唯一)',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名',
  `goods_num` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品编码',
  `sku_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '规格名',
  `sku_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规格编码',
  `color_label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '颜色label',
  `color_id` bigint NULL DEFAULT 0 COMMENT '颜色id',
  `color_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '颜色值',
  `color_image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '颜色图片',
  `size_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '尺码label',
  `size_id` bigint NULL DEFAULT 0 COMMENT '尺码id',
  `size_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '尺码值(材质)',
  `style_label` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '款式label',
  `style_id` bigint NULL DEFAULT 0 COMMENT '款式id',
  `style_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '款式值',
  `bar_code` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '库存条形码',
  `pur_price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '预计采购价格',
  `retail_price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '建议零售价',
  `unit_cost` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '单位成本',
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态',
  `low_qty` int NULL DEFAULT 0 COMMENT '最低库存（预警）',
  `high_qty` int NULL DEFAULT 0 COMMENT '最高库存（预警）',
  `volume` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'erp商品体积',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sku_id_unique`(`outer_erp_sku_id` ASC) USING BTREE,
  INDEX `id`(`id` ASC) USING BTREE,
  INDEX `number`(`sku_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'OMS商品SKU表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_goods_sku
-- ----------------------------
INSERT INTO `o_goods_sku` VALUES (45, 16, NULL, NULL, '雷士照明led吸顶灯管灯芯改造灯板圆形灯盘节能灯泡替换光源模组', NULL, '白光 12W', 'LSDX0010012W', NULL, 427, '白光', 'https://cbu01.alicdn.com/img/ibank/O1CN01ZZTZb01UZhscuHvTj_!!2215604672532-0-cib.jpg', NULL, 428, '12W', NULL, 0, '', NULL, 25.00, 0.00, 0.00, '', 1, 0, 0, NULL, '2025-10-08 02:57:16', NULL);
INSERT INTO `o_goods_sku` VALUES (46, 16, NULL, NULL, '雷士照明led吸顶灯管灯芯改造灯板圆形灯盘节能灯泡替换光源模组', NULL, '白光 18W', 'LSDX0010018W', NULL, 427, '白光', 'https://cbu01.alicdn.com/img/ibank/O1CN01bYBxVj1UZhsbltiGt_!!2215604672532-0-cib.jpg', NULL, 429, '18W', NULL, 0, '', NULL, 25.00, 0.00, 0.00, '', 1, 0, 0, NULL, '2025-10-08 02:57:16', NULL);
INSERT INTO `o_goods_sku` VALUES (47, 16, NULL, NULL, '雷士照明led吸顶灯管灯芯改造灯板圆形灯盘节能灯泡替换光源模组', NULL, '白光 24W', 'LSDX0010024W', NULL, 427, '白光', 'https://cbu01.alicdn.com/img/ibank/O1CN01RBKirl1UZhsd6pgUY_!!2215604672532-0-cib.jpg', NULL, 430, '24W', NULL, 0, '', NULL, 25.00, 0.00, 0.00, '', 1, 0, 0, NULL, '2025-10-08 02:57:16', NULL);
INSERT INTO `o_goods_sku` VALUES (48, 16, NULL, NULL, '雷士照明led吸顶灯管灯芯改造灯板圆形灯盘节能灯泡替换光源模组', NULL, '白光 36W', 'LSDX0010036W', NULL, 427, '白光', 'https://cbu01.alicdn.com/img/ibank/O1CN01opaMlf1UZhseOA2Zj_!!2215604672532-0-cib.jpg', NULL, 431, '36W', NULL, 0, '', NULL, 25.00, 0.00, 0.00, '', 1, 0, 0, NULL, '2025-10-08 02:57:16', NULL);

-- ----------------------------
-- Table structure for o_goods_sku_attr
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_sku_attr`;
CREATE TABLE `o_goods_sku_attr`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `goods_id` bigint NOT NULL,
  `type` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `k` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `kid` int NULL DEFAULT NULL,
  `vid` int NULL DEFAULT NULL,
  `v` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `img` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_goods_sku_attr
-- ----------------------------
INSERT INTO `o_goods_sku_attr` VALUES (1, 16, 'color', '颜色', 114, 427, NULL, NULL);
INSERT INTO `o_goods_sku_attr` VALUES (2, 16, 'size', '尺码', 115, 428, NULL, NULL);
INSERT INTO `o_goods_sku_attr` VALUES (3, 16, 'size', '尺码', 115, 429, NULL, NULL);
INSERT INTO `o_goods_sku_attr` VALUES (4, 16, 'size', '尺码', 115, 430, NULL, NULL);
INSERT INTO `o_goods_sku_attr` VALUES (5, 16, 'size', '尺码', 115, 431, NULL, NULL);
INSERT INTO `o_goods_sku_attr` VALUES (6, 16, 'style', '款式', 116, 427, NULL, NULL);

-- ----------------------------
-- Table structure for o_goods_supplier
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_supplier`;
CREATE TABLE `o_goods_supplier`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '供应商名称',
  `number` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '供应商编码',
  `taxRate` double NULL DEFAULT 0 COMMENT '税率',
  `amount` double NULL DEFAULT 0 COMMENT '期初应付款',
  `periodMoney` double NULL DEFAULT 0 COMMENT '期初预付款',
  `difMoney` double NULL DEFAULT 0 COMMENT '初期往来余额',
  `beginDate` date NULL DEFAULT NULL COMMENT '余额日期',
  `remark` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `place` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '职位',
  `linkMan` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '联系方式',
  `province` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省',
  `city` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市',
  `county` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区县',
  `address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货地址详情',
  `pinYin` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  `disable` tinyint(1) NULL DEFAULT 0 COMMENT '0启用   1禁用',
  `isDelete` tinyint(1) NULL DEFAULT 0 COMMENT '0正常 1删除',
  `purchaserName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分管采购员',
  `createTime` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1975713491747684354 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_goods_supplier
-- ----------------------------
INSERT INTO `o_goods_supplier` VALUES (1975713491747684353, '佛山三佛照明', 'SFZM', 0, 0, 0, 0, NULL, '', '', NULL, '', NULL, NULL, NULL, NULL, '', 0, 0, NULL, '2025-10-08 08:02:58');

-- ----------------------------
-- Table structure for o_logistics_company
-- ----------------------------
DROP TABLE IF EXISTS `o_logistics_company`;
CREATE TABLE `o_logistics_company`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `platform_id` int NULL DEFAULT NULL COMMENT '平台id',
  `shop_id` int NULL DEFAULT NULL COMMENT '店铺ID',
  `logistics_id` bigint NULL DEFAULT NULL COMMENT '物流公司id（值来自于平台返回）',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流公司编码（值来自于平台返回）',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流公司名称（值来自于平台返回）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` int NULL DEFAULT NULL COMMENT '状态（0禁用1启用）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '快递公司表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_logistics_company
-- ----------------------------
INSERT INTO `o_logistics_company` VALUES (1, 100, NULL, NULL, 'aa', '中通快递', NULL, 1);
INSERT INTO `o_logistics_company` VALUES (3, 300, NULL, NULL, 'JTSD', '极兔快递', NULL, 1);

-- ----------------------------
-- Table structure for o_order
-- ----------------------------
DROP TABLE IF EXISTS `o_order`;
CREATE TABLE `o_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单id，自增',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号（第三方平台订单号）',
  `shop_type` int NOT NULL COMMENT '店铺类型',
  `shop_id` bigint NOT NULL COMMENT '店铺ID',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单备注',
  `buyer_memo` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家留言信息',
  `seller_memo` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卖家留言信息',
  `tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签',
  `refund_status` int NOT NULL COMMENT '售后状态 1：无售后或售后关闭，2：售后处理中，3：退款中，4： 退款成功 ',
  `order_status` int NOT NULL COMMENT '订单状态0：新订单，1：待发货，2：已发货，3：已完成，11已取消；12退款中；21待付款；22锁定，29删除，101部分发货',
  `goods_amount` double NULL DEFAULT NULL COMMENT '订单商品金额',
  `post_fee` double NULL DEFAULT NULL COMMENT '订单运费',
  `seller_discount` double NULL DEFAULT 0 COMMENT '商家优惠金额，单位：元',
  `platform_discount` double NULL DEFAULT 0 COMMENT '平台优惠金额，单位：元',
  `amount` double NOT NULL COMMENT '订单实际金额',
  `payment` double NULL DEFAULT NULL COMMENT '实付金额',
  `receiver_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人姓名',
  `receiver_mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人手机号',
  `address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人地址',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市',
  `town` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区',
  `order_time` datetime NULL DEFAULT NULL COMMENT '订单时间',
  `shipper` int NOT NULL DEFAULT 0 COMMENT '发货方式 0 自己发货1联合发货2供应商发货',
  `ship_type` int NOT NULL DEFAULT 0 COMMENT '发货方式1电子面单发货2手动发货',
  `ship_status` int NOT NULL DEFAULT 0 COMMENT '发货状态 0 待发货 1 已分配供应商发货 2全部发货',
  `ship_company` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '发货快递公司',
  `ship_code` varchar(33) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货物流公司',
  `ship_time` datetime NULL DEFAULT NULL COMMENT '发货时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '取消原因',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_sn_index`(`order_num` ASC) USING BTREE,
  INDEX `shopid_index`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'OMS订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_order
-- ----------------------------
INSERT INTO `o_order` VALUES (40, '4779070308838830200', 100, 1007, NULL, NULL, NULL, NULL, 1, 1, 11992, 0, 0, 0, 11992, 3816, '李**', '***********', '北**镇东**村***号***', '北京', '北京市', '昌平区', '2025-09-30 15:47:31', 0, 0, 0, '0', NULL, NULL, '2025-10-06 17:49:00', '手动确认订单', '2025-10-07 10:49:54', '手动发货', NULL);
INSERT INTO `o_order` VALUES (41, '250929-351611154071222', 300, 1009, NULL, '', '', NULL, 1, 2, 29.35, 0, 0, 0, 29.35, 29.35, 'a', 'a', 'a', '北京市', '市辖区', '东城区', '2025-09-29 21:22:48', 0, 2, 2, '0', NULL, NULL, '2025-10-06 17:56:31', '手动确认订单', '2025-10-08 11:42:57', '手动发货', 'aa');

-- ----------------------------
-- Table structure for o_order_item
-- ----------------------------
DROP TABLE IF EXISTS `o_order_item`;
CREATE TABLE `o_order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id，自增',
  `shop_id` bigint NOT NULL COMMENT '店铺ID',
  `shop_type` int NOT NULL COMMENT '店铺类型',
  `order_id` bigint NOT NULL COMMENT '订单ID（o_order外键）',
  `order_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号（第三方平台）',
  `sub_order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '子订单号（第三方平台）',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方平台skuId',
  `goods_id` bigint NOT NULL DEFAULT 0 COMMENT '商品id(o_goods外键)',
  `goods_sku_id` bigint NOT NULL DEFAULT 0 COMMENT '商品skuid(o_goods_sku外键)',
  `goods_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题',
  `goods_img` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `goods_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品编码',
  `goods_spec` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品规格',
  `sku_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品规格编码',
  `goods_price` double NOT NULL COMMENT '商品单价',
  `item_amount` double NULL DEFAULT NULL COMMENT '子订单金额',
  `discount_amount` double NULL DEFAULT 0 COMMENT '子订单优惠金额',
  `payment` double NULL DEFAULT NULL COMMENT '实际支付金额',
  `quantity` int NOT NULL COMMENT '商品数量',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `refund_count` int NULL DEFAULT 0 COMMENT '已退货数量',
  `refund_status` int NULL DEFAULT NULL COMMENT '售后状态 1：无售后或售后关闭，2：售后处理中，3：退款中，4： 退款成功 ',
  `order_status` int NULL DEFAULT NULL COMMENT '订单状态1：待发货，2：已发货，3：已完成，11已取消；21待付款',
  `shipper` int NOT NULL DEFAULT 0 COMMENT '发货方式 0 自己发货1联合发货2供应商发货',
  `ship_type` int NOT NULL DEFAULT 0 COMMENT '发货方式1电子面单发货2手动发货',
  `ship_status` int NOT NULL DEFAULT 0 COMMENT '发货状态 0 待发货  2全部发货',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `goodId_index`(`goods_id` ASC) USING BTREE,
  INDEX `order_id`(`order_id` ASC) USING BTREE,
  INDEX `order_num_index`(`order_num` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'OMS订单明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_order_item
-- ----------------------------
INSERT INTO `o_order_item` VALUES (45, 1007, 100, 40, '4779070308838830200', '4779070308839830200', '5380261056486', 0, 0, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', NULL, '适用人数:组合;颜色分类:石墨灰【灯芯绒】;尺寸:94x45x35cm', 'F9-23E-LAB-ZDB-2', 1499, 1499, 0, 0, 1, NULL, 0, 1, NULL, 0, 0, 0, '2025-10-06 17:49:00', '手动确认订单', '2025-10-07 10:49:54', '手动发货');
INSERT INTO `o_order_item` VALUES (46, 1007, 100, 40, '4779070308838830200', '4779070308840830200', '5380261056464', 0, 0, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', NULL, '适用人数:组合;颜色分类:焦糖棕【灯芯绒】;尺寸:94x45x35cm', 'F8-23E-LAB-ZDB-2', 1499, 1499, 0, 0, 1, NULL, 0, 1, NULL, 0, 0, 0, '2025-10-06 17:49:00', '手动确认订单', '2025-10-07 10:49:54', '手动发货');
INSERT INTO `o_order_item` VALUES (47, 1007, 100, 40, '4779070308838830200', '4779070308841830200', '5380261056530', 0, 0, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', NULL, '适用人数:组合;颜色分类:蔷薇粉【灯芯绒】;尺寸:94x45x35cm', 'F7-23E-LAB-ZDB-2', 1499, 1499, 0, 0, 1, NULL, 0, 1, NULL, 0, 0, 0, '2025-10-06 17:49:00', '手动确认订单', '2025-10-07 10:49:54', '手动发货');
INSERT INTO `o_order_item` VALUES (48, 1007, 100, 40, '4779070308838830200', '4779070308842830200', '5380261056508', 0, 0, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', NULL, '适用人数:组合;颜色分类:奶茶灰【灯芯绒】;尺寸:94x45x35cm', 'F2-23E-LAB-ZDB-2', 1499, 4497, 0, 0, 3, NULL, 0, 1, NULL, 0, 0, 0, '2025-10-06 17:49:00', '手动确认订单', '2025-10-07 10:49:54', '手动发货');
INSERT INTO `o_order_item` VALUES (49, 1007, 100, 40, '4779070308838830200', '4779070308843830200', '5380261056552', 0, 0, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', NULL, '适用人数:组合;颜色分类:冰川灰【头层牛皮】;尺寸:94x45x35cm', 'F5-23E-LAB-ZDB-2', 1499, 1499, 0, 0, 1, NULL, 0, 1, NULL, 0, 0, 0, '2025-10-06 17:49:00', '手动确认订单', '2025-10-07 10:49:54', '手动发货');
INSERT INTO `o_order_item` VALUES (50, 1007, 100, 40, '4779070308838830200', '4779070308844830200', '5380261056497', 0, 0, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', NULL, '适用人数:组合;颜色分类:蜜糖棕【硅胶皮】;尺寸:94x45x35cm', 'F4-23E-LAB-ZDB-2', 1499, 1499, 0, 0, 1, NULL, 0, 1, NULL, 0, 0, 0, '2025-10-06 17:49:00', '手动确认订单', '2025-10-07 10:49:54', '手动发货');
INSERT INTO `o_order_item` VALUES (51, 1009, 300, 41, '250929-351611154071222', '250929-351611154071222-1742164849115', '1742164849115', 0, 0, NULL, 'https://img.pddpic.com/mms-material-img/2025-05-29/a3e7e689-5c30-495c-b5e0-90e38bd352b5.jpeg.a.jpeg', 'LEDDX001', '12W白光-135mm', 'LEDDX00101', 29.35, 29.35, 0, 0, 1, NULL, 0, 1, 11, 0, 2, 2, '2025-10-06 17:56:31', '手动确认订单', '2025-10-08 11:42:57', '手动发货');

-- ----------------------------
-- Table structure for o_order_ship_list
-- ----------------------------
DROP TABLE IF EXISTS `o_order_ship_list`;
CREATE TABLE `o_order_ship_list`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `shop_type` int NOT NULL COMMENT '店铺类型',
  `shipper` int NOT NULL COMMENT '发货方 0 仓库发货 1 供应商发货',
  `ship_supplier_id` bigint NOT NULL DEFAULT 0 COMMENT '发货供应商ID（0自己发货）',
  `ship_supplier` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货供应商',
  `order_id` bigint NULL DEFAULT NULL COMMENT 'erp订单id',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单编号',
  `receiver_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人姓名',
  `receiver_mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人手机号',
  `address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人地址',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市',
  `town` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `buyer_memo` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家留言信息',
  `seller_memo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卖家留言信息',
  `ship_logistics_company` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流公司',
  `ship_logistics_company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流公司code',
  `ship_logistics_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流单号',
  `ship_status` int NOT NULL COMMENT '发货状态1：待发货，2：已发货，3已推送',
  `status` int NOT NULL COMMENT '状态0待备货1备货中2备货完成3已出库',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发货-备货表（取号发货加入备货清单、分配供应商发货加入备货清单）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_order_ship_list
-- ----------------------------
INSERT INTO `o_order_ship_list` VALUES (1, 1009, 300, 0, 0, '仓库发货', 41, '250929-351611154071222', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '极兔快递', 'JTSD', 'JT2300994000', 2, 3, '2025-10-08 11:42:57', '手动发货', '2025-10-08 15:58:59', '发货出库');

-- ----------------------------
-- Table structure for o_order_ship_list_item
-- ----------------------------
DROP TABLE IF EXISTS `o_order_ship_list_item`;
CREATE TABLE `o_order_ship_list_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `list_id` bigint NOT NULL COMMENT '外键id',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `shop_type` int NOT NULL COMMENT '店铺类型',
  `shipper` int NOT NULL DEFAULT 0 COMMENT '发货方 0 仓库发货 1 供应商发货',
  `ship_supplier_id` bigint NOT NULL DEFAULT 0 COMMENT '发货供应商ID（0自己发货）',
  `ship_supplier` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货供应商',
  `order_id` bigint NULL DEFAULT NULL COMMENT 'erp订单id',
  `order_item_id` bigint NULL DEFAULT NULL COMMENT 'erp订单itemid',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单编号',
  `original_sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '原始订单skuid',
  `goods_id` bigint NULL DEFAULT 0 COMMENT 'erp系统商品id',
  `sku_id` bigint NULL DEFAULT 0 COMMENT 'erp系统商品规格id',
  `goods_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题',
  `goods_img` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `goods_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品编码',
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品规格',
  `sku_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品规格编码',
  `quantity` int NOT NULL COMMENT '商品数量',
  `status` int NOT NULL COMMENT '状态0待备货1备货中2备货完成3已发货',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发货-备货表（打单加入备货清单）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_order_ship_list_item
-- ----------------------------
INSERT INTO `o_order_ship_list_item` VALUES (1, 1, 1009, 300, 0, 0, '仓库发货', 41, 51, '250929-351611154071222', '0', 0, 45, NULL, 'https://img.pddpic.com/mms-material-img/2025-05-29/a3e7e689-5c30-495c-b5e0-90e38bd352b5.jpeg.a.jpeg', 'LEDDX001', '12W白光-135mm', 'LEDDX00101', 1, 3, '2025-10-08 11:42:57', '手动发货', '2025-10-08 15:58:59', '备货完成');

-- ----------------------------
-- Table structure for o_refund
-- ----------------------------
DROP TABLE IF EXISTS `o_refund`;
CREATE TABLE `o_refund`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `refund_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '退货单号',
  `refund_type` int NULL DEFAULT NULL COMMENT '类型(1-售前退款 10-退货 20-换货 30-维修 40-大家电安装 50-大家电移机 60-大家电增值服务 70-上门维修 90-优鲜赔 80-补发商品 100-试用收回 11-仅退款)',
  `shop_id` bigint NULL DEFAULT NULL COMMENT '店铺id',
  `shop_type` int NULL DEFAULT NULL COMMENT '店铺类型',
  `order_amount` float NULL DEFAULT NULL COMMENT '订单金额',
  `refund_fee` float NOT NULL COMMENT '退款金额',
  `refund_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款原因',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '源订单号',
  `order_item_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子订单号或id',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '源skuId',
  `goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `sku_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku编码',
  `has_good_return` int NULL DEFAULT NULL COMMENT '买家是否需要退货。可选值:1(是),0(否)',
  `goods_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `goods_sku` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品sku',
  `goods_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `quantity` bigint NULL DEFAULT NULL COMMENT '退货数量',
  `return_logistics_company` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退货物流公司',
  `return_logistics_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退货物流单号',
  `receive_time` datetime NULL DEFAULT NULL COMMENT '收货时间',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `status` int NOT NULL COMMENT '状态（10001待审核 10002等待买家退货 10003等待平台审核 10004待买家处理 10005等待卖家处理 10006等待卖家发货 14000拒绝退款 10011退款关闭 10010退款完成 10020售后成功 10021售后失败 10090退款中 10091换货成功 10092换货失败 10093维修关闭 10094维修成功 ）',
  `create_time` datetime NOT NULL COMMENT '订单创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `erp_push_status` int NULL DEFAULT 0 COMMENT 'ERP推送状态(200成功，其他失败）',
  `erp_push_result` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'ERP推送状态结果',
  `erp_push_time` datetime NULL DEFAULT NULL COMMENT 'ERP最近推送时间',
  `has_processing` int NOT NULL DEFAULT 0 COMMENT '是否处理0未处理1已处理',
  `after_sale_id` bigint NULL DEFAULT NULL COMMENT '处理id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'OMS售后处理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_refund
-- ----------------------------

-- ----------------------------
-- Table structure for o_ship_waybill
-- ----------------------------
DROP TABLE IF EXISTS `o_ship_waybill`;
CREATE TABLE `o_ship_waybill`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `shop_type` int NOT NULL COMMENT '店铺类型',
  `waybill_order_id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '电子面单订单id(仅视频号)',
  `waybill_code` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '快递单号',
  `logistics_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '快递公司编码',
  `print_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '打印数据',
  `status` int NULL DEFAULT NULL COMMENT '状态（1已取号2已打印3已发货）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发货-电子面单记录表（打单记录）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_ship_waybill
-- ----------------------------

-- ----------------------------
-- Table structure for o_shipment
-- ----------------------------
DROP TABLE IF EXISTS `o_shipment`;
CREATE TABLE `o_shipment`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `shop_type` int NOT NULL COMMENT '店铺类型',
  `order_id` bigint NULL DEFAULT NULL COMMENT 'o_order表id',
  `order_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单编号',
  `order_time` datetime NULL DEFAULT NULL COMMENT '订单时间',
  `shipper` int NOT NULL DEFAULT 0 COMMENT '发货方 0 仓库发货 1 供应商发货',
  `supplier_id` bigint NOT NULL DEFAULT 0 COMMENT '供应商ID',
  `supplier` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `ship_type` int NULL DEFAULT NULL COMMENT '发货类型（1订单发货2商品补发3商品换货）',
  `ship_company` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流公司',
  `ship_company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '物流公司code',
  `ship_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流单号',
  `ship_fee` decimal(6, 2) NOT NULL DEFAULT 0.00 COMMENT '物流费用',
  `ship_time` datetime NULL DEFAULT NULL COMMENT '发货时间',
  `ship_operator` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货操作人',
  `ship_status` int NULL DEFAULT NULL COMMENT '物流状态（0 待发货1已发货2已完成）',
  `package_weight` float NULL DEFAULT NULL COMMENT '包裹重量',
  `package_length` float NULL DEFAULT NULL COMMENT '包裹长度',
  `package_width` float NULL DEFAULT NULL COMMENT '包裹宽度',
  `package_height` float NULL DEFAULT NULL COMMENT '包裹高度',
  `packsge_operator` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '打包操作人',
  `packsge_time` datetime NULL DEFAULT NULL COMMENT '打包时间',
  `packages` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '包裹内容JSON',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `update_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_id_index`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发货记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_shipment
-- ----------------------------
INSERT INTO `o_shipment` VALUES (1, 1009, 300, 41, '250929-351611154071222', '2025-09-29 21:22:48', 0, 0, NULL, 1, '极兔快递', 'JTSD', 'JT2300994000', 0.00, '2025-10-08 11:42:57', NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, NULL, '2025-10-08 11:42:57', 'admin', NULL, NULL);

-- ----------------------------
-- Table structure for o_shipment_item
-- ----------------------------
DROP TABLE IF EXISTS `o_shipment_item`;
CREATE TABLE `o_shipment_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id，自增',
  `shipment_id` bigint NOT NULL COMMENT '发货id',
  `shipper` int NOT NULL COMMENT '发货方 0 仓库发货 1 供应商发货',
  `supplier_id` bigint NOT NULL DEFAULT 0 COMMENT '供应商ID',
  `supplier` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `shop_type` int NOT NULL COMMENT '店铺类型',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `order_id` bigint NOT NULL COMMENT '订单 id',
  `order_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号',
  `order_time` datetime NULL DEFAULT NULL COMMENT '订单时间',
  `order_item_id` bigint NOT NULL COMMENT '订单itemID（o_order_item外键）',
  `erp_goods_id` bigint NOT NULL DEFAULT 0 COMMENT 'erp系统商品id',
  `erp_sku_id` bigint NOT NULL DEFAULT 0 COMMENT 'erp系统商品规格id',
  `goods_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题',
  `goods_img` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `goods_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品编码',
  `goods_spec` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品规格',
  `sku_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品规格编码',
  `quantity` int NOT NULL COMMENT '商品数量',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `stock_status` int NOT NULL COMMENT '仓库状态 0 备货中 1 已出库 2 已发走',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `goodId_index`(`erp_goods_id` ASC) USING BTREE,
  INDEX `order_id`(`order_item_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发货明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_shipment_item
-- ----------------------------
INSERT INTO `o_shipment_item` VALUES (1, 1, 0, 0, NULL, 300, 1009, 41, '250929-351611154071222', '2025-09-29 21:22:48', 51, 0, 0, NULL, 'https://img.pddpic.com/mms-material-img/2025-05-29/a3e7e689-5c30-495c-b5e0-90e38bd352b5.jpeg.a.jpeg', 'LEDDX001', '12W白光-135mm', 'LEDDX00101', 1, NULL, 0, '2025-10-08 11:42:57', 'admin', NULL, NULL);

-- ----------------------------
-- Table structure for o_shop
-- ----------------------------
DROP TABLE IF EXISTS `o_shop`;
CREATE TABLE `o_shop`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '店铺名',
  `type` int NOT NULL COMMENT '对应第三方平台Id',
  `url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '店铺url',
  `sort` int NOT NULL DEFAULT 9 COMMENT '排序',
  `status` int NULL DEFAULT 0 COMMENT '状态（1正常2已删除）',
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `seller_id` bigint NOT NULL DEFAULT 0 COMMENT '第三方平台店铺id，淘宝天猫开放平台使用',
  `app_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Appkey',
  `app_secret` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Appsercet',
  `access_token` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '第三方平台sessionKey（access_token）',
  `expires_in` bigint NULL DEFAULT NULL COMMENT '到期',
  `access_token_begin` bigint NULL DEFAULT NULL COMMENT 'access_token开始时间',
  `refresh_token` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '刷新token',
  `refresh_token_timeout` bigint NULL DEFAULT NULL COMMENT '刷新token过期时间',
  `api_request_url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求url',
  `api_redirect_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '回调url',
  `manage_user_id` bigint NULL DEFAULT NULL COMMENT '负责人id',
  `manage_dept_id` bigint NULL DEFAULT NULL COMMENT '负责人部门id',
  `region_id` bigint NOT NULL DEFAULT 0 COMMENT '国家/地区',
  `modify_on` bigint NOT NULL COMMENT '更新时间',
  `create_on` bigint NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1010 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '店铺表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_shop
-- ----------------------------
INSERT INTO `o_shop` VALUES (1007, '天猫测试', 100, NULL, 9, 1, NULL, 0, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1759286858, 1759286723);
INSERT INTO `o_shop` VALUES (1008, '京东POP测试', 200, NULL, 9, 1, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1759287467, 1759287467);
INSERT INTO `o_shop` VALUES (1009, '爱顾家的小店', 300, NULL, 9, 1, NULL, 0, NULL, NULL, 'b4f1d695397d428b883b4b7c1a2c55925cc36b24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1759287857, 1759287857);

-- ----------------------------
-- Table structure for o_shop_daily
-- ----------------------------
DROP TABLE IF EXISTS `o_shop_daily`;
CREATE TABLE `o_shop_daily`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL COMMENT '报表日期',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `platform_id` bigint NOT NULL COMMENT '平台id',
  `region_id` bigint NOT NULL COMMENT '国家/地区',
  `order_total` int NOT NULL COMMENT '订单总数',
  `order_amount` decimal(10, 2) NOT NULL COMMENT '订单总金额（当前货币）',
  `false_order_total` int NOT NULL COMMENT '刷单数量',
  `false_order_amount` decimal(10, 2) NOT NULL COMMENT '刷单金额（当前货币）',
  `false_order_amount1` decimal(10, 2) NULL DEFAULT NULL COMMENT '刷单金额（人民币）',
  `true_order_total` int NOT NULL COMMENT '真实订单数',
  `true_order_amount` decimal(10, 2) NOT NULL COMMENT '真实订单金额（当前货币）',
  `ad_fee` decimal(10, 2) NOT NULL COMMENT '广告支出',
  `ad_click` int NOT NULL COMMENT '广告点击',
  `ad_click_fee` decimal(10, 2) NOT NULL COMMENT '广告点击成本',
  `ad_roi` decimal(10, 2) NOT NULL COMMENT 'ROI',
  `unit_price` decimal(10, 2) NOT NULL COMMENT '平均客单价',
  `withdrawal_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '提现金额（当前货币）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '店铺日报' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_shop_daily
-- ----------------------------

-- ----------------------------
-- Table structure for o_shop_daily_detail
-- ----------------------------
DROP TABLE IF EXISTS `o_shop_daily_detail`;
CREATE TABLE `o_shop_daily_detail`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `daily_id` bigint NOT NULL COMMENT '日报id',
  `date` date NOT NULL COMMENT '报表日期',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `platform_id` bigint NOT NULL COMMENT '平台id',
  `region_id` bigint NOT NULL COMMENT '国家/地区',
  `sku_id` bigint NOT NULL COMMENT 'sku id',
  `sku_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku编码',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '产品名称',
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku名称',
  `order_total` int NOT NULL COMMENT '订单总数',
  `order_amount` decimal(10, 2) NOT NULL COMMENT '订单总金额（当前货币）',
  `false_order_total` int NOT NULL COMMENT '刷单数量',
  `false_order_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '刷单金额（当前货币）',
  `false_order_amount1` decimal(10, 2) NULL DEFAULT NULL COMMENT '刷单金额（人民币，包含服务费）',
  `true_order_total` int NULL DEFAULT NULL COMMENT '真实订单数',
  `true_order_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '真实订单金额（当前货币）',
  `ad_fee` decimal(10, 2) NOT NULL COMMENT '广告支出',
  `ad_click` int NOT NULL COMMENT '广告点击',
  `ad_click_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '广告点击成本',
  `ad_roi` decimal(10, 2) NULL DEFAULT NULL COMMENT 'ROI',
  `unit_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '平均客单价',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '店铺日报明细（sku级别）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_shop_daily_detail
-- ----------------------------

-- ----------------------------
-- Table structure for o_shop_platform
-- ----------------------------
DROP TABLE IF EXISTS `o_shop_platform`;
CREATE TABLE `o_shop_platform`  (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '平台名',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '平台编码',
  `app_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `app_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `redirect_uri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '平台回调uri',
  `server_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接口访问地址',
  `status` int NULL DEFAULT NULL COMMENT '状态（0启用1关闭）',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `region_id` bigint NULL DEFAULT NULL COMMENT '国家/地区',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '店铺平台配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_shop_platform
-- ----------------------------
INSERT INTO `o_shop_platform` VALUES (100, '淘宝天猫', 'TMALL', '', '', 'https://www.qihangerp.cn', 'http://gw.api.taobao.com/router/rest', 0, 0, 1);
INSERT INTO `o_shop_platform` VALUES (200, '京东POP', 'JD-POP', '', NULL, 'http://www.qihangerp.cn', 'https://api.jd.com/routerjson', 0, 0, 1);
INSERT INTO `o_shop_platform` VALUES (300, '拼多多', 'PDD', 'dc953bcf16d24b27abf3e64a59e1ecd1', '89c639b1ceaf8e5260acc73b2bdbb5c529cf23a4', 'https://qihangerp.cn', 'https://gw-api.pinduoduo.com/api/router', 0, 0, 1);
INSERT INTO `o_shop_platform` VALUES (400, '抖店', 'DOUDIAN', '7496863701597783592', '999b47a2-4991-48ba-b23f-9bc30172a6b3', 'http://www.qihangerp.cn', 'https://openapi-fxg.jinritemai.com/', 0, 0, 1);
INSERT INTO `o_shop_platform` VALUES (500, '微信小店', 'WEISHOP', '', NULL, 'http://www.qihangerp.cn', 'https://api.weixin.qq.com', 0, 0, 1);
INSERT INTO `o_shop_platform` VALUES (999, '其他渠道', 'OFFLINE', NULL, NULL, NULL, NULL, 1, 0, NULL);

-- ----------------------------
-- Table structure for o_shop_pull_lasttime
-- ----------------------------
DROP TABLE IF EXISTS `o_shop_pull_lasttime`;
CREATE TABLE `o_shop_pull_lasttime`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NULL DEFAULT NULL COMMENT '店铺id',
  `pull_type` enum('ORDER','REFUND','GOODS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类型（ORDER:订单，REFUND:退款）',
  `lasttime` datetime NULL DEFAULT NULL COMMENT '最后更新时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '店铺更新最后时间记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_shop_pull_lasttime
-- ----------------------------
INSERT INTO `o_shop_pull_lasttime` VALUES (1, 1007, 'ORDER', '2025-10-01 16:10:02', '2025-10-01 10:56:27', '2025-10-01 16:10:03');
INSERT INTO `o_shop_pull_lasttime` VALUES (2, 1007, 'GOODS', '2025-10-01 10:50:36', '2025-10-01 10:50:11', '2025-10-01 10:51:00');
INSERT INTO `o_shop_pull_lasttime` VALUES (3, 1009, 'ORDER', '2025-09-30 08:07:23', '2025-10-01 11:07:23', '2025-10-01 11:23:46');
INSERT INTO `o_shop_pull_lasttime` VALUES (4, 1009, 'GOODS', '2025-10-01 12:56:14', '2025-10-01 11:07:08', '2025-10-01 12:56:16');
INSERT INTO `o_shop_pull_lasttime` VALUES (5, 1007, 'REFUND', '2025-10-01 11:24:50', '2025-10-01 11:24:04', '2025-10-01 11:24:50');

-- ----------------------------
-- Table structure for o_shop_pull_logs
-- ----------------------------
DROP TABLE IF EXISTS `o_shop_pull_logs`;
CREATE TABLE `o_shop_pull_logs`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `shop_id` int NULL DEFAULT NULL COMMENT '店铺id',
  `shop_type` int NOT NULL COMMENT '平台id',
  `pull_type` enum('ORDER','REFUND','GOODS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类型（ORDER订单，GOODS商品，REFUND退款）',
  `pull_way` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拉取方式（主动拉取、定时任务）',
  `pull_params` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拉取参数',
  `pull_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '拉取结果',
  `pull_time` datetime NULL DEFAULT NULL COMMENT '拉取时间',
  `duration` bigint NULL DEFAULT NULL COMMENT '耗时（毫秒）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1973299356768198658 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '店铺更新日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_shop_pull_logs
-- ----------------------------
INSERT INTO `o_shop_pull_logs` VALUES (1973218858452750338, 1007, 100, 'GOODS', '主动拉取', '{PageNo:1,PageSize:100}', '{successTotal:119}', '2025-10-01 10:49:47', 23913);
INSERT INTO `o_shop_pull_logs` VALUES (1973219062555971585, 1007, 100, 'GOODS', '主动拉取', '{PageNo:1,PageSize:100}', '{successTotal:119}', '2025-10-01 10:50:36', 24238);
INSERT INTO `o_shop_pull_logs` VALUES (1973220434047229954, 1007, 100, 'ORDER', '主动拉取', '{startTime:2025-09-30T10:56:20,endTime:2025-10-01T10:56:20}', '{insert:40,update:0,fail:0}', '2025-10-01 10:56:21', 5835);
INSERT INTO `o_shop_pull_logs` VALUES (1973223120834486273, 1009, 300, 'GOODS', '主动拉取商品sku', '{startTime:null,endTime:null}', '{successTotal:10}', '2025-10-01 11:07:06', 977);
INSERT INTO `o_shop_pull_logs` VALUES (1973223185800060930, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-30T11:07:22.693461,endTime:2025-10-01T11:07:22.693461}', '{insert:0,update:0,fail:0}', '2025-10-01 11:07:23', 181);
INSERT INTO `o_shop_pull_logs` VALUES (1973224217523351554, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-28T10:07:23,endTime:2025-09-29T10:07:23}', '{insert:0,update:0,fail:0}', '2025-10-01 11:11:28', 843);
INSERT INTO `o_shop_pull_logs` VALUES (1973224244010381314, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-29T09:07:23,endTime:2025-09-30T09:07:23}', '{insert:0,update:0,fail:2}', '2025-10-01 11:11:35', 218);
INSERT INTO `o_shop_pull_logs` VALUES (1973224275601879041, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-29T09:07:23,endTime:2025-09-30T09:07:23}', '{insert:0,update:0,fail:2}', '2025-10-01 11:11:42', 210);
INSERT INTO `o_shop_pull_logs` VALUES (1973224605026709505, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-28T09:07:23,endTime:2025-09-29T09:07:23}', '{insert:0,update:0,fail:0}', '2025-10-01 11:12:34', 26944);
INSERT INTO `o_shop_pull_logs` VALUES (1973225223619440641, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-29T08:07:23,endTime:2025-09-30T08:07:23}', '{insert:0,update:0,fail:2}', '2025-10-01 11:13:48', 101206);
INSERT INTO `o_shop_pull_logs` VALUES (1973225403668328450, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-29T08:07:23,endTime:2025-09-30T08:07:23}', '{insert:0,update:0,fail:2}', '2025-10-01 11:15:31', 40436);
INSERT INTO `o_shop_pull_logs` VALUES (1973226544598675457, 1009, 300, 'GOODS', '主动拉取商品sku', '{startTime:2025-09-24T11:07:08,endTime:2025-10-01T11:20:41.946310900}', '{successTotal:10}', '2025-10-01 11:20:42', 1730);
INSERT INTO `o_shop_pull_logs` VALUES (1973227309039939586, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-29T08:07:23,endTime:2025-09-30T08:07:23}', '{insert:2,update:0,fail:0}', '2025-10-01 11:23:42', 3541);
INSERT INTO `o_shop_pull_logs` VALUES (1973227384306724865, 1007, 100, 'REFUND', '主动拉取', '{startTime:2025-09-30T11:24:03.025533400,endTime:2025-10-01T11:24:03.025533400}', '{insert:4,update:0,fail:0}', '2025-10-01 11:24:03', 849);
INSERT INTO `o_shop_pull_logs` VALUES (1973227551042891778, 1007, 100, 'REFUND', '主动拉取', '{startTime:2025-10-01T10:24:03,endTime:2025-10-01T11:24:43.246316700}', '{insert:0,update:1,fail:0}', '2025-10-01 11:24:43', 402);
INSERT INTO `o_shop_pull_logs` VALUES (1973227577492172802, 1007, 100, 'REFUND', '主动拉取', '{startTime:2025-10-01T10:24:43,endTime:2025-10-01T11:24:49.599735900}', '{insert:0,update:1,fail:0}', '2025-10-01 11:24:50', 345);
INSERT INTO `o_shop_pull_logs` VALUES (1973228990511247361, 1009, 400, 'REFUND', '主动拉取退款', '{startTime:2025-10-01T11:00:26.567753200,endTime:2025-10-01T11:30:26.567753200}', '结束时间和开始时间范围太大，请缩小范围', '2025-10-01 11:30:27', 254);
INSERT INTO `o_shop_pull_logs` VALUES (1973250539771449345, 1009, 300, 'GOODS', '主动拉取商品sku', '{startTime:2025-09-24T11:20:42,endTime:2025-10-01T12:56:02.568389800}', '{successTotal:10}', '2025-10-01 12:56:03', 2003);
INSERT INTO `o_shop_pull_logs` VALUES (1973250585430642689, 1009, 300, 'GOODS', '主动拉取商品sku', '{startTime:2025-09-24T12:56:03,endTime:2025-10-01T12:56:14.013894300}', '{successTotal:10}', '2025-10-01 12:56:14', 1448);
INSERT INTO `o_shop_pull_logs` VALUES (1973295260355104769, 1007, 100, 'ORDER', '主动拉取', '{startTime:2025-10-01T09:56:21,endTime:2025-10-01T15:53:44}', '{insert:12,update:0,fail:0}', '2025-10-01 15:53:44', 2336);
INSERT INTO `o_shop_pull_logs` VALUES (1973295330425147393, 1007, 100, 'ORDER', '主动拉取', '{startTime:2025-10-01T14:53:45,endTime:2025-10-01T15:54:02}', '{insert:0,update:4,fail:0}', '2025-10-01 15:54:03', 660);
INSERT INTO `o_shop_pull_logs` VALUES (1973299108058533890, 1007, 100, 'ORDER', '主动拉取', '{startTime:2025-10-01T14:54:03,endTime:2025-10-01T16:09:03}', '{insert:4,update:0,fail:0}', '2025-10-01 16:09:03', 705);
INSERT INTO `o_shop_pull_logs` VALUES (1973299356768198657, 1007, 100, 'ORDER', '主动拉取', '{startTime:2025-10-01T15:09:03,endTime:2025-10-01T16:10:02}', '{insert:4,update:0,fail:0}', '2025-10-01 16:10:02', 1358);

-- ----------------------------
-- Table structure for o_shop_region
-- ----------------------------
DROP TABLE IF EXISTS `o_shop_region`;
CREATE TABLE `o_shop_region`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地区名称',
  `exchange_rate` float NULL DEFAULT NULL COMMENT '汇率',
  `num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地区编码',
  `status` int NULL DEFAULT NULL COMMENT '状态0正常1禁用',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '店铺地区表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of o_shop_region
-- ----------------------------
INSERT INTO `o_shop_region` VALUES (1, '中国', 1, '86', 0, '2025-02-10 10:42:54', 'system', '2025-02-10 10:42:57', NULL);

-- ----------------------------
-- Table structure for offline_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `offline_goods_sku`;
CREATE TABLE `offline_goods_sku`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键sku id',
  `o_goods_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `shop_id` bigint NULL DEFAULT NULL COMMENT '店铺id',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名',
  `sku_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '规格名',
  `sku_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规格编码',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方平台skuId',
  `color_id` bigint NULL DEFAULT 0 COMMENT '颜色id',
  `color_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '颜色值',
  `color_image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '颜色图片',
  `size_id` bigint NULL DEFAULT 0 COMMENT '尺码id',
  `size_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '尺码值(材质)',
  `style_id` bigint NULL DEFAULT 0 COMMENT '款式id',
  `style_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '款式值',
  `bar_code` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '库存条形码',
  `sale_price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '售价',
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sku_id_unique`(`o_goods_sku_id` ASC) USING BTREE,
  INDEX `id`(`id` ASC) USING BTREE,
  INDEX `number`(`sku_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'OMS商品SKU表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of offline_goods_sku
-- ----------------------------

-- ----------------------------
-- Table structure for offline_order
-- ----------------------------
DROP TABLE IF EXISTS `offline_order`;
CREATE TABLE `offline_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单id，自增',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号（第三方平台订单号）',
  `shop_id` bigint NOT NULL COMMENT '店铺ID',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单备注',
  `buyer_memo` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家留言信息',
  `seller_memo` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卖家留言信息',
  `tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签',
  `refund_status` int NOT NULL COMMENT '售后状态 1：无售后或售后关闭，2：售后处理中，3：退款中，4： 退款成功 ',
  `order_status` int NOT NULL COMMENT '订单状态0：新订单，1：待发货，2：已发货，3：已完成，11已取消；12退款中；21待付款；22锁定，29删除，101部分发货',
  `goods_amount` double NULL DEFAULT NULL COMMENT '订单商品金额',
  `post_fee` double NULL DEFAULT NULL COMMENT '订单运费',
  `amount` double NOT NULL COMMENT '订单实际金额',
  `seller_discount` double NULL DEFAULT 0 COMMENT '商家优惠金额，单位：元',
  `platform_discount` double NULL DEFAULT 0 COMMENT '平台优惠金额，单位：元',
  `payment` double NULL DEFAULT NULL COMMENT '实付金额',
  `receiver_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人姓名',
  `receiver_mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人手机号',
  `address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人地址',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市',
  `town` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区',
  `order_time` datetime NULL DEFAULT NULL COMMENT '订单时间',
  `ship_type` int NOT NULL COMMENT '发货类型（0仓库发货；1供应商代发）',
  `shipping_time` datetime NULL DEFAULT NULL COMMENT '发货时间',
  `shipping_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '快递单号',
  `shipping_company` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流公司',
  `shipping_man` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货人',
  `shipping_cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '发货费用',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `oms_push_status` int NULL DEFAULT 0 COMMENT 'OMS推送状态(1已推送0未推送）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_sn_index`(`order_num` ASC) USING BTREE,
  INDEX `shopid_index`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '线下渠道订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of offline_order
-- ----------------------------

-- ----------------------------
-- Table structure for offline_order_item
-- ----------------------------
DROP TABLE IF EXISTS `offline_order_item`;
CREATE TABLE `offline_order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id，自增',
  `order_id` bigint NOT NULL COMMENT '订单ID（o_order外键）',
  `order_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号（第三方平台）',
  `sub_order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '子订单号（第三方平台）',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方平台skuId',
  `goods_id` bigint NOT NULL DEFAULT 0 COMMENT '商品id(o_goods外键)',
  `goods_sku_id` bigint NOT NULL DEFAULT 0 COMMENT '商品skuid(o_goods_sku外键)',
  `goods_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题',
  `goods_img` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `goods_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品编码',
  `goods_spec` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品规格',
  `sku_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品规格编码',
  `goods_price` double NOT NULL COMMENT '商品单价',
  `item_amount` double NULL DEFAULT NULL COMMENT '子订单金额',
  `payment` double NULL DEFAULT NULL COMMENT '实际支付金额',
  `quantity` int NOT NULL COMMENT '商品数量',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `refund_count` int NULL DEFAULT 0 COMMENT '已退货数量',
  `refund_status` int NULL DEFAULT NULL COMMENT '售后状态 1：无售后或售后关闭，2：售后处理中，3：退款中，4： 退款成功 ',
  `order_status` int NULL DEFAULT NULL COMMENT '订单状态1：待发货，2：已发货，3：已完成，11已取消；21待付款',
  `has_push_erp` int NULL DEFAULT 0 COMMENT '是否推送到ERP',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `goodId_index`(`goods_id` ASC) USING BTREE,
  INDEX `order_id`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '渠道订单明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of offline_order_item
-- ----------------------------

-- ----------------------------
-- Table structure for offline_refund
-- ----------------------------
DROP TABLE IF EXISTS `offline_refund`;
CREATE TABLE `offline_refund`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `type` int NOT NULL COMMENT '类型（10退货退款；11仅退款；20换货；）',
  `shop_id` int NOT NULL COMMENT '店铺id',
  `refund_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '退款单号',
  `order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `order_item_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '子订单号',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单id',
  `status` int NULL DEFAULT NULL COMMENT '状态（10005等待卖家处理 10006等待卖家发货 10011退款关闭 10010退款完成 10020售后成功 10021售后失败 10090退款中 10091换货成功 10092换货失败 ）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `update_by` datetime NULL DEFAULT NULL,
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方平台skuId',
  `goods_id` bigint NOT NULL DEFAULT 0 COMMENT '商品id(o_goods外键)',
  `goods_sku_id` bigint NOT NULL DEFAULT 0 COMMENT '商品skuid(o_goods_sku外键)',
  `goods_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题',
  `goods_img` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `goods_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品编码',
  `goods_spec` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品规格',
  `sku_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品规格编码',
  `item_amount` double NULL DEFAULT NULL COMMENT '子订单金额',
  `refund_fee` float NOT NULL COMMENT '退款金额',
  `has_good_return` int NOT NULL COMMENT '买家是否需要退货。可选值:1(是),0(否)',
  `refund_quantity` bigint NOT NULL COMMENT '退货数量',
  `return_logistics_company` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退货物流公司',
  `return_logistics_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退货物流单号',
  `receive_time` datetime NULL DEFAULT NULL COMMENT '收货时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '线下渠道退款表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of offline_refund
-- ----------------------------

-- ----------------------------
-- Table structure for oms_dou_goods
-- ----------------------------
DROP TABLE IF EXISTS `oms_dou_goods`;
CREATE TABLE `oms_dou_goods`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NULL DEFAULT NULL COMMENT '店铺id',
  `product_id` bigint NULL DEFAULT NULL COMMENT '商品ID，抖店系统生成，店铺下唯一',
  `product_type` int NULL DEFAULT NULL COMMENT '商品类型；0-普通；1-新客商品；3-虚拟；6-玉石闪购；7-云闪购 ；127-其他类型；',
  `name` varchar(85) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题。',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品主图的第一张图',
  `check_status` int NULL DEFAULT NULL COMMENT '商品审核状态: 1-未提交；2-待审核；3-审核通过；4-审核未通过；5-封禁；7-审核通过待上架；',
  `market_price` bigint NULL DEFAULT NULL,
  `discount_price` bigint NULL DEFAULT NULL,
  `status` int NULL DEFAULT NULL COMMENT '商品在店铺中状态: 0-在线；1-下线；2-删除；',
  `spec_id` bigint NULL DEFAULT NULL COMMENT '商品规格，全局唯一',
  `create_time` int NULL DEFAULT NULL COMMENT '商品创建时间，unix时间戳，单位：秒；',
  `update_time` int NULL DEFAULT NULL COMMENT '商品更新时间，unix时间戳，单位：秒；',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '商品详情，最大支持50张图片，单张详情图宽高比不超2000*2000px，大小5M内，仅支持jpg/jpeg/png格式；',
  `category_detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '类目详情；商品类目id可使用【/shop/getShopCategory】查询',
  `outer_product_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '外部商家编码，商家自定义字段，支持最多 255个字符',
  `is_package_product` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否是组合商品，true-是，false-不是；',
  `erp_goods_id` bigint NULL DEFAULT NULL COMMENT 'erp商品id',
  `pull_time` datetime NULL DEFAULT NULL COMMENT '拉取时间',
  `modify_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '抖店商品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_dou_goods
-- ----------------------------

-- ----------------------------
-- Table structure for oms_dou_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `oms_dou_goods_sku`;
CREATE TABLE `oms_dou_goods_sku`  (
  `id` bigint NOT NULL COMMENT '商品sku_id;抖店系统生成。',
  `product_id` bigint NULL DEFAULT NULL COMMENT '商品ID；抖店系统生成。',
  `name` varchar(85) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题。',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品主图的第一张图',
  `spec_id` bigint NULL DEFAULT NULL COMMENT '规格ID',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku外部编码',
  `sku_type` int NULL DEFAULT NULL COMMENT '库存类型；0-普通；1-区域库存；10-阶梯库存；',
  `sku_status` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku状态 true上架 false下架',
  `out_sku_id` bigint NULL DEFAULT NULL COMMENT '外部的skuId；商家自定义；未设置返回为0。',
  `spec_detail_id1` bigint NULL DEFAULT NULL COMMENT '第一级子规格',
  `spec_detail_id2` bigint NULL DEFAULT NULL COMMENT '第二级子规格',
  `spec_detail_id3` bigint NULL DEFAULT NULL COMMENT '\r\n第三级子规格',
  `spec_detail_name1` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第一级子规格名',
  `spec_detail_name2` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第二级子规格名',
  `spec_detail_name3` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '\r\n第三级子规格名',
  `price` int NULL DEFAULT NULL COMMENT '商品价格，单位：分',
  `create_time` int NULL DEFAULT NULL COMMENT '创建时间，时间戳：单位秒；',
  `stock_num` int NULL DEFAULT NULL COMMENT 'ku_type=0时，表示普通库存数量 ;sku_type=1时，使用stock_map，表示区域库存数量',
  `prehold_stock_num` int NULL DEFAULT NULL COMMENT 'sku_type=0时，表示预占库存数量； sku_type=1时，表示区域库存数量，使用prehold_stock_map',
  `prom_stock_num` int NULL DEFAULT NULL COMMENT '活动库存',
  `step_stock_num` int NULL DEFAULT NULL COMMENT '\r\n阶梯库存',
  `prehold_step_stock_num` int NULL DEFAULT NULL COMMENT '预占阶梯库存',
  `prom_step_stock_num` int NULL DEFAULT NULL COMMENT '活动阶梯库存',
  `normal_stock_num` int NULL DEFAULT NULL COMMENT '库存模型V2新增 普通库存 非活动可售',
  `channel_stock_num` int NULL DEFAULT NULL COMMENT '库存模型V2新增 渠道库存',
  `sell_properties` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '销售属性，代替spec_detail_id123、spec_detail_name123',
  `erp_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `erp_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `shop_id` bigint NULL DEFAULT NULL COMMENT '店铺id',
  `pull_time` datetime NULL DEFAULT NULL COMMENT '拉取时间',
  `modify_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '抖店商品Sku表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_dou_goods_sku
-- ----------------------------

-- ----------------------------
-- Table structure for oms_dou_order
-- ----------------------------
DROP TABLE IF EXISTS `oms_dou_order`;
CREATE TABLE `oms_dou_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '店铺父订单号，抖店平台生成，平台下唯一；',
  `order_level` int NULL DEFAULT NULL COMMENT '订单层级，主订单是2级',
  `order_phase_list` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '定金预售阶段单json',
  `order_status` int NULL DEFAULT NULL COMMENT '订单状态1 待确认/待支付（订单创建完毕）105 已支付 2 备货中 101 部分发货 3 已发货（全部发货）4 已取消5 已完成（已收货）',
  `order_status_desc` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单状态描述',
  `order_tag` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '\r\n订单的一些c端标签json',
  `order_type` int NULL DEFAULT NULL COMMENT '【订单类型】 0、普通订单 2、虚拟商品订单 4、电子券（poi核销） 5、三方核销',
  `order_type_desc` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单类型描述',
  `app_id` int NULL DEFAULT NULL COMMENT '具体某个小程序的ID',
  `open_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '抖音小程序ID',
  `accept_order_status` int NULL DEFAULT NULL COMMENT '小时达订单的接单状态 0-未接单；1-已接单；2-超时取消，或商家取消',
  `appointment_ship_time` int NULL DEFAULT NULL COMMENT '预约发货时间',
  `author_cost_amount` int NULL DEFAULT NULL COMMENT '作者（达人）承担金额（单位：分），订单参与活动和优惠中作者（达人）承担部分的总金额',
  `aweme_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '达人抖音号，样品订单场景下才会返回的申样达人信息；',
  `b_type` int NULL DEFAULT NULL COMMENT '【下单端】 0、站外 1、火山 2、抖音 3、头条 4、西瓜 5、微信 6、值点app 7、头条lite 8、懂车帝 9、皮皮虾 11、抖音极速版 12、TikTok 13、musically 14、穿山甲 15、火山极速版 16、服务市场 26、番茄小说 27、UG教育营销电商平台 28、Jumanji 29、电商SDK',
  `b_type_desc` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '下单端描述',
  `sub_b_type` int NULL DEFAULT NULL COMMENT '【下单场景】 0、未知 1、app内-原生 2、app内-小程序 3、H5 13、电商SDK-头条 35、电商SDK-头条lite',
  `sub_b_type_desc` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '下单场景描述',
  `biz` int NULL DEFAULT NULL COMMENT '【业务来源】 1 -鲁班 2 -小店 3 -好好学习 4 -ev 5 -虚拟 6 -建站 7 -核销 8 -玉石 9 -ez 10 -ep 11 -虚拟卡券 12 -服务市场 13 - EP 视频课 14 - EP 直播课 21 -跨境BBC 22 -跨境BC 23 -跨境CC|UPU 24 -手机充值 25 -拍卖保证金 26 -懂车帝抵扣券 27 -懂车帝返现券 28 -离岛免税 29 -海南会员购 30 -抽奖 31 -清北-企业代付 32 -抖+券 33 -联盟寄样 49 -刀剑 53 -通信卡 66 -加油包 76 -大闸蟹 99 -保险 102-小店海外 108-上门取件收款',
  `biz_desc` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务来源描述',
  `buyer_words` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家留言',
  `seller_words` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '商家备注',
  `seller_remark_stars` int NULL DEFAULT NULL COMMENT '插旗信息：0-灰 1-紫 2-青 3-绿 4-橙 5-红',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '取消原因',
  `channel_payment_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付渠道的流水号',
  `create_time` int NULL DEFAULT NULL COMMENT '下单时间，时间戳，秒',
  `pay_time` int NULL DEFAULT NULL COMMENT '支付时间，时间戳，秒',
  `update_time` int NULL DEFAULT NULL COMMENT '订单更新时间，时间戳，秒',
  `finish_time` int NULL DEFAULT NULL COMMENT '订单完成时间，时间戳，秒',
  `order_expire_time` int NULL DEFAULT NULL COMMENT '订单过期时间，时间戳，秒',
  `doudian_open_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户唯一id',
  `encrypt_post_receiver` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '收件人姓名',
  `encrypt_post_tel` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '收件人电话',
  `encrypt_post_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件地址',
  `exp_ship_time` int NULL DEFAULT NULL COMMENT '预计发货时间，时间戳，秒',
  `logistics_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '物流信息JSON',
  `main_status` int NULL DEFAULT NULL COMMENT '主流程状态，1 待确认/待支付（订单创建完毕）103 部分支付105 已支付2 备货中101 部分发货3 已发货（全部发货）4 已取消5 已完成（已收货）21 发货前退款完结22 发货后退款完结39 收货后退款完结',
  `main_status_desc` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '主流程状态描述',
  `mask_post_receiver` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人姓名（脱敏后）',
  `mask_post_tel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人电话（脱敏后）',
  `mask_post_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收件人地址（脱敏后）',
  `province_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省',
  `province_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `city_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `city_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `town_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `town_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `street_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `street_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `open_address_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标识收件人地址的id，可用于合单',
  `modify_amount` int NULL DEFAULT NULL COMMENT '改价金额变化量（单位：分）',
  `modify_post_amount` int NULL DEFAULT NULL COMMENT '改价运费金额变化量（单位：分）',
  `only_platform_cost_amount` int NULL DEFAULT NULL COMMENT '仅平台承担金额（单位：分），订单参与活动和优惠中平台承担部分的总金额',
  `order_amount` int NULL DEFAULT NULL COMMENT '订单金额（单位：分）',
  `pay_amount` int NULL DEFAULT NULL COMMENT '支付金额（单位：分）',
  `pay_type` int NULL DEFAULT NULL COMMENT '7=无需支付（0元单）；8=DOU分期（信用支付）；9=新卡支付；12=先用后付；16=收银台支付',
  `post_amount` int NULL DEFAULT NULL COMMENT '快递费（单位：分）',
  `post_insurance_amount` int NULL DEFAULT NULL COMMENT '运费险金额（单位：分）',
  `post_origin_amount` int NULL DEFAULT NULL COMMENT '运费原价（单位：分），post_origin_amount = post_amount + post_promotion_amount',
  `post_promotion_amount` int NULL DEFAULT NULL COMMENT '运费优惠金额（单位：分）',
  `promotion_amount` int NULL DEFAULT NULL COMMENT '订单优惠总金额（单位：分） = 店铺优惠金额 + 平台优惠金额 + 达人优惠金额',
  `promotion_pay_amount` int NULL DEFAULT NULL COMMENT '支付优惠金额（单位：分），支付渠道上的优惠金额',
  `promotion_platform_amount` int NULL DEFAULT NULL COMMENT '平台优惠金额（单位：分），属于平台的优惠活动、优惠券、红包的总优惠金额',
  `promotion_redpack_amount` int NULL DEFAULT NULL COMMENT '红包优惠金额（单位：分）',
  `promotion_redpack_platform_amount` int NULL DEFAULT NULL COMMENT '平台红包优惠金额（单位：分），属于平台的红包的优惠金额',
  `promotion_redpack_talent_amount` int NULL DEFAULT NULL COMMENT '达人红包优惠金额（单位：分），属于达人的红包的优惠金额',
  `promotion_shop_amount` int NULL DEFAULT NULL COMMENT '店铺优惠金额（单位：分），属于店铺的优惠活动、优惠券、红包的总优惠金额',
  `promotion_talent_amount` int NULL DEFAULT NULL COMMENT '达人优惠金额（单位：分），属于达人的优惠活动、优惠券、红包的总优惠金额',
  `ship_time` int NULL DEFAULT NULL COMMENT '发货时间，时间戳，秒',
  `shop_cost_amount` int NULL DEFAULT NULL COMMENT '商家承担金额（单位：分），订单参与活动和优惠中商家承担部分的总金额',
  `platform_cost_amount` int NULL DEFAULT NULL COMMENT '平台承担金额（单位：分），订单参与活动和优惠中平台+作者（达人）承担部分的总金额,包含作者（达人）承担金额：platform_cost_amount = only_platform_cost_amount + author_cost_amount',
  `shop_id` bigint NULL DEFAULT NULL COMMENT '店铺id，抖店平台生成，平台下唯一；',
  `shop_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商户名称',
  `total_promotion_amount` int NULL DEFAULT NULL COMMENT '总优惠金额（单位：分），total_promotion_amount = promotion_amount + post_promotion_amount',
  `user_tag_ui` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '用户特征标签；JSON',
  `s_shop_id` bigint NULL DEFAULT NULL COMMENT '系统店铺id',
  `pull_time` datetime NULL DEFAULT NULL COMMENT '第一次拉取时间',
  `last_pull_time` datetime NULL DEFAULT NULL COMMENT '最后一次拉取时间',
  `audit_status` int NOT NULL DEFAULT 0 COMMENT '0待确认，1已确认2已拦截-9未拉取',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `oms_push_status` int NULL DEFAULT 0 COMMENT 'oms订单库推送状态0未推送1已推送2推送失败',
  `oms_push_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT 'oms订单库推送结果',
  `oms_push_time` datetime NULL DEFAULT NULL COMMENT 'oms订单库推送时间（记录最后一次）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_id_index`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '抖店订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_dou_order
-- ----------------------------

-- ----------------------------
-- Table structure for oms_dou_order_item
-- ----------------------------
DROP TABLE IF EXISTS `oms_dou_order_item`;
CREATE TABLE `oms_dou_order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '店铺子订单号，抖店平台生成，平台下唯一；注意：一笔订单下有一个子订单和父订单单号相同。',
  `parent_order_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '店铺父订单号，抖店平台生成，平台下唯一；',
  `order_level` int NULL DEFAULT NULL COMMENT '订单层级',
  `ad_env_type` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '广告来源，video-短视频 live-直播',
  `after_sale_status` int NULL DEFAULT NULL COMMENT '售后状态；6-售后申请；27-拒绝售后申请；12-售后成功；7-售后退货中；11-售后已发货；29-售后退货拒绝；13-【换货返回：换货售后换货商家发货】，【补寄返回：补寄待用户收货】； 14-【换货返回：（换货）售后换货用户收货】，【补寄返回：（补寄）用户已收货】 ；28-售后失败；51-订单取消成功；53-逆向交易已完成；',
  `after_sale_type` int NULL DEFAULT NULL COMMENT '售后类型 ；0-退货退款;1-已发货仅退款;2-未发货仅退款;3-换货;4-系统取消;5-用户取消;6-价保;7-补寄;',
  `refund_status` int NULL DEFAULT NULL COMMENT '退款状态:1-待退款；3-退款成功； 4-退款失败；当买家发起售后后又主动取消售后，此时after_sale_status=28并且refund_status=1的状态不变，不会流转至4状态；',
  `author_cost_amount` int NULL DEFAULT NULL COMMENT '作者（达人）承担金额（单位：分），订单参与活动和优惠中作者（达人）承担部分的总金额',
  `author_id` bigint NULL DEFAULT NULL COMMENT '直播主播id（达人）;仅直播间和橱窗产生的订单会有值返回;',
  `author_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '直播主播名称;仅直播间和橱窗产生的订单会有值返回',
  `c_biz` int NULL DEFAULT NULL COMMENT '【C端流量来源】 0-unknown 2-精选联盟 8-小店自卖',
  `c_biz_desc` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'C端流量来源业务类型描述',
  `cancel_reason` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '\r\n取消原因',
  `channel_payment_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付渠道的流水号',
  `code` varchar(88) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家后台商品编码',
  `confirm_receipt_time` int NULL DEFAULT NULL COMMENT '用户确认收货时间',
  `finish_time` int NULL DEFAULT NULL COMMENT '订单完成时间，时间戳，秒',
  `goods_price` int NULL DEFAULT NULL COMMENT '\r\n商品原价（单位：分）',
  `goods_type` int NULL DEFAULT NULL COMMENT '【商品类型】 0-实体 1-虚拟',
  `is_comment` int NULL DEFAULT NULL COMMENT '\r\n是否评价 :1-已评价，0-未评价，2 -追评',
  `item_num` int NULL DEFAULT NULL COMMENT '订单商品数量',
  `logistics_receipt_time` int NULL DEFAULT NULL COMMENT '物流收货时间 ',
  `modify_amount` int NULL DEFAULT NULL COMMENT '\r\n改价金额变化量（单位：分）',
  `modify_post_amount` int NULL DEFAULT NULL COMMENT '改价运费金额变化量（单位：分）',
  `only_platform_cost_amount` int NULL DEFAULT NULL COMMENT '仅平台承担金额（单位：分），订单参与活动和优惠中平台承担部分的总金额',
  `order_amount` int NULL DEFAULT NULL COMMENT '订单金额（单位：分）',
  `pay_amount` int NULL DEFAULT NULL COMMENT '支付金额（单位：分）',
  `post_insurance_amount` int NULL DEFAULT NULL COMMENT '运费险金额（单位：分）',
  `promotion_amount` int NULL DEFAULT NULL COMMENT '订单优惠总金额（单位：分） = 店铺优惠金额 + 平台优惠金额 + 达人优惠金额',
  `promotion_shop_amount` int NULL DEFAULT NULL COMMENT '店铺优惠金额（单位：分），属于店铺的优惠活动、优惠券、红包的总优惠金额',
  `promotion_platform_amount` int NULL DEFAULT NULL COMMENT '平台优惠金额（单位：分），属于平台的优惠活动、优惠券、红包的总优惠金额',
  `shop_cost_amount` int NULL DEFAULT NULL COMMENT '商家承担金额（单位：分），订单参与活动和优惠中商家承担部分的总金额',
  `platform_cost_amount` int NULL DEFAULT NULL COMMENT '平台承担金额（单位：分），订单参与活动和优惠中平台+作者（达人）承担部分的总金额,包含作者（达人）承担金额：platform_cost_amount = only_platform_cost_amount + author_cost_amount',
  `promotion_talent_amount` int NULL DEFAULT NULL COMMENT '达人优惠金额（单位：分），属于达人的优惠活动、优惠券、红包的总优惠金额',
  `promotion_pay_amount` int NULL DEFAULT NULL COMMENT '支付优惠金额（单位：分），支付渠道上的优惠金额',
  `origin_amount` int NULL DEFAULT NULL COMMENT '商品现价（单位：分）',
  `out_product_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品外部编码',
  `out_sku_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '外部Skuid',
  `product_id` bigint NULL DEFAULT NULL COMMENT '商品ID',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuId',
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `product_pic` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `promotion_redpack_amount` int NULL DEFAULT NULL COMMENT '平台优惠金额（单位：分），属于平台的优惠活动、优惠券、红包的总优惠金额',
  `promotion_redpack_platform_amount` int NULL DEFAULT NULL COMMENT '平台红包优惠金额（单位：分），属于平台的红包的优惠金额',
  `promotion_redpack_talent_amount` int NULL DEFAULT NULL COMMENT '达人红包优惠金额（单位：分），属于达人的红包的优惠金额',
  `room_id` bigint NULL DEFAULT NULL COMMENT '直播间id，有值则代表订单来自直播间',
  `ship_time` int NULL DEFAULT NULL COMMENT '\r\n发货时间',
  `spec` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '规格信息JSON',
  `theme_type_desc` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '下单来源描述（废弃）',
  `update_time` int NULL DEFAULT NULL COMMENT '订单更新时间，时间戳，秒',
  `create_time` int NULL DEFAULT NULL COMMENT '下单时间，时间戳，秒',
  `video_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '视频id，有值则代表订单来自短视频video_id',
  `o_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_id_index`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '抖店订单明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_dou_order_item
-- ----------------------------

-- ----------------------------
-- Table structure for oms_dou_refund
-- ----------------------------
DROP TABLE IF EXISTS `oms_dou_refund`;
CREATE TABLE `oms_dou_refund`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '售后订单id，自增',
  `shop_id` bigint NOT NULL COMMENT '订单所属商户id',
  `aftersale_id` bigint NOT NULL DEFAULT 0 COMMENT '售后id',
  `aftersale_order_type` bigint NULL DEFAULT NULL COMMENT '售后订单类型，枚举为-1(历史订单),1(商品单),2(店铺单)',
  `aftersale_type` bigint NOT NULL COMMENT '售后类型；0-退货退款；1-已发货仅退款；2-未发货仅退款；3-换货；6-价保；7-补寄；8-维修',
  `aftersale_status` bigint NOT NULL COMMENT '售后状态和请求参数standard_aftersale_status字段对应；3-换货待买家收货；6-待商家同意；7-待买家退货；8-待商家发货；11-待商家二次同意；12-售后成功；14-换货成功；27-商家一次拒绝；28-售后失败；29-商家二次拒绝；',
  `aftersale_status_to_final_time` bigint NULL DEFAULT NULL COMMENT '售后完结时间，完结时间是平台根据商品的类型，售后状态等综合判断生成，当售后单有完结时间返回时售后单不可再做任何操作；未完结售后单的该字段值为0；Unix时间戳：秒',
  `related_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '\r\n关联的订单ID',
  `order_sku_order_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '抖音子订单id',
  `order_status` bigint NULL DEFAULT NULL COMMENT '订单状态',
  `order_pay_amount` bigint NULL DEFAULT NULL COMMENT '付款金额',
  `order_post_amount` bigint NULL DEFAULT NULL COMMENT '\r\n付运费金额',
  `order_item_num` bigint NULL DEFAULT NULL COMMENT '购买数量',
  `order_product_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名',
  `order_product_image` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `order_product_id` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品id',
  `order_sku_spec` varchar(550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品规格JSON',
  `order_shop_sku_code` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家SKU编码',
  `apply_time` bigint NULL DEFAULT NULL COMMENT '申请时间',
  `update_time` bigint NULL DEFAULT NULL COMMENT '最近更新时间',
  `status_deadline` bigint NULL DEFAULT NULL COMMENT '当前节点逾期时间',
  `refund_amount` bigint NULL DEFAULT NULL COMMENT '售后退款金额，单位为分',
  `refund_post_amount` bigint NULL DEFAULT NULL COMMENT '售后退运费金额，单位为分',
  `aftersale_num` bigint NULL DEFAULT NULL COMMENT '\r\n售后数量',
  `part_type` bigint NULL DEFAULT NULL COMMENT '部分退类型',
  `aftersale_refund_type` bigint NULL DEFAULT NULL COMMENT '售后退款类型，枚举为-1(历史数据默认值),0(订单货款/原路退款),1(货到付款线下退款),2(备用金),3(保证金),4(无需退款),5(平台垫付)',
  `refund_type` bigint NULL DEFAULT NULL COMMENT '退款方式，枚举为1(极速退款助手)、2(售后小助手)、3(售后急速退)、4(闪电退货)',
  `arbitrate_status` bigint NULL DEFAULT NULL COMMENT '仲裁状态，枚举为0(无仲裁记录),1(仲裁中),2(客服同意),3(客服拒绝),4(待商家举证),5(协商期),255(仲裁结束)',
  `create_time` bigint NULL DEFAULT NULL COMMENT '\r\n售后单创建时间',
  `risk_decision_reason` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '风控理由',
  `risk_decision_description` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '风控描述',
  `return_promotion_amount` bigint NULL DEFAULT NULL COMMENT '退优惠金额',
  `refund_status` bigint NULL DEFAULT NULL COMMENT '退款状态；1-待退款;2-退款中;3-退款成功;4-退款失败;5-追缴成功;',
  `arbitrate_blame` bigint NULL DEFAULT NULL COMMENT '仲裁责任方 1:商家责任,2:买家责任,3:双方有责,4:平台责任,5:达人责任',
  `return_logistics_code` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退货物流单号',
  `return_logistics_company_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退货物流公司名称',
  `exchange_sku_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '换货SKU信息JSON',
  `exchange_logistics_company_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '换货物流公司名称',
  `remark` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `got_pkg` bigint NULL DEFAULT NULL COMMENT '买家是否收到货物，0表示未收到，1表示收到',
  `is_agree_refuse_sign` bigint NULL DEFAULT NULL COMMENT '是否拒签后退款（1：已同意拒签, 2：未同意拒签）',
  `order_logistics` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '商家首次发货的正向物流信息JSON',
  `aftersale_tags` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '售后标签（含时效延长、风险预警、豁免体验分等标签）标签在平台侧会有更新，标签仅做展示使用，请勿作为系统判断依赖。JSON',
  `aftersale_sub_type` bigint NULL DEFAULT NULL COMMENT '售后子类型；8001-以换代修。',
  `auto_audit_bits` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '自动审核方式：1-发货前极速退；2-小助手自动同意退款；3-发货后极速退；4-闪电退货；5-跨境零秒退；6-云仓拦截自动退；7-小助手自动同意退货；8-小助手自动同意拒签后退款；9-商家代客填写卡片发起售后；10-治理未发货自动同意退款；11-治理已发货自动同意退款；12-商家快递拦截成功自动退款；13-质检商品免审核；14-协商方案自动同意退款；15-平台卡券自动同意退款；16-三方卡券自动同意退款；17-治理一审自动同意退货退款',
  `text_part` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '文案部分JSON',
  `related_order_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '售后关联的订单信息JSON',
  `pull_time` datetime NULL DEFAULT NULL COMMENT '第一次拉取时间',
  `pull_last_time` datetime NULL DEFAULT NULL COMMENT '最后一次拉取时间',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '抖音skuid',
  `o_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `aftersale_id_index`(`aftersale_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '抖店退款表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_dou_refund
-- ----------------------------

-- ----------------------------
-- Table structure for oms_jd_goods
-- ----------------------------
DROP TABLE IF EXISTS `oms_jd_goods`;
CREATE TABLE `oms_jd_goods`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ware_id` bigint NULL DEFAULT NULL COMMENT '商品id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `ware_status` int NULL DEFAULT NULL COMMENT '商品状态 -1：删除 1:从未上架 2:自主下架 4:系统下架 8:上架 513:从未上架待审 514:自主下架待审 516:系统下架待审 520:上架待审核 1028:系统下架审核失败',
  `outer_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '	商品外部ID,商家自行设置的ID（便于关联京东商品）',
  `item_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品货号',
  `bar_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品的条形码.UPC码,SN码,PLU码统称为条形码',
  `modified` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品最后一次修改时间',
  `created` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品创建时间，只读属性',
  `offline_time` datetime NULL DEFAULT NULL COMMENT '最后下架时间',
  `online_time` datetime NULL DEFAULT NULL COMMENT '最后上架时间',
  `delivery` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货地',
  `pack_listing` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '包装清单',
  `wrap` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '包装规格',
  `weight` float NULL DEFAULT NULL,
  `width` int NULL DEFAULT NULL,
  `height` int NULL DEFAULT NULL,
  `length` int NULL DEFAULT NULL,
  `mobile_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `introduction` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `after_sales` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `market_price` decimal(10, 2) NULL DEFAULT NULL,
  `cost_price` decimal(10, 2) NULL DEFAULT NULL,
  `jd_price` decimal(10, 2) NULL DEFAULT NULL,
  `brand_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `stock_num` int NULL DEFAULT NULL,
  `sell_point` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `after_sale_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `spu_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `shop_id` bigint NULL DEFAULT NULL COMMENT '店铺id（sys_shop表id）',
  `erp_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 72 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '京东商品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_jd_goods
-- ----------------------------

-- ----------------------------
-- Table structure for oms_jd_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `oms_jd_goods_sku`;
CREATE TABLE `oms_jd_goods_sku`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ware_id` bigint NULL DEFAULT NULL COMMENT '平台商品id',
  `sku_id` bigint NULL DEFAULT NULL,
  `status` int NULL DEFAULT NULL,
  `jd_price` decimal(10, 2) NULL DEFAULT NULL,
  `outer_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `bar_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `sale_attrs` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `stock_num` int NULL DEFAULT NULL,
  `modified` datetime NULL DEFAULT NULL,
  `created` datetime NULL DEFAULT NULL,
  `currency_spu_id` varchar(0) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `erp_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `erp_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `shop_id` bigint NULL DEFAULT NULL COMMENT '店铺id',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 813 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '京东商品SKU表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_jd_goods_sku
-- ----------------------------

-- ----------------------------
-- Table structure for oms_jd_order
-- ----------------------------
DROP TABLE IF EXISTS `oms_jd_order`;
CREATE TABLE `oms_jd_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` int NOT NULL COMMENT '店铺id',
  `order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单id',
  `vender_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家id',
  `order_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '	订单类型（22 SOP；75 LOC） 可选字段，需要在输入参数optional_fields中写入才能返回',
  `pay_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付方式（1货到付款, 2邮局汇款, 3自提, 4在线支付, 5公司转账, 6银行卡转账）',
  `order_total_price` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单总金额。总金额=订单金额（不减优惠，不加运费服务费税费）',
  `order_seller_price` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单货款金额（订单总金额-商家优惠金额）',
  `order_payment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户应付金额。应付款=货款-用户优惠-余额+运费+税费+服务费。',
  `freight_price` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品的运费',
  `seller_discount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家优惠金额',
  `order_state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '	1）WAIT_SELLER_STOCK_OUT 等待出库 2）WAIT_GOODS_RECEIVE_CONFIRM 等待确认收货 3）WAIT_SELLER_DELIVERY等待发货（只适用于海外购商家，含义为\'等待境内发货\'标签下的订单,非海外购商家无需使用） 4) POP_ORDER_PAUSE POP暂停 5）FINISHED_L 完成 6）TRADE_CANCELED 取消 7）LOCKED 已锁定 8）WAIT_SEND_CODE 等待发码',
  `order_state_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单状态说明（中文）',
  `delivery_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '送货（日期）类型（1-只工作日送货(双休日、假日不用送);2-只双休日、假日送货(工作日不用送);3-工作日、双休日与假日均可送货;其他值-返回“任意时间”）',
  `invoice_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发票信息 “invoice_info: 不需要开具发票”下无需开具发票；其它返回值请正常开具发票 。（没有电子发票具体信息）',
  `invoice_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '普通发票纳税人识别码',
  `order_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家下单时订单备注',
  `order_start_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '下单时间',
  `order_end_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '结单时间 如返回信息为“0001-01-01 00:00:00”和“1970-01-01 00:00:00”，可认为此订单为未完成状态。',
  `fullname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `telephone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '固定电话',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机',
  `full_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
  `province` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `county` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `town` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `province_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `city_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `county_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `town_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `vender_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家订单备注（不大于500字符） 可选字段，需要在输入参数optional_fields中写入才能返回',
  `balance_used` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '余额支付金额 可选字段，需要在输入参数optional_fields中写入才能返回',
  `pin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家的账号信息',
  `return_order` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '售后订单标记 0:不是换货订单 1返修发货,直接赔偿,客服补件 2售后调货 可选字段，需要在输入参数optional_fields中写入才能返回',
  `payment_confirm_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '付款确认时间 如果没有付款时间 默认返回0001-01-01 00:00:00 可选字段，需要在输入参数optional_fields中写入才能返回',
  `waybill` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '运单号(当厂家自送时运单号可为空，不同物流公司的运单号用|分隔，如果同一物流公司有多个运单号，则用英文逗号分隔) 可选字段，需要在输入参数optional_fields中写入才能返回',
  `logistics_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流公司ID 可选字段，需要在输入参数optional_fields中写入才能返回',
  `modified` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单更新时间',
  `direct_parent_order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '	直接父订单号 可选字段，需要在输入参数optional_fields中写入才能返回',
  `parent_order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '	根父订单号 可选字段，需要在输入参数optional_fields中写入才能返回',
  `order_source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单来源。如：移动端订单',
  `store_order` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '京仓订单/云仓订单/空“”',
  `id_sop_shipmenttype` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否京配。68=京配，69=京配自提',
  `real_pin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家的账号信息(区分大小写) 可选字段，需要在输入参数optional_fields中写入才能返回',
  `open_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家的账号信息 ',
  `open_id_buyer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家的账号信息(区分大小写) 可选字段',
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_id_index`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1464 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '京东订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_jd_order
-- ----------------------------

-- ----------------------------
-- Table structure for oms_jd_order_coupon
-- ----------------------------
DROP TABLE IF EXISTS `oms_jd_order_coupon`;
CREATE TABLE `oms_jd_order_coupon`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NULL DEFAULT NULL COMMENT '订单编号',
  `skuId` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '京东sku编号。(只有30-单品促销优惠 此skuId才非空)',
  `coupon_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '优惠类型: 20-套装优惠, 28-闪团优惠, 29-团购优惠, 30-单品促销优惠, 34-手机红包, 35-满返满送(返现), 39-京豆优惠,41-京东券优惠, 52-礼品卡优惠,100-店铺优惠',
  `coupon_price` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '优惠金额。',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4128 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '京东订单优惠明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_jd_order_coupon
-- ----------------------------

-- ----------------------------
-- Table structure for oms_jd_order_item
-- ----------------------------
DROP TABLE IF EXISTS `oms_jd_order_item`;
CREATE TABLE `oms_jd_order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `jd_order_id` bigint NOT NULL COMMENT '外键id（jd_order表id）',
  `order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '京东平台订单id',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '京东内部SKU的ID',
  `outer_sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'SKU外部ID（极端情况下不保证返回，建议从商品接口获取',
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品的名称+SKU规格',
  `jd_price` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'SKU的京东价',
  `gift_point` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '赠送积分',
  `ware_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '	京东内部商品ID（极端情况下不保证返回，建议从商品接口获取）',
  `item_total` int NULL DEFAULT NULL COMMENT '数量',
  `product_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `service_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `new_store_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `erp_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `erp_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1794 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '京东订单明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_jd_order_item
-- ----------------------------

-- ----------------------------
-- Table structure for oms_jd_refund
-- ----------------------------
DROP TABLE IF EXISTS `oms_jd_refund`;
CREATE TABLE `oms_jd_refund`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` int NULL DEFAULT NULL COMMENT '店铺id',
  `apply_id` bigint NULL DEFAULT NULL COMMENT '申请单号',
  `service_id` bigint NULL DEFAULT NULL COMMENT '服务单号（退款单id）',
  `refund_id` bigint NULL DEFAULT NULL COMMENT '退款单id',
  `order_id` bigint NULL DEFAULT NULL COMMENT '订单号',
  `apply_time` datetime NULL DEFAULT NULL COMMENT '申请时间',
  `apply_refund_sum` double NULL DEFAULT NULL COMMENT '退款金额(单位分)',
  `customer_expect` int NOT NULL COMMENT '客户期望(1-售前退款 10-退货 20-换货 30-维修 40-大家电安装 50-大家电移机 60-大家电增值服务 70-上门维修 90-优鲜赔 80-补发商品 100-试用收回 11-仅退款)',
  `customer_expect_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户期望名称',
  `service_status` int NULL DEFAULT NULL COMMENT '服务单状态（10000-待审核领取 10001-待审核 10002-待客户反馈 10004-审核关闭 10005-待收货 10006-待处理领取 10007-待处理 10009-待用户确认 10010-完成 10011-取消 10012-客户已反馈 10013-待审核和待客户反馈 10041-提交退款申请 1100-待下发维修中心接单 12000-上门维修中 14000-上门检测中 13000-商家催收待处理 13000-未收货，待收款 13000-已收货，待收款）',
  `service_status_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '服务单状态名称',
  `customer_pin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户账号',
  `customer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户姓名',
  `customer_tel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户电话',
  `pickware_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '取件地址',
  `pickware_type` int NULL DEFAULT NULL COMMENT '取件方式(4-上门取件 5-上门换新取件 7-客户送货 8-大家电上门取件 9-大家电换新取件 40-客户发货 70-送货至门店 71-快递至门店 72-门店上门取件 80-京东快运上门取件 85-德邦取件)',
  `order_type` int NULL DEFAULT NULL COMMENT '订单类型(0-一般订单 2-拍卖订单 11-售后调货 15-返修发货 16-直接赔偿 21-POPFBP 22-POPSOP 23-POPLBP 24-POPLBV 25-POPSOPL 18-厂商直送 19-客服补件 42-通用合约 61-EPT订单 69-京东服务产品订单 19-客服补件 75-LOC订单 77-LSP订单 42-虚拟订单 88-总代订单 96-sop虚拟订单 100-提货卡订单 33-电子礼品卡 49-礼品卡 108-京东维修服务产品订单 131-X无人超市订单 142-企业店铺IBS订单 151-品牌门店线下订单 112-自营采购，以销定结 159-领货码订单 89-移动仓库订单 170-实体领货码订单 140-商家采购订单 193-scf订单 54-线下礼品卡订单 202-月卡订单 4-虚拟商品)',
  `order_type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单类型名称',
  `actual_pay_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '实付金额',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '商品编号',
  `ware_id` bigint NULL DEFAULT NULL COMMENT '商品id',
  `ware_type` int NULL DEFAULT NULL COMMENT '售后商品类型(10-申请主商品 20-申请的赠品 30-附件 40-发票 50-发票复印件 60-出检报告 70-包装 80-防损吊牌 90-贺卡 100-礼品购包装 110-loc订单验证码 120-服务产品标识)',
  `ware_type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品类型名称',
  `ware_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `sku_type` int NULL DEFAULT NULL COMMENT '商品类型(1-单品 2-赠品套装中的主商品 3-赠品套装中的赠品 4-套装中的单品 5-套装中的赠品 6-加价购赠品 7-延保通 8-延保通赠品)',
  `sku_type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'skuType对应名称',
  `approve_pin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核人账号',
  `approve_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核人姓名',
  `approve_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `approve_result` int NULL DEFAULT NULL COMMENT '审核结果(11-直赔积分 12-直赔余额 13-直赔优惠卷 14-直赔京豆 21-直赔商品 22-上门换新 31-自营取件 32-客户送货 33-客户发货 34-闪电退款 35-虚拟退款 36-上门检测 37-客户送货至门店 38-保外维修 39-快递至门店 40-门店上门取件 80-大家电检测 81-大家电安装 82-大家电移机 83-大家电维修 84-大家电其它 85-闪电催收 86-上门维修 87-补发商品 91-退款不退货 92-预授权冻结 93-ACS换新 95-(超级体验店)门店换新 96-(超级体验店)主站换新 97-厂商维修-寄修 98-厂商维修-上门维修 99-厂商维修-送修 101-厂商大家电检测鉴定 102-厂商大家电安装 103-厂商大家电移机拆机 104-厂商大家电维修(上门维修) 105-厂商大家电拆机鉴定 106-换货 100-客户退货至团长 107-3c上门维修 108-增值服务 109-退货(筋斗云使用) 110-直赔(筋斗云使用) 111-上门检测取件)',
  `approve_result_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核结果名称',
  `approve_notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `process_pin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '处理人账号',
  `process_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '处理人姓名',
  `process_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `process_result` int NULL DEFAULT NULL COMMENT '处理结果(0-初始化 1-安装完成 2-维修完成 3-检测完成 4-拆机完成 5-咨询解释 6-取消 70-原返 80-换货 100-赔付)',
  `process_result_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '处理结果名称',
  `platform_src` int NULL DEFAULT NULL COMMENT '平台来源',
  `platform_src_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '平台来源名称',
  `service_count` int NULL DEFAULT NULL COMMENT '服务单售后数量',
  `desen_customer_tel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户电话',
  `buyer_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户帐号',
  `buyer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '客户姓名',
  `refund_check_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核日期',
  `refund_status` int NULL DEFAULT NULL COMMENT '退款审核状态: 0代表未审核， 1代表审核通过 2代表审核不通过 3代表京东财务审核通过；4代表京东财务审核不通过',
  `refund_complete_time` datetime NULL DEFAULT NULL COMMENT '退款完成时间',
  `refund_check_username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核人',
  `refund_check_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核备注',
  `refund_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款原因',
  `refund_system_id` int NULL DEFAULT NULL COMMENT ' 退款来源(10:客服; 11:网站; 12:配送拒收; 28:APP; 87:分拣中心,逆向物流; 98:微信手Q;)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '订单创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `o_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `sku_list` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '商品明细列表JSON',
  `sku_count` int NULL DEFAULT NULL COMMENT '退款数量',
  `question_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `service_id_index`(`service_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '京东退款与售后表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_jd_refund
-- ----------------------------

-- ----------------------------
-- Table structure for oms_pdd_goods
-- ----------------------------
DROP TABLE IF EXISTS `oms_pdd_goods`;
CREATE TABLE `oms_pdd_goods`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `goods_id` bigint NULL DEFAULT NULL COMMENT '商品编码',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `goods_quantity` bigint NULL DEFAULT NULL COMMENT '商品总数量',
  `outer_goods_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家外部编码（goods）',
  `is_more_sku` int NULL DEFAULT NULL COMMENT '是否多sku，0-单sku，1-多sku',
  `is_onsale` int NULL DEFAULT NULL COMMENT '是否在架上，0-下架中，1-架上',
  `thumb_url` varchar(355) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品缩略图',
  `market_price` bigint NOT NULL DEFAULT 0 COMMENT '市场价，单位分',
  `created_at` bigint NULL DEFAULT NULL COMMENT '商品创建时间的时间戳',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `erp_goods_id` bigint NULL DEFAULT NULL COMMENT 'erp商品id',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'pdd商品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_pdd_goods
-- ----------------------------
INSERT INTO `oms_pdd_goods` VALUES (3, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', NULL, NULL, 1, 1, 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:14', '2025-10-01 12:56:14');
INSERT INTO `oms_pdd_goods` VALUES (4, 754380133868, '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', NULL, NULL, 1, 1, 'https://img.pddpic.com/gaudit-image/2025-05-29/1a92b78dc9240b794790f686d5186398.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:14', '2025-10-01 12:56:14');
INSERT INTO `oms_pdd_goods` VALUES (5, 755310184807, '艾瑞泽工具箱三层折叠多层多功能收纳箱汽车用家用电工五金收纳箱', NULL, NULL, 1, 0, 'https://img.pddpic.com/gaudit-image/2025-05-31/8378221ca34955ad167b22c921234f14.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:14', '2025-10-01 12:56:14');
INSERT INTO `oms_pdd_goods` VALUES (6, 755635245980, '雷士照明led灯泡节能E27螺口球泡飞碟灯夜市地摊工矿大功率厂房灯', NULL, NULL, 1, 1, 'https://img.pddpic.com/gaudit-image/2025-06-01/c59032e87cd4a8aa1d6615eb3770bddb.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:14', '2025-10-01 12:56:14');
INSERT INTO `oms_pdd_goods` VALUES (7, 756679247197, '雷士照明LED灯泡高亮E27螺口节能灯泡吊灯光源大功率护眼LED球泡', NULL, NULL, 1, 1, 'https://img.pddpic.com/gaudit-image/2025-06-03/1f92d0247e00defa30fe23ccc15be4fe.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:15', '2025-10-01 12:56:15');
INSERT INTO `oms_pdd_goods` VALUES (8, 756684220589, '雷士照明led吸顶灯灯条客厅卧室灯板磁吸灯条长条形灯芯家用节能', NULL, NULL, 0, 0, 'https://img.pddpic.com/gaudit-image/2025-06-03/8079acdcba55f2fb96b57b775b87c002.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:15', '2025-10-01 12:56:15');
INSERT INTO `oms_pdd_goods` VALUES (9, 762810718533, '雷士照明应急灯户外露营充电灯泡地摊照明灯超亮节能家用应急灯', NULL, NULL, 1, 0, 'https://img.pddpic.com/gaudit-image/2025-06-15/d74171a6b86b15ddf9d2adc6632a6185.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:15', '2025-10-01 12:56:15');
INSERT INTO `oms_pdd_goods` VALUES (10, 770936903345, '雷士照明LED集成吊顶灯无边框防水厨房卫生间厕所全面发光平板灯', NULL, NULL, 0, 0, 'https://img.pddpic.com/gaudit-image/2025-06-30/3a3e4097cfebbbc95462edc234c8e488.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:15', '2025-10-01 12:56:15');
INSERT INTO `oms_pdd_goods` VALUES (11, 770940543534, '雷士照明led集成吊顶灯平板灯厨房浴室300*300厕所灯卫生间厨房灯', NULL, NULL, 1, 0, 'https://img.pddpic.com/gaudit-image/2025-06-30/b6e35e30732ce30a849d2ad0d6c061e7.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:15', '2025-10-01 12:56:15');
INSERT INTO `oms_pdd_goods` VALUES (12, 774317814352, '雷士led灯芯吸顶磁吸节能灯板改装光源模组圆形三色模组家用环形', NULL, NULL, 1, 1, 'https://img.pddpic.com/gaudit-image/2025-07-06/64eeaa77c1d01bb91bea649e7615bd3c.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:15', '2025-10-01 12:56:15');

-- ----------------------------
-- Table structure for oms_pdd_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `oms_pdd_goods_sku`;
CREATE TABLE `oms_pdd_goods_sku`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sku_id` bigint NULL DEFAULT NULL COMMENT 'sku编码',
  `goods_id` bigint NULL DEFAULT NULL COMMENT 'pdd商品编码',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `thumb_url` varchar(355) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品缩略图',
  `outer_goods_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家外部编码（goods）',
  `outer_id` varchar(85) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家外部编码（sku）',
  `sku_quantity` bigint NULL DEFAULT NULL COMMENT 'sku库存',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规格名称',
  `price` bigint NULL DEFAULT NULL COMMENT '价格，单位分',
  `is_sku_onsale` int NULL DEFAULT NULL COMMENT 'sku是否在架上，0-下架中，1-架上',
  `erp_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `erp_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `shop_id` bigint NULL DEFAULT NULL COMMENT '店铺id',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 147 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'pdd商品SKU表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_pdd_goods_sku
-- ----------------------------
INSERT INTO `oms_pdd_goods_sku` VALUES (112, 1742373848730, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 'LEDDP001', 'LEDDP00102', NULL, 'E27螺口 5瓦白光 1级能效', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (113, 1740677623154, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 'LEDDP001', 'LEDDP00104', NULL, 'E27螺口 12瓦白光 1级能效', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (114, 1742374330748, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 'LEDDP001', 'LEDDP00107', NULL, 'E27螺口 30瓦白光 1级能效', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (115, 1742374330747, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 'LEDDP001', 'LEDDP00106', NULL, 'E27螺口 24瓦白光 1级能效', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (116, 1740677623153, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 'LEDDP001', 'LEDDP00103', NULL, 'E27螺口 7瓦白光 1级能效', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (117, 1740677623155, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 'LEDDP001', 'LEDDP00105', NULL, 'E27螺口 18瓦白光 1级能效', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (118, 1742373848729, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 'LEDDP001', 'LEDDP00101', NULL, 'E27螺口 3瓦白光 1级能效', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (119, 1742164849118, 754380133868, '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/gaudit-image/2025-05-29/1a92b78dc9240b794790f686d5186398.jpeg', 'LEDDX001', 'LEDDX00104', NULL, '36W三色变光-300mm', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (120, 1742164849120, 754380133868, '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/gaudit-image/2025-05-29/1a92b78dc9240b794790f686d5186398.jpeg', 'LEDDX001', 'LEDDX00106', NULL, '60W三色变光-360mm', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (121, 1742164849117, 754380133868, '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/gaudit-image/2025-05-29/1a92b78dc9240b794790f686d5186398.jpeg', 'LEDDX001', 'LEDDX00103', NULL, '24W白光-215mm', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (122, 1742164849115, 754380133868, '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/gaudit-image/2025-05-29/1a92b78dc9240b794790f686d5186398.jpeg', 'LEDDX001', 'LEDDX00101', NULL, '12W白光-135mm', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (123, 1742164849119, 754380133868, '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/gaudit-image/2025-05-29/1a92b78dc9240b794790f686d5186398.jpeg', 'LEDDX001', 'LEDDX00105', NULL, '48W三色变光-330mm', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (124, 1742164849116, 754380133868, '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/gaudit-image/2025-05-29/1a92b78dc9240b794790f686d5186398.jpeg', 'LEDDX001', 'LEDDX00102', NULL, '18W白光-175mm', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (125, 1741926779987, 755310184807, '艾瑞泽工具箱三层折叠多层多功能收纳箱汽车用家用电工五金收纳箱', 'https://img.pddpic.com/gaudit-image/2025-05-31/8378221ca34955ad167b22c921234f14.jpeg', '448700666150_1748700757', '648700666529453', NULL, '22寸黑金刚加强筋骨抗砸耐摔旗舰款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (126, 1741926779985, 755310184807, '艾瑞泽工具箱三层折叠多层多功能收纳箱汽车用家用电工五金收纳箱', 'https://img.pddpic.com/gaudit-image/2025-05-31/8378221ca34955ad167b22c921234f14.jpeg', '448700666150_1748700757', '648700666529451', NULL, '21寸三层折叠工具箱精工款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (127, 1741926779986, 755310184807, '艾瑞泽工具箱三层折叠多层多功能收纳箱汽车用家用电工五金收纳箱', 'https://img.pddpic.com/gaudit-image/2025-05-31/8378221ca34955ad167b22c921234f14.jpeg', '448700666150_1748700757', '648700666529452', NULL, '19寸黑金刚加强筋骨抗砸耐摔旗舰款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (128, 1741926779984, 755310184807, '艾瑞泽工具箱三层折叠多层多功能收纳箱汽车用家用电工五金收纳箱', 'https://img.pddpic.com/gaudit-image/2025-05-31/8378221ca34955ad167b22c921234f14.jpeg', '448700666150_1748700757', '648700666529450', NULL, '17寸三层折叠工具箱精工款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (129, 1742148962888, 755635245980, '雷士照明led灯泡节能E27螺口球泡飞碟灯夜市地摊工矿大功率厂房灯', 'https://img.pddpic.com/gaudit-image/2025-06-01/c59032e87cd4a8aa1d6615eb3770bddb.jpeg', '', '', NULL, '白色款30W白光 其它', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (130, 1742372682345, 755635245980, '雷士照明led灯泡节能E27螺口球泡飞碟灯夜市地摊工矿大功率厂房灯', 'https://img.pddpic.com/gaudit-image/2025-06-01/c59032e87cd4a8aa1d6615eb3770bddb.jpeg', '', '', NULL, '白色款18W白光 其它', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (131, 1742148962887, 755635245980, '雷士照明led灯泡节能E27螺口球泡飞碟灯夜市地摊工矿大功率厂房灯', 'https://img.pddpic.com/gaudit-image/2025-06-01/c59032e87cd4a8aa1d6615eb3770bddb.jpeg', '', '', NULL, '白色款24W白光 其它', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (132, 1743027340567, 756679247197, '雷士照明LED灯泡高亮E27螺口节能灯泡吊灯光源大功率护眼LED球泡', 'https://img.pddpic.com/gaudit-image/2025-06-03/1f92d0247e00defa30fe23ccc15be4fe.jpeg', '', '', NULL, '【五只装】E27 24W 正白光', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (133, 1743027340565, 756679247197, '雷士照明LED灯泡高亮E27螺口节能灯泡吊灯光源大功率护眼LED球泡', 'https://img.pddpic.com/gaudit-image/2025-06-03/1f92d0247e00defa30fe23ccc15be4fe.jpeg', '', '', NULL, '【五只装】E27 18W 正白光', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (134, 1743027340569, 756679247197, '雷士照明LED灯泡高亮E27螺口节能灯泡吊灯光源大功率护眼LED球泡', 'https://img.pddpic.com/gaudit-image/2025-06-03/1f92d0247e00defa30fe23ccc15be4fe.jpeg', '', '', NULL, '【五只装】E27 30W 正白光', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (135, 1749116485132, 756684220589, '雷士照明led吸顶灯灯条客厅卧室灯板磁吸灯条长条形灯芯家用节能', 'https://img.pddpic.com/gaudit-image/2025-06-03/8079acdcba55f2fb96b57b775b87c002.jpeg', '', '', NULL, '48W白光【一拖四】 【磁铁吸附 快捷替换】', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (136, 1748010394260, 762810718533, '雷士照明应急灯户外露营充电灯泡地摊照明灯超亮节能家用应急灯', 'https://img.pddpic.com/gaudit-image/2025-06-15/d74171a6b86b15ddf9d2adc6632a6185.jpeg', '', '', NULL, '4W USB充电式灯泡', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (137, 1748010394261, 762810718533, '雷士照明应急灯户外露营充电灯泡地摊照明灯超亮节能家用应急灯', 'https://img.pddpic.com/gaudit-image/2025-06-15/d74171a6b86b15ddf9d2adc6632a6185.jpeg', '', '', NULL, '7W USB充电式灯泡', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (138, 1754155826431, 770936903345, '雷士照明LED集成吊顶灯无边框防水厨房卫生间厕所全面发光平板灯', 'https://img.pddpic.com/gaudit-image/2025-06-30/3a3e4097cfebbbc95462edc234c8e488.jpeg', '', '', NULL, '30X30【24W悬浮曲面照明】', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (139, 1754157954617, 770940543534, '雷士照明led集成吊顶灯平板灯厨房浴室300*300厕所灯卫生间厨房灯', 'https://img.pddpic.com/gaudit-image/2025-06-30/b6e35e30732ce30a849d2ad0d6c061e7.jpeg', '', '', NULL, '300*600 24W珍珠白集成款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (140, 1754157954614, 770940543534, '雷士照明led集成吊顶灯平板灯厨房浴室300*300厕所灯卫生间厨房灯', 'https://img.pddpic.com/gaudit-image/2025-06-30/b6e35e30732ce30a849d2ad0d6c061e7.jpeg', '', '', NULL, '300*300 18W雾银集成款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (141, 1754157954615, 770940543534, '雷士照明led集成吊顶灯平板灯厨房浴室300*300厕所灯卫生间厨房灯', 'https://img.pddpic.com/gaudit-image/2025-06-30/b6e35e30732ce30a849d2ad0d6c061e7.jpeg', '', '', NULL, '300*300 18W珍珠白集成款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (142, 1754157954616, 770940543534, '雷士照明led集成吊顶灯平板灯厨房浴室300*300厕所灯卫生间厨房灯', 'https://img.pddpic.com/gaudit-image/2025-06-30/b6e35e30732ce30a849d2ad0d6c061e7.jpeg', '', '', NULL, '300*600 24W雾银集成款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (143, 1756355886271, 774317814352, '雷士led灯芯吸顶磁吸节能灯板改装光源模组圆形三色模组家用环形', 'https://img.pddpic.com/gaudit-image/2025-07-06/64eeaa77c1d01bb91bea649e7615bd3c.jpeg', '', 'LEDDX00104', NULL, '三色模组36W 直径23CM', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (144, 1756354078309, 774317814352, '雷士led灯芯吸顶磁吸节能灯板改装光源模组圆形三色模组家用环形', 'https://img.pddpic.com/gaudit-image/2025-07-06/64eeaa77c1d01bb91bea649e7615bd3c.jpeg', '', 'LEDDX00103', NULL, '白光24W 直径22CM', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (145, 1756355886273, 774317814352, '雷士led灯芯吸顶磁吸节能灯板改装光源模组圆形三色模组家用环形', 'https://img.pddpic.com/gaudit-image/2025-07-06/64eeaa77c1d01bb91bea649e7615bd3c.jpeg', '', 'LEDDX00106', NULL, '三色模组60W 直径30CM', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` VALUES (146, 1756355886272, 774317814352, '雷士led灯芯吸顶磁吸节能灯板改装光源模组圆形三色模组家用环形', 'https://img.pddpic.com/gaudit-image/2025-07-06/64eeaa77c1d01bb91bea649e7615bd3c.jpeg', '', 'LEDDX00105', NULL, '三色模组48W 直径30CM', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);

-- ----------------------------
-- Table structure for oms_pdd_order
-- ----------------------------
DROP TABLE IF EXISTS `oms_pdd_order`;
CREATE TABLE `oms_pdd_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单id，自增',
  `shop_id` int NOT NULL COMMENT '内部店铺ID',
  `order_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单编号',
  `trade_type` int NOT NULL COMMENT '订单类型 0-普通订单 ，1- 定金订单',
  `free_sf` int NOT NULL COMMENT '是否顺丰包邮，1-是 0-否',
  `is_lucky_flag` int NOT NULL COMMENT '是否是抽奖订单，1-非抽奖订单，2-抽奖订单',
  `group_status` int NOT NULL COMMENT '成团状态：0：拼团中、1：已成团、2：团失败',
  `confirm_status` int NOT NULL COMMENT '成交状态：0：未成交、1：已成交、2：已取消、',
  `order_status` int NOT NULL COMMENT '发货状态，枚举值：1：待发货，2：已发货待签收，3：已签收',
  `refund_status` int NOT NULL COMMENT '退款状态，枚举值：1：无售后或售后关闭，2：售后处理中，3：退款中，4： 退款成功',
  `after_sales_status` int NOT NULL COMMENT '售后状态 0：无售后 2：买家申请退款，待商家处理 3：退货退款，待商家处理 4：商家同意退款，退款中 5：平台同意退款，退款中 6：驳回退款， 待买家处理 7：已同意退货退款,待用户发货 8：平台处理中 9：平台拒 绝退款，退款关闭 10：退款成功 11：买家撤销 12：买家逾期未处 理，退款失败 13：买家逾期，超过有效期 14 : 换货补寄待商家处理 15:换货补寄待用户处理 16:换货补寄成功 17:换货补寄失败 18:换货补寄待用户确认完成',
  `capital_free_discount` double NOT NULL COMMENT '团长免单金额，单位：元',
  `seller_discount` double NOT NULL COMMENT '商家优惠金额，单位：元',
  `platform_discount` double NOT NULL COMMENT '平台优惠金额，单位：元',
  `goods_amount` double NOT NULL COMMENT '商品金额，单位：元，商品金额=商品销售价格*商品数量-改价金额（接口暂无该字段）',
  `discount_amount` double NOT NULL COMMENT '折扣金额，单位：元，折扣金额=平台优惠+商家优惠+团长免单优惠金额',
  `pay_amount` double NOT NULL COMMENT '支付金额，单位：元，支付金额=商品金额-折扣金额+邮费',
  `postage` double NOT NULL COMMENT '邮费，单位：元',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单备注',
  `remark_tag` int NULL DEFAULT NULL COMMENT '订单备注标记，1-红色，2-黄色，3-绿色，4-蓝色，5-紫色',
  `remark_tag_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单备注标记名称',
  `buyer_memo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '买家留言信息',
  `updated_at` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单的更新时间',
  `shipping_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发货时间',
  `tracking_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '快递单号',
  `tracking_company` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '物流公司',
  `pay_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付方式，枚举值：QQ,WEIXIN,ALIPAY,LIANLIANPAY',
  `pay_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付单号',
  `receiver_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收件人地址，不拼接省市区',
  `receiver_address_mask` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收件人地址（打码）',
  `receiver_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收件人姓名',
  `receiver_phone` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收件人电话',
  `receiver_phone_mask` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `receiver_name_mask` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `address_mask` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `address` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细地址',
  `town` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '区县',
  `town_id` int NULL DEFAULT NULL,
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '市',
  `city_id` int NULL DEFAULT NULL COMMENT '城市编码',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '省',
  `province_id` int NULL DEFAULT NULL,
  `country` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国家地区',
  `country_id` int NULL DEFAULT NULL,
  `created_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单创建时间',
  `pay_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付时间',
  `confirm_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '成交时间',
  `receive_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '确认收货时间',
  `last_ship_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单承诺发货时间',
  `tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标签',
  `delivery_one_day` int NULL DEFAULT NULL COMMENT '是否当日发货，1-是，0-否',
  `duoduo_wholesale` int NULL DEFAULT NULL COMMENT '是否多多批发，1-是，0-否',
  `home_delivery_type` int NULL DEFAULT NULL COMMENT '送货入户并安装服务 0-不支持送货，1-送货入户不安装，2-送货入户并安装',
  `invoice_status` int NULL DEFAULT NULL COMMENT '发票申请,1代表有 0代表无',
  `is_pre_sale` int NULL DEFAULT NULL COMMENT '是否为预售商品 1表示是 0表示否',
  `is_stock_out` int NULL DEFAULT NULL COMMENT '是否缺货 0-无缺货处理 1： 有缺货处理',
  `logistics_id` bigint NULL DEFAULT NULL COMMENT '快递公司在拼多多的代码',
  `mkt_biz_type` int NULL DEFAULT NULL COMMENT '市场业务类型，0-普通订单，1-拼内购订单',
  `only_support_replace` int NULL DEFAULT NULL COMMENT '只换不修，1:是，0:否',
  `order_change_amount` double NULL DEFAULT NULL COMMENT '订单改价折扣金额，单位元',
  `pre_sale_time` varchar(26) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '预售时间',
  `return_freight_payer` int NULL DEFAULT NULL COMMENT '退货包运费，1:是，0:否',
  `risk_control_status` int NULL DEFAULT NULL COMMENT '订单审核状态（0-正常订单， 1-审核中订单）',
  `urge_shipping_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '催发货时间',
  `audit_status` int NULL DEFAULT 0 COMMENT '0待确认，1已确认',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '发货时间（仓库真实发货时间）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '系统创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '系统更新时间',
  `duo_duo_pay_reduction` double NULL DEFAULT NULL COMMENT '多多支付优惠',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_sn_index`(`order_sn` ASC) USING BTREE,
  INDEX `shopid_index`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1973227308263993347 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '拼多多订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_pdd_order
-- ----------------------------
INSERT INTO `oms_pdd_order` VALUES (1973227307811008514, 1009, '250929-004537740820931', 0, 0, 1, 1, 1, 2, 4, 10, 0, 0, 0, 29.35, 0, 29.35, 0, '', NULL, NULL, '', '2025-09-29 18:27:20', '2025-09-29 18:09:45', 'JT5416889180664', NULL, '', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, '中国', 0, '2025-09-29 18:05:30', '2025-09-29 18:05:32', '2025-09-29 18:05:32', '', '2025-09-30 18:05:32', NULL, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, NULL, 0, 0, '', 0, NULL, '2025-10-01 11:23:46', NULL, NULL);
INSERT INTO `oms_pdd_order` VALUES (1973227308263993346, 1009, '250929-351611154071222', 0, 0, 1, 1, 1, 2, 1, 0, 0, 0, 0, 29.35, 0, 29.35, 0, '', NULL, NULL, '', '2025-09-30 13:57:46', '2025-09-30 13:57:46', 'JT5417062326379', NULL, '', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, '中国', 0, '2025-09-29 21:22:48', '2025-09-29 21:22:49', '2025-09-29 21:22:50', '', '2025-09-30 21:22:50', NULL, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, NULL, 0, 0, '', 1, '2025-10-06 17:56:31', '2025-10-06 09:56:31', NULL, NULL);

-- ----------------------------
-- Table structure for oms_pdd_order_item
-- ----------------------------
DROP TABLE IF EXISTS `oms_pdd_order_item`;
CREATE TABLE `oms_pdd_order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id，自增',
  `order_sn` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号',
  `goods_id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '拼多多商品id',
  `sku_id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '拼多多商品skuid',
  `goods_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `goods_img` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `goods_spec` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品规格',
  `goods_price` double NOT NULL COMMENT '商品单价',
  `outer_goods_id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家外部编码（商品）',
  `outer_id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家外部编码（sku）',
  `goods_count` int NOT NULL COMMENT '商品数量',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `o_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_order_sn`(`order_sn` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1973227308326907906 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '拼多多订单明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_pdd_order_item
-- ----------------------------
INSERT INTO `oms_pdd_order_item` VALUES (1973227307873923073, '250929-004537740820931', '754380133868', '1742164849115', NULL, 'https://img.pddpic.com/mms-material-img/2025-05-29/a3e7e689-5c30-495c-b5e0-90e38bd352b5.jpeg.a.jpeg', '12W白光-135mm', 29.35, 'LEDDX001', 'LEDDX00101', 1, NULL, 0, 0);
INSERT INTO `oms_pdd_order_item` VALUES (1973227308326907905, '250929-351611154071222', '754380133868', '1742164849115', NULL, 'https://img.pddpic.com/mms-material-img/2025-05-29/a3e7e689-5c30-495c-b5e0-90e38bd352b5.jpeg.a.jpeg', '12W白光-135mm', 29.35, 'LEDDX001', 'LEDDX00101', 1, NULL, 0, 0);

-- ----------------------------
-- Table structure for oms_pdd_refund
-- ----------------------------
DROP TABLE IF EXISTS `oms_pdd_refund`;
CREATE TABLE `oms_pdd_refund`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '售后编号',
  `shop_id` int NOT NULL COMMENT '内部店铺ID',
  `order_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号',
  `after_sales_type` int NOT NULL COMMENT '售后类型 1：全部 2：仅退款 3：退货退款 4：换货 5：缺货补寄 6：维修',
  `after_sales_status` int NOT NULL COMMENT '售后状态 0：无售后 2：买家申请退款，待商家处理 3：退货退款，待商家处理 4：商家同意退款，退款中 5：平台同意退款，退款中 6：驳回退款，待买家处理 7：已同意退货退款,待用户发货 8：平台处理中 9：平台拒绝退款，退款关闭 10：退款成功 11：买家撤销 12：买家逾期未处理，退款失败 13：买家逾期，超过有效期 14：换货补寄待商家处理 15：换货补寄待用户处理 16：换货补寄成功 17：换货补寄失败 18：换货补寄待用户确认完成 21：待商家同意维修 22：待用户确认发货 24：维修关闭 25：维修成功 27：待用户确认收货 31：已同意拒收退款，待用户拒收 32：补寄待商家发货 33：待商家召回',
  `after_sale_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '售后原因',
  `confirm_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单成团时间',
  `created_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建时间',
  `discount_amount` double NOT NULL COMMENT '订单折扣金额（元）',
  `dispute_refund_status` double NULL DEFAULT NULL COMMENT '1纠纷退款 0非纠纷退款',
  `goods_image` varchar(245) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品图片',
  `goods_id` bigint NULL DEFAULT NULL COMMENT '拼多多商品id',
  `goods_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `goods_price` double NOT NULL COMMENT '商品价格，单位：元',
  `order_amount` double NOT NULL COMMENT '订单金额（元）',
  `refund_amount` double NOT NULL COMMENT '退款金额（元）',
  `refund_operator_role` int NULL DEFAULT NULL COMMENT '同意退款操作人角色0:\"默认\",1:\"用户\",2:\"商家\",3:\"平台\",4:\"系统\",5:\"团长\",6:\"司机\",7:\"代理人\"',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '拼多多商品skuid',
  `outer_goods_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家外部编码（商品）',
  `outer_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '商家外部编码（sku）',
  `goods_spec` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '商品规格',
  `goods_number` int NOT NULL COMMENT '数量',
  `shipping_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退货物流公司名称',
  `speed_refund_flag` int NULL DEFAULT NULL COMMENT '极速退款标志位 1：极速退款，0：非极速退款',
  `speed_refund_status` int NULL DEFAULT NULL COMMENT '极速退款状态，\"1\"：有极速退款资格，\"2\"：极速退款失败, \"3\" 表示极速退款成功，其他表示非极速退款',
  `user_shipping_status` int NULL DEFAULT NULL COMMENT '0-未勾选 1-消费者选择的收货状态为未收到货 2-消费者选择的收货状态为已收到货',
  `tracking_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '快递单号',
  `updated_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL COMMENT '系统更新时间',
  `o_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40559843813 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '拼多多订单退款表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_pdd_refund
-- ----------------------------

-- ----------------------------
-- Table structure for oms_tao_goods
-- ----------------------------
DROP TABLE IF EXISTS `oms_tao_goods`;
CREATE TABLE `oms_tao_goods`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `iid` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品id',
  `num_iid` bigint NULL DEFAULT NULL COMMENT '商品数字id',
  `title` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题',
  `nick` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卖家昵称',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品类型(fixed:一口价;auction:拍卖)注：取消团购',
  `cid` bigint NULL DEFAULT NULL COMMENT '商品所属的叶子类目 id',
  `seller_cids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品所属的店铺内卖家自定义类目列表',
  `pic_url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主图',
  `num` int NULL DEFAULT NULL COMMENT '商品数量',
  `props` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品属性 格式：pid:vid;pid:vid',
  `valid_thru` int NULL DEFAULT NULL COMMENT '有效期,7或者14（默认是7天）',
  `has_discount` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支持会员打折,true/false',
  `has_invoice` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否有发票,true/false',
  `has_warranty` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否有保修,true/false',
  `has_showcase` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '橱窗推荐,true/false',
  `modified` datetime NULL DEFAULT NULL COMMENT '商品修改时间（格式：yyyy-MM-dd HH:mm:ss）',
  `delist_time` datetime NULL DEFAULT NULL COMMENT '下架时间（格式：yyyy-MM-dd HH:mm:ss）',
  `postage_id` bigint NULL DEFAULT NULL COMMENT '宝贝所属的运费模板ID，如果没有返回则说明没有使用运费模板',
  `outer_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家外部编码(可与商家外部系统对接)。需要授权才能获取。',
  `list_time` datetime NULL DEFAULT NULL COMMENT '上架时间（格式：yyyy-MM-dd HH:mm:ss）',
  `price` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品价格，格式：5.00；单位：元；精确到：分',
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `is_ex` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否在外部网店显示',
  `is_virtual` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '虚拟商品的状态字段',
  `is_taobao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否在淘宝显示',
  `sold_quantity` int NULL DEFAULT 0 COMMENT '商品销量',
  `is_cspu` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否为达尔文挂接成功了的商品',
  `first_starts_time` datetime NULL DEFAULT NULL COMMENT '商品首次上架时间',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `erp_goods_id` bigint NULL DEFAULT NULL COMMENT 'erp商品id',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '淘宝商品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_tao_goods
-- ----------------------------

-- ----------------------------
-- Table structure for oms_tao_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `oms_tao_goods_sku`;
CREATE TABLE `oms_tao_goods_sku`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `tao_goods_id` bigint NOT NULL COMMENT '外键id',
  `num_iid` bigint NOT NULL COMMENT 'sku所属商品数字id',
  `iid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku所属商品id(注意：iid近期即将废弃，请用num_iid参数)',
  `sku_id` bigint NOT NULL COMMENT '商品skuid，阿里',
  `properties` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku的销售属性组合字符串（颜色，大小，等等，可通过类目API获取某类目下的销售属性）,格式是p1:v1;p2:v2',
  `properties_name` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku所对应的销售属性的中文名字串，格式如：pid1:vid1:pid_name1:vid_name1;pid2:vid2:pid_name2:vid_name2……',
  `quantity` bigint NULL DEFAULT NULL COMMENT '属于这个sku的商品的数量，',
  `spec` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'specId',
  `price` double NULL DEFAULT NULL COMMENT '属于这个sku的商品的价格 取值范围:0-100000000;精确到2位小数;单位:元。如:200.07，表示:200元7分。',
  `outer_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家设置的外部id。',
  `created` datetime NULL DEFAULT NULL COMMENT 'sku创建日期 时间格式：yyyy-MM-dd HH:mm:ss',
  `modified` datetime NULL DEFAULT NULL COMMENT 'sku最后修改日期 时间格式：yyyy-MM-dd HH:mm:ss',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku状态。	normal',
  `sku_spec_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '表示SKu上的产品规格信息',
  `barcode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品级别的条形码',
  `erp_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `erp_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sku_id_index`(`sku_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '淘宝商品SKU表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_tao_goods_sku
-- ----------------------------

-- ----------------------------
-- Table structure for oms_tao_order
-- ----------------------------
DROP TABLE IF EXISTS `oms_tao_order`;
CREATE TABLE `oms_tao_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `shop_id` int NOT NULL DEFAULT 0 COMMENT '店铺id',
  `tid` bigint NOT NULL COMMENT '交易编号 (父订单的交易编号)',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易标题，以店铺名作为此标题的值。',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易类型列表，同时查询多种交易类型可用逗号分隔。',
  `seller_flag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卖家备注旗帜（与淘宝网上订单的卖家备注旗帜对应，只有卖家才能查看该字段）红、黄、绿、蓝、紫 分别对应 1、2、3、4、5',
  `has_buyer_message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '判断订单是否有买家留言，有买家留言返回true，否则返回false',
  `credit_card_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用信用卡支付金额数',
  `step_trade_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分阶段付款的订单状态（例如万人团订单等），目前有三返回状态FRONT_NOPAID_FINAL_NOPAID(定金未付尾款未付)，FRONT_PAID_FINAL_NOPAID(定金已付尾款未付)，FRONT_PAID_FINAL_PAID(定金和尾款都付)',
  `step_paid_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分阶段付款的已付金额（万人团订单已付金额）',
  `buyer_open_uid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家OpenUid',
  `mark_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单出现异常问题的时候，给予用户的描述,没有异常的时候，此值为空',
  `buyer_nick` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '买家昵称',
  `num_iid` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品数字编号',
  `num` int NULL DEFAULT NULL COMMENT '商品购买数量。取值范围：大于零的整数,对于一个trade对应多个order的时候（一笔主订单，对应多笔子订单），num=0，num是一个跟商品关联的属性，一笔订单对应多比子订单的时候，主订单上的num无意义。',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '商品价格。精确到2位小数；单位：元。如：200.07，表示：200元7分',
  `total_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '商品金额（商品价格乘以数量的总金额）。精确到2位小数;单位:元。如:200.07，表示:200元7分',
  `adjust_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '卖家手工调整金额，精确到2位小数，单位：元。如：200.07',
  `post_fee` decimal(5, 2) NOT NULL DEFAULT 0.00 COMMENT '邮费',
  `discount_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '优惠金额',
  `payment` decimal(10, 2) NOT NULL COMMENT '实付金额',
  `received_payment` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '卖家实际收到的支付宝打款金额（由于子订单可以部分确认收货，这个金额会随着子订单的确认收货而不断增加，交易成功后等于买家实付款减去退款金额）。精确到2位小数;单位:元。如:200.07，表示:200元7分',
  `available_confirm_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '交易中剩余的确认收货金额（这个金额会随着子订单确认收货而不断减少，交易成功后会变为零）。精确到2位小数;单位:元。如:200.07，表示:200 元7分',
  `cod_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '货到付款服务费。',
  `cod_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '货到付款物流状态。初始状态 NEW_CREATED,接单成功 ACCEPTED_BY_COMPANY,接单失败 REJECTED_BY_COMPANY,接单超时 RECIEVE_TIMEOUT,揽收成功 TAKEN_IN_SUCCESS,揽收失败 TAKEN_IN_FAILED,揽收超时 TAKEN_TIMEOUT,签收成功 SIGN_IN,签收失败 REJECTED_BY_OTHER_SIDE,订单等待发送给物流公司 WAITING_TO_BE_SENT,用户取消物流订单 CANCELED',
  `buyer_cod_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家货到付款服务费',
  `seller_cod_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卖家货到付款服务费',
  `express_agency_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '快递代收款。',
  `commission_fee` float NULL DEFAULT NULL COMMENT '交易佣金。',
  `shipping_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建交易时的物流方式（交易完成前，物流方式有可能改变，但系统里的这个字段一直不变）。可选值：free(卖家包邮),post(平邮),express(快递),ems(EMS),virtual(虚拟发货)，25(次日必达)，26(预约配送)。',
  `created` datetime NOT NULL COMMENT '交易创建时间。格式:yyyy-MM-dd HH:mm:ss',
  `modified` datetime NULL DEFAULT NULL COMMENT '交易修改时间(用户对订单的任何修改都会更新此字段)。格式:yyyy-MM-dd HH:mm:ss',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '付款时间。格式:yyyy-MM-dd HH:mm:ss。订单的付款时间即为物流订单的创建时间。',
  `consign_time` datetime NULL DEFAULT NULL COMMENT '卖家发货时间。格式:yyyy-MM-dd HH:mm:ss',
  `end_time` datetime NULL DEFAULT NULL COMMENT '交易结束时间。交易成功时间(更新交易状态为成功的同时更新)/确认收货时间或者交易关闭时间 。格式:yyyy-MM-dd HH:mm:ss',
  `seller_memo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卖家备忘信息',
  `buyer_memo` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家备注',
  `buyer_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '买家留言',
  `point_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家使用积分,下单时生成，且一直不变。格式:100;单位:个.',
  `real_point_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家实际使用积分（扣除部分退款使用的积分），交易完成后生成（交易成功或关闭），交易未完成时该字段值为0。格式:100;单位:个',
  `buyer_obtain_point_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家获得积分,返点的积分。格式:100;单位:个。返点的积分要交易成功之后才能获得。',
  `receiving_time` datetime NULL DEFAULT NULL COMMENT '收货时间，这里返回的是完全收货时间',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '交易状态。可选值: * TRADE_NO_CREATE_PAY(没有创建支付宝交易) * WAIT_BUYER_PAY(等待买家付款) * SELLER_CONSIGNED_PART(卖家部分发货) * WAIT_SELLER_SEND_GOODS(等待卖家发货,即:买家已付款) * WAIT_BUYER_CONFIRM_GOODS(等待买家确认收货,即:卖家已发货) * TRADE_BUYER_SIGNED(买家已签收,货到付款专用) * TRADE_FINISHED(交易成功) * TRADE_CLOSED(付款以后用户退款成功，交易自动关闭) * TRADE_CLOSED_BY_TAOBAO(付款以前，卖家或买家主动关闭交易) * PAY_PENDING(国际信用卡支付付款确认中) * WAIT_PRE_AUTH_CONFIRM(0元购合约中) * PAID_FORBID_CONSIGN(拼团中订单或者发货强管控的订单，已付款但禁止发货)',
  `trade_memo` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易备注。',
  `erp_send_company` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'erp发货快递公司',
  `erp_send_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'erp发货快递单号',
  `erp_send_status` int NULL DEFAULT 0 COMMENT 'erp发货状态',
  `create_time` datetime NULL DEFAULT NULL COMMENT '数据库创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '数据库更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '数据库更新人',
  `oaid` varchar(2552) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '（收货人+手机号+座机+收货地址+create）5个字段组合成oaid，原始订单上座机为空也满足条件，否则生成不了oaid',
  `aid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址aid字段',
  `receiver_country` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人国籍',
  `receiver_state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人的所在省份',
  `receiver_city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人的所在城市',
  `receiver_district` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人的所在地区',
  `receiver_town` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人街道地址',
  `receiver_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人的详细地址',
  `receiver_zip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人的邮编',
  `receiver_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人的姓名',
  `receiver_mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人的手机号码',
  `receiver_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人的电话号码',
  `seller_rate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卖家是否已评价。可选值:true(已评价),false(未评价)',
  `seller_nick` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卖家昵称',
  `buyer_rate` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '买家是否已评价。可选值:true(已评价),false(未评价)。如买家只评价未打分，此字段仍返回false',
  `buyer_area` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家下单的地区',
  `alipay_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付宝交易号，如：2009112081173831',
  `buyer_alipay_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家支付宝账号',
  `buyer_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家邮件地址',
  `seller_alipay_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卖家支付宝账号',
  `has_post_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否包含邮费。与available_confirm_fee同时使用。可选值:true(包含),false(不包含)',
  `timeout_action_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '超时到期时间。格式:yyyy-MM-dd HH:mm:ss。业务规则：前提条件：只有在买家已付款，卖家已发货的情况下才有效如果申请了退款，那么超时会落在子订单上；比如说3笔ABC，A申请了，那么返回的是BC的列表, 主定单不存在如果没有申请过退款，那么超时会挂在主定单上；比如ABC，返回主定单，ABC的超时和主定单相同',
  `snapshot_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易快照地址',
  `promotion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易促销详细信息',
  `yfx_fee` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单的运费险，单位为元',
  `has_yfx` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单中是否包含运费险订单，如果包含运费险订单返回true，不包含运费险订单，返回false',
  `send_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单将在此时间前发出，主要用于预售订单',
  `is_part_consign` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否是多次发货的订单如果卖家对订单进行多次发货，则为true否则为false',
  `sid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流运单号',
  `tmall_coupon_fee` bigint NULL DEFAULT NULL COMMENT '天猫商家使用，订单使用的红包信息',
  `audit_status` int NOT NULL DEFAULT 0 COMMENT '0待确认，1已确认2已拦截-9未拉取',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `index_tid`(`tid` ASC) USING BTREE,
  INDEX `shop_id_index`(`shop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '淘宝订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_tao_order
-- ----------------------------
INSERT INTO `oms_tao_order` VALUES (1, 1007, 4779070308838830200, '曲美家具官方旗舰店', 'fixed', '0', 'false', NULL, NULL, NULL, 'AAFlHVMUAAJ_dKyzaDW1umZV', NULL, '南**', NULL, NULL, NULL, 11992.00, 0.00, 0.00, 0.00, 3816.00, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-09-30 15:47:31', '2025-10-01 15:47:33', NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', NULL, NULL, NULL, 0, '2025-10-01 16:10:03', NULL, NULL, '1mR3x9I4XJSLepZNWRNl52fSD7qMKERlp5UshuqVdylNKnjw6k2P3IbTVXGAQibQARZmuzE', NULL, NULL, '北京', '北京市', '昌平区', '北七家镇', '北**镇东**村***号***', NULL, '李**', '***********', NULL, NULL, NULL, '0', NULL, '2025093022001155621417014220', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'false', NULL, NULL, '4779070308838830200', NULL, 1, '2025-10-06 17:49:00');
INSERT INTO `oms_tao_order` VALUES (2, 1007, 4769970048747824611, '曲美家具官方旗舰店', 'fixed', '1', 'false', '3536.20', NULL, NULL, 'AAE3HVMUAAJ_dKyzaDUXfKw9', NULL, '蓝**', NULL, NULL, NULL, 7999.00, 0.00, 0.00, 0.00, 3538.00, 3538.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-09-26 12:12:58', '2025-10-01 15:46:06', '2025-09-26 12:13:19', NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, 'TRADE_FINISHED', NULL, NULL, NULL, 0, '2025-10-01 16:10:03', NULL, NULL, '1UnlddID4G8zgNMdldmrJT6T5jDlgmshqI445r0SnTCquiaHamrgp5zzTVqHl8NqzNPcicKG', NULL, NULL, '北京', '北京市', '昌平区', '回龙观街道', '回**街道北京**小区**号楼*-***', NULL, '徐**', '***********', NULL, NULL, NULL, '0', NULL, '2025092622001136091425793800', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'false', NULL, NULL, '4769970048747824611', NULL, 0, NULL);
INSERT INTO `oms_tao_order` VALUES (3, 1007, 4778846679944830200, '曲美家具官方旗舰店', 'fixed', '0', 'false', NULL, NULL, NULL, 'AAFlHVMUAAJ_dKyzaDW1umZV', NULL, '南**', NULL, NULL, NULL, 4497.00, 0.00, 0.00, 0.00, 1134.00, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-09-30 15:43:58', '2025-10-01 15:44:07', NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', NULL, NULL, NULL, 0, '2025-10-01 16:10:03', NULL, NULL, '1mR3x9I4XJSLepZNWRNl52fSD7qMKERlp5UshuqVdylNKnjw6k2P3IbTVXGAQibQARZmuzE', NULL, NULL, '北京', '北京市', '昌平区', '北七家镇', '北**镇东**村***号***', NULL, '李**', '***********', NULL, NULL, NULL, '0', NULL, '2025093022001155621417482852', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'false', NULL, NULL, '4778846679944830200', NULL, 0, NULL);
INSERT INTO `oms_tao_order` VALUES (4, 1007, 4778912197701623818, '曲美家具官方旗舰店', 'fixed', '0', 'false', NULL, NULL, NULL, 'AAGuHVMUAAJ_dKyzaDUDY-Sp', NULL, '我**', NULL, NULL, NULL, 12996.00, 0.00, 0.00, 0.00, 4060.00, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-09-30 15:34:01', '2025-10-01 15:34:03', NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', NULL, NULL, NULL, 0, '2025-10-01 16:10:03', NULL, NULL, '1tR04xIVEJAkicKAJpONkicavfyNDTf7p5lqia681elfDFttgsEdibTlguhZPoTVrnYriaIdfhe', NULL, NULL, '山西省', '运城市', '盐湖区', '姚孟街道', '姚*街道**广场吾悦华府（南区**号**单元****', NULL, '君**', '***********', NULL, NULL, NULL, '0', NULL, '2025093022001113001443075250', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'false', NULL, NULL, '4778912197701623818', NULL, 0, NULL);

-- ----------------------------
-- Table structure for oms_tao_order_item
-- ----------------------------
DROP TABLE IF EXISTS `oms_tao_order_item`;
CREATE TABLE `oms_tao_order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tid` bigint NOT NULL COMMENT '订单id',
  `oid` bigint NOT NULL COMMENT '子订单编号',
  `total_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '应付金额（商品价格 * 商品数量 + 手工调整金额 - 子订单级订单优惠金额）。精确到2位小数;单位:元。如:200.07，表示:200元7分',
  `discount_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '子订单级订单优惠金额。精确到2位小数;单位:元。如:200.07，表示:200元7分',
  `adjust_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '手工调整金额.格式为:1.01;单位:元;精确到小数点后两位.',
  `divide_order_fee` decimal(10, 2) NULL DEFAULT NULL COMMENT '分摊之后的实付金额',
  `part_mjz_discount` decimal(10, 2) NULL DEFAULT NULL COMMENT '优惠分摊',
  `payment` decimal(10, 2) NULL DEFAULT NULL COMMENT '子订单实付金额。精确到2位小数，单位:元。如:200.07，表示:200元7分。对于多子订单的交易，计算公式如下：payment = price * num + adjust_fee - discount_fee ；单子订单交易，payment与主订单的payment一致，对于退款成功的子订单，由于主订单的优惠分摊金额，会造成该字段可能不为0.00元。建议使用退款前的实付金额减去退款单中的实际退款金额计算。',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题',
  `pic_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品主图',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '商品价格',
  `num_iid` bigint NULL DEFAULT NULL COMMENT '商品数字ID',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品的最小库存单位Sku的id.可以通过taobao.item.sku.get获取详细的Sku信息天猫的SKUID',
  `outer_iid` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家外部编码(可与商家外部系统对接)。',
  `outer_sku_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '外部网店自己定义的Sku编号',
  `sku_properties_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'SKU的值。如：机身颜色:黑色;手机套餐:官方标配',
  `item_meal_id` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '套餐ID',
  `item_meal_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '套餐的值。如：M8原装电池:便携支架:M8专用座充:莫凡保护袋',
  `num` int NULL DEFAULT NULL COMMENT '数量',
  `timeout_action_time` datetime NULL DEFAULT NULL COMMENT '订单超时到期时间。格式:yyyy-MM-dd HH:mm:ss',
  `item_memo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品备注',
  `buyer_rate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家是否已评价。可选值：true(已评价)，false(未评价)',
  `seller_rate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卖家是否已评价。可选值：true(已评价)，false(未评价)',
  `seller_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卖家类型，可选值为：B（商城商家），C（普通卖家）',
  `cid` bigint NULL DEFAULT NULL COMMENT '交易商品对应的类目ID',
  `is_oversold` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '	是否超卖',
  `end_time` datetime NULL DEFAULT NULL COMMENT '子订单的交易结束时间说明：子订单有单独的结束时间，与主订单的结束时间可能有所不同，在有退款发起的时候或者是主订单分阶段付款的时候，子订单的结束时间会早于主订单的结束时间，所以开放这个字段便于订单结束状态的判断',
  `order_from` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子订单来源,如jhs(聚划算)、taobao(淘宝)、wap(无线)',
  `is_service_order` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否是服务订单，是返回true，否返回false。',
  `consign_time` datetime NULL DEFAULT NULL COMMENT '子订单发货时间，当卖家对订单进行了多次发货，子订单的发货时间和主订单的发货时间可能不一样了，那么就需要以子订单的时间为准。（没有进行多次发货的订单，主订单的发货时间和子订单的发货时间都一样）',
  `shipping_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子订单的运送方式（卖家对订单进行多次发货之后，一个主订单下的子订单的运送方式可能不同，用order.shipping_type来区分子订单的运送方式）',
  `logistics_company` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子订单发货的快递公司名称',
  `invoice_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子订单所在包裹的运单号',
  `bind_oid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '捆绑的子订单号，表示该子订单要和捆绑的子订单一起发货，用于卖家子订单捆绑发货',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单状态（请关注此状态，如果为TRADE_CLOSED_BY_TAOBAO状态，则不要对此订单进行发货，切记啊！）。可选值:\r\nTRADE_NO_CREATE_PAY(没有创建支付宝交易)\r\nWAIT_BUYER_PAY(等待买家付款)\r\nWAIT_SELLER_SEND_GOODS(等待卖家发货,即:买家已付款)\r\nWAIT_BUYER_CONFIRM_GOODS(等待买家确认收货,即:卖家已发货)\r\nTRADE_BUYER_SIGNED(买家已签收,货到付款专用)\r\nTRADE_FINISHED(交易成功)\r\nTRADE_CLOSED(付款以后用户退款成功，交易自动关闭)\r\nTRADE_CLOSED_BY_TAOBAO(付款以前，卖家或买家主动关闭交易)\r\nPAY_PENDING(国际信用卡支付付款确认中)',
  `refund_status` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'NO_REFUND' COMMENT '退款状态。退款状态。可选值 WAIT_SELLER_AGREE(买家已经申请退款，等待卖家同意) WAIT_BUYER_RETURN_GOODS(卖家已经同意退款，等待买家退货) WAIT_SELLER_CONFIRM_GOODS(买家已经退货，等待卖家确认收货) SELLER_REFUSE_BUYER(卖家拒绝退款) CLOSED(退款关闭) SUCCESS(退款成功)',
  `refund_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最近退款ID',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `o_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `tid_index`(`tid` ASC) USING BTREE,
  INDEX `oid_index`(`oid` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '淘宝订单明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_tao_order_item
-- ----------------------------
INSERT INTO `oms_tao_order_item` VALUES (1, 4779070308838830200, 4779070308839830200, 378.00, 1121.00, 0.00, NULL, 0.00, 0.00, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', 1499.00, 730871350821, '5380261056486', NULL, 'F9-23E-LAB-ZDB-2', '适用人数:组合;颜色分类:石墨灰【灯芯绒】;尺寸:94x45x35cm', NULL, NULL, 1, NULL, NULL, NULL, NULL, 'B', 50020633, NULL, '2025-10-01 15:47:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', 'NO_REFUND', NULL, NULL, NULL, NULL);
INSERT INTO `oms_tao_order_item` VALUES (2, 4779070308838830200, 4779070308840830200, 378.00, 1121.00, 0.00, NULL, 0.00, 0.00, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', 1499.00, 730871350821, '5380261056464', NULL, 'F8-23E-LAB-ZDB-2', '适用人数:组合;颜色分类:焦糖棕【灯芯绒】;尺寸:94x45x35cm', NULL, NULL, 1, NULL, NULL, NULL, NULL, 'B', 50020633, NULL, '2025-10-01 15:47:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', 'NO_REFUND', NULL, NULL, NULL, NULL);
INSERT INTO `oms_tao_order_item` VALUES (3, 4779070308838830200, 4779070308841830200, 378.00, 1121.00, 0.00, NULL, 0.00, 0.00, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', 1499.00, 730871350821, '5380261056530', NULL, 'F7-23E-LAB-ZDB-2', '适用人数:组合;颜色分类:蔷薇粉【灯芯绒】;尺寸:94x45x35cm', NULL, NULL, 1, NULL, NULL, NULL, NULL, 'B', 50020633, NULL, '2025-10-01 15:47:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', 'NO_REFUND', NULL, NULL, NULL, NULL);
INSERT INTO `oms_tao_order_item` VALUES (4, 4779070308838830200, 4779070308842830200, 1134.00, 3363.00, 0.00, NULL, 0.00, 0.00, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', 1499.00, 730871350821, '5380261056508', NULL, 'F2-23E-LAB-ZDB-2', '适用人数:组合;颜色分类:奶茶灰【灯芯绒】;尺寸:94x45x35cm', NULL, NULL, 3, NULL, NULL, NULL, NULL, 'B', 50020633, NULL, '2025-10-01 15:47:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', 'NO_REFUND', NULL, NULL, NULL, NULL);
INSERT INTO `oms_tao_order_item` VALUES (5, 4779070308838830200, 4779070308843830200, 1027.00, 472.00, 0.00, NULL, 0.00, 0.00, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', 1499.00, 730871350821, '5380261056552', NULL, 'F5-23E-LAB-ZDB-2', '适用人数:组合;颜色分类:冰川灰【头层牛皮】;尺寸:94x45x35cm', NULL, NULL, 1, NULL, NULL, NULL, NULL, 'B', 50020633, NULL, '2025-10-01 15:47:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', 'NO_REFUND', NULL, NULL, NULL, NULL);
INSERT INTO `oms_tao_order_item` VALUES (6, 4779070308838830200, 4779070308844830200, 521.00, 978.00, 0.00, NULL, 0.00, 0.00, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', 1499.00, 730871350821, '5380261056497', NULL, 'F4-23E-LAB-ZDB-2', '适用人数:组合;颜色分类:蜜糖棕【硅胶皮】;尺寸:94x45x35cm', NULL, NULL, 1, NULL, NULL, NULL, NULL, 'B', 50020633, NULL, '2025-10-01 15:47:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', 'NO_REFUND', NULL, NULL, NULL, NULL);
INSERT INTO `oms_tao_order_item` VALUES (7, 4769970048747824611, 4769970048748824611, 3538.00, 4461.00, 0.00, 3538.00, 0.00, 3538.00, '曲美家居真皮婚床次卧轻奢悬浮现代简约高端大气主卧室双人左岸床', 'https://img.alicdn.com/bao/uploaded/i2/351855490/O1CN01pF9mAE1qQTFrWXkWd_!!351855490.jpg', 7999.00, 718529179488, '5024925108638', NULL, 'DS-F1-QM23-B1-12&QM23-M1-12', '颜色分类:架子款-浅咖色 进口真皮软床+独袋弹簧乳胶床垫;适用床垫尺寸:1200mm*2000mm;床结构:框架结构', NULL, NULL, 1, NULL, NULL, NULL, NULL, 'B', 50020000, NULL, '2025-10-01 15:41:01', NULL, NULL, '2025-09-27 23:57:08', 'express', '顺丰速运', 'SF3297741286482', NULL, 'TRADE_FINISHED', 'NO_REFUND', NULL, NULL, NULL, NULL);
INSERT INTO `oms_tao_order_item` VALUES (8, 4778846679944830200, 4778846679945830200, 378.00, 1121.00, 0.00, NULL, 0.00, 0.00, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', 1499.00, 730871350821, '5380261056464', NULL, 'F8-23E-LAB-ZDB-2', '适用人数:组合;颜色分类:焦糖棕【灯芯绒】;尺寸:94x45x35cm', NULL, NULL, 1, NULL, NULL, NULL, NULL, 'B', 50020633, NULL, '2025-10-01 15:44:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', 'NO_REFUND', NULL, NULL, NULL, NULL);
INSERT INTO `oms_tao_order_item` VALUES (9, 4778846679944830200, 4778846679946830200, 378.00, 1121.00, 0.00, NULL, 0.00, 0.00, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', 1499.00, 730871350821, '5380261056530', NULL, 'F7-23E-LAB-ZDB-2', '适用人数:组合;颜色分类:蔷薇粉【灯芯绒】;尺寸:94x45x35cm', NULL, NULL, 1, NULL, NULL, NULL, NULL, 'B', 50020633, NULL, '2025-10-01 15:44:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', 'NO_REFUND', NULL, NULL, NULL, NULL);
INSERT INTO `oms_tao_order_item` VALUES (10, 4778846679944830200, 4778846679947830200, 378.00, 1121.00, 0.00, NULL, 0.00, 0.00, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', 1499.00, 730871350821, '5380261056475', NULL, 'F1-23E-LAB-ZDB-2', '适用人数:组合;颜色分类:燕麦白【灯芯绒】;尺寸:94x45x35cm', NULL, NULL, 1, NULL, NULL, NULL, NULL, 'B', 50020633, NULL, '2025-10-01 15:44:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', 'NO_REFUND', NULL, NULL, NULL, NULL);
INSERT INTO `oms_tao_order_item` VALUES (11, 4778912197701623818, 4778912197702623818, 3304.00, 6694.00, 0.00, NULL, 0.00, 0.00, '【活动价】曲美lab墩墩沙发现代简约模块布艺真皮沙发别墅客厅沙发自由搭配', 'https://img.alicdn.com/bao/uploaded/i4/351855490/O1CN01NspmnZ1qQTLR1LBVt_!!351855490.png', 4999.00, 770344068923, '5340247493414', NULL, 'F1-23E-LAB-FS', '适用人数:组合;颜色分类:灯芯绒扶手-燕麦白;尺寸:96x24x60cm', NULL, NULL, 2, NULL, NULL, NULL, NULL, 'B', 50020633, NULL, '2025-10-01 15:34:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', 'NO_REFUND', NULL, NULL, NULL, NULL);
INSERT INTO `oms_tao_order_item` VALUES (12, 4778912197701623818, 4778912197703623818, 378.00, 1121.00, 0.00, NULL, 0.00, 0.00, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', 1499.00, 730871350821, '5380261056508', NULL, 'F2-23E-LAB-ZDB-2', '适用人数:组合;颜色分类:奶茶灰【灯芯绒】;尺寸:94x45x35cm', NULL, NULL, 1, NULL, NULL, NULL, NULL, 'B', 50020633, NULL, '2025-10-01 15:34:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', 'NO_REFUND', NULL, NULL, NULL, NULL);
INSERT INTO `oms_tao_order_item` VALUES (13, 4778912197701623818, 4778912197704623818, 378.00, 1121.00, 0.00, NULL, 0.00, 0.00, '【活动价】曲美lab墩墩沙发现代别墅客厅沙发组合沙发配件', 'https://img.alicdn.com/bao/uploaded/i1/351855490/O1CN01gnsf7b1qQTMCTnI4c_!!351855490.jpg', 1499.00, 730871350821, '5380261056530', NULL, 'F7-23E-LAB-ZDB-2', '适用人数:组合;颜色分类:蔷薇粉【灯芯绒】;尺寸:94x45x35cm', NULL, NULL, 1, NULL, NULL, NULL, NULL, 'B', 50020633, NULL, '2025-10-01 15:34:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TRADE_CLOSED_BY_TAOBAO', 'NO_REFUND', NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for oms_tao_order_promotion
-- ----------------------------
DROP TABLE IF EXISTS `oms_tao_order_promotion`;
CREATE TABLE `oms_tao_order_promotion`  (
  `id` bigint NOT NULL COMMENT '交易的主订单或子订单号',
  `promotion_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '优惠信息的名称',
  `discount_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '优惠金额（免运费、限时打折时为空）,单位：元',
  `gift_item_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '满就送商品时，所送商品的名称',
  `gift_item_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '赠品的宝贝id',
  `gift_item_num` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '满就送礼物的礼物数量',
  `promotion_desc` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '优惠活动的描述',
  `promotion_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '优惠id，(由营销工具id、优惠活动id和优惠详情id组成，结构为：营销工具id-优惠活动id_优惠详情id，如mjs-123024_211143）',
  `kd_discount_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分摊优惠金额（免运费、限时打折时为空）,单位：元',
  `kd_child_discount_fee` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '若优惠项在主订单上，返回子订单的分摊信息'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '淘宝订单优惠明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_tao_order_promotion
-- ----------------------------

-- ----------------------------
-- Table structure for oms_tao_refund
-- ----------------------------
DROP TABLE IF EXISTS `oms_tao_refund`;
CREATE TABLE `oms_tao_refund`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `refund_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款id',
  `dispute_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款类型，可选值REFUND(仅退款),REFUND_AND_RETURN(退货退款),TMALL_EXCHANGE(天猫换货),TAOBAO_EXCHANGE(淘宝换货),REPAIR(维修),RESHIPPING(补寄),OTHERS(其他)',
  `shop_id` int NOT NULL COMMENT '店铺id',
  `tid` bigint NULL DEFAULT NULL COMMENT '淘宝交易单号（订单号）',
  `oid` bigint NULL DEFAULT NULL COMMENT '子订单号。如果是单笔交易oid会等于tid',
  `payment` float NULL DEFAULT NULL COMMENT '支付给卖家的金额(交易总金额-退还给买家的金额)。精确到2位小数;单位:元。如:200.07，表示:200元7分',
  `price` float NULL DEFAULT NULL COMMENT '商品价格。',
  `total_fee` float NULL DEFAULT NULL COMMENT '交易总金额。精确到2位小数;单位:元。如:200.07，表示:200元7分',
  `refund_fee` float NULL DEFAULT NULL COMMENT '退还金额(退还给买家的金额)。精确到2位小数;单位:元。如:200.07，表示:200元7分',
  `split_seller_fee` float NULL DEFAULT NULL COMMENT '	分账给卖家的钱',
  `split_taobao_fee` float NULL DEFAULT NULL COMMENT '分账给淘宝的钱',
  `created` datetime NULL DEFAULT NULL COMMENT '退款申请时间。格式:yyyy-MM-dd HH:mm:ss',
  `modified` datetime NULL DEFAULT NULL COMMENT '更新时间。格式:yyyy-MM-dd HH:mm:ss',
  `seller_nick` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卖家昵称',
  `cs_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '不需客服介入1;需要客服介入2;客服已经介入3;客服初审完成4;客服主管复审失败5;客服处理完成6;系统撤销(B2B使用)，维权撤销(集市使用) 7;支持买家 8;支持卖家 9;举证中 10;开放申诉 11;',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款状态。可选值WAIT_SELLER_AGREE(买家已经申请退款，等待卖家同意) WAIT_BUYER_RETURN_GOODS(卖家已经同意退款，等待买家退货) WAIT_SELLER_CONFIRM_GOODS(买家已经退货，等待卖家确认收货) SELLER_REFUSE_BUYER(卖家拒绝退款) CLOSED(退款关闭) SUCCESS(退款成功)',
  `order_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款对应的订单交易状态。可选值TRADE_NO_CREATE_PAY(没有创建支付宝交易) WAIT_BUYER_PAY(等待买家付款) WAIT_SELLER_SEND_GOODS(等待卖家发货,即:买家已付款) WAIT_BUYER_CONFIRM_GOODS(等待买家确认收货,即:卖家已发货) TRADE_BUYER_SIGNED(买家已签收,货到付款专用) TRADE_FINISHED(交易成功) TRADE_CLOSED(交易关闭) TRADE_CLOSED_BY_TAOBAO(交易被淘宝关闭) ALL_WAIT_PAY(包含：WAIT_BUYER_PAY、TRADE_NO_CREATE_PAY) ALL_CLOSED(包含：TRADE_CLOSED、TRADE_CLOSED_BY_TAOBAO) 取自\"http://open.taobao.com/dev/index.php/%E4%BA%A4%E6%98%93%E7%8A%B6%E6%80%81\"',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卖家收货地址',
  `advance_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款先行垫付默认的未申请状态 0;退款先行垫付申请中 1;退款先行垫付，垫付完成 2;退款先行垫付，卖家拒绝收货 3;退款先行垫付，垫付关闭 4;退款先行垫付，垫付分账成功 5;',
  `alipay_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付宝交易号',
  `good_return_time` datetime NULL DEFAULT NULL COMMENT '退货时间。格式:yyyy-MM-dd HH:mm:ss',
  `good_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '货物状态。可选值BUYER_NOT_RECEIVED (买家未收到货) BUYER_RECEIVED (买家已收到货) BUYER_RETURNED_GOODS (买家已退货)',
  `has_good_return` int NULL DEFAULT NULL COMMENT '买家是否需要退货。可选值:true(是),false(否)',
  `num_iid` bigint NULL DEFAULT NULL COMMENT '申请退款的商品数字编号',
  `num` bigint NOT NULL DEFAULT 0 COMMENT '退货数量',
  `outer_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品外部商家编码',
  `reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款原因',
  `refund_phase` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款阶段，可选值：onsale/aftersale',
  `shipping_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流方式.可选值:free(卖家包邮),post(平邮),express(快递),ems(EMS).',
  `desc1` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款说明',
  `company_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流公司',
  `sid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退货运单号',
  `send_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家发货时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '	完结时间。格式:yyyy-MM-dd HH:mm:ss',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题',
  `sku` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品SKU信息',
  `buyer_open_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家openUid',
  `buyer_nick` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家昵称',
  `combine_item_info` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组合品信息\r\nnum_iid	String	2342344	商品数字编号\r\nitem_name	String	测试商品	商品标题\r\nquantity	Number	123	数量\r\nsku_id	String	123	sku_id\r\nouter_iid	String	123	商家外部编码(可与商家外部系统对接)\r\nouter_sku_id	String	123	123',
  `create_time` datetime NULL DEFAULT NULL COMMENT '订单创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '平台skuId',
  `o_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `refund_id_index`(`refund_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '淘宝退款表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_tao_refund
-- ----------------------------

-- ----------------------------
-- Table structure for oms_tao_waybill_account
-- ----------------------------
DROP TABLE IF EXISTS `oms_tao_waybill_account`;
CREATE TABLE `oms_tao_waybill_account`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `seller_id` bigint NULL DEFAULT NULL COMMENT '商家ID',
  `cp_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流服务商编码',
  `cp_type` int NULL DEFAULT NULL COMMENT '1是直营，2是加盟',
  `quantity` int NULL DEFAULT NULL COMMENT '可用单数',
  `allocated_quantity` int NULL DEFAULT NULL COMMENT '已用单数',
  `branch_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网点ID',
  `branch_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网点名称',
  `print_quantity` int NULL DEFAULT NULL COMMENT '已经打印的面单总数',
  `cancel_quantity` int NULL DEFAULT NULL COMMENT '取消的面对总数',
  `waybill_address_id` bigint NULL DEFAULT NULL COMMENT 'waybill 地址记录ID(非地址库ID)',
  `province` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省名称（一级地址）',
  `city` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市名称（二级地址）',
  `area` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区名称（三级地址）',
  `address_detail` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货人',
  `mobile` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货手机号',
  `phone` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货固定电话',
  `is_show` int NULL DEFAULT NULL COMMENT '是否前台显示1显示0不显示',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '淘宝电子面单账户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_tao_waybill_account
-- ----------------------------

-- ----------------------------
-- Table structure for oms_wei_goods
-- ----------------------------
DROP TABLE IF EXISTS `oms_wei_goods`;
CREATE TABLE `oms_wei_goods`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NULL DEFAULT NULL COMMENT '店铺id',
  `product_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '平台商品id',
  `out_product_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家编码id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题',
  `sub_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `head_imgs` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主图集合',
  `head_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第一张主图',
  `desc_info` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品详情字符串',
  `attrs` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '属性字符串',
  `status` int NULL DEFAULT NULL COMMENT '状态',
  `edit_status` int NULL DEFAULT NULL COMMENT '编辑状态',
  `min_price` int NULL DEFAULT NULL COMMENT '商品 SKU 最小价格（单位：分）',
  `spu_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品编码',
  `product_type` int NULL DEFAULT NULL COMMENT '商品类型。1: 小店普通自营商品；2: 福袋抽奖商品；3: 直播间闪电购商品。注意: 福袋抽奖、直播间闪电购类型的商品为只读数据，不支持编辑、上架操作，不支持用data_type=2的参数获取。',
  `edit_time` int NULL DEFAULT NULL COMMENT '商品草稿最近一次修改时间',
  `erp_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_wei_goods
-- ----------------------------

-- ----------------------------
-- Table structure for oms_wei_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `oms_wei_goods_sku`;
CREATE TABLE `oms_wei_goods_sku`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NULL DEFAULT NULL COMMENT '店铺id',
  `product_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '产品id',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'skuID',
  `out_sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家自定义skuID。如果添加时没录入，回包可能不包含该字段',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题',
  `thumb_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku小图',
  `sale_price` int NULL DEFAULT NULL COMMENT '售卖价格，以分为单位',
  `stock_num` int NULL DEFAULT NULL COMMENT 'sku库存',
  `sku_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku编码',
  `status` int NULL DEFAULT NULL COMMENT 'sku状态',
  `sku_attr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku属性',
  `sku_attrs` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku_attrs',
  `sku_deliver_info` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku_deliver_info',
  `erp_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `erp_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sku_id_index`(`sku_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 64 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_wei_goods_sku
-- ----------------------------

-- ----------------------------
-- Table structure for oms_wei_order
-- ----------------------------
DROP TABLE IF EXISTS `oms_wei_order`;
CREATE TABLE `oms_wei_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` int NULL DEFAULT NULL COMMENT '店铺id',
  `order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `openid` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家身份标识',
  `create_time` int NULL DEFAULT NULL COMMENT '秒级时间戳',
  `update_time` int NULL DEFAULT NULL COMMENT '秒级时间戳',
  `unionid` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `status` int NULL DEFAULT NULL COMMENT '状态10	待付款；20	待发货；21	部分发货；30	待收货；100	完成；200	全部商品售后之后，订单取消；250	未付款用户主动取消或超时未付款订单自动取消；',
  `aftersale_detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '售后信息json',
  `pay_info` varchar(5500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付信息json',
  `product_price` int NULL DEFAULT NULL COMMENT '商品总价，单位为分',
  `order_price` int NULL DEFAULT NULL COMMENT '订单金额，单位为分，order_price=original_order_price-discounted_price-deduction_price-change_down_price',
  `freight` int NULL DEFAULT NULL COMMENT '运费，单位为分',
  `discounted_price` int NULL DEFAULT NULL COMMENT '优惠券优惠金额，单位为分',
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货人姓名',
  `postal_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮编',
  `province_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省份',
  `city_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '城市',
  `county_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区',
  `detail_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `tel_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系方式\r\n',
  `house_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '门牌号码',
  `virtual_order_tel_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '虚拟发货订单联系方式(deliver_method=1时返回)',
  `tel_number_ext_info` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '额外的联系方式信息（虚拟号码相关）',
  `use_tel_number` int NULL DEFAULT NULL COMMENT '0：不使用虚拟号码，1：使用虚拟号码',
  `hash_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标识当前店铺下一个唯一的用户收货地址',
  `delivery_product_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '发货物流信息JSON',
  `ship_done_time` int NULL DEFAULT NULL COMMENT '发货完成时间，秒级时间戳',
  `ewaybill_order_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '电子面单代发时的订单密文\r\n',
  `settle_info` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '结算信息json',
  `audit_status` int NULL DEFAULT NULL COMMENT '订单审核状态（0待审核1已审核）',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '订单审核时间',
  `erp_send_company` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'erp发货快递公司',
  `erp_send_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'erp发货快递单号',
  `erp_send_status` int NULL DEFAULT 0 COMMENT 'erp发货状态',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_id_index`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_wei_order
-- ----------------------------

-- ----------------------------
-- Table structure for oms_wei_order_item
-- ----------------------------
DROP TABLE IF EXISTS `oms_wei_order_item`;
CREATE TABLE `oms_wei_order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单id（平台订单id）',
  `product_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品spuid',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品skuid\r\n',
  `thumb_img` varchar(550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku小图',
  `sku_cnt` int NULL DEFAULT NULL COMMENT 'sku数量',
  `sale_price` int NULL DEFAULT NULL COMMENT '售卖单价（单位：分）',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品标题',
  `on_aftersale_sku_cnt` int NULL DEFAULT NULL COMMENT '正在售后/退款流程中的 sku 数量',
  `finish_aftersale_sku_cnt` int NULL DEFAULT NULL COMMENT '完成售后/退款的 sku 数量',
  `sku_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品编码',
  `market_price` int NULL DEFAULT NULL COMMENT '市场单价（单位：分）',
  `sku_attrs` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sku属性JSON',
  `real_price` int NULL DEFAULT NULL COMMENT 'sku实付总价，取estimate_price和change_price中较小值',
  `out_product_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品外部spuid',
  `out_sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品外部skuid',
  `is_discounted` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否有优惠金额，非必填，默认为false',
  `estimate_price` int NULL DEFAULT NULL COMMENT '优惠后sku总价，非必填，is_discounted为true时有值',
  `is_change_price` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否修改过价格，非必填，默认为false',
  `change_price` int NULL DEFAULT NULL COMMENT '改价后sku总价，非必填，is_change_price为true时有值',
  `out_warehouse_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区域库存id',
  `sku_deliver_info` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品发货信息JSON',
  `extra_service` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品额外服务信息JSON',
  `use_deduction` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否使用了会员积分抵扣\r\n',
  `deduction_price` int NULL DEFAULT NULL COMMENT '会员积分抵扣金额，单位为分',
  `order_product_coupon_info_list` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品优惠券信息，逐步替换 order.order_detail.coupon_info',
  `o_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_wei_order_item
-- ----------------------------

-- ----------------------------
-- Table structure for oms_wei_refund
-- ----------------------------
DROP TABLE IF EXISTS `oms_wei_refund`;
CREATE TABLE `oms_wei_refund`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` int NULL DEFAULT NULL COMMENT '店铺id',
  `after_sale_order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '售后单号',
  `after_sales_status` int NULL DEFAULT NULL COMMENT '售后状态（参考拼多多）',
  `after_sales_type` int NULL DEFAULT NULL COMMENT '售后类型（参考拼多多）',
  `status` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '售后单当前状态，参考：\r\nUSER_CANCELD	用户取消申请\r\nMERCHANT_PROCESSING	商家受理中\r\nMERCHANT_REJECT_REFUND	商家拒绝退款\r\nMERCHANT_REJECT_RETURN	商家拒绝退货退款\r\nUSER_WAIT_RETURN	待买家退货\r\nRETURN_CLOSED	退货退款关闭\r\nMERCHANT_WAIT_RECEIPT	待商家收货\r\nMERCHANT_OVERDUE_REFUND	商家逾期未退款\r\nMERCHANT_REFUND_SUCCESS	退款完成\r\nMERCHANT_RETURN_SUCCESS	退货退款完成\r\nPLATFORM_REFUNDING	平台退款中\r\nPLATFORM_REFUND_FAIL	平台退款失败\r\nUSER_WAIT_CONFIRM	待用户确认\r\nMERCHANT_REFUND_RETRY_FAIL	商家打款失败，客服关闭售后\r\nMERCHANT_FAIL	售后关闭\r\nUSER_WAIT_CONFIRM_UPDATE	待用户处理商家协商\r\nUSER_WAIT_HANDLE_MERCHANT_AFTER_SALE	待用户处理商家代发起的售后申请',
  `openid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家身份标识',
  `unionid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '买家在开放平台的唯一标识符，若当前视频号小店已绑定到微信开放平台账号下会返回',
  `product_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品spuid',
  `sku_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品skuid',
  `count` int NULL DEFAULT NULL COMMENT '售后数量',
  `fast_refund` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否极速退款RefundInfo',
  `refund_reason` int NULL DEFAULT NULL COMMENT '标明售后单退款直接原因, 枚举值参考 RefundReason',
  `refund_amount` int NULL DEFAULT NULL COMMENT '退款金额（分）',
  `return_waybill_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '快递单号',
  `return_delivery_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流公司id',
  `return_delivery_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '物流公司名称',
  `merchant_upload_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '售后相关商品信息JSON',
  `create_time` int NULL DEFAULT NULL COMMENT '售后单创建时间戳',
  `update_time` int NULL DEFAULT NULL COMMENT '售后单更新时间戳',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款原因',
  `reason_text` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退款原因解释',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '售后类型。REFUND:退款；RETURN:退货退款。',
  `order_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号，该字段可用于获取订单',
  `details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT 'detail json',
  `complaint_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '纠纷id，该字段可用于获取纠纷信息',
  `refund_resp` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信支付退款的响应',
  `pull_status` int NULL DEFAULT NULL COMMENT '推送状态（0未推送；1推送成功；2推送失败）',
  `pull_time` datetime NULL DEFAULT NULL COMMENT '订单审核时间',
  `o_goods_id` bigint NULL DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint NULL DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '视频号小店退款' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_wei_refund
-- ----------------------------

-- ----------------------------
-- Table structure for oms_wei_waybill_account
-- ----------------------------
DROP TABLE IF EXISTS `oms_wei_waybill_account`;
CREATE TABLE `oms_wei_waybill_account`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `seller_shop_id` bigint NULL DEFAULT NULL COMMENT '平台店铺id，全局唯一，一个店铺分配一个shop_id',
  `delivery_id` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '快递公司编码',
  `company_type` int NULL DEFAULT NULL COMMENT '快递公司类型1：加盟型 2：直营型',
  `site_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网点编码',
  `site_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网点名称',
  `acct_id` bigint NULL DEFAULT NULL COMMENT '电子面单账号id，每绑定一个网点分配一个acct_id',
  `acct_type` int NULL DEFAULT NULL COMMENT '面单账号类型0：普通账号 1：共享账号',
  `status` int NULL DEFAULT NULL COMMENT '面单账号状态',
  `available` int NULL DEFAULT NULL COMMENT '面单余额',
  `allocated` int NULL DEFAULT NULL COMMENT '累积已取单',
  `cancel` int NULL DEFAULT NULL COMMENT '累计已取消',
  `recycled` int NULL DEFAULT NULL COMMENT '累积已回收',
  `monthly_card` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '月结账号，company_type 为直营型时有效',
  `site_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '网点信息JSON',
  `sender_province` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省名称（一级地址）',
  `sender_city` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市名称（二级地址）',
  `sender_county` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `sender_street` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `sender_address` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货人',
  `mobile` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货手机号',
  `phone` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货固定电话',
  `is_show` int NULL DEFAULT NULL COMMENT '是否前台显示1显示0不显示',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '视频号小店电子面单账户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oms_wei_waybill_account
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '系统名称', 'sys.name', '启航电商OMS系统', 'Y', 'admin', '2023-08-07 19:31:38', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'false', 'Y', 'admin', '2023-08-07 19:31:38', '', NULL, '是否开启验证码功能（true开启，false关闭）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '启航技术', 0, '老齐', '15888888888', '280645618@qq.com', '0', '0', 'admin', '2023-08-07 19:31:37', 'admin', '2024-09-15 17:52:12');
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '研发中心', 1, '老齐', '15888888888', '280645618@qq.com', '0', '0', 'admin', '2023-08-07 19:31:37', 'admin', '2024-09-15 17:52:47');
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '市场中心', 2, '方', '15888888888', 'market@qihangerp.cn', '0', '0', 'admin', '2023-08-07 19:31:37', 'admin', '2024-09-15 17:53:28');
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '至简', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2023-08-07 19:31:37', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '至简', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2023-08-07 19:31:37', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '至简', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2023-08-07 19:31:37', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '至简', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2023-08-07 19:31:37', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '至简', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2023-08-07 19:31:37', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '至简', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2023-08-07 19:31:37', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '至简', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2023-08-07 19:31:37', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '路由参数',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2130 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '订单管理', 0, 10, '/order', 'Layout', '', 1, 0, 'M', '0', '0', '', 'shopping', 'admin', '2023-12-27 15:00:27', 'admin', '2024-08-25 15:45:43', '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '售后管理', 0, 30, '/refund', 'Layout', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2023-12-27 15:00:27', 'admin', '2024-08-25 15:45:54', '至简官网地址');
INSERT INTO `sys_menu` VALUES (3, '店铺&平台设置', 0, 50, 'shop', 'Layout', '', 1, 0, 'M', '0', '0', '', 'dict', 'admin', '2023-12-29 13:29:44', 'admin', '2025-10-01 02:33:33', '');
INSERT INTO `sys_menu` VALUES (4, '商品管理', 0, 1, 'goods', 'Layout', '', 1, 0, 'M', '0', '0', '', 'international', 'admin', '2023-12-29 16:53:03', 'admin', '2025-10-01 02:30:31', '');
INSERT INTO `sys_menu` VALUES (5, '系统设置', 0, 99, '/system', 'Layout', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2023-12-27 15:00:27', 'admin', '2023-12-29 09:07:42.856856', '系统管理目录');
INSERT INTO `sys_menu` VALUES (100, '发货订单库', 1, 1, 'order_list', 'order/index', '', 1, 0, 'C', '0', '0', '', 'shopping', 'admin', '2023-12-27 15:00:27', 'admin', '2025-10-01 08:17:29', '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '订单拉取日志', 1, 32, 'order_pull_logs', 'order/shopOrder/pull_log', '', 1, 0, 'C', '0', '0', '', 'documentation', 'admin', '2023-12-27 15:00:27', 'admin', '2025-05-19 14:11:59', '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '店铺订单管理', 1, 3, 'shop_order_list', 'order/shopOrder/index', '', 1, 0, 'C', '0', '0', '', 'monitor', 'admin', '2023-12-27 15:00:27', 'admin', '2024-04-06 11:18:00', '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (104, '售后中心', 2, 1, 'refund_list', 'refund/index', '', 1, 0, 'C', '0', '0', '', 'tree', 'admin', '2023-12-27 15:00:27', 'admin', '2024-09-15 18:58:16', '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '售后拉取日志', 2, 36, 'refund_pull_logs', 'refund/shopRefund/pull_log', '', 1, 0, 'C', '0', '0', '', 'dict', 'admin', '2023-12-27 15:00:27', 'admin', '2025-05-19 14:12:28', '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '店铺售后管理', 2, 2, 'shop_refund_list', 'refund/shopRefund/index', '', 1, 0, 'C', '0', '0', '', 'edit', 'admin', '2023-12-27 15:00:27', 'admin', '2024-07-20 11:56:11', '参数设置菜单');
INSERT INTO `sys_menu` VALUES (108, '店铺管理', 3, 1, 'shop_list', 'shop/index', '', 1, 0, 'C', '0', '0', '', 'tree', 'admin', '2023-12-29 09:14:02', 'admin', '2025-03-24 13:03:00', '');
INSERT INTO `sys_menu` VALUES (110, '平台开关', 3, 81, 'platform/setting', 'shop/platform/index', '', 1, 0, 'C', '0', '0', '', 'system', 'admin', '2023-12-29 13:32:41', 'admin', '2025-05-20 20:36:38', '');
INSERT INTO `sys_menu` VALUES (112, '商品库SKU明细', 4, 10, 'sku_list', 'goods/spec/index', '', 1, 0, 'C', '1', '0', '', 'tree', 'admin', '2023-12-29 16:35:55', 'admin', '2025-10-01 02:30:40', '');
INSERT INTO `sys_menu` VALUES (116, '用户管理', 5, 1, 'user', 'system/user/index', '', 1, 0, 'C', '0', '0', '', 'user', 'admin', '2023-12-27 15:00:27', '', '', '用户管理菜单');
INSERT INTO `sys_menu` VALUES (117, '菜单管理', 5, 1, 'menu', 'system/menu/index', '', 1, 0, 'C', '0', '0', '', 'user', 'admin', '2023-12-27 15:00:27', '', '', '用户管理菜单');
INSERT INTO `sys_menu` VALUES (2077, '店铺商品', 4, 21, 'shop_goods', 'shop/goods/index', NULL, 1, 0, 'C', '0', '0', '', 'shopping', 'admin', '2024-03-28 10:29:59', 'admin', '2025-10-08 03:16:26', '');
INSERT INTO `sys_menu` VALUES (2078, '添加商品', 4, 99, 'create', 'goods/create', NULL, 1, 0, 'C', '1', '0', '', 'checkbox', 'admin', '2024-03-18 07:59:57', 'admin', '2025-10-01 02:32:19', '');
INSERT INTO `sys_menu` VALUES (2079, '字典管理', 5, 9, 'dict', 'system/dict/index', NULL, 1, 0, 'C', '0', '0', '', 'dict', 'admin', '2024-03-18 08:43:55', 'admin', '2024-03-18 08:44:08', '');
INSERT INTO `sys_menu` VALUES (2087, '发货管理', 0, 20, 'ship', NULL, NULL, 1, 0, 'M', '0', '0', '', 'guide', 'admin', '2024-03-30 17:36:10', 'admin', '2024-08-25 15:45:48', '');
INSERT INTO `sys_menu` VALUES (2088, '发货设置', 2087, 9, 'ship_set', 'shipping/logistics/index', NULL, 1, 0, 'C', '0', '0', '', 'checkbox', 'admin', '2024-03-30 17:37:01', 'admin', '2025-06-01 15:02:10', '');
INSERT INTO `sys_menu` VALUES (2089, '发货记录', 2087, 3, 'record', 'shipping/record/index', NULL, 1, 0, 'C', '0', '0', '', 'guide', 'admin', '2024-03-30 17:37:42', 'admin', '2025-06-02 09:45:44', '');
INSERT INTO `sys_menu` VALUES (2090, '角色管理', 5, 2, 'role', 'system/role/index', NULL, 1, 0, 'C', '0', '0', NULL, 'peoples', 'admin', '2024-03-31 12:40:50', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2091, '部门管理', 5, 3, 'dept', 'system/dept/index', NULL, 1, 0, 'C', '0', '0', NULL, 'tree', 'admin', '2024-03-31 12:42:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2092, '售后处理记录', 2, 5, 'processing', 'afterSale/index', NULL, 1, 0, 'C', '0', '0', '', 'documentation', 'admin', '2024-04-06 17:27:03', 'admin', '2024-07-28 18:59:41', '');
INSERT INTO `sys_menu` VALUES (2093, '发货订单商品', 1, 2, 'order_item_list', 'order/item_list', NULL, 1, 0, 'C', '1', '1', '', 'chart', 'admin', '2024-04-06 18:58:06', 'admin', '2025-10-06 03:38:47', '');
INSERT INTO `sys_menu` VALUES (2094, '打单发货', 2087, 1, 'print', 'shipping/ewaybillPrint/index', NULL, 1, 0, 'C', '0', '0', '', 'edit', 'admin', '2024-07-20 11:04:54', 'admin', '2025-10-01 03:32:45', '');
INSERT INTO `sys_menu` VALUES (2096, '备货出库', 2087, 2, 'stockup', 'shipping/stockup/index.vue', NULL, 1, 0, 'C', '0', '0', '', 'email', 'admin', '2024-07-20 11:53:24', 'admin', '2025-10-08 07:59:43', '');
INSERT INTO `sys_menu` VALUES (2097, '物流跟踪', 2087, 5, 'logistics', 'shipping/stocking/index', NULL, 1, 0, 'C', '0', '1', '', 'list', 'admin', '2024-07-20 11:54:18', 'admin', '2025-05-25 14:32:27', '');
INSERT INTO `sys_menu` VALUES (2099, '私域订单管理', 1, 10, 'offline_order_list', 'order/private/index', NULL, 1, 0, 'C', '0', '1', '', 'checkbox', 'admin', '2024-07-27 17:33:03', 'admin', '2025-05-24 13:10:53', '');
INSERT INTO `sys_menu` VALUES (2100, '私域售后管理', 2, 3, 'offline_aftersale', 'refund/private/index', NULL, 1, 0, 'C', '0', '1', '', 'code', 'admin', '2024-07-27 17:33:33', 'admin', '2025-05-25 14:59:03', '');
INSERT INTO `sys_menu` VALUES (2103, '手动创建私域订单', 1, 49, 'offline_order_create', 'order/private/create', NULL, 1, 0, 'C', '1', '0', '', 'date', 'admin', '2024-07-27 20:30:07', 'admin', '2025-03-24 11:46:51', '');
INSERT INTO `sys_menu` VALUES (2104, '商品库', 4, 0, 'goods_list', 'goods/index', NULL, 1, 0, 'C', '0', '0', 'goods', 'example', 'admin', '2024-08-25 14:35:54', 'admin', '2025-10-01 02:30:12', '');
INSERT INTO `sys_menu` VALUES (2105, '库存管理', 0, 40, 'stock', NULL, NULL, 1, 0, 'M', '1', '1', '', 'lock', 'admin', '2024-08-25 15:54:14', 'admin', '2025-10-01 02:34:24', '');
INSERT INTO `sys_menu` VALUES (2106, '商品入库管理', 2105, 10, 'stock_in', 'stock/stockIn/index.vue', NULL, 1, 0, 'C', '0', '0', '', 'download', 'admin', '2024-08-25 15:56:04', 'admin', '2025-03-24 13:35:21', '');
INSERT INTO `sys_menu` VALUES (2108, '供应商管理', 4, 90, 'supplier_list', 'goods/supplier/index', NULL, 1, 0, 'C', '0', '0', '', 'people', 'admin', '2024-08-25 18:27:55', 'admin', '2024-09-07 15:51:17', '');
INSERT INTO `sys_menu` VALUES (2109, '分类管理', 4, 80, 'category_list', 'goods/category/index', NULL, 1, 0, 'C', '0', '0', '', 'edit', 'admin', '2024-08-25 18:43:28', 'admin', '2025-10-01 02:32:02', '');
INSERT INTO `sys_menu` VALUES (2110, '品牌管理', 4, 81, 'brand_list', 'goods/brand/index', NULL, 1, 0, 'C', '0', '0', '', 'icon', 'admin', '2024-08-25 18:45:47', 'admin', '2025-10-01 02:32:09', '');
INSERT INTO `sys_menu` VALUES (2111, '分类规格属性', 4, 101, 'goods_category/attribute', 'goods/category/categoryAttribute', NULL, 1, 0, 'C', '1', '0', '', 'button', 'admin', '2024-08-25 18:49:22', 'admin', '2024-09-07 16:17:01', '');
INSERT INTO `sys_menu` VALUES (2112, '规格属性值', 4, 102, 'goods_category/attribute_value', 'goods/category/categoryAttributeValue', NULL, 1, 0, 'C', '1', '0', '', 'date', 'admin', '2024-08-25 18:51:55', 'admin', '2024-09-07 16:23:53', '');
INSERT INTO `sys_menu` VALUES (2114, '仓库仓位设置', 2105, 90, 'warehouse', 'stock/warehouse/index.vue', NULL, 1, 0, 'C', '0', '0', '', 'cascader', 'admin', '2024-09-21 20:07:26', 'admin', '2025-03-24 13:46:52', '');
INSERT INTO `sys_menu` VALUES (2115, '商品库存', 4, 1, 'goods_stock', 'goods/stock/index.vue', NULL, 1, 0, 'C', '0', '0', '', 'chart', 'admin', '2024-09-21 20:43:00', 'admin', '2025-10-08 03:16:56', '');
INSERT INTO `sys_menu` VALUES (2116, '商品出库管理', 2105, 20, 'stock_out', 'stock/stockOut/index', NULL, 1, 0, 'C', '0', '0', '', 'guide', 'admin', '2024-09-21 20:44:46', 'admin', '2025-03-24 13:46:42', '');
INSERT INTO `sys_menu` VALUES (2117, '仓位管理', 2105, 91, 'position', 'stock/warehouse/position', NULL, 1, 0, 'C', '1', '0', '', '404', 'admin', '2024-09-22 11:52:18', 'admin', '2025-03-24 13:47:04', '');
INSERT INTO `sys_menu` VALUES (2118, '新建商品入库单', 2105, 11, 'stock_in/create', 'stock/stockIn/create.vue', NULL, 1, 0, 'C', '1', '0', '', '404', 'admin', '2024-09-22 14:49:40', 'admin', '2025-03-24 13:35:30', '');
INSERT INTO `sys_menu` VALUES (2129, '订单发货', 2087, 0, 'ship_order', 'shipping/shipment/index', NULL, 1, 0, 'C', '0', '0', '', 'checkbox', 'admin', '2025-06-01 13:36:57', 'admin', '2025-10-07 00:36:48', '');

-- ----------------------------
-- Table structure for sys_oss
-- ----------------------------
DROP TABLE IF EXISTS `sys_oss`;
CREATE TABLE `sys_oss`  (
  `oss_id` bigint NOT NULL AUTO_INCREMENT COMMENT '文件id',
  `file_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '文件名',
  `original_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '原名',
  `file_suffix` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '文件后缀名',
  `url` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'URL地址',
  `object_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '对象名',
  `bucket` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '桶名',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`oss_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文件表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oss
-- ----------------------------
INSERT INTO `sys_oss` VALUES (1, '主图画板 1.jpg', '主图画板 1.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/09/07/a3e935aa-d1b3-4524-bd84-e567df01f2e3.jpg', '/images/2024/09/07/a3e935aa-d1b3-4524-bd84-e567df01f2e3.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 17:38:57', '', NULL);
INSERT INTO `sys_oss` VALUES (2, '主图画板2.jpg', '主图画板2.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/09/07/1dbe1530-787f-4461-9f20-3efa3c332588.jpg', '/images/2024/09/07/1dbe1530-787f-4461-9f20-3efa3c332588.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 17:57:54', '', NULL);
INSERT INTO `sys_oss` VALUES (3, '主图画板5.jpg', '主图画板5.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/09/07/2dc06b89-8661-4a72-a7cd-7f85f4545c6e.jpg', '/images/2024/09/07/2dc06b89-8661-4a72-a7cd-7f85f4545c6e.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 18:03:24', '', NULL);
INSERT INTO `sys_oss` VALUES (4, '主图画板 4.jpg', '主图画板 4.jpg', '.jpg', 'http://127.0.0.1:9000/ecerp//images/2024/09/07/3ed00452-5973-4c7e-91ae-5e87aa32dd23.jpg', '/images/2024/09/07/3ed00452-5973-4c7e-91ae-5e87aa32dd23.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 18:03:46', '', NULL);
INSERT INTO `sys_oss` VALUES (5, '主图画板5.jpg', '主图画板5.jpg', '.jpg', 'http://127.0.0.1:9000/ecerp/images/2024/09/07/4b2583ae-65ae-45b6-9227-ebbee99d6558.jpg', '/images/2024/09/07/4b2583ae-65ae-45b6-9227-ebbee99d6558.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 18:04:47', '', NULL);
INSERT INTO `sys_oss` VALUES (6, '主图画板2.jpg', '主图画板2.jpg', '.jpg', 'http://223.83.100.30:9001/omsimage/images/2024/09/07/a64ff14b-09d4-42d6-8d52-0344360efdbf.jpg', '/images/2024/09/07/a64ff14b-09d4-42d6-8d52-0344360efdbf.jpg', 'omsimage', 0, '0', '0', '', '2024-09-07 19:10:39', '', NULL);
INSERT INTO `sys_oss` VALUES (7, '主图画板 1.jpg', '主图画板 1.jpg', '.jpg', 'http://223.83.100.30:9001/omsimage/images/2024/09/07/af19385d-a1dd-4efb-8257-3099706d1272.jpg', '/images/2024/09/07/af19385d-a1dd-4efb-8257-3099706d1272.jpg', 'omsimage', 0, '0', '0', '', '2024-09-07 19:26:36', '', NULL);
INSERT INTO `sys_oss` VALUES (8, '主图画板 1.jpg', '主图画板 1.jpg', '.jpg', 'http://223.83.100.30:9001/omsimage/images/2024/09/07/5aac40e1-ddc1-41a8-a468-28d81e699980.jpg', '/images/2024/09/07/5aac40e1-ddc1-41a8-a468-28d81e699980.jpg', 'omsimage', 0, '0', '0', '', '2024-09-07 20:37:14', '', NULL);
INSERT INTO `sys_oss` VALUES (9, '主图画板 1.jpg', '主图画板 1.jpg', '.jpg', 'http://223.83.100.30:9001/omsimage/images/2024/09/07/b28f4e15-8997-418c-bd32-b4beb4966f6b.jpg', '/images/2024/09/07/b28f4e15-8997-418c-bd32-b4beb4966f6b.jpg', 'omsimage', 0, '0', '0', '', '2024-09-07 20:37:51', '', NULL);
INSERT INTO `sys_oss` VALUES (50, 'x4.jpg', 'x4.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/08/28/x4.jpg', '/images/2024/08/28/x4.jpg', 'ecerp', 0, '0', '0', '', '2024-08-28 22:39:05', '', NULL);
INSERT INTO `sys_oss` VALUES (51, 'x11.jpg', 'x11.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/08/28/x11.jpg', '/images/2024/08/28/x11.jpg', 'ecerp', 0, '0', '0', '', '2024-08-28 22:47:11', '', NULL);
INSERT INTO `sys_oss` VALUES (52, '主图画板 4.jpg', '主图画板 4.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/09/07/主图画板 4.jpg', '/images/2024/09/07/主图画板 4.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 17:31:44', '', NULL);
INSERT INTO `sys_oss` VALUES (53, '主图画板 4.jpg', '主图画板 4.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/09/07/主图画板 4.jpg', '/images/2024/09/07/主图画板 4.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 17:35:41', '', NULL);
INSERT INTO `sys_oss` VALUES (54, '主图画板 1.jpg', '主图画板 1.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/09/07/f35a3cb8-1b9e-41f4-8158-31d458c7efb3.jpg', '/images/2024/09/07/f35a3cb8-1b9e-41f4-8158-31d458c7efb3.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 17:36:09', '', NULL);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2023-08-07 19:31:37', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2023-08-07 19:31:37', 'admin', '2025-10-01 02:31:21', '普通角色');

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------

-- ----------------------------
-- Table structure for sys_task
-- ----------------------------
DROP TABLE IF EXISTS `sys_task`;
CREATE TABLE `sys_task`  (
  `id` int NOT NULL,
  `task_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `cron` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '后台任务配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_task
-- ----------------------------
INSERT INTO `sys_task` VALUES (1, '拉取淘宝订单', '-', NULL, '定时更新淘宝订单', '2024-03-07 09:52:40');
INSERT INTO `sys_task` VALUES (2, '拉取京东POP订单', '-', NULL, '拉取京东POP订单', '2024-03-07 09:23:36');
INSERT INTO `sys_task` VALUES (3, '拉取拼多多订单', '-', NULL, '定时拉取拼多多订单', '2024-04-09 11:24:14');
INSERT INTO `sys_task` VALUES (4, '拉取抖店订单', '-', NULL, '定时拉取抖店订单', '2024-04-09 11:24:54');
INSERT INTO `sys_task` VALUES (5, '拉取天猫退款', '-', NULL, '定时拉取天猫退款', '2024-04-09 11:25:43');
INSERT INTO `sys_task` VALUES (6, '拉取京东售后', '-', NULL, '定时拉取京东售后', '2024-04-09 11:26:26');
INSERT INTO `sys_task` VALUES (7, '拉取拼多多退款', '-', NULL, '定时拉取拼多多退款', '2024-04-09 11:27:01');
INSERT INTO `sys_task` VALUES (8, '拉取抖店退款', '-', NULL, '定时拉取抖店退款', '2024-04-09 11:27:38');
INSERT INTO `sys_task` VALUES (11, '拉取京东自营订单', '-', NULL, '拉取京东自营订单', '2024-05-27 10:57:44');
INSERT INTO `sys_task` VALUES (12, '拉取京东自营退货', '-', NULL, '拉取京东自营退货', NULL);
INSERT INTO `sys_task` VALUES (21, '推送待发货订单到ERP', '-', NULL, '推送待发货订单到ERP', '2024-04-22 15:48:48');
INSERT INTO `sys_task` VALUES (22, '推送待处理售后到ERP', '-', NULL, '推送待处理售后到ERP', '2024-04-22 15:48:48');
INSERT INTO `sys_task` VALUES (23, '推送已取消的订单到ERP', '-', NULL, '推送已取消的订单到ERP', '2024-05-29 17:57:02');

-- ----------------------------
-- Table structure for sys_task_logs
-- ----------------------------
DROP TABLE IF EXISTS `sys_task_logs`;
CREATE TABLE `sys_task_logs`  (
  `id` bigint NOT NULL COMMENT '主键ID',
  `task_id` int NULL DEFAULT NULL COMMENT '任务ID',
  `result` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '结果',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始运行时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `status` int NULL DEFAULT NULL COMMENT '状态1运行中，2已结束',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '后台任务运行日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_task_logs
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, NULL, 'admin', '启航老齐A', '00', '280645618@qq.com', '18123879144', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-10-08 15:19:04', 'admin', '2023-08-07 19:31:37', '', '2025-10-08 07:19:04', '管理员');
INSERT INTO `sys_user` VALUES (2, NULL, 'openapi', 'openApi接口专用', '00', '2806456181@qq.com', '15818590000', '0', '', '$2a$10$fHkhoqbMiyracAsTzl38H.55bu.M.of1FXk2EK7RQBjfic3tLU0Ue', '0', '0', '127.0.0.1', '2024-06-24 10:23:35', 'admin', '2024-03-17 14:55:22', 'admin', '2024-06-24 10:23:35', NULL);
INSERT INTO `sys_user` VALUES (101, 101, '15818590119', 'aaa123', '00', '', '', '0', '', '$2a$10$pXcT6cHaObMeKuYd9vZb5uEb8PyUdF2AcqqRN1cBqiA9rV4qYQW7G', '0', '2', '', NULL, 'admin', '2024-08-15 13:45:25', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (102, 101, '15818590119', '老齐', '00', '', '', '0', '', '$2a$10$ysk.zgJ8wh25c7vOjKyZ8uarM2hkG0S51j8GYdJSo2kZmc3f8HdKe', '0', '0', '', NULL, 'admin', '2024-08-15 13:49:59', 'admin', '2025-02-10 16:26:20', NULL);
INSERT INTO `sys_user` VALUES (103, 100, '18025303180', '老方', '00', '', '', '0', '', '$2a$10$QnLM3NluG5q1xpmWep0QUOFfvNrd02hwenL4HkV0uhMbm4cEX1uIG', '0', '0', '', NULL, 'admin', '2024-09-21 17:17:56', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (102, 2);
INSERT INTO `sys_user_role` VALUES (103, 2);

SET FOREIGN_KEY_CHECKS = 1;
