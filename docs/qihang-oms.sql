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

 Date: 20/01/2026 18:58:54
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for o_after_sale
-- ----------------------------
DROP TABLE IF EXISTS `o_after_sale`;
CREATE TABLE `o_after_sale` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type` int DEFAULT NULL COMMENT '类型（0无需处理；10退货；20换货；80补发；99订单拦截；）',
  `shop_id` bigint DEFAULT NULL COMMENT '店铺id',
  `shop_type` int DEFAULT NULL COMMENT '店铺类型',
  `refund_id` bigint DEFAULT NULL COMMENT '退款id（o_refund表主键）',
  `refund_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '售后单号',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单号',
  `sub_order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '子订单号',
  `o_order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单id（o_order表主键id）',
  `o_order_item_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '子订单id（o_order_item表主键id）',
  `sku_id` bigint DEFAULT NULL COMMENT '平台商品skuid',
  `quantity` int DEFAULT NULL COMMENT '售后数量',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品标题',
  `img` varchar(555) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品图片',
  `sku_info` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku描述',
  `sku_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku编码',
  `o_goods_id` bigint DEFAULT NULL COMMENT '系统商品id（o_goods表主键id）',
  `o_goods_sku_id` bigint DEFAULT NULL COMMENT '系统商品skuId（o_goods表主键id）',
  `has_goods_send` int DEFAULT NULL COMMENT ' 是否发货',
  `send_logistics_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货物流单号',
  `return_info` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退回人信息json',
  `return_logistics_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退回快递单号',
  `return_logistics_company` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退回物流公司名称',
  `receiver_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人姓名',
  `receiver_tel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人联系电话',
  `receiver_province` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '省',
  `receiver_city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '市',
  `receiver_town` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '区',
  `receiver_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人详细地址',
  `reissue_logistics_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货快递单号（补发、换货发货）',
  `reissue_logistics_company` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货快递公司',
  `status` int DEFAULT NULL COMMENT '状态:0待处理；1已发出；2已收货；10已完成',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `update_by` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='OMS售后处理表';

-- ----------------------------
-- Records of o_after_sale
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for o_goods
-- ----------------------------
DROP TABLE IF EXISTS `o_goods`;
CREATE TABLE `o_goods` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '商品名称',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品图片地址',
  `outer_erp_goods_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品唯一ID',
  `goods_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '商品编号',
  `unit_name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '单位名称',
  `category_id` bigint DEFAULT '0' COMMENT '商品分类ID',
  `bar_code` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '条码',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态1销售中2已下架',
  `length` float NOT NULL DEFAULT '0' COMMENT '衣长/裙长/裤长',
  `height` float NOT NULL DEFAULT '0' COMMENT '高度/袖长',
  `width` float NOT NULL DEFAULT '0' COMMENT '宽度/胸阔(围)',
  `width1` float NOT NULL DEFAULT '0' COMMENT '肩阔',
  `width2` float NOT NULL DEFAULT '0' COMMENT '腰阔',
  `width3` float NOT NULL DEFAULT '0' COMMENT '臀阔',
  `weight` float NOT NULL DEFAULT '0' COMMENT '重量',
  `disable` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0启用   1禁用',
  `period` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '保质期',
  `pur_price` decimal(8,2) DEFAULT '0.00' COMMENT '预计采购价格',
  `whole_price` decimal(8,2) DEFAULT '0.00' COMMENT '建议批发价',
  `retail_price` decimal(8,2) DEFAULT '0.00' COMMENT '建议零售价',
  `unit_cost` decimal(8,2) DEFAULT NULL COMMENT '单位成本',
  `supplier_id` bigint DEFAULT '0' COMMENT '供应商id',
  `brand_id` bigint DEFAULT '0' COMMENT '品牌id',
  `attr1` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '属性1：季节',
  `attr2` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '属性2：分类',
  `attr3` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '属性3：风格',
  `attr4` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '属性4：年份',
  `attr5` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '属性5：面料',
  `link_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '外链url',
  `low_qty` int DEFAULT '0' COMMENT '最低库存（预警）',
  `high_qty` int DEFAULT '0' COMMENT '最高库存（预警）',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `province` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发货地省',
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发货地市',
  `town` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发货地区',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `goods_id_unique` (`outer_erp_goods_id`) USING BTREE,
  KEY `number` (`goods_num`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='OMS商品表';

-- ----------------------------
-- Records of o_goods
-- ----------------------------
BEGIN;
INSERT INTO `o_goods` (`id`, `name`, `image`, `outer_erp_goods_id`, `goods_num`, `unit_name`, `category_id`, `bar_code`, `remark`, `status`, `length`, `height`, `width`, `width1`, `width2`, `width3`, `weight`, `disable`, `period`, `pur_price`, `whole_price`, `retail_price`, `unit_cost`, `supplier_id`, `brand_id`, `attr1`, `attr2`, `attr3`, `attr4`, `attr5`, `link_url`, `low_qty`, `high_qty`, `create_by`, `create_time`, `update_by`, `update_time`, `province`, `city`, `town`) VALUES (16, '雷士照明led吸顶灯管灯芯改造灯板圆形灯盘节能灯泡替换光源模组', 'https://cbu01.alicdn.com/img/ibank/O1CN01LUp3xX1UZhfp9zoR1_!!2215604672532-0-cib.jpg', NULL, 'LSDX001', '', 3, '', '', 1, 0, 0, 0, 0, 0, 0, 0, 0, '0', 25.00, 0.00, 0.00, NULL, 1975713491747684353, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 'admin', '2025-10-08 10:57:17', NULL, NULL, NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for o_goods_brand
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_brand`;
CREATE TABLE `o_goods_brand` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '品牌名',
  `status` int DEFAULT NULL COMMENT '状态',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of o_goods_brand
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for o_goods_category
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_category`;
CREATE TABLE `o_goods_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `number` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分类编码',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分类名称',
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `parent_id` bigint DEFAULT NULL COMMENT '上架分类id',
  `path` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '分类路径',
  `sort` int DEFAULT '0' COMMENT '排序值',
  `image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '图片',
  `isDelete` tinyint(1) DEFAULT '0' COMMENT '0正常  1删除',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of o_goods_category
-- ----------------------------
BEGIN;
INSERT INTO `o_goods_category` (`id`, `number`, `name`, `remark`, `parent_id`, `path`, `sort`, `image`, `isDelete`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (3, 'ZM', '照明', NULL, 0, '', 0, NULL, 0, 'admin', '2025-10-08 08:02:22', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for o_goods_category_attribute
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_category_attribute`;
CREATE TABLE `o_goods_category_attribute` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `category_id` bigint NOT NULL,
  `type` int NOT NULL DEFAULT '0' COMMENT '类型：0属性1规格',
  `title` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '''属性名''',
  `code` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '固定值color颜色size尺码style款式',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of o_goods_category_attribute
-- ----------------------------
BEGIN;
INSERT INTO `o_goods_category_attribute` (`id`, `category_id`, `type`, `title`, `code`) VALUES (2, 3, 1, '颜色', 'color');
INSERT INTO `o_goods_category_attribute` (`id`, `category_id`, `type`, `title`, `code`) VALUES (3, 3, 1, '亮度', 'size');
COMMIT;

-- ----------------------------
-- Table structure for o_goods_category_attribute_value
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_category_attribute_value`;
CREATE TABLE `o_goods_category_attribute_value` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键，属性值id',
  `category_attribute_id` bigint DEFAULT NULL COMMENT '属性id',
  `value` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性值文本',
  `sku_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生成SKU的编码',
  `orderNum` int DEFAULT '0',
  `isDelete` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=432 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of o_goods_category_attribute_value
-- ----------------------------
BEGIN;
INSERT INTO `o_goods_category_attribute_value` (`id`, `category_attribute_id`, `value`, `sku_code`, `orderNum`, `isDelete`) VALUES (427, 2, '白光', '00', 0, 0);
INSERT INTO `o_goods_category_attribute_value` (`id`, `category_attribute_id`, `value`, `sku_code`, `orderNum`, `isDelete`) VALUES (428, 3, '12W', '12W', 0, 0);
INSERT INTO `o_goods_category_attribute_value` (`id`, `category_attribute_id`, `value`, `sku_code`, `orderNum`, `isDelete`) VALUES (429, 3, '18W', '18W', 0, 0);
INSERT INTO `o_goods_category_attribute_value` (`id`, `category_attribute_id`, `value`, `sku_code`, `orderNum`, `isDelete`) VALUES (430, 3, '24W', '24W', 0, 0);
INSERT INTO `o_goods_category_attribute_value` (`id`, `category_attribute_id`, `value`, `sku_code`, `orderNum`, `isDelete`) VALUES (431, 3, '36W', '36W', 0, 0);
COMMIT;

-- ----------------------------
-- Table structure for o_goods_inventory
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_inventory`;
CREATE TABLE `o_goods_inventory` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `goods_id` bigint NOT NULL COMMENT '商品id',
  `goods_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品编码',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名',
  `goods_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品图片',
  `sku_id` bigint NOT NULL COMMENT '商品规格id',
  `sku_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '规格编码（唯一）',
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'SKU名',
  `quantity` bigint NOT NULL DEFAULT '0' COMMENT '当前库存',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0正常  1删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `specIdIndex` (`sku_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='商品库存表';

-- ----------------------------
-- Records of o_goods_inventory
-- ----------------------------
BEGIN;
INSERT INTO `o_goods_inventory` (`id`, `goods_id`, `goods_num`, `goods_name`, `goods_img`, `sku_id`, `sku_code`, `sku_name`, `quantity`, `is_delete`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES (45, 16, 'LSDX001', NULL, NULL, 45, 'LSDX0010012W', NULL, 18, 0, '2025-10-08 10:57:17', '添加商品', '2025-10-08 16:48:43', '发货出库');
INSERT INTO `o_goods_inventory` (`id`, `goods_id`, `goods_num`, `goods_name`, `goods_img`, `sku_id`, `sku_code`, `sku_name`, `quantity`, `is_delete`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES (46, 16, 'LSDX001', NULL, NULL, 46, 'LSDX0010018W', NULL, 0, 0, '2025-10-08 10:57:17', '添加商品', '2025-10-08 02:57:16', NULL);
INSERT INTO `o_goods_inventory` (`id`, `goods_id`, `goods_num`, `goods_name`, `goods_img`, `sku_id`, `sku_code`, `sku_name`, `quantity`, `is_delete`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES (47, 16, 'LSDX001', NULL, NULL, 47, 'LSDX0010024W', NULL, 0, 0, '2025-10-08 10:57:17', '添加商品', '2025-10-08 02:57:16', NULL);
INSERT INTO `o_goods_inventory` (`id`, `goods_id`, `goods_num`, `goods_name`, `goods_img`, `sku_id`, `sku_code`, `sku_name`, `quantity`, `is_delete`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES (48, 16, 'LSDX001', NULL, NULL, 48, 'LSDX0010036W', NULL, 0, 0, '2025-10-08 10:57:17', '添加商品', '2025-10-08 02:57:16', NULL);
COMMIT;

-- ----------------------------
-- Table structure for o_goods_inventory_batch
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_inventory_batch`;
CREATE TABLE `o_goods_inventory_batch` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `inventory_id` bigint NOT NULL COMMENT '库存id',
  `batch_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '批次号',
  `qty` int NOT NULL COMMENT '操作数量',
  `origin_qty` int NOT NULL COMMENT '初始数量',
  `current_qty` int NOT NULL DEFAULT '0' COMMENT '当前数量',
  `pur_price` double NOT NULL DEFAULT '0' COMMENT '采购价',
  `pur_id` bigint NOT NULL DEFAULT '0' COMMENT '采购单id',
  `pur_item_id` bigint NOT NULL DEFAULT '0' COMMENT '采购单itemId',
  `remark` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `sku_id` bigint NOT NULL COMMENT '规格id',
  `goods_id` bigint NOT NULL COMMENT '商品id',
  `sku_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku编码',
  `warehouse_id` bigint NOT NULL COMMENT '仓库id',
  `position_id` bigint NOT NULL COMMENT '仓位id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='商品库存批次';

-- ----------------------------
-- Records of o_goods_inventory_batch
-- ----------------------------
BEGIN;
INSERT INTO `o_goods_inventory_batch` (`id`, `inventory_id`, `batch_num`, `qty`, `origin_qty`, `current_qty`, `pur_price`, `pur_id`, `pur_item_id`, `remark`, `sku_id`, `goods_id`, `sku_code`, `warehouse_id`, `position_id`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES (2, 45, '20251008154746', -1, 0, -1, 0, 0, 0, '发货出库250929-351611154071222', 45, 16, 'LSDX0010012W', 0, 0, '2025-10-08 15:47:46', '发货出库', '2025-10-08 15:47:46', NULL);
INSERT INTO `o_goods_inventory_batch` (`id`, `inventory_id`, `batch_num`, `qty`, `origin_qty`, `current_qty`, `pur_price`, `pur_id`, `pur_item_id`, `remark`, `sku_id`, `goods_id`, `sku_code`, `warehouse_id`, `position_id`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES (3, 45, '20251008155858', 1, -1, -2, 0, 0, 0, '发货出库250929-351611154071222', 45, 16, 'LSDX0010012W', 0, 0, '2025-10-08 15:58:59', '发货出库', '2025-10-08 15:58:59', NULL);
INSERT INTO `o_goods_inventory_batch` (`id`, `inventory_id`, `batch_num`, `qty`, `origin_qty`, `current_qty`, `pur_price`, `pur_id`, `pur_item_id`, `remark`, `sku_id`, `goods_id`, `sku_code`, `warehouse_id`, `position_id`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES (4, 45, '20251008164842', 20, -2, 18, 0, 0, 0, '增加库存：采购', 45, 16, 'LSDX0010012W', 0, 0, '2025-10-08 16:48:43', '增加库存', '2025-10-08 16:48:43', NULL);
COMMIT;

-- ----------------------------
-- Table structure for o_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_sku`;
CREATE TABLE `o_goods_sku` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `goods_id` bigint NOT NULL COMMENT '外键（o_goods）',
  `outer_erp_goods_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '外部erp系统商品id',
  `outer_erp_sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '外部erp系统skuId(唯一)',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名',
  `goods_num` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品编码',
  `sku_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '规格名',
  `sku_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规格编码',
  `color_label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '颜色label',
  `color_id` bigint DEFAULT '0' COMMENT '颜色id',
  `color_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '颜色值',
  `color_image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '颜色图片',
  `size_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '尺码label',
  `size_id` bigint DEFAULT '0' COMMENT '尺码id',
  `size_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '尺码值(材质)',
  `style_label` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '款式label',
  `style_id` bigint DEFAULT '0' COMMENT '款式id',
  `style_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '款式值',
  `bar_code` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '库存条形码',
  `pur_price` decimal(8,2) DEFAULT '0.00' COMMENT '预计采购价格',
  `retail_price` decimal(8,2) DEFAULT '0.00' COMMENT '建议零售价',
  `unit_cost` decimal(8,2) DEFAULT '0.00' COMMENT '单位成本',
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `low_qty` int DEFAULT '0' COMMENT '最低库存（预警）',
  `high_qty` int DEFAULT '0' COMMENT '最高库存（预警）',
  `volume` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'erp商品体积',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `sku_id_unique` (`outer_erp_sku_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `number` (`sku_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='OMS商品SKU表';

-- ----------------------------
-- Records of o_goods_sku
-- ----------------------------
BEGIN;
INSERT INTO `o_goods_sku` (`id`, `goods_id`, `outer_erp_goods_id`, `outer_erp_sku_id`, `goods_name`, `goods_num`, `sku_name`, `sku_code`, `color_label`, `color_id`, `color_value`, `color_image`, `size_label`, `size_id`, `size_value`, `style_label`, `style_id`, `style_value`, `bar_code`, `pur_price`, `retail_price`, `unit_cost`, `remark`, `status`, `low_qty`, `high_qty`, `volume`, `create_time`, `update_time`) VALUES (45, 16, NULL, NULL, '雷士照明led吸顶灯管灯芯改造灯板圆形灯盘节能灯泡替换光源模组', NULL, '白光 12W', 'LSDX0010012W', NULL, 427, '白光', 'https://cbu01.alicdn.com/img/ibank/O1CN01ZZTZb01UZhscuHvTj_!!2215604672532-0-cib.jpg', NULL, 428, '12W', NULL, 0, '', NULL, 25.00, 0.00, 0.00, '', 1, 0, 0, NULL, '2025-10-08 02:57:16', NULL);
INSERT INTO `o_goods_sku` (`id`, `goods_id`, `outer_erp_goods_id`, `outer_erp_sku_id`, `goods_name`, `goods_num`, `sku_name`, `sku_code`, `color_label`, `color_id`, `color_value`, `color_image`, `size_label`, `size_id`, `size_value`, `style_label`, `style_id`, `style_value`, `bar_code`, `pur_price`, `retail_price`, `unit_cost`, `remark`, `status`, `low_qty`, `high_qty`, `volume`, `create_time`, `update_time`) VALUES (46, 16, NULL, NULL, '雷士照明led吸顶灯管灯芯改造灯板圆形灯盘节能灯泡替换光源模组', NULL, '白光 18W', 'LSDX0010018W', NULL, 427, '白光', 'https://cbu01.alicdn.com/img/ibank/O1CN01bYBxVj1UZhsbltiGt_!!2215604672532-0-cib.jpg', NULL, 429, '18W', NULL, 0, '', NULL, 25.00, 0.00, 0.00, '', 1, 0, 0, NULL, '2025-10-08 02:57:16', NULL);
INSERT INTO `o_goods_sku` (`id`, `goods_id`, `outer_erp_goods_id`, `outer_erp_sku_id`, `goods_name`, `goods_num`, `sku_name`, `sku_code`, `color_label`, `color_id`, `color_value`, `color_image`, `size_label`, `size_id`, `size_value`, `style_label`, `style_id`, `style_value`, `bar_code`, `pur_price`, `retail_price`, `unit_cost`, `remark`, `status`, `low_qty`, `high_qty`, `volume`, `create_time`, `update_time`) VALUES (47, 16, NULL, NULL, '雷士照明led吸顶灯管灯芯改造灯板圆形灯盘节能灯泡替换光源模组', NULL, '白光 24W', 'LSDX0010024W', NULL, 427, '白光', 'https://cbu01.alicdn.com/img/ibank/O1CN01RBKirl1UZhsd6pgUY_!!2215604672532-0-cib.jpg', NULL, 430, '24W', NULL, 0, '', NULL, 25.00, 0.00, 0.00, '', 1, 0, 0, NULL, '2025-10-08 02:57:16', NULL);
INSERT INTO `o_goods_sku` (`id`, `goods_id`, `outer_erp_goods_id`, `outer_erp_sku_id`, `goods_name`, `goods_num`, `sku_name`, `sku_code`, `color_label`, `color_id`, `color_value`, `color_image`, `size_label`, `size_id`, `size_value`, `style_label`, `style_id`, `style_value`, `bar_code`, `pur_price`, `retail_price`, `unit_cost`, `remark`, `status`, `low_qty`, `high_qty`, `volume`, `create_time`, `update_time`) VALUES (48, 16, NULL, NULL, '雷士照明led吸顶灯管灯芯改造灯板圆形灯盘节能灯泡替换光源模组', NULL, '白光 36W', 'LSDX0010036W', NULL, 427, '白光', 'https://cbu01.alicdn.com/img/ibank/O1CN01opaMlf1UZhseOA2Zj_!!2215604672532-0-cib.jpg', NULL, 431, '36W', NULL, 0, '', NULL, 25.00, 0.00, 0.00, '', 1, 0, 0, NULL, '2025-10-08 02:57:16', NULL);
COMMIT;

-- ----------------------------
-- Table structure for o_goods_sku_attr
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_sku_attr`;
CREATE TABLE `o_goods_sku_attr` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `goods_id` bigint NOT NULL,
  `type` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `k` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `kid` int DEFAULT NULL,
  `vid` int DEFAULT NULL,
  `v` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `img` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of o_goods_sku_attr
-- ----------------------------
BEGIN;
INSERT INTO `o_goods_sku_attr` (`id`, `goods_id`, `type`, `k`, `kid`, `vid`, `v`, `img`) VALUES (1, 16, 'color', '颜色', 114, 427, NULL, NULL);
INSERT INTO `o_goods_sku_attr` (`id`, `goods_id`, `type`, `k`, `kid`, `vid`, `v`, `img`) VALUES (2, 16, 'size', '尺码', 115, 428, NULL, NULL);
INSERT INTO `o_goods_sku_attr` (`id`, `goods_id`, `type`, `k`, `kid`, `vid`, `v`, `img`) VALUES (3, 16, 'size', '尺码', 115, 429, NULL, NULL);
INSERT INTO `o_goods_sku_attr` (`id`, `goods_id`, `type`, `k`, `kid`, `vid`, `v`, `img`) VALUES (4, 16, 'size', '尺码', 115, 430, NULL, NULL);
INSERT INTO `o_goods_sku_attr` (`id`, `goods_id`, `type`, `k`, `kid`, `vid`, `v`, `img`) VALUES (5, 16, 'size', '尺码', 115, 431, NULL, NULL);
INSERT INTO `o_goods_sku_attr` (`id`, `goods_id`, `type`, `k`, `kid`, `vid`, `v`, `img`) VALUES (6, 16, 'style', '款式', 116, 427, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for o_goods_supplier
-- ----------------------------
DROP TABLE IF EXISTS `o_goods_supplier`;
CREATE TABLE `o_goods_supplier` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '供应商名称',
  `number` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '供应商编码',
  `taxRate` double DEFAULT '0' COMMENT '税率',
  `amount` double DEFAULT '0' COMMENT '期初应付款',
  `periodMoney` double DEFAULT '0' COMMENT '期初预付款',
  `difMoney` double DEFAULT '0' COMMENT '初期往来余额',
  `beginDate` date DEFAULT NULL COMMENT '余额日期',
  `remark` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  `place` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '职位',
  `linkMan` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系人',
  `contact` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '联系方式',
  `province` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '省',
  `city` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '市',
  `county` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '区县',
  `address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收货地址详情',
  `pinYin` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '',
  `disable` tinyint(1) DEFAULT '0' COMMENT '0启用   1禁用',
  `isDelete` tinyint(1) DEFAULT '0' COMMENT '0正常 1删除',
  `purchaserName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分管采购员',
  `createTime` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1975713491747684354 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of o_goods_supplier
-- ----------------------------
BEGIN;
INSERT INTO `o_goods_supplier` (`id`, `name`, `number`, `taxRate`, `amount`, `periodMoney`, `difMoney`, `beginDate`, `remark`, `place`, `linkMan`, `contact`, `province`, `city`, `county`, `address`, `pinYin`, `disable`, `isDelete`, `purchaserName`, `createTime`) VALUES (1975713491747684353, '佛山三佛照明', 'SFZM', 0, 0, 0, 0, NULL, '', '', NULL, '', NULL, NULL, NULL, NULL, '', 0, 0, NULL, '2025-10-08 08:02:58');
COMMIT;

-- ----------------------------
-- Table structure for o_logistics_company
-- ----------------------------
DROP TABLE IF EXISTS `o_logistics_company`;
CREATE TABLE `o_logistics_company` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `platform_id` int DEFAULT NULL COMMENT '平台id',
  `shop_id` bigint DEFAULT NULL COMMENT '店铺ID',
  `logistics_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '物流公司id（值来自于平台返回）',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流公司编码（值来自于平台返回）',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流公司名称（值来自于平台返回）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `status` int DEFAULT NULL COMMENT '状态（0禁用1启用）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2198 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='快递公司表';

-- ----------------------------
-- Records of o_logistics_company
-- ----------------------------
BEGIN;
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1, 300, 0, '1', 'STO', '申通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2, 300, 0, '2', 'SHHT', '上海汇通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (3, 300, 0, '3', 'HT', '百世快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (4, 300, 0, '44', 'SF', '顺丰快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (5, 300, 0, '85', 'YTO', '圆通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (6, 300, 0, '86', 'NBYGZT', '内部员工自提', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (7, 300, 0, '88', 'BBSD', '奔奔速达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (8, 300, 0, '89', 'SAD', '赛澳递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (9, 300, 0, '90', 'CHENGBANG', '晟邦物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (10, 300, 0, '115', 'ZTO', '中通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (11, 300, 0, '116', 'QF', '全峰快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (12, 300, 0, '117', 'YS', '优速', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (13, 300, 0, '118', 'EMS', '邮政EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (14, 300, 0, '119', 'TT', '天天快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (15, 300, 0, '120', 'JD', '京东配送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (16, 300, 0, '121', 'YUNDA', '韵达快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (17, 300, 0, '122', 'KJ', '快捷快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (18, 300, 0, '124', 'GTO', '国通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (19, 300, 0, '128', 'DDCBPS', '当当出版配送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (20, 300, 0, '129', 'ZJS', '宅急送快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (21, 300, 0, '130', 'RFD', '如风达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (22, 300, 0, '131', 'DB', '德邦快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (23, 300, 0, '132', 'YZXB', '邮政快递包裹', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (24, 300, 0, '133', 'LBEX', '龙邦快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (25, 300, 0, '135', 'FEDEX', '联邦快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (26, 300, 0, '136', 'JIUYE', '九曳供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (27, 300, 0, '137', 'BCDRD', '百城当日达快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (28, 300, 0, '138', 'DDKD', '达达快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (29, 300, 0, '139', 'DDJWL', '冻到家物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (30, 300, 0, '140', 'NJCHENGBANG', '南京晟邦', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (31, 300, 0, '141', 'SXHONGMAJIA', '山西红马甲', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (32, 300, 0, '142', 'WXWL', '万象物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (33, 300, 0, '143', 'LIJISONG', '立即送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (34, 300, 0, '144', 'MENDUIMEN', '门对门', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (35, 300, 0, '145', 'SAD2', '赛澳递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (36, 300, 0, '147', 'FENGCHENG', '丰程', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (37, 300, 0, '148', 'ADX', '安达信', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (38, 300, 0, '149', 'HWKD', '海外快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (39, 300, 0, '150', 'GZLT', '飞远物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (40, 300, 0, '151', 'NDKD', '南都快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (41, 300, 0, '152', 'HUIWEN', '汇文快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (42, 300, 0, '153', 'NDKD', '南都快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (43, 300, 0, '154', 'HUANGMAJIA', '黄马甲', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (44, 300, 0, '155', 'SURE', '速尔快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (45, 300, 0, '156', 'YAMAXUNWULIU', '亚马逊物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (46, 300, 0, '157', 'YCT', '黑猫宅急便', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (47, 300, 0, '158', 'SFHY', '顺丰航运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (48, 300, 0, '159', 'YTHY', '圆通航运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (49, 300, 0, '160', 'PINHAOHUO', '拼好货', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (50, 300, 0, '161', 'SHSAD', '上海赛澳递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (51, 300, 0, '162', 'BJCS', '城市100', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (52, 300, 0, '163', 'ZMKM', '芝麻开门', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (53, 300, 0, '164', 'SHUNJIEFENGDA', '顺捷丰达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (54, 300, 0, '165', 'HTXMJ', '汇通小红马', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (55, 300, 0, '166', 'LNXHM', '辽宁小红马', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (56, 300, 0, '167', 'LNHUANGMAJIA', '辽宁黄马甲', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (57, 300, 0, '168', 'JSSAD', '江苏赛澳递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (58, 300, 0, '169', 'SANRENXING', '三人行', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (59, 300, 0, '170', 'THJD', '通和佳递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (60, 300, 0, '171', 'SUJIEVIP', '速捷', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (61, 300, 0, '172', 'XNXD', '信诺迅达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (62, 300, 0, '173', 'FXIANSHENG', '风先生', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (63, 300, 0, '174', 'KUANRONG', '宽容', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (64, 300, 0, '175', 'GZTK', '广州途客', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (65, 300, 0, '176', 'XIAOHONGMAO', '小红帽', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (66, 300, 0, '177', 'PENGDA', '鹏达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (67, 300, 0, '178', 'FJGZLT', '福建飞远', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (68, 300, 0, '179', 'ETEKUAI', 'E特快', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (69, 300, 0, '180', 'SELF', '其他', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (70, 300, 0, '181', 'YUNNIAO', '云鸟', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (71, 300, 0, '182', 'BAODA', '保达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (72, 300, 0, '183', 'KYE', '跨越速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (73, 300, 0, '184', 'JLHMJ', '吉林黄马甲', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (74, 300, 0, '185', 'CHENGJI', '城际速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (75, 300, 0, '186', 'USPS', 'usps', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (76, 300, 0, '187', 'ANJELEX', '青岛安捷', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (77, 300, 0, '188', 'DHTY', '大韩通运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (78, 300, 0, '189', 'BANGBANGTANG', '棒棒糖', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (79, 300, 0, '190', 'TUXIAN', '途鲜', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (80, 300, 0, '191', 'CNKD', '菜鸟快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (81, 300, 0, '192', 'EMSKD', 'EMS经济快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (82, 300, 0, '193', 'HZZX', '汇站众享', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (83, 300, 0, '194', 'PAIKE', '派客', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (84, 300, 0, '195', 'XLOBO', '贝海国际速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (85, 300, 0, '196', 'TFGJKD', '丰泰国际快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (86, 300, 0, '197', 'HUANQIU', '环球速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (87, 300, 0, '198', 'SHUNFASUDI', '168顺发速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (88, 300, 0, '199', 'QQSD', '全球快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (89, 300, 0, '200', 'CG', '程光物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (90, 300, 0, '201', 'UAPEX', '全一快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (91, 300, 0, '202', 'HQSY', '环球速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (92, 300, 0, '203', 'DJKJ', '东骏快捷', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (93, 300, 0, '204', 'BSKD', '百世快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (94, 300, 0, '205', 'YCGWL', '远成快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (95, 300, 0, '206', 'FTGJSD', '风腾国际速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (96, 300, 0, '207', 'BNZY', '笨鸟转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (97, 300, 0, '208', 'ANNENG', '安能快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (98, 300, 0, '209', 'EPS', '联众国际快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (99, 300, 0, '210', 'HOAU', '天地华宇', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (100, 300, 0, '211', 'ZHONGYOUWULIU', '中邮速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (101, 300, 0, '212', 'HITAOYI', 'hi淘易', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (102, 300, 0, '213', 'INTEREMS', 'EMS-国际件', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (103, 300, 0, '214', 'ZTKY', '中铁物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (104, 300, 0, '215', 'CYWL', '楚源物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (105, 300, 0, '216', 'XBWL', '新邦物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (106, 300, 0, '217', 'FLASH', 'Flash Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (107, 300, 0, '218', 'NSF', '新顺丰NSF', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (108, 300, 0, '219', 'RLKD', '锐朗快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (109, 300, 0, '220', 'WDGJWL', '王道国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (110, 300, 0, '221', 'DCS', 'DCS GLOBAL', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (111, 300, 0, '222', 'XSKD', '迅速快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (112, 300, 0, '223', 'FTD', '富腾达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (113, 300, 0, '224', 'QFWL', '琦峰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (114, 300, 0, '225', 'JYTWL', '金运通物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (115, 300, 0, '226', 'EWE', 'EWE全球快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (116, 300, 0, '227', 'RRS', '日日顺物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (117, 300, 0, '228', 'SNWL', '苏宁快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (118, 300, 0, '229', 'BESTQJT', '百世快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (119, 300, 0, '230', 'DEBANGWULIU', '德邦物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (120, 300, 0, '231', 'WEITEPAI', '微特派', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (121, 300, 0, '232', 'MYAAE', 'AAE全球专递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (122, 300, 0, '233', 'ARAMEX', 'Aramex', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (123, 300, 0, '234', 'ASENDIA', 'Asendia USA', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (124, 300, 0, '235', 'CITYLINK', 'City-Link', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (125, 300, 0, '236', 'COE', 'COE东方快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (126, 300, 0, '237', 'DHLDE', 'DHL德国', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (127, 300, 0, '238', 'DHL', 'DHL全球', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (128, 300, 0, '239', 'DHLCN', 'DHL中国', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (129, 300, 0, '240', 'EMSGJ', 'EMS国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (130, 300, 0, '241', 'FEDEXUS', 'FedEx美国', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (131, 300, 0, '242', 'FEDEXCN', 'FedEx中国', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (132, 300, 0, '243', 'OCS', 'OCS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (133, 300, 0, '244', 'ONTRAC', 'OnTrac', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (134, 300, 0, '245', 'TNT', 'TNT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (135, 300, 0, '246', 'UPS', 'UPS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (136, 300, 0, '247', 'POSTAL', '阿尔巴尼亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (137, 300, 0, '248', 'POSTAR', '阿根廷邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (138, 300, 0, '249', 'POSTAE', '阿联酋邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (139, 300, 0, '250', 'POSTEE', '爱沙尼亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (140, 300, 0, '252', 'POSTAT', '奥地利邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (141, 300, 0, '253', 'POSTAU', '澳大利亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (142, 300, 0, '254', 'POSTPK', '巴基斯坦邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (143, 300, 0, '255', 'POSTBR', '巴西邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (144, 300, 0, '256', 'POSTBY', '白俄罗斯邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (145, 300, 0, '257', 'EES', '百福东方', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (146, 300, 0, '258', 'POSTB', '包裹信件', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (147, 300, 0, '259', 'POSTBG', '保加利亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (148, 300, 0, '260', 'BLSYZ', '比利时邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (149, 300, 0, '261', 'BLYZ', '波兰邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (150, 300, 0, '262', 'CXCOD', '传喜物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (151, 300, 0, '263', 'DTW', '大田物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (152, 300, 0, '264', '4PX', '递四方', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (153, 300, 0, '265', 'RUSTON', '俄速通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (154, 300, 0, '266', 'FGYZ', '法国邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (155, 300, 0, '267', 'GZFY', '凡宇快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (156, 300, 0, '268', 'ZTKY1', '飞豹快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (157, 300, 0, '269', 'HZABC', '飞远(爱彼西)配送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (158, 300, 0, '270', 'POSTFI', '芬兰邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (159, 300, 0, '271', 'POSTCO', '哥伦比亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (160, 300, 0, '272', 'EPOST', '韩国邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (161, 300, 0, '273', 'HLWL', '恒路物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (162, 300, 0, '274', 'HQKY', '华企快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (163, 300, 0, '275', 'TMS56', '加运美', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (164, 300, 0, '276', 'CNEX', '佳吉快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (165, 300, 0, '277', 'JIAYI', '佳怡物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (166, 300, 0, '278', 'KERRYEAS', '嘉里大通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (167, 300, 0, '279', 'JKYZ', '捷克邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (168, 300, 0, '280', 'JDYWL', '筋斗云物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (169, 300, 0, '281', 'SZKKE', '京广速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (170, 300, 0, '282', 'POSTHR', '克罗地亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (171, 300, 0, '283', 'POSTLV', '拉脱维亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (172, 300, 0, '284', 'POSTLB', '黎巴嫩邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (173, 300, 0, '285', 'LTS', '联昊通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (174, 300, 0, '286', 'POSTMT', '马耳他邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (175, 300, 0, '287', 'POSTMK', '马其顿邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (176, 300, 0, '288', 'POSTMU', '毛里求斯邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (177, 300, 0, '289', 'SERPOST', '秘鲁邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (178, 300, 0, '290', 'MBEX', '民邦快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (179, 300, 0, '291', 'CAE', '民航快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (180, 300, 0, '292', 'SZML56', '明亮物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (181, 300, 0, '293', 'POSTMD', '摩尔多瓦邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (182, 300, 0, '294', 'POSTZA', '南非邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (183, 300, 0, '295', 'POSTNO', '挪威邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (184, 300, 0, '296', 'POSTPT', '葡萄牙邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (185, 300, 0, '297', 'QRT', '全日通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (186, 300, 0, '298', 'RBYZEMS', '日本邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (187, 300, 0, '299', 'POSTSE', '瑞典邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (188, 300, 0, '300', 'POSTCH', '瑞士邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (189, 300, 0, '301', 'POSTSRB', '塞尔维亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (190, 300, 0, '302', 'SANTAI', '三态速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (191, 300, 0, '303', 'POSTSA', '沙特邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (192, 300, 0, '304', 'SZSA56', '圣安物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (193, 300, 0, '305', 'FJSFWLJTYXGS', '盛丰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (194, 300, 0, '306', 'SHENGHUI', '盛辉物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (195, 300, 0, '307', 'POSTSK', '斯洛伐克邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (196, 300, 0, '308', 'POSTSI', '斯洛文尼亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (197, 300, 0, '309', 'SUIJIAWL', '穗佳物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (198, 300, 0, '310', 'POSTTH', '泰国邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (199, 300, 0, '311', 'POSTTR', '土耳其邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (200, 300, 0, '312', 'MANCOWL', '万家物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (201, 300, 0, '313', 'POSTUA', '乌克兰邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (202, 300, 0, '314', 'POSTES', '西班牙邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (203, 300, 0, '315', 'XFWL', '信丰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (204, 300, 0, '316', 'POSTHU', '匈牙利邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (205, 300, 0, '317', 'AIR', '亚风速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (206, 300, 0, '318', 'POSTAM', '亚美尼亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (207, 300, 0, '319', 'YWWL', '燕文物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (208, 300, 0, '320', 'POSTIT', '意大利邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (209, 300, 0, '321', 'FEC', '银捷速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (210, 300, 0, '322', 'POSTIN', '印度邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (211, 300, 0, '323', 'ROYALMAIL', '英国皇家邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (212, 300, 0, '324', 'POSTBBZ', '邮政标准快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (213, 300, 0, '325', 'CNPOSTGJ', '邮政国际包裹', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (214, 300, 0, '326', 'YFEXPRESS', '越丰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (215, 300, 0, '327', 'YTZG', '运通中港快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (216, 300, 0, '328', 'ZENY', '增益速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (217, 300, 0, '329', 'POSTCL', '智利邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (218, 300, 0, '330', 'SPSR', '中俄快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (219, 300, 0, '332', 'CRE', '中铁快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (220, 300, 0, '333', 'KFW', '快服务快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (221, 300, 0, '334', 'KDN', '快递鸟', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (222, 300, 0, '335', 'YOUBANG', '优邦国际速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (223, 300, 0, '336', 'TJ', '天际快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (224, 300, 0, '337', 'FY', '飞洋快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (225, 300, 0, '338', 'BM', '斑马物联网', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (226, 300, 0, '339', 'EKM', '易客满', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (227, 300, 0, '340', 'JDKD', '京东大件物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (228, 300, 0, '341', 'SUBIDA', '速必达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (229, 300, 0, '342', 'DJKJWL', '东骏快捷', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (230, 300, 0, '343', 'ZTOKY', '中通快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (231, 300, 0, '344', 'YDKY', '韵达快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (232, 300, 0, '345', 'ANKY', '安能快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (233, 300, 0, '346', 'ANDE', '安得物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (234, 300, 0, '347', 'WM', '中粮我买网', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (235, 300, 0, '348', 'YMDD', '壹米滴答', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (236, 300, 0, '349', 'DD', '当当网', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (237, 300, 0, '350', 'PJ', '品骏', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (238, 300, 0, '351', 'OTP', '承诺达特快', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (239, 300, 0, '352', 'AXWL', '安迅物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (240, 300, 0, '353', 'YJ', '友家速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (241, 300, 0, '354', 'SDSD', 'D速物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (242, 300, 0, '355', 'STOINTER', '申通国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (243, 300, 0, '356', 'YZT', '一智通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (244, 300, 0, '357', 'JGSD', '京广速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (245, 300, 0, '358', 'SXJD', '顺心捷达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (246, 300, 0, '359', 'QH', '群航国际货运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (247, 300, 0, '360', 'ZWYSD', '中外运速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (248, 300, 0, '361', 'ZZSY', '卓志速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (249, 300, 0, '362', 'JZMSD', '加州猫速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (250, 300, 0, '363', 'GJ', '高捷物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (251, 300, 0, '364', 'SQWL', '商桥物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (252, 300, 0, '365', 'FR', '复融供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (253, 300, 0, '366', 'ZY', '中远e环球', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (254, 300, 0, '367', 'YDGJ', '韵达国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (255, 300, 0, '368', 'MKGJ', '美快国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (256, 300, 0, '369', 'NFCM', '南方传媒', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (257, 300, 0, '370', 'WSPY', '威时沛运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (258, 300, 0, '371', 'ZTOINTER', '中通国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (259, 300, 0, '372', 'SFKY', '顺丰快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (260, 300, 0, '373', 'MGWL', '亚马逊综合物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (261, 300, 0, '374', 'HKE', 'HKE国际速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (262, 300, 0, '375', 'EFSPOST', '新西兰平安物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (263, 300, 0, '376', 'HTINTER', '百世国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (264, 300, 0, '377', 'BSE', '蓝天国际快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (265, 300, 0, '378', 'YLJY', '优联吉运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (266, 300, 0, '379', 'ZYSFWL', '转运四方物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (267, 300, 0, '380', 'WSKD', '威盛快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (268, 300, 0, '381', 'YTGJ', '圆通国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (269, 300, 0, '382', 'HXWL', '海信物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (270, 300, 0, '383', 'HYWL', '空港宏远电商物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (271, 300, 0, '384', 'JTSD', '极兔速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (272, 300, 0, '385', 'UCS', '合众速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (273, 300, 0, '386', 'SYNSHIP', 'SYNSHIP快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (274, 300, 0, '387', '21CAKE', '21cake物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (275, 300, 0, '388', 'WHHDJ', '娃哈哈到家配送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (276, 300, 0, '389', 'FZGJ', '方舟国际速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (277, 300, 0, '390', 'STZNWL', '圣塔智能物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (278, 300, 0, '391', 'SFGJ', '顺丰国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (279, 300, 0, '392', 'TJWL', '泰进物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (280, 300, 0, '393', 'QJW', '千机网1小时达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (281, 300, 0, '394', 'AuExpress', '澳邮中国快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (282, 300, 0, '395', 'HSSY', '汇森速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (283, 300, 0, '396', 'XFXBWL', '幸福西饼物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (284, 300, 0, '397', 'DDKS', '叮当快送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (285, 300, 0, '398', 'QYT', '泉源堂', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (286, 300, 0, '399', 'YFDYF', '益丰大药房', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (287, 300, 0, '400', 'YTDKD', '易达通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (288, 300, 0, '401', 'ZJWL', '中汲物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (289, 300, 0, '402', 'SHUANGHUI', '双汇', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (290, 300, 0, '403', 'FENGWANG', '丰网速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (291, 300, 0, '404', 'WUXINYAOFANG', '五心药房', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (292, 300, 0, '405', 'LAOBAIXING', '老百姓大药房', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (293, 300, 0, '406', 'YUELUWULIU', '跃陆物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (294, 300, 0, '407', 'NFSQ', '农夫山泉', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (295, 300, 0, '408', 'YIJIUYIJIU', '1919酒类直供', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (296, 300, 0, '409', 'QUANYOUJIAJU', '莫仕供应链物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (297, 300, 0, '410', 'GUJIAJIAJU', '顾家家居', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (298, 300, 0, '411', 'ZHIHUASHI', '芝华仕', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (299, 300, 0, '412', 'TIANMAWULIU', '天马物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (300, 300, 0, '413', 'HALUO', '哈啰出行', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (301, 300, 0, '414', 'LINSHIMUYE', '林氏物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (302, 300, 0, '415', 'SIJIAPP', '商家自行配送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (303, 300, 0, '416', 'SFTC', '顺丰同城', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (304, 300, 0, '417', 'SHANSONG', '闪送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (305, 300, 0, '418', 'SFINTL', '顺丰集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (306, 300, 0, '419', 'SZJY', '神州集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (307, 300, 0, '420', 'DSDCD', '代收点仓端', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (308, 300, 0, '421', 'PADTF', '平安达腾飞', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (309, 300, 0, '422', 'SUTENG', '速腾快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (310, 300, 0, '423', 'YXWL', '宇鑫物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (311, 300, 0, '424', 'SUTWL', '速通物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (312, 300, 0, '425', 'JUYUWL', '具语平台物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (313, 300, 0, '426', 'AJJPWL', '安居佳配物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (314, 300, 0, '427', 'SANZHIWL', '三志物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (315, 300, 0, '428', 'FUHUWL', '福虎物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (316, 300, 0, '429', 'YADSY', '源安达速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (317, 300, 0, '430', 'LIANYUNHUI', '联运汇', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (318, 300, 0, '431', 'YONGCHANGWL', '永昌物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (319, 300, 0, '432', 'HMJT', '澳全球', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (320, 300, 0, '433', 'NKHXWL', '南康洪鑫物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (321, 300, 0, '434', 'JGWL', '景光物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (322, 300, 0, '435', 'YUNJUWL', '云聚物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (323, 300, 0, '436', 'YIXINSUYUN', '益鑫速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (324, 300, 0, '437', 'KJKWL', '快捷快物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (325, 300, 0, '438', 'LHTSD', '联昊通速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (326, 300, 0, '439', 'GZLXWL', '赣州龙鑫物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (327, 300, 0, '440', 'HNHTWL', '河南鸿泰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (328, 300, 0, '441', 'YANGBAOGUO', '洋包裹', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (329, 300, 0, '442', 'SDXDWL', '山东湘达物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (330, 300, 0, '443', 'GZCBWL', '赣州楚邦物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (331, 300, 0, '444', 'YITUWULIU', '易途物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (332, 300, 0, '445', 'YOUYUANWL', '友源物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (333, 300, 0, '446', 'JITUJIYUN', '極兔速遞HK', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (334, 300, 0, '447', 'YLBDT', '永利八达通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (335, 300, 0, '448', 'ZTOCC', '中通冷链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (336, 300, 0, '449', 'CHINAUNICOM', '联通自有物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (337, 300, 0, '450', 'YANWENJIYUN', '燕文集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (338, 300, 0, '451', 'XLHJY', '鑫隆华集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (339, 300, 0, '452', 'AMLJY', '艾姆勒集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (340, 300, 0, '453', 'GUYIWULIU', '古宜物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (341, 300, 0, '454', 'LUOTUOWULIU', '骆驼物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (342, 300, 0, '455', 'XIAOMIWULIU', '小米物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (343, 300, 0, '456', 'YSJE', '139 express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (344, 300, 0, '457', 'YBGJ', 'Jańa Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (345, 300, 0, '458', 'YZDSBK', '邮政电商标快', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (346, 300, 0, '459', 'JIEZHOU', '芥舟物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (347, 300, 0, '460', 'JE', 'Jingle Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (348, 300, 0, '461', 'WJXSD', '微集新世代', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (349, 300, 0, '462', 'JYSJ', '集运世家', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (350, 300, 0, '463', 'BUYUP', 'BUYUP', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (351, 300, 0, '464', 'AMICI', '欧米奇速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (352, 300, 0, '465', 'ZYWL', '中邮物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (353, 300, 0, '466', 'ECMS', '易客满物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (354, 300, 0, '467', 'TST', 'TST速运通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (355, 300, 0, '468', 'JPRSJY', '日森集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (356, 300, 0, '469', 'NDJY', '诺达集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (357, 300, 0, '470', 'DSJY', '东澍集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (358, 300, 0, '471', 'CTJY', '赤兔集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (359, 300, 0, '472', 'TDQQJY', '通达集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (360, 300, 0, '473', 'DFJY', '大发集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (361, 300, 0, '474', 'LTJY', '龙通集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (362, 300, 0, '475', 'FRJY', 'FR集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (363, 300, 0, '476', 'TMJY', '天马集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (364, 300, 0, '477', 'DHSHJY', '盛合集運', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (365, 300, 0, '478', 'FSJY', 'flash集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (366, 300, 0, '479', 'MTJY', '易淘集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (367, 300, 0, '480', 'XLJY', '西里物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (368, 300, 0, '481', 'ZTGJJY', '中通国际集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (369, 300, 0, '482', '786EXPRESS', '786 Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (370, 300, 0, '483', 'YMTRANS', 'YM TRANS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (371, 300, 0, '484', 'BEEPOST', 'Bee Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (372, 300, 0, '485', 'HUOLALA', '货拉拉', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (373, 300, 0, '486', 'WPJY', 'WePost集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (374, 300, 0, '487', 'JLJY', 'KEC-嘉里集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (375, 300, 0, '488', 'SHIBJY', '十邦集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (376, 300, 0, '489', 'JIEJINGJY', '捷竞集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (377, 300, 0, '490', 'SLHT', 'SMARTEX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (378, 300, 0, '491', 'PSBYEX', '顺捷速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (379, 300, 0, '492', 'AFL', 'AFL集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (380, 300, 0, '493', 'ZHONGYOUJY', '中邮集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (381, 300, 0, '494', '878EXPRESS', '878 Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (382, 300, 0, '495', 'YUNDAJY', 'uda Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (383, 300, 0, '496', 'FBKY', '飞豹快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (384, 300, 0, '497', 'EBUY', 'eBuy', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (385, 300, 0, '498', 'YIYUAN', '壹圆国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (386, 300, 0, '499', 'GHT', 'GHT EXPRESS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (387, 300, 0, '500', 'SLGJ', '首领国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (388, 300, 0, '501', 'CCCP', 'CCCPexpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (389, 300, 0, '502', 'ONEX', 'ONEX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (390, 300, 0, '503', 'GLOBBING', 'Globbing', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (391, 300, 0, '504', 'INEX', 'INEX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (392, 300, 0, '505', 'FLYPOST', 'FLY POST', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (393, 300, 0, '506', 'QTSD', '全通速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (394, 300, 0, '507', 'SJTJY', '速集通集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (395, 300, 0, '508', 'LBJY', '立邦集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (396, 300, 0, '509', 'CNPOSTJY', '中邮集运-广东', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (397, 300, 0, '510', 'JKEXPRESS', 'JKexpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (398, 300, 0, '511', 'KITAYBOX', 'KitayBox', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (399, 300, 0, '512', 'GONGZHUJY', '公主集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (400, 300, 0, '513', 'OCSJY', 'OCS集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (401, 300, 0, '514', 'WOFENGJY', '窩蜂聯盟', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (402, 300, 0, '515', 'YILIJY', '易里集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (403, 300, 0, '516', 'TDHJY', '天地會', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (404, 300, 0, '517', 'XGJY', '香港集運', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (405, 300, 0, '518', 'XHJY', '鑫航集運', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (406, 300, 0, '519', 'YGAJY', '粵港澳集運', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (407, 300, 0, '520', 'YJDJY', '易集达集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (408, 300, 0, '521', 'LXGJSY', '聯迅國際速運', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (409, 300, 0, '522', 'GUANDANBAO', '管单宝物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (410, 300, 0, '523', 'JKDWL', '吉客道物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (411, 300, 0, '524', 'CHUANYOUJY', '中郵快遞', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (412, 300, 0, '525', 'DDXGJY', '永達茂盛', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (413, 300, 0, '526', 'MOTO', 'Moto Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (414, 300, 0, '527', 'SCCSEXPRESS', 'SCCS物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (415, 300, 0, '528', 'GOODKUAIDI', 'GOOD快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (416, 300, 0, '529', 'JGJY', '婕果集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (417, 300, 0, '530', 'SOD', 'Sod Cargo', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (418, 300, 0, '531', 'QSJY', '勤胜集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (419, 300, 0, '532', 'DDMOJY', '澳門集運', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (420, 300, 0, '533', 'YTGJJY', '圆通国际集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (421, 300, 0, '534', 'XYCJY', '耀成集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (422, 300, 0, '535', 'TAIJY', '台集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (423, 300, 0, '536', 'HKYC', '上海晧库', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (424, 300, 0, '537', 'SSLH', '盛世领航', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (425, 300, 0, '538', 'NZGJ', '能者国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (426, 300, 0, '539', 'XMJJY', '熊麻集運', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (427, 300, 0, '540', 'ZGWY', '中国外运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (428, 300, 0, '541', 'RTHXJY', '榕台海峽集運', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (429, 300, 0, '542', 'CFJY', '超峰集運', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (430, 300, 0, '543', 'QQLJY', '巧巧郎集運', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (431, 300, 0, '544', 'DBGJJY', '德邦國際集運', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (432, 300, 0, '545', 'SHUIQU', '水趣到家', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (433, 300, 0, '546', 'HEUTE', '货易达物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (434, 300, 0, '547', 'SHUILIDUO', '水立多', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (435, 300, 0, '548', 'LSJY', '龍順集運', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (436, 300, 0, '549', 'BENNIAO', '笨鸟速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (437, 300, 0, '550', 'TJY', '淘集運', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (438, 300, 0, '551', 'PUSHENG', '璞笙物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (439, 300, 0, '552', 'DTS', '洞庭山送水', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (440, 300, 0, '553', 'MXMJY', '麦西盟集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (441, 300, 0, '554', 'ZXJY', '志翔集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (442, 300, 0, '555', 'SHENGZHONG', '胜中物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (443, 300, 0, '556', 'QIANTUTONG', '千途通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (444, 300, 0, '557', 'RUXIJY', '如熙集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (445, 300, 0, '558', 'ZHANCHENG', '展程物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (446, 300, 0, '559', 'ZHUOYUAN', '卓远物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (447, 300, 0, '560', 'LUCHANG', '禄昌物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (448, 300, 0, '561', 'BGJJY', 'BeeGoPLUS集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (449, 300, 0, '562', 'WENHUI', '文辉物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (450, 300, 0, '563', 'JHJY', '傑航集運', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (451, 300, 0, '564', 'WGWL', '沃格物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (452, 300, 0, '565', 'XJMWL', '馨家梦物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (453, 400, 0, '1098', 'xiaoshidayun', '小时达测试物流商', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (454, 400, 0, '1100', 'debangkuaiyun', '德邦快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (455, 400, 0, '1115', 'beijinggede', '歌德', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (456, 400, 0, '1116', 'shanghaijintong', '同达快送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (457, 400, 0, '37', 'huangmajia', '黄马甲', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (458, 400, 0, '846', 'zhongtongkuaiyun', '中通快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (459, 400, 0, '1113', 'qianniuhua', '牵牛花-腾讯云', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (460, 400, 0, '1157', 'fujianouyang', '强华同城配送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (461, 400, 0, '30', 'jd', '京东物流(常用)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (462, 400, 0, '1025', 'savor', '海信物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (463, 400, 0, '1070', 'guangzhoubenxin', '菜加壹', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (464, 400, 0, '1117', 'shenzhenlinxun', '邻寻', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (465, 400, 0, '1144', 'ganzhoushenghao', '盛浩物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (466, 400, 0, '1165', 'shanghailehu', '乐虎物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (467, 400, 0, '1031', 'linshiwuliu', '林氏物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (468, 400, 0, '1069', 'zhongqingtingcai', '听菜到家', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (469, 400, 0, '1024', 'sxjdfreight', '顺心捷达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (470, 400, 0, '15', 'zhongtong', '中通快递(常用)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (471, 400, 0, '1094', 'guangdongjingguang', '鲸广直运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (472, 400, 0, '1112', 'szclyc', '车联天下', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (473, 400, 0, '1156', 'tiandishunchi', '天地顺驰', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (474, 400, 0, '440', 'zhimakaimen', '芝麻开门', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (475, 400, 0, '31', 'wanxiangwuliu', '万象物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (476, 400, 0, '1088', 'henanjiubian', '酒便利', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (477, 400, 0, '1110', 'hangzhoucainiao', '菜鸟大件', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (478, 400, 0, '1138', 'ganzhoudashu', '大树物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (479, 400, 0, '1059', 'shenzhendinghai', '花果鲜', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (480, 400, 0, '1066', 'chengdouruoxi', '京西菜市', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (481, 400, 0, '1101', 'shenzhenshihai', '海王星辰', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (482, 400, 0, '1131', 'boyol', '贝业物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (483, 400, 0, '1133', 'huajiwang', '花集通同城物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (484, 400, 0, '1164', 'fushanshizhan', '展程物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (485, 400, 0, '1173', 'shanghaiwoge', '上海沃格供应链管理有限公司', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (486, 400, 0, '7', 'yuantong', '圆通快递(常用)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (487, 400, 0, '1086', 'shanghaixiake', '同达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (488, 400, 0, '1104', 'shenzhenshixing', '幸福西饼', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (489, 400, 0, '1107', 'huanshengdianzi', '肯德基自在厨房', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (490, 400, 0, '1119', 'zhejiangcainiao', '菜鸟裹裹商家寄', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (491, 400, 0, '1125', 'zhejiangzhongyou', '邮政小时达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (492, 400, 0, '1175', 'zhejiangbenniao01', '笨鸟速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (493, 400, 0, '610', 'zhongtiewuliu', '中铁飞豹', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (494, 400, 0, '968', 'stosolution', '申通国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (495, 400, 0, '999', 'hongbeixin', '红背心', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (496, 400, 0, '1043', 'udalogistic', '韵达国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (497, 400, 0, '1045', 'zhihuashi', '芝华仕物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (498, 400, 0, '1049', 'chuanhua', '传化物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (499, 400, 0, '1072', 'guangzhouzhixianzx', '诚食生鲜', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (500, 400, 0, '716', 'subida', '速必达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (501, 400, 0, '597', 'zhongtongguoji', '中通国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (502, 400, 0, '1082', 'yilongex', '亿隆速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (503, 400, 0, '1084', 'smwfloor', '湘粤华通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (504, 400, 0, '1111', 'guangdongdeshang', '德尚', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (505, 400, 0, '1145', 'fushanshisheng', '胜中物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (506, 400, 0, '1160', 'ganzhouhanma', '翰玛物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (507, 400, 0, '518', 'tiandihuayu', '天地华宇', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (508, 400, 0, '1063', 'guangzhoubenxi', '菜加壹（废弃）', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (509, 400, 0, '1054', 'beijingmeiri', '小时达测试', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (510, 400, 0, '1056', 'zhongqingcailao', '菜老包', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (511, 400, 0, '1057', 'jiangsuchuangji', '果多美', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (512, 400, 0, '1128', 'tzky', '铁中快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (513, 400, 0, '1130', 'sichuanzhongbang', '众邦客物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (514, 400, 0, '1167', 'ganzhoushinan08', '鑫鸿峰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (515, 400, 0, '641', 'rrs', '日日顺物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (516, 400, 0, '32', 'annengwuliu', '安能物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (517, 400, 0, '1062', 'beijingdaguan', '达冠', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (518, 400, 0, '1140', 'hongxinwuliu', '洪鑫物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (519, 400, 0, '1141', 'youyuanwuliu', '友源物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (520, 400, 0, '1151', 'tianjinhaihe', '海河奶站', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (521, 400, 0, '1162', 'ganzhoumuxing', '木行物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (522, 400, 0, '637', 'baishiwuliu', '百世快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (523, 400, 0, '1050', 'lyh', '联运汇', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (524, 400, 0, '317', 'ndwl', '南方传媒物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (525, 400, 0, '1038', 'zilegongmao', '紫乐工贸', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (526, 400, 0, '1071', 'mingchuangyoupinmcyp', '名创优品', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (527, 400, 0, '1099', 'fujianpupu', '朴朴', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (528, 400, 0, '1109', 'yzdsbk', '邮政电商标快', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (529, 400, 0, '1170', 'fujianzhixin', '至信物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (530, 400, 0, '17', 'ems', 'EMS(常用)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (531, 400, 0, '8', 'shentong', '申通快递(常用)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (532, 400, 0, '1095', 'beijingtengfu', '牵牛花-阿里云', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (533, 400, 0, '1139', 'chengdoujike', '吉客道信息', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (534, 400, 0, '1159', 'wuxiankeneng', '宠嗒嗒', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (535, 400, 0, '1033', 'fengwang', '丰网速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (536, 400, 0, '1052', 'ztocc', '中通冷链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (537, 400, 0, '1030', 'gujiajiaju', '顾家家居', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (538, 400, 0, '1034', 'yuantongguoji', '圆通国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (539, 400, 0, '1065', 'dajiangwangluo', '达达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (540, 400, 0, '1171', 'gdkjk56', '快捷快物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (541, 400, 0, '19', 'youzhengguonei', '邮政快递包裹', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (542, 400, 0, '1029', 'yijiuyijiu', '壹玖壹玖', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (543, 400, 0, '1079', 'jingdongdajian', '京东大件', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (544, 400, 0, '1090', 'suyoda', '速邮达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (545, 400, 0, '1102', 'zhongqingzhuandan', '到哪儿了', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (546, 400, 0, '1123', 'youxuankonggu', '优选', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (547, 400, 0, '1127', 'jiangxifuhu', '福虎物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (548, 400, 0, '1142', 'ganzhouyuewu', '粤无忧物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (549, 400, 0, '397', 'kuayue', '跨越速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (550, 400, 0, '1044', 'meiriyouxian', '每日优鲜', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (551, 400, 0, '1137', 'ganzhouxiaoma', '小蚂蚁物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (552, 400, 0, '1143', 'jiangxijiuwu', '川鸽物流(九五至臻)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (553, 400, 0, '1152', 'tcxfx', '正鑫小飞侠', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (554, 400, 0, '1163', 'fushanshijin', '晋良物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (555, 400, 0, '1042', 'shanhuodidi', '闪货极速达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (556, 400, 0, '1073', 'xianyouyi', '萝卜青菜', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (557, 400, 0, '1074', 'guangdongmeiyimy', '美宜佳', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (558, 400, 0, '1083', 'shanghaixintian', '信天翁小时达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (559, 400, 0, '1096', 'yueluwuliu', '跃陆物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (560, 400, 0, '1105', 'xiaomitongxun', '小米物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (561, 400, 0, '1129', 'kunmingyunxuan', '云选供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (562, 400, 0, '1039', 'xintianweng', '信天翁同城速配', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (563, 400, 0, '1068', 'shanghaijinmi', '侠刻送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (564, 400, 0, '563', 'suteng', '速腾快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (565, 400, 0, '1040', 'shunfengguoji', '顺丰国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (566, 400, 0, '1106', 'bishengyouxuan', '必胜客必胜优选', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (567, 400, 0, '1146', 'pushengwuliu', '璞笙物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (568, 400, 0, '1169', 'fushanshiwen', '文辉物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (569, 400, 0, '517', 'jinguangsudikuaijian', '京广速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (570, 400, 0, '1089', 'qingdaoriri', '日日顺家居服务', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (571, 400, 0, '1036', 'nongfushanquan', '农夫山泉物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (572, 400, 0, '12', 'shunfeng', '顺丰速运(常用)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (573, 400, 0, '1148', 'jilinjishi', '吉时达物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (574, 400, 0, '11', 'youshuwuliu', '优速', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (575, 400, 0, '243', 'suer', '速尔快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (576, 400, 0, '1132', 'gujiawuliu', '顾家物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (577, 400, 0, '1155', 'yingchang', '赢畅物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (578, 400, 0, '1174', 'jitianxiajiang', '吉天下快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (579, 400, 0, '1061', 'duodianshenzhen', '多点配送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (580, 400, 0, '1067', 'shanghaiyibai', '叮咚买菜', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (581, 400, 0, '1047', 'XMTC', '寻梦同城', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (582, 400, 0, '1053', 'shunfengchengpei', '顺丰城配', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (583, 400, 0, '1064', 'shenzhenshishun', '顺丰同城', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (584, 400, 0, '1076', 'shanghaiganlin', '菜公社', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (585, 400, 0, '1122', 'beijingmaiya', '麦芽田', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (586, 400, 0, '1135', 'chubangwuliu', '楚邦物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (587, 400, 0, '10', 'jiayiwuliu', '佳怡物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (588, 400, 0, '177', 'amusorder', 'Amazon Logistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (589, 400, 0, '861', 'annto', '安得物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (590, 400, 0, '1085', 'dingdangkuaiyao', '叮当快药', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (591, 400, 0, '1153', 'rjtcsd', '全信速同城', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (592, 400, 0, '1158', 'jinmengwuliu', '晋蒙物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (593, 400, 0, '21', 'zhaijisong', '宅急送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (594, 400, 0, '327', 'jiayunmeiwuliu', '加运美', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (595, 400, 0, '1060', 'beijingbenlai', '本来鲜', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (596, 400, 0, '1075', 'xianjiuru', '鲜菜园', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (597, 400, 0, '1136', 'zhongji', '中汲物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (598, 400, 0, '13', 'debangwuliu', '德邦快递(常用)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (599, 400, 0, '1022', 'zhongyouex', '众邮快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (600, 400, 0, '952', 'yundakuaiyun', '韵达快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (601, 400, 0, '1051', 'xlair', '快弟来了', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (602, 400, 0, '1114', 'zhongqingxindong', '心动快送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (603, 400, 0, '1134', 'runhongwuliu', '润宏物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (604, 400, 0, '1161', 'ganzhoushilong', '龙鑫物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (605, 400, 0, '191', 'jiuyescm', '九曳供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (606, 400, 0, '565', 'pingandatengfei', '平安达腾飞快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (607, 400, 0, '1077', 'ganzhouanju', '具语', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (608, 400, 0, '1149', 'fushanshishun', '乐峰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (609, 400, 0, '1166', 'ganzhouhengxin', '恒新物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (610, 400, 0, '1058', 'baiguoyuanind', '百果园', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (611, 400, 0, '9', 'yunda', '韵达快递(常用)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (612, 400, 0, '1037', 'shanxijianhua', '山西建华', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (613, 400, 0, '1168', 'ganzhoushinan05', '大正物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (614, 400, 0, '1172', 'ganzhoushinan', '捷诚物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (615, 400, 0, '1017', 'danniao', '菜鸟速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (616, 400, 0, '1021', 'jtexpress', '极兔速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (617, 400, 0, '1048', 'NZSY', '哪吒速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (618, 400, 0, '1124', 'beijinghuiyi', '惠宜选', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (619, 400, 0, '1154', 'chengdoumoshi', '莫仕物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (620, 400, 0, '202', 'suning', '苏宁物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (621, 400, 0, '1032', 'taijin', '泰进物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (622, 400, 0, '1035', 'shunfengkuaiyun', '顺丰快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (623, 400, 0, '1091', 'fushanshilu', '禄昌物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (624, 400, 0, '1092', 'guangxijiaojiu', '酒小二', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (625, 400, 0, '1103', 'jiangsujingchun', '京东酒世界', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (626, 400, 0, '1121', 'sooeasy', '水趣到家', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (627, 400, 0, '475', 'xlobo', '贝海国际速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (628, 400, 0, '244', 'shenghuiwuliu', '盛辉物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (629, 400, 0, '1080', 'jingdongkuaiyun', '京东快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (630, 400, 0, '1097', 'gansushantong', '兰马同城', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (631, 400, 0, '1026', 'sfwl', '盛丰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (632, 400, 0, '897', 'yimidida', '壹米滴答', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (633, 400, 0, '1', 'POST', '中国邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (634, 100, 0, '1', 'POST', '中国邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (635, 100, 0, '-1', 'OTHER', '其他', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (636, 100, 0, '511', 'CYEXP', '长宇', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (637, 100, 0, '512', 'DTW', '大田', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (638, 100, 0, '513', 'YUD', '长发', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (639, 100, 0, '269346156', 'DISTRIBUTOR_13211725', '跨越速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (640, 100, 0, '269583380', 'DISTRIBUTOR_30493846', '平安达腾飞快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (641, 100, 0, '269347246', 'DISTRIBUTOR_13222803', '中通快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (642, 100, 0, '-474798478', 'PKGJWL', '派易国际物流77', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (643, 100, 0, '30721717', 'DISTRIBUTOR_13148625', '菜鸟大件-中铁配', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (644, 100, 0, '30721674', 'DISTRIBUTOR_13159132', '菜鸟大件-日日顺配', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (645, 100, 0, '269571490', 'DISTRIBUTOR_30464910', '丰网速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (646, 100, 0, '269502847', 'DISTRIBUTOR_30292473', '大食品商家自配', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (647, 100, 0, '-474709471', 'WND', 'WnDirect', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (648, 100, 0, '200427', 'GZLT', '飞远配送 ', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (649, 100, 0, '658246117', 'DISTRIBUTOR_1710055', '邮政标准快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (650, 100, 0, '269380569', 'DISTRIBUTOR_13484485', '顺心捷达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (651, 100, 0, '1139', 'YC', '远长', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (652, 100, 0, '1137', 'DFH', '东方汇', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (653, 100, 0, '1237', 'UNIPS', '发网', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (654, 100, 0, '-474829477', 'MGSD', '美国速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (655, 100, 0, '-474783443', 'BHWL', '保宏物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (656, 100, 0, '103', 'ZJS', '宅急送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (657, 100, 0, '505', 'SF', '顺丰速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (658, 100, 0, '100', 'STO', '申通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (659, 100, 0, '2', 'EMS', 'EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (660, 100, 0, '102', 'YUNDA', '韵达快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (661, 100, 0, '502', 'HTKY', '极兔速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (662, 100, 0, '101', 'YTO', '圆通速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (663, 100, 0, '504', 'TTKDEX', '天天快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (664, 100, 0, '1216', 'QFKD', '全峰快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (665, 100, 0, '1207', 'UC', '优速快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (666, 100, 0, '658178186', 'DBKD', '德邦快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (667, 100, 0, '500', 'ZTO', '中通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (668, 100, 0, '200143', 'GTO', '国通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (669, 100, 0, '1204', 'FAST', '快捷快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (670, 100, 0, '201174', 'SURE', '速尔快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (671, 100, 0, '106', 'FEDEX', '联邦快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (672, 100, 0, '108', 'SHQ', '华强物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (673, 100, 0, '1259', 'UAPEX', '全一快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (674, 100, 0, '1191', 'HOAU', '天地华宇', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (675, 100, 0, '105', 'BEST', '百世物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (676, 100, 0, '1195', 'LB', '龙邦速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (677, 100, 0, '1186', 'XB', '新邦物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (678, 100, 0, '3', 'EYB', '邮政电商标快EYB', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (679, 100, 0, '202855', 'XFWL', '信丰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (680, 100, 0, '200734', 'POSTB', '邮政快递包裹', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (681, 100, 0, '107', 'DBL', '德邦物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (682, 100, 0, '1214', 'LTS', '联昊通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (683, 100, 0, '200740', 'ESB', 'E速宝', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (684, 100, 0, '105031', 'BESTQJT', '百世快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (685, 500, 0, 'ZTO', 'ZTO', '中通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (686, 500, 0, 'YTO', 'YTO', '圆通速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (687, 500, 0, 'YUNDA', 'YUNDA', '韵达速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (688, 500, 0, 'JTSD', 'JTSD', '极兔速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (689, 500, 0, 'STO', 'STO', '申通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (690, 500, 0, 'JD', 'JD', '京东快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (691, 500, 0, 'EMS', 'EMS', '中国邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (692, 500, 0, 'DBKD', 'DBKD', '德邦快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (693, 500, 0, 'CNSD', 'CNSD', '菜鸟速递(丹鸟)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (694, 500, 0, 'SF', 'SF', '顺丰速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (695, 500, 0, 'SXJD', 'SXJD', '顺心捷达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (696, 500, 0, 'BTWL', 'BTWL', '百世快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (697, 500, 0, 'ZTOKY', 'ZTOKY', '中通快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (698, 500, 0, 'ZJS', 'ZJS', '宅急送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (699, 500, 0, 'KYSY', 'KYSY', '跨越速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (700, 500, 0, 'JYM', 'JYM', '加运美快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (701, 500, 0, 'YDKY', 'YDKY', '韵达快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (702, 500, 0, 'ANEKY', 'ANEKY', '安能物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (703, 500, 0, 'XFEX', 'XFEX', '信丰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (704, 500, 0, 'RJTCSD', 'RJTCSD', '全信速同城', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (705, 500, 0, 'YMDD', 'YMDD', '壹米滴答', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (706, 500, 0, 'JGSD', 'JGSD', '京广速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (707, 500, 0, 'ANNTO', 'ANNTO', '安得物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (708, 500, 0, 'JSD', 'JSD', '吉时达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (709, 500, 0, 'ZTOGLOBAL', 'ZTOGLOBAL', '中通国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (710, 500, 0, '007EX', '007EX', '俄顺达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (711, 500, 0, '138SD', '138SD', '泰国138快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (712, 500, 0, '139EXPRESS', '139EXPRESS', '139快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (713, 500, 0, '13TEN', '13TEN', '13ten', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (714, 500, 0, '168EXPRESS', '168EXPRESS', 'Antron Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (715, 500, 0, '17FEIA', '17FEIA', '一起飞啊国际速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (716, 500, 0, '17POSTSERVICE', '17POSTSERVICE', '17 Post Service', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (717, 500, 0, '1DLEXPRESS', '1DLEXPRESS', 'e递诺快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (718, 500, 0, '1HCANG', '1HCANG', '1号仓', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (719, 500, 0, '1SHIDA', '1SHIDA', '壹世达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (720, 500, 0, '1TONG', '1TONG', '1TONG', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (721, 500, 0, '2GO', '2GO', '2GO', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (722, 500, 0, '360LION', '360LION', '纬狮物联网', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (723, 500, 0, '360ZEBRA', '360ZEBRA', '斑马物联网', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (724, 500, 0, '5Post', '5Post', '5Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (725, 500, 0, '5UL', '5UL', '5UL', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (726, 500, 0, '8256RU', '8256RU', 'BEL北俄国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (727, 500, 0, '8DT', '8DT', '永利八达通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (728, 500, 0, '8STAREXPRESS', '8STAREXPRESS', '八星物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (729, 500, 0, 'A4PX', 'A4PX', '转运四方', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (730, 500, 0, 'AAE', 'AAE', 'AAE全球专递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (731, 500, 0, 'ABGJ', 'ABGJ', '澳邦国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (732, 500, 0, 'ABXEXPRESSMY', 'ABXEXPRESSMY', 'ABX Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (733, 500, 0, 'ACOMMERCE', 'ACOMMERCE', 'ACommerce', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (734, 500, 0, 'ACS', 'ACS', 'ACS雅仕快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (735, 500, 0, 'ACSCOURIER', 'ACSCOURIER', 'ACS Courier', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (736, 500, 0, 'ADD', 'ADD', '澳多多', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (737, 500, 0, 'ADICIONAL', 'ADICIONAL', 'Adicional Logistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (738, 500, 0, 'ADP', 'ADP', 'ADP Express Tracking', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (739, 500, 0, 'ADSONE', 'ADSONE', 'ADSOne快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (740, 500, 0, 'AIR21', 'AIR21', 'AIR21', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (741, 500, 0, 'AIRPAKEXPRESS', 'AIRPAKEXPRESS', 'Airpak Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (742, 500, 0, 'AIRSPEED', 'AIRSPEED', 'Airspeed International Corporation', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (743, 500, 0, 'AIRWINGSINDIA', 'AIRWINGSINDIA', 'Airwings Courier Express India', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (744, 500, 0, 'AJ', 'AJ', '安捷快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (745, 500, 0, 'AL8856', 'AL8856', '阿里电商物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (746, 500, 0, 'ALANDPOST', 'ALANDPOST', '奥兰群岛芬兰邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (747, 500, 0, 'ALBANIANPOST', 'ALBANIANPOST', 'AlbanianPost', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (748, 500, 0, 'ALGERIAEMS', 'ALGERIAEMS', 'Algeria EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (749, 500, 0, 'ALGERIAPOST', 'ALGERIAPOST', 'AlgeriaPost', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (750, 500, 0, 'ALIEXPRESSSHIPPING', 'ALIEXPRESSSHIPPING', 'AliexpressShipping', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (751, 500, 0, 'ALKJWL', 'ALKJWL', '阿里跨境电商物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (752, 500, 0, 'ALLEKURIER', 'ALLEKURIER', 'AlleKurier', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (753, 500, 0, 'ALLJOY', 'ALLJOY', 'Alljoy', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (754, 500, 0, 'ALPHAFAST', 'ALPHAFAST', 'Alpha Fast快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (755, 500, 0, 'ALWL', 'ALWL', '安鹿物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (756, 500, 0, 'AMAZON', 'AMAZON', '亚马逊物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (757, 500, 0, 'ANDORRAPOST', 'ANDORRAPOST', '安道尔邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (758, 500, 0, 'ANGUILAYOU', 'ANGUILAYOU', '安圭拉邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (759, 500, 0, 'ANJUN', 'ANJUN', '安骏物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (760, 500, 0, 'ANPOST', 'ANPOST', '爱尔兰邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (761, 500, 0, 'ANSERX', 'ANSERX', '斑头雁国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (762, 500, 0, 'ANTILLESPOST', 'ANTILLESPOST', '荷属安的列斯荷兰邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (763, 500, 0, 'AOL', 'AOL', 'AOL（澳通）', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (764, 500, 0, 'AOMENYZ', 'AOMENYZ', '澳门邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (765, 500, 0, 'AOYUNLTD', 'AOYUNLTD', '澳运国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (766, 500, 0, 'APAC', 'APAC', 'APAC', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (767, 500, 0, 'APC', 'APC', 'APC Postal Logistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (768, 500, 0, 'APGECOMMERCE', 'APGECOMMERCE', 'APG eCommerce', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (769, 500, 0, 'APLUSEX', 'APLUSEX', 'Aplus物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (770, 500, 0, 'ARAMEX', 'ARAMEX', 'Aramex', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (771, 500, 0, 'ARROWXL', 'ARROWXL', 'Arrow XL', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (772, 500, 0, 'ARTLOGEXPRESS', 'ARTLOGEXPRESS', 'Art Logexpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (773, 500, 0, 'ASENDIA', 'ASENDIA', 'Asendia', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (774, 500, 0, 'ASENDIADE', 'ASENDIADE', 'Asendia Germany', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (775, 500, 0, 'ASENDIAHK', 'ASENDIAHK', 'Asendia HK', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (776, 500, 0, 'ASENDIAUK', 'ASENDIAUK', 'Asendia UK', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (777, 500, 0, 'ASENDIAUSA', 'ASENDIAUSA', 'Asendia USA', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (778, 500, 0, 'ASIAFLY', 'ASIAFLY', '上海亚翔', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (779, 500, 0, 'ASMRED', 'ASMRED', 'ASM', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (780, 500, 0, 'ASTEXPRESS', 'ASTEXPRESS', '安世通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (781, 500, 0, 'ASYAD', 'ASYAD', 'Asyad Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (782, 500, 0, 'AT', 'AT', '奥地利邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (783, 500, 0, 'ATWINDOW', 'ATWINDOW', '在窗', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (784, 500, 0, 'AUEX', 'AUEX', '澳邮国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (785, 500, 0, 'AUEXPRESS', 'AUEXPRESS', '澳邮中国快运AuExpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (786, 500, 0, 'AUODEXPRESS', 'AUODEXPRESS', '澳德物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (787, 500, 0, 'AUS', 'AUS', 'AUS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (788, 500, 0, 'AUSTRALIA', 'AUSTRALIA', 'Australia Post Tracking', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (789, 500, 0, 'AUSTRALIAEMS', 'AUSTRALIAEMS', '澳大利亚 EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (790, 500, 0, 'AX', 'AX', '安迅物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (791, 500, 0, 'AXD', 'AXD', '安鲜达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (792, 500, 0, 'AYCA', 'AYCA', '澳邮专线', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (793, 500, 0, 'AYUS', 'AYUS', '安邮美国', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (794, 500, 0, 'Aquiline', 'Aquiline', 'Aquiline', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (795, 500, 0, 'BAB', 'BAB', 'BAB', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (796, 500, 0, 'BABRU', 'BABRU', '北北国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (797, 500, 0, 'BAISHIGUOJI', 'BAISHIGUOJI', '百世跨境', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (798, 500, 0, 'BALUNZHI', 'BALUNZHI', '巴伦支快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (799, 500, 0, 'BANGLADESHEMS', 'BANGLADESHEMS', '孟加拉国 EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (800, 500, 0, 'BARBADOSPOST', 'BARBADOSPOST', '巴巴多斯邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (801, 500, 0, 'BARTOLINI', 'BARTOLINI', 'BRT Bartolini', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (802, 500, 0, 'BBFZY', 'BBFZY', '帮帮发转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (803, 500, 0, 'BCTWL', 'BCTWL', '百城通物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (804, 500, 0, 'BCWELT', 'BCWELT', 'BCWELT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (805, 500, 0, 'BDM', 'BDM', 'BDM Corriere espresso', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (806, 500, 0, 'BDT', 'BDT', '八达通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (807, 500, 0, 'BEEBIRD', 'BEEBIRD', '锋鸟物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (808, 500, 0, 'BEEEXPRESS', 'BEEEXPRESS', 'BeeExpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (809, 500, 0, 'BEIJINGFENGYUE', 'BEIJINGFENGYUE', '北京丰越供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (810, 500, 0, 'BELIZEPOST', 'BELIZEPOST', '伯利兹邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (811, 500, 0, 'BENINPOST', 'BENINPOST', '贝宁邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (812, 500, 0, 'BERMUDAPOST', 'BERMUDAPOST', '百慕大邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (813, 500, 0, 'BETWL', 'BETWL', '百腾物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (814, 500, 0, 'BETWL_Crack', 'BETWL_Crack', 'BETWL_Crack', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (815, 500, 0, 'BEUROPE', 'BEUROPE', '败欧洲', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (816, 500, 0, 'BFAY', 'BFAY', '八方安运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (817, 500, 0, 'BFDF', 'BFDF', '百福东方', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (818, 500, 0, 'BHT', 'BHT', 'BHT快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (819, 500, 0, 'BILUYOUZHE', 'BILUYOUZHE', '秘鲁邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (820, 500, 0, 'BIRDSYSTEM', 'BIRDSYSTEM', '飞鸟国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (821, 500, 0, 'BJXKY', 'BJXKY', '北极星快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (822, 500, 0, 'BKWL', 'BKWL', '宝凯物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (823, 500, 0, 'BLSYZ', 'BLSYZ', '比利时邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (824, 500, 0, 'BLUECARE', 'BLUECARE', 'Bluecare Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (825, 500, 0, 'BLUEDART', 'BLUEDART', 'Bluedart', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (826, 500, 0, 'BLUESKYEXPRESS', 'BLUESKYEXPRESS', '蓝天快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (827, 500, 0, 'BLYZ', 'BLYZ', '波兰邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (828, 500, 0, 'BLZ', 'BLZ', '巴伦支', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (829, 500, 0, 'BN', 'BN', '笨鸟国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (830, 500, 0, 'BNEXP', 'BNEXP', '商盟', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (831, 500, 0, 'BNTWL', 'BNTWL', '奔腾物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (832, 500, 0, 'BNTWL_Crack', 'BNTWL_Crack', 'BNTWL_Crack', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (833, 500, 0, 'BOMBINOEXPRESS', 'BOMBINOEXPRESS', 'Bombino Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (834, 500, 0, 'BONDSCOURIERS', 'BONDSCOURIERS', 'Bonds Couriers', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (835, 500, 0, 'BORDEREXPRESS', 'BORDEREXPRESS', 'border-express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (836, 500, 0, 'BOXC', 'BOXC', 'Boxc', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (837, 500, 0, 'BPOSTINTERNATIONAL', 'BPOSTINTERNATIONAL', 'Bpost International', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (838, 500, 0, 'BQC', 'BQC', 'BQC百千诚物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (839, 500, 0, 'BQXHM', 'BQXHM', '北青小红帽', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (840, 500, 0, 'BR', 'BR', '巴西邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (841, 500, 0, 'BR1', 'BR1', 'BR1', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (842, 500, 0, 'BRINGERAIRCARGO', 'BRINGERAIRCARGO', 'BringerAirCargo', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (843, 500, 0, 'BRINGERPARCELSERVICE', 'BRINGERPARCELSERVICE', 'Bringer Parcel Service', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (844, 500, 0, 'BRT', 'BRT', 'BRT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (845, 500, 0, 'BSI', 'BSI', '佰事达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (846, 500, 0, 'BSIECOMMERCE', 'BSIECOMMERCE', '柏电科技物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (847, 500, 0, 'BSWL', 'BSWL', '邦送物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (848, 500, 0, 'BTD', 'BTD', 'BTD', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (849, 500, 0, 'BTD56', 'BTD56', '深圳宝通达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (850, 500, 0, 'BTEXP', 'BTEXP', '利佳顺', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (851, 500, 0, 'BUDANYOUZH', 'BUDANYOUZH', '不丹邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (852, 500, 0, 'BUFFALOEX', 'BUFFALOEX', 'Buffalo', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (853, 500, 0, 'BULGARIANPOST', 'BULGARIANPOST', 'Bulgarian Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (854, 500, 0, 'BURUNDIPOST', 'BURUNDIPOST', '布隆迪邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (855, 500, 0, 'BUYLOGIC', 'BUYLOGIC', '捷买送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (856, 500, 0, 'Belpost', 'Belpost', 'Belpost', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (857, 500, 0, 'Beone', 'Beone', 'Beone', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (858, 500, 0, 'BlueEx', 'BlueEx', 'BlueEx', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (859, 500, 0, 'Boxberry', 'Boxberry', 'Boxberry', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (860, 500, 0, 'Bpost', 'Bpost', 'Bpost', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (861, 500, 0, 'CA', 'CA', '加拿大邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (862, 500, 0, 'CACESAPOSTAL', 'CACESAPOSTAL', 'Cacesa南美专线', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (863, 500, 0, 'CAINIAO', 'CAINIAO', '速卖通线上物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (864, 500, 0, 'CANADAPOST', 'CANADAPOST', 'Canada Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (865, 500, 0, 'CANPAR', 'CANPAR', 'Canpar Courier', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (866, 500, 0, 'CANPAREXPRESS', 'CANPAREXPRESS', 'CanparExpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (867, 500, 0, 'CBLLOGISTICA', 'CBLLOGISTICA', 'CBL Logistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (868, 500, 0, 'CBO', 'CBO', 'CBO钏博物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (869, 500, 0, 'CBTSD', 'CBTSD', '北泰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (870, 500, 0, 'CCES', 'CCES', 'CCES快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (871, 500, 0, 'CDEK', 'CDEK', 'CDEK', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (872, 500, 0, 'CDSTKY', 'CDSTKY', '成都善途速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (873, 500, 0, 'CEVA', 'CEVA', 'CEVA物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (874, 500, 0, 'CEVALOGISTICS', 'CEVALOGISTICS', 'CEVA物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (875, 500, 0, 'CFWL', 'CFWL', '春风物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (876, 500, 0, 'CG', 'CG', '程光物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (877, 500, 0, 'CGS', 'CGS', 'CGS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (878, 500, 0, 'CGSGJ', 'CGSGJ', '超光速国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (879, 500, 0, 'CHANGJIANGEXPRESS', 'CHANGJIANGEXPRESS', 'changjiangexpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (880, 500, 0, 'CHEER56', 'CHEER56', '琪悦物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (881, 500, 0, 'CHENGDAGUOJI', 'CHENGDAGUOJI', 'CD', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (882, 500, 0, 'CHENGFENGEXPRESS', 'CHENGFENGEXPRESS', '顺阳供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (883, 500, 0, 'CHINACOURIERHK', 'CHINACOURIERHK', '中快', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (884, 500, 0, 'CHINAEMS', 'CHINAEMS', 'China EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (885, 500, 0, 'CHINAPOST', 'CHINAPOST', 'China Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (886, 500, 0, 'CHINARUSSIA56', 'CHINARUSSIA56', '俄必达A79', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (887, 500, 0, 'CHINASQK', 'CHINASQK', 'SQK国际速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (888, 500, 0, 'CHINZ56', 'CHINZ56', '秦远物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (889, 500, 0, 'CHLLOG', 'CHLLOG', '嘉荣物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (890, 500, 0, 'CHOICE', 'CHOICE', '赛时国际货运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (891, 500, 0, 'CHRONOPOST', 'CHRONOPOST', '法国 EMS-Chronopost', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (892, 500, 0, 'CHRONOPOSTPORTUGAL', 'CHRONOPOSTPORTUGAL', 'Chronopost Portugal', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (893, 500, 0, 'CHTWL', 'CHTWL', '诚通物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (894, 500, 0, 'CHUNGHWAPOST', 'CHUNGHWAPOST', 'Chunghwa Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (895, 500, 0, 'CITITRANS', 'CITITRANS', '亦邦国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (896, 500, 0, 'CITY100', 'CITY100', '城市100', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (897, 500, 0, 'CITYLINK', 'CITYLINK', 'City Link', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (898, 500, 0, 'CITYLINKEXPRESS', 'CITYLINKEXPRESS', 'City-Link(信递联）', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (899, 500, 0, 'CJCENTURY', 'CJCENTURY', 'CJ Century', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (900, 500, 0, 'CJDROPSHIP', 'CJDROPSHIP', '促佳', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (901, 500, 0, 'CJDROPSHIPPING', 'CJDROPSHIPPING', 'CJ Dropshipping', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (902, 500, 0, 'CJKD', 'CJKD', '城际快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (903, 500, 0, 'CJKOREAEXPRESS', 'CJKOREAEXPRESS', 'CJ Korea Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (904, 500, 0, 'CKY', 'CKY', '出口易', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (905, 500, 0, 'CND', 'CND', '承诺达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (906, 500, 0, 'CNDEXPRESS', 'CNDEXPRESS', '辰诺达物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (907, 500, 0, 'CNE', 'CNE', 'CNE', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (908, 500, 0, 'CNEX', 'CNEX', '佳吉快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (909, 500, 0, 'CNEXPS', 'CNEXPS', 'CNE国际快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (910, 500, 0, 'CNILINK', 'CNILINK', 'CNILINK', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (911, 500, 0, 'CNPEX', 'CNPEX', 'CNPEX中邮快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (912, 500, 0, 'CNWANGTONG', 'CNWANGTONG', '中国网通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (913, 500, 0, 'CNXLM', 'CNXLM', '新配盟', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (914, 500, 0, 'COE', 'COE', 'COE东方快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (915, 500, 0, 'COLISPRIVE', 'COLISPRIVE', 'Colis Privé', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (916, 500, 0, 'COLISSIMO', 'COLISSIMO', '法国邮政-Colissimo', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (917, 500, 0, 'COLLECTPLUS', 'COLLECTPLUS', 'Collect+', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (918, 500, 0, 'COM1EXPRESS', 'COM1EXPRESS', '商壹国际快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (919, 500, 0, 'COMET-TECH', 'COMET-TECH', '上海彗吉', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (920, 500, 0, 'COMETHELLAS', 'COMETHELLAS', 'Comet Hellas', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (921, 500, 0, 'COMMONLINEEXPRESS', 'COMMONLINEEXPRESS', 'CommonlineExpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (922, 500, 0, 'CONWAY', 'CONWAY', 'Con-way Freight', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (923, 500, 0, 'CORREIOSBRAZIL', 'CORREIOSBRAZIL', 'Correios Brazil', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (924, 500, 0, 'CORREIOSCABOVERDE', 'CORREIOSCABOVERDE', 'Correios Cabo Verde', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (925, 500, 0, 'CORREOARGENTINO', 'CORREOARGENTINO', 'CorreoArgentino', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (926, 500, 0, 'CORREOELSALVADOR', 'CORREOELSALVADOR', 'Correo El Salvador', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (927, 500, 0, 'CORREOPARAGUAYO', 'CORREOPARAGUAYO', '巴拉圭邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (928, 500, 0, 'CORREOSBOLIVIA', 'CORREOSBOLIVIA', '玻利维亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (929, 500, 0, 'CORREOSCOSTARICA', 'CORREOSCOSTARICA', 'Correos Costa Rica', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (930, 500, 0, 'CORREOSDEHONDURAS', 'CORREOSDEHONDURAS', 'Correos de Honduras', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (931, 500, 0, 'CORREOSECUADOR', 'CORREOSECUADOR', 'Correos Ecuador', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (932, 500, 0, 'CORREOSEXPRESS', 'CORREOSEXPRESS', 'Correos Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (933, 500, 0, 'CORREOSPANAMA', 'CORREOSPANAMA', '巴拿马邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (934, 500, 0, 'CORREOURUGUAYO', 'CORREOURUGUAYO', 'Correo Uruguayo', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (935, 500, 0, 'COSCO', 'COSCO', '中远E环球', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (936, 500, 0, 'COSEX', 'COSEX', '慧合物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (937, 500, 0, 'COURIERIT', 'COURIERIT', 'Courier IT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (938, 500, 0, 'COURIERPLUSNIGERIA', 'COURIERPLUSNIGERIA', 'CourierPlusNigeria', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (939, 500, 0, 'COURIERPOST', 'COURIERPOST', 'CourierPost', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (940, 500, 0, 'COURIERSPLEASE', 'COURIERSPLEASE', 'Couriers Please', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (941, 500, 0, 'CPACKET', 'CPACKET', 'CPacket', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (942, 500, 0, 'CRAZY', 'CRAZY', '疯狂快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (943, 500, 0, 'CROATIANPOST', 'CROATIANPOST', 'Croatian Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (944, 500, 0, 'CSCY', 'CSCY', '长沙创一', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (945, 500, 0, 'CSD', 'CSD', '超时代供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (946, 500, 0, 'CSE', 'CSE', 'cse', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (947, 500, 0, 'CSILGROUP', 'CSILGROUP', '常昇国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (948, 500, 0, 'CSTD', 'CSTD', '畅顺通达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (949, 500, 0, 'CTG', 'CTG', '联合运通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (950, 500, 0, 'CTT', 'CTT', '葡萄牙邮政-CTT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (951, 500, 0, 'CTTEXPRESS', 'CTTEXPRESS', 'CTT Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (952, 500, 0, 'CTWL', 'CTWL', '长通物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (953, 500, 0, 'CUBAPOST', 'CUBAPOST', '古巴邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (954, 500, 0, 'CUCKOOEXPRESS', 'CUCKOOEXPRESS', '布谷鸟速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (955, 500, 0, 'CUNTO', 'CUNTO', '村通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (956, 500, 0, 'CXC', 'CXC', 'CXC物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (957, 500, 0, 'CXCEXPRESS', 'CXCEXPRESS', 'CXCExpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (958, 500, 0, 'CXHY', 'CXHY', '传喜物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (959, 500, 0, 'CYEXPRESS', 'CYEXPRESS', '创宇物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (960, 500, 0, 'Cargus', 'Cargus', 'Cargus', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (961, 500, 0, 'Caribou', 'Caribou', 'Caribou', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (962, 500, 0, 'Celeritas', 'Celeritas', 'Celeritas', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (963, 500, 0, 'Cubyn', 'Cubyn', 'Cubyn', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (964, 500, 0, 'D4PX', 'D4PX', '递四方速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (965, 500, 0, 'DACHSER', 'DACHSER', 'Dachser', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (966, 500, 0, 'DASU', 'DASU', '达速物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (967, 500, 0, 'DAWNWING', 'DAWNWING', 'Dawn Wing', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (968, 500, 0, 'DBLKY', 'DBLKY', '德邦快运/德邦物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (969, 500, 0, 'DBSCHENKER', 'DBSCHENKER', '全球国际货运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (970, 500, 0, 'DBYWL', 'DBYWL', '递必易国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (971, 500, 0, 'DCWL', 'DCWL', '德创物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (972, 500, 0, 'DDEXPRESS', 'DDEXPRESS', 'DD Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (973, 500, 0, 'DDUEXPRESS', 'DDUEXPRESS', 'DDU Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (974, 500, 0, 'DDWL', 'DDWL', '大道物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (975, 500, 0, 'DEKUN', 'DEKUN', '德坤', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (976, 500, 0, 'DELCARTIN', 'DELCARTIN', 'Delcart', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (977, 500, 0, 'DELHIVERY', 'DELHIVERY', 'Delhivery', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (978, 500, 0, 'DELLIN', 'DELLIN', 'dellin', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (979, 500, 0, 'DELTAFILLE', 'DELTAFILLE', 'Trending Times', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (980, 500, 0, 'DELTECCOURIER', 'DELTECCOURIER', 'Deltec Courier', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (981, 500, 0, 'DEUTSCHEPOST', 'DEUTSCHEPOST', '德国邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (982, 500, 0, 'DGYKD', 'DGYKD', '德国云快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (983, 500, 0, 'DHL', 'DHL', 'DHL', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (984, 500, 0, 'DHLACTIVE', 'DHLACTIVE', 'DHL Active Tracing', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (985, 500, 0, 'DHLBENELUX', 'DHLBENELUX', 'DHL Benelux', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (986, 500, 0, 'DHLECOMMERCEASIA', 'DHLECOMMERCEASIA', 'DHL Global Mail Asia', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (987, 500, 0, 'DHLECOMMERCEUS', 'DHLECOMMERCEUS', 'DHL eCommerce US', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (988, 500, 0, 'DHLES', 'DHLES', '西班牙DHL', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (989, 500, 0, 'DHLGLOBALLOGISTICS', 'DHLGLOBALLOGISTICS', 'DHL全球货运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (990, 500, 0, 'DHLGLOBALMAIL', 'DHLGLOBALMAIL', 'DHL电子商务', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (991, 500, 0, 'DHLGM', 'DHLGM', 'DHL Global Mail', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (992, 500, 0, 'DHLHONGKONG', 'DHLHONGKONG', '香港DHL', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (993, 500, 0, 'DHLPARCELNL', 'DHLPARCELNL', '荷兰DHL', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (994, 500, 0, 'DHLPOLAND', 'DHLPOLAND', '波兰DHL', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (995, 500, 0, 'DHLUK', 'DHLUK', 'DHL Parcel UK', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (996, 500, 0, 'DHL_C', 'DHL_C', 'DHL(中国件)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (997, 500, 0, 'DHL_DE', 'DHL_DE', 'DHL德国', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (998, 500, 0, 'DHL_EN', 'DHL_EN', 'DHL(英文版)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (999, 500, 0, 'DHL_GLB', 'DHL_GLB', 'DHL全球', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1000, 500, 0, 'DHL_USA', 'DHL_USA', 'DHL(美国)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1001, 500, 0, 'DHWL', 'DHWL', '东红物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1002, 500, 0, 'DICOMEXPRESS', 'DICOMEXPRESS', 'DicomExpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1003, 500, 0, 'DIRECTFREIGHTAU', 'DIRECTFREIGHTAU', 'Direct Freight快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1004, 500, 0, 'DIRECTLINK', 'DIRECTLINK', 'Direct Link', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1005, 500, 0, 'DK', 'DK', '丹麦邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1006, 500, 0, 'DLG', 'DLG', '到了港', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1007, 500, 0, 'DLGJ', 'DLGJ', '到乐国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1008, 500, 0, 'DML', 'DML', '大马鹿', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1009, 500, 0, 'DMMNETWORK', 'DMMNETWORK', 'DMM Network', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1010, 500, 0, 'DNJEXPRESS', 'DNJEXPRESS', 'DNJExpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1011, 500, 0, 'DNWL', 'DNWL', '丹鸟物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1012, 500, 0, 'DOORTODOOR', 'DOORTODOOR', '韩国CJ物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1013, 500, 0, 'DOTZOT', 'DOTZOT', 'Dotzot', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1014, 500, 0, 'DPD', 'DPD', 'DPD', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1015, 500, 0, 'DPDBE', 'DPDBE', 'DPD 比利时', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1016, 500, 0, 'DPDDE', 'DPDDE', '德国 DPD', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1017, 500, 0, 'DPDHK', 'DPDHK', '香港DPD', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1018, 500, 0, 'DPDIRELAND', 'DPDIRELAND', '爱尔兰DPD', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1019, 500, 0, 'DPDPOLAND', 'DPDPOLAND', '波兰DPD', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1020, 500, 0, 'DPDRO', 'DPDRO', 'DPD Romania', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1021, 500, 0, 'DPESOUTHAFRICA', 'DPESOUTHAFRICA', 'DPE South Africa', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1022, 500, 0, 'DPEX', 'DPEX', 'DPEX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1023, 500, 0, 'DRL', 'DRL', '鼎润物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1024, 500, 0, 'DSV', 'DSV', 'DSV', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1025, 500, 0, 'DSWL', 'DSWL', 'D速物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1026, 500, 0, 'DTD', 'DTD', 'DTD', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1027, 500, 0, 'DTDC', 'DTDC', 'DTDC', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1028, 500, 0, 'DTDCPLUS', 'DTDCPLUS', 'DTDC Plus', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1029, 500, 0, 'DTKD', 'DTKD', '店通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1030, 500, 0, 'DTWL', 'DTWL', '大田物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1031, 500, 0, 'DWEEX', 'DWEEX', '多维智慧', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1032, 500, 0, 'DWZ', 'DWZ', '递五洲国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1033, 500, 0, 'DXDELIVERY', 'DXDELIVERY', 'DX Delivery', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1034, 500, 0, 'DYEXPRESS', 'DYEXPRESS', '德远物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1035, 500, 0, 'DYJ', 'DYJ', '递易家', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1036, 500, 0, 'DYWL', 'DYWL', '大洋物流快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1037, 500, 0, 'Delnext', 'Delnext', 'Delnext', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1038, 500, 0, 'EARLYBIRD', 'EARLYBIRD', 'EarlyBird', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1039, 500, 0, 'EASYEX', 'EASYEX', 'EASY-EXPRESS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1040, 500, 0, 'EASYMAIL', 'EASYMAIL', 'Easy Mail', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1041, 500, 0, 'EASYWAY', 'EASYWAY', 'EasyWay', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1042, 500, 0, 'ECAN', 'ECAN', '台湾宅配通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1043, 500, 0, 'ECARGOASIA', 'ECARGOASIA', 'Ecargo', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1044, 500, 0, 'ECFIRSFTCLASS', 'ECFIRSFTCLASS', 'EC-Firstclass', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1045, 500, 0, 'ECHO', 'ECHO', 'Echo', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1046, 500, 0, 'ECOMEXPRESS', 'ECOMEXPRESS', 'Ecom Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1047, 500, 0, 'ECPOST', 'ECPOST', 'ECPOST', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1048, 500, 0, 'ECexpress', 'ECexpress', 'ECexpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1049, 500, 0, 'EKM', 'EKM', '易客满', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1050, 500, 0, 'ELIANPOST', 'ELIANPOST', '易连供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1051, 500, 0, 'ELINEX', 'ELINEX', 'ELINEX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1052, 500, 0, 'ELTA', 'ELTA', 'ELTA', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1053, 500, 0, 'ELTACOURIERGR', 'ELTACOURIERGR', 'ELTA Courier', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1054, 500, 0, 'EMPSEXPRESS', 'EMPSEXPRESS', 'EMPS Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1055, 500, 0, 'EMS2', 'EMS2', 'EMS国内', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1056, 500, 0, 'ENTERPRISEDESPOSTELAO', 'ENTERPRISEDESPOSTELAO', 'Enterprise des Poste Lao', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1057, 500, 0, 'ENTERPRISEDESPOSTELAOAPL', 'ENTERPRISEDESPOSTELAOAPL', 'Enterprise des Poste Lao (APL)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1058, 500, 0, 'ENVIALIA', 'ENVIALIA', 'Envialia', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1059, 500, 0, 'EPARCELKR', 'EPARCELKR', 'eParcel Korea', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1060, 500, 0, 'EPOST', 'EPOST', '韩国邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1061, 500, 0, 'EPP', 'EPP', 'EPP', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1062, 500, 0, 'EPS', 'EPS', 'EPS (联众国际快运)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1063, 500, 0, 'EQT', 'EQT', 'EQT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1064, 500, 0, 'EQUICKCN', 'EQUICKCN', 'EQUICK国际快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1065, 500, 0, 'ESDEX', 'ESDEX', '卓志速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1066, 500, 0, 'ESE', 'ESE', '俄速易', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1067, 500, 0, 'ESHIPPER', 'ESHIPPER', 'EShipper', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1068, 500, 0, 'ESNAD', 'ESNAD', 'ESNAD Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1069, 500, 0, 'ESPEEDPOST', 'ESPEEDPOST', '易速国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1070, 500, 0, 'ESPOST', 'ESPOST', 'Espost', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1071, 500, 0, 'EST365', 'EST365', '东方汇', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1072, 500, 0, 'ESTAFETAUSA', 'ESTAFETAUSA', 'Estafeta USA', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1073, 500, 0, 'ESTES', 'ESTES', 'Estes', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1074, 500, 0, 'ETHIOPIANPOST', 'ETHIOPIANPOST', 'Ethiopian Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1075, 500, 0, 'ETK', 'ETK', 'E特快', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1076, 500, 0, 'ETONG', 'ETONG', 'E通速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1077, 500, 0, 'ETOTAL', 'ETOTAL', 'eTotal快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1078, 500, 0, 'ETS', 'ETS', 'ETS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1079, 500, 0, 'ETSEXPRESS', 'ETSEXPRESS', '俄通收', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1080, 500, 0, 'EUASIA', 'EUASIA', 'EAX欧亚专线', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1081, 500, 0, 'EURODIS', 'EURODIS', 'Eurodis快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1082, 500, 0, 'EWE', 'EWE', 'EWE', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1083, 500, 0, 'EWS', 'EWS', 'EWS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1084, 500, 0, 'EWS-YQ', 'EWS-YQ', 'EWS-YQ', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1085, 500, 0, 'EXAPAQ', 'EXAPAQ', 'Exapaq', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1086, 500, 0, 'EXELOT', 'EXELOT', 'Exelot', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1087, 500, 0, 'EXPEDITORS', 'EXPEDITORS', 'Expeditors', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1088, 500, 0, 'EYOUPOST', 'EYOUPOST', '易友通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1089, 500, 0, 'EasyGet', 'EasyGet', 'EasyGet', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1090, 500, 0, 'Ekart', 'Ekart', 'Ekart', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1091, 500, 0, 'Equick', 'Equick', 'Equick', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1092, 500, 0, 'Eshun', 'Eshun', 'Eshun', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1093, 500, 0, 'Estafeta', 'Estafeta', 'Estafeta', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1094, 500, 0, 'FAMIPORT', 'FAMIPORT', '全家快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1095, 500, 0, 'FARGOODEXPRESS', 'FARGOODEXPRESS', '发个货', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1096, 500, 0, 'FARINTERNATIONAL', 'FARINTERNATIONAL', 'FARInternational', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1097, 500, 0, 'FAROEISLANDSPOST', 'FAROEISLANDSPOST', '法罗群岛邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1098, 500, 0, 'FAROEPOST', 'FAROEPOST', 'FaroePost', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1099, 500, 0, 'FASTDESPATCH', 'FASTDESPATCH', 'Fast Despatch', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1100, 500, 0, 'FASTGO', 'FASTGO', '速派快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1101, 500, 0, 'FASTRAKSERVICES', 'FASTRAKSERVICES', 'Fastrak Services', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1102, 500, 0, 'FASTWAYAU', 'FASTWAYAU', '澳大利亚Fastway', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1103, 500, 0, 'FASTWAYIE', 'FASTWAYIE', '爱尔兰Fastway', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1104, 500, 0, 'FASTWAYNZ', 'FASTWAYNZ', '新西兰Fastway', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1105, 500, 0, 'FASTWAYZA', 'FASTWAYZA', 'Fastway (ZA)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1106, 500, 0, 'FASTZT', 'FASTZT', '正途供应链（白海豚）', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1107, 500, 0, 'FBB', 'FBB', '迅蜂物联', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1108, 500, 0, 'FBKD', 'FBKD', '飞豹快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1109, 500, 0, 'FBOX', 'FBOX', '丰巢', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1110, 500, 0, 'FCKJEXPRESS', 'FCKJEXPRESS', '飞驰供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1111, 500, 0, 'FCWL', 'FCWL', '丰程物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1112, 500, 0, 'FDEXPRESS', 'FDEXPRESS', '方递物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1113, 500, 0, 'FEDEX', 'FEDEX', 'FEDEX联邦(国内件）', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1114, 500, 0, 'FEDEXUK', 'FEDEXUK', '英国FedEx', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1115, 500, 0, 'FEDEX_GJ', 'FEDEX_GJ', 'FEDEX联邦(国际件）', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1116, 500, 0, 'FEIA', 'FEIA', 'FEIA', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1117, 500, 0, 'FERCAM', 'FERCAM', 'FERCAM Logistics & Transport', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1118, 500, 0, 'FERRYBOATLOGISTICS', 'FERRYBOATLOGISTICS', '摆渡一下', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1119, 500, 0, 'FETCHR', 'FETCHR', 'Fetchr', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1120, 500, 0, 'FHKD', 'FHKD', '飞狐快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1121, 500, 0, 'FIJIPOST', 'FIJIPOST', '斐济邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1122, 500, 0, 'FINLANDPOSTI', 'FINLANDPOSTI', '芬兰邮政-Posti', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1123, 500, 0, 'FIRSTFLIGHT', 'FIRSTFLIGHT', 'First Flight', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1124, 500, 0, 'FIRSTFLIGHTME', 'FIRSTFLIGHTME', 'First Flight Couriers', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1125, 500, 0, 'FIRSTMILE', 'FIRSTMILE', 'FirstMile', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1126, 500, 0, 'FJEX', 'FJEX', 'FJEX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1127, 500, 0, 'FKD', 'FKD', '飞康达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1128, 500, 0, 'FLASHEXPRESS', 'FLASHEXPRESS', 'Flash Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1129, 500, 0, 'FLIPPOST', 'FLIPPOST', 'FlipPost', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1130, 500, 0, 'FLYZ', 'FLYZ', '芬兰邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1131, 500, 0, 'FOURSEASONSFLY', 'FOURSEASONSFLY', '四季正扬', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1132, 500, 0, 'FPSLOGISTICS', 'FPSLOGISTICS', 'FPS Logistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1133, 500, 0, 'FQ', 'FQ', 'FQ', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1134, 500, 0, 'FREAKYQUICK', 'FREAKYQUICK', 'FQ狂派速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1135, 500, 0, 'FRGYL', 'FRGYL', '复融供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1136, 500, 0, 'FT', 'FT', '丰通快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1137, 500, 0, 'FTD', 'FTD', '富腾达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1138, 500, 0, 'FULFILLMEN', 'FULFILLMEN', 'Fulfillmen', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1139, 500, 0, 'FWX', 'FWX', '丰网速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1140, 500, 0, 'FX', 'FX', '法翔速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1141, 500, 0, 'FYKD', 'FYKD', '凡宇货的', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1142, 500, 0, 'FYPS', 'FYPS', '飞远配送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1143, 500, 0, 'FYSD', 'FYSD', '凡宇速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1144, 500, 0, 'FZGJ', 'FZGJ', '方舟国际速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1145, 500, 0, 'Fedex', 'Fedex', 'Fedex', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1146, 500, 0, 'GAASHWORLDWIDE', 'GAASHWORLDWIDE', 'GAASHWorldwide', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1147, 500, 0, 'GAEAEX', 'GAEAEX', '盖亚物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1148, 500, 0, 'GAI', 'GAI', '迦递快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1149, 500, 0, 'GALAXYEX', 'GALAXYEX', '嘉盛泓', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1150, 500, 0, 'GAOPOST', 'GAOPOST', '高翔物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1151, 500, 0, 'GATICN', 'GATICN', 'GATI上海迦递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1152, 500, 0, 'GATIKWE', 'GATIKWE', 'Gati-KWE', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1153, 500, 0, 'GCT', 'GCT', 'GCT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1154, 500, 0, 'GCX', 'GCX', 'GCX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1155, 500, 0, 'GD', 'GD', '冠达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1156, 500, 0, 'GDEMS', 'GDEMS', '广东邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1157, 500, 0, 'GDEX', 'GDEX', 'GDEX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1158, 500, 0, 'GDEXPRESS', 'GDEXPRESS', 'GDExpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1159, 500, 0, 'GDKD', 'GDKD', '冠达快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1160, 500, 0, 'GDOYX', 'GDOYX', '欧亚兴', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1161, 500, 0, 'GDRZ58', 'GDRZ58', '容智快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1162, 500, 0, 'GDSK', 'GDSK', 'GDSK', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1163, 500, 0, 'GDWSE', 'GDWSE', '威速易供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1164, 500, 0, 'GE2D', 'GE2D', 'GE2D', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1165, 500, 0, 'GELEXPRESS', 'GELEXPRESS', 'GEL 快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1166, 500, 0, 'GEORGIANPOST', 'GEORGIANPOST', '格鲁吉亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1167, 500, 0, 'GHLLOGISTICS', 'GHLLOGISTICS', 'GHL Logistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1168, 500, 0, 'GHN', 'GHN', 'Giao Hàng Nhanh', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1169, 500, 0, 'GIMEN56', 'GIMEN56', '巨门跨境', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1170, 500, 0, 'GJ472', 'GJ472', '4-72', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1171, 500, 0, 'GJEYB', 'GJEYB', '国际e邮宝', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1172, 500, 0, 'GJYZ', 'GJYZ', '国际邮政包裹', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1173, 500, 0, 'GKSD', 'GKSD', '港快速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1174, 500, 0, 'GLOBALLEADER', 'GLOBALLEADER', '全球立达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1175, 500, 0, 'GLOBALROUTERS', 'GLOBALROUTERS', '印态跨境', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1176, 500, 0, 'GLOBEGISTICS', 'GLOBEGISTICS', 'Globegistics Inc', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1177, 500, 0, 'GLS', 'GLS', 'GLS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1178, 500, 0, 'GLSCROATIA', 'GLSCROATIA', 'GLS (Croatia)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1179, 500, 0, 'GLSITALY', 'GLSITALY', '意大利GLS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1180, 500, 0, 'GLSNL', 'GLSNL', 'GLS-Info', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1181, 500, 0, 'GLSSPAINNATIONAL', 'GLSSPAINNATIONAL', 'GLSSpain(National)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1182, 500, 0, 'GOFLY', 'GOFLY', 'Gofly', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1183, 500, 0, 'GOJAVAS', 'GOJAVAS', 'GoJavas', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1184, 500, 0, 'GPDSERVICE', 'GPDSERVICE', 'GPD Service', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1185, 500, 0, 'GPSL', 'GPSL', 'GPSL', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1186, 500, 0, 'GRANDSLAMEXPRESS', 'GRANDSLAMEXPRESS', 'Grand Slam Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1187, 500, 0, 'GREYHOUND', 'GREYHOUND', 'Greyhound', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1188, 500, 0, 'GSD', 'GSD', '共速达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1189, 500, 0, 'GSWTKD', 'GSWTKD', '万通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1190, 500, 0, 'GT', 'GT', '冠泰', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1191, 500, 0, 'GTD', 'GTD', 'GTD', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1192, 500, 0, 'GTI', 'GTI', '跨境易通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1193, 500, 0, 'GTKD', 'GTKD', '广通速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1194, 500, 0, 'GTKY', 'GTKY', '高铁快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1195, 500, 0, 'GTONG', 'GTONG', '广通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1196, 500, 0, 'GTSD', 'GTSD', '高铁速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1197, 500, 0, 'GTSEXPRESS', 'GTSEXPRESS', 'GTSExpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1198, 500, 0, 'GUANGCHI', 'GUANGCHI', '光驰国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1199, 500, 0, 'GUERNSEYPOST', 'GUERNSEYPOST', '根西岛邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1200, 500, 0, 'GUYANAPOST', 'GUYANAPOST', 'Guyana Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1201, 500, 0, 'GV', 'GV', 'GV', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1202, 500, 0, 'GXA', 'GXA', 'GXA', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1203, 500, 0, 'GYANG', 'GYANG', '国洋运通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1204, 500, 0, 'GZYMYT', 'GZYMYT', '优美宇通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1205, 500, 0, 'Gati', 'Gati', 'Gati', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1206, 500, 0, 'Geis', 'Geis', 'Geis', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1207, 500, 0, 'GlavDostavka', 'GlavDostavka', 'GlavDostavka', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1208, 500, 0, 'Grastin', 'Grastin', 'Grastin', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1209, 500, 0, 'HANJIN', 'HANJIN', '韩进物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1210, 500, 0, 'HAPPYPOST', 'HAPPYPOST', 'Happy-Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1211, 500, 0, 'HBJH', 'HBJH', '河北建华', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1212, 500, 0, 'HBKD', 'HBKD', '美国汉邦快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1213, 500, 0, 'HCT', 'HCT', '新竹物流HCT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1214, 500, 0, 'HDGJ19', 'HDGJ19', 'HD物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1215, 500, 0, 'HDKD', 'HDKD', '汇达快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1216, 500, 0, 'HENANZHENGBO', 'HENANZHENGBO', '正博', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1217, 500, 0, 'HERMES', 'HERMES', 'Hermesworld', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1218, 500, 0, 'HERMESBORDERGURU', 'HERMESBORDERGURU', 'HermesBorderguru', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1219, 500, 0, 'HERMESDE', 'HERMESDE', '德国Hermes', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1220, 500, 0, 'HERMESUK', 'HERMESUK', 'MyHermes UK', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1221, 500, 0, 'HF', 'HF', '汇丰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1222, 500, 0, 'HFHW', 'HFHW', '合肥汇文', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1223, 500, 0, 'HGLL', 'HGLL', '黑狗冷链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1224, 500, 0, 'HHAIR56', 'HHAIR56', '华瀚快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1225, 500, 0, 'HHEXP', 'HHEXP', '华翰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1226, 500, 0, 'HHJY56', 'HHJY56', '华航吉运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1227, 500, 0, 'HHKD', 'HHKD', '华航快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1228, 500, 0, 'HHWL', 'HHWL', '华翰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1229, 500, 0, 'HILIFE', 'HILIFE', 'Hi Life萊爾富', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1230, 500, 0, 'HISENSE', 'HISENSE', '海信物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1231, 500, 0, 'HIVEWMS', 'HIVEWMS', '海沧无忧', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1232, 500, 0, 'HJWL', 'HJWL', '皇家物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1233, 500, 0, 'HJYT', 'HJYT', 'HJYT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1234, 500, 0, 'HKDEXPRESS', 'HKDEXPRESS', 'HKD', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1235, 500, 0, 'HLONGWL', 'HLONGWL', '辉隆物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1236, 500, 0, 'HLWL', 'HLWL', '恒路物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1237, 500, 0, 'HLYSD', 'HLYSD', '好来运快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1238, 500, 0, 'HMGEXPRESS', 'HMGEXPRESS', '黄马褂', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1239, 500, 0, 'HMSD', 'HMSD', '海盟速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1240, 500, 0, 'HNFYWL', 'HNFYWL', '方圆物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1241, 500, 0, 'HNHTYXGS', 'HNHTYXGS', '河南航投物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1242, 500, 0, 'HOAU', 'HOAU', '天地华宇', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1243, 500, 0, 'HONGKONGPOST', 'HONGKONGPOST', 'HongKong Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1244, 500, 0, 'HOTSCM', 'HOTSCM', '鸿桥供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1245, 500, 0, 'HOUND', 'HOUND', 'Hound Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1246, 500, 0, 'HPTEX', 'HPTEX', '海派通物流公司', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1247, 500, 0, 'HQGJXB', 'HQGJXB', 'HQGJXB', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1248, 500, 0, 'HQKD', 'HQKD', '华企快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1249, 500, 0, 'HQKY', 'HQKY', '华企快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1250, 500, 0, 'HQSY', 'HQSY', '环球速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1251, 500, 0, 'HRD', 'HRD', 'HRD', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1252, 500, 0, 'HRWL', 'HRWL', '韩润物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1253, 500, 0, 'HSD-EX', 'HSD-EX', '鸿盛达国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1254, 500, 0, 'HSGJKY', 'HSGJKY', '华昇国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1255, 500, 0, 'HSGTSD', 'HSGTSD', '海硕高铁速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1256, 500, 0, 'HSSY', 'HSSY', '汇森速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1257, 500, 0, 'HSWL', 'HSWL', '昊盛物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1258, 500, 0, 'HTB56', 'HTB56', '徽托邦物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1259, 500, 0, 'HTKD', 'HTKD', '青岛恒通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1260, 500, 0, 'HTKJWL', 'HTKJWL', '环通跨境物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1261, 500, 0, 'HTKY', 'HTKY', '百世快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1262, 500, 0, 'HTWL', 'HTWL', '鸿泰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1263, 500, 0, 'HUANSHID', 'HUANSHID', '寰世达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1264, 500, 0, 'HUAXIEXPRESS', 'HUAXIEXPRESS', '华熙国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1265, 500, 0, 'HUIDAEX', 'HUIDAEX', '美国汇达快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1266, 500, 0, 'HUILOGISTICS', 'HUILOGISTICS', '荟千物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1267, 500, 0, 'HUINGLOBAL', 'HUINGLOBAL', '惠恩物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1268, 500, 0, 'HUNTEREXPRESS', 'HUNTEREXPRESS', 'Hunter Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1269, 500, 0, 'HXGJ56', 'HXGJ56', '瀚轩国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1270, 500, 0, 'HXLWL', 'HXLWL', '华夏龙物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1271, 500, 0, 'HXWL', 'HXWL', '豪翔物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1272, 500, 0, 'HYEXPRESS', 'HYEXPRESS', '浩远国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1273, 500, 0, 'HYH', 'HYH', '货运皇物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1274, 500, 0, 'Haypost', 'Haypost', 'Haypost', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1275, 500, 0, 'Helthjem', 'Helthjem', 'Helthjem', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1276, 500, 0, 'IADLSQDYZ', 'IADLSQDYZ', '安的列斯群岛邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1277, 500, 0, 'IADLYYZ', 'IADLYYZ', '澳大利亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1278, 500, 0, 'IAEBNYYZ', 'IAEBNYYZ', '阿尔巴尼亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1279, 500, 0, 'IAEJLYYZ', 'IAEJLYYZ', '阿尔及利亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1280, 500, 0, 'IAFHYZ', 'IAFHYZ', '阿富汗邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1281, 500, 0, 'IAGLYZ', 'IAGLYZ', '安哥拉邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1282, 500, 0, 'IAGTYZ', 'IAGTYZ', '阿根廷邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1283, 500, 0, 'IAJYZ', 'IAJYZ', '埃及邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1284, 500, 0, 'IALBYZ', 'IALBYZ', '阿鲁巴邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1285, 500, 0, 'IALQDYZ', 'IALQDYZ', '奥兰群岛邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1286, 500, 0, 'IALYYZ', 'IALYYZ', '阿联酋邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1287, 500, 0, 'IAMYZ', 'IAMYZ', '阿曼邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1288, 500, 0, 'IASBJYZ', 'IASBJYZ', '阿塞拜疆邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1289, 500, 0, 'IASEBYYZ', 'IASEBYYZ', '埃塞俄比亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1290, 500, 0, 'IASNYYZ', 'IASNYYZ', '爱沙尼亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1291, 500, 0, 'IASSDYZ', 'IASSDYZ', '阿森松岛邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1292, 500, 0, 'IBCWNYZ', 'IBCWNYZ', '博茨瓦纳邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1293, 500, 0, 'IBDLGYZ', 'IBDLGYZ', '波多黎各邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1294, 500, 0, 'IBDYZ', 'IBDYZ', '冰岛邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1295, 500, 0, 'IBELSYZ', 'IBELSYZ', '白俄罗斯邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1296, 500, 0, 'IBHYZ', 'IBHYZ', '波黑邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1297, 500, 0, 'IBJLYYZ', 'IBJLYYZ', '保加利亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1298, 500, 0, 'IBJSTYZ', 'IBJSTYZ', '巴基斯坦邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1299, 500, 0, 'IBLNYZ', 'IBLNYZ', '黎巴嫩邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1300, 500, 0, 'IBLSD', 'IBLSD', '便利速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1301, 500, 0, 'IBLYZ', 'IBLYZ', '巴林邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1302, 500, 0, 'IBMDYZ', 'IBMDYZ', '百慕达邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1303, 500, 0, 'IBTD', 'IBTD', '宝通达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1304, 500, 0, 'IBYB', 'IBYB', '贝邮宝', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1305, 500, 0, 'IDADA56', 'IDADA56', '大达物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1306, 500, 0, 'IDEXPRESS', 'IDEXPRESS', 'IDEX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1307, 500, 0, 'IDFWL', 'IDFWL', '达方物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1308, 500, 0, 'IDSLOGISTICS', 'IDSLOGISTICS', 'IDS Logistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1309, 500, 0, 'IEGDEYZ', 'IEGDEYZ', '厄瓜多尔邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1310, 500, 0, 'IELSYZ', 'IELSYZ', '俄罗斯邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1311, 500, 0, 'IELTLYYZ', 'IELTLYYZ', '厄立特里亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1312, 500, 0, 'IEPOST', 'IEPOST', 'IEPost', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1313, 500, 0, 'IFTWL', 'IFTWL', '飞特物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1314, 500, 0, 'IGDLPDEMS', 'IGDLPDEMS', '瓜德罗普岛EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1315, 500, 0, 'IGDLPDYZ', 'IGDLPDYZ', '瓜德罗普岛邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1316, 500, 0, 'IGJESD', 'IGJESD', '俄速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1317, 500, 0, 'IGLBYYZ', 'IGLBYYZ', '哥伦比亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1318, 500, 0, 'IGLLYZ', 'IGLLYZ', '格陵兰邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1319, 500, 0, 'IGSDLJYZ', 'IGSDLJYZ', '哥斯达黎加邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1320, 500, 0, 'IHLY', 'IHLY', '互联易', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1321, 500, 0, 'IHSKSTYZ', 'IHSKSTYZ', '哈萨克斯坦邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1322, 500, 0, 'IHSYZ', 'IHSYZ', '黑山邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1323, 500, 0, 'IJBBWYZ', 'IJBBWYZ', '津巴布韦邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1324, 500, 0, 'IJEJSSTYZ', 'IJEJSSTYZ', '吉尔吉斯斯坦邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1325, 500, 0, 'IJKYZ', 'IJKYZ', '捷克邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1326, 500, 0, 'IJNYZ', 'IJNYZ', '加纳邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1327, 500, 0, 'IJPZYZ', 'IJPZYZ', '柬埔寨邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1328, 500, 0, 'IKNDYYZ', 'IKNDYYZ', '克罗地亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1329, 500, 0, 'IKNYYZ', 'IKNYYZ', '肯尼亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1330, 500, 0, 'IKTDWEMS', 'IKTDWEMS', '科特迪瓦EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1331, 500, 0, 'IKTDWYZ', 'IKTDWYZ', '科特迪瓦邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1332, 500, 0, 'IKTEYZ', 'IKTEYZ', '卡塔尔邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1333, 500, 0, 'ILBYYZ', 'ILBYYZ', '利比亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1334, 500, 0, 'ILKKD', 'ILKKD', '林克快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1335, 500, 0, 'ILMNYYZ', 'ILMNYYZ', '罗马尼亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1336, 500, 0, 'ILSBYZ', 'ILSBYZ', '卢森堡邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1337, 500, 0, 'ILTWYYZ', 'ILTWYYZ', '拉脱维亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1338, 500, 0, 'ILTWYZ', 'ILTWYZ', '立陶宛邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1339, 500, 0, 'ILZDSDYZ', 'ILZDSDYZ', '列支敦士登邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1340, 500, 0, 'IMEDFYZ', 'IMEDFYZ', '马尔代夫邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1341, 500, 0, 'IMEDWYZ', 'IMEDWYZ', '摩尔多瓦邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1342, 500, 0, 'IMETYZ', 'IMETYZ', '马耳他邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1343, 500, 0, 'IMEXGLOBALSOLUTIONS', 'IMEXGLOBALSOLUTIONS', 'IMEX Global Solutions', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1344, 500, 0, 'IMILE', 'IMILE', 'iMile', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1345, 500, 0, 'IMJLGEMS', 'IMJLGEMS', '孟加拉国EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1346, 500, 0, 'IML', 'IML', 'IML', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1347, 500, 0, 'IMLB2C', 'IMLB2C', 'IML艾姆勒', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1348, 500, 0, 'IMLEXPRESS', 'IMLEXPRESS', '艾姆勒', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1349, 500, 0, 'IMLGYZ', 'IMLGYZ', '摩洛哥邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1350, 500, 0, 'IMLQSYZ', 'IMLQSYZ', '毛里求斯邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1351, 500, 0, 'IMLXYEMS', 'IMLXYEMS', '马来西亚EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1352, 500, 0, 'IMLXYYZ', 'IMLXYYZ', '马来西亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1353, 500, 0, 'IMQDYZ', 'IMQDYZ', '马其顿邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1354, 500, 0, 'IMTNKEMS', 'IMTNKEMS', '马提尼克EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1355, 500, 0, 'IMTNKYZ', 'IMTNKYZ', '马提尼克邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1356, 500, 0, 'IMXGYZ', 'IMXGYZ', '墨西哥邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1357, 500, 0, 'INFYZ', 'INFYZ', '南非邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1358, 500, 0, 'INPOSTPACZKOMATY', 'INPOSTPACZKOMATY', 'InPost Paczkomaty', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1359, 500, 0, 'INPOSTPL', 'INPOSTPL', 'Inpost (PL)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1360, 500, 0, 'INRLYYZ', 'INRLYYZ', '尼日利亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1361, 500, 0, 'INTELCOM', 'INTELCOM', 'Intelcom Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1362, 500, 0, 'INTERNATIONALSEUR', 'INTERNATIONALSEUR', 'International Seur', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1363, 500, 0, 'INTERPARCELAU', 'INTERPARCELAU', 'Interparcel (AU)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1364, 500, 0, 'INTERPARCELNZ', 'INTERPARCELNZ', 'Interparcel (NZ)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1365, 500, 0, 'INTERPARCELUK', 'INTERPARCELUK', 'Interparcel (UK)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1366, 500, 0, 'IOZYZ', 'IOZYZ', '欧洲专线(邮政)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1367, 500, 0, 'IPARCEL', 'IPARCEL', 'I-parcel', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1368, 500, 0, 'IPOSITARWANDA', 'IPOSITARWANDA', '卢旺达邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1369, 500, 0, 'IPTYYZ', 'IPTYYZ', '葡萄牙邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1370, 500, 0, 'IQQKD', 'IQQKD', '全球快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1371, 500, 0, 'IQTWL', 'IQTWL', '全通物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1372, 500, 0, 'ISDYZ', 'ISDYZ', '苏丹邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1373, 500, 0, 'ISEWDYZ', 'ISEWDYZ', '萨尔瓦多邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1374, 500, 0, 'ISEWYYZ', 'ISEWYYZ', '塞尔维亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1375, 500, 0, 'ISLFKYZ', 'ISLFKYZ', '斯洛伐克邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1376, 500, 0, 'ISLWNYYZ', 'ISLWNYYZ', '斯洛文尼亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1377, 500, 0, 'ISPLSYZ', 'ISPLSYZ', '塞浦路斯邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1378, 500, 0, 'ISTALBYZ', 'ISTALBYZ', '沙特阿拉伯邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1379, 500, 0, 'ITALYSDA', 'ITALYSDA', '意大利SDA', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1380, 500, 0, 'ITEQYZ', 'ITEQYZ', '土耳其邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1381, 500, 0, 'ITGYZ', 'ITGYZ', '泰国邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1382, 500, 0, 'ITLNDHDBGE', 'ITLNDHDBGE', '特立尼达和多巴哥EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1383, 500, 0, 'ITNSYZ', 'ITNSYZ', '突尼斯邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1384, 500, 0, 'ITSNYYZ', 'ITSNYYZ', '坦桑尼亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1385, 500, 0, 'IVORYCOASTEMS', 'IVORYCOASTEMS', '科特迪瓦 EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1386, 500, 0, 'IWDMLYZ', 'IWDMLYZ', '危地马拉邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1387, 500, 0, 'IWGDYZ', 'IWGDYZ', '乌干达邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1388, 500, 0, 'IWKLEMS', 'IWKLEMS', '乌克兰EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1389, 500, 0, 'IWKLYZ', 'IWKLYZ', '乌克兰邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1390, 500, 0, 'IWLGYZ', 'IWLGYZ', '乌拉圭邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1391, 500, 0, 'IWLYZ', 'IWLYZ', '文莱邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1392, 500, 0, 'IWZBKSTEMS', 'IWZBKSTEMS', '乌兹别克斯坦EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1393, 500, 0, 'IWZBKSTYZ', 'IWZBKSTYZ', '乌兹别克斯坦邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1394, 500, 0, 'IXBYYZ', 'IXBYYZ', '西班牙邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1395, 500, 0, 'IXFLWL', 'IXFLWL', '小飞龙物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1396, 500, 0, 'IXGLDNYYZ', 'IXGLDNYYZ', '新喀里多尼亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1397, 500, 0, 'IXJPEMS', 'IXJPEMS', '新加坡EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1398, 500, 0, 'IXJPYZ', 'IXJPYZ', '新加坡邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1399, 500, 0, 'IXLYYZ', 'IXLYYZ', '叙利亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1400, 500, 0, 'IXLYZ', 'IXLYZ', '希腊邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1401, 500, 0, 'IXPSJ', 'IXPSJ', '夏浦世纪', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1402, 500, 0, 'IXPWL', 'IXPWL', '夏浦物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1403, 500, 0, 'IXXLYZ', 'IXXLYZ', '新西兰邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1404, 500, 0, 'IXYLYZ', 'IXYLYZ', '匈牙利邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1405, 500, 0, 'IYDNXYYZ', 'IYDNXYYZ', '印度尼西亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1406, 500, 0, 'IYDYZ', 'IYDYZ', '印度邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1407, 500, 0, 'IYLYZ', 'IYLYZ', '伊朗邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1408, 500, 0, 'IYMNYYZ', 'IYMNYYZ', '亚美尼亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1409, 500, 0, 'IYMYZ', 'IYMYZ', '也门邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1410, 500, 0, 'IYNYZ', 'IYNYZ', '越南邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1411, 500, 0, 'IYSLYZ', 'IYSLYZ', '以色列邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1412, 500, 0, 'IYTG', 'IYTG', '易通关', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1413, 500, 0, 'IZBLTYZ', 'IZBLTYZ', '直布罗陀邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1414, 500, 0, 'IZLYZ', 'IZLYZ', '智利邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1415, 500, 0, 'Inposdom', 'Inposdom', 'Inposdom', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1416, 500, 0, 'J-Express', 'J-Express', 'J-Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1417, 500, 0, 'JAD', 'JAD', '捷安达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1418, 500, 0, 'JAMAICAPOST', 'JAMAICAPOST', '牙买加邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1419, 500, 0, 'JAMEXPRESS', 'JAMEXPRESS', 'Jam Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1420, 500, 0, 'JANIO', 'JANIO', 'janio', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1421, 500, 0, 'JAYEEK', 'JAYEEK', 'Jayeek', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1422, 500, 0, 'JAYONEXPRESS', 'JAYONEXPRESS', 'Jayon Express (JEX)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1423, 500, 0, 'JCEX', 'JCEX', '佳成国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1424, 500, 0, 'JDE', 'JDE', 'JDE', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1425, 500, 0, 'JDKY', 'JDKY', '京东快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1426, 500, 0, 'JDLOGISTICS', 'JDLOGISTICS', '京东国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1427, 500, 0, 'JDPPLUS', 'JDPPLUS', '美国急递速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1428, 500, 0, 'JDWL', 'JDWL', '金大物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1429, 500, 0, 'JDY', 'JDY', '金斗云物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1430, 500, 0, 'JENY', 'JENY', 'JENY', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1431, 500, 0, 'JERSEYPOST', 'JERSEYPOST', 'Jersey Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1432, 500, 0, 'JET', 'JET', 'JET', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1433, 500, 0, 'JETSHIP', 'JETSHIP', 'Jet-Ship Worldwide', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1434, 500, 0, 'JFGJ', 'JFGJ', '今枫国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1435, 500, 0, 'JGWL', 'JGWL', '景光物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1436, 500, 0, 'JGZY', 'JGZY', '极光转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1437, 500, 0, 'JIAJI', 'JIAJI', '佳吉物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1438, 500, 0, 'JIEHANG', 'JIEHANG', '杰航国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1439, 500, 0, 'JIUYE', 'JIUYE', '九曳供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1440, 500, 0, 'JLDT', 'JLDT', '嘉里国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1441, 500, 0, 'JNEEXPRESS', 'JNEEXPRESS', 'JNE Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1442, 500, 0, 'JNET', 'JNET', 'J-NET捷网', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1443, 500, 0, 'JOYINGBOX', 'JOYINGBOX', '飞盒跨境', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1444, 500, 0, 'JP', 'JP', '日本邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1445, 500, 0, 'JPBHPOST', 'JPBHPOST', 'JP BH Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1446, 500, 0, 'JPKD', 'JPKD', '绝配国际速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1447, 500, 0, 'JPSGJWL', 'JPSGJWL', '捷谱斯国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1448, 500, 0, 'JRHYWL', 'JRHYWL', '金润荷役物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1449, 500, 0, 'JSEXP', 'JSEXP', '急速国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1450, 500, 0, 'JTEX', 'JTEX', 'JTEX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1451, 500, 0, 'JTEXPRESSID', 'JTEXPRESSID', 'J&TExpress(ID)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1452, 500, 0, 'JTEXPRESSMY', 'JTEXPRESSMY', 'J&TExpress(MY)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1453, 500, 0, 'JTEXPRESSTH', 'JTEXPRESSTH', 'J&T Express TH', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1454, 500, 0, 'JTKD', 'JTKD', '捷特快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1455, 500, 0, 'JUXIEX', 'JUXIEX', '上海驹隙', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1456, 500, 0, 'JXD', 'JXD', '急先达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1457, 500, 0, 'JXYKD', 'JXYKD', '吉祥邮转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1458, 500, 0, 'JY', 'JY', 'JY', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1459, 500, 0, 'JYKD', 'JYKD', '晋越快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1460, 500, 0, 'JYSD', 'JYSD', '上海久易国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1461, 500, 0, 'JYSY', 'JYSY', '精英速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1462, 500, 0, 'JYWL', 'JYWL', '佳怡物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1463, 500, 0, 'JoeyCo', 'JoeyCo', 'JoeyCo', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1464, 500, 0, 'K-mestu', 'K-mestu', 'K-mestu', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1465, 500, 0, 'KANGAROOMY', 'KANGAROOMY', 'Kangaroo Worldwide Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1466, 500, 0, 'KAWA', 'KAWA', '嘉华', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1467, 500, 0, 'KBSY', 'KBSY', '快8速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1468, 500, 0, 'KD1913', 'KD1913', '飞速国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1469, 500, 0, 'KERRYECOMMERCE', 'KERRYECOMMERCE', '嘉里电子商务', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1470, 500, 0, 'KERRYEXPRESS', 'KERRYEXPRESS', 'Kerry Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1471, 500, 0, 'KERRYEXPRESSTH', 'KERRYEXPRESSTH', 'kerryexpress-th', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1472, 500, 0, 'KERRYLOGISTICS', 'KERRYLOGISTICS', '嘉里大通物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1473, 500, 0, 'KERRYTEC', 'KERRYTEC', 'Kerry Tec', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1474, 500, 0, 'KFW', 'KFW', '快服务', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1475, 500, 0, 'KFY', 'KFY', '快飞鱼', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1476, 500, 0, 'KGMHUB', 'KGMHUB', 'KGM Hub', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1477, 500, 0, 'KINGRUNS', 'KINGRUNS', 'Kingruns土耳其鲸仓', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1478, 500, 0, 'KIRIBATIPOST', 'KIRIBATIPOST', 'Kiribati Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1479, 500, 0, 'KJY', 'KJY', '跨境翼物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1480, 500, 0, 'KLWL', 'KLWL', '康力物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1481, 500, 0, 'KOMONEXPRESS', 'KOMONEXPRESS', '可蒙国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1482, 500, 0, 'KONGLOK', 'KONGLOK', '港乐速邮', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1483, 500, 0, 'KOREAPOST', 'KOREAPOST', 'Korea Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1484, 500, 0, 'KOREAPOSTDOMESTIC', 'KOREAPOSTDOMESTIC', 'Korea Post (Domestic)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1485, 500, 0, 'KREXI', 'KREXI', '坤翔国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1486, 500, 0, 'KSDWL', 'KSDWL', '快速递物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1487, 500, 0, 'KTKD', 'KTKD', '快淘快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1488, 500, 0, 'KUAIDAWULIU', 'KUAIDAWULIU', '快达物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1489, 500, 0, 'KUAJINGLINE56', 'KUAJINGLINE56', '跨境在线', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1490, 500, 0, 'KUAJINGYIHAO', 'KUAJINGYIHAO', '跨境壹号', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1491, 500, 0, 'KUEHNENAGEL', 'KUEHNENAGEL', 'Kuehne Nagel', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1492, 500, 0, 'KUWAITPOST', 'KUWAITPOST', 'Kuwait Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1493, 500, 0, 'KWT', 'KWT', 'KWT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1494, 500, 0, 'KWT56', 'KWT56', '京华达物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1495, 500, 0, 'KYDSD', 'KYDSD', '快优达速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1496, 500, 0, 'KYRGYZEXPRESSPOST', 'KYRGYZEXPRESSPOST', 'Kyrgyz Express Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1497, 500, 0, 'LANDMARKGLOBAL', 'LANDMARKGLOBAL', 'Landmark Global快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1498, 500, 0, 'LAOSPOST', 'LAOSPOST', '老挝邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1499, 500, 0, 'LAPOSTE', 'LAPOSTE', 'La Poste', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1500, 500, 0, 'LAPOSTEDEBENIN', 'LAPOSTEDEBENIN', 'La Poste De Benin', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1501, 500, 0, 'LAPOSTEDESENEGAL', 'LAPOSTEDESENEGAL', 'La Poste De Senegal', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1502, 500, 0, 'LAPOSTEDETOGO', 'LAPOSTEDETOGO', 'LaPosteDeTogo', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1503, 500, 0, 'LAPOSTEDETUNISIA', 'LAPOSTEDETUNISIA', 'LaPosteDeTunisia', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1504, 500, 0, 'LAPOSTEMONACO', 'LAPOSTEMONACO', '摩纳哥邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1505, 500, 0, 'LASERSHIP', 'LASERSHIP', 'Lasership', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1506, 500, 0, 'LATVIAPOST', 'LATVIAPOST', 'Latvia Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1507, 500, 0, 'LB', 'LB', '龙邦快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1508, 500, 0, 'LBCEXPRESS', 'LBCEXPRESS', 'LBC Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1509, 500, 0, 'LBEXPS', 'LBEXPS', '立邦国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1510, 500, 0, 'LDLOG', 'LDLOG', '龙迅国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1511, 500, 0, 'LDXPRESS', 'LDXPRESS', '林道快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1512, 500, 0, 'LEADER', 'LEADER', 'LEADER', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1513, 500, 0, 'LEDII', 'LEDII', '乐递供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1514, 500, 0, 'LEOPARDSCHINA', 'LEOPARDSCHINA', 'LWE云豹', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1515, 500, 0, 'LESOTHOPOST', 'LESOTHOPOST', '莱索托邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1516, 500, 0, 'LEX', 'LEX', 'LEX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1517, 500, 0, 'LGS', 'LGS', 'Lazada (LGS) 快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1518, 500, 0, 'LHG', 'LHG', 'LHG', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1519, 500, 0, 'LHKD', 'LHKD', '蓝弧快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1520, 500, 0, 'LHKDS', 'LHKDS', '联合快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1521, 500, 0, 'LHT', 'LHT', '联昊通速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1522, 500, 0, 'LINECLEAR', 'LINECLEAR', 'Line Clear Express & Logistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1523, 500, 0, 'LINEXSOLUTIONS', 'LINEXSOLUTIONS', 'Linex 快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1524, 500, 0, 'LINGXUN', 'LINGXUN', '领讯物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1525, 500, 0, 'LITHUANIAPOST', 'LITHUANIAPOST', 'Lithuania Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1526, 500, 0, 'LJD', 'LJD', '乐捷递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1527, 500, 0, 'LJS', 'LJS', '立即送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1528, 500, 0, 'LMPARCEL', 'LMPARCEL', '六脉速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1529, 500, 0, 'LOGISTICS', 'LOGISTICS', '世航通运WEL', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1530, 500, 0, 'LONFENNERLOGISTIC', 'LONFENNERLOGISTIC', '纵横迅通国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1531, 500, 0, 'LOOMISEXPRESS', 'LOOMISEXPRESS', 'Loomis Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1532, 500, 0, 'LPEXPRESS', 'LPEXPRESS', 'LP Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1533, 500, 0, 'LTIAN', 'LTIAN', '乐天国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1534, 500, 0, 'LWEHK', 'LWEHK', 'LWE', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1535, 500, 0, 'LY', 'LY', 'LY', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1536, 500, 0, 'LY-B2C', 'LY-B2C', '深圳市雷翼国际物流有限公司', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1537, 500, 0, 'LYT', 'LYT', '联运通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1538, 500, 0, 'MACAOPOST', 'MACAOPOST', '澳门邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1539, 500, 0, 'MACAUPOST', 'MACAUPOST', 'Macau Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1540, 500, 0, 'MAILAMERICAS', 'MAILAMERICAS', 'MailAmericas', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1541, 500, 0, 'MATDESPATCH', 'MATDESPATCH', 'Matdespatch快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1542, 500, 0, 'MATKAHUOLTO', 'MATKAHUOLTO', 'Matkahuolto', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1543, 500, 0, 'MAXCELLENTS', 'MAXCELLENTS', 'Maxcellents Pte Ltd', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1544, 500, 0, 'MB', 'MB', '民邦快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1545, 500, 0, 'MCTRANSEXPRESS', 'MCTRANSEXPRESS', '马可达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1546, 500, 0, 'MD', 'MD', '迈达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1547, 500, 0, 'MDEXPRESS', 'MDEXPRESS', '茂聪国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1548, 500, 0, 'MDM', 'MDM', '门对门快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1549, 500, 0, 'MEEST', 'MEEST', 'Meest快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1550, 500, 0, 'MEITAI', 'MEITAI', '美泰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1551, 500, 0, 'MEXICOPOST', 'MEXICOPOST', 'Mexico Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1552, 500, 0, 'MHAFLY', 'MHAFLY', '梦和爱', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1553, 500, 0, 'MHKD', 'MHKD', '民航快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1554, 500, 0, 'MICROEXPRESS', 'MICROEXPRESS', 'MicroExpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1555, 500, 0, 'MIUSONINTERNATIONAL', 'MIUSONINTERNATIONAL', '深圳淼信国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1556, 500, 0, 'MK', 'MK', '美快', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1557, 500, 0, 'MLWL', 'MLWL', '明亮物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1558, 500, 0, 'MONACOEMS', 'MONACOEMS', '摩纳哥 EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1559, 500, 0, 'MONDIALRELAY', 'MONDIALRELAY', 'Mondial Relay', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1560, 500, 0, 'MONGOLPOST', 'MONGOLPOST', '蒙古邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1561, 500, 0, 'MONTENEGROPOST', 'MONTENEGROPOST', 'Montenegro Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1562, 500, 0, 'MOROCCOPOST', 'MOROCCOPOST', 'Morocco Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1563, 500, 0, 'MRDY', 'MRDY', '迈隆递运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1564, 500, 0, 'MRWSPAIN', 'MRWSPAIN', 'MRW', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1565, 500, 0, 'MSKD', 'MSKD', '闽盛快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1566, 500, 0, 'MXE', 'MXE', '上海淼信国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1567, 500, 0, 'MXE56', 'MXE56', '上海淼信', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1568, 500, 0, 'MYANMAPOST', 'MYANMAPOST', 'Myanma Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1569, 500, 0, 'MYAUSTRIANPOST', 'MYAUSTRIANPOST', '澳邮欧洲专线平邮', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1570, 500, 0, 'MYDSERVICE', 'MYDSERVICE', '满壹滴', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1571, 500, 0, 'MYIB', 'MYIB', 'MyIB', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1572, 500, 0, 'MYPOSTONLINE', 'MYPOSTONLINE', 'Mypostonline', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1573, 500, 0, 'MZ56', 'MZ56', '铭志国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1574, 500, 0, 'Madrooex', 'Madrooex', 'Madrooex', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1575, 500, 0, 'NAMIBIAPOST', 'NAMIBIAPOST', '纳米比亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1576, 500, 0, 'NANJINGWOYUAN', 'NANJINGWOYUAN', '南京沃源', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1577, 500, 0, 'NAQEL', 'NAQEL', 'Naqel', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1578, 500, 0, 'NATIONWIDEMY', 'NATIONWIDEMY', 'Nationwide Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1579, 500, 0, 'NEDA', 'NEDA', '能达速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1580, 500, 0, 'NEPALPOST', 'NEPALPOST', 'Nepal Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1581, 500, 0, 'NETHERLANDSPOST', 'NETHERLANDSPOST', '荷兰邮政(大包)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1582, 500, 0, 'NEWGISTICS', 'NEWGISTICS', 'Newgistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1583, 500, 0, 'NEXIVE', 'NEXIVE', 'Nexive', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1584, 500, 0, 'NFCM', 'NFCM', '南方传媒物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1585, 500, 0, 'NHANSSOLUTIONS', 'NHANSSOLUTIONS', 'Nhans Solutions', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1586, 500, 0, 'NICARAGUAPOST', 'NICARAGUAPOST', '尼加拉瓜邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1587, 500, 0, 'NIGERIANPOST', 'NIGERIANPOST', 'Nigerian Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1588, 500, 0, 'NIGHTLINE', 'NIGHTLINE', 'Nightline', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1589, 500, 0, 'NINJAVAN', 'NINJAVAN', 'Ninja Van', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1590, 500, 0, 'NINJAVANID', 'NINJAVANID', 'Ninjavan (ID)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1591, 500, 0, 'NINJAVANMY', 'NINJAVANMY', 'Ninja Van （马来西亚）', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1592, 500, 0, 'NINJAVANPH', 'NINJAVANPH', 'Ninja Van (菲律宾)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1593, 500, 0, 'NINJAVANSG', 'NINJAVANSG', 'Ninjavan(SG)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1594, 500, 0, 'NINJAVANTH', 'NINJAVANTH', 'Ninja Van （泰国）', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1595, 500, 0, 'NINJAVANVN', 'NINJAVANVN', 'Ninja Van（越南）', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1596, 500, 0, 'NINJAXPRESS', 'NINJAXPRESS', 'Ninja Van （印度尼西亚）', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1597, 500, 0, 'NIPPON', 'NIPPON', 'Nippon日本通运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1598, 500, 0, 'NJFEIBAO', 'NJFEIBAO', '金陵飞豹快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1599, 500, 0, 'NJSBWL', 'NJSBWL', '南京晟邦物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1600, 500, 0, 'NORWAYPOST', 'NORWAYPOST', 'Norway Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1601, 500, 0, 'NOVAPOSHTA', 'NOVAPOSHTA', 'Nova Poshta', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1602, 500, 0, 'NOVAPOSHTAGLOBAL', 'NOVAPOSHTAGLOBAL', 'Nova Poshta Global', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1603, 500, 0, 'NSF', 'NSF', '新顺丰', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1604, 500, 0, 'NUO', 'NUO', 'NUO', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1605, 500, 0, 'NUVOEX', 'NUVOEX', 'NuvoEx', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1606, 500, 0, 'OCA', 'OCA', 'OCA', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1607, 500, 0, 'OCAAR', 'OCAAR', 'OCA Argentina', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1608, 500, 0, 'OCS', 'OCS', 'OCS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1609, 500, 0, 'OCSCHINA', 'OCSCHINA', 'OCS国际快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1610, 500, 0, 'OCSWORLDWIDE', 'OCSWORLDWIDE', 'OCS Worldwide', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1611, 500, 0, 'OFO56', 'OFO56', '南北通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1612, 500, 0, 'OJEXPRESS', 'OJEXPRESS', '欧捷', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1613, 500, 0, 'OLDDOMINION', 'OLDDOMINION', 'Old Dominion Freight Line', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1614, 500, 0, 'OMNIPARCEL', 'OMNIPARCEL', 'Omni Parcel快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1615, 500, 0, 'ONEWORLD', 'ONEWORLD', 'One World', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1616, 500, 0, 'ONEWORLDEXPRESS', 'ONEWORLDEXPRESS', '万欧国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1617, 500, 0, 'ONTRAC', 'ONTRAC', 'ONTRAC', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1618, 500, 0, 'OOPSTON', 'OOPSTON', 'OOPSTON', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1619, 500, 0, 'OPEK', 'OPEK', '波兰FedEx', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1620, 500, 0, 'OPT-NC', 'OPT-NC', 'OPT-NC', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1621, 500, 0, 'ORANGECONNEX', 'ORANGECONNEX', '橙联股份', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1622, 500, 0, 'ORANGEDS', 'ORANGEDS', 'OrangeDS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1623, 500, 0, 'OTHER', 'OTHER', '其他快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1624, 500, 0, 'OVERNITENET', 'OVERNITENET', 'Overnite印度快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1625, 500, 0, 'OVERSEASLOGISTICS', 'OVERSEASLOGISTICS', 'Overseas Logistics 印度快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1626, 500, 0, 'OVERSEASTERRITORYFREMS', 'OVERSEASTERRITORYFREMS', '海外领地法国 EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1627, 500, 0, 'OWDIEX', 'OWDIEX', '轻松速达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1628, 500, 0, 'P2PMAILING', 'P2PMAILING', 'P2PMailing', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1629, 500, 0, 'PACKLINK', 'PACKLINK', 'Packlink', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1630, 500, 0, 'PADTF', 'PADTF', '平安达腾飞快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1631, 500, 0, 'PALESTINEPOST', 'PALESTINEPOST', 'Palestine Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1632, 500, 0, 'PALEXPRESS', 'PALEXPRESS', 'PALExpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1633, 500, 0, 'PANDULOGISTICS', 'PANDULOGISTICS', 'Pandu Logistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1634, 500, 0, 'PANEX', 'PANEX', '泛捷快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1635, 500, 0, 'PAPA', 'PAPA', '啪啪供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1636, 500, 0, 'PARCEL', 'PARCEL', 'PitneyBowes', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1637, 500, 0, 'PARCELCHINA', 'PARCELCHINA', '诚一物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1638, 500, 0, 'PARCELEXPRESS', 'PARCELEXPRESS', 'Parcel Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1639, 500, 0, 'PARCELFORCE', 'PARCELFORCE', '英国邮政parcelforce', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1640, 500, 0, 'PARCELJET', 'PARCELJET', '派速捷', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1641, 500, 0, 'PARCELLEDIN', 'PARCELLEDIN', 'Parcelled.in', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1642, 500, 0, 'PCA', 'PCA', 'PCA Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1643, 500, 0, 'PCF', 'PCF', 'PCF', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1644, 500, 0, 'PFCEXPRESS', 'PFCEXPRESS', 'PFC皇家物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1645, 500, 0, 'PFLOGISTICS', 'PFLOGISTICS', 'Parcel Freight Logistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1646, 500, 0, 'PHLPOST', 'PHLPOST', '菲律宾邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1647, 500, 0, 'PJ', 'PJ', '品骏快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1648, 500, 0, 'PNGPOST', 'PNGPOST', 'PNG Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1649, 500, 0, 'POLANDPOST', 'POLANDPOST', 'Poland Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1650, 500, 0, 'PONYEXPRESS', 'PONYEXPRESS', 'Pony Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1651, 500, 0, 'POSINDONESIA', 'POSINDONESIA', 'Pos Indonesia', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1652, 500, 0, 'POSMALAYSIA', 'POSMALAYSIA', 'Pos Malaysia', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1653, 500, 0, 'POSTAPLUS', 'POSTAPLUS', 'PostaPlus', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1654, 500, 0, 'POSTEIBE', 'POSTEIBE', 'POSTEIBE', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1655, 500, 0, 'POSTEITALIANE', 'POSTEITALIANE', 'PosteItaliane', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1656, 500, 0, 'POSTEN', 'POSTEN', '挪威邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1657, 500, 0, 'POSTNL', 'POSTNL', '荷兰邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1658, 500, 0, 'POSTNL3S', 'POSTNL3S', 'PostNL International 3S', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1659, 500, 0, 'POSTNLINTERNATIONALMAIL', 'POSTNLINTERNATIONALMAIL', 'PostNL International Mail', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1660, 500, 0, 'POSTNORDDANMARK', 'POSTNORDDANMARK', 'PostNord Danmark', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1661, 500, 0, 'POSTNORDSWEDEN', 'POSTNORDSWEDEN', 'PostNord Sweden', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1662, 500, 0, 'POSTPNG', 'POSTPNG', '巴布亚新几内亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1663, 500, 0, 'PPLCZ', 'PPLCZ', 'PPL CZ', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1664, 500, 0, 'PROFESSIONALCOURIERS', 'PROFESSIONALCOURIERS', 'The Professional Couriers (TPC)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1665, 500, 0, 'PTSWORLDWIDEEXPRESS', 'PTSWORLDWIDEEXPRESS', 'PTSWorldwideExpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1666, 500, 0, 'PTT', 'PTT', 'PTT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1667, 500, 0, 'PUROLATOR', 'PUROLATOR', 'Purolator', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1668, 500, 0, 'PXWL', 'PXWL', '陪行物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1669, 500, 0, 'PYEXPRESS', 'PYEXPRESS', '派优供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1670, 500, 0, 'Packeta', 'Packeta', 'Packeta', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1671, 500, 0, 'Paquetexpress', 'Paquetexpress', 'Paquetexpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1672, 500, 0, 'Parcel2GO', 'Parcel2GO', 'Parcel2GO', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1673, 500, 0, 'PostPlus', 'PostPlus', 'PostPlus', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1674, 500, 0, 'Posti', 'Posti', 'Posti', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1675, 500, 0, 'Q-Post', 'Q-Post', 'Q-Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1676, 500, 0, 'QCKD', 'QCKD', '全晨快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1677, 500, 0, 'QDANTS', 'QDANTS', 'ANTSEXPRESS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1678, 500, 0, 'QEXPRESS', 'QEXPRESS', '新西兰易达通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1679, 500, 0, 'QIELEVEN', 'QIELEVEN', '7-ELEVEN', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1680, 500, 0, 'QLINYUN', 'QLINYUN', '麒麟物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1681, 500, 0, 'QQYZ', 'QQYZ', '全球邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1682, 500, 0, 'QRT', 'QRT', '全日通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1683, 500, 0, 'QUANTIUM', 'QUANTIUM', '冠庭国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1684, 500, 0, 'QUICK', 'QUICK', '快客快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1685, 500, 0, 'QUICKWAY', 'QUICKWAY', '瞬程物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1686, 500, 0, 'QXPRESS', 'QXPRESS', 'Qxpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1687, 500, 0, 'QXT', 'QXT', '全信通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1688, 500, 0, 'QYEXP', 'QYEXP', '前雨国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1689, 500, 0, 'QYHY', 'QYHY', '秦远海运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1690, 500, 0, 'QYSC', 'QYSC', 'QYSC', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1691, 500, 0, 'QYZY', 'QYZY', '七曜中邮', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1692, 500, 0, 'Qualitypost', 'Qualitypost', 'Qualitypost', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1693, 500, 0, 'RAF', 'RAF', 'RAF Philippines', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1694, 500, 0, 'RAIDEREX', 'RAIDEREX', 'RaidereX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1695, 500, 0, 'RDSE', 'RDSE', '瑞典邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1696, 500, 0, 'REDBOXMV', 'REDBOXMV', 'RedboxMV', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1697, 500, 0, 'REDPACKMEXICO', 'REDPACKMEXICO', 'Redpack Mexico', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1698, 500, 0, 'REDURES', 'REDURES', 'Redur Spain', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1699, 500, 0, 'RFD', 'RFD', '如风达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1700, 500, 0, 'RFEX', 'RFEX', '瑞丰速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1701, 500, 0, 'RHM', 'RHM', 'RHM', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1702, 500, 0, 'RINCOS', 'RINCOS', 'RINCOS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1703, 500, 0, 'RLCARRIERS', 'RLCARRIERS', 'RL Carriers', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1704, 500, 0, 'RLG', 'RLG', '澳洲飞跃', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1705, 500, 0, 'RLWL', 'RLWL', '日昱物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1706, 500, 0, 'ROADBULL', 'ROADBULL', 'Roadbull Logistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1707, 500, 0, 'ROMANIAPOST', 'ROMANIAPOST', 'Romania Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1708, 500, 0, 'ROSAN', 'ROSAN', '中乌融盛速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1709, 500, 0, 'ROYALMAIL', 'ROYALMAIL', 'Royal Mail', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1710, 500, 0, 'ROYALSHIPMENTS', 'ROYALSHIPMENTS', 'Royal Shipments', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1711, 500, 0, 'RPX', 'RPX', 'RPX Indonesia', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1712, 500, 0, 'RPXONLINE', 'RPXONLINE', 'RPX保时达国际快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1713, 500, 0, 'RQ', 'RQ', '荣庆物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1714, 500, 0, 'RRDONNELLEY', 'RRDONNELLEY', 'RR Donnelley', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1715, 500, 0, 'RRS', 'RRS', '日日顺物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1716, 500, 0, 'RUECOM', 'RUECOM', '如易', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1717, 500, 0, 'RUNBAIL', 'RUNBAIL', '润百', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1718, 500, 0, 'RUSTON', 'RUSTON', 'Ruston俄速通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1719, 500, 0, 'RWANDAPOST', 'RWANDAPOST', 'Rwanda Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1720, 500, 0, 'RZYEXPRESS', 'RZYEXPRESS', 'RZY Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1721, 500, 0, 'Redbox', 'Redbox', 'Redbox', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1722, 500, 0, 'Redpack', 'Redpack', 'Redpack', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1723, 500, 0, 'SAD', 'SAD', '赛澳递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1724, 500, 0, 'SAEE', 'SAEE', 'SAEE', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1725, 500, 0, 'SAFEXPRESS', 'SAFEXPRESS', 'Safexpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1726, 500, 0, 'SAFLY', 'SAFLY', '吉飞国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1727, 500, 0, 'SAGAWA', 'SAGAWA', 'Sagawa佐川急便', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1728, 500, 0, 'SAGAWAGLOBAL', 'SAGAWAGLOBAL', 'SagawaGlobal', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1729, 500, 0, 'SAIAFREIGHT', 'SAIAFREIGHT', 'Saia LTL Freight', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1730, 500, 0, 'SAICHENG', 'SAICHENG', '赛诚国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1731, 500, 0, 'SAILPOST', 'SAILPOST', 'Sailpost', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1732, 500, 0, 'SAINTLUCIAPOST', 'SAINTLUCIAPOST', '圣卢西亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1733, 500, 0, 'SAMOAPOST', 'SAMOAPOST', '西萨摩亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1734, 500, 0, 'SANMARINOPOST', 'SANMARINOPOST', '圣马力诺邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1735, 500, 0, 'SAWL', 'SAWL', '圣安物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1736, 500, 0, 'SBD', 'SBD', 'SBD', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1737, 500, 0, 'SCGJ56', 'SCGJ56', '拾诚国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1738, 500, 0, 'SCM', 'SCM', 'SCM', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1739, 500, 0, 'SCOREJP', 'SCOREJP', '中国流通王', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1740, 500, 0, 'SCZPDS', 'SCZPDS', '速呈宅配', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1741, 500, 0, 'SDA', 'SDA', 'SDA', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1742, 500, 0, 'SDEZ', 'SDEZ', '速递e站', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1743, 500, 0, 'SDHH', 'SDHH', '山东海红', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1744, 500, 0, 'SDKEXPRESS', 'SDKEXPRESS', '斯德克', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1745, 500, 0, 'SDSY', 'SDSY', '首达速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1746, 500, 0, 'SDTO', 'SDTO', '速达通跨境物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1747, 500, 0, 'SDWL', 'SDWL', '上大物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1748, 500, 0, 'SENDCN', 'SENDCN', '速递中国', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1749, 500, 0, 'SENDLE', 'SENDLE', 'Sendle', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1750, 500, 0, 'SENEGALPOST', 'SENEGALPOST', '塞内加尔邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1751, 500, 0, 'SEYCHELLESPOST', 'SEYCHELLESPOST', '塞舌尔邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1752, 500, 0, 'SFB2C', 'SFB2C', '顺丰国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1753, 500, 0, 'SFWL', 'SFWL', '盛丰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1754, 500, 0, 'SGF', 'SGF', 'SGF', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1755, 500, 0, 'SGT', 'SGT', 'SGT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1756, 500, 0, 'SGTIT', 'SGTIT', 'SGT Corriere Espresso', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1757, 500, 0, 'SGTWL', 'SGTWL', '深港台物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1758, 500, 0, 'SHLDHY', 'SHLDHY', '林道国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1759, 500, 0, 'SHOWL', 'SHOWL', '森鸿物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1760, 500, 0, 'SHREEMAHABALIEXPRESS', 'SHREEMAHABALIEXPRESS', 'Shree Mahabali Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1761, 500, 0, 'SHREEMARUTICOURIER', 'SHREEMARUTICOURIER', 'Shree Maruti Courier', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1762, 500, 0, 'SHREETIRUPATI', 'SHREETIRUPATI', 'Shree Tirupati', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1763, 500, 0, 'SHT', 'SHT', 'SHT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1764, 500, 0, 'SHWL', 'SHWL', '盛辉物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1765, 500, 0, 'SINGAPOREPOST', 'SINGAPOREPOST', '新加坡邮政(小包)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1766, 500, 0, 'SINGAPORESPEEDPOST', 'SINGAPORESPEEDPOST', '新加坡特快专递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1767, 500, 0, 'SINOAIR', 'SINOAIR', '中外运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1768, 500, 0, 'SINODIDI', 'SINODIDI', '外运迪迪', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1769, 500, 0, 'SIODEMKA', 'SIODEMKA', 'Siodemka', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1770, 500, 0, 'SJ', 'SJ', '郑州速捷', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1771, 500, 0, 'SJTSZ', 'SJTSZ', '盛吉泰快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1772, 500, 0, 'SJWL', 'SJWL', '穗佳物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1773, 500, 0, 'SK', 'SK', '穗空物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1774, 500, 0, 'SKYNET', 'SKYNET', 'SkyNet', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1775, 500, 0, 'SKYNETMY', 'SKYNETMY', 'Skynet(MY)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1776, 500, 0, 'SKYNETWORLDWIDE', 'SKYNETWORLDWIDE', 'SkyNet国际快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1777, 500, 0, 'SKYNETWORLDWIDEUK', 'SKYNETWORLDWIDEUK', 'Skynet Worldwide Express UK', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1778, 500, 0, 'SKYPOST', 'SKYPOST', 'SKYPOST', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1779, 500, 0, 'SMARTCAT', 'SMARTCAT', 'SMARTCAT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1780, 500, 0, 'SMARTPOSTGLOBAL', 'SMARTPOSTGLOBAL', 'SMARTPostGlobal', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1781, 500, 0, 'SMSAEXPRESS', 'SMSAEXPRESS', 'SMSA快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1782, 500, 0, 'SNWL', 'SNWL', '苏宁物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1783, 500, 0, 'SOLOMONPOST', 'SOLOMONPOST', '所罗门群岛邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1784, 500, 0, 'SONAPOST', 'SONAPOST', '布基纳法索邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1785, 500, 0, 'SPECIALISEDFREIGHT', 'SPECIALISEDFREIGHT', 'Specialised Freight', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1786, 500, 0, 'SPEEDEE', 'SPEEDEE', 'Spee-Dee Delivery', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1787, 500, 0, 'SPEEDEXCOURIER', 'SPEEDEXCOURIER', 'Speedex Courier', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1788, 500, 0, 'SPEEDPAK', 'SPEEDPAK', 'SpeedPAK物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1789, 500, 0, 'SPEEDPOST', 'SPEEDPOST', 'speed-post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1790, 500, 0, 'SPES', 'SPES', '速易邮', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1791, 500, 0, 'SPOTON', 'SPOTON', 'Spoton', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1792, 500, 0, 'SPRINGGDS', 'SPRINGGDS', 'Spring GDS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1793, 500, 0, 'SPRINTPACK', 'SPRINTPACK', 'SprintPack', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1794, 500, 0, 'SPSR', 'SPSR', '中俄快递SPSR', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1795, 500, 0, 'SQWL', 'SQWL', '商桥物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1796, 500, 0, 'SREKOREA', 'SREKOREA', 'SRE Korea', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1797, 500, 0, 'SRILANKAPOST', 'SRILANKAPOST', '斯里兰卡邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1798, 500, 0, 'SS', 'SS', '闪送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1799, 500, 0, 'ST', 'ST', '速通物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1800, 500, 0, 'STADT', 'STADT', '施塔特', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1801, 500, 0, 'STARTRACK', 'STARTRACK', 'Star Track 快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1802, 500, 0, 'STKD', 'STKD', '盛通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1803, 500, 0, 'STONG', 'STONG', '首通快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1804, 500, 0, 'STO_INTL', 'STO_INTL', '申通快递国际单', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1805, 500, 0, 'STSD', 'STSD', '三态速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1806, 500, 0, 'STWL', 'STWL', '速腾快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1807, 500, 0, 'SUBIDA', 'SUBIDA', '速必达物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1808, 500, 0, 'SUMTOM', 'SUMTOM', 'SUMTOM', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1809, 500, 0, 'SUMXPRESS', 'SUMXPRESS', '速玛物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1810, 500, 0, 'SUNSHINE', 'SUNSHINE', '光线速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1811, 500, 0, 'SUNSPEEDY', 'SUNSPEEDY', '新速航', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1812, 500, 0, 'SUNYOU', 'SUNYOU', '顺友物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1813, 500, 0, 'SUPEROZ', 'SUPEROZ', '速配鸥翼', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1814, 500, 0, 'SUPERTON', 'SUPERTON', '速宝通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1815, 500, 0, 'SURE', 'SURE', '速尔快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1816, 500, 0, 'SUYD56', 'SUYD56', '速邮达物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1817, 500, 0, 'SVGPOST', 'SVGPOST', '圣文森特和格林纳丁斯', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1818, 500, 0, 'SWCH', 'SWCH', '瑞士邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1819, 500, 0, 'SWISHIP', 'SWISHIP', 'Swiship UK', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1820, 500, 0, 'SWISSPOST', 'SWISSPOST', 'Swiss Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1821, 500, 0, 'SX', 'SX', '顺心捷达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1822, 500, 0, 'SXEXPRESS', 'SXEXPRESS', '三象速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1823, 500, 0, 'SXHMJ', 'SXHMJ', '山西红马甲', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1824, 500, 0, 'SYJHE', 'SYJHE', '佳惠尔', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1825, 500, 0, 'SYJWDX', 'SYJWDX', '佳旺达物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1826, 500, 0, 'SYKD', 'SYKD', '世运快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1827, 500, 0, 'SZDPEX', 'SZDPEX', 'DPEX国际快递（中国）', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1828, 500, 0, 'SZEAC', 'SZEAC', '富皇美运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1829, 500, 0, 'SZEDLON', 'SZEDLON', '誉德隆物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1830, 500, 0, 'SZENDEX', 'SZENDEX', 'Szendex', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1831, 500, 0, 'SZJY188', 'SZJY188', '神州集运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1832, 500, 0, 'SZPAGO', 'SZPAGO', '派格国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1833, 500, 0, 'SZQFSY', 'SZQFSY', '深圳轻风', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1834, 500, 0, 'SZTY56', 'SZTY56', '通邮集团', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1835, 500, 0, 'SZYN', 'SZYN', '英诺供应链', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1836, 500, 0, 'Seino', 'Seino', 'Seino', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1837, 500, 0, 'Shadowfax', 'Shadowfax', 'Shadowfax', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1838, 500, 0, 'SkyPostal', 'SkyPostal', 'SkyPostal', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1839, 500, 0, 'Speedy', 'Speedy', 'Speedy', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1840, 500, 0, 'Sprintstar', 'Sprintstar', 'Sprintstar', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1841, 500, 0, 'SunJT', 'SunJT', 'SunJT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1842, 500, 0, 'Sunnyway', 'Sunnyway', 'Sunnyway', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1843, 500, 0, 'T-CAT', 'T-CAT', 'T-CAT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1844, 500, 0, 'TAILAND138', 'TAILAND138', '泰国138', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1845, 500, 0, 'TAIMEK', 'TAIMEK', '天美快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1846, 500, 0, 'TAIWANPOST', 'TAIWANPOST', '中華郵政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1847, 500, 0, 'TAIWANYZ', 'TAIWANYZ', '台湾邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1848, 500, 0, 'TAKESEND', 'TAKESEND', '泰嘉物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1849, 500, 0, 'TAQBINHK', 'TAQBINHK', '香港宅急便', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1850, 500, 0, 'TAQBINJP', 'TAQBINJP', 'Yamato宅急便', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1851, 500, 0, 'TAQBINMY', 'TAQBINMY', 'TAQBIN 马来西亚', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1852, 500, 0, 'TARRIVE', 'TARRIVE', '通达全球', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1853, 500, 0, 'TAXYDROMIKI', 'TAXYDROMIKI', 'Geniki Taxydromiki', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1854, 500, 0, 'TCAT', 'TCAT', '黑貓宅急便', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1855, 500, 0, 'TCATCN', 'TCATCN', '黑猫跨境物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1856, 500, 0, 'TDE', 'TDE', 'TDE', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1857, 500, 0, 'TDEXPRESS', 'TDEXPRESS', 'TDExpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1858, 500, 0, 'TDHY', 'TDHY', '华宇物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1859, 500, 0, 'TEAPOST', 'TEAPOST', '亚欧快运TEA', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1860, 500, 0, 'TELEPOST', 'TELEPOST', '格陵兰岛邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1861, 500, 0, 'TFORCEFINALMILE', 'TFORCEFINALMILE', 'TForceFinalMile', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1862, 500, 0, 'TFS906', 'TFS906', '天府盛', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1863, 500, 0, 'TGX', 'TGX', 'TGX精英速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1864, 500, 0, 'THAIZTO', 'THAIZTO', '泰国中通ZTO', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1865, 500, 0, 'THECOURIERGUY', 'THECOURIERGUY', 'The Courier Guy', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1866, 500, 0, 'THTX', 'THTX', '通和天下', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1867, 500, 0, 'TIKI', 'TIKI', 'Tiki', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1868, 500, 0, 'TINGHAOWL', 'TINGHAOWL', '挺好国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1869, 500, 0, 'TIPSA', 'TIPSA', 'TIPSA', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1870, 500, 0, 'TJDGJWL', 'TJDGJWL', '泰捷达物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1871, 500, 0, 'TJS', 'TJS', '特急送', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1872, 500, 0, 'TLWL', 'TLWL', '腾林物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1873, 500, 0, 'TMG', 'TMG', 'TMG', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1874, 500, 0, 'TMMEXPRESS', 'TMMEXPRESS', 'TMM Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1875, 500, 0, 'TNT', 'TNT', 'TNT快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1876, 500, 0, 'TNTAU', 'TNTAU', '澳大利亚TNT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1877, 500, 0, 'TNTCLICK', 'TNTCLICK', 'TNT Click', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1878, 500, 0, 'TNTFR', 'TNTFR', '法国TNT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1879, 500, 0, 'TNTIT', 'TNTIT', '意大利TNT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1880, 500, 0, 'TNTREFERENCE', 'TNTREFERENCE', 'TNT Reference', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1881, 500, 0, 'TNTUK', 'TNTUK', 'TNT UK', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1882, 500, 0, 'TOGOPOST', 'TOGOPOST', '多哥邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1883, 500, 0, 'TOLL', 'TOLL', 'TOLL', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1884, 500, 0, 'TOLLIPEC', 'TOLLIPEC', 'Toll IPEC', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1885, 500, 0, 'TONGAPOST', 'TONGAPOST', '汤加邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1886, 500, 0, 'TOPYOU', 'TOPYOU', '通邮国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1887, 500, 0, 'TPDEX', 'TPDEX', '德启', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1888, 500, 0, 'TRACKON', 'TRACKON', 'Trackon', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1889, 500, 0, 'TRAKPAK', 'TRAKPAK', 'TrakPak', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1890, 500, 0, 'TSSTO', 'TSSTO', '唐山申通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1891, 500, 0, 'TUFFNELLS', 'TUFFNELLS', 'tuffnells', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1892, 500, 0, 'TURTLEEXPRESS', 'TURTLEEXPRESS', '海龟国际速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1893, 500, 0, 'TUVALUPOST', 'TUVALUPOST', '图瓦卢邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1894, 500, 0, 'TWTH', 'TWTH', '拓威天海', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1895, 500, 0, 'TXWL', 'TXWL', '天玺物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1896, 500, 0, 'TYWL', 'TYWL', '通用物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1897, 500, 0, 'TZT', 'TZT', 'TZT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1898, 500, 0, 'Tianzi', 'Tianzi', 'Tianzi', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1899, 500, 0, 'Tinzung', 'Tinzung', 'Tinzung', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1900, 500, 0, 'Tonami', 'Tonami', 'Tonami', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1901, 500, 0, 'UAPEX', 'UAPEX', '全一快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1902, 500, 0, 'UBI', 'UBI', 'UBI', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1903, 500, 0, 'UBONEX', 'UBONEX', '优邦国际速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1904, 500, 0, 'UBXUK', 'UBXUK', 'UBX Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1905, 500, 0, 'UC', 'UC', '优速快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1906, 500, 0, 'UEQ', 'UEQ', 'UEQ Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1907, 500, 0, 'UEX', 'UEX', 'UEX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1908, 500, 0, 'UKMAIL', 'UKMAIL', 'UK Mail', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1909, 500, 0, 'UKRAINEEMS', 'UKRAINEEMS', '乌克兰 EMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1910, 500, 0, 'UNIEXPRESS', 'UNIEXPRESS', 'Uni Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1911, 500, 0, 'UNITEDDELIVERYSERVICE', 'UNITEDDELIVERYSERVICE', 'UnitedDeliveryService', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1912, 500, 0, 'UNLINE', 'UNLINE', 'Un-line', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1913, 500, 0, 'UPS', 'UPS', 'UPS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1914, 500, 0, 'UPSMI', 'UPSMI', 'UPS Mail Innovations', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1915, 500, 0, 'UPU', 'UPU', '万国邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1916, 500, 0, 'USEX', 'USEX', '美国快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1917, 500, 0, 'USKYEXPRESS', 'USKYEXPRESS', '全酋通Usky', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1918, 500, 0, 'USPEEDEX', 'USPEEDEX', '优时派', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1919, 500, 0, 'USPS', 'USPS', 'USPS美国邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1920, 500, 0, 'USPSINTERNATIONAL', 'USPSINTERNATIONAL', 'usps-international', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1921, 500, 0, 'UTEC', 'UTEC', 'UTEC瞬移达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1922, 500, 0, 'UVAN', 'UVAN', 'UVAN宇环通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1923, 500, 0, 'UXEXP', 'UXEXP', '邮行天下', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1924, 500, 0, 'Ukrposhta', 'Ukrposhta', 'Ukrposhta', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1925, 500, 0, 'Usky', 'Usky', 'Usky', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1926, 500, 0, 'VALUEWAY', 'VALUEWAY', '美通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1927, 500, 0, 'VANUATUPOST', 'VANUATUPOST', '瓦努阿图邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1928, 500, 0, 'VCTRANS', 'VCTRANS', '中越国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1929, 500, 0, 'VENIPAK', 'VENIPAK', 'Venipak', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1930, 500, 0, 'VENUCIA', 'VENUCIA', '启辰国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1931, 500, 0, 'VIETNAMEMS', 'VIETNAMEMS', 'VietNamEMS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1932, 500, 0, 'VIETTELPOST', 'VIETTELPOST', 'Viettel Post', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1933, 500, 0, 'VOVALOGISTICS', 'VOVALOGISTICS', 'VOVA Logistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1934, 500, 0, 'Vestovoy', 'Vestovoy', 'Vestovoy', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1935, 500, 0, 'WAHANA', 'WAHANA', 'Wahana', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1936, 500, 0, 'WANBEXPRESS', 'WANBEXPRESS', '万邦速达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1937, 500, 0, 'WEDO', 'WEDO', 'WeDo Logistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1938, 500, 0, 'WEL', 'WEL', 'WEL', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1939, 500, 0, 'WESTBANK', 'WESTBANK', 'West Bank', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1940, 500, 0, 'WEWORLDEXPRESS', 'WEWORLDEXPRESS', 'We World Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1941, 500, 0, 'WHISTL', 'WHISTL', 'Whistl', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1942, 500, 0, 'WHTEXPRESS', 'WHTEXPRESS', '五和通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1943, 500, 0, 'WHTZX', 'WHTZX', '武汉同舟行', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1944, 500, 0, 'WHXBWL', 'WHXBWL', '武汉晓毕物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1945, 500, 0, 'WINIT', 'WINIT', 'winit万邑通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1946, 500, 0, 'WINLINK', 'WINLINK', '合联国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1947, 500, 0, 'WISEEXPRESS', 'WISEEXPRESS', '万色速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1948, 500, 0, 'WISELOADS', 'WISELOADS', 'wiseloads快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1949, 500, 0, 'WISHPOST', 'WISHPOST', 'Wish邮', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1950, 500, 0, 'WJEXPRESS', 'WJEXPRESS', '文捷航空速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1951, 500, 0, 'WJK', 'WJK', '万家康', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1952, 500, 0, 'WJWL', 'WJWL', '万家物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1953, 500, 0, 'WLDEXPRESS', 'WLDEXPRESS', '万立德国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1954, 500, 0, 'WM', 'WM', '中粮我买网', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1955, 500, 0, 'WMENGSCM', 'WMENGSCM', '万盟云仓', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1956, 500, 0, 'WNDIRECT', 'WNDIRECT', 'wndirect快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1957, 500, 0, 'WPE', 'WPE', '维普恩', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1958, 500, 0, 'WSGDLOGISTICS', 'WSGDLOGISTICS', 'WSGD物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1959, 500, 0, 'WSH', 'WSH', 'WSH', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1960, 500, 0, 'WTP', 'WTP', '微特派', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1961, 500, 0, 'WTWL', 'WTWL', '温通物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1962, 500, 0, 'WWE', 'WWE', 'WWE', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1963, 500, 0, 'Wiio', 'Wiio', 'Wiio', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1964, 500, 0, 'Wing', 'Wing', 'Wing', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1965, 500, 0, 'XBWL', 'XBWL', '新邦物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1966, 500, 0, 'XCWL', 'XCWL', '迅驰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1967, 500, 0, 'XD', 'XD', '迅达国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1968, 500, 0, 'XDEXPRESS', 'XDEXPRESS', '迅达速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1969, 500, 0, 'XDPUK', 'XDPUK', 'XDP Express', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1970, 500, 0, 'XEND', 'XEND', 'Xend', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1971, 500, 0, 'XGYZ', 'XGYZ', '香港邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1972, 500, 0, 'XIAOBI', 'XIAOBI', '晓毕物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1973, 500, 0, 'XINGYUAN', 'XINGYUAN', 'XINGYUAN', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1974, 500, 0, 'XINGYUNYI', 'XINGYUNYI', '行运易', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1975, 500, 0, 'XJ', 'XJ', '新杰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1976, 500, 0, 'XKGJ', 'XKGJ', '星空国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1977, 500, 0, 'XLKD', 'XLKD', '喜来快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1978, 500, 0, 'XLOBO', 'XLOBO', '贝海国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1979, 500, 0, 'XLYT', 'XLYT', '祥龙运通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1980, 500, 0, 'XPOST', 'XPOST', 'XPOST', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1981, 500, 0, 'XPRESSBEES', 'XPRESSBEES', 'XpressBees', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1982, 500, 0, 'XPRESSPOST', 'XPRESSPOST', 'xpresspost', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1983, 500, 0, 'XQWL', 'XQWL', '星前物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1984, 500, 0, 'XRU', 'XRU', 'XRU-俄速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1985, 500, 0, 'XSRD', 'XSRD', '鑫世锐达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1986, 500, 0, 'XXDEXP', 'XXDEXP', '上海享享达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1987, 500, 0, 'XYGJ', 'XYGJ', '新元国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1988, 500, 0, 'XYGJSD', 'XYGJSD', 'ADLER雄鹰国际速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1989, 500, 0, 'XYJ', 'XYJ', '西邮寄', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1990, 500, 0, 'XYL', 'XYL', 'XYL', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1991, 500, 0, 'XYT', 'XYT', '希优特', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1992, 500, 0, 'XYY', 'XYY', 'XYY', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1993, 500, 0, 'YAD', 'YAD', '源安达快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1994, 500, 0, 'YAKIT', 'YAKIT', 'yakit快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1995, 500, 0, 'YAMATO', 'YAMATO', '日本大和运输(Yamato)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1996, 500, 0, 'YANWEN', 'YANWEN', '燕文', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1997, 500, 0, 'YBG', 'YBG', '洋包裹', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1998, 500, 0, 'YBJ', 'YBJ', '邮必佳', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (1999, 500, 0, 'YBWL', 'YBWL', '优拜物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2000, 500, 0, 'YCSY', 'YCSY', '远成快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2001, 500, 0, 'YCWL', 'YCWL', '远成物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2002, 500, 0, 'YDH', 'YDH', '义达国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2003, 500, 0, 'YDHEX', 'YDHEX', 'YDH义达物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2004, 500, 0, 'YDLYZ', 'YDLYZ', '意大利邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2005, 500, 0, 'YDMEX', 'YDMEX', '易邮通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2006, 500, 0, 'YDS', 'YDS', 'YDS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2007, 500, 0, 'YDT', 'YDT', '易达通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2008, 500, 0, 'YEEDA909', 'YEEDA909', '易达联运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2009, 500, 0, 'YF', 'YF', '耀飞快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2010, 500, 0, 'YFEX', 'YFEX', '越丰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2011, 500, 0, 'YFHEX', 'YFHEX', '原飞航物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2012, 500, 0, 'YFM', 'YFM', 'YFM', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2013, 500, 0, 'YFSD', 'YFSD', '亚风快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2014, 500, 0, 'YFSUYUN', 'YFSUYUN', '驭丰速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2015, 500, 0, 'YFZX', 'YFZX', 'YFZX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2016, 500, 0, 'YGYZ', 'YGYZ', '英国邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2017, 500, 0, 'YHA', 'YHA', 'YHA', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2018, 500, 0, 'YHT', 'YHT', '一海通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2019, 500, 0, 'YHXGJSD', 'YHXGJSD', '一号线', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2020, 500, 0, 'YIDST', 'YIDST', 'YIDST', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2021, 500, 0, 'YINYANGINC', 'YINYANGINC', '印度专线', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2022, 500, 0, 'YIYUAN56', 'YIYUAN56', '一沅国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2023, 500, 0, 'YJ', 'YJ', '友家速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2024, 500, 0, 'YJD', 'YJD', '易境达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2025, 500, 0, 'YJI', 'YJI', '延锦国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2026, 500, 0, 'YJSD', 'YJSD', '银捷速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2027, 500, 0, 'YJWL', 'YJWL', '云聚物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2028, 500, 0, 'YL', 'YL', '云路', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2029, 500, 0, 'YLDLOGISTICS', 'YLDLOGISTICS', 'YLDLogistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2030, 500, 0, 'YLFWL', 'YLFWL', '一路发物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2031, 500, 0, 'YLJY', 'YLJY', '优联吉运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2032, 500, 0, 'YLSY', 'YLSY', '亿领速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2033, 500, 0, 'YMSY', 'YMSY', '玥玛速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2034, 500, 0, 'YMWL', 'YMWL', '英脉物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2035, 500, 0, 'YMY', 'YMY', 'YMY', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2036, 500, 0, 'YODEL', 'YODEL', 'YODEL', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2037, 500, 0, 'YONAEXPRESS', 'YONAEXPRESS', 'YonaExpress', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2038, 500, 0, 'YOUBIJIA', 'YOUBIJIA', '邮必佳快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2039, 500, 0, 'YOUCWL', 'YOUCWL', '邮畅物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2040, 500, 0, 'YOUWEI', 'YOUWEI', '有为国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2041, 500, 0, 'YP56', 'YP56', '云派物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2042, 500, 0, 'YSDF', 'YSDF', '余氏东风', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2043, 500, 0, 'YSH', 'YSH', '亿顺航', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2044, 500, 0, 'YSKY', 'YSKY', '音素快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2045, 500, 0, 'YTD', 'YTD', '易通达', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2046, 500, 0, 'YTFH', 'YTFH', '一统飞鸿', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2047, 500, 0, 'YTKD', 'YTKD', '运通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2048, 500, 0, 'YTOGJ', 'YTOGJ', '圆通国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2049, 500, 0, 'YUANHAOLOGISTICS', 'YUANHAOLOGISTICS', 'YuanHao Logistics', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2050, 500, 0, 'YUDIEXP', 'YUDIEXP', '杭州宇地', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2051, 500, 0, 'YUEDANYOUZ', 'YUEDANYOUZ', '约旦邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2052, 500, 0, 'YUNDAEXUS', 'YUNDAEXUS', '云达速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2053, 500, 0, 'YUNDX', 'YUNDX', '运东西网', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2054, 500, 0, 'YUNEXPRESS', 'YUNEXPRESS', '云途物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2055, 500, 0, 'YUNLU', 'YUNLU', '云路物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2056, 500, 0, 'YUTENG', 'YUTENG', 'YUTENG', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2057, 500, 0, 'YWWL', 'YWWL', '燕文物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2058, 500, 0, 'YXKD', 'YXKD', '亿翔快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2059, 500, 0, 'YXWL', 'YXWL', '宇鑫物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2060, 500, 0, 'YYSD', 'YYSD', '鹰运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2061, 500, 0, 'YZBK', 'YZBK', '邮政国内标快', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2062, 500, 0, 'YZGN', 'YZGN', '包裹/平邮/挂号信', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2063, 500, 0, 'YZPY', 'YZPY', '邮政快递包裹', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2064, 500, 0, 'YZT', 'YZT', '一智通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2065, 500, 0, 'YZTSY', 'YZTSY', '一站通速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2066, 500, 0, 'ZAJIL', 'ZAJIL', 'Zajil快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2067, 500, 0, 'ZAMBIAPOST', 'ZAMBIAPOST', '赞比亚邮政', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2068, 500, 0, 'ZCEEXP', 'ZCEEXP', '上海翼速', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2069, 500, 0, 'ZENY', 'ZENY', '增益快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2070, 500, 0, 'ZESEXPRESS', 'ZESEXPRESS', '俄顺国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2071, 500, 0, 'ZH', 'ZH', '中驰物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2072, 500, 0, 'ZHN', 'ZHN', '智汇鸟', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2073, 500, 0, 'ZHONGHUAN', 'ZHONGHUAN', '中环快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2074, 500, 0, 'ZHONGSU', 'ZHONGSU', '中速国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2075, 500, 0, 'ZHQKD', 'ZHQKD', '汇强快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2076, 500, 0, 'ZHWL', 'ZHWL', '中骅物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2077, 500, 0, 'ZJSEXPRESS', 'ZJSEXPRESS', '宅急送快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2078, 500, 0, 'ZO', 'ZO', '中欧快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2079, 500, 0, 'ZSKY', 'ZSKY', '准实快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2080, 500, 0, 'ZT', 'ZT', 'ZT', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2081, 500, 0, 'ZTE', 'ZTE', '众通快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2082, 500, 0, 'ZTWL', 'ZTWL', '中铁物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2083, 500, 0, 'ZTWY', 'ZTWY', '中天万运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2084, 500, 0, 'ZWSY', 'ZWSY', '中外速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2085, 500, 0, 'ZWWL', 'ZWWL', '中网物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2086, 500, 0, 'ZWYSD', 'ZWYSD', '中外运速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2087, 500, 0, 'ZXG', 'ZXG', 'ZXG', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2088, 500, 0, 'ZY100', 'ZY100', '中远快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2089, 500, 0, 'ZYE', 'ZYE', '众邮快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2090, 500, 0, 'ZYKD', 'ZYKD', '中邮快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2091, 500, 0, 'ZYQS', 'ZYQS', '中运全速', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2092, 500, 0, 'ZYSFGJ', 'ZYSFGJ', '转运四方国际快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2093, 500, 0, 'ZYWL', 'ZYWL', '中邮物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2094, 500, 0, 'ZYZOOM', 'ZYZOOM', '增速海淘', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2095, 500, 0, 'ZY_AG', 'ZY_AG', '爱购转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2096, 500, 0, 'ZY_AOZ', 'ZY_AOZ', '爱欧洲', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2097, 500, 0, 'ZY_AUSE', 'ZY_AUSE', '澳世速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2098, 500, 0, 'ZY_AXO', 'ZY_AXO', 'AXO', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2099, 500, 0, 'ZY_AZY', 'ZY_AZY', '澳转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2100, 500, 0, 'ZY_BDA', 'ZY_BDA', '八达网', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2101, 500, 0, 'ZY_BEE', 'ZY_BEE', '蜜蜂速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2102, 500, 0, 'ZY_BL', 'ZY_BL', '百利快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2103, 500, 0, 'ZY_BM', 'ZY_BM', '斑马物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2104, 500, 0, 'ZY_BT', 'ZY_BT', '百通物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2105, 500, 0, 'ZY_BYECO', 'ZY_BYECO', '贝易购', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2106, 500, 0, 'ZY_CM', 'ZY_CM', '策马转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2107, 500, 0, 'ZY_CTM', 'ZY_CTM', '赤兔马转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2108, 500, 0, 'ZY_CUL', 'ZY_CUL', 'CUL中美速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2109, 500, 0, 'ZY_DGHT', 'ZY_DGHT', '德国海淘之家', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2110, 500, 0, 'ZY_DYW', 'ZY_DYW', '德运网', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2111, 500, 0, 'ZY_ESONG', 'ZY_ESONG', '宜送转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2112, 500, 0, 'ZY_ETD', 'ZY_ETD', 'ETD', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2113, 500, 0, 'ZY_FCKD', 'ZY_FCKD', '风驰快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2114, 500, 0, 'ZY_FD', 'ZY_FD', '飞碟快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2115, 500, 0, 'ZY_FG', 'ZY_FG', '飞鸽快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2116, 500, 0, 'ZY_FLSD', 'ZY_FLSD', '风雷速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2117, 500, 0, 'ZY_FX', 'ZY_FX', '风行快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2118, 500, 0, 'ZY_FXSD', 'ZY_FXSD', '风行速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2119, 500, 0, 'ZY_FY', 'ZY_FY', '飞洋快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2120, 500, 0, 'ZY_HC', 'ZY_HC', '皓晨快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2121, 500, 0, 'ZY_HCYD', 'ZY_HCYD', '皓晨优递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2122, 500, 0, 'ZY_HDB', 'ZY_HDB', '海带宝', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2123, 500, 0, 'ZY_HFMZ', 'ZY_HFMZ', '汇丰美中速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2124, 500, 0, 'ZY_HJSD', 'ZY_HJSD', '豪杰速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2125, 500, 0, 'ZY_HMKD', 'ZY_HMKD', '华美快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2126, 500, 0, 'ZY_HTAO', 'ZY_HTAO', '360hitao转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2127, 500, 0, 'ZY_HTCUN', 'ZY_HTCUN', '海淘村', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2128, 500, 0, 'ZY_HTKE', 'ZY_HTKE', '365海淘客', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2129, 500, 0, 'ZY_HTONG', 'ZY_HTONG', '华通快运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2130, 500, 0, 'ZY_HXKD', 'ZY_HXKD', '海星桥快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2131, 500, 0, 'ZY_HXSY', 'ZY_HXSY', '华兴速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2132, 500, 0, 'ZY_HYSD', 'ZY_HYSD', '海悦速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2133, 500, 0, 'ZY_IHERB', 'ZY_IHERB', 'LogisticsY', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2134, 500, 0, 'ZY_JA', 'ZY_JA', '君安快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2135, 500, 0, 'ZY_JD', 'ZY_JD', '时代转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2136, 500, 0, 'ZY_JDKD', 'ZY_JDKD', '骏达快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2137, 500, 0, 'ZY_JDZY', 'ZY_JDZY', '骏达转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2138, 500, 0, 'ZY_JH', 'ZY_JH', '久禾快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2139, 500, 0, 'ZY_JHT', 'ZY_JHT', '金海淘', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2140, 500, 0, 'ZY_LBZY', 'ZY_LBZY', '联邦转运FedRoad', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2141, 500, 0, 'ZY_LPZ', 'ZY_LPZ', '领跑者快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2142, 500, 0, 'ZY_LX', 'ZY_LX', '龙象快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2143, 500, 0, 'ZY_LZWL', 'ZY_LZWL', '量子物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2144, 500, 0, 'ZY_MBZY', 'ZY_MBZY', '明邦转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2145, 500, 0, 'ZY_MGZY', 'ZY_MGZY', '美国转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2146, 500, 0, 'ZY_MJ', 'ZY_MJ', '美嘉快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2147, 500, 0, 'ZY_MST', 'ZY_MST', '美速通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2148, 500, 0, 'ZY_MXZY', 'ZY_MXZY', '美西转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2149, 500, 0, 'ZY_MZ', 'ZY_MZ', '168 美中快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2150, 500, 0, 'ZY_OEJ', 'ZY_OEJ', '欧e捷', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2151, 500, 0, 'ZY_OZF', 'ZY_OZF', '欧洲疯', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2152, 500, 0, 'ZY_OZGO', 'ZY_OZGO', '欧洲GO', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2153, 500, 0, 'ZY_QMT', 'ZY_QMT', '全美通', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2154, 500, 0, 'ZY_QQEX', 'ZY_QQEX', 'QQ-EX', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2155, 500, 0, 'ZY_RDGJ', 'ZY_RDGJ', '润东国际快线', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2156, 500, 0, 'ZY_RT', 'ZY_RT', '瑞天快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2157, 500, 0, 'ZY_RTSD', 'ZY_RTSD', '瑞天速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2158, 500, 0, 'ZY_SCS', 'ZY_SCS', 'SCS国际物流', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2159, 500, 0, 'ZY_SDKD', 'ZY_SDKD', '速达快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2160, 500, 0, 'ZY_SFZY', 'ZY_SFZY', '四方转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2161, 500, 0, 'ZY_SOHO', 'ZY_SOHO', 'SOHO苏豪国际', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2162, 500, 0, 'ZY_SONIC', 'ZY_SONIC', 'Sonic-Ex速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2163, 500, 0, 'ZY_ST', 'ZY_ST', '上腾快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2164, 500, 0, 'ZY_TCM', 'ZY_TCM', '通诚美中快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2165, 500, 0, 'ZY_TJ', 'ZY_TJ', '天际快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2166, 500, 0, 'ZY_TM', 'ZY_TM', '天马转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2167, 500, 0, 'ZY_TN', 'ZY_TN', '滕牛快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2168, 500, 0, 'ZY_TPAK', 'ZY_TPAK', 'TrakPak', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2169, 500, 0, 'ZY_TPY', 'ZY_TPY', '太平洋快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2170, 500, 0, 'ZY_TSZ', 'ZY_TSZ', '唐三藏转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2171, 500, 0, 'ZY_TTHT', 'ZY_TTHT', '天天海淘', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2172, 500, 0, 'ZY_TWC', 'ZY_TWC', 'TWC转运世界', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2173, 500, 0, 'ZY_TX', 'ZY_TX', '同心快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2174, 500, 0, 'ZY_TY', 'ZY_TY', '天翼快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2175, 500, 0, 'ZY_TZH', 'ZY_TZH', '同舟快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2176, 500, 0, 'ZY_TZKD', 'ZY_TZKD', '天泽快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2177, 500, 0, 'ZY_UCS', 'ZY_UCS', 'UCS合众快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2178, 500, 0, 'ZY_WDCS', 'ZY_WDCS', '文达国际DCS', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2179, 500, 0, 'ZY_XC', 'ZY_XC', '星辰快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2180, 500, 0, 'ZY_XDKD', 'ZY_XDKD', '迅达快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2181, 500, 0, 'ZY_XDSY', 'ZY_XDSY', '信达速运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2182, 500, 0, 'ZY_XF', 'ZY_XF', '先锋快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2183, 500, 0, 'ZY_XGX', 'ZY_XGX', '新干线快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2184, 500, 0, 'ZY_XJ', 'ZY_XJ', '信捷转运', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2185, 500, 0, 'ZY_YGKD', 'ZY_YGKD', '优购快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2186, 500, 0, 'ZY_YJSD', 'ZY_YJSD', '友家速递(UCS)', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2187, 500, 0, 'ZY_YPW', 'ZY_YPW', '云畔网', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2188, 500, 0, 'ZY_YQ', 'ZY_YQ', '云骑快递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2189, 500, 0, 'ZY_YSSD', 'ZY_YSSD', '优晟速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2190, 500, 0, 'ZY_YSW', 'ZY_YSW', '易送网', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2191, 500, 0, 'ZY_YTUSA', 'ZY_YTUSA', '运淘美国', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2192, 500, 0, 'ZY_ZCSD', 'ZY_ZCSD', '至诚速递', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2193, 500, 0, 'ZZJH', 'ZZJH', '郑州建华', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2194, 500, 0, 'Zeleris', 'Zeleris', 'Zeleris', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2195, 500, 0, 'Zinc', 'Zinc', 'Zinc', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2196, 500, 0, 'dao', 'dao', 'dao', NULL, 0);
INSERT INTO `o_logistics_company` (`id`, `platform_id`, `shop_id`, `logistics_id`, `code`, `name`, `remark`, `status`) VALUES (2197, 500, 0, 'hq568', 'hq568', '华强物流', NULL, 0);
COMMIT;

-- ----------------------------
-- Table structure for o_order
-- ----------------------------
DROP TABLE IF EXISTS `o_order`;
CREATE TABLE `o_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单id，自增',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号（第三方平台订单号）',
  `shop_type` int NOT NULL COMMENT '店铺类型',
  `shop_id` bigint NOT NULL COMMENT '店铺ID',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单备注',
  `buyer_memo` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家留言信息',
  `seller_memo` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卖家留言信息',
  `tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `refund_status` int NOT NULL COMMENT '售后状态 1：无售后或售后关闭，2：售后处理中，3：退款中，4： 退款成功 ',
  `order_status` int NOT NULL COMMENT '订单状态0：新订单，1：待发货，2：已发货，3：已完成，11已取消；12退款中；21待付款；22锁定，29删除，101部分发货',
  `goods_amount` double DEFAULT NULL COMMENT '订单商品金额',
  `post_fee` double DEFAULT NULL COMMENT '订单运费',
  `seller_discount` double DEFAULT '0' COMMENT '商家优惠金额，单位：元',
  `platform_discount` double DEFAULT '0' COMMENT '平台优惠金额，单位：元',
  `amount` double NOT NULL COMMENT '订单实际金额',
  `payment` double DEFAULT NULL COMMENT '实付金额',
  `receiver_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人姓名',
  `receiver_mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人手机号',
  `address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人地址',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '省',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '市',
  `town` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '区',
  `order_time` datetime DEFAULT NULL COMMENT '订单时间',
  `shipper` int NOT NULL DEFAULT '0' COMMENT '发货方式 0 自己发货1联合发货2供应商发货',
  `ship_type` int NOT NULL DEFAULT '0' COMMENT '发货方式2供应商代发0仓库发货',
  `ship_status` int NOT NULL DEFAULT '0' COMMENT '发货状态 0 待发货 1 已分配供应商发货 2全部发货',
  `ship_company` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '发货快递公司',
  `ship_code` varchar(33) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货物流公司',
  `ship_time` datetime DEFAULT NULL COMMENT '发货时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '取消原因',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_sn_index` (`order_num`) USING BTREE,
  KEY `shopid_index` (`shop_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='OMS订单表';

-- ----------------------------
-- Records of o_order
-- ----------------------------
BEGIN;
INSERT INTO `o_order` (`id`, `order_num`, `shop_type`, `shop_id`, `remark`, `buyer_memo`, `seller_memo`, `tag`, `refund_status`, `order_status`, `goods_amount`, `post_fee`, `seller_discount`, `platform_discount`, `amount`, `payment`, `receiver_name`, `receiver_mobile`, `address`, `province`, `city`, `town`, `order_time`, `shipper`, `ship_type`, `ship_status`, `ship_company`, `ship_code`, `ship_time`, `create_time`, `create_by`, `update_time`, `update_by`, `cancel_reason`) VALUES (41, '250929-351611154071222', 300, 1009, NULL, '', '', NULL, 1, 2, 29.35, 0, 0, 0, 29.35, 29.35, 'a', 'a', 'a', '北京市', '市辖区', '东城区', '2025-09-29 21:22:48', 0, 2, 2, '0', NULL, NULL, '2025-10-06 17:56:31', '手动确认订单', '2025-10-08 11:42:57', '手动发货', 'aa');
COMMIT;

-- ----------------------------
-- Table structure for o_order_item
-- ----------------------------
DROP TABLE IF EXISTS `o_order_item`;
CREATE TABLE `o_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id，自增',
  `shop_id` bigint NOT NULL COMMENT '店铺ID',
  `shop_type` int NOT NULL COMMENT '店铺类型',
  `order_id` bigint NOT NULL COMMENT '订单ID（o_order外键）',
  `order_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单号（第三方平台）',
  `sub_order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '子订单号（第三方平台）',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '第三方平台skuId',
  `goods_id` bigint NOT NULL DEFAULT '0' COMMENT '商品id(o_goods外键)',
  `goods_sku_id` bigint NOT NULL DEFAULT '0' COMMENT '商品skuid(o_goods_sku外键)',
  `goods_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品标题',
  `goods_img` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品图片',
  `goods_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品编码',
  `goods_spec` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品规格',
  `sku_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品规格编码',
  `goods_price` double NOT NULL COMMENT '商品单价',
  `item_amount` double DEFAULT NULL COMMENT '子订单金额',
  `discount_amount` double DEFAULT '0' COMMENT '子订单优惠金额',
  `payment` double DEFAULT NULL COMMENT '实际支付金额',
  `quantity` int NOT NULL COMMENT '商品数量',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `refund_count` int DEFAULT '0' COMMENT '已退货数量',
  `refund_status` int DEFAULT NULL COMMENT '售后状态 1：无售后或售后关闭，2：售后处理中，3：退款中，4： 退款成功 ',
  `order_status` int DEFAULT NULL COMMENT '订单状态1：待发货，2：已发货，3：已完成，11已取消；21待付款',
  `shipper` int NOT NULL DEFAULT '0' COMMENT '发货方式 0 自己发货1联合发货2供应商发货',
  `ship_type` int NOT NULL DEFAULT '0' COMMENT '发货方式1电子面单发货2手动发货',
  `ship_status` int NOT NULL DEFAULT '0' COMMENT '发货状态 0 待发货  2全部发货',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goodId_index` (`goods_id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE,
  KEY `order_num_index` (`order_num`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='OMS订单明细表';

-- ----------------------------
-- Records of o_order_item
-- ----------------------------
BEGIN;
INSERT INTO `o_order_item` (`id`, `shop_id`, `shop_type`, `order_id`, `order_num`, `sub_order_num`, `sku_id`, `goods_id`, `goods_sku_id`, `goods_title`, `goods_img`, `goods_num`, `goods_spec`, `sku_num`, `goods_price`, `item_amount`, `discount_amount`, `payment`, `quantity`, `remark`, `refund_count`, `refund_status`, `order_status`, `shipper`, `ship_type`, `ship_status`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES (51, 1009, 300, 41, '250929-351611154071222', '250929-351611154071222-1742164849115', '1742164849115', 0, 0, 'aaaaa', 'https://img.pddpic.com/mms-material-img/2025-05-29/a3e7e689-5c30-495c-b5e0-90e38bd352b5.jpeg.a.jpeg', 'LEDDX001', '12W白光-135mm', 'LEDDX00101', 29.35, 29.35, 0, 0, 1, NULL, 0, 1, 11, 0, 2, 2, '2025-10-06 17:56:31', '手动确认订单', '2025-10-08 11:42:57', '手动发货');
COMMIT;

-- ----------------------------
-- Table structure for o_order_ship_list
-- ----------------------------
DROP TABLE IF EXISTS `o_order_ship_list`;
CREATE TABLE `o_order_ship_list` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `shop_type` int NOT NULL COMMENT '店铺类型',
  `shipper` int NOT NULL COMMENT '发货方 0 仓库发货 1 供应商发货',
  `ship_supplier_id` bigint NOT NULL DEFAULT '0' COMMENT '发货供应商ID（0自己发货）',
  `ship_supplier` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货供应商',
  `order_id` bigint DEFAULT NULL COMMENT 'erp订单id',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单编号',
  `receiver_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人姓名',
  `receiver_mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人手机号',
  `address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人地址',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '省',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '市',
  `town` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '区',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `buyer_memo` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家留言信息',
  `seller_memo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卖家留言信息',
  `ship_logistics_company` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流公司',
  `ship_logistics_company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流公司code',
  `ship_logistics_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流单号',
  `ship_status` int NOT NULL COMMENT '发货状态1：待发货，2：已发货，3已推送',
  `status` int NOT NULL COMMENT '状态0待备货1备货中2备货完成3已出库',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='发货-备货表（取号发货加入备货清单、分配供应商发货加入备货清单）';

-- ----------------------------
-- Records of o_order_ship_list
-- ----------------------------
BEGIN;
INSERT INTO `o_order_ship_list` (`id`, `shop_id`, `shop_type`, `shipper`, `ship_supplier_id`, `ship_supplier`, `order_id`, `order_num`, `receiver_name`, `receiver_mobile`, `address`, `province`, `city`, `town`, `remark`, `buyer_memo`, `seller_memo`, `ship_logistics_company`, `ship_logistics_company_code`, `ship_logistics_code`, `ship_status`, `status`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES (1, 1009, 300, 0, 0, '仓库发货', 41, '250929-351611154071222', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', '极兔快递', 'JTSD', 'JT2300994000', 2, 3, '2025-10-08 11:42:57', '手动发货', '2025-10-08 15:58:59', '发货出库');
COMMIT;

-- ----------------------------
-- Table structure for o_order_ship_list_item
-- ----------------------------
DROP TABLE IF EXISTS `o_order_ship_list_item`;
CREATE TABLE `o_order_ship_list_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `list_id` bigint NOT NULL COMMENT '外键id',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `shop_type` int NOT NULL COMMENT '店铺类型',
  `shipper` int NOT NULL DEFAULT '0' COMMENT '发货方 0 仓库发货 1 供应商发货',
  `ship_supplier_id` bigint NOT NULL DEFAULT '0' COMMENT '发货供应商ID（0自己发货）',
  `ship_supplier` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货供应商',
  `order_id` bigint DEFAULT NULL COMMENT 'erp订单id',
  `order_item_id` bigint DEFAULT NULL COMMENT 'erp订单itemid',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单编号',
  `original_sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '原始订单skuid',
  `goods_id` bigint DEFAULT '0' COMMENT 'erp系统商品id',
  `sku_id` bigint DEFAULT '0' COMMENT 'erp系统商品规格id',
  `goods_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品标题',
  `goods_img` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品图片',
  `goods_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品编码',
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品规格',
  `sku_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品规格编码',
  `quantity` int NOT NULL COMMENT '商品数量',
  `status` int NOT NULL COMMENT '状态0待备货1备货中2备货完成3已发货',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='发货-备货表（打单加入备货清单）';

-- ----------------------------
-- Records of o_order_ship_list_item
-- ----------------------------
BEGIN;
INSERT INTO `o_order_ship_list_item` (`id`, `list_id`, `shop_id`, `shop_type`, `shipper`, `ship_supplier_id`, `ship_supplier`, `order_id`, `order_item_id`, `order_num`, `original_sku_id`, `goods_id`, `sku_id`, `goods_title`, `goods_img`, `goods_num`, `sku_name`, `sku_num`, `quantity`, `status`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES (1, 1, 1009, 300, 0, 0, '仓库发货', 41, 51, '250929-351611154071222', '0', 0, 45, NULL, 'https://img.pddpic.com/mms-material-img/2025-05-29/a3e7e689-5c30-495c-b5e0-90e38bd352b5.jpeg.a.jpeg', 'LEDDX001', '12W白光-135mm', 'LEDDX00101', 1, 3, '2025-10-08 11:42:57', '手动发货', '2025-10-08 15:58:59', '备货完成');
COMMIT;

-- ----------------------------
-- Table structure for o_refund
-- ----------------------------
DROP TABLE IF EXISTS `o_refund`;
CREATE TABLE `o_refund` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `refund_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '退货单号',
  `refund_type` int DEFAULT NULL COMMENT '类型(1-售前退款 10-退货 20-换货 30-维修 40-大家电安装 50-大家电移机 60-大家电增值服务 70-上门维修 90-优鲜赔 80-补发商品 100-试用收回 11-仅退款)',
  `shop_id` bigint DEFAULT NULL COMMENT '店铺id',
  `shop_type` int DEFAULT NULL COMMENT '店铺类型',
  `order_amount` float DEFAULT NULL COMMENT '订单金额',
  `refund_fee` float NOT NULL COMMENT '退款金额',
  `refund_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退款原因',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '源订单号',
  `order_item_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '子订单号或id',
  `sku_id` bigint DEFAULT NULL COMMENT '源skuId',
  `goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `sku_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku编码',
  `has_good_return` int DEFAULT NULL COMMENT '买家是否需要退货。可选值:1(是),0(否)',
  `goods_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `goods_sku` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品sku',
  `goods_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品图片',
  `quantity` bigint DEFAULT NULL COMMENT '退货数量',
  `return_logistics_company` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退货物流公司',
  `return_logistics_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退货物流单号',
  `receive_time` datetime DEFAULT NULL COMMENT '收货时间',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  `status` int NOT NULL COMMENT '状态（10001待审核 10002等待买家退货 10003等待平台审核 10004待买家处理 10005等待卖家处理 10006等待卖家发货 14000拒绝退款 10011退款关闭 10010退款完成 10020售后成功 10021售后失败 10090退款中 10091换货成功 10092换货失败 10093维修关闭 10094维修成功 ）',
  `create_time` datetime NOT NULL COMMENT '订单创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `erp_push_status` int DEFAULT '0' COMMENT 'ERP推送状态(200成功，其他失败）',
  `erp_push_result` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ERP推送状态结果',
  `erp_push_time` datetime DEFAULT NULL COMMENT 'ERP最近推送时间',
  `has_processing` int NOT NULL DEFAULT '0' COMMENT '是否处理0未处理1已处理',
  `after_sale_id` bigint DEFAULT NULL COMMENT '处理id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='OMS售后处理表';

-- ----------------------------
-- Records of o_refund
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for o_ship_waybill
-- ----------------------------
DROP TABLE IF EXISTS `o_ship_waybill`;
CREATE TABLE `o_ship_waybill` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `shop_type` int NOT NULL COMMENT '店铺类型',
  `waybill_order_id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '电子面单订单id(仅视频号)',
  `waybill_code` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '快递单号',
  `logistics_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '快递公司编码',
  `print_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '打印数据',
  `status` int DEFAULT NULL COMMENT '状态（1已取号2已打印3已发货）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='发货-电子面单记录表（打单记录）';

-- ----------------------------
-- Records of o_ship_waybill
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for o_shipment
-- ----------------------------
DROP TABLE IF EXISTS `o_shipment`;
CREATE TABLE `o_shipment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `shop_type` int NOT NULL COMMENT '店铺类型',
  `order_id` bigint DEFAULT NULL COMMENT 'o_order表id',
  `order_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单编号',
  `order_time` datetime DEFAULT NULL COMMENT '订单时间',
  `shipper` int NOT NULL DEFAULT '0' COMMENT '发货方 0 仓库发货 1 供应商发货',
  `supplier_id` bigint NOT NULL DEFAULT '0' COMMENT '供应商ID',
  `supplier` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '供应商',
  `ship_type` int DEFAULT NULL COMMENT '发货类型（1订单发货2商品补发3商品换货）',
  `ship_company` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流公司',
  `ship_company_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '物流公司code',
  `ship_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流单号',
  `ship_fee` decimal(6,2) NOT NULL DEFAULT '0.00' COMMENT '物流费用',
  `ship_time` datetime DEFAULT NULL COMMENT '发货时间',
  `ship_operator` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货操作人',
  `ship_status` int DEFAULT NULL COMMENT '物流状态（0 待发货1已发货2已完成）',
  `package_weight` float DEFAULT NULL COMMENT '包裹重量',
  `package_length` float DEFAULT NULL COMMENT '包裹长度',
  `package_width` float DEFAULT NULL COMMENT '包裹宽度',
  `package_height` float DEFAULT NULL COMMENT '包裹高度',
  `packsge_operator` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '打包操作人',
  `packsge_time` datetime DEFAULT NULL COMMENT '打包时间',
  `packages` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '包裹内容JSON',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `update_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `order_id_index` (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='发货记录表';

-- ----------------------------
-- Records of o_shipment
-- ----------------------------
BEGIN;
INSERT INTO `o_shipment` (`id`, `shop_id`, `shop_type`, `order_id`, `order_num`, `order_time`, `shipper`, `supplier_id`, `supplier`, `ship_type`, `ship_company`, `ship_company_code`, `ship_code`, `ship_fee`, `ship_time`, `ship_operator`, `ship_status`, `package_weight`, `package_length`, `package_width`, `package_height`, `packsge_operator`, `packsge_time`, `packages`, `remark`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES (1, 1009, 300, 41, '250929-351611154071222', '2025-09-29 21:22:48', 0, 0, NULL, 1, '极兔快递', 'JTSD', 'JT2300994000', 0.00, '2025-10-08 11:42:57', NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, NULL, '2025-10-08 11:42:57', 'admin', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for o_shipment_item
-- ----------------------------
DROP TABLE IF EXISTS `o_shipment_item`;
CREATE TABLE `o_shipment_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id，自增',
  `shipment_id` bigint NOT NULL COMMENT '发货id',
  `shipper` int NOT NULL COMMENT '发货方 0 仓库发货 1 供应商发货',
  `supplier_id` bigint NOT NULL DEFAULT '0' COMMENT '供应商ID',
  `supplier` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '供应商',
  `shop_type` int NOT NULL COMMENT '店铺类型',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `order_id` bigint NOT NULL COMMENT '订单 id',
  `order_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号',
  `order_time` datetime DEFAULT NULL COMMENT '订单时间',
  `order_item_id` bigint NOT NULL COMMENT '订单itemID（o_order_item外键）',
  `erp_goods_id` bigint NOT NULL DEFAULT '0' COMMENT 'erp系统商品id',
  `erp_sku_id` bigint NOT NULL DEFAULT '0' COMMENT 'erp系统商品规格id',
  `goods_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品标题',
  `goods_img` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品图片',
  `goods_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品编码',
  `goods_spec` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品规格',
  `sku_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品规格编码',
  `quantity` int NOT NULL COMMENT '商品数量',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `stock_status` int NOT NULL COMMENT '仓库状态 0 备货中 1 已出库 2 已发走',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goodId_index` (`erp_goods_id`) USING BTREE,
  KEY `order_id` (`order_item_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='发货明细表';

-- ----------------------------
-- Records of o_shipment_item
-- ----------------------------
BEGIN;
INSERT INTO `o_shipment_item` (`id`, `shipment_id`, `shipper`, `supplier_id`, `supplier`, `shop_type`, `shop_id`, `order_id`, `order_num`, `order_time`, `order_item_id`, `erp_goods_id`, `erp_sku_id`, `goods_title`, `goods_img`, `goods_num`, `goods_spec`, `sku_num`, `quantity`, `remark`, `stock_status`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES (1, 1, 0, 0, NULL, 300, 1009, 41, '250929-351611154071222', '2025-09-29 21:22:48', 51, 0, 0, NULL, 'https://img.pddpic.com/mms-material-img/2025-05-29/a3e7e689-5c30-495c-b5e0-90e38bd352b5.jpeg.a.jpeg', 'LEDDX001', '12W白光-135mm', 'LEDDX00101', 1, NULL, 0, '2025-10-08 11:42:57', 'admin', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for o_shop
-- ----------------------------
DROP TABLE IF EXISTS `o_shop`;
CREATE TABLE `o_shop` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '店铺名',
  `type` int NOT NULL COMMENT '对应第三方平台Id',
  `url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '店铺url',
  `sort` int NOT NULL DEFAULT '9' COMMENT '排序',
  `status` int DEFAULT '0' COMMENT '状态（1正常2已删除）',
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '描述',
  `seller_id` bigint NOT NULL DEFAULT '0' COMMENT '第三方平台店铺id，淘宝天猫开放平台使用',
  `app_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Appkey',
  `app_secret` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Appsercet',
  `access_token` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '第三方平台sessionKey（access_token）',
  `expires_in` bigint DEFAULT NULL COMMENT '到期',
  `access_token_begin` bigint DEFAULT NULL COMMENT 'access_token开始时间',
  `refresh_token` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '刷新token',
  `refresh_token_timeout` bigint DEFAULT NULL COMMENT '刷新token过期时间',
  `api_request_url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '请求url',
  `api_redirect_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '回调url',
  `manage_user_id` bigint DEFAULT NULL COMMENT '负责人id',
  `manage_dept_id` bigint DEFAULT NULL COMMENT '负责人部门id',
  `region_id` bigint NOT NULL DEFAULT '0' COMMENT '国家/地区',
  `modify_on` bigint NOT NULL COMMENT '更新时间',
  `create_on` bigint NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1013 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='店铺表';

-- ----------------------------
-- Records of o_shop
-- ----------------------------
BEGIN;
INSERT INTO `o_shop` (`id`, `name`, `type`, `url`, `sort`, `status`, `remark`, `seller_id`, `app_key`, `app_secret`, `access_token`, `expires_in`, `access_token_begin`, `refresh_token`, `refresh_token_timeout`, `api_request_url`, `api_redirect_url`, `manage_user_id`, `manage_dept_id`, `region_id`, `modify_on`, `create_on`) VALUES (1009, '爱顾家的小店', 300, NULL, 9, 1, NULL, 0, NULL, NULL, 'bc281984af944caf8f312b6b07429ced19493bf8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1768885419, 1759287857);
INSERT INTO `o_shop` (`id`, `name`, `type`, `url`, `sort`, `status`, `remark`, `seller_id`, `app_key`, `app_secret`, `access_token`, `expires_in`, `access_token_begin`, `refresh_token`, `refresh_token_timeout`, `api_request_url`, `api_redirect_url`, `manage_user_id`, `manage_dept_id`, `region_id`, `modify_on`, `create_on`) VALUES (1010, '抖店测试', 400, NULL, 9, 1, NULL, 4463798, NULL, NULL, 'qoc461fha31h7zl69zjws9900002noae-11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1759965958, 1759965958);
INSERT INTO `o_shop` (`id`, `name`, `type`, `url`, `sort`, `status`, `remark`, `seller_id`, `app_key`, `app_secret`, `access_token`, `expires_in`, `access_token_begin`, `refresh_token`, `refresh_token_timeout`, `api_request_url`, `api_redirect_url`, `manage_user_id`, `manage_dept_id`, `region_id`, `modify_on`, `create_on`) VALUES (1011, '淘宝测试', 100, NULL, 9, 1, NULL, 11, NULL, NULL, 'aa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1759972091, 1759972091);
INSERT INTO `o_shop` (`id`, `name`, `type`, `url`, `sort`, `status`, `remark`, `seller_id`, `app_key`, `app_secret`, `access_token`, `expires_in`, `access_token_begin`, `refresh_token`, `refresh_token_timeout`, `api_request_url`, `api_redirect_url`, `manage_user_id`, `manage_dept_id`, `region_id`, `modify_on`, `create_on`) VALUES (1012, '微信小店测试', 500, NULL, 9, 1, NULL, 0, 'wx82dd65f284dd6ee3', 'a6054ccf2694e8dc51d2616e634cad39', '100_qp1j4CQuM-ag1LgfkaAE_DCvbo4bzghkloSF_gkh--MpCEYMUs2iZmAcEMNcVzU6XDYaersdCSrW2vbjiKu1HlvaqYQvqm24aTss9L39_WNljKTT0ZOvWrNaafMSJAaACACTK', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1759974308, 1759974152);
COMMIT;

-- ----------------------------
-- Table structure for o_shop_daily
-- ----------------------------
DROP TABLE IF EXISTS `o_shop_daily`;
CREATE TABLE `o_shop_daily` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL COMMENT '报表日期',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `platform_id` bigint NOT NULL COMMENT '平台id',
  `region_id` bigint NOT NULL COMMENT '国家/地区',
  `order_total` int NOT NULL COMMENT '订单总数',
  `order_amount` decimal(10,2) NOT NULL COMMENT '订单总金额（当前货币）',
  `false_order_total` int NOT NULL COMMENT '刷单数量',
  `false_order_amount` decimal(10,2) NOT NULL COMMENT '刷单金额（当前货币）',
  `false_order_amount1` decimal(10,2) DEFAULT NULL COMMENT '刷单金额（人民币）',
  `true_order_total` int NOT NULL COMMENT '真实订单数',
  `true_order_amount` decimal(10,2) NOT NULL COMMENT '真实订单金额（当前货币）',
  `ad_fee` decimal(10,2) NOT NULL COMMENT '广告支出',
  `ad_click` int NOT NULL COMMENT '广告点击',
  `ad_click_fee` decimal(10,2) NOT NULL COMMENT '广告点击成本',
  `ad_roi` decimal(10,2) NOT NULL COMMENT 'ROI',
  `unit_price` decimal(10,2) NOT NULL COMMENT '平均客单价',
  `withdrawal_amount` decimal(10,2) DEFAULT NULL COMMENT '提现金额（当前货币）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='店铺日报';

-- ----------------------------
-- Records of o_shop_daily
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for o_shop_daily_detail
-- ----------------------------
DROP TABLE IF EXISTS `o_shop_daily_detail`;
CREATE TABLE `o_shop_daily_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `daily_id` bigint NOT NULL COMMENT '日报id',
  `date` date NOT NULL COMMENT '报表日期',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `platform_id` bigint NOT NULL COMMENT '平台id',
  `region_id` bigint NOT NULL COMMENT '国家/地区',
  `sku_id` bigint NOT NULL COMMENT 'sku id',
  `sku_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku编码',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '产品名称',
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku名称',
  `order_total` int NOT NULL COMMENT '订单总数',
  `order_amount` decimal(10,2) NOT NULL COMMENT '订单总金额（当前货币）',
  `false_order_total` int NOT NULL COMMENT '刷单数量',
  `false_order_amount` decimal(10,2) DEFAULT NULL COMMENT '刷单金额（当前货币）',
  `false_order_amount1` decimal(10,2) DEFAULT NULL COMMENT '刷单金额（人民币，包含服务费）',
  `true_order_total` int DEFAULT NULL COMMENT '真实订单数',
  `true_order_amount` decimal(10,2) DEFAULT NULL COMMENT '真实订单金额（当前货币）',
  `ad_fee` decimal(10,2) NOT NULL COMMENT '广告支出',
  `ad_click` int NOT NULL COMMENT '广告点击',
  `ad_click_fee` decimal(10,2) DEFAULT NULL COMMENT '广告点击成本',
  `ad_roi` decimal(10,2) DEFAULT NULL COMMENT 'ROI',
  `unit_price` decimal(10,2) DEFAULT NULL COMMENT '平均客单价',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='店铺日报明细（sku级别）';

-- ----------------------------
-- Records of o_shop_daily_detail
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for o_shop_platform
-- ----------------------------
DROP TABLE IF EXISTS `o_shop_platform`;
CREATE TABLE `o_shop_platform` (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '平台名',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '平台编码',
  `app_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `app_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `redirect_uri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '平台回调uri',
  `server_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '接口访问地址',
  `status` int DEFAULT NULL COMMENT '状态（0启用1关闭）',
  `sort` int DEFAULT '0' COMMENT '排序',
  `region_id` bigint DEFAULT NULL COMMENT '国家/地区',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='店铺平台配置表';

-- ----------------------------
-- Records of o_shop_platform
-- ----------------------------
BEGIN;
INSERT INTO `o_shop_platform` (`id`, `name`, `code`, `app_key`, `app_secret`, `redirect_uri`, `server_url`, `status`, `sort`, `region_id`) VALUES (100, '淘宝天猫', 'TMALL', '', '', 'https://www.qihangerp.cn', 'http://gw.api.taobao.com/router/rest', 0, 0, 1);
INSERT INTO `o_shop_platform` (`id`, `name`, `code`, `app_key`, `app_secret`, `redirect_uri`, `server_url`, `status`, `sort`, `region_id`) VALUES (200, '京东POP', 'JD-POP', '', NULL, 'http://www.qihangerp.cn', 'https://api.jd.com/routerjson', 0, 0, 1);
INSERT INTO `o_shop_platform` (`id`, `name`, `code`, `app_key`, `app_secret`, `redirect_uri`, `server_url`, `status`, `sort`, `region_id`) VALUES (300, '拼多多', 'PDD', 'dc953bcf16d24b27abf3e64a59e1ecd1', '89c639b1ceaf8e5260acc73b2bdbb5c529cf23a4', 'https://qihangerp.cn', 'https://gw-api.pinduoduo.com/api/router', 0, 9, 1);
INSERT INTO `o_shop_platform` (`id`, `name`, `code`, `app_key`, `app_secret`, `redirect_uri`, `server_url`, `status`, `sort`, `region_id`) VALUES (400, '抖店', 'DOUDIAN', '7005157746437834253', '8104c8b8-9085-4a80-9248-629759b4f1a3', 'http://www.qihangerp.cn', 'https://openapi-fxg.jinritemai.com/', 0, 8, 1);
INSERT INTO `o_shop_platform` (`id`, `name`, `code`, `app_key`, `app_secret`, `redirect_uri`, `server_url`, `status`, `sort`, `region_id`) VALUES (500, '微信小店', 'WEISHOP', '', NULL, 'http://www.qihangerp.cn', 'https://api.weixin.qq.com', 0, 7, 1);
INSERT INTO `o_shop_platform` (`id`, `name`, `code`, `app_key`, `app_secret`, `redirect_uri`, `server_url`, `status`, `sort`, `region_id`) VALUES (999, '其他渠道', 'OFFLINE', NULL, NULL, NULL, NULL, 1, 0, 1);
COMMIT;

-- ----------------------------
-- Table structure for o_shop_pull_lasttime
-- ----------------------------
DROP TABLE IF EXISTS `o_shop_pull_lasttime`;
CREATE TABLE `o_shop_pull_lasttime` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint DEFAULT NULL COMMENT '店铺id',
  `pull_type` enum('ORDER','REFUND','GOODS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型（ORDER:订单，REFUND:退款）',
  `lasttime` datetime DEFAULT NULL COMMENT '最后更新时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='店铺更新最后时间记录';

-- ----------------------------
-- Records of o_shop_pull_lasttime
-- ----------------------------
BEGIN;
INSERT INTO `o_shop_pull_lasttime` (`id`, `shop_id`, `pull_type`, `lasttime`, `create_time`, `update_time`) VALUES (1, 1007, 'ORDER', '2025-10-01 16:10:02', '2025-10-01 10:56:27', '2025-10-01 16:10:03');
INSERT INTO `o_shop_pull_lasttime` (`id`, `shop_id`, `pull_type`, `lasttime`, `create_time`, `update_time`) VALUES (2, 1007, 'GOODS', '2025-10-01 10:50:36', '2025-10-01 10:50:11', '2025-10-01 10:51:00');
INSERT INTO `o_shop_pull_lasttime` (`id`, `shop_id`, `pull_type`, `lasttime`, `create_time`, `update_time`) VALUES (3, 1009, 'ORDER', '2025-10-08 17:37:51', '2025-10-01 11:07:23', '2025-10-08 17:37:51');
INSERT INTO `o_shop_pull_lasttime` (`id`, `shop_id`, `pull_type`, `lasttime`, `create_time`, `update_time`) VALUES (4, 1009, 'GOODS', '2025-10-01 12:56:14', '2025-10-01 11:07:08', '2025-10-01 12:56:16');
INSERT INTO `o_shop_pull_lasttime` (`id`, `shop_id`, `pull_type`, `lasttime`, `create_time`, `update_time`) VALUES (5, 1007, 'REFUND', '2025-10-01 11:24:50', '2025-10-01 11:24:04', '2025-10-01 11:24:50');
INSERT INTO `o_shop_pull_lasttime` (`id`, `shop_id`, `pull_type`, `lasttime`, `create_time`, `update_time`) VALUES (6, 1010, 'ORDER', '2025-10-09 07:36:05', '2025-10-09 07:36:09', NULL);
COMMIT;

-- ----------------------------
-- Table structure for o_shop_pull_logs
-- ----------------------------
DROP TABLE IF EXISTS `o_shop_pull_logs`;
CREATE TABLE `o_shop_pull_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `shop_id` int DEFAULT NULL COMMENT '店铺id',
  `shop_type` int NOT NULL COMMENT '平台id',
  `pull_type` enum('ORDER','REFUND','GOODS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型（ORDER订单，GOODS商品，REFUND退款）',
  `pull_way` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '拉取方式（主动拉取、定时任务）',
  `pull_params` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '拉取参数',
  `pull_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '拉取结果',
  `pull_time` datetime DEFAULT NULL COMMENT '拉取时间',
  `duration` bigint DEFAULT NULL COMMENT '耗时（毫秒）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2013566020223893506 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='店铺更新日志表';

-- ----------------------------
-- Records of o_shop_pull_logs
-- ----------------------------
BEGIN;
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973218858452750338, 1007, 100, 'GOODS', '主动拉取', '{PageNo:1,PageSize:100}', '{successTotal:119}', '2025-10-01 10:49:47', 23913);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973219062555971585, 1007, 100, 'GOODS', '主动拉取', '{PageNo:1,PageSize:100}', '{successTotal:119}', '2025-10-01 10:50:36', 24238);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973220434047229954, 1007, 100, 'ORDER', '主动拉取', '{startTime:2025-09-30T10:56:20,endTime:2025-10-01T10:56:20}', '{insert:40,update:0,fail:0}', '2025-10-01 10:56:21', 5835);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973223120834486273, 1009, 300, 'GOODS', '主动拉取商品sku', '{startTime:null,endTime:null}', '{successTotal:10}', '2025-10-01 11:07:06', 977);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973223185800060930, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-30T11:07:22.693461,endTime:2025-10-01T11:07:22.693461}', '{insert:0,update:0,fail:0}', '2025-10-01 11:07:23', 181);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973224217523351554, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-28T10:07:23,endTime:2025-09-29T10:07:23}', '{insert:0,update:0,fail:0}', '2025-10-01 11:11:28', 843);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973224244010381314, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-29T09:07:23,endTime:2025-09-30T09:07:23}', '{insert:0,update:0,fail:2}', '2025-10-01 11:11:35', 218);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973224275601879041, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-29T09:07:23,endTime:2025-09-30T09:07:23}', '{insert:0,update:0,fail:2}', '2025-10-01 11:11:42', 210);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973224605026709505, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-28T09:07:23,endTime:2025-09-29T09:07:23}', '{insert:0,update:0,fail:0}', '2025-10-01 11:12:34', 26944);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973225223619440641, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-29T08:07:23,endTime:2025-09-30T08:07:23}', '{insert:0,update:0,fail:2}', '2025-10-01 11:13:48', 101206);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973225403668328450, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-29T08:07:23,endTime:2025-09-30T08:07:23}', '{insert:0,update:0,fail:2}', '2025-10-01 11:15:31', 40436);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973226544598675457, 1009, 300, 'GOODS', '主动拉取商品sku', '{startTime:2025-09-24T11:07:08,endTime:2025-10-01T11:20:41.946310900}', '{successTotal:10}', '2025-10-01 11:20:42', 1730);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973227309039939586, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-29T08:07:23,endTime:2025-09-30T08:07:23}', '{insert:2,update:0,fail:0}', '2025-10-01 11:23:42', 3541);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973227384306724865, 1007, 100, 'REFUND', '主动拉取', '{startTime:2025-09-30T11:24:03.025533400,endTime:2025-10-01T11:24:03.025533400}', '{insert:4,update:0,fail:0}', '2025-10-01 11:24:03', 849);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973227551042891778, 1007, 100, 'REFUND', '主动拉取', '{startTime:2025-10-01T10:24:03,endTime:2025-10-01T11:24:43.246316700}', '{insert:0,update:1,fail:0}', '2025-10-01 11:24:43', 402);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973227577492172802, 1007, 100, 'REFUND', '主动拉取', '{startTime:2025-10-01T10:24:43,endTime:2025-10-01T11:24:49.599735900}', '{insert:0,update:1,fail:0}', '2025-10-01 11:24:50', 345);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973228990511247361, 1009, 400, 'REFUND', '主动拉取退款', '{startTime:2025-10-01T11:00:26.567753200,endTime:2025-10-01T11:30:26.567753200}', '结束时间和开始时间范围太大，请缩小范围', '2025-10-01 11:30:27', 254);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973250539771449345, 1009, 300, 'GOODS', '主动拉取商品sku', '{startTime:2025-09-24T11:20:42,endTime:2025-10-01T12:56:02.568389800}', '{successTotal:10}', '2025-10-01 12:56:03', 2003);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973250585430642689, 1009, 300, 'GOODS', '主动拉取商品sku', '{startTime:2025-09-24T12:56:03,endTime:2025-10-01T12:56:14.013894300}', '{successTotal:10}', '2025-10-01 12:56:14', 1448);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973295260355104769, 1007, 100, 'ORDER', '主动拉取', '{startTime:2025-10-01T09:56:21,endTime:2025-10-01T15:53:44}', '{insert:12,update:0,fail:0}', '2025-10-01 15:53:44', 2336);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973295330425147393, 1007, 100, 'ORDER', '主动拉取', '{startTime:2025-10-01T14:53:45,endTime:2025-10-01T15:54:02}', '{insert:0,update:4,fail:0}', '2025-10-01 15:54:03', 660);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973299108058533890, 1007, 100, 'ORDER', '主动拉取', '{startTime:2025-10-01T14:54:03,endTime:2025-10-01T16:09:03}', '{insert:4,update:0,fail:0}', '2025-10-01 16:09:03', 705);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1973299356768198657, 1007, 100, 'ORDER', '主动拉取', '{startTime:2025-10-01T15:09:03,endTime:2025-10-01T16:10:02}', '{insert:4,update:0,fail:0}', '2025-10-01 16:10:02', 1358);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1975855874687467522, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-09-30T07:07:23,endTime:2025-10-01T07:07:23}', '{insert:0,update:0,fail:0}', '2025-10-08 17:28:45', 214);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1975855892085440513, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-10-01T06:07:23,endTime:2025-10-02T06:07:23}', '{insert:2,update:0,fail:0}', '2025-10-08 17:28:49', 303);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1975856206620491777, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-10-02T05:07:23,endTime:2025-10-03T05:07:23}', '{insert:0,update:0,fail:0}', '2025-10-08 17:29:23', 40239);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1975856594367086594, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-10-04T03:07:23,endTime:2025-10-05T03:07:23}', '{insert:0,update:0,fail:0}', '2025-10-08 17:31:13', 23246);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1975856682632019969, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-10-05T02:07:23,endTime:2025-10-06T02:07:23}', '{insert:0,update:0,fail:0}', '2025-10-08 17:31:51', 6388);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1975856705180598273, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-10-06T01:07:23,endTime:2025-10-07T01:07:23}', '{insert:1,update:0,fail:0}', '2025-10-08 17:32:03', 285);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1975858067796709378, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-10-07T00:07:23,endTime:2025-10-08T00:07:23}', '{insert:1,update:1,fail:0}', '2025-10-08 17:37:27', 777);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1975858165750484994, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2025-10-07T23:07:23,endTime:2025-10-08T17:37:50.618442500}', '{insert:1,update:0,fail:0}', '2025-10-08 17:37:51', 444);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (1976069131025027074, 1010, 400, 'ORDER', '主动拉取订单', '{startTime:2025-10-08T07:36:05.496916700,endTime:2025-10-09T07:36:05.496916700}', '{insert:20,update:0,fail:0}', '2025-10-09 07:36:05', 3906);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (2013477343191834626, 1009, 400, 'ORDER', '主动拉取订单', '{startTime:2026-01-01 00:00:01,endTime:2026-01-01 23:59:59}', 'access_token已过期', '2026-01-20 13:03:02', 338);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (2013477542320611330, 1009, 300, 'ORDER', '主动拉取订单', '{startTime:2026-01-01 00:00:01,endTime:2026-01-01 23:59:59}', '{insert:2,update:0,fail:0}', '2026-01-20 13:03:49', 231);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (2013479078069215233, 1010, 400, 'ORDER', '主动拉取订单', '{startTime:2025-10-09T06:36:05,endTime:2025-10-10T06:36:05}', '请求API错误：access_token不存在，请使用最新的access_token访问', '2026-01-20 13:09:55', 270);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (2013479197883703298, 1010, 400, 'ORDER', '主动拉取订单', '{startTime:2025-10-09T06:36:05,endTime:2025-10-10T06:36:05}', '请求API错误：access_token不存在，请使用最新的access_token访问', '2026-01-20 13:10:24', 96);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (2013479502939627521, 1010, 400, 'ORDER', '主动拉取订单', '{startTime:2025-10-09T06:36:05,endTime:2025-10-10T06:36:05}', '请求API错误：access_token不存在，请使用最新的access_token访问', '2026-01-20 13:11:03', 33617);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (2013479724101083138, 1010, 400, 'ORDER', '主动拉取订单', '{startTime:2025-10-09T06:36:05,endTime:2025-10-10T06:36:05}', '请求API错误：access_token不存在，请使用最新的access_token访问', '2026-01-20 13:11:41', 48517);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (2013480573313454082, 1010, 400, 'ORDER', '主动拉取订单', '{startTime:2025-10-09T06:36:05,endTime:2025-10-10T06:36:05}', 'access_token不存在，请使用最新的access_token访问', '2026-01-20 13:15:45', 7268);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (2013480920102723586, 1010, 400, 'ORDER', '主动拉取订单', '{startTime:2025-10-09T06:36:05,endTime:2025-10-10T06:36:05}', 'access_token不存在，请使用最新的access_token访问', '2026-01-20 13:17:15', 146);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (2013481459200811010, 1010, 400, 'ORDER', '主动拉取订单', '{startTime:2025-10-09T06:36:05,endTime:2025-10-10T06:36:05}', 'access_token不存在，请使用最新的access_token访问', '2026-01-20 13:19:23', 112);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (2013484768330444802, 1010, 400, 'ORDER', '主动拉取订单', '{startTime:2025-10-09T06:36:05,endTime:2025-10-10T06:36:05}', 'access_token不存在，请使用最新的access_token访问', '2026-01-20 13:32:32', 117);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (2013485977938313218, 1010, 400, 'ORDER', '主动拉取订单', '{startTime:2025-10-09T06:36:05,endTime:2025-10-10T06:36:05}', 'access_token不存在，请使用最新的access_token访问', '2026-01-20 13:37:20', 224);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (2013551545504747522, 1012, 500, 'ORDER', '主动拉取订单', '{startTime:2026-01-01 00:00:01,endTime:2026-01-01 23:59:59}', '{insert:0,update:0,fail:0}', '2026-01-20 17:57:52', 847);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (2013565297398632449, 1012, 500, 'ORDER', '主动拉取订单', '{startTime:2025-11-03 00:00:01,endTime:2025-11-03 23:59:59}', '{insert:5,update:0,fail:0}', '2026-01-20 18:52:28', 3886);
INSERT INTO `o_shop_pull_logs` (`id`, `shop_id`, `shop_type`, `pull_type`, `pull_way`, `pull_params`, `pull_result`, `pull_time`, `duration`) VALUES (2013566020223893505, 1012, 500, 'ORDER', '主动拉取订单', '{startTime:2025-11-03 00:00:01,endTime:2025-11-03 23:59:59}', '{insert:5,update:0,fail:0}', '2026-01-20 18:55:21', 3536);
COMMIT;

-- ----------------------------
-- Table structure for o_shop_region
-- ----------------------------
DROP TABLE IF EXISTS `o_shop_region`;
CREATE TABLE `o_shop_region` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '地区名称',
  `exchange_rate` float DEFAULT NULL COMMENT '汇率',
  `num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '地区编码',
  `status` int DEFAULT NULL COMMENT '状态0正常1禁用',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='店铺地区表';

-- ----------------------------
-- Records of o_shop_region
-- ----------------------------
BEGIN;
INSERT INTO `o_shop_region` (`id`, `name`, `exchange_rate`, `num`, `status`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES (1, '中国', 1, '86', 0, '2025-02-10 10:42:54', 'system', '2025-02-10 10:42:57', NULL);
COMMIT;

-- ----------------------------
-- Table structure for offline_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `offline_goods_sku`;
CREATE TABLE `offline_goods_sku` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键sku id',
  `o_goods_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `shop_id` bigint DEFAULT NULL COMMENT '店铺id',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名',
  `sku_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '规格名',
  `sku_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规格编码',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '第三方平台skuId',
  `color_id` bigint DEFAULT '0' COMMENT '颜色id',
  `color_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '颜色值',
  `color_image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '颜色图片',
  `size_id` bigint DEFAULT '0' COMMENT '尺码id',
  `size_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '尺码值(材质)',
  `style_id` bigint DEFAULT '0' COMMENT '款式id',
  `style_value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '款式值',
  `bar_code` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '库存条形码',
  `sale_price` decimal(8,2) DEFAULT '0.00' COMMENT '售价',
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `sku_id_unique` (`o_goods_sku_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `number` (`sku_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='OMS商品SKU表';

-- ----------------------------
-- Records of offline_goods_sku
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for offline_order
-- ----------------------------
DROP TABLE IF EXISTS `offline_order`;
CREATE TABLE `offline_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单id，自增',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号（第三方平台订单号）',
  `shop_id` bigint NOT NULL COMMENT '店铺ID',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单备注',
  `buyer_memo` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家留言信息',
  `seller_memo` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卖家留言信息',
  `tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `refund_status` int NOT NULL COMMENT '售后状态 1：无售后或售后关闭，2：售后处理中，3：退款中，4： 退款成功 ',
  `order_status` int NOT NULL COMMENT '订单状态0：新订单，1：待发货，2：已发货，3：已完成，11已取消；12退款中；21待付款；22锁定，29删除，101部分发货',
  `goods_amount` double DEFAULT NULL COMMENT '订单商品金额',
  `post_fee` double DEFAULT NULL COMMENT '订单运费',
  `amount` double NOT NULL COMMENT '订单实际金额',
  `seller_discount` double DEFAULT '0' COMMENT '商家优惠金额，单位：元',
  `platform_discount` double DEFAULT '0' COMMENT '平台优惠金额，单位：元',
  `payment` double DEFAULT NULL COMMENT '实付金额',
  `receiver_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人姓名',
  `receiver_mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人手机号',
  `address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人地址',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '省',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '市',
  `town` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '区',
  `order_time` datetime DEFAULT NULL COMMENT '订单时间',
  `ship_type` int NOT NULL COMMENT '发货类型（0仓库发货；1供应商代发）',
  `shipping_time` datetime DEFAULT NULL COMMENT '发货时间',
  `shipping_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '快递单号',
  `shipping_company` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流公司',
  `shipping_man` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货人',
  `shipping_cost` decimal(10,2) DEFAULT NULL COMMENT '发货费用',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `oms_push_status` int DEFAULT '0' COMMENT 'OMS推送状态(1已推送0未推送）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_sn_index` (`order_num`) USING BTREE,
  KEY `shopid_index` (`shop_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='线下渠道订单表';

-- ----------------------------
-- Records of offline_order
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for offline_order_item
-- ----------------------------
DROP TABLE IF EXISTS `offline_order_item`;
CREATE TABLE `offline_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id，自增',
  `order_id` bigint NOT NULL COMMENT '订单ID（o_order外键）',
  `order_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单号（第三方平台）',
  `sub_order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '子订单号（第三方平台）',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '第三方平台skuId',
  `goods_id` bigint NOT NULL DEFAULT '0' COMMENT '商品id(o_goods外键)',
  `goods_sku_id` bigint NOT NULL DEFAULT '0' COMMENT '商品skuid(o_goods_sku外键)',
  `goods_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品标题',
  `goods_img` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品图片',
  `goods_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品编码',
  `goods_spec` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品规格',
  `sku_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品规格编码',
  `goods_price` double NOT NULL COMMENT '商品单价',
  `item_amount` double DEFAULT NULL COMMENT '子订单金额',
  `payment` double DEFAULT NULL COMMENT '实际支付金额',
  `quantity` int NOT NULL COMMENT '商品数量',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `refund_count` int DEFAULT '0' COMMENT '已退货数量',
  `refund_status` int DEFAULT NULL COMMENT '售后状态 1：无售后或售后关闭，2：售后处理中，3：退款中，4： 退款成功 ',
  `order_status` int DEFAULT NULL COMMENT '订单状态1：待发货，2：已发货，3：已完成，11已取消；21待付款',
  `has_push_erp` int DEFAULT '0' COMMENT '是否推送到ERP',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goodId_index` (`goods_id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='渠道订单明细表';

-- ----------------------------
-- Records of offline_order_item
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for offline_refund
-- ----------------------------
DROP TABLE IF EXISTS `offline_refund`;
CREATE TABLE `offline_refund` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `type` int NOT NULL COMMENT '类型（10退货退款；11仅退款；20换货；）',
  `shop_id` int NOT NULL COMMENT '店铺id',
  `refund_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '退款单号',
  `order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `order_item_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '子订单号',
  `order_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单id',
  `status` int DEFAULT NULL COMMENT '状态（10005等待卖家处理 10006等待卖家发货 10011退款关闭 10010退款完成 10020售后成功 10021售后失败 10090退款中 10091换货成功 10092换货失败 ）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `update_by` datetime DEFAULT NULL,
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '第三方平台skuId',
  `goods_id` bigint NOT NULL DEFAULT '0' COMMENT '商品id(o_goods外键)',
  `goods_sku_id` bigint NOT NULL DEFAULT '0' COMMENT '商品skuid(o_goods_sku外键)',
  `goods_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品标题',
  `goods_img` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品图片',
  `goods_num` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品编码',
  `goods_spec` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品规格',
  `sku_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品规格编码',
  `item_amount` double DEFAULT NULL COMMENT '子订单金额',
  `refund_fee` float NOT NULL COMMENT '退款金额',
  `has_good_return` int NOT NULL COMMENT '买家是否需要退货。可选值:1(是),0(否)',
  `refund_quantity` bigint NOT NULL COMMENT '退货数量',
  `return_logistics_company` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退货物流公司',
  `return_logistics_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退货物流单号',
  `receive_time` datetime DEFAULT NULL COMMENT '收货时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='线下渠道退款表';

-- ----------------------------
-- Records of offline_refund
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_dou_goods
-- ----------------------------
DROP TABLE IF EXISTS `oms_dou_goods`;
CREATE TABLE `oms_dou_goods` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint DEFAULT NULL COMMENT '店铺id',
  `product_id` bigint DEFAULT NULL COMMENT '商品ID，抖店系统生成，店铺下唯一',
  `product_type` int DEFAULT NULL COMMENT '商品类型；0-普通；1-新客商品；3-虚拟；6-玉石闪购；7-云闪购 ；127-其他类型；',
  `name` varchar(85) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品标题。',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品主图的第一张图',
  `check_status` int DEFAULT NULL COMMENT '商品审核状态: 1-未提交；2-待审核；3-审核通过；4-审核未通过；5-封禁；7-审核通过待上架；',
  `market_price` bigint DEFAULT NULL,
  `discount_price` bigint DEFAULT NULL,
  `status` int DEFAULT NULL COMMENT '商品在店铺中状态: 0-在线；1-下线；2-删除；',
  `spec_id` bigint DEFAULT NULL COMMENT '商品规格，全局唯一',
  `create_time` int DEFAULT NULL COMMENT '商品创建时间，unix时间戳，单位：秒；',
  `update_time` int DEFAULT NULL COMMENT '商品更新时间，unix时间戳，单位：秒；',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '商品详情，最大支持50张图片，单张详情图宽高比不超2000*2000px，大小5M内，仅支持jpg/jpeg/png格式；',
  `category_detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '类目详情；商品类目id可使用【/shop/getShopCategory】查询',
  `outer_product_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '外部商家编码，商家自定义字段，支持最多 255个字符',
  `is_package_product` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否是组合商品，true-是，false-不是；',
  `erp_goods_id` bigint DEFAULT NULL COMMENT 'erp商品id',
  `pull_time` datetime DEFAULT NULL COMMENT '拉取时间',
  `modify_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='抖店商品表';

-- ----------------------------
-- Records of oms_dou_goods
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_dou_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `oms_dou_goods_sku`;
CREATE TABLE `oms_dou_goods_sku` (
  `id` bigint NOT NULL COMMENT '商品sku_id;抖店系统生成。',
  `product_id` bigint DEFAULT NULL COMMENT '商品ID；抖店系统生成。',
  `name` varchar(85) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品标题。',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品主图的第一张图',
  `spec_id` bigint DEFAULT NULL COMMENT '规格ID',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku外部编码',
  `sku_type` int DEFAULT NULL COMMENT '库存类型；0-普通；1-区域库存；10-阶梯库存；',
  `sku_status` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku状态 true上架 false下架',
  `out_sku_id` bigint DEFAULT NULL COMMENT '外部的skuId；商家自定义；未设置返回为0。',
  `spec_detail_id1` bigint DEFAULT NULL COMMENT '第一级子规格',
  `spec_detail_id2` bigint DEFAULT NULL COMMENT '第二级子规格',
  `spec_detail_id3` bigint DEFAULT NULL COMMENT '\r\n第三级子规格',
  `spec_detail_name1` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '第一级子规格名',
  `spec_detail_name2` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '第二级子规格名',
  `spec_detail_name3` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '\r\n第三级子规格名',
  `price` int DEFAULT NULL COMMENT '商品价格，单位：分',
  `create_time` int DEFAULT NULL COMMENT '创建时间，时间戳：单位秒；',
  `stock_num` int DEFAULT NULL COMMENT 'ku_type=0时，表示普通库存数量 ;sku_type=1时，使用stock_map，表示区域库存数量',
  `prehold_stock_num` int DEFAULT NULL COMMENT 'sku_type=0时，表示预占库存数量； sku_type=1时，表示区域库存数量，使用prehold_stock_map',
  `prom_stock_num` int DEFAULT NULL COMMENT '活动库存',
  `step_stock_num` int DEFAULT NULL COMMENT '\r\n阶梯库存',
  `prehold_step_stock_num` int DEFAULT NULL COMMENT '预占阶梯库存',
  `prom_step_stock_num` int DEFAULT NULL COMMENT '活动阶梯库存',
  `normal_stock_num` int DEFAULT NULL COMMENT '库存模型V2新增 普通库存 非活动可售',
  `channel_stock_num` int DEFAULT NULL COMMENT '库存模型V2新增 渠道库存',
  `sell_properties` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '销售属性，代替spec_detail_id123、spec_detail_name123',
  `erp_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `erp_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `shop_id` bigint DEFAULT NULL COMMENT '店铺id',
  `pull_time` datetime DEFAULT NULL COMMENT '拉取时间',
  `modify_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='抖店商品Sku表';

-- ----------------------------
-- Records of oms_dou_goods_sku
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_dou_order
-- ----------------------------
DROP TABLE IF EXISTS `oms_dou_order`;
CREATE TABLE `oms_dou_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '店铺父订单号，抖店平台生成，平台下唯一；',
  `order_level` int DEFAULT NULL COMMENT '订单层级，主订单是2级',
  `order_phase_list` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '定金预售阶段单json',
  `order_status` int DEFAULT NULL COMMENT '订单状态1 待确认/待支付（订单创建完毕）105 已支付 2 备货中 101 部分发货 3 已发货（全部发货）4 已取消5 已完成（已收货）',
  `order_status_desc` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单状态描述',
  `order_tag` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '\r\n订单的一些c端标签json',
  `order_type` int DEFAULT NULL COMMENT '【订单类型】 0、普通订单 2、虚拟商品订单 4、电子券（poi核销） 5、三方核销',
  `order_type_desc` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单类型描述',
  `app_id` int DEFAULT NULL COMMENT '具体某个小程序的ID',
  `open_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '抖音小程序ID',
  `accept_order_status` int DEFAULT NULL COMMENT '小时达订单的接单状态 0-未接单；1-已接单；2-超时取消，或商家取消',
  `appointment_ship_time` int DEFAULT NULL COMMENT '预约发货时间',
  `author_cost_amount` int DEFAULT NULL COMMENT '作者（达人）承担金额（单位：分），订单参与活动和优惠中作者（达人）承担部分的总金额',
  `aweme_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '达人抖音号，样品订单场景下才会返回的申样达人信息；',
  `b_type` int DEFAULT NULL COMMENT '【下单端】 0、站外 1、火山 2、抖音 3、头条 4、西瓜 5、微信 6、值点app 7、头条lite 8、懂车帝 9、皮皮虾 11、抖音极速版 12、TikTok 13、musically 14、穿山甲 15、火山极速版 16、服务市场 26、番茄小说 27、UG教育营销电商平台 28、Jumanji 29、电商SDK',
  `b_type_desc` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '下单端描述',
  `sub_b_type` int DEFAULT NULL COMMENT '【下单场景】 0、未知 1、app内-原生 2、app内-小程序 3、H5 13、电商SDK-头条 35、电商SDK-头条lite',
  `sub_b_type_desc` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '下单场景描述',
  `biz` int DEFAULT NULL COMMENT '【业务来源】 1 -鲁班 2 -小店 3 -好好学习 4 -ev 5 -虚拟 6 -建站 7 -核销 8 -玉石 9 -ez 10 -ep 11 -虚拟卡券 12 -服务市场 13 - EP 视频课 14 - EP 直播课 21 -跨境BBC 22 -跨境BC 23 -跨境CC|UPU 24 -手机充值 25 -拍卖保证金 26 -懂车帝抵扣券 27 -懂车帝返现券 28 -离岛免税 29 -海南会员购 30 -抽奖 31 -清北-企业代付 32 -抖+券 33 -联盟寄样 49 -刀剑 53 -通信卡 66 -加油包 76 -大闸蟹 99 -保险 102-小店海外 108-上门取件收款',
  `biz_desc` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '业务来源描述',
  `buyer_words` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家留言',
  `seller_words` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '商家备注',
  `seller_remark_stars` int DEFAULT NULL COMMENT '插旗信息：0-灰 1-紫 2-青 3-绿 4-橙 5-红',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '取消原因',
  `channel_payment_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付渠道的流水号',
  `create_time` int DEFAULT NULL COMMENT '下单时间，时间戳，秒',
  `pay_time` int DEFAULT NULL COMMENT '支付时间，时间戳，秒',
  `update_time` int DEFAULT NULL COMMENT '订单更新时间，时间戳，秒',
  `finish_time` int DEFAULT NULL COMMENT '订单完成时间，时间戳，秒',
  `order_expire_time` int DEFAULT NULL COMMENT '订单过期时间，时间戳，秒',
  `doudian_open_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户唯一id',
  `encrypt_post_receiver` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '收件人姓名',
  `encrypt_post_tel` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '收件人电话',
  `encrypt_post_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '收件地址',
  `exp_ship_time` int DEFAULT NULL COMMENT '预计发货时间，时间戳，秒',
  `logistics_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '物流信息JSON',
  `main_status` int DEFAULT NULL COMMENT '主流程状态，1 待确认/待支付（订单创建完毕）103 部分支付105 已支付2 备货中101 部分发货3 已发货（全部发货）4 已取消5 已完成（已收货）21 发货前退款完结22 发货后退款完结39 收货后退款完结',
  `main_status_desc` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '主流程状态描述',
  `mask_post_receiver` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人姓名（脱敏后）',
  `mask_post_tel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人电话（脱敏后）',
  `mask_post_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收件人地址（脱敏后）',
  `province_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '省',
  `province_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `city_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `city_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `town_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `town_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `street_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `street_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `open_address_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标识收件人地址的id，可用于合单',
  `modify_amount` int DEFAULT NULL COMMENT '改价金额变化量（单位：分）',
  `modify_post_amount` int DEFAULT NULL COMMENT '改价运费金额变化量（单位：分）',
  `only_platform_cost_amount` int DEFAULT NULL COMMENT '仅平台承担金额（单位：分），订单参与活动和优惠中平台承担部分的总金额',
  `order_amount` int DEFAULT NULL COMMENT '订单金额（单位：分）',
  `pay_amount` int DEFAULT NULL COMMENT '支付金额（单位：分）',
  `pay_type` int DEFAULT NULL COMMENT '7=无需支付（0元单）；8=DOU分期（信用支付）；9=新卡支付；12=先用后付；16=收银台支付',
  `post_amount` int DEFAULT NULL COMMENT '快递费（单位：分）',
  `post_insurance_amount` int DEFAULT NULL COMMENT '运费险金额（单位：分）',
  `post_origin_amount` int DEFAULT NULL COMMENT '运费原价（单位：分），post_origin_amount = post_amount + post_promotion_amount',
  `post_promotion_amount` int DEFAULT NULL COMMENT '运费优惠金额（单位：分）',
  `promotion_amount` int DEFAULT NULL COMMENT '订单优惠总金额（单位：分） = 店铺优惠金额 + 平台优惠金额 + 达人优惠金额',
  `promotion_pay_amount` int DEFAULT NULL COMMENT '支付优惠金额（单位：分），支付渠道上的优惠金额',
  `promotion_platform_amount` int DEFAULT NULL COMMENT '平台优惠金额（单位：分），属于平台的优惠活动、优惠券、红包的总优惠金额',
  `promotion_redpack_amount` int DEFAULT NULL COMMENT '红包优惠金额（单位：分）',
  `promotion_redpack_platform_amount` int DEFAULT NULL COMMENT '平台红包优惠金额（单位：分），属于平台的红包的优惠金额',
  `promotion_redpack_talent_amount` int DEFAULT NULL COMMENT '达人红包优惠金额（单位：分），属于达人的红包的优惠金额',
  `promotion_shop_amount` int DEFAULT NULL COMMENT '店铺优惠金额（单位：分），属于店铺的优惠活动、优惠券、红包的总优惠金额',
  `promotion_talent_amount` int DEFAULT NULL COMMENT '达人优惠金额（单位：分），属于达人的优惠活动、优惠券、红包的总优惠金额',
  `ship_time` int DEFAULT NULL COMMENT '发货时间，时间戳，秒',
  `shop_cost_amount` int DEFAULT NULL COMMENT '商家承担金额（单位：分），订单参与活动和优惠中商家承担部分的总金额',
  `platform_cost_amount` int DEFAULT NULL COMMENT '平台承担金额（单位：分），订单参与活动和优惠中平台+作者（达人）承担部分的总金额,包含作者（达人）承担金额：platform_cost_amount = only_platform_cost_amount + author_cost_amount',
  `shop_id` bigint DEFAULT NULL COMMENT '店铺id，抖店平台生成，平台下唯一；',
  `shop_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商户名称',
  `total_promotion_amount` int DEFAULT NULL COMMENT '总优惠金额（单位：分），total_promotion_amount = promotion_amount + post_promotion_amount',
  `user_tag_ui` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '用户特征标签；JSON',
  `s_shop_id` bigint DEFAULT NULL COMMENT '系统店铺id',
  `pull_time` datetime DEFAULT NULL COMMENT '第一次拉取时间',
  `last_pull_time` datetime DEFAULT NULL COMMENT '最后一次拉取时间',
  `audit_status` int NOT NULL DEFAULT '0' COMMENT '0待确认，1已确认2已拦截-9未拉取',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `oms_push_status` int DEFAULT '0' COMMENT 'oms订单库推送状态0未推送1已推送2推送失败',
  `oms_push_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'oms订单库推送结果',
  `oms_push_time` datetime DEFAULT NULL COMMENT 'oms订单库推送时间（记录最后一次）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `order_id_index` (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1976069130370715651 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='抖店订单表';

-- ----------------------------
-- Records of oms_dou_order
-- ----------------------------
BEGIN;
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069120451186689, '6946855202206389414', NULL, '[]', NULL, '待发货', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '小店', '', '', NULL, '', '2105012510080503368182858831', 1759937891, 1759937892, 1759937893, 0, 1800, '1@#kYhN01TVQyYxYx0V3wzfRQuunp82K0y3rPtji4lcPfht/wVm5Cv8RhIQWj389ROF/g==', '#TAoW#YosJYZ2vr2vMaj8PogUMOhNjq/KwJRo4T8rUoa4Rblzb1UyhjHtC5BuLzuMyLB7U6xRK0/CfE03Drf6Pq02tGUffFJokIHmxUQ6MYw==*CgYIASAHKAESPgo8KZqe6ijMRtDwl0MrtSa8q2gf5iwgmP5qM1Cc1F6Vmu5TaTIfGdld0NHNhCM4ZumcKJJo4kiIbPjPEwhzGgA=#1##', '$L/yAu3rU9mKN5TZABdnMmAoY3j4MaToEvxZF2CMFMJ4=$JFODeSaeWX9x9pLmCUWzSmtFOz1coGyXUZtHwAM4sHrMv9FxN0T6mX96VQhy3x7JrFutmh8f7OWjhvtrPpFUi7+XDO/BW/H/+etg4VyBBy68*CgYIASAHKAESPgo8SaUju0NJ+qsIeFVKt0AAryigFBx0Y9oie1AI8CtwxZK4UMclxYCk6Fq1sO36jVzyNIJWVWQlLB2PGhs6GgA=$1$$', '#QPXZ+8QHCCC6EZmQ9MJPK/CVdFGcj132KZrYIzw4uAOgRjFb#TH1chJFlGNrpTAD6I2yGPRDlvJM48TvezlPdgsOVBfEY+SBUH/yJmQkNw/5SJGMrYtr6gvwjpS6Eig93ZL7vb0OXFreLIOANhDZA3fhdqd+V+caSMib0UELqmHTYUdDsXZ2sUnT8qg==*CgYIASAHKAESPgo89D6u1xHmqqj9hplhnuytfcpwlZzPf7rPV38kUwVI7a/4OsmblFcTqGV5d1CmXVLE197qcnFXKcv+zp20GgA=#1##', 1760110693, '[]', NULL, '备货中', '唐*', '1**********', '*************', '广东省', '44', '深圳市', '440300', '宝安区', '440306', '西乡街道', '440306018', '#vjhBSGYo80fWEOiiS+xc8f6vel7hTe60R01bC8VxAN7cTlGaL1MEviwAo+JMGCHpMSGw2gqEQzXlS68xifrGYNEyKC5L5z0+diaY6OHKIJlIR73Xo7jEZUsLlJDVgW0hAel75N+b9A==', 0, 0, 0, 2, 2, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:07', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069120828674050, '6946833213743895718', NULL, '[]', NULL, '待发货', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '小店', '', '', NULL, '', '2105012510080503367978540506', 1759937881, 1759937882, 1759937883, 0, 1800, '1@#kYhN01TVQyYxYx0V3wzfRQuunp82K0y3rPtji4lcPfht/wVm5Cv8RhIQWj389ROF/g==', '#TAoW#sL8thS3QNLCgOM/z76ePePVA7SCKWLENKfPeWAVgzlbygZSRGskj+kjjHdOToj5kdJ9TkHy5Oo1EixEJG680wra6mB0QDOfk7QmP/A==*CgYIASAHKAESPgo8y3v2nBmtSQwA3Hsg2xEFz9SWevplpP9U0nRZFxKZcD7n48uN9puW4WAbf/RkLdFS8M9l2qdK4BUVbBucGgA=#1##', '$L/yAu3rU9mKN5TZABdnMmAoY3j4MaToEvxZF2CMFMJ4=$pIdIqUHR6cArqmOhYgs6YV3K9Vv6dPbh8Ug7NvzcmZWXWUcnUez0JTLOlxCXnCk5x980BMmx1IWg7iRulUuFZKf0F166hEGXNNAUgWsUG3+r*CgYIASAHKAESPgo8vl+P6mz+ve3z8bsNrbrxi5slaUmUxCQLWO4sqnIHIzMI0OtAC28lmWIfwEsy2B3A2oVJNPdWPff1uPkSGgA=$1$$', '#QPXZ+8QHCCC6EZmQ9MJPK/CVdFGcj132KZrYIzw4uAOgRjFb#eLcZLYeeaDRGdDmlS5Cu6K3pz2XDvMHxH5gaddeOrigXqAtCBX1hT8CcHwA5TTKI1aBXZJu/zH6sQwy/z23vqRy0U8Zbt2wiQbvwV9un9rzj3Jg4HSVBKRMMYiTSEzBlgUNr86qZyw==*CgYIASAHKAESPgo8kyEbBTy0YKOqM67ZlyKtirsI+qBno0I99MnfxQdd39ES8CC8vSjsrQP1bq8gNzpHmnyMbJ+TPh+mMZE2GgA=#1##', 1760110682, '[]', NULL, '备货中', '唐*', '1**********', '*************', '广东省', '44', '深圳市', '440300', '宝安区', '440306', '西乡街道', '440306018', '#vjhBSGYo80fWEOiiS+xc8f6vel7hTe60R01bC8VxAN7cTlGaL1MEviwAo+JMGCHpMSGw2gqEQzXlS68xifrGYNEyKC5L5z0+diaY6OHKIJlIR73Xo7jEZUsLlJDVgW0hAel75N+b9A==', 0, 0, 0, 1, 1, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:07', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069121151635458, '6946852810251244710', NULL, '[]', NULL, '待发货', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '小店', '', '', NULL, '', '2105012510080503367713143617', 1759936917, 1759936919, 1759936920, 0, 1800, '1@#kYhN01TVQyYxYx0V3wzfRQuunp82K0y3rPtji4lcPfht/wVm5Cv8RhIQWj389ROF/g==', '#TAoW#TNuIanrcfcs2psi2llpZljaxFDfkK0mTeZSQnC6EWWRuDUcFLq3jm7T8TNGuCEBEjUVNKE94ow+C6E4xNm6hMUtll6zU4P+s9o+GCQ==*CgYIASAHKAESPgo8L+VWTMzKuFE/prQmXGQgqt3JUoq0wn/+t9RZFqJ+0iYpkBmEMRUonRjjum1Dn7XyLY7/JTQv8ZYHRxfLGgA=#1##', '$L/yAu3rU9mKN5TZABdnMmAoY3j4MaToEvxZF2CMFMJ4=$Y1uQwPUxyYTDYnOiR4EpZRVp9wq6/tsRxL6BmSRwffVRu2l+QIqwzTVaR9Bz7FzxP2PhYMcZ8QW5b4A/WJh84R14hDhm8IPVBli7yScttZEQ*CgYIASAHKAESPgo8AR3eptnPZoQ4AkxO32PjYKoddXZU58R7DB/hyev8xBTWIAwGHyren05a3mo7qD9k5CCmdekNWR0ZUCyzGgA=$1$$', '#QPXZ+8QHCCC6EZmQ9MJPK/CVdFGcj132KZrYIzw4uAOgRjFb#2wvzVpbibk8NfSGB0b8uZOf8FF9Jj2XvQaARlCByj6e8njV+9SdA7ShZYtuxF2lLSFLTGbT8DP84tYS5JrvsIzF4svhefVgYhwQwX5wEHNPTfiW4TGbcRquSldiTstzTKhuMn5/Nug==*CgYIASAHKAESPgo8AqOO4LCGt6earfuRK7vY+RVYErE96C4wPCBsktk0a97S6saCTgyiDb4eU2OSTsREWrVr9vlgP2qcXX/LGgA=#1##', 1760109719, '[]', NULL, '备货中', '唐*', '1**********', '*************', '广东省', '44', '深圳市', '440300', '宝安区', '440306', '西乡街道', '440306018', '#vjhBSGYo80fWEOiiS+xc8f6vel7hTe60R01bC8VxAN7cTlGaL1MEviwAo+JMGCHpMSGw2gqEQzXlS68xifrGYNEyKC5L5z0+diaY6OHKIJlIR73Xo7jEZUsLlJDVgW0hAel75N+b9A==', 0, 0, 0, 5, 5, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:07', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069121604620290, '6946819380690621606', NULL, '[]', NULL, '已发货', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '小店', '', '', NULL, '', '2105012510080503362887270840', 1759925922, 1759925924, 1759935488, 0, 1800, '1@#kYhN01TVQyYxYx0V3wzfRQuunp82K0y3rPtji4lcPfht/wVm5Cv8RhIQWj389ROF/g==', '#TAoW#lnl1QHG7rKvaL7LMESWaskgYJH2h88vWFBN6a46vENXum2Ty0SMNxCxfORArw2cPZX1eonoxc9ihBt1iL56wXpC0QCj5KU0gzqGKRw==*CgYIASAHKAESPgo8bFbgYos93e+EYV0pqHbnlsNSQcyiPtmW52GUxlbk0Zkx0sjaRbEH3bjxtofM/NBqSXmlimeHoPALGozxGgA=#1##', '$L/yAu3rU9mKN5TZABdnMmAoY3j4MaToEvxZF2CMFMJ4=$FvO/8YOJOd6YriBhfy+b0bpAtYzEwFfV8kUXSQhx5/56yXwoSACwhXiRGux8V8NRImc/9p7+n1pe3tDOv8G/Zj2YbTURrKKqt3V1vamdQ25A*CgYIASAHKAESPgo8373fdIg5GGouy0skXbZFwXxDlhdZ9Veh7b7jy/mPDErUOXUJE8/vTtzt5nH6PwT34/5xVX1Eyv9DDhRRGgA=$1$$', '#QPXZ+8QHCCC6EZmQ9MJPK/CVdFGcj132KZrYIzw4uAOgRjFb#gHYNY8a7VSt6wUwD9l8WQ2aAIoplKeqMG+CMwXhUmGZ0XQMFm1m7WWl1sLHlVsqpqQ3X8YmBmA7RX0fG8zf3R3TJ3z0hWz/nfIRhOvb4uYIdtn7/AVjeRkbERtHdbIHHqvdFWGURLw==*CgYIASAHKAESPgo8k/i6r2pPpR0yB1OwDDqlKISRQ1qSoM8Me7bhUjawjip3Sxn9ssOB+FdQnrUkIbAh6lj1TP6mEHwcnqeqGgA=#1##', 1760098724, '[{\"company\":\"shunfeng\",\"company_name\":\"顺丰速运\",\"delivery_id\":\"147170295624667264\",\"guarantee_amount\":0,\"hour_up_pickup_code\":\"\",\"product_info\":[{\"outer_sku_id\":\"\",\"price\":1,\"product_count\":1,\"product_id\":3704250147174219802,\"product_id_str\":\"3704250147174219802\",\"product_name\":\"通用气质针织春夏收腰欧美法式潮流短款外套\",\"sku_id\":3415147054561794,\"sku_order_id\":\"6946819380690621606\",\"sku_specs\":[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"XS\"}]}],\"ship_time\":1759935487,\"sp_discount_price\":0,\"sp_price\":0,\"sp_total_price\":0,\"tracking_no\":\"SF3299283329088\"}]', NULL, '已全部发货', '唐*', '1**********', '*************', '广东省', '44', '深圳市', '440300', '宝安区', '440306', '西乡街道', '440306018', '#vjhBSGYo80fWEOiiS+xc8f6vel7hTe60R01bC8VxAN7cTlGaL1MEviwAo+JMGCHpMSGw2gqEQzXlS68xifrGYNEyKC5L5z0+diaY6OHKIJlIR73Xo7jEZUsLlJDVgW0hAel75N+b9A==', 0, 0, 0, 1, 1, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1759935487, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:07', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069121868861441, '6946617941468648709', NULL, '[]', NULL, '已关闭', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '小店', '', '六六测试顺丰快递SF32885093375322025100821380；-0  zzzz测试dddzzzz', NULL, '', '2025092922001476781407413226', 1759131982, 1759131991, 1759930680, 0, 1800, '1@#LdCl3m30bbJk+tVTyl6xWlXY7u1w6NzLZDdha/OpMcFs8ZW+14eqlCGFJHbFjkvNv2JLX8E=', '#xGECxRdviE7G#31FUtmNiIipCn+mEPiqU/ghcFHz7OxZU889qCvE7j1PN0vNlzxYYIbhlwxGQwTfnD5MxnzmSo06zW/s8RS3zmC37Nx1NBHy4vQ+9cQiYg2Gm+g==*CgYIASAHKAESPgo8uRfzv+ejhLfDKd1hjHQoqtKQtz75oz5SQ6oaKVn7lC0BS2/6ZqrtUiJ4C0moBFIega4yB7X1kK+UUZFCGgA=#1##', '$AbHbZY+tLcay7NpMHIefjo/ML20hx3JhgTMIAtmkzjw=$qTmKyRMEUD4edmuhajhYYiDQ1bassISb+VII14LBeLPugN2WaGh+btZVbN2xyy9+k1SqmFNhgvfUSuhAHBrm3r2dy4JzdhXppxIxaslgrVwu*CgYIASAHKAESPgo8V8UUwraGs21NfUKSPYJe9uFWZDeddN/wsvSoCZh1GjjUGGLEcr4bGg6gpwhv+nb0F5uY/6B5VVr8AEvCGgA=$1$$', '#WOWmRyB2CkX21hWmrDFDJU1zPLyXTxmSzaS9ckKSYb4bpXH54RjIAweXz7bs+4IgRxtztk+QsruyzaS9ckKSYb4bV4YP52QlpIeIQyhN+TQS#wNCgbW8skYyiuDVHZGs90nS1g4PDG1f9ps+p0NSmepA9iGdXb09N+c+J3r4Ti3T1eC5aGtb9+lZQKA/cxktTy9fozIl8vjRrsrAHlFzNNUQD/Revi6bF3f5EbvS2trEDgIh+K3Rqa9wVbVLhXQjseNU4n2+UsPYBClJ5cCGWaWzKpep8298rKQ==*CgYIASAHKAESPgo8nEkgOL8seKYXjLyMxXNWUbgSorwD541vCikSJzG9Ad2NveUkAFv2dbchoXizP5I0qIxYxiXciFsykT1QGgA=#1##', 1759304792, '[{\"company\":\"shunfeng\",\"company_name\":\"顺丰速运\",\"delivery_id\":\"147156918191938248\",\"guarantee_amount\":0,\"hour_up_pickup_code\":\"\",\"product_info\":[{\"outer_sku_id\":\"\",\"price\":1,\"product_count\":1,\"product_id\":3704250147174219802,\"product_id_str\":\"3704250147174219802\",\"product_name\":\"通用气质针织春夏收腰欧美法式潮流短款外套\",\"sku_id\":3415147054561794,\"sku_order_id\":\"6946617941468648709\",\"sku_specs\":[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"XS\"}]}],\"ship_time\":1759138079,\"sp_discount_price\":0,\"sp_price\":0,\"sp_total_price\":0,\"tracking_no\":\"SF3297601138791\"}]', NULL, '发货后退款完成', '卡*', '1**********', '****************************', '福建省', '35', '福州市', '350100', '仓山区', '350104', '金山街道', '350104008', '#pN3dLBIeva6itOkiovzV871qp1AZU2mSxxziu++YKtmUwL2p9xb8NKNdsTwMO9v8KQsbLspLQJRDv5zgKXDEifgq0AZxySOFo8JY4N9BADcwSUcGO1WprUVnJ4tGCzdL+eu25CXkcg==', 0, 0, 0, 1, 1, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1759138079, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:07', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069122254737409, '6946823916925425563', NULL, '[]', NULL, '已关闭', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音商城版', NULL, 'H5', NULL, '小店', '', '', NULL, '', '2025100822001450841452459994', 1759917308, 1759917321, 1759917350, 0, 1800, '1@#stbfVDe6GeQNgVr++adSHrwDiP/Yu8VBDkODnlT1SExN1W6Gp0wYCWGmL7Qwb5O9V9m5nl68', '#RE65ng3c#h027Sip0xg16UrNrqs00/SWBBWxK1KUmTgW6qx+aRTmqbssnnaGiO3wZJK4XLoDbdUythMDBhNDTCOlgQLXx2ZErzuEThnY7oQ==*CgYIASAHKAESPgo8hYTlP/vnXjfeX5MQChT9CiK7tzSaEqoBna02/7XQJI+XUUUBM7AO+qR6liBb20qAX8Wq4aBTMFjOHro9GgA=#1##', '$W2CYvnf2fHhysHLxkRD9F4unz5o9XnwQLzsg1lB9OLw=$/mJdnTSIDjbTdfPSUijpHPAqe49+2SY9haYBVdwZLvFxvnDJjlIxd1D2SytqOZgvLy4rGpKtCjfV1VeybcpLztMDhDgAJJfRdffzCFP++BE3*CgYIASAHKAESPgo8iCv9dhCAsC0t/eO0MMwfKTLvDs/+IDT0IQQVs0z5bQD1Pyhc9704x+vfWki+pvgax68nXslot6j3KmnhGgA=$1$$', '#Oot0SgBgl+Td5G/AlW8sLW43lx0QXHscjOzvAEeU78qXUidrFY10b+loiMpz/lzT#bjyt0RUUl4TiyX2RL6J91iVTYTXzz2kd6/ozIvbS4U7qUyv6B7nCY/gXdggVO9CvChybYaANAPXaB0pr3yJotDOUrZg5vYC7Hixuu52cSYoTBkUoXGrlxSiyMNIksi0WZS9ihYV8R6KNgCV5NeVq*CgYIASAHKAESPgo8FjpSRdYwRCDfZFGqit53RRnRt99VwdPAFOXPnn2xBOuPqynTjjq7JwQYG3qSZU19zRSSD9xWeGMTR6ugGgA=#1##', 1760090122, '[]', NULL, '发货前退款完成', 'y*', '1**********', '*****************', '北京市', '11', '北京市', '110000', '朝阳区', '110105', '朝外街道', '110105002', '#3MNvCDt1/u2nfmfYlg4M0aVir56RN3NdaWGDAVS/BD4CfvQ9OV45U3qRUUjBC1Jd14BgnQQTcnpcUVKo0xBy/9ui4Dvx4QdQDQ105hm+zqvkQz7cxUq6ccfxQg9pjdMmCgwtwtq5wQ==', 0, 0, 0, 17, 17, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:07', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069122644807681, '6946821219953022875', NULL, '[]', NULL, '已关闭', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音商城版', NULL, 'H5', NULL, '小店', '', '', NULL, '', '2025100822001450841451582591', 1759917239, 1759917248, 1759917269, 0, 1800, '1@#stbfVDe6GeQNgVr++adSHrwDiP/Yu8VBDkODnlT1SExN1W6Gp0wYCWGmL7Qwb5O9V9m5nl68', '#RE65ng3c#6gB5cSGQUX5rs9GpWC/v/EpFylBZNoc7XtGk4uTTtrXDKS3utUsQbfyctFh19S/vXuUbF1f4GSgwbEm51Vc+aNXtON6UMtbEqg==*CgYIASAHKAESPgo8u3mEOkHtE8pHQxS0C7EwIbUmzLIF4pEqdSiZl3ex+3Wfvkyg3EYeShY1aSd5Fmyme8LGV75e4/vOCB/8GgA=#1##', '$W2CYvnf2fHhysHLxkRD9F4unz5o9XnwQLzsg1lB9OLw=$Yx/X6z3MbXtJTNUttSxCBhVtZq5ppTbhlE3VDSL9oVPNk+m6MkqOhd9kFWFK1fN7DbGvJy30UCGSjqR4SAGKEu0ELFCO74s1G1tFTaSJ97VF*CgYIASAHKAESPgo8R+vUQCBf3Rks0CtBavCMxt3/SfohGzXx3NxXR8h8nHkFdzdxDKrBmBAiebAQkdyoAXWeWZW60S06yEbaGgA=$1$$', '#Oot0SgBgl+Td5G/AlW8sLW43lx0QXHscjOzvAEeU78qXUidrFY10b+loiMpz/lzT#MqqXqGzetrWa87aqdAmGMR2bA2DYhIRWdbWDtmJF4OoCSV/7DMdM9lSXAk+A2O00R3gYAKOlCAeShs6NcJAsJA7zCKzmM8IFz3AZgym/LoLL6ClLepqLqd267HfOjCO5WP457lO8trXbApEfuVZh*CgYIASAHKAESPgo8gjuk2YTCH6gplNrrANN0iiu1v0Gx3Tt7sH8F974SK02lQnMyV16BY4Y+SEz4B8IKC5S02ImJrCjTKnEYGgA=#1##', 1760090049, '[]', NULL, '发货前退款完成', 'y*', '1**********', '*****************', '北京市', '11', '北京市', '110000', '朝阳区', '110105', '朝外街道', '110105002', '#3MNvCDt1/u2nfmfYlg4M0aVir56RN3NdaWGDAVS/BD4CfvQ9OV45U3qRUUjBC1Jd14BgnQQTcnpcUVKo0xBy/9ui4Dvx4QdQDQ105hm+zqvkQz7cxUq6ccfxQg9pjdMmCgwtwtq5wQ==', 0, 0, 0, 17, 17, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:07', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069122967769090, '6946838791950112063', NULL, '[]', NULL, '待发货', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '小店', '', '发顺丰【18569065130】【10-08 17:52:43】', NULL, '', '2105012510080503353383706431', 1759908229, 1759908230, 1759917166, 0, 1800, '1@#GPloKNuDRXIJU05qYPS5h0/AD6e78KrwYoRHGqT4jk/a+0G1XqN33ghCd8tXGPmT0zdx+eU5', '#/LnYS+FX#dOLZ2RomDB3wTYJu837g+uKiJHO7ajulnU/drzmNSnF54d6GKe4x034D72cJq9B0AxAndsHHb6PiG6LNtLpgZAJsJVstqx9mrvSBkd/RNw==*CgYIASAHKAESPgo8dNb/URYuz+cqdU1eDHblUFLxaBEmVXrqfVhOfzHNPr7f3FioO7fjUXXEo3zWiHrTdCcw2jPjHvdN2xgZGgA=#1##', '$gkewzV+/OjXmTT6sJUyBBKfEXDjIzIuQqoONOqDy7LY=$mM+1ngEYQi8W5g+YeYi8UaHINq1DdrBr2fquNaIc8w8FUZvdjxC8S2QF0G2cdpOhdxa/o6sCemhosTGUrpH0WfgLdVbBxYK2luPxOgmpBwAn*CgYIASAHKAESPgo842K4NHnGvNDQQ2SilIAgV6L/LhRXp6vOeOo2rnsBlkdwhSNxAJdGwvRJOwPeyeXyh5w4AE2un8iFBhrXGgA=$1$$', '#G4J7lsJGuz4Oj4XQG4J7N0kGgNZEelEGuz4OnmiKPsuqf4aQ1KGjG4J7lsJGuz4O4BoOTJXZzStqHYV3EFVo0OvrVxdUVh8C#I0ZA8XdSAwvc+Pc6MW0VCqHNSnPK6A0Em/K8kFB/lJTJSN3BX+o1bIRFvbGQjHNzTnhLQtPMlrq756xqAr3X+sdBAhceesEWoUAL8dAEfMyqTmHbfJDWs3sSFLBfmAlXLiw4eamJlrfrohzqGJenvVEgaPRB8GiECOC0cO3leFVNYza9a3kCpUjn8+PU*CgYIASAHKAESPgo856mm1PTLKDmyWJZ+kWKlZkPfHoKLcxdIuAgMZ/n8tU2Kmi7AtxqiT5gkUGcmrQQfOaiF9Z2kwA7op8rUGgA=#1##', 1760081030, '[]', NULL, '备货中', '邹*', '1**********', '*************************', '上海市', '31', '上海市', '310000', '青浦区', '310118', '华新镇', '310118107', '#vck2xBMziohm8GH20sxbCtvSrFRdJLUdgLNUzF8tyseacA9lQQhDMJz0L05CLt0UsBIPIrXvYkbJYnW/0WDagziXqxeKu6Kd72DgfAKz8zBRFFJG/xi1VsDBYrg0YsZkZ7Zm2KZ2RA==', 0, 0, 0, 150, 150, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:07', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069123223621633, '6946629275321439680', NULL, '[]', NULL, '已关闭', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '小店', '', '六六测试圆通快递YT197336702720320251008171559；-1  11dddzzzz', NULL, '', '2105012509290502756781920716', 1759144626, 1759144629, 1759914960, 0, 1800, '1@#hDMlLSs6fVjXpybuZXFmNuJl7jKdXSm5XUeOnXwxlyhiM3u1srREhFOcejFAxcuVWQ==', '#lTJO#nGl4qkgOGq2Bu2J5j0imQ4eCDpvXCSX0XHpaIXcK54/gdhV+tQKyc5ivNd7CF+yCHMrA2r7gBimIug89T7xaQiNKCUc6ZKoeGtErdg==*CgYIASAHKAESPgo8t5+qJwLbcXRQZSReWSwD4YGr4vQlnrcSF6k5KWqoCQPm4lXXMiBemvfDMtbAdMi8+AxtQOP51Jwit2FQGgA=#1##', '$3Mp/gTpf3xs+q4TQ0KnthJGnBBPwwY++1XrH44M9aFw=$AnVJ/szowxx8zCBReXdV9eXsPUyXJ9HkNh+lpnsEMgtrLBq1UcIyL5FOn9jYPKo6UYYyvKjybeATkRywD8/rz/zHWIR9tNlxJvgHOC9UFrW+*CgYIASAHKAESPgo8f6GDpyJCPsU0P7nZaMwz3JwmbUGPHA4q3JXZbjyQ+d4CrpsFqdeJw1g1AB9xwO3wLBq/G91/R1vUZZSDGgA=$1$$', '#UcRboYpSMFMWTM6Zdq1LdyB6RtmQ7nL1V1KW60lm4RjINtSSw8JKhWVAXq6518ch88M+#b9WSzaFp/7vZS1gAbkEBC5MUI1xGZ5INA5QMrJafQe2TlDOr512rn4q5HKOrJuII1D45UfMbGlJuVyjPyxtAt3xuM2e8VXScmF1Bl37KMqr52XY5UaZsFEUDho/NYyuIjtieg+1cGAymo3UWAvjIIbAj*CgYIASAHKAESPgo8GbXdSqnVUnCZXGaIUrSYNGEJAJlAsAwTh8Q9o01pG3fRtX03Pkd3R8Rp98yq/C2sISqF6NPzcL1eXGirGgA=#1##', 1759247999, '[{\"company\":\"yuantong\",\"company_name\":\"圆通快递\",\"delivery_id\":\"147157029477019349\",\"guarantee_amount\":0,\"hour_up_pickup_code\":\"\",\"product_info\":[{\"outer_sku_id\":\"\",\"price\":8,\"product_count\":1,\"product_id\":3699778895269200035,\"product_id_str\":\"3699778895269200035\",\"product_name\":\"5000万+收藏碎花裙子蕾丝显瘦修身包臀裙半身裙大田\",\"sku_id\":3412261091365122,\"sku_order_id\":\"6946629275321439680\",\"sku_specs\":[{\"name\":\"颜色分类\",\"value\":\"白色\"},{\"name\":\"尺码大小\",\"value\":\"XL\"}]}],\"ship_time\":1759144723,\"sp_discount_price\":0,\"sp_price\":0,\"sp_total_price\":0,\"tracking_no\":\"YT1973727951978\"}]', NULL, '发货后退款完成', '小*', '1**********', '******************', '广东省', '44', '广州市', '440100', '荔湾区', '440103', '龙津街道', '440103007', '#Obcr9wpz1UMacnkCggfv4+WhsAYeRj60Ymmt/W8tgE6gJqqxK20Kn26uP0TBYTfqpg6lEOX5twTMDw9Bz3Eq5nhnKtyiK8gu97aJsL62HJVycyYX6jU7lrM+fFf01Fy86iUDbBMoWg==', 0, 0, 0, 8, 8, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1759144723, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:07', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069123546583041, '6921602341082267246', NULL, '[]', NULL, '已使用', NULL, NULL, '平台发码订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '核销', '', '', NULL, '', '2025100722001478581410588803', 1759835067, 1759835076, 1759914460, 1759835178, 1800, '1@#NMk63mvt6FtYc9mS/DA6MbevM3qFW3ryV83pFbPktlJ0pkpqDccMxxjiH1OWnpMxLtRCRX0/', '#hqvJ#dWtpgbYPqBvHU1b5grGg+wrl/6mvkQ31o0RutQUUc2k1TJHZN7w6gQ9fL28MWsFcXr1aTARMn4KKTqS0Gp10tzoNSqGX2FtaoXwF7g==*CgYIASAHKAESPgo8uJzMVy3BMIbgp1V6YeBNnYEOe7x1dVoRqRHPrxMDCdgWrHHxr8JvTc4OlDTgbRDRWrwCNioww9b/7JH6GgA=#1##', '$0o2bgiKlFzq0j/AF/nBGXNjNVrEdWzgQD77unQ3EB1Q=$DiIokWX5LSBXya5FOqedbmdylJm7PSpiCIzdPukbpuWtFAaXGaW78IlbN1ephogzjZejPBfobgGVWZHPUg5ZuuKI6jF+LlTrM5Z6+GkNfExG*CgYIASAHKAESPgo8n1WjxpaPQKwbowNBCIka5zyh7KVKOuPPzMNxvvrnZ7LFC3uJahGApfOKsWHz4CMjLCXWWgDWnle9NGdKGgA=$1$$', '', 1760007867, '[]', NULL, '正向已收货', '天*', '1**********', '', '', '0', '0', '', '', '0', '', '', '#IELYa07+ugKQVXbqFtHWY+dhppecG+n8muGoizAg8dknyS5+/exgRDaU6J7rmZE6TUwe8yhqDEWwwYPmoXnUcY1odpk/9v5jV0XV4Op5n3Oz/Qj6btgI6/jLy1JtQGqCJK2IIlm/qA==', 0, 0, 0, 1, 1, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1759835077, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:07', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069124523855873, '6921639186009783565', NULL, '[]', NULL, '已使用', NULL, NULL, '平台发码订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '核销', '', '', NULL, '', '2025100822001454231405544199', 1759913850, 1759913856, 1759913910, 1759913910, 1800, '1@#43uGN+JKFNqreDgenQ9w9ub86MDpmqGd/AjVD4F7L0XQzhNTtn1mArlsWg98RQ7X308GKdU=', '#aZ4lCnZ9#CsYF3A4EFkLk2MRJkgu/E0SuPkwRdm1n5jCZRxX8KTX/H+td2uIDTvtSHP4rnXn5pIaZFt9HOhGRi4UiadMfmDNk9X7W40RVYyirfeE6SQ==*CgYIASAHKAESPgo88ELRQGc2JtTnq5UbFTWeTLuDvshfUTgs9zChwImT26SbbZpgsy3qZZpWACPFeese6/P+BopC07JmaM7lGgA=#1##', '$OLdQVKNpxS0zdV71kvM8cp3ZrAV3E2hxDLEiLEN3zZY=$9TskFaGEvl9O2fUK0VZ4crBJEv0rijTzFa0YHxqIqDOvKpv+NHNpTwS1itJ1citEloasAHd7Q6CHoRRBk79q8f5/tvq0v2bJgqsz3AjqGrSQ*CgYIASAHKAESPgo80bfShNTO3XmGYQVvtbxh4O2cqTM52hey30Nd1ZVCuqRBWHmnw4D+XjCTftVfj4nkPc6WZA8ESj/qvfZ4GgA=$1$$', '', 1760086650, '[]', NULL, '正向已收货', '顾*', '1**********', '', '', '0', '0', '', '', '0', '', '', '#oZkXfJO9hhKcsnHUoT3jODvC0t0XK5hMlgDKgc3buIUXK2qav5sHDBC5yMXTOt/Y6/hcoDryvKHMsVwUU41vYT4vbkL1Ru4sPpzX1Ia5vrIuGZLVjw09UQCf0jzz+Y5wlb4NSBMgbw==', 0, 0, 0, 1, 1, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1759913857, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:08', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069125949919233, '6921639306983341325', NULL, '[]', NULL, '待使用', NULL, NULL, '平台发码订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '核销', '', '', NULL, '', '2025100822001454231409941268', 1759913660, 1759913664, 1759913665, 0, 1800, '1@#43uGN+JKFNqreDgenQ9w9ub86MDpmqGd/AjVD4F7L0XQzhNTtn1mArlsWg98RQ7X308GKdU=', '#aZ4lCnZ9#dcKhVsaATUjq3VixvfyrzfOfNfMjfsjz++XCVsDsVviPYGktylNpPW+mslteHPzeHb85O7JO6kBBFg4o/StRz/x36CE1gy9p2YOAX3lGdQ==*CgYIASAHKAESPgo8PhOy7Tp7H5v5bPiAgtGgEFH/jLT3lsnH+Rl28HAE0ZwnD6+BnpGWJJwoKdFM8nL9nX1EalqszAwFFlYTGgA=#1##', '$OLdQVKNpxS0zdV71kvM8cp3ZrAV3E2hxDLEiLEN3zZY=$pEEyLYTh8ibR45ShMZOT4yE2weTdIrGpz12WMF9vVjCkm3IvWJB7lEjAToSNSCOhTF+/7C0ldAO2pfFJ+S8NVoGJ9+ykPWvCSfTtYXljdpaU*CgYIASAHKAESPgo8AboeLjBFUj6ImcrJZcaiZk7zvBO4AY8nEe1eArmoYgYzVNIdFmhKiReyPLpOwaM0of5AI4Y9lOI2S7O3GgA=$1$$', '', 1760086460, '[]', NULL, '已全部发货', '顾*', '1**********', '', '', '0', '0', '', '', '0', '', '', '#oZkXfJO9hhKcsnHUoT3jODvC0t0XK5hMlgDKgc3buIUXK2qav5sHDBC5yMXTOt/Y6/hcoDryvKHMsVwUU41vYT4vbkL1Ru4sPpzX1Ia5vrIuGZLVjw09UQCf0jzz+Y5wlb4NSBMgbw==', 0, 0, 0, 1, 1, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1759913665, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:08', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069126407098370, '6921627853996326157', NULL, '[]', NULL, '已使用', NULL, NULL, '平台发码订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '核销', '', '', NULL, '', '2025100822001454231405650025', 1759911231, 1759911237, 1759911284, 1759911284, 1800, '1@#43uGN+JKFNqreDgenQ9w9ub86MDpmqGd/AjVD4F7L0XQzhNTtn1mArlsWg98RQ7X308GKdU=', '#aZ4lCnZ9#aZX3HRcuz70Vd5RiOyBIuRxQQqq8RFHnxOT8XITVvnN8CglNka7i7JcicCpeItue+v06nynCr7wijcjzNGGDiJHbk7Vfy5vLEQndJWdP4g==*CgYIASAHKAESPgo8v1sQvxtbrnOsWTtxAuzDx9afsXxbJSIYFvqvbjT/tSlkyQvU9qdQndHo8iXRfTt38yOVGHE+83ot7XrmGgA=#1##', '$OLdQVKNpxS0zdV71kvM8cp3ZrAV3E2hxDLEiLEN3zZY=$CEhm1VniwLAiwLuYX5mztSjLVAtAaQuzH4LjP9/SJKyXN71/ItoeW8BKAXP71eqQRSfwuSncqlP/hAKzuvaWUHxAAqEMImBGR6FbKv6gQm2L*CgYIASAHKAESPgo8m/k/iWno+7d8/M92Yoqj2w+KET/R915f6aqD6JLTxCCs6SZQUH5YUjElZam84zXj796S2JHpWpTh3cfWGgA=$1$$', '', 1760084031, '[]', NULL, '正向已收货', '顾*', '1**********', '', '', '0', '0', '', '', '0', '', '', '#h5qKuRBaSs59u26b5KHlCBkJ3jS869gwD2HGzMktp9vDr0lZNK5F93/26ozn3i/mUzphIXY6/SRQ++LhwocLPFZD3wWj16F19MDfbKqaWWmR375LVL1f+MU8XrIjLMvG0pBMD68OCA==', 0, 0, 0, 1, 1, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1759911238, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:08', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069127061409794, '6946619869083932541', NULL, '[]', NULL, '已发货', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音极速版', NULL, 'H5', NULL, '小店', '', '', NULL, '', '2105012509290503063794163541', 1759127104, 1759127107, 1759909755, 0, 1800, '1@#QFO01rITqkLXtAYdDAez1oWE9mFkyZSXRFpAXIBS0qqvKWbaGLzE/mnQ66x7zp8uwQ==', '#I9um#Xb5+xAosqXbQE5QnVwoIHIIGsWfMgjn9iTIH02JZMEy3hgtzFaiyKJTFZF3MZRrW+6nvlCNLrkLKEAgO61QSyqZRwrzeu6Q8JQn8EA==*CgYIASAHKAESPgo89bqc+WbQdKMBmAiY56bcldfDrSR2bNjCES0+GCwaIL0F7kDdcKXTxk5qeGq0vGlDvjkQZKXobfji0Tl9GgA=#1##', '$yz0d2pZVR2+rziX3g053k1wHutnNKcH5f9m6wrQG+m8=$uUNCUKpL2M/f9qRFDOoOGx4we3GnsI2itDZYWQRWelzgPvxPEqSonxiik76cqI9QoTv+neK09KzKPO3COjZuNI6jqQggujb9Cfn6CY7OqgMZ*CgYIASAHKAESPgo8P2f80HGhYj3qK2sI+cM65ZnhS7J45Rq+okRtc6ugZ4SpSb9aZioLHmN98Iq5GXONQstDNwms4hRIZqbFGgA=$1$$', '#Tvm+lP6TF8VE8/EooLl/1BPuI8wmgaHaOORZFAC9imILgwp7#F5q2AXuBj1dUZpHn1OyFvJkRU+xEKRt+33uv7IxQpNd8HxbNjC2XPKyVL36f4UDHFpbSkI5V0hsnrQjgFX8j1vgVee9h82wzcLS3oJYlEZ7gzpNSx6oJTxxHk9fDY44=*CgYIASAHKAESPgo8t5X5pmkxOQL11A5INlsq+EgUUL8Uw+S0SK0/MvZlCS298uf5ixreZ4tYGVqVVtzZI/rG27G6HdZIpAb+GgA=#1##', 1759247999, '[{\"company\":\"zhongtong\",\"company_name\":\"中通快递\",\"delivery_id\":\"147156739513866267\",\"guarantee_amount\":0,\"hour_up_pickup_code\":\"\",\"product_info\":[{\"outer_sku_id\":\"\",\"price\":8,\"product_count\":1,\"product_id\":3699778895269200035,\"product_id_str\":\"3699778895269200035\",\"product_name\":\"5000万+收藏碎花裙子蕾丝显瘦修身包臀裙半身裙大田\",\"sku_id\":3412261091365122,\"sku_order_id\":\"6946619869083932541\",\"sku_specs\":[{\"name\":\"颜色分类\",\"value\":\"白色\"},{\"name\":\"尺码大小\",\"value\":\"XL\"}]}],\"ship_time\":1759127418,\"sp_discount_price\":0,\"sp_price\":0,\"sp_total_price\":0,\"tracking_no\":\"76745672670802\"}]', NULL, '已全部发货', '小*', '1**********', '*************', '安徽省', '34', '合肥市', '340100', '瑶海区', '340102', '龙岗综合经济开发区', '340102401', '#YuvbKuqDSzECx5+hSVXdft4C2cf3gCj3Mw9WLBSLTb4IPMdBVAp4Yw74v3VlXHIOcc/A4ob0PMtSVAGCe+xwXE9RumVxIN+GCHDiX1TPr9c3heWMkoj9dxQXLZrwzN/8HpLoCyEedg==', 0, 0, 0, 8, 8, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1759127418, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:08', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069127979962370, '6946818969975199358', NULL, '[]', NULL, '待发货', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '小店', '', '', NULL, '', '2105012510080503354191159085', 1759908715, 1759908721, 1759908722, 0, 1800, '1@#vZvRG5czZqelIdekWnQHc/ulW77cQRm1fXgqWeCuZ1VTKRyU8DlLKFDJpK76q9HKKQ==', '#0s5o#MnZXMJEJnCNCUWcuBQa70fBocibygzbcDUz9zUTXMUF/RJlX1iUajkF2uktEH4QcIMOGpuKsizlSerE54ClU1/yrRTs5IrQBkUqMVQ==*CgYIASAHKAESPgo8EgQfVBY+qFWnqQV5PU/rxI+JT8LtQcaEJz9EthphccyZmwfCv3d/y3N+fk1pqlxTkx0NiKvauXjnYSQPGgA=#1##', '$g6WSfSkp/uPIxIrvM6O2EzrayzLHWjaTD6etCAXVTT8=$GEaHXyX2HO0I1ayAKs6XlpCxWuqlmtgAxU5a9Pb5NGPhOKWx/7zRgXXmSQLyZu5TI690aT5l2ZM6+Plhn6xtjEwRYiWoLTp0PLkXLJfc1i8I*CgYIASAHKAESPgo8ukTsXWIcH5ZL4INPDVofBbpMryzEI+UnIUF2vDU86lQt1KTW6ddIkMZIbxhmPibolGEd52R6SYHf/a2mGgA=$1$$', '#qjkV8smCGuzbIHumJfVhm/oX#QVKWieMykUVeGZA8cyRxrKE+pRSa7JTtdg1d0W1poUY3J0JrvgFlfyj3PckVGdeYTgzFf91Hzt3ubNZtLCErkGLSfDSLEwfRZrCBAs7arhxmEh03lvHm*CgYIASAHKAESPgo8bm/A5AaRfjMMRL2Kg9F2ROS4OKTMpW5mviCJZLcOTZZPRR59mDty2oDBGscesLqBNliR38KqWKaZwWzzGgA=#1##', 1760081521, '[]', NULL, '备货中', '西*', '1**********', '*******', '山东省', '37', '济南市', '370100', '历城区', '370112', '郭店街道', '370112011', '#5Nabx2TQ8m4AKN4P6bIWu9c261+HQzaB/GLetqQr0OpWwuEPeFdwPFGRif0/rrzulAMv7ZeeMZeQZNIGbsPqI3XC6xJZdeHttpQNe+IJZ80EYttfxMxSdEIu+24sV0MD8E1y01ACdQ==', 0, 0, 0, 4, 4, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:08', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069128953040897, '6946838745846322814', NULL, '[]', NULL, '待发货', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '小店', '', '', NULL, '', '2025100822001424701428269279', 1759908675, 1759908690, 1759908690, 0, 1800, '1@#vZvRG5czZqelIdekWnQHc/ulW77cQRm1fXgqWeCuZ1VTKRyU8DlLKFDJpK76q9HKKQ==', '#0s5o#vi32cmBgqhUjSIW+Bu329X+QXG+p0kxa6zEIZy8QUyEt7gH8ItqUzh2KEwSy5m/xb1jS63tJ8rlxkgSPyAHn0R8AiZMxsJpbiWLOug==*CgYIASAHKAESPgo8tPbHSvhFFKNfR8LZspIySWCTAjhUXtTOk8W4UHQSrpl3KJsLylpb7VP7QUmNsQsCqA7UOLIFFO/WTDinGgA=#1##', '$g6WSfSkp/uPIxIrvM6O2EzrayzLHWjaTD6etCAXVTT8=$Utt4M2Fnf1nkvIthNewU5S0KDOLHpNN7KLZOi7UsI5itIYMk1EOanbnupfgNcFWpo6J4alc1yIsFLEZY7HlYQ9RRjtnhrx0m0jenZZYhy2Lr*CgYIASAHKAESPgo8DQg6OXS79teWVNxT6QY9Wu9a2jC1G1ijeuKw+JI1SUul1IlVRJgHGSX6QJRESTIBJmtv7E8H1bTASvvDGgA=$1$$', '#qjkV8smCGuzbIHumJfVhm/oX#Cd6Db9Y5IqWLPv9d3QnG/3ezgrtp3+qGv3i7XyyILgXBRPRQfQwqqxy7sOwqM9IjZwGJ1Gjb16Kx/ldYepdoieEBuHkNrW53Lb04uY9AID1vWeMUwrWG*CgYIASAHKAESPgo8JskAeyPoNzg9bvdanxEHfl4mWHAaZTVkBt6eoEUKevcPLsmaZJKTWHSU8RgbN06gyJUwWtNyyahDUgfZGgA=#1##', 1759939199, '[]', NULL, '备货中', '西*', '1**********', '*******', '山东省', '37', '济南市', '370100', '历城区', '370112', '郭店街道', '370112011', '#EIEPxe4+Zg/zJzZtdodziohW4bIkePpLCajvmhxmTqB8BTTWgo+ikOkKJnD/oKN1Iv0JH+2lcpLpaCH9DZ0PL+QXxcgZzqyZy6NFdm+9W3tA4k/jOHi3ol9uxPr7gx/0uzj0ZNMvfw==', 0, 0, 0, 10, 10, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:09', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069129338916866, '6946741365313902412', NULL, '[]', NULL, '已完成', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '小店', '', '', NULL, '', '2105012510050503240893349702', 1759626087, 1759626091, 1759906013, 1759626478, 1800, '1@#uTXncINdDuTHdTkTCNuIV8b8drr9+Z4BJj8+2g+2oCd9ptnFKmYXoGj0XFmar/N1AdRtrdt/', '#O+yfCwha#FMfSH8huI2YUZFon6Q0g3Cc8Mkolso03XEHlRPKz9CSKgT6uMxu+9Q8lPXIW1vjBz1spS0b8X/pugaP60BZiCAeRIvJXWaomsUMBAp6zzA==*CgYIASAHKAESPgo848Hu/lmSHEMDLGyM4hpNG0tQBTQsnUr04QYsulfYbePV3hkjQQJYnmlfYySYtRh52VBLikqqqHiEE8O6GgA=#1##', '$jzutmQqBDJyfo27HRA3bg4mpahpeDImjeYLA0XvYrR4=$VYJEruQlvgmL5oUljsmQDI4JoLCeq/wBIWKB33g3se0T7p5WTMIblUFSz2v/0eMGAWTaHxmimYbMgE1hQJdwzSG1hWQt5DcPGYKk4zyRO3k4*CgYIASAHKAESPgo8qadVEJ++b6j6dNPOTV59EDpoCT9ZiPP1ivcoEwta+5z1YaIqRZqv9MA86H/6E3EXYK3dVB3yi1Q5CJMCGgA=$1$$', '#r5EtJst2XYO95dtOwjdG6fan/VbFFEBLmn79lwD3AUFtI8wmuAOgRjFb#AmVjo++kpDVsNAYcG6eM39QF+NDVcz1ejsOv7ozH35s2DH1eHOl+Jyzw2vmN5JfHlENWMjxJsXdsVdnUbcpCN9w5fGybIPEHxeq0Hj6o2JmTHVUtLUu9QPbc+UlhunIG30pCoNyaQAjSWCn/dIPT*CgYIASAHKAESPgo861fN4lh8/r0IKNPgYXAv0xjFSnC0WFYWD1gJ0Fxfs1XTGzjgbhTlSknEKiWUdj1XZ0c/8VsSmda88qHAGgA=#1##', 1759798891, '[{\"company\":\"zhongtong\",\"company_name\":\"中通快递\",\"delivery_id\":\"147165111650997915\",\"guarantee_amount\":0,\"hour_up_pickup_code\":\"\",\"product_info\":[{\"outer_sku_id\":\"\",\"price\":1,\"product_count\":1,\"product_id\":3704250147174219802,\"product_id_str\":\"3704250147174219802\",\"product_name\":\"通用气质针织春夏收腰欧美法式潮流短款外套\",\"sku_id\":3415147054561794,\"sku_order_id\":\"6946741365313902412\",\"sku_specs\":[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"XS\"}]}],\"ship_time\":1759626448,\"sp_discount_price\":0,\"sp_price\":0,\"sp_total_price\":0,\"tracking_no\":\"76747265936001\"}]', NULL, '正向已收货', '赵*', '1**********', '***************', '河北省', '13', '石家庄市', '130100', '新华区', '130105', '北苑街道', '130105012', '#IPyJHAux6BPlNVrhPWQ47Xbf2hPxRLFzQPHxKQPa4M6OLpaQpuWXoVO3IosuPfbkIQx3i1tnSZa6Yn/RLRhO19S/S6ORIVWgXLAvg7MPN08HBVxjovvSCijuWNWcbf+9sqwkc+c6NQ==', 0, 0, 0, 1, 1, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1759626448, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:09', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069129666072578, '6946749688160786252', NULL, '[]', NULL, '已发货', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '小店', '', 'zsj3012：4787864244574781326^_^采购金额：48.72^_^利润：-48.71^_^利润：-4871.00^_^上家：空空 品质 生活女装', NULL, '', '2105012510050503236252146188', 1759616707, 1759616713, 1759905871, 0, 1800, '1@#uTXncINdDuTHdTkTCNuIV8b8drr9+Z4BJj8+2g+2oCd9ptnFKmYXoGj0XFmar/N1AdRtrdt/', '#O+yfCwha#mJ2ssj6ZM3azsHFDFTcAWEQVCeHTIoU1PiSQfKiHJ/19jIOFLFq1Pp2xvHaRMyVtyqDc6/sMblqFkgysUv9rgfJGH9HKlJ5cVageX7WHXA==*CgYIASAHKAESPgo8HG01bmNXzInIc+5q8SfT/0m1dnkviNIPY2GEYxsyDxUpoUQlLGjcV4Lccm8pEBzcpFNd4Fpq+8sUlv/7GgA=#1##', '$jzutmQqBDJyfo27HRA3bg4mpahpeDImjeYLA0XvYrR4=$FsThLPMVEhn2TfSrOF93hhdLVO9dw890gDgV0NMVzbLpKSgfKKaLzUHHmTGRt7xDRUUftneVBMP4wxzzmf1zWO3BI6O/e1htIv8kT+yIibeM*CgYIASAHKAESPgo8IwUjme6ObiiosBSWuQoHajTCqim1s2kwJiCD9GQf5hed3NQqprPquK9ZfRUJsDNSfiH7OUvztq+Cow84GgA=$1$$', '#r5EtJst2XYO95dtOwjdG6fan/VbFFEBLmn79lwD3AUFtI8wmuAOgRjFb#gbVlRNGTesoI2aYgnfdgM/jeCW+D4+B+cC8xHfvVMzFTAZxgbNjwFEEq0I+W6nRANNuNOX8+qYrSxNsYDPjY0yN5fEzQ2dp1qIhZBq0why7VrKLw+iBwKXNuzaiut5uFEDzj7NNy/sHqZB0J0eZ1*CgYIASAHKAESPgo8VZUJ5OCREdLghxp6qg4NLU80EyfxFNkw5Okaoi8hhzoDCdXmXP90xMQMZgBWWm2b38n8/eGB1evSXOPuGgA=#1##', 1759789513, '[{\"company\":\"youzhengguonei\",\"company_name\":\"邮政快递包裹\",\"delivery_id\":\"147165063365149440\",\"guarantee_amount\":0,\"hour_up_pickup_code\":\"\",\"product_info\":[{\"outer_sku_id\":\"\",\"price\":1,\"product_count\":1,\"product_id\":3704250147174219802,\"product_id_str\":\"3704250147174219802\",\"product_name\":\"通用气质针织春夏收腰欧美法式潮流短款外套\",\"sku_id\":3415147054561794,\"sku_order_id\":\"6946749688160786252\",\"sku_specs\":[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"XS\"}]}],\"ship_time\":1759623590,\"sp_discount_price\":0,\"sp_price\":0,\"sp_total_price\":0,\"tracking_no\":\"9473794738333\"}]', NULL, '已全部发货', '赵*', '1**********', '***************', '河北省', '13', '石家庄市', '130100', '新华区', '130105', '北苑街道', '130105012', '#IPyJHAux6BPlNVrhPWQ47Xbf2hPxRLFzQPHxKQPa4M6OLpaQpuWXoVO3IosuPfbkIQx3i1tnSZa6Yn/RLRhO19S/S6ORIVWgXLAvg7MPN08HBVxjovvSCijuWNWcbf+9sqwkc+c6NQ==', 0, 0, 0, 1, 1, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1759623590, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:09', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069129984839682, '6946632778593933132', NULL, '[]', NULL, '已完成', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '小店', '', '测试-09，15，2025，15，18871068615，147157939640448285，申通快递，773376786936820；通用气质针织春夏收腰欧美法式潮流短款外套，BY9961_250，BY9961_250，SIDJQ1D，1', NULL, '', '2105012509300503082918698120', 1759197721, 1759197725, 1759905818, 1759199178, 1800, '1@#uTXncINdDuTHdTkTCNuIV8b8drr9+Z4BJj8+2g+2oCd9ptnFKmYXoGj0XFmar/N1AdRtrdt/', '#O+yfCwha#8iDb6eAuvEmqwBz23v5Yo/BmMcnJJcT+dLy9kcL2bX7KWYPd+puWsOX/zl0thGAjSIjUuV/JJGP5X+tRkqJaGSaUUnYmfo2rbqyAoLdEiw==*CgYIASAHKAESPgo8uTDmDXNapqJnzX0ptKDAgQ+6OB53P3MaJ5MgzleKLSFizEy+dOewPcBJEogs00bg44/lH4yd6AN8Wfq3GgA=#1##', '$jzutmQqBDJyfo27HRA3bg4mpahpeDImjeYLA0XvYrR4=$lnSVs+W9h+qLG8+d22gE7W3l5VE48YE3W2Z7Fdxman0MrDQsruoBsxGvmWbEGmIMSEKBpDrFnCMCm1dE0xxCxcjqa3HRktrzMJnJXhvJQ2CT*CgYIASAHKAESPgo85nZMS3HeTxdKaE/iANPifN0vDY/jnfbEy9c0v7m7Dh5helhwMMR4Aa0+v9+KW44oO6glLYu+J/Bru5d0GgA=$1$$', '#r5EtJst2XYO95dtOwjdG6fan/VbFFEBLmn79lwD3AUFtI8wmuAOgRjFb#zHDKHzjLlIkB/9/FflTJ5p7st/LVV2Ed9LTGSO/TR0nkq18QUXqEtXZ+9pyxGOlxOkkC/ZHK57u0+JoDBeOI8Jsi40nnItW9Tl0bVhF7aubA6wIg6F1/PGyDalogF7ecv/CisWMdUlPYKcUvuc7Q*CgYIASAHKAESPgo89M8fohESJ3AaSX65rB9WhNj/Cl44MSvh9Mlite6icJJSAEWDhAQDrqeCELrCZqf2c2zq5uTWdMSzUOIPGgA=#1##', 1759370525, '[{\"company\":\"youzhengguonei\",\"company_name\":\"邮政快递包裹\",\"delivery_id\":\"147157923616240158\",\"guarantee_amount\":0,\"hour_up_pickup_code\":\"\",\"product_info\":[{\"outer_sku_id\":\"\",\"price\":1,\"product_count\":1,\"product_id\":3704250147174219802,\"product_id_str\":\"3704250147174219802\",\"product_name\":\"通用气质针织春夏收腰欧美法式潮流短款外套\",\"sku_id\":3415147054561794,\"sku_order_id\":\"6946632778593933132\",\"sku_specs\":[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"XS\"}]}],\"ship_time\":1759198001,\"sp_discount_price\":0,\"sp_price\":0,\"sp_total_price\":0,\"tracking_no\":\"9441930538033\"}]', NULL, '收货后退款完成', '赵*', '1**********', '***************', '河北省', '13', '石家庄市', '130100', '新华区', '130105', '北苑街道', '130105012', '#IPyJHAux6BPlNVrhPWQ47Xbf2hPxRLFzQPHxKQPa4M6OLpaQpuWXoVO3IosuPfbkIQx3i1tnSZa6Yn/RLRhO19S/S6ORIVWgXLAvg7MPN08HBVxjovvSCijuWNWcbf+9sqwkc+c6NQ==', 0, 0, 0, 1, 1, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1759198001, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:09', NULL, 0, NULL, 0, NULL, NULL);
INSERT INTO `oms_dou_order` (`id`, `order_id`, `order_level`, `order_phase_list`, `order_status`, `order_status_desc`, `order_tag`, `order_type`, `order_type_desc`, `app_id`, `open_id`, `accept_order_status`, `appointment_ship_time`, `author_cost_amount`, `aweme_id`, `b_type`, `b_type_desc`, `sub_b_type`, `sub_b_type_desc`, `biz`, `biz_desc`, `buyer_words`, `seller_words`, `seller_remark_stars`, `cancel_reason`, `channel_payment_no`, `create_time`, `pay_time`, `update_time`, `finish_time`, `order_expire_time`, `doudian_open_id`, `encrypt_post_receiver`, `encrypt_post_tel`, `encrypt_post_address`, `exp_ship_time`, `logistics_info`, `main_status`, `main_status_desc`, `mask_post_receiver`, `mask_post_tel`, `mask_post_address`, `province_name`, `province_id`, `city_name`, `city_id`, `town_name`, `town_id`, `street_name`, `street_id`, `open_address_id`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `pay_type`, `post_amount`, `post_insurance_amount`, `post_origin_amount`, `post_promotion_amount`, `promotion_amount`, `promotion_pay_amount`, `promotion_platform_amount`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `promotion_shop_amount`, `promotion_talent_amount`, `ship_time`, `shop_cost_amount`, `platform_cost_amount`, `shop_id`, `shop_name`, `total_promotion_amount`, `user_tag_ui`, `s_shop_id`, `pull_time`, `last_pull_time`, `audit_status`, `audit_time`, `oms_push_status`, `oms_push_result`, `oms_push_time`) VALUES (1976069130370715650, '6946814493599274622', NULL, '[]', NULL, '待发货', NULL, NULL, '普通订单', NULL, '', NULL, 0, NULL, '', NULL, '抖音', NULL, 'H5', NULL, '小店', '', '', NULL, '', '2025100822001424701427322849', 1759905692, 1759905701, 1759905703, 0, 1800, '1@#vZvRG5czZqelIdekWnQHc/ulW77cQRm1fXgqWeCuZ1VTKRyU8DlLKFDJpK76q9HKKQ==', '#K3Yi#Ov/Xycza1kAWPqBVQXwXj5yG4E8jdBx+Y6uG7URuPAEKK4ruEKz777LDZghccO5fazoZWmNmET7/3rHS6dShUpF9Xl881NddH0U8XA==*CgYIASAHKAESPgo8sXxYlG1oXSq/Y9xrEOOzo6//GSzcjtWWV+DoKf3+M6PAmr2kilgJ4SmMuwizAqUzuBqBSrMtcS16t+oYGgA=#1##', '$yTgI96gZ4gwfM/tyxIz4E5B6xxAr3FqNXvRMSAwCUmw=$y0DQSjg1GszDwcaoLpm5pw+2yCxooRuBHoRn3PlqwLbjrl8ROnlYFdum8H6F/QfKoXgFPfSOXOMNQLKaTZYxt5w3ZzMnztHM02zFBDrUuWI1*CgYIASAHKAESPgo85db9ZS0ik3OziGuA+llwsdipA2lcBaaXEBBOlg9TDnAQM9m2rLPghkCe6cOAh/udMm0LUa/3wYm2L9RAGgA=$1$$', '#v1zGP9CIy9zBLW43HKcLA8VBFZbmW5mRQzAUFY109LzXIDc2NCRRGf6uWhj4jBtMmqlqEmCe#Wqi/lgTRzS2UYof2L6lxrStO0tHA5vX+MOa+8pf72L5oskhzcCPzKZZCV53vr48ZhXz8vVu6S95jOWzFWTFNJWyASJ5rFYMTrGaSof6HZhHAFNhkV96bdxw06wDsc5EhEvxwx1ld6h9VTDdVe2+u2NNGcDc8wnv+nQ==*CgYIASAHKAESPgo8KU1zcKzk+O8a/zmTGyb5DFrGZ9qhiTP5u5oaX+gUFYGqF5jI1Tw0EmVDu7m0UUDHGSYv5YDk+o1TsVWtGgA=#1##', 1760078502, '[]', NULL, '备货中', '张*', '1**********', '*******************', '山东省', '37', '威海市', '371000', '环翠区', '371002', '怡园街道', '371002004', '#oqzqZ6Bf3xRTJ9KDpYhn06eaoASVaJNFl71rl2MdIl+UQHx/7gdiyZkLHUNzOv5NZGJnsrM1dKOfHkAobXy5ePaL8C+zsvB3XzATgYynO6TZ2BFun49QlW/F/ATOZvfB1vMrZBMAgA==', 0, 0, 0, 14, 14, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1010, '开放平台测试专用店', 0, NULL, NULL, '2025-10-09 07:36:09', NULL, 0, NULL, 0, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for oms_dou_order_item
-- ----------------------------
DROP TABLE IF EXISTS `oms_dou_order_item`;
CREATE TABLE `oms_dou_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '店铺子订单号，抖店平台生成，平台下唯一；注意：一笔订单下有一个子订单和父订单单号相同。',
  `parent_order_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '店铺父订单号，抖店平台生成，平台下唯一；',
  `order_level` int DEFAULT NULL COMMENT '订单层级',
  `ad_env_type` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '广告来源，video-短视频 live-直播',
  `after_sale_status` int DEFAULT NULL COMMENT '售后状态；6-售后申请；27-拒绝售后申请；12-售后成功；7-售后退货中；11-售后已发货；29-售后退货拒绝；13-【换货返回：换货售后换货商家发货】，【补寄返回：补寄待用户收货】； 14-【换货返回：（换货）售后换货用户收货】，【补寄返回：（补寄）用户已收货】 ；28-售后失败；51-订单取消成功；53-逆向交易已完成；',
  `after_sale_type` int DEFAULT NULL COMMENT '售后类型 ；0-退货退款;1-已发货仅退款;2-未发货仅退款;3-换货;4-系统取消;5-用户取消;6-价保;7-补寄;',
  `refund_status` int DEFAULT NULL COMMENT '退款状态:1-待退款；3-退款成功； 4-退款失败；当买家发起售后后又主动取消售后，此时after_sale_status=28并且refund_status=1的状态不变，不会流转至4状态；',
  `author_cost_amount` int DEFAULT NULL COMMENT '作者（达人）承担金额（单位：分），订单参与活动和优惠中作者（达人）承担部分的总金额',
  `author_id` bigint DEFAULT NULL COMMENT '直播主播id（达人）;仅直播间和橱窗产生的订单会有值返回;',
  `author_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '直播主播名称;仅直播间和橱窗产生的订单会有值返回',
  `c_biz` int DEFAULT NULL COMMENT '【C端流量来源】 0-unknown 2-精选联盟 8-小店自卖',
  `c_biz_desc` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'C端流量来源业务类型描述',
  `cancel_reason` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '\r\n取消原因',
  `channel_payment_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付渠道的流水号',
  `code` varchar(88) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家后台商品编码',
  `confirm_receipt_time` int DEFAULT NULL COMMENT '用户确认收货时间',
  `finish_time` int DEFAULT NULL COMMENT '订单完成时间，时间戳，秒',
  `goods_price` int DEFAULT NULL COMMENT '\r\n商品原价（单位：分）',
  `goods_type` int DEFAULT NULL COMMENT '【商品类型】 0-实体 1-虚拟',
  `is_comment` int DEFAULT NULL COMMENT '\r\n是否评价 :1-已评价，0-未评价，2 -追评',
  `item_num` int DEFAULT NULL COMMENT '订单商品数量',
  `logistics_receipt_time` int DEFAULT NULL COMMENT '物流收货时间 ',
  `modify_amount` int DEFAULT NULL COMMENT '\r\n改价金额变化量（单位：分）',
  `modify_post_amount` int DEFAULT NULL COMMENT '改价运费金额变化量（单位：分）',
  `only_platform_cost_amount` int DEFAULT NULL COMMENT '仅平台承担金额（单位：分），订单参与活动和优惠中平台承担部分的总金额',
  `order_amount` int DEFAULT NULL COMMENT '订单金额（单位：分）',
  `pay_amount` int DEFAULT NULL COMMENT '支付金额（单位：分）',
  `post_insurance_amount` int DEFAULT NULL COMMENT '运费险金额（单位：分）',
  `promotion_amount` int DEFAULT NULL COMMENT '订单优惠总金额（单位：分） = 店铺优惠金额 + 平台优惠金额 + 达人优惠金额',
  `promotion_shop_amount` int DEFAULT NULL COMMENT '店铺优惠金额（单位：分），属于店铺的优惠活动、优惠券、红包的总优惠金额',
  `promotion_platform_amount` int DEFAULT NULL COMMENT '平台优惠金额（单位：分），属于平台的优惠活动、优惠券、红包的总优惠金额',
  `shop_cost_amount` int DEFAULT NULL COMMENT '商家承担金额（单位：分），订单参与活动和优惠中商家承担部分的总金额',
  `platform_cost_amount` int DEFAULT NULL COMMENT '平台承担金额（单位：分），订单参与活动和优惠中平台+作者（达人）承担部分的总金额,包含作者（达人）承担金额：platform_cost_amount = only_platform_cost_amount + author_cost_amount',
  `promotion_talent_amount` int DEFAULT NULL COMMENT '达人优惠金额（单位：分），属于达人的优惠活动、优惠券、红包的总优惠金额',
  `promotion_pay_amount` int DEFAULT NULL COMMENT '支付优惠金额（单位：分），支付渠道上的优惠金额',
  `origin_amount` int DEFAULT NULL COMMENT '商品现价（单位：分）',
  `out_product_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品外部编码',
  `out_sku_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '外部Skuid',
  `product_id` bigint DEFAULT NULL COMMENT '商品ID',
  `sku_id` bigint DEFAULT NULL COMMENT '商品skuId',
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `product_pic` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品图片',
  `promotion_redpack_amount` int DEFAULT NULL COMMENT '平台优惠金额（单位：分），属于平台的优惠活动、优惠券、红包的总优惠金额',
  `promotion_redpack_platform_amount` int DEFAULT NULL COMMENT '平台红包优惠金额（单位：分），属于平台的红包的优惠金额',
  `promotion_redpack_talent_amount` int DEFAULT NULL COMMENT '达人红包优惠金额（单位：分），属于达人的红包的优惠金额',
  `room_id` bigint DEFAULT NULL COMMENT '直播间id，有值则代表订单来自直播间',
  `ship_time` int DEFAULT NULL COMMENT '\r\n发货时间',
  `spec` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '规格信息JSON',
  `theme_type_desc` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '下单来源描述（废弃）',
  `update_time` int DEFAULT NULL COMMENT '订单更新时间，时间戳，秒',
  `create_time` int DEFAULT NULL COMMENT '下单时间，时间戳，秒',
  `video_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '视频id，有值则代表订单来自短视频video_id',
  `o_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `order_id_index` (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1976069130433630211 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='抖店订单明细表';

-- ----------------------------
-- Records of oms_dou_order_item
-- ----------------------------
BEGIN;
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069120505712641, '6946855202206389414', '6946855202206389414', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2105012510080503368182858831', 'EE6262_510', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3704250147174219802, 3415147054562306, '通用气质针织春夏收腰欧美法式潮流短款外套', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/ALSUvYM_m_6b2c63f75ace689f2e1b03224ce5fd7e_sx_27680_www600-600', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"M\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069120505712642, '6946855202206454950', '6946855202206389414', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2105012510080503368182858831', 'BY9961_250', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3704250147174219802, 3415147054561794, '通用气质针织春夏收腰欧美法式潮流短款外套', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/ALSUvYM_m_6b2c63f75ace689f2e1b03224ce5fd7e_sx_27680_www600-600', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"XS\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069120895782913, '6946833213743895718', '6946833213743895718', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2105012510080503367978540506', 'EE6262_510', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3704250147174219802, 3415147054562306, '通用气质针织春夏收腰欧美法式潮流短款外套', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/ALSUvYM_m_6b2c63f75ace689f2e1b03224ce5fd7e_sx_27680_www600-600', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"M\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069121151635459, '6946852810251244710', '6946852810251244710', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2105012510080503367713143617', 'DU0404_680', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3704250147174219802, 3415147054563330, '通用气质针织春夏收腰欧美法式潮流短款外套', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/ALSUvYM_m_6b2c63f75ace689f2e1b03224ce5fd7e_sx_27680_www600-600', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"150/60A\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069121151635460, '6946852810251310246', '6946852810251244710', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2105012510080503367713143617', 'DU0404_690', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3704250147174219802, 3415147054562818, '通用气质针织春夏收腰欧美法式潮流短款外套', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/ALSUvYM_m_6b2c63f75ace689f2e1b03224ce5fd7e_sx_27680_www600-600', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"XL\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069121218744321, '6946852810251375782', '6946852810251244710', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2105012510080503367713143617', 'BY9961_250', NULL, NULL, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3704250147174219802, 3415147054561794, '通用气质针织春夏收腰欧美法式潮流短款外套', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/ALSUvYM_m_6b2c63f75ace689f2e1b03224ce5fd7e_sx_27680_www600-600', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"XS\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069121604620291, '6946819380690621606', '6946819380690621606', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2105012510080503362887270840', 'BY9961_250', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3704250147174219802, 3415147054561794, '通用气质针织春夏收腰欧美法式潮流短款外套', 'https://p9-aio.ecombdimg.com/obj/ecom-shop-material/ALSUvYM_m_6b2c63f75ace689f2e1b03224ce5fd7e_sx_27680_www600-600', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"XS\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069121868861442, '6946617941468648709', '6946617941468648709', NULL, '', 12, 0, 3, NULL, NULL, '', NULL, '小店自卖', '', '2025092922001476781407413226', 'BY9961_250', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3704250147174219802, 3415147054561794, '通用气质针织春夏收腰欧美法式潮流短款外套', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/ALSUvYM_m_6b2c63f75ace689f2e1b03224ce5fd7e_sx_27680_www600-600', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"XS\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069122321846273, '6946823916925425563', '6946823916925425563', NULL, '', 12, 2, 3, NULL, NULL, '', NULL, '精选联盟', '', '2025100822001450841452459994', '', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3777109040660873455, 3562453809082626, '【测试商品勿拍】爬藤架阳台花架支撑架植物盆栽花卉造型支撑杆固', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/jpeg_m_951d3319a249e391ec8bac98005be98d_sx_83544_www1920-1920', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"规格\",\"value\":\"1号-17cm\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069122644807682, '6946821219953022875', '6946821219953022875', NULL, '', 12, 2, 3, NULL, NULL, '', NULL, '精选联盟', '', '2025100822001450841451582591', '', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3777109040660873455, 3562453809082626, '【测试商品勿拍】爬藤架阳台花架支撑架植物盆栽花卉造型支撑杆固', 'https://p9-aio.ecombdimg.com/obj/ecom-shop-material/jpeg_m_951d3319a249e391ec8bac98005be98d_sx_83544_www1920-1920', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"规格\",\"value\":\"1号-17cm\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069122967769091, '6946838791950112063', '6946838791950112063', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2105012510080503353383706431', '', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3777107498583064805, 3562504012050690, '【测试商品勿拍】跨境出口推剪梳男士造型平头梳弧形推边理发梳渐', 'https://p9-aio.ecombdimg.com/obj/ecom-shop-material/jpeg_m_53024dd8edf8a9a08557a992c901185e_sx_49873_www800-800', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"颜色分类\",\"value\":\"新款/灰色\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069123286536193, '6946629275321439680', '6946629275321439680', NULL, '', 12, 0, 3, NULL, NULL, '', NULL, '小店自卖', '', '2105012509290502756781920716', '12', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3699778895269200035, 3412261091365122, '5000万+收藏碎花裙子蕾丝显瘦修身包臀裙半身裙大田', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/v1_ALSUvYM_70630259408755264040798_16991a88a61d1a1f4ab8bc526fcb7762_sx_388998_www800-800', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"颜色分类\",\"value\":\"白色\"},{\"name\":\"尺码大小\",\"value\":\"XL\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069124196700162, '6921602341082267246', '6921602341082267246', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2025100722001478581410588803', '', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3779202820029415669, 3571826389225986, '【测试商品勿拍】玩转PPT，制作发布会级PPT', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/png_m_aa547ca3ed253f57c278411d66e4c144_sx_469512_www960-960', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"套餐类型\",\"value\":\"标准版课程\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069124586770434, '6921639186009783565', '6921639186009783565', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2025100822001454231405544199', '', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3779202820029415669, 3571826389225986, '【测试商品勿拍】玩转PPT，制作发布会级PPT', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/png_m_aa547ca3ed253f57c278411d66e4c144_sx_469512_www960-960', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"套餐类型\",\"value\":\"标准版课程\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069125949919234, '6921639306983341325', '6921639306983341325', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2025100822001454231409941268', '', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3779202820029415669, 3571826389225986, '【测试商品勿拍】玩转PPT，制作发布会级PPT', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/png_m_aa547ca3ed253f57c278411d66e4c144_sx_469512_www960-960', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"套餐类型\",\"value\":\"标准版课程\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069126474207233, '6921627853996326157', '6921627853996326157', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2025100822001454231405650025', '', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3779202820029415669, 3571826389225986, '【测试商品勿拍】玩转PPT，制作发布会级PPT', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/png_m_aa547ca3ed253f57c278411d66e4c144_sx_469512_www960-960', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"套餐类型\",\"value\":\"标准版课程\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069127652806657, '6946619869083932541', '6946619869083932541', NULL, '', 28, 7, 0, NULL, NULL, '', NULL, '小店自卖', '', '2105012509290503063794163541', '12', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3699778895269200035, 3412261091365122, '5000万+收藏碎花裙子蕾丝显瘦修身包臀裙半身裙大田', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/v1_ALSUvYM_70630259408755264040798_16991a88a61d1a1f4ab8bc526fcb7762_sx_388998_www800-800', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"颜色分类\",\"value\":\"白色\"},{\"name\":\"尺码大小\",\"value\":\"XL\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069128172900354, '6946818969975199358', '6946818969975199358', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2105012510080503354191159085', '', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3777108396298338603, 3562349463705858, '【测试商品勿拍】圣诞节塑料帽子 雪人帽魔术师高顶礼帽 三款规格', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/jpeg_m_ef755b8ea6da0cbd86b7e052880fde4a_sx_81102_www800-800', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"规格\",\"value\":\"2.3*1.6cm粉红色小帽\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069129015955457, '6946838745846322814', '6946838745846322814', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2025100822001424701428269279', 'SIOECHOY000000006/00', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3776985319715504145, 3561759867195906, '【测试商品勿拍】养车式_粉色波点吊带连衣裙子组合商品', 'https://p9-aio.ecombdimg.com/obj/ecom-shop-material/jpeg_m_6e81220e4cc8108c6619174f5ae353e3_sx_979970_www1440-1440', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"尺码大小\",\"value\":\"M\"},{\"name\":\"颜色分类\",\"value\":\"红色\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069129338916867, '6946741365313902412', '6946741365313902412', NULL, '', 7, 0, 1, NULL, NULL, '', NULL, '小店自卖', '', '2105012510050503240893349702', 'BY9961_250', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3704250147174219802, 3415147054561794, '通用气质针织春夏收腰欧美法式潮流短款外套', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/ALSUvYM_m_6b2c63f75ace689f2e1b03224ce5fd7e_sx_27680_www600-600', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"XS\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069129666072579, '6946749688160786252', '6946749688160786252', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2105012510050503236252146188', 'BY9961_250', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3704250147174219802, 3415147054561794, '通用气质针织春夏收腰欧美法式潮流短款外套', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/ALSUvYM_m_6b2c63f75ace689f2e1b03224ce5fd7e_sx_27680_www600-600', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"XS\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069129984839683, '6946632778593933132', '6946632778593933132', NULL, '', 12, 0, 3, NULL, NULL, '', NULL, '小店自卖', '', '2105012509300503082918698120', 'BY9961_250', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3704250147174219802, 3415147054561794, '通用气质针织春夏收腰欧美法式潮流短款外套', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/ALSUvYM_m_6b2c63f75ace689f2e1b03224ce5fd7e_sx_27680_www600-600', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"颜色分类\",\"value\":\"乳白色22234\"},{\"name\":\"尺码大小\",\"value\":\"XS\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069130370715651, '6946814493599274622', '6946814493599274622', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2025100822001424701427322849', '', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3777108396298338603, 3562349463705602, '【测试商品勿拍】圣诞节塑料帽子 雪人帽魔术师高顶礼帽 三款规格', 'https://p9-aio.ecombdimg.com/obj/ecom-shop-material/jpeg_m_ef755b8ea6da0cbd86b7e052880fde4a_sx_81102_www800-800', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"规格\",\"value\":\"黑色2.3*1.6cm小帽\"}]', '-', NULL, NULL, '', NULL, NULL);
INSERT INTO `oms_dou_order_item` (`id`, `order_id`, `parent_order_id`, `order_level`, `ad_env_type`, `after_sale_status`, `after_sale_type`, `refund_status`, `author_cost_amount`, `author_id`, `author_name`, `c_biz`, `c_biz_desc`, `cancel_reason`, `channel_payment_no`, `code`, `confirm_receipt_time`, `finish_time`, `goods_price`, `goods_type`, `is_comment`, `item_num`, `logistics_receipt_time`, `modify_amount`, `modify_post_amount`, `only_platform_cost_amount`, `order_amount`, `pay_amount`, `post_insurance_amount`, `promotion_amount`, `promotion_shop_amount`, `promotion_platform_amount`, `shop_cost_amount`, `platform_cost_amount`, `promotion_talent_amount`, `promotion_pay_amount`, `origin_amount`, `out_product_id`, `out_sku_id`, `product_id`, `sku_id`, `product_name`, `product_pic`, `promotion_redpack_amount`, `promotion_redpack_platform_amount`, `promotion_redpack_talent_amount`, `room_id`, `ship_time`, `spec`, `theme_type_desc`, `update_time`, `create_time`, `video_id`, `o_goods_id`, `o_goods_sku_id`) VALUES (1976069130433630210, '6946814493599340158', '6946814493599274622', NULL, '', 0, 0, 0, NULL, NULL, '', NULL, '小店自卖', '', '2025100822001424701427322849', 'SIOECHOY000000006/00', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '', 3776985319715504145, 3561759867195906, '【测试商品勿拍】养车式_粉色波点吊带连衣裙子组合商品', 'https://p3-aio.ecombdimg.com/obj/ecom-shop-material/jpeg_m_6e81220e4cc8108c6619174f5ae353e3_sx_979970_www1440-1440', NULL, NULL, NULL, NULL, NULL, '[{\"name\":\"尺码大小\",\"value\":\"M\"},{\"name\":\"颜色分类\",\"value\":\"红色\"}]', '-', NULL, NULL, '', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for oms_dou_refund
-- ----------------------------
DROP TABLE IF EXISTS `oms_dou_refund`;
CREATE TABLE `oms_dou_refund` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '售后订单id，自增',
  `shop_id` bigint NOT NULL COMMENT '订单所属商户id',
  `aftersale_id` bigint NOT NULL DEFAULT '0' COMMENT '售后id',
  `aftersale_order_type` bigint DEFAULT NULL COMMENT '售后订单类型，枚举为-1(历史订单),1(商品单),2(店铺单)',
  `aftersale_type` bigint NOT NULL COMMENT '售后类型；0-退货退款；1-已发货仅退款；2-未发货仅退款；3-换货；6-价保；7-补寄；8-维修',
  `aftersale_status` bigint NOT NULL COMMENT '售后状态和请求参数standard_aftersale_status字段对应；3-换货待买家收货；6-待商家同意；7-待买家退货；8-待商家发货；11-待商家二次同意；12-售后成功；14-换货成功；27-商家一次拒绝；28-售后失败；29-商家二次拒绝；',
  `aftersale_status_to_final_time` bigint DEFAULT NULL COMMENT '售后完结时间，完结时间是平台根据商品的类型，售后状态等综合判断生成，当售后单有完结时间返回时售后单不可再做任何操作；未完结售后单的该字段值为0；Unix时间戳：秒',
  `related_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '\r\n关联的订单ID',
  `order_sku_order_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '抖音子订单id',
  `order_status` bigint DEFAULT NULL COMMENT '订单状态',
  `order_pay_amount` bigint DEFAULT NULL COMMENT '付款金额',
  `order_post_amount` bigint DEFAULT NULL COMMENT '\r\n付运费金额',
  `order_item_num` bigint DEFAULT NULL COMMENT '购买数量',
  `order_product_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名',
  `order_product_image` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品图片',
  `order_product_id` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品id',
  `order_sku_spec` varchar(550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品规格JSON',
  `order_shop_sku_code` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家SKU编码',
  `apply_time` bigint DEFAULT NULL COMMENT '申请时间',
  `update_time` bigint DEFAULT NULL COMMENT '最近更新时间',
  `status_deadline` bigint DEFAULT NULL COMMENT '当前节点逾期时间',
  `refund_amount` bigint DEFAULT NULL COMMENT '售后退款金额，单位为分',
  `refund_post_amount` bigint DEFAULT NULL COMMENT '售后退运费金额，单位为分',
  `aftersale_num` bigint DEFAULT NULL COMMENT '\r\n售后数量',
  `part_type` bigint DEFAULT NULL COMMENT '部分退类型',
  `aftersale_refund_type` bigint DEFAULT NULL COMMENT '售后退款类型，枚举为-1(历史数据默认值),0(订单货款/原路退款),1(货到付款线下退款),2(备用金),3(保证金),4(无需退款),5(平台垫付)',
  `refund_type` bigint DEFAULT NULL COMMENT '退款方式，枚举为1(极速退款助手)、2(售后小助手)、3(售后急速退)、4(闪电退货)',
  `arbitrate_status` bigint DEFAULT NULL COMMENT '仲裁状态，枚举为0(无仲裁记录),1(仲裁中),2(客服同意),3(客服拒绝),4(待商家举证),5(协商期),255(仲裁结束)',
  `create_time` bigint DEFAULT NULL COMMENT '\r\n售后单创建时间',
  `risk_decision_reason` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '风控理由',
  `risk_decision_description` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '风控描述',
  `return_promotion_amount` bigint DEFAULT NULL COMMENT '退优惠金额',
  `refund_status` bigint DEFAULT NULL COMMENT '退款状态；1-待退款;2-退款中;3-退款成功;4-退款失败;5-追缴成功;',
  `arbitrate_blame` bigint DEFAULT NULL COMMENT '仲裁责任方 1:商家责任,2:买家责任,3:双方有责,4:平台责任,5:达人责任',
  `return_logistics_code` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退货物流单号',
  `return_logistics_company_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退货物流公司名称',
  `exchange_sku_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '换货SKU信息JSON',
  `exchange_logistics_company_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '换货物流公司名称',
  `remark` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `got_pkg` bigint DEFAULT NULL COMMENT '买家是否收到货物，0表示未收到，1表示收到',
  `is_agree_refuse_sign` bigint DEFAULT NULL COMMENT '是否拒签后退款（1：已同意拒签, 2：未同意拒签）',
  `order_logistics` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '商家首次发货的正向物流信息JSON',
  `aftersale_tags` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '售后标签（含时效延长、风险预警、豁免体验分等标签）标签在平台侧会有更新，标签仅做展示使用，请勿作为系统判断依赖。JSON',
  `aftersale_sub_type` bigint DEFAULT NULL COMMENT '售后子类型；8001-以换代修。',
  `auto_audit_bits` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '自动审核方式：1-发货前极速退；2-小助手自动同意退款；3-发货后极速退；4-闪电退货；5-跨境零秒退；6-云仓拦截自动退；7-小助手自动同意退货；8-小助手自动同意拒签后退款；9-商家代客填写卡片发起售后；10-治理未发货自动同意退款；11-治理已发货自动同意退款；12-商家快递拦截成功自动退款；13-质检商品免审核；14-协商方案自动同意退款；15-平台卡券自动同意退款；16-三方卡券自动同意退款；17-治理一审自动同意退货退款',
  `text_part` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '文案部分JSON',
  `related_order_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '售后关联的订单信息JSON',
  `pull_time` datetime DEFAULT NULL COMMENT '第一次拉取时间',
  `pull_last_time` datetime DEFAULT NULL COMMENT '最后一次拉取时间',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '抖音skuid',
  `o_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `aftersale_id_index` (`aftersale_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='抖店退款表';

-- ----------------------------
-- Records of oms_dou_refund
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_jd_goods
-- ----------------------------
DROP TABLE IF EXISTS `oms_jd_goods`;
CREATE TABLE `oms_jd_goods` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ware_id` bigint DEFAULT NULL COMMENT '商品id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `ware_status` int DEFAULT NULL COMMENT '商品状态 -1：删除 1:从未上架 2:自主下架 4:系统下架 8:上架 513:从未上架待审 514:自主下架待审 516:系统下架待审 520:上架待审核 1028:系统下架审核失败',
  `outer_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '	商品外部ID,商家自行设置的ID（便于关联京东商品）',
  `item_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品货号',
  `bar_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品的条形码.UPC码,SN码,PLU码统称为条形码',
  `modified` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品最后一次修改时间',
  `created` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品创建时间，只读属性',
  `offline_time` datetime DEFAULT NULL COMMENT '最后下架时间',
  `online_time` datetime DEFAULT NULL COMMENT '最后上架时间',
  `delivery` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货地',
  `pack_listing` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '包装清单',
  `wrap` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '包装规格',
  `weight` float DEFAULT NULL,
  `width` int DEFAULT NULL,
  `height` int DEFAULT NULL,
  `length` int DEFAULT NULL,
  `mobile_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `introduction` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `after_sales` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `market_price` decimal(10,2) DEFAULT NULL,
  `cost_price` decimal(10,2) DEFAULT NULL,
  `jd_price` decimal(10,2) DEFAULT NULL,
  `brand_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `stock_num` int DEFAULT NULL,
  `sell_point` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `after_sale_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `spu_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shop_id` bigint DEFAULT NULL COMMENT '店铺id（sys_shop表id）',
  `erp_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='京东商品表';

-- ----------------------------
-- Records of oms_jd_goods
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_jd_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `oms_jd_goods_sku`;
CREATE TABLE `oms_jd_goods_sku` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ware_id` bigint DEFAULT NULL COMMENT '平台商品id',
  `sku_id` bigint DEFAULT NULL,
  `status` int DEFAULT NULL,
  `jd_price` decimal(10,2) DEFAULT NULL,
  `outer_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bar_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sale_attrs` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `stock_num` int DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `currency_spu_id` varchar(0) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `erp_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `erp_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `shop_id` bigint DEFAULT NULL COMMENT '店铺id',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=813 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='京东商品SKU表';

-- ----------------------------
-- Records of oms_jd_goods_sku
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_jd_order
-- ----------------------------
DROP TABLE IF EXISTS `oms_jd_order`;
CREATE TABLE `oms_jd_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` int NOT NULL COMMENT '店铺id',
  `order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单id',
  `vender_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家id',
  `order_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '	订单类型（22 SOP；75 LOC） 可选字段，需要在输入参数optional_fields中写入才能返回',
  `pay_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付方式（1货到付款, 2邮局汇款, 3自提, 4在线支付, 5公司转账, 6银行卡转账）',
  `order_total_price` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单总金额。总金额=订单金额（不减优惠，不加运费服务费税费）',
  `order_seller_price` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单货款金额（订单总金额-商家优惠金额）',
  `order_payment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户应付金额。应付款=货款-用户优惠-余额+运费+税费+服务费。',
  `freight_price` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品的运费',
  `seller_discount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家优惠金额',
  `order_state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '	1）WAIT_SELLER_STOCK_OUT 等待出库 2）WAIT_GOODS_RECEIVE_CONFIRM 等待确认收货 3）WAIT_SELLER_DELIVERY等待发货（只适用于海外购商家，含义为''等待境内发货''标签下的订单,非海外购商家无需使用） 4) POP_ORDER_PAUSE POP暂停 5）FINISHED_L 完成 6）TRADE_CANCELED 取消 7）LOCKED 已锁定 8）WAIT_SEND_CODE 等待发码',
  `order_state_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单状态说明（中文）',
  `delivery_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '送货（日期）类型（1-只工作日送货(双休日、假日不用送);2-只双休日、假日送货(工作日不用送);3-工作日、双休日与假日均可送货;其他值-返回“任意时间”）',
  `invoice_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发票信息 “invoice_info: 不需要开具发票”下无需开具发票；其它返回值请正常开具发票 。（没有电子发票具体信息）',
  `invoice_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '普通发票纳税人识别码',
  `order_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家下单时订单备注',
  `order_start_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '下单时间',
  `order_end_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结单时间 如返回信息为“0001-01-01 00:00:00”和“1970-01-01 00:00:00”，可认为此订单为未完成状态。',
  `fullname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '姓名',
  `telephone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '固定电话',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机',
  `full_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '地址',
  `province` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `county` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `town` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `province_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `city_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `county_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `town_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `vender_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家订单备注（不大于500字符） 可选字段，需要在输入参数optional_fields中写入才能返回',
  `balance_used` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '余额支付金额 可选字段，需要在输入参数optional_fields中写入才能返回',
  `pin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家的账号信息',
  `return_order` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '售后订单标记 0:不是换货订单 1返修发货,直接赔偿,客服补件 2售后调货 可选字段，需要在输入参数optional_fields中写入才能返回',
  `payment_confirm_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '付款确认时间 如果没有付款时间 默认返回0001-01-01 00:00:00 可选字段，需要在输入参数optional_fields中写入才能返回',
  `waybill` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '运单号(当厂家自送时运单号可为空，不同物流公司的运单号用|分隔，如果同一物流公司有多个运单号，则用英文逗号分隔) 可选字段，需要在输入参数optional_fields中写入才能返回',
  `logistics_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流公司ID 可选字段，需要在输入参数optional_fields中写入才能返回',
  `modified` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单更新时间',
  `direct_parent_order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '	直接父订单号 可选字段，需要在输入参数optional_fields中写入才能返回',
  `parent_order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '	根父订单号 可选字段，需要在输入参数optional_fields中写入才能返回',
  `order_source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单来源。如：移动端订单',
  `store_order` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '京仓订单/云仓订单/空“”',
  `id_sop_shipmenttype` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否京配。68=京配，69=京配自提',
  `real_pin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家的账号信息(区分大小写) 可选字段，需要在输入参数optional_fields中写入才能返回',
  `open_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家的账号信息 ',
  `open_id_buyer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家的账号信息(区分大小写) 可选字段',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `order_id_index` (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1464 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='京东订单表';

-- ----------------------------
-- Records of oms_jd_order
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_jd_order_coupon
-- ----------------------------
DROP TABLE IF EXISTS `oms_jd_order_coupon`;
CREATE TABLE `oms_jd_order_coupon` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint DEFAULT NULL COMMENT '订单编号',
  `skuId` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '京东sku编号。(只有30-单品促销优惠 此skuId才非空)',
  `coupon_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '优惠类型: 20-套装优惠, 28-闪团优惠, 29-团购优惠, 30-单品促销优惠, 34-手机红包, 35-满返满送(返现), 39-京豆优惠,41-京东券优惠, 52-礼品卡优惠,100-店铺优惠',
  `coupon_price` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '优惠金额。',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='京东订单优惠明细表';

-- ----------------------------
-- Records of oms_jd_order_coupon
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_jd_order_item
-- ----------------------------
DROP TABLE IF EXISTS `oms_jd_order_item`;
CREATE TABLE `oms_jd_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `jd_order_id` bigint NOT NULL COMMENT '外键id（jd_order表id）',
  `order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '京东平台订单id',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '京东内部SKU的ID',
  `outer_sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'SKU外部ID（极端情况下不保证返回，建议从商品接口获取',
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品的名称+SKU规格',
  `jd_price` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'SKU的京东价',
  `gift_point` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '赠送积分',
  `ware_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '	京东内部商品ID（极端情况下不保证返回，建议从商品接口获取）',
  `item_total` int DEFAULT NULL COMMENT '数量',
  `product_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `service_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `new_store_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `erp_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `erp_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1794 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='京东订单明细表';

-- ----------------------------
-- Records of oms_jd_order_item
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_jd_refund
-- ----------------------------
DROP TABLE IF EXISTS `oms_jd_refund`;
CREATE TABLE `oms_jd_refund` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` int DEFAULT NULL COMMENT '店铺id',
  `apply_id` bigint DEFAULT NULL COMMENT '申请单号',
  `service_id` bigint DEFAULT NULL COMMENT '服务单号（退款单id）',
  `refund_id` bigint DEFAULT NULL COMMENT '退款单id',
  `order_id` bigint DEFAULT NULL COMMENT '订单号',
  `apply_time` datetime DEFAULT NULL COMMENT '申请时间',
  `apply_refund_sum` double DEFAULT NULL COMMENT '退款金额(单位分)',
  `customer_expect` int NOT NULL COMMENT '客户期望(1-售前退款 10-退货 20-换货 30-维修 40-大家电安装 50-大家电移机 60-大家电增值服务 70-上门维修 90-优鲜赔 80-补发商品 100-试用收回 11-仅退款)',
  `customer_expect_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '客户期望名称',
  `service_status` int DEFAULT NULL COMMENT '服务单状态（10000-待审核领取 10001-待审核 10002-待客户反馈 10004-审核关闭 10005-待收货 10006-待处理领取 10007-待处理 10009-待用户确认 10010-完成 10011-取消 10012-客户已反馈 10013-待审核和待客户反馈 10041-提交退款申请 1100-待下发维修中心接单 12000-上门维修中 14000-上门检测中 13000-商家催收待处理 13000-未收货，待收款 13000-已收货，待收款）',
  `service_status_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '服务单状态名称',
  `customer_pin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '客户账号',
  `customer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '客户姓名',
  `customer_tel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户电话',
  `pickware_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '取件地址',
  `pickware_type` int DEFAULT NULL COMMENT '取件方式(4-上门取件 5-上门换新取件 7-客户送货 8-大家电上门取件 9-大家电换新取件 40-客户发货 70-送货至门店 71-快递至门店 72-门店上门取件 80-京东快运上门取件 85-德邦取件)',
  `order_type` int DEFAULT NULL COMMENT '订单类型(0-一般订单 2-拍卖订单 11-售后调货 15-返修发货 16-直接赔偿 21-POPFBP 22-POPSOP 23-POPLBP 24-POPLBV 25-POPSOPL 18-厂商直送 19-客服补件 42-通用合约 61-EPT订单 69-京东服务产品订单 19-客服补件 75-LOC订单 77-LSP订单 42-虚拟订单 88-总代订单 96-sop虚拟订单 100-提货卡订单 33-电子礼品卡 49-礼品卡 108-京东维修服务产品订单 131-X无人超市订单 142-企业店铺IBS订单 151-品牌门店线下订单 112-自营采购，以销定结 159-领货码订单 89-移动仓库订单 170-实体领货码订单 140-商家采购订单 193-scf订单 54-线下礼品卡订单 202-月卡订单 4-虚拟商品)',
  `order_type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单类型名称',
  `actual_pay_price` decimal(10,2) DEFAULT NULL COMMENT '实付金额',
  `sku_id` bigint DEFAULT NULL COMMENT '商品编号',
  `ware_id` bigint DEFAULT NULL COMMENT '商品id',
  `ware_type` int DEFAULT NULL COMMENT '售后商品类型(10-申请主商品 20-申请的赠品 30-附件 40-发票 50-发票复印件 60-出检报告 70-包装 80-防损吊牌 90-贺卡 100-礼品购包装 110-loc订单验证码 120-服务产品标识)',
  `ware_type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品类型名称',
  `ware_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `sku_type` int DEFAULT NULL COMMENT '商品类型(1-单品 2-赠品套装中的主商品 3-赠品套装中的赠品 4-套装中的单品 5-套装中的赠品 6-加价购赠品 7-延保通 8-延保通赠品)',
  `sku_type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'skuType对应名称',
  `approve_pin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审核人账号',
  `approve_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审核人姓名',
  `approve_time` datetime DEFAULT NULL COMMENT '审核时间',
  `approve_result` int DEFAULT NULL COMMENT '审核结果(11-直赔积分 12-直赔余额 13-直赔优惠卷 14-直赔京豆 21-直赔商品 22-上门换新 31-自营取件 32-客户送货 33-客户发货 34-闪电退款 35-虚拟退款 36-上门检测 37-客户送货至门店 38-保外维修 39-快递至门店 40-门店上门取件 80-大家电检测 81-大家电安装 82-大家电移机 83-大家电维修 84-大家电其它 85-闪电催收 86-上门维修 87-补发商品 91-退款不退货 92-预授权冻结 93-ACS换新 95-(超级体验店)门店换新 96-(超级体验店)主站换新 97-厂商维修-寄修 98-厂商维修-上门维修 99-厂商维修-送修 101-厂商大家电检测鉴定 102-厂商大家电安装 103-厂商大家电移机拆机 104-厂商大家电维修(上门维修) 105-厂商大家电拆机鉴定 106-换货 100-客户退货至团长 107-3c上门维修 108-增值服务 109-退货(筋斗云使用) 110-直赔(筋斗云使用) 111-上门检测取件)',
  `approve_result_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审核结果名称',
  `approve_notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `process_pin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理人账号',
  `process_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理人姓名',
  `process_time` datetime DEFAULT NULL COMMENT '处理时间',
  `process_result` int DEFAULT NULL COMMENT '处理结果(0-初始化 1-安装完成 2-维修完成 3-检测完成 4-拆机完成 5-咨询解释 6-取消 70-原返 80-换货 100-赔付)',
  `process_result_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理结果名称',
  `platform_src` int DEFAULT NULL COMMENT '平台来源',
  `platform_src_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '平台来源名称',
  `service_count` int DEFAULT NULL COMMENT '服务单售后数量',
  `desen_customer_tel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户电话',
  `buyer_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '客户帐号',
  `buyer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '客户姓名',
  `refund_check_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审核日期',
  `refund_status` int DEFAULT NULL COMMENT '退款审核状态: 0代表未审核， 1代表审核通过 2代表审核不通过 3代表京东财务审核通过；4代表京东财务审核不通过',
  `refund_complete_time` datetime DEFAULT NULL COMMENT '退款完成时间',
  `refund_check_username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审核人',
  `refund_check_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审核备注',
  `refund_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退款原因',
  `refund_system_id` int DEFAULT NULL COMMENT ' 退款来源(10:客服; 11:网站; 12:配送拒收; 28:APP; 87:分拣中心,逆向物流; 98:微信手Q;)',
  `create_time` datetime DEFAULT NULL COMMENT '订单创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `o_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `sku_list` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '商品明细列表JSON',
  `sku_count` int DEFAULT NULL COMMENT '退款数量',
  `question_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `service_id_index` (`service_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='京东退款与售后表';

-- ----------------------------
-- Records of oms_jd_refund
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_pdd_goods
-- ----------------------------
DROP TABLE IF EXISTS `oms_pdd_goods`;
CREATE TABLE `oms_pdd_goods` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `goods_id` bigint DEFAULT NULL COMMENT '商品编码',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `goods_quantity` bigint DEFAULT NULL COMMENT '商品总数量',
  `outer_goods_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家外部编码（goods）',
  `is_more_sku` int DEFAULT NULL COMMENT '是否多sku，0-单sku，1-多sku',
  `is_onsale` int DEFAULT NULL COMMENT '是否在架上，0-下架中，1-架上',
  `thumb_url` varchar(355) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品缩略图',
  `market_price` bigint NOT NULL DEFAULT '0' COMMENT '市场价，单位分',
  `created_at` bigint DEFAULT NULL COMMENT '商品创建时间的时间戳',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `erp_goods_id` bigint DEFAULT NULL COMMENT 'erp商品id',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='pdd商品表';

-- ----------------------------
-- Records of oms_pdd_goods
-- ----------------------------
BEGIN;
INSERT INTO `oms_pdd_goods` (`id`, `goods_id`, `goods_name`, `goods_quantity`, `outer_goods_id`, `is_more_sku`, `is_onsale`, `thumb_url`, `market_price`, `created_at`, `shop_id`, `erp_goods_id`, `create_time`, `update_time`) VALUES (3, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', NULL, NULL, 1, 1, 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:14', '2025-10-01 12:56:14');
INSERT INTO `oms_pdd_goods` (`id`, `goods_id`, `goods_name`, `goods_quantity`, `outer_goods_id`, `is_more_sku`, `is_onsale`, `thumb_url`, `market_price`, `created_at`, `shop_id`, `erp_goods_id`, `create_time`, `update_time`) VALUES (4, 754380133868, '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', NULL, NULL, 1, 1, 'https://img.pddpic.com/gaudit-image/2025-05-29/1a92b78dc9240b794790f686d5186398.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:14', '2025-10-01 12:56:14');
INSERT INTO `oms_pdd_goods` (`id`, `goods_id`, `goods_name`, `goods_quantity`, `outer_goods_id`, `is_more_sku`, `is_onsale`, `thumb_url`, `market_price`, `created_at`, `shop_id`, `erp_goods_id`, `create_time`, `update_time`) VALUES (5, 755310184807, '艾瑞泽工具箱三层折叠多层多功能收纳箱汽车用家用电工五金收纳箱', NULL, NULL, 1, 0, 'https://img.pddpic.com/gaudit-image/2025-05-31/8378221ca34955ad167b22c921234f14.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:14', '2025-10-01 12:56:14');
INSERT INTO `oms_pdd_goods` (`id`, `goods_id`, `goods_name`, `goods_quantity`, `outer_goods_id`, `is_more_sku`, `is_onsale`, `thumb_url`, `market_price`, `created_at`, `shop_id`, `erp_goods_id`, `create_time`, `update_time`) VALUES (6, 755635245980, '雷士照明led灯泡节能E27螺口球泡飞碟灯夜市地摊工矿大功率厂房灯', NULL, NULL, 1, 1, 'https://img.pddpic.com/gaudit-image/2025-06-01/c59032e87cd4a8aa1d6615eb3770bddb.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:14', '2025-10-01 12:56:14');
INSERT INTO `oms_pdd_goods` (`id`, `goods_id`, `goods_name`, `goods_quantity`, `outer_goods_id`, `is_more_sku`, `is_onsale`, `thumb_url`, `market_price`, `created_at`, `shop_id`, `erp_goods_id`, `create_time`, `update_time`) VALUES (7, 756679247197, '雷士照明LED灯泡高亮E27螺口节能灯泡吊灯光源大功率护眼LED球泡', NULL, NULL, 1, 1, 'https://img.pddpic.com/gaudit-image/2025-06-03/1f92d0247e00defa30fe23ccc15be4fe.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:15', '2025-10-01 12:56:15');
INSERT INTO `oms_pdd_goods` (`id`, `goods_id`, `goods_name`, `goods_quantity`, `outer_goods_id`, `is_more_sku`, `is_onsale`, `thumb_url`, `market_price`, `created_at`, `shop_id`, `erp_goods_id`, `create_time`, `update_time`) VALUES (8, 756684220589, '雷士照明led吸顶灯灯条客厅卧室灯板磁吸灯条长条形灯芯家用节能', NULL, NULL, 0, 0, 'https://img.pddpic.com/gaudit-image/2025-06-03/8079acdcba55f2fb96b57b775b87c002.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:15', '2025-10-01 12:56:15');
INSERT INTO `oms_pdd_goods` (`id`, `goods_id`, `goods_name`, `goods_quantity`, `outer_goods_id`, `is_more_sku`, `is_onsale`, `thumb_url`, `market_price`, `created_at`, `shop_id`, `erp_goods_id`, `create_time`, `update_time`) VALUES (9, 762810718533, '雷士照明应急灯户外露营充电灯泡地摊照明灯超亮节能家用应急灯', NULL, NULL, 1, 0, 'https://img.pddpic.com/gaudit-image/2025-06-15/d74171a6b86b15ddf9d2adc6632a6185.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:15', '2025-10-01 12:56:15');
INSERT INTO `oms_pdd_goods` (`id`, `goods_id`, `goods_name`, `goods_quantity`, `outer_goods_id`, `is_more_sku`, `is_onsale`, `thumb_url`, `market_price`, `created_at`, `shop_id`, `erp_goods_id`, `create_time`, `update_time`) VALUES (10, 770936903345, '雷士照明LED集成吊顶灯无边框防水厨房卫生间厕所全面发光平板灯', NULL, NULL, 0, 0, 'https://img.pddpic.com/gaudit-image/2025-06-30/3a3e4097cfebbbc95462edc234c8e488.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:15', '2025-10-01 12:56:15');
INSERT INTO `oms_pdd_goods` (`id`, `goods_id`, `goods_name`, `goods_quantity`, `outer_goods_id`, `is_more_sku`, `is_onsale`, `thumb_url`, `market_price`, `created_at`, `shop_id`, `erp_goods_id`, `create_time`, `update_time`) VALUES (11, 770940543534, '雷士照明led集成吊顶灯平板灯厨房浴室300*300厕所灯卫生间厨房灯', NULL, NULL, 1, 0, 'https://img.pddpic.com/gaudit-image/2025-06-30/b6e35e30732ce30a849d2ad0d6c061e7.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:15', '2025-10-01 12:56:15');
INSERT INTO `oms_pdd_goods` (`id`, `goods_id`, `goods_name`, `goods_quantity`, `outer_goods_id`, `is_more_sku`, `is_onsale`, `thumb_url`, `market_price`, `created_at`, `shop_id`, `erp_goods_id`, `create_time`, `update_time`) VALUES (12, 774317814352, '雷士led灯芯吸顶磁吸节能灯板改装光源模组圆形三色模组家用环形', NULL, NULL, 1, 1, 'https://img.pddpic.com/gaudit-image/2025-07-06/64eeaa77c1d01bb91bea649e7615bd3c.jpeg', 0, NULL, 1009, NULL, '2025-10-01 12:56:15', '2025-10-01 12:56:15');
COMMIT;

-- ----------------------------
-- Table structure for oms_pdd_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `oms_pdd_goods_sku`;
CREATE TABLE `oms_pdd_goods_sku` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sku_id` bigint DEFAULT NULL COMMENT 'sku编码',
  `goods_id` bigint DEFAULT NULL COMMENT 'pdd商品编码',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `thumb_url` varchar(355) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品缩略图',
  `outer_goods_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家外部编码（goods）',
  `outer_id` varchar(85) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家外部编码（sku）',
  `sku_quantity` bigint DEFAULT NULL COMMENT 'sku库存',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规格名称',
  `price` bigint DEFAULT NULL COMMENT '价格，单位分',
  `is_sku_onsale` int DEFAULT NULL COMMENT 'sku是否在架上，0-下架中，1-架上',
  `erp_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `erp_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `shop_id` bigint DEFAULT NULL COMMENT '店铺id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='pdd商品SKU表';

-- ----------------------------
-- Records of oms_pdd_goods_sku
-- ----------------------------
BEGIN;
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (112, 1742373848730, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 'LEDDP001', 'LEDDP00102', NULL, 'E27螺口 5瓦白光 1级能效', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (113, 1740677623154, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 'LEDDP001', 'LEDDP00104', NULL, 'E27螺口 12瓦白光 1级能效', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (114, 1742374330748, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 'LEDDP001', 'LEDDP00107', NULL, 'E27螺口 30瓦白光 1级能效', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (115, 1742374330747, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 'LEDDP001', 'LEDDP00106', NULL, 'E27螺口 24瓦白光 1级能效', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (116, 1740677623153, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 'LEDDP001', 'LEDDP00103', NULL, 'E27螺口 7瓦白光 1级能效', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (117, 1740677623155, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 'LEDDP001', 'LEDDP00105', NULL, 'E27螺口 18瓦白光 1级能效', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (118, 1742373848729, 753794079556, '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/gaudit-image/2025-05-28/048a06e3b11fe5e8ce5ab00e1828d77f.jpeg', 'LEDDP001', 'LEDDP00101', NULL, 'E27螺口 3瓦白光 1级能效', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (119, 1742164849118, 754380133868, '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/gaudit-image/2025-05-29/1a92b78dc9240b794790f686d5186398.jpeg', 'LEDDX001', 'LEDDX00104', NULL, '36W三色变光-300mm', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (120, 1742164849120, 754380133868, '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/gaudit-image/2025-05-29/1a92b78dc9240b794790f686d5186398.jpeg', 'LEDDX001', 'LEDDX00106', NULL, '60W三色变光-360mm', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (121, 1742164849117, 754380133868, '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/gaudit-image/2025-05-29/1a92b78dc9240b794790f686d5186398.jpeg', 'LEDDX001', 'LEDDX00103', NULL, '24W白光-215mm', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (122, 1742164849115, 754380133868, '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/gaudit-image/2025-05-29/1a92b78dc9240b794790f686d5186398.jpeg', 'LEDDX001', 'LEDDX00101', NULL, '12W白光-135mm', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (123, 1742164849119, 754380133868, '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/gaudit-image/2025-05-29/1a92b78dc9240b794790f686d5186398.jpeg', 'LEDDX001', 'LEDDX00105', NULL, '48W三色变光-330mm', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (124, 1742164849116, 754380133868, '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/gaudit-image/2025-05-29/1a92b78dc9240b794790f686d5186398.jpeg', 'LEDDX001', 'LEDDX00102', NULL, '18W白光-175mm', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (125, 1741926779987, 755310184807, '艾瑞泽工具箱三层折叠多层多功能收纳箱汽车用家用电工五金收纳箱', 'https://img.pddpic.com/gaudit-image/2025-05-31/8378221ca34955ad167b22c921234f14.jpeg', '448700666150_1748700757', '648700666529453', NULL, '22寸黑金刚加强筋骨抗砸耐摔旗舰款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (126, 1741926779985, 755310184807, '艾瑞泽工具箱三层折叠多层多功能收纳箱汽车用家用电工五金收纳箱', 'https://img.pddpic.com/gaudit-image/2025-05-31/8378221ca34955ad167b22c921234f14.jpeg', '448700666150_1748700757', '648700666529451', NULL, '21寸三层折叠工具箱精工款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (127, 1741926779986, 755310184807, '艾瑞泽工具箱三层折叠多层多功能收纳箱汽车用家用电工五金收纳箱', 'https://img.pddpic.com/gaudit-image/2025-05-31/8378221ca34955ad167b22c921234f14.jpeg', '448700666150_1748700757', '648700666529452', NULL, '19寸黑金刚加强筋骨抗砸耐摔旗舰款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (128, 1741926779984, 755310184807, '艾瑞泽工具箱三层折叠多层多功能收纳箱汽车用家用电工五金收纳箱', 'https://img.pddpic.com/gaudit-image/2025-05-31/8378221ca34955ad167b22c921234f14.jpeg', '448700666150_1748700757', '648700666529450', NULL, '17寸三层折叠工具箱精工款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (129, 1742148962888, 755635245980, '雷士照明led灯泡节能E27螺口球泡飞碟灯夜市地摊工矿大功率厂房灯', 'https://img.pddpic.com/gaudit-image/2025-06-01/c59032e87cd4a8aa1d6615eb3770bddb.jpeg', '', '', NULL, '白色款30W白光 其它', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (130, 1742372682345, 755635245980, '雷士照明led灯泡节能E27螺口球泡飞碟灯夜市地摊工矿大功率厂房灯', 'https://img.pddpic.com/gaudit-image/2025-06-01/c59032e87cd4a8aa1d6615eb3770bddb.jpeg', '', '', NULL, '白色款18W白光 其它', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (131, 1742148962887, 755635245980, '雷士照明led灯泡节能E27螺口球泡飞碟灯夜市地摊工矿大功率厂房灯', 'https://img.pddpic.com/gaudit-image/2025-06-01/c59032e87cd4a8aa1d6615eb3770bddb.jpeg', '', '', NULL, '白色款24W白光 其它', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:14', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (132, 1743027340567, 756679247197, '雷士照明LED灯泡高亮E27螺口节能灯泡吊灯光源大功率护眼LED球泡', 'https://img.pddpic.com/gaudit-image/2025-06-03/1f92d0247e00defa30fe23ccc15be4fe.jpeg', '', '', NULL, '【五只装】E27 24W 正白光', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (133, 1743027340565, 756679247197, '雷士照明LED灯泡高亮E27螺口节能灯泡吊灯光源大功率护眼LED球泡', 'https://img.pddpic.com/gaudit-image/2025-06-03/1f92d0247e00defa30fe23ccc15be4fe.jpeg', '', '', NULL, '【五只装】E27 18W 正白光', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (134, 1743027340569, 756679247197, '雷士照明LED灯泡高亮E27螺口节能灯泡吊灯光源大功率护眼LED球泡', 'https://img.pddpic.com/gaudit-image/2025-06-03/1f92d0247e00defa30fe23ccc15be4fe.jpeg', '', '', NULL, '【五只装】E27 30W 正白光', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (135, 1749116485132, 756684220589, '雷士照明led吸顶灯灯条客厅卧室灯板磁吸灯条长条形灯芯家用节能', 'https://img.pddpic.com/gaudit-image/2025-06-03/8079acdcba55f2fb96b57b775b87c002.jpeg', '', '', NULL, '48W白光【一拖四】 【磁铁吸附 快捷替换】', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (136, 1748010394260, 762810718533, '雷士照明应急灯户外露营充电灯泡地摊照明灯超亮节能家用应急灯', 'https://img.pddpic.com/gaudit-image/2025-06-15/d74171a6b86b15ddf9d2adc6632a6185.jpeg', '', '', NULL, '4W USB充电式灯泡', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (137, 1748010394261, 762810718533, '雷士照明应急灯户外露营充电灯泡地摊照明灯超亮节能家用应急灯', 'https://img.pddpic.com/gaudit-image/2025-06-15/d74171a6b86b15ddf9d2adc6632a6185.jpeg', '', '', NULL, '7W USB充电式灯泡', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (138, 1754155826431, 770936903345, '雷士照明LED集成吊顶灯无边框防水厨房卫生间厕所全面发光平板灯', 'https://img.pddpic.com/gaudit-image/2025-06-30/3a3e4097cfebbbc95462edc234c8e488.jpeg', '', '', NULL, '30X30【24W悬浮曲面照明】', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (139, 1754157954617, 770940543534, '雷士照明led集成吊顶灯平板灯厨房浴室300*300厕所灯卫生间厨房灯', 'https://img.pddpic.com/gaudit-image/2025-06-30/b6e35e30732ce30a849d2ad0d6c061e7.jpeg', '', '', NULL, '300*600 24W珍珠白集成款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (140, 1754157954614, 770940543534, '雷士照明led集成吊顶灯平板灯厨房浴室300*300厕所灯卫生间厨房灯', 'https://img.pddpic.com/gaudit-image/2025-06-30/b6e35e30732ce30a849d2ad0d6c061e7.jpeg', '', '', NULL, '300*300 18W雾银集成款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (141, 1754157954615, 770940543534, '雷士照明led集成吊顶灯平板灯厨房浴室300*300厕所灯卫生间厨房灯', 'https://img.pddpic.com/gaudit-image/2025-06-30/b6e35e30732ce30a849d2ad0d6c061e7.jpeg', '', '', NULL, '300*300 18W珍珠白集成款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (142, 1754157954616, 770940543534, '雷士照明led集成吊顶灯平板灯厨房浴室300*300厕所灯卫生间厨房灯', 'https://img.pddpic.com/gaudit-image/2025-06-30/b6e35e30732ce30a849d2ad0d6c061e7.jpeg', '', '', NULL, '300*600 24W雾银集成款', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (143, 1756355886271, 774317814352, '雷士led灯芯吸顶磁吸节能灯板改装光源模组圆形三色模组家用环形', 'https://img.pddpic.com/gaudit-image/2025-07-06/64eeaa77c1d01bb91bea649e7615bd3c.jpeg', '', 'LEDDX00104', NULL, '三色模组36W 直径23CM', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (144, 1756354078309, 774317814352, '雷士led灯芯吸顶磁吸节能灯板改装光源模组圆形三色模组家用环形', 'https://img.pddpic.com/gaudit-image/2025-07-06/64eeaa77c1d01bb91bea649e7615bd3c.jpeg', '', 'LEDDX00103', NULL, '白光24W 直径22CM', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (145, 1756355886273, 774317814352, '雷士led灯芯吸顶磁吸节能灯板改装光源模组圆形三色模组家用环形', 'https://img.pddpic.com/gaudit-image/2025-07-06/64eeaa77c1d01bb91bea649e7615bd3c.jpeg', '', 'LEDDX00106', NULL, '三色模组60W 直径30CM', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
INSERT INTO `oms_pdd_goods_sku` (`id`, `sku_id`, `goods_id`, `goods_name`, `thumb_url`, `outer_goods_id`, `outer_id`, `sku_quantity`, `spec`, `price`, `is_sku_onsale`, `erp_goods_id`, `erp_goods_sku_id`, `shop_id`, `create_time`, `update_time`) VALUES (146, 1756355886272, 774317814352, '雷士led灯芯吸顶磁吸节能灯板改装光源模组圆形三色模组家用环形', 'https://img.pddpic.com/gaudit-image/2025-07-06/64eeaa77c1d01bb91bea649e7615bd3c.jpeg', '', 'LEDDX00105', NULL, '三色模组48W 直径30CM', NULL, 1, 0, 0, 1009, '2025-10-01 12:56:15', NULL);
COMMIT;

-- ----------------------------
-- Table structure for oms_pdd_order
-- ----------------------------
DROP TABLE IF EXISTS `oms_pdd_order`;
CREATE TABLE `oms_pdd_order` (
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
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '订单备注',
  `remark_tag` int DEFAULT NULL COMMENT '订单备注标记，1-红色，2-黄色，3-绿色，4-蓝色，5-紫色',
  `remark_tag_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '订单备注标记名称',
  `buyer_memo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '买家留言信息',
  `updated_at` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '订单的更新时间',
  `shipping_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '发货时间',
  `tracking_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '快递单号',
  `tracking_company` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '物流公司',
  `pay_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '支付方式，枚举值：QQ,WEIXIN,ALIPAY,LIANLIANPAY',
  `pay_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '支付单号',
  `receiver_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '收件人地址，不拼接省市区',
  `receiver_address_mask` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '收件人地址（打码）',
  `receiver_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '收件人姓名',
  `receiver_phone` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '收件人电话',
  `receiver_phone_mask` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receiver_name_mask` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_mask` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '详细地址',
  `town` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '区县',
  `town_id` int DEFAULT NULL,
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '市',
  `city_id` int DEFAULT NULL COMMENT '城市编码',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '省',
  `province_id` int DEFAULT NULL,
  `country` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '国家地区',
  `country_id` int DEFAULT NULL,
  `created_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '订单创建时间',
  `pay_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '支付时间',
  `confirm_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '成交时间',
  `receive_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '确认收货时间',
  `last_ship_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '订单承诺发货时间',
  `tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签',
  `delivery_one_day` int DEFAULT NULL COMMENT '是否当日发货，1-是，0-否',
  `duoduo_wholesale` int DEFAULT NULL COMMENT '是否多多批发，1-是，0-否',
  `home_delivery_type` int DEFAULT NULL COMMENT '送货入户并安装服务 0-不支持送货，1-送货入户不安装，2-送货入户并安装',
  `invoice_status` int DEFAULT NULL COMMENT '发票申请,1代表有 0代表无',
  `is_pre_sale` int DEFAULT NULL COMMENT '是否为预售商品 1表示是 0表示否',
  `is_stock_out` int DEFAULT NULL COMMENT '是否缺货 0-无缺货处理 1： 有缺货处理',
  `logistics_id` bigint DEFAULT NULL COMMENT '快递公司在拼多多的代码',
  `mkt_biz_type` int DEFAULT NULL COMMENT '市场业务类型，0-普通订单，1-拼内购订单',
  `only_support_replace` int DEFAULT NULL COMMENT '只换不修，1:是，0:否',
  `order_change_amount` double DEFAULT NULL COMMENT '订单改价折扣金额，单位元',
  `pre_sale_time` varchar(26) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '预售时间',
  `return_freight_payer` int DEFAULT NULL COMMENT '退货包运费，1:是，0:否',
  `risk_control_status` int DEFAULT NULL COMMENT '订单审核状态（0-正常订单， 1-审核中订单）',
  `urge_shipping_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '催发货时间',
  `audit_status` int DEFAULT '0' COMMENT '0待确认，1已确认',
  `audit_time` datetime DEFAULT NULL COMMENT '发货时间（仓库真实发货时间）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '系统创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '系统更新时间',
  `duo_duo_pay_reduction` double DEFAULT NULL COMMENT '多多支付优惠',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_sn_index` (`order_sn`) USING BTREE,
  KEY `shopid_index` (`shop_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2013477542266085379 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='拼多多订单表';

-- ----------------------------
-- Records of oms_pdd_order
-- ----------------------------
BEGIN;
INSERT INTO `oms_pdd_order` (`id`, `shop_id`, `order_sn`, `trade_type`, `free_sf`, `is_lucky_flag`, `group_status`, `confirm_status`, `order_status`, `refund_status`, `after_sales_status`, `capital_free_discount`, `seller_discount`, `platform_discount`, `goods_amount`, `discount_amount`, `pay_amount`, `postage`, `remark`, `remark_tag`, `remark_tag_name`, `buyer_memo`, `updated_at`, `shipping_time`, `tracking_number`, `tracking_company`, `pay_type`, `pay_no`, `receiver_address`, `receiver_address_mask`, `receiver_name`, `receiver_phone`, `receiver_phone_mask`, `receiver_name_mask`, `address_mask`, `address`, `town`, `town_id`, `city`, `city_id`, `province`, `province_id`, `country`, `country_id`, `created_time`, `pay_time`, `confirm_time`, `receive_time`, `last_ship_time`, `tag`, `delivery_one_day`, `duoduo_wholesale`, `home_delivery_type`, `invoice_status`, `is_pre_sale`, `is_stock_out`, `logistics_id`, `mkt_biz_type`, `only_support_replace`, `order_change_amount`, `pre_sale_time`, `return_freight_payer`, `risk_control_status`, `urge_shipping_time`, `audit_status`, `audit_time`, `create_time`, `update_time`, `duo_duo_pay_reduction`) VALUES (1973227307811008514, 1009, '250929-004537740820931', 0, 0, 1, 1, 1, 2, 4, 10, 0, 0, 0, 29.35, 0, 29.35, 0, '', NULL, NULL, '', '2025-09-29 18:27:20', '2025-09-29 18:09:45', 'JT5416889180664', NULL, '', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, '中国', 0, '2025-09-29 18:05:30', '2025-09-29 18:05:32', '2025-09-29 18:05:32', '', '2025-09-30 18:05:32', NULL, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, NULL, 0, 0, '', 0, NULL, '2025-10-08 11:01:07', '2025-10-08 19:01:08', NULL);
INSERT INTO `oms_pdd_order` (`id`, `shop_id`, `order_sn`, `trade_type`, `free_sf`, `is_lucky_flag`, `group_status`, `confirm_status`, `order_status`, `refund_status`, `after_sales_status`, `capital_free_discount`, `seller_discount`, `platform_discount`, `goods_amount`, `discount_amount`, `pay_amount`, `postage`, `remark`, `remark_tag`, `remark_tag_name`, `buyer_memo`, `updated_at`, `shipping_time`, `tracking_number`, `tracking_company`, `pay_type`, `pay_no`, `receiver_address`, `receiver_address_mask`, `receiver_name`, `receiver_phone`, `receiver_phone_mask`, `receiver_name_mask`, `address_mask`, `address`, `town`, `town_id`, `city`, `city_id`, `province`, `province_id`, `country`, `country_id`, `created_time`, `pay_time`, `confirm_time`, `receive_time`, `last_ship_time`, `tag`, `delivery_one_day`, `duoduo_wholesale`, `home_delivery_type`, `invoice_status`, `is_pre_sale`, `is_stock_out`, `logistics_id`, `mkt_biz_type`, `only_support_replace`, `order_change_amount`, `pre_sale_time`, `return_freight_payer`, `risk_control_status`, `urge_shipping_time`, `audit_status`, `audit_time`, `create_time`, `update_time`, `duo_duo_pay_reduction`) VALUES (1973227308263993346, 1009, '250929-351611154071222', 0, 0, 1, 1, 1, 3, 1, 0, 0, 0, 0, 29.35, 0, 29.35, 0, '', NULL, NULL, '', '2025-10-05 00:13:25', '2025-09-30 13:57:46', 'JT5417062326379', NULL, '', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, '中国', 0, '2025-09-29 21:22:48', '2025-09-29 21:22:49', '2025-09-29 21:22:50', '2025-10-05 00:12:56', '2025-09-30 21:22:50', NULL, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, NULL, 0, 0, '', 0, '2025-10-06 17:56:31', '2025-10-08 11:01:05', '2025-10-08 19:01:05', NULL);
INSERT INTO `oms_pdd_order` (`id`, `shop_id`, `order_sn`, `trade_type`, `free_sf`, `is_lucky_flag`, `group_status`, `confirm_status`, `order_status`, `refund_status`, `after_sales_status`, `capital_free_discount`, `seller_discount`, `platform_discount`, `goods_amount`, `discount_amount`, `pay_amount`, `postage`, `remark`, `remark_tag`, `remark_tag_name`, `buyer_memo`, `updated_at`, `shipping_time`, `tracking_number`, `tracking_company`, `pay_type`, `pay_no`, `receiver_address`, `receiver_address_mask`, `receiver_name`, `receiver_phone`, `receiver_phone_mask`, `receiver_name_mask`, `address_mask`, `address`, `town`, `town_id`, `city`, `city_id`, `province`, `province_id`, `country`, `country_id`, `created_time`, `pay_time`, `confirm_time`, `receive_time`, `last_ship_time`, `tag`, `delivery_one_day`, `duoduo_wholesale`, `home_delivery_type`, `invoice_status`, `is_pre_sale`, `is_stock_out`, `logistics_id`, `mkt_biz_type`, `only_support_replace`, `order_change_amount`, `pre_sale_time`, `return_freight_payer`, `risk_control_status`, `urge_shipping_time`, `audit_status`, `audit_time`, `create_time`, `update_time`, `duo_duo_pay_reduction`) VALUES (1975855891292717057, 1009, '251002-085338365560640', 0, 0, 1, 1, 1, 3, 1, 0, 0, 0, 0, 9.9, 0, 9.9, 0, '', NULL, NULL, '', '2025-10-04 19:58:35', '2025-10-02 11:23:00', 'JT5418053493040', NULL, '', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, '中国', 0, '2025-10-02 03:56:23', '2025-10-02 03:56:25', '2025-10-02 03:56:25', '2025-10-04 19:47:21', '2025-10-02 23:59:59', NULL, 1, 0, 0, 0, 0, 0, NULL, 0, 0, 0, NULL, 0, 0, '', 0, NULL, '2025-10-08 11:01:03', '2025-10-08 19:01:03', NULL);
INSERT INTO `oms_pdd_order` (`id`, `shop_id`, `order_sn`, `trade_type`, `free_sf`, `is_lucky_flag`, `group_status`, `confirm_status`, `order_status`, `refund_status`, `after_sales_status`, `capital_free_discount`, `seller_discount`, `platform_discount`, `goods_amount`, `discount_amount`, `pay_amount`, `postage`, `remark`, `remark_tag`, `remark_tag_name`, `buyer_memo`, `updated_at`, `shipping_time`, `tracking_number`, `tracking_company`, `pay_type`, `pay_no`, `receiver_address`, `receiver_address_mask`, `receiver_name`, `receiver_phone`, `receiver_phone_mask`, `receiver_name_mask`, `address_mask`, `address`, `town`, `town_id`, `city`, `city_id`, `province`, `province_id`, `country`, `country_id`, `created_time`, `pay_time`, `confirm_time`, `receive_time`, `last_ship_time`, `tag`, `delivery_one_day`, `duoduo_wholesale`, `home_delivery_type`, `invoice_status`, `is_pre_sale`, `is_stock_out`, `logistics_id`, `mkt_biz_type`, `only_support_replace`, `order_change_amount`, `pre_sale_time`, `return_freight_payer`, `risk_control_status`, `urge_shipping_time`, `audit_status`, `audit_time`, `create_time`, `update_time`, `duo_duo_pay_reduction`) VALUES (1975855891573735426, 1009, '251002-171237742200640', 0, 0, 1, 1, 1, 3, 1, 0, 0, 0, 0, 12.49, 0, 12.49, 0, '', NULL, NULL, '', '2025-10-04 19:56:53', '2025-10-02 11:23:00', 'JT5418053493040', NULL, '', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, '中国', 0, '2025-10-02 03:56:59', '2025-10-02 03:57:00', '2025-10-02 03:57:00', '2025-10-04 19:46:40', '2025-10-02 23:59:59', NULL, 1, 0, 0, 0, 0, 0, NULL, 0, 0, 0, NULL, 0, 0, '', 0, NULL, '2025-10-08 11:01:01', '2025-10-08 19:01:01', NULL);
INSERT INTO `oms_pdd_order` (`id`, `shop_id`, `order_sn`, `trade_type`, `free_sf`, `is_lucky_flag`, `group_status`, `confirm_status`, `order_status`, `refund_status`, `after_sales_status`, `capital_free_discount`, `seller_discount`, `platform_discount`, `goods_amount`, `discount_amount`, `pay_amount`, `postage`, `remark`, `remark_tag`, `remark_tag_name`, `buyer_memo`, `updated_at`, `shipping_time`, `tracking_number`, `tracking_company`, `pay_type`, `pay_no`, `receiver_address`, `receiver_address_mask`, `receiver_name`, `receiver_phone`, `receiver_phone_mask`, `receiver_name_mask`, `address_mask`, `address`, `town`, `town_id`, `city`, `city_id`, `province`, `province_id`, `country`, `country_id`, `created_time`, `pay_time`, `confirm_time`, `receive_time`, `last_ship_time`, `tag`, `delivery_one_day`, `duoduo_wholesale`, `home_delivery_type`, `invoice_status`, `is_pre_sale`, `is_stock_out`, `logistics_id`, `mkt_biz_type`, `only_support_replace`, `order_change_amount`, `pre_sale_time`, `return_freight_payer`, `risk_control_status`, `urge_shipping_time`, `audit_status`, `audit_time`, `create_time`, `update_time`, `duo_duo_pay_reduction`) VALUES (1975856704463372289, 1009, '251006-010779369161362', 0, 0, 1, 1, 1, 2, 1, 0, 0, 0, 0, 33.93, 0, 33.93, 0, '', NULL, NULL, '', '2025-10-08 18:20:34', '2025-10-06 15:34:19', 'JT5418708391327', NULL, '', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, '中国', 0, '2025-10-06 13:37:06', '2025-10-06 13:37:08', '2025-10-06 13:37:08', '', '2025-10-06 23:59:59', NULL, 1, 0, 0, 0, 0, 0, NULL, 0, 0, 0, NULL, 0, 0, '', 0, NULL, '2025-10-08 11:00:59', '2025-10-08 19:00:59', NULL);
INSERT INTO `oms_pdd_order` (`id`, `shop_id`, `order_sn`, `trade_type`, `free_sf`, `is_lucky_flag`, `group_status`, `confirm_status`, `order_status`, `refund_status`, `after_sales_status`, `capital_free_discount`, `seller_discount`, `platform_discount`, `goods_amount`, `discount_amount`, `pay_amount`, `postage`, `remark`, `remark_tag`, `remark_tag_name`, `buyer_memo`, `updated_at`, `shipping_time`, `tracking_number`, `tracking_company`, `pay_type`, `pay_no`, `receiver_address`, `receiver_address_mask`, `receiver_name`, `receiver_phone`, `receiver_phone_mask`, `receiver_name_mask`, `address_mask`, `address`, `town`, `town_id`, `city`, `city_id`, `province`, `province_id`, `country`, `country_id`, `created_time`, `pay_time`, `confirm_time`, `receive_time`, `last_ship_time`, `tag`, `delivery_one_day`, `duoduo_wholesale`, `home_delivery_type`, `invoice_status`, `is_pre_sale`, `is_stock_out`, `logistics_id`, `mkt_biz_type`, `only_support_replace`, `order_change_amount`, `pre_sale_time`, `return_freight_payer`, `risk_control_status`, `urge_shipping_time`, `audit_status`, `audit_time`, `create_time`, `update_time`, `duo_duo_pay_reduction`) VALUES (1975857725197582337, 1009, '251007-217044764362431', 0, 0, 1, 1, 1, 2, 1, 0, 0, 0, 0, 29.35, 0, 29.35, 0, '', NULL, NULL, '', '2025-10-07 13:59:55', '2025-10-07 13:59:55', 'JT5419139774201', NULL, '', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, '中国', 0, '2025-10-07 08:27:48', '2025-10-07 08:27:50', '2025-10-07 08:27:50', '', '2025-10-07 23:59:59', NULL, 1, 0, 0, 0, 0, 0, NULL, 0, 0, 0, NULL, 0, 0, '', 0, NULL, '2025-10-08 09:37:27', '2025-10-08 17:37:27', NULL);
INSERT INTO `oms_pdd_order` (`id`, `shop_id`, `order_sn`, `trade_type`, `free_sf`, `is_lucky_flag`, `group_status`, `confirm_status`, `order_status`, `refund_status`, `after_sales_status`, `capital_free_discount`, `seller_discount`, `platform_discount`, `goods_amount`, `discount_amount`, `pay_amount`, `postage`, `remark`, `remark_tag`, `remark_tag_name`, `buyer_memo`, `updated_at`, `shipping_time`, `tracking_number`, `tracking_company`, `pay_type`, `pay_no`, `receiver_address`, `receiver_address_mask`, `receiver_name`, `receiver_phone`, `receiver_phone_mask`, `receiver_name_mask`, `address_mask`, `address`, `town`, `town_id`, `city`, `city_id`, `province`, `province_id`, `country`, `country_id`, `created_time`, `pay_time`, `confirm_time`, `receive_time`, `last_ship_time`, `tag`, `delivery_one_day`, `duoduo_wholesale`, `home_delivery_type`, `invoice_status`, `is_pre_sale`, `is_stock_out`, `logistics_id`, `mkt_biz_type`, `only_support_replace`, `order_change_amount`, `pre_sale_time`, `return_freight_payer`, `risk_control_status`, `urge_shipping_time`, `audit_status`, `audit_time`, `create_time`, `update_time`, `duo_duo_pay_reduction`) VALUES (1975858067217895425, 1009, '251007-545768097592317', 0, 0, 1, 1, 1, 1, 4, 10, 0, 0, 0, 39.32, 0, 39.32, 0, '', NULL, NULL, '', '2025-10-07 16:01:12', '', '', NULL, '', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, '中国', 0, '2025-10-07 16:00:20', '2025-10-07 16:00:21', '2025-10-07 16:00:22', '', '2025-10-08 16:00:22', NULL, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, NULL, 0, 0, '', 0, NULL, '2025-10-08 17:37:28', NULL, NULL);
INSERT INTO `oms_pdd_order` (`id`, `shop_id`, `order_sn`, `trade_type`, `free_sf`, `is_lucky_flag`, `group_status`, `confirm_status`, `order_status`, `refund_status`, `after_sales_status`, `capital_free_discount`, `seller_discount`, `platform_discount`, `goods_amount`, `discount_amount`, `pay_amount`, `postage`, `remark`, `remark_tag`, `remark_tag_name`, `buyer_memo`, `updated_at`, `shipping_time`, `tracking_number`, `tracking_company`, `pay_type`, `pay_no`, `receiver_address`, `receiver_address_mask`, `receiver_name`, `receiver_phone`, `receiver_phone_mask`, `receiver_name_mask`, `address_mask`, `address`, `town`, `town_id`, `city`, `city_id`, `province`, `province_id`, `country`, `country_id`, `created_time`, `pay_time`, `confirm_time`, `receive_time`, `last_ship_time`, `tag`, `delivery_one_day`, `duoduo_wholesale`, `home_delivery_type`, `invoice_status`, `is_pre_sale`, `is_stock_out`, `logistics_id`, `mkt_biz_type`, `only_support_replace`, `order_change_amount`, `pre_sale_time`, `return_freight_payer`, `risk_control_status`, `urge_shipping_time`, `audit_status`, `audit_time`, `create_time`, `update_time`, `duo_duo_pay_reduction`) VALUES (1975858164324421633, 1009, '251008-486340062721032', 0, 0, 1, 1, 1, 2, 1, 0, 0, 2.93, 0.5, 55.7, 3.43, 52.27, 0, '', NULL, NULL, '', '2025-10-08 15:09:16', '2025-10-08 15:09:16', 'JT5418763041082', NULL, '', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, '中国', 0, '2025-10-08 12:49:30', '2025-10-08 12:51:33', '2025-10-08 12:51:33', '', '2025-10-08 23:59:59', NULL, 1, 0, 0, 0, 0, 0, NULL, 0, 0, 3, NULL, 0, 0, '', 0, NULL, '2025-10-08 17:37:51', NULL, NULL);
INSERT INTO `oms_pdd_order` (`id`, `shop_id`, `order_sn`, `trade_type`, `free_sf`, `is_lucky_flag`, `group_status`, `confirm_status`, `order_status`, `refund_status`, `after_sales_status`, `capital_free_discount`, `seller_discount`, `platform_discount`, `goods_amount`, `discount_amount`, `pay_amount`, `postage`, `remark`, `remark_tag`, `remark_tag_name`, `buyer_memo`, `updated_at`, `shipping_time`, `tracking_number`, `tracking_company`, `pay_type`, `pay_no`, `receiver_address`, `receiver_address_mask`, `receiver_name`, `receiver_phone`, `receiver_phone_mask`, `receiver_name_mask`, `address_mask`, `address`, `town`, `town_id`, `city`, `city_id`, `province`, `province_id`, `country`, `country_id`, `created_time`, `pay_time`, `confirm_time`, `receive_time`, `last_ship_time`, `tag`, `delivery_one_day`, `duoduo_wholesale`, `home_delivery_type`, `invoice_status`, `is_pre_sale`, `is_stock_out`, `logistics_id`, `mkt_biz_type`, `only_support_replace`, `order_change_amount`, `pre_sale_time`, `return_freight_payer`, `risk_control_status`, `urge_shipping_time`, `audit_status`, `audit_time`, `create_time`, `update_time`, `duo_duo_pay_reduction`) VALUES (2013477542136061954, 1009, '260101-602941713932531', 0, 0, 1, 1, 1, 1, 4, 10, 0, 0, 10, 39.32, 10, 29.32, 0, '', NULL, NULL, '', '2026-01-01 14:53:57', '', '', NULL, '', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, '中国', 0, '2026-01-01 14:48:29', '2026-01-01 14:48:36', '2026-01-01 14:48:36', '', '2026-01-01 23:59:59', NULL, 1, 0, 0, 0, 0, 0, NULL, 0, 0, 0, NULL, 1, 0, '', 0, NULL, '2026-01-20 13:03:49', NULL, NULL);
INSERT INTO `oms_pdd_order` (`id`, `shop_id`, `order_sn`, `trade_type`, `free_sf`, `is_lucky_flag`, `group_status`, `confirm_status`, `order_status`, `refund_status`, `after_sales_status`, `capital_free_discount`, `seller_discount`, `platform_discount`, `goods_amount`, `discount_amount`, `pay_amount`, `postage`, `remark`, `remark_tag`, `remark_tag_name`, `buyer_memo`, `updated_at`, `shipping_time`, `tracking_number`, `tracking_company`, `pay_type`, `pay_no`, `receiver_address`, `receiver_address_mask`, `receiver_name`, `receiver_phone`, `receiver_phone_mask`, `receiver_name_mask`, `address_mask`, `address`, `town`, `town_id`, `city`, `city_id`, `province`, `province_id`, `country`, `country_id`, `created_time`, `pay_time`, `confirm_time`, `receive_time`, `last_ship_time`, `tag`, `delivery_one_day`, `duoduo_wholesale`, `home_delivery_type`, `invoice_status`, `is_pre_sale`, `is_stock_out`, `logistics_id`, `mkt_biz_type`, `only_support_replace`, `order_change_amount`, `pre_sale_time`, `return_freight_payer`, `risk_control_status`, `urge_shipping_time`, `audit_status`, `audit_time`, `create_time`, `update_time`, `duo_duo_pay_reduction`) VALUES (2013477542266085378, 1009, '260101-343073113703028', 0, 0, 1, 1, 1, 1, 4, 10, 0, 0, 0, 29.35, 0, 29.35, 0, '', NULL, NULL, '', '2026-01-01 20:52:17', '', '', NULL, '', '', '', '', '', '', '', '', '', '', '', 0, '', 0, '', 0, '中国', 0, '2026-01-01 20:47:51', '2026-01-01 20:47:51', '2026-01-01 20:47:51', '', '2026-01-02 20:47:51', NULL, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, NULL, 1, 0, '', 0, NULL, '2026-01-20 13:03:49', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for oms_pdd_order_item
-- ----------------------------
DROP TABLE IF EXISTS `oms_pdd_order_item`;
CREATE TABLE `oms_pdd_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id，自增',
  `order_sn` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号',
  `goods_id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '拼多多商品id',
  `sku_id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '拼多多商品skuid',
  `goods_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `goods_img` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品图片',
  `goods_spec` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品规格',
  `goods_price` double NOT NULL COMMENT '商品单价',
  `outer_goods_id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家外部编码（商品）',
  `outer_id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家外部编码（sku）',
  `goods_count` int NOT NULL COMMENT '商品数量',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `o_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_order_sn` (`order_sn`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2013477542282862594 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='拼多多订单明细表';

-- ----------------------------
-- Records of oms_pdd_order_item
-- ----------------------------
BEGIN;
INSERT INTO `oms_pdd_order_item` (`id`, `order_sn`, `goods_id`, `sku_id`, `goods_name`, `goods_img`, `goods_spec`, `goods_price`, `outer_goods_id`, `outer_id`, `goods_count`, `remark`, `o_goods_id`, `o_goods_sku_id`) VALUES (1975858066832019457, '251007-217044764362431', '754380133868', '1742164849115', '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/mms-material-img/2025-05-29/a3e7e689-5c30-495c-b5e0-90e38bd352b5.jpeg.a.jpeg', '12W白光-135mm', 29.35, 'LEDDX001', 'LEDDX00101', 1, NULL, 0, 0);
INSERT INTO `oms_pdd_order_item` (`id`, `order_sn`, `goods_id`, `sku_id`, `goods_name`, `goods_img`, `goods_spec`, `goods_price`, `outer_goods_id`, `outer_id`, `goods_count`, `remark`, `o_goods_id`, `o_goods_sku_id`) VALUES (1975858067280809986, '251007-545768097592317', '754380133868', '1742164849117', '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/mms-material-img/2025-05-29/70732144-21a8-423c-90df-553c3ea4fe36.jpeg.a.jpeg', '24W白光-215mm', 39.32, 'LEDDX001', 'LEDDX00103', 1, NULL, 0, 0);
INSERT INTO `oms_pdd_order_item` (`id`, `order_sn`, `goods_id`, `sku_id`, `goods_name`, `goods_img`, `goods_spec`, `goods_price`, `outer_goods_id`, `outer_id`, `goods_count`, `remark`, `o_goods_id`, `o_goods_sku_id`) VALUES (1975858164387336194, '251008-486340062721032', '754380133868', '1742164849115', '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/mms-material-img/2025-05-29/a3e7e689-5c30-495c-b5e0-90e38bd352b5.jpeg.a.jpeg', '12W白光-135mm', 29.35, 'LEDDX001', 'LEDDX00101', 2, NULL, 0, 0);
INSERT INTO `oms_pdd_order_item` (`id`, `order_sn`, `goods_id`, `sku_id`, `goods_name`, `goods_img`, `goods_spec`, `goods_price`, `outer_goods_id`, `outer_id`, `goods_count`, `remark`, `o_goods_id`, `o_goods_sku_id`) VALUES (1975879087140216833, '251006-010779369161362', '754380133868', '1742164849116', '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/mms-material-img/2025-05-29/dfb81deb-a7c1-4028-b6b1-b3f02fb63c72.jpeg.a.jpeg', '18W白光-175mm', 33.93, 'LEDDX001', 'LEDDX00102', 1, NULL, 0, 0);
INSERT INTO `oms_pdd_order_item` (`id`, `order_sn`, `goods_id`, `sku_id`, `goods_name`, `goods_img`, `goods_spec`, `goods_price`, `outer_goods_id`, `outer_id`, `goods_count`, `remark`, `o_goods_id`, `o_goods_sku_id`) VALUES (1975879095994392578, '251002-171237742200640', '753794079556', '1742373848730', '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/mms-material-img/2025-06-02/0d875ad2-529b-43be-b699-96748b4c0bb4.jpeg.a.jpeg', 'E27螺口 5瓦白光 1级能效', 12.49, 'LEDDP001', 'LEDDP00102', 1, NULL, 0, 0);
INSERT INTO `oms_pdd_order_item` (`id`, `order_sn`, `goods_id`, `sku_id`, `goods_name`, `goods_img`, `goods_spec`, `goods_price`, `outer_goods_id`, `outer_id`, `goods_count`, `remark`, `o_goods_id`, `o_goods_sku_id`) VALUES (1975879103783215105, '251002-085338365560640', '753794079556', '1742373848729', '雷士照明超亮LED节能灯E27大功率强光均匀三色可选一级能效护眼', 'https://img.pddpic.com/mms-material-img/2025-06-02/0d875ad2-529b-43be-b699-96748b4c0bb4.jpeg.a.jpeg', 'E27螺口 3瓦白光 1级能效', 9.9, 'LEDDP001', 'LEDDP00101', 1, NULL, 0, 0);
INSERT INTO `oms_pdd_order_item` (`id`, `order_sn`, `goods_id`, `sku_id`, `goods_name`, `goods_img`, `goods_spec`, `goods_price`, `outer_goods_id`, `outer_id`, `goods_count`, `remark`, `o_goods_id`, `o_goods_sku_id`) VALUES (1975879112142462977, '250929-351611154071222', '754380133868', '1742164849115', '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/mms-material-img/2025-05-29/a3e7e689-5c30-495c-b5e0-90e38bd352b5.jpeg.a.jpeg', '12W白光-135mm', 29.35, 'LEDDX001', 'LEDDX00101', 1, NULL, 0, 0);
INSERT INTO `oms_pdd_order_item` (`id`, `order_sn`, `goods_id`, `sku_id`, `goods_name`, `goods_img`, `goods_spec`, `goods_price`, `outer_goods_id`, `outer_id`, `goods_count`, `remark`, `o_goods_id`, `o_goods_sku_id`) VALUES (1975879123802628098, '250929-004537740820931', '754380133868', '1742164849115', '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/mms-material-img/2025-05-29/a3e7e689-5c30-495c-b5e0-90e38bd352b5.jpeg.a.jpeg', '12W白光-135mm', 29.35, 'LEDDX001', 'LEDDX00101', 1, NULL, 0, 0);
INSERT INTO `oms_pdd_order_item` (`id`, `order_sn`, `goods_id`, `sku_id`, `goods_name`, `goods_img`, `goods_spec`, `goods_price`, `outer_goods_id`, `outer_id`, `goods_count`, `remark`, `o_goods_id`, `o_goods_sku_id`) VALUES (2013477542178004994, '260101-602941713932531', '754380133868', '1742164849117', '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/mms-material-img/2025-05-29/70732144-21a8-423c-90df-553c3ea4fe36.jpeg.a.jpeg', '24W白光-215mm', 39.32, 'LEDDX001', 'LEDDX00103', 1, NULL, 0, 0);
INSERT INTO `oms_pdd_order_item` (`id`, `order_sn`, `goods_id`, `sku_id`, `goods_name`, `goods_img`, `goods_spec`, `goods_price`, `outer_goods_id`, `outer_id`, `goods_count`, `remark`, `o_goods_id`, `o_goods_sku_id`) VALUES (2013477542282862593, '260101-343073113703028', '754380133868', '1742164849115', '雷士照明LED光源灯芯正品保障客厅卧室餐厅书房吸顶灯LED灯板替换', 'https://img.pddpic.com/mms-material-img/2025-05-29/a3e7e689-5c30-495c-b5e0-90e38bd352b5.jpeg.a.jpeg', '12W白光-135mm', 29.35, 'LEDDX001', 'LEDDX00101', 1, NULL, 0, 0);
COMMIT;

-- ----------------------------
-- Table structure for oms_pdd_refund
-- ----------------------------
DROP TABLE IF EXISTS `oms_pdd_refund`;
CREATE TABLE `oms_pdd_refund` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '售后编号',
  `shop_id` int NOT NULL COMMENT '内部店铺ID',
  `order_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号',
  `after_sales_type` int NOT NULL COMMENT '售后类型 1：全部 2：仅退款 3：退货退款 4：换货 5：缺货补寄 6：维修',
  `after_sales_status` int NOT NULL COMMENT '售后状态 0：无售后 2：买家申请退款，待商家处理 3：退货退款，待商家处理 4：商家同意退款，退款中 5：平台同意退款，退款中 6：驳回退款，待买家处理 7：已同意退货退款,待用户发货 8：平台处理中 9：平台拒绝退款，退款关闭 10：退款成功 11：买家撤销 12：买家逾期未处理，退款失败 13：买家逾期，超过有效期 14：换货补寄待商家处理 15：换货补寄待用户处理 16：换货补寄成功 17：换货补寄失败 18：换货补寄待用户确认完成 21：待商家同意维修 22：待用户确认发货 24：维修关闭 25：维修成功 27：待用户确认收货 31：已同意拒收退款，待用户拒收 32：补寄待商家发货 33：待商家召回',
  `after_sale_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '售后原因',
  `confirm_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单成团时间',
  `created_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建时间',
  `discount_amount` double NOT NULL COMMENT '订单折扣金额（元）',
  `dispute_refund_status` double DEFAULT NULL COMMENT '1纠纷退款 0非纠纷退款',
  `goods_image` varchar(245) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品图片',
  `goods_id` bigint DEFAULT NULL COMMENT '拼多多商品id',
  `goods_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `goods_price` double NOT NULL COMMENT '商品价格，单位：元',
  `order_amount` double NOT NULL COMMENT '订单金额（元）',
  `refund_amount` double NOT NULL COMMENT '退款金额（元）',
  `refund_operator_role` int DEFAULT NULL COMMENT '同意退款操作人角色0:"默认",1:"用户",2:"商家",3:"平台",4:"系统",5:"团长",6:"司机",7:"代理人"',
  `sku_id` bigint DEFAULT NULL COMMENT '拼多多商品skuid',
  `outer_goods_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家外部编码（商品）',
  `outer_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '商家外部编码（sku）',
  `goods_spec` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '商品规格',
  `goods_number` int NOT NULL COMMENT '数量',
  `shipping_name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退货物流公司名称',
  `speed_refund_flag` int DEFAULT NULL COMMENT '极速退款标志位 1：极速退款，0：非极速退款',
  `speed_refund_status` int DEFAULT NULL COMMENT '极速退款状态，"1"：有极速退款资格，"2"：极速退款失败, "3" 表示极速退款成功，其他表示非极速退款',
  `user_shipping_status` int DEFAULT NULL COMMENT '0-未勾选 1-消费者选择的收货状态为未收到货 2-消费者选择的收货状态为已收到货',
  `tracking_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '快递单号',
  `updated_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新时间',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL COMMENT '系统更新时间',
  `o_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=40559843813 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='拼多多订单退款表';

-- ----------------------------
-- Records of oms_pdd_refund
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_tao_goods
-- ----------------------------
DROP TABLE IF EXISTS `oms_tao_goods`;
CREATE TABLE `oms_tao_goods` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `iid` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品id',
  `num_iid` bigint DEFAULT NULL COMMENT '商品数字id',
  `title` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品标题',
  `nick` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卖家昵称',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品类型(fixed:一口价;auction:拍卖)注：取消团购',
  `cid` bigint DEFAULT NULL COMMENT '商品所属的叶子类目 id',
  `seller_cids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品所属的店铺内卖家自定义类目列表',
  `pic_url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '主图',
  `num` int DEFAULT NULL COMMENT '商品数量',
  `props` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品属性 格式：pid:vid;pid:vid',
  `valid_thru` int DEFAULT NULL COMMENT '有效期,7或者14（默认是7天）',
  `has_discount` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支持会员打折,true/false',
  `has_invoice` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否有发票,true/false',
  `has_warranty` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否有保修,true/false',
  `has_showcase` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '橱窗推荐,true/false',
  `modified` datetime DEFAULT NULL COMMENT '商品修改时间（格式：yyyy-MM-dd HH:mm:ss）',
  `delist_time` datetime DEFAULT NULL COMMENT '下架时间（格式：yyyy-MM-dd HH:mm:ss）',
  `postage_id` bigint DEFAULT NULL COMMENT '宝贝所属的运费模板ID，如果没有返回则说明没有使用运费模板',
  `outer_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家外部编码(可与商家外部系统对接)。需要授权才能获取。',
  `list_time` datetime DEFAULT NULL COMMENT '上架时间（格式：yyyy-MM-dd HH:mm:ss）',
  `price` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品价格，格式：5.00；单位：元；精确到：分',
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `is_ex` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否在外部网店显示',
  `is_virtual` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '虚拟商品的状态字段',
  `is_taobao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否在淘宝显示',
  `sold_quantity` int DEFAULT '0' COMMENT '商品销量',
  `is_cspu` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否为达尔文挂接成功了的商品',
  `first_starts_time` datetime DEFAULT NULL COMMENT '商品首次上架时间',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `erp_goods_id` bigint DEFAULT NULL COMMENT 'erp商品id',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='淘宝商品表';

-- ----------------------------
-- Records of oms_tao_goods
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_tao_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `oms_tao_goods_sku`;
CREATE TABLE `oms_tao_goods_sku` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `tao_goods_id` bigint NOT NULL COMMENT '外键id',
  `num_iid` bigint NOT NULL COMMENT 'sku所属商品数字id',
  `iid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku所属商品id(注意：iid近期即将废弃，请用num_iid参数)',
  `sku_id` bigint NOT NULL COMMENT '商品skuid，阿里',
  `properties` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku的销售属性组合字符串（颜色，大小，等等，可通过类目API获取某类目下的销售属性）,格式是p1:v1;p2:v2',
  `properties_name` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku所对应的销售属性的中文名字串，格式如：pid1:vid1:pid_name1:vid_name1;pid2:vid2:pid_name2:vid_name2……',
  `quantity` bigint DEFAULT NULL COMMENT '属于这个sku的商品的数量，',
  `spec` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'specId',
  `price` double DEFAULT NULL COMMENT '属于这个sku的商品的价格 取值范围:0-100000000;精确到2位小数;单位:元。如:200.07，表示:200元7分。',
  `outer_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家设置的外部id。',
  `created` datetime DEFAULT NULL COMMENT 'sku创建日期 时间格式：yyyy-MM-dd HH:mm:ss',
  `modified` datetime DEFAULT NULL COMMENT 'sku最后修改日期 时间格式：yyyy-MM-dd HH:mm:ss',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku状态。	normal',
  `sku_spec_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表示SKu上的产品规格信息',
  `barcode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品级别的条形码',
  `erp_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `erp_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `sku_id_index` (`sku_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='淘宝商品SKU表';

-- ----------------------------
-- Records of oms_tao_goods_sku
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_tao_order
-- ----------------------------
DROP TABLE IF EXISTS `oms_tao_order`;
CREATE TABLE `oms_tao_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `shop_id` int NOT NULL DEFAULT '0' COMMENT '店铺id',
  `tid` bigint NOT NULL COMMENT '交易编号 (父订单的交易编号)',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '交易标题，以店铺名作为此标题的值。',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '交易类型列表，同时查询多种交易类型可用逗号分隔。',
  `seller_flag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卖家备注旗帜（与淘宝网上订单的卖家备注旗帜对应，只有卖家才能查看该字段）红、黄、绿、蓝、紫 分别对应 1、2、3、4、5',
  `has_buyer_message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '判断订单是否有买家留言，有买家留言返回true，否则返回false',
  `credit_card_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '使用信用卡支付金额数',
  `step_trade_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分阶段付款的订单状态（例如万人团订单等），目前有三返回状态FRONT_NOPAID_FINAL_NOPAID(定金未付尾款未付)，FRONT_PAID_FINAL_NOPAID(定金已付尾款未付)，FRONT_PAID_FINAL_PAID(定金和尾款都付)',
  `step_paid_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分阶段付款的已付金额（万人团订单已付金额）',
  `buyer_open_uid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家OpenUid',
  `mark_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单出现异常问题的时候，给予用户的描述,没有异常的时候，此值为空',
  `buyer_nick` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '买家昵称',
  `num_iid` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品数字编号',
  `num` int DEFAULT NULL COMMENT '商品购买数量。取值范围：大于零的整数,对于一个trade对应多个order的时候（一笔主订单，对应多笔子订单），num=0，num是一个跟商品关联的属性，一笔订单对应多比子订单的时候，主订单上的num无意义。',
  `price` decimal(10,2) DEFAULT NULL COMMENT '商品价格。精确到2位小数；单位：元。如：200.07，表示：200元7分',
  `total_fee` decimal(10,2) DEFAULT NULL COMMENT '商品金额（商品价格乘以数量的总金额）。精确到2位小数;单位:元。如:200.07，表示:200元7分',
  `adjust_fee` decimal(10,2) DEFAULT NULL COMMENT '卖家手工调整金额，精确到2位小数，单位：元。如：200.07',
  `post_fee` decimal(5,2) NOT NULL DEFAULT '0.00' COMMENT '邮费',
  `discount_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  `payment` decimal(10,2) NOT NULL COMMENT '实付金额',
  `received_payment` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '卖家实际收到的支付宝打款金额（由于子订单可以部分确认收货，这个金额会随着子订单的确认收货而不断增加，交易成功后等于买家实付款减去退款金额）。精确到2位小数;单位:元。如:200.07，表示:200元7分',
  `available_confirm_fee` decimal(10,2) DEFAULT NULL COMMENT '交易中剩余的确认收货金额（这个金额会随着子订单确认收货而不断减少，交易成功后会变为零）。精确到2位小数;单位:元。如:200.07，表示:200 元7分',
  `cod_fee` decimal(10,2) DEFAULT NULL COMMENT '货到付款服务费。',
  `cod_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '货到付款物流状态。初始状态 NEW_CREATED,接单成功 ACCEPTED_BY_COMPANY,接单失败 REJECTED_BY_COMPANY,接单超时 RECIEVE_TIMEOUT,揽收成功 TAKEN_IN_SUCCESS,揽收失败 TAKEN_IN_FAILED,揽收超时 TAKEN_TIMEOUT,签收成功 SIGN_IN,签收失败 REJECTED_BY_OTHER_SIDE,订单等待发送给物流公司 WAITING_TO_BE_SENT,用户取消物流订单 CANCELED',
  `buyer_cod_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家货到付款服务费',
  `seller_cod_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卖家货到付款服务费',
  `express_agency_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '快递代收款。',
  `commission_fee` float DEFAULT NULL COMMENT '交易佣金。',
  `shipping_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建交易时的物流方式（交易完成前，物流方式有可能改变，但系统里的这个字段一直不变）。可选值：free(卖家包邮),post(平邮),express(快递),ems(EMS),virtual(虚拟发货)，25(次日必达)，26(预约配送)。',
  `created` datetime NOT NULL COMMENT '交易创建时间。格式:yyyy-MM-dd HH:mm:ss',
  `modified` datetime DEFAULT NULL COMMENT '交易修改时间(用户对订单的任何修改都会更新此字段)。格式:yyyy-MM-dd HH:mm:ss',
  `pay_time` datetime DEFAULT NULL COMMENT '付款时间。格式:yyyy-MM-dd HH:mm:ss。订单的付款时间即为物流订单的创建时间。',
  `consign_time` datetime DEFAULT NULL COMMENT '卖家发货时间。格式:yyyy-MM-dd HH:mm:ss',
  `end_time` datetime DEFAULT NULL COMMENT '交易结束时间。交易成功时间(更新交易状态为成功的同时更新)/确认收货时间或者交易关闭时间 。格式:yyyy-MM-dd HH:mm:ss',
  `seller_memo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卖家备忘信息',
  `buyer_memo` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家备注',
  `buyer_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '买家留言',
  `point_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家使用积分,下单时生成，且一直不变。格式:100;单位:个.',
  `real_point_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家实际使用积分（扣除部分退款使用的积分），交易完成后生成（交易成功或关闭），交易未完成时该字段值为0。格式:100;单位:个',
  `buyer_obtain_point_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家获得积分,返点的积分。格式:100;单位:个。返点的积分要交易成功之后才能获得。',
  `receiving_time` datetime DEFAULT NULL COMMENT '收货时间，这里返回的是完全收货时间',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '交易状态。可选值: * TRADE_NO_CREATE_PAY(没有创建支付宝交易) * WAIT_BUYER_PAY(等待买家付款) * SELLER_CONSIGNED_PART(卖家部分发货) * WAIT_SELLER_SEND_GOODS(等待卖家发货,即:买家已付款) * WAIT_BUYER_CONFIRM_GOODS(等待买家确认收货,即:卖家已发货) * TRADE_BUYER_SIGNED(买家已签收,货到付款专用) * TRADE_FINISHED(交易成功) * TRADE_CLOSED(付款以后用户退款成功，交易自动关闭) * TRADE_CLOSED_BY_TAOBAO(付款以前，卖家或买家主动关闭交易) * PAY_PENDING(国际信用卡支付付款确认中) * WAIT_PRE_AUTH_CONFIRM(0元购合约中) * PAID_FORBID_CONSIGN(拼团中订单或者发货强管控的订单，已付款但禁止发货)',
  `trade_memo` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '交易备注。',
  `erp_send_company` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'erp发货快递公司',
  `erp_send_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'erp发货快递单号',
  `erp_send_status` int DEFAULT '0' COMMENT 'erp发货状态',
  `create_time` datetime DEFAULT NULL COMMENT '数据库创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '数据库更新时间',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '数据库更新人',
  `oaid` varchar(2552) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '（收货人+手机号+座机+收货地址+create）5个字段组合成oaid，原始订单上座机为空也满足条件，否则生成不了oaid',
  `aid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '地址aid字段',
  `receiver_country` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收货人国籍',
  `receiver_state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收货人的所在省份',
  `receiver_city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收货人的所在城市',
  `receiver_district` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收货人的所在地区',
  `receiver_town` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收货人街道地址',
  `receiver_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收货人的详细地址',
  `receiver_zip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收货人的邮编',
  `receiver_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收货人的姓名',
  `receiver_mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收货人的手机号码',
  `receiver_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收货人的电话号码',
  `seller_rate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卖家是否已评价。可选值:true(已评价),false(未评价)',
  `seller_nick` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卖家昵称',
  `buyer_rate` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '买家是否已评价。可选值:true(已评价),false(未评价)。如买家只评价未打分，此字段仍返回false',
  `buyer_area` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家下单的地区',
  `alipay_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付宝交易号，如：2009112081173831',
  `buyer_alipay_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家支付宝账号',
  `buyer_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家邮件地址',
  `seller_alipay_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卖家支付宝账号',
  `has_post_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否包含邮费。与available_confirm_fee同时使用。可选值:true(包含),false(不包含)',
  `timeout_action_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '超时到期时间。格式:yyyy-MM-dd HH:mm:ss。业务规则：前提条件：只有在买家已付款，卖家已发货的情况下才有效如果申请了退款，那么超时会落在子订单上；比如说3笔ABC，A申请了，那么返回的是BC的列表, 主定单不存在如果没有申请过退款，那么超时会挂在主定单上；比如ABC，返回主定单，ABC的超时和主定单相同',
  `snapshot_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '交易快照地址',
  `promotion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '交易促销详细信息',
  `yfx_fee` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单的运费险，单位为元',
  `has_yfx` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单中是否包含运费险订单，如果包含运费险订单返回true，不包含运费险订单，返回false',
  `send_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单将在此时间前发出，主要用于预售订单',
  `is_part_consign` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否是多次发货的订单如果卖家对订单进行多次发货，则为true否则为false',
  `sid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流运单号',
  `tmall_coupon_fee` bigint DEFAULT NULL COMMENT '天猫商家使用，订单使用的红包信息',
  `audit_status` int NOT NULL DEFAULT '0' COMMENT '0待确认，1已确认2已拦截-9未拉取',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_tid` (`tid`) USING BTREE,
  KEY `shop_id_index` (`shop_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='淘宝订单表';

-- ----------------------------
-- Records of oms_tao_order
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_tao_order_item
-- ----------------------------
DROP TABLE IF EXISTS `oms_tao_order_item`;
CREATE TABLE `oms_tao_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tid` bigint NOT NULL COMMENT '订单id',
  `oid` bigint NOT NULL COMMENT '子订单编号',
  `total_fee` decimal(10,2) DEFAULT NULL COMMENT '应付金额（商品价格 * 商品数量 + 手工调整金额 - 子订单级订单优惠金额）。精确到2位小数;单位:元。如:200.07，表示:200元7分',
  `discount_fee` decimal(10,2) DEFAULT NULL COMMENT '子订单级订单优惠金额。精确到2位小数;单位:元。如:200.07，表示:200元7分',
  `adjust_fee` decimal(10,2) DEFAULT NULL COMMENT '手工调整金额.格式为:1.01;单位:元;精确到小数点后两位.',
  `divide_order_fee` decimal(10,2) DEFAULT NULL COMMENT '分摊之后的实付金额',
  `part_mjz_discount` decimal(10,2) DEFAULT NULL COMMENT '优惠分摊',
  `payment` decimal(10,2) DEFAULT NULL COMMENT '子订单实付金额。精确到2位小数，单位:元。如:200.07，表示:200元7分。对于多子订单的交易，计算公式如下：payment = price * num + adjust_fee - discount_fee ；单子订单交易，payment与主订单的payment一致，对于退款成功的子订单，由于主订单的优惠分摊金额，会造成该字段可能不为0.00元。建议使用退款前的实付金额减去退款单中的实际退款金额计算。',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品标题',
  `pic_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品主图',
  `price` decimal(10,2) DEFAULT NULL COMMENT '商品价格',
  `num_iid` bigint DEFAULT NULL COMMENT '商品数字ID',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品的最小库存单位Sku的id.可以通过taobao.item.sku.get获取详细的Sku信息天猫的SKUID',
  `outer_iid` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家外部编码(可与商家外部系统对接)。',
  `outer_sku_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '外部网店自己定义的Sku编号',
  `sku_properties_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'SKU的值。如：机身颜色:黑色;手机套餐:官方标配',
  `item_meal_id` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '套餐ID',
  `item_meal_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '套餐的值。如：M8原装电池:便携支架:M8专用座充:莫凡保护袋',
  `num` int DEFAULT NULL COMMENT '数量',
  `timeout_action_time` datetime DEFAULT NULL COMMENT '订单超时到期时间。格式:yyyy-MM-dd HH:mm:ss',
  `item_memo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品备注',
  `buyer_rate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家是否已评价。可选值：true(已评价)，false(未评价)',
  `seller_rate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卖家是否已评价。可选值：true(已评价)，false(未评价)',
  `seller_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卖家类型，可选值为：B（商城商家），C（普通卖家）',
  `cid` bigint DEFAULT NULL COMMENT '交易商品对应的类目ID',
  `is_oversold` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '	是否超卖',
  `end_time` datetime DEFAULT NULL COMMENT '子订单的交易结束时间说明：子订单有单独的结束时间，与主订单的结束时间可能有所不同，在有退款发起的时候或者是主订单分阶段付款的时候，子订单的结束时间会早于主订单的结束时间，所以开放这个字段便于订单结束状态的判断',
  `order_from` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '子订单来源,如jhs(聚划算)、taobao(淘宝)、wap(无线)',
  `is_service_order` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否是服务订单，是返回true，否返回false。',
  `consign_time` datetime DEFAULT NULL COMMENT '子订单发货时间，当卖家对订单进行了多次发货，子订单的发货时间和主订单的发货时间可能不一样了，那么就需要以子订单的时间为准。（没有进行多次发货的订单，主订单的发货时间和子订单的发货时间都一样）',
  `shipping_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '子订单的运送方式（卖家对订单进行多次发货之后，一个主订单下的子订单的运送方式可能不同，用order.shipping_type来区分子订单的运送方式）',
  `logistics_company` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '子订单发货的快递公司名称',
  `invoice_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '子订单所在包裹的运单号',
  `bind_oid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '捆绑的子订单号，表示该子订单要和捆绑的子订单一起发货，用于卖家子订单捆绑发货',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单状态（请关注此状态，如果为TRADE_CLOSED_BY_TAOBAO状态，则不要对此订单进行发货，切记啊！）。可选值:\r\nTRADE_NO_CREATE_PAY(没有创建支付宝交易)\r\nWAIT_BUYER_PAY(等待买家付款)\r\nWAIT_SELLER_SEND_GOODS(等待卖家发货,即:买家已付款)\r\nWAIT_BUYER_CONFIRM_GOODS(等待买家确认收货,即:卖家已发货)\r\nTRADE_BUYER_SIGNED(买家已签收,货到付款专用)\r\nTRADE_FINISHED(交易成功)\r\nTRADE_CLOSED(付款以后用户退款成功，交易自动关闭)\r\nTRADE_CLOSED_BY_TAOBAO(付款以前，卖家或买家主动关闭交易)\r\nPAY_PENDING(国际信用卡支付付款确认中)',
  `refund_status` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'NO_REFUND' COMMENT '退款状态。退款状态。可选值 WAIT_SELLER_AGREE(买家已经申请退款，等待卖家同意) WAIT_BUYER_RETURN_GOODS(卖家已经同意退款，等待买家退货) WAIT_SELLER_CONFIRM_GOODS(买家已经退货，等待卖家确认收货) SELLER_REFUSE_BUYER(卖家拒绝退款) CLOSED(退款关闭) SUCCESS(退款成功)',
  `refund_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最近退款ID',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `o_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `tid_index` (`tid`) USING BTREE,
  KEY `oid_index` (`oid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='淘宝订单明细表';

-- ----------------------------
-- Records of oms_tao_order_item
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_tao_order_promotion
-- ----------------------------
DROP TABLE IF EXISTS `oms_tao_order_promotion`;
CREATE TABLE `oms_tao_order_promotion` (
  `id` bigint NOT NULL COMMENT '交易的主订单或子订单号',
  `promotion_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '优惠信息的名称',
  `discount_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '优惠金额（免运费、限时打折时为空）,单位：元',
  `gift_item_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '满就送商品时，所送商品的名称',
  `gift_item_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '赠品的宝贝id',
  `gift_item_num` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '满就送礼物的礼物数量',
  `promotion_desc` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '优惠活动的描述',
  `promotion_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '优惠id，(由营销工具id、优惠活动id和优惠详情id组成，结构为：营销工具id-优惠活动id_优惠详情id，如mjs-123024_211143）',
  `kd_discount_fee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分摊优惠金额（免运费、限时打折时为空）,单位：元',
  `kd_child_discount_fee` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '若优惠项在主订单上，返回子订单的分摊信息'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='淘宝订单优惠明细表';

-- ----------------------------
-- Records of oms_tao_order_promotion
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_tao_refund
-- ----------------------------
DROP TABLE IF EXISTS `oms_tao_refund`;
CREATE TABLE `oms_tao_refund` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `refund_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退款id',
  `dispute_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退款类型，可选值REFUND(仅退款),REFUND_AND_RETURN(退货退款),TMALL_EXCHANGE(天猫换货),TAOBAO_EXCHANGE(淘宝换货),REPAIR(维修),RESHIPPING(补寄),OTHERS(其他)',
  `shop_id` int NOT NULL COMMENT '店铺id',
  `tid` bigint DEFAULT NULL COMMENT '淘宝交易单号（订单号）',
  `oid` bigint DEFAULT NULL COMMENT '子订单号。如果是单笔交易oid会等于tid',
  `payment` float DEFAULT NULL COMMENT '支付给卖家的金额(交易总金额-退还给买家的金额)。精确到2位小数;单位:元。如:200.07，表示:200元7分',
  `price` float DEFAULT NULL COMMENT '商品价格。',
  `total_fee` float DEFAULT NULL COMMENT '交易总金额。精确到2位小数;单位:元。如:200.07，表示:200元7分',
  `refund_fee` float DEFAULT NULL COMMENT '退还金额(退还给买家的金额)。精确到2位小数;单位:元。如:200.07，表示:200元7分',
  `split_seller_fee` float DEFAULT NULL COMMENT '	分账给卖家的钱',
  `split_taobao_fee` float DEFAULT NULL COMMENT '分账给淘宝的钱',
  `created` datetime DEFAULT NULL COMMENT '退款申请时间。格式:yyyy-MM-dd HH:mm:ss',
  `modified` datetime DEFAULT NULL COMMENT '更新时间。格式:yyyy-MM-dd HH:mm:ss',
  `seller_nick` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卖家昵称',
  `cs_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '不需客服介入1;需要客服介入2;客服已经介入3;客服初审完成4;客服主管复审失败5;客服处理完成6;系统撤销(B2B使用)，维权撤销(集市使用) 7;支持买家 8;支持卖家 9;举证中 10;开放申诉 11;',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退款状态。可选值WAIT_SELLER_AGREE(买家已经申请退款，等待卖家同意) WAIT_BUYER_RETURN_GOODS(卖家已经同意退款，等待买家退货) WAIT_SELLER_CONFIRM_GOODS(买家已经退货，等待卖家确认收货) SELLER_REFUSE_BUYER(卖家拒绝退款) CLOSED(退款关闭) SUCCESS(退款成功)',
  `order_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退款对应的订单交易状态。可选值TRADE_NO_CREATE_PAY(没有创建支付宝交易) WAIT_BUYER_PAY(等待买家付款) WAIT_SELLER_SEND_GOODS(等待卖家发货,即:买家已付款) WAIT_BUYER_CONFIRM_GOODS(等待买家确认收货,即:卖家已发货) TRADE_BUYER_SIGNED(买家已签收,货到付款专用) TRADE_FINISHED(交易成功) TRADE_CLOSED(交易关闭) TRADE_CLOSED_BY_TAOBAO(交易被淘宝关闭) ALL_WAIT_PAY(包含：WAIT_BUYER_PAY、TRADE_NO_CREATE_PAY) ALL_CLOSED(包含：TRADE_CLOSED、TRADE_CLOSED_BY_TAOBAO) 取自"http://open.taobao.com/dev/index.php/%E4%BA%A4%E6%98%93%E7%8A%B6%E6%80%81"',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卖家收货地址',
  `advance_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退款先行垫付默认的未申请状态 0;退款先行垫付申请中 1;退款先行垫付，垫付完成 2;退款先行垫付，卖家拒绝收货 3;退款先行垫付，垫付关闭 4;退款先行垫付，垫付分账成功 5;',
  `alipay_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付宝交易号',
  `good_return_time` datetime DEFAULT NULL COMMENT '退货时间。格式:yyyy-MM-dd HH:mm:ss',
  `good_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '货物状态。可选值BUYER_NOT_RECEIVED (买家未收到货) BUYER_RECEIVED (买家已收到货) BUYER_RETURNED_GOODS (买家已退货)',
  `has_good_return` int DEFAULT NULL COMMENT '买家是否需要退货。可选值:true(是),false(否)',
  `num_iid` bigint DEFAULT NULL COMMENT '申请退款的商品数字编号',
  `num` bigint NOT NULL DEFAULT '0' COMMENT '退货数量',
  `outer_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品外部商家编码',
  `reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退款原因',
  `refund_phase` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退款阶段，可选值：onsale/aftersale',
  `shipping_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流方式.可选值:free(卖家包邮),post(平邮),express(快递),ems(EMS).',
  `desc1` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退款说明',
  `company_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流公司',
  `sid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退货运单号',
  `send_time` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家发货时间',
  `end_time` datetime DEFAULT NULL COMMENT '	完结时间。格式:yyyy-MM-dd HH:mm:ss',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品标题',
  `sku` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品SKU信息',
  `buyer_open_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家openUid',
  `buyer_nick` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家昵称',
  `combine_item_info` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '组合品信息\r\nnum_iid	String	2342344	商品数字编号\r\nitem_name	String	测试商品	商品标题\r\nquantity	Number	123	数量\r\nsku_id	String	123	sku_id\r\nouter_iid	String	123	商家外部编码(可与商家外部系统对接)\r\nouter_sku_id	String	123	123',
  `create_time` datetime DEFAULT NULL COMMENT '订单创建时间',
  `create_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `sku_id` bigint DEFAULT NULL COMMENT '平台skuId',
  `o_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `refund_id_index` (`refund_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='淘宝退款表';

-- ----------------------------
-- Records of oms_tao_refund
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_tao_waybill_account
-- ----------------------------
DROP TABLE IF EXISTS `oms_tao_waybill_account`;
CREATE TABLE `oms_tao_waybill_account` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `seller_id` bigint DEFAULT NULL COMMENT '商家ID',
  `cp_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流服务商编码',
  `cp_type` int DEFAULT NULL COMMENT '1是直营，2是加盟',
  `quantity` int DEFAULT NULL COMMENT '可用单数',
  `allocated_quantity` int DEFAULT NULL COMMENT '已用单数',
  `branch_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '网点ID',
  `branch_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '网点名称',
  `print_quantity` int DEFAULT NULL COMMENT '已经打印的面单总数',
  `cancel_quantity` int DEFAULT NULL COMMENT '取消的面对总数',
  `waybill_address_id` bigint DEFAULT NULL COMMENT 'waybill 地址记录ID(非地址库ID)',
  `province` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '省名称（一级地址）',
  `city` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '市名称（二级地址）',
  `area` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '区名称（三级地址）',
  `address_detail` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '详细地址',
  `name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货人',
  `mobile` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货手机号',
  `phone` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货固定电话',
  `is_show` int DEFAULT NULL COMMENT '是否前台显示1显示0不显示',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='淘宝电子面单账户信息表';

-- ----------------------------
-- Records of oms_tao_waybill_account
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_wei_goods
-- ----------------------------
DROP TABLE IF EXISTS `oms_wei_goods`;
CREATE TABLE `oms_wei_goods` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint DEFAULT NULL COMMENT '店铺id',
  `product_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '平台商品id',
  `out_product_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家编码id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品标题',
  `sub_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `head_imgs` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '主图集合',
  `head_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '第一张主图',
  `desc_info` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品详情字符串',
  `attrs` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性字符串',
  `status` int DEFAULT NULL COMMENT '状态',
  `edit_status` int DEFAULT NULL COMMENT '编辑状态',
  `min_price` int DEFAULT NULL COMMENT '商品 SKU 最小价格（单位：分）',
  `spu_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品编码',
  `product_type` int DEFAULT NULL COMMENT '商品类型。1: 小店普通自营商品；2: 福袋抽奖商品；3: 直播间闪电购商品。注意: 福袋抽奖、直播间闪电购类型的商品为只读数据，不支持编辑、上架操作，不支持用data_type=2的参数获取。',
  `edit_time` int DEFAULT NULL COMMENT '商品草稿最近一次修改时间',
  `erp_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of oms_wei_goods
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_wei_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `oms_wei_goods_sku`;
CREATE TABLE `oms_wei_goods_sku` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint DEFAULT NULL COMMENT '店铺id',
  `product_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '产品id',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'skuID',
  `out_sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家自定义skuID。如果添加时没录入，回包可能不包含该字段',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品标题',
  `thumb_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku小图',
  `sale_price` int DEFAULT NULL COMMENT '售卖价格，以分为单位',
  `stock_num` int DEFAULT NULL COMMENT 'sku库存',
  `sku_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku编码',
  `status` int DEFAULT NULL COMMENT 'sku状态',
  `sku_attr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku属性',
  `sku_attrs` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku_attrs',
  `sku_deliver_info` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku_deliver_info',
  `erp_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `erp_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `sku_id_index` (`sku_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of oms_wei_goods_sku
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_wei_order
-- ----------------------------
DROP TABLE IF EXISTS `oms_wei_order`;
CREATE TABLE `oms_wei_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` int DEFAULT NULL COMMENT '店铺id',
  `order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单号',
  `openid` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家身份标识',
  `create_time` int DEFAULT NULL COMMENT '秒级时间戳',
  `update_time` int DEFAULT NULL COMMENT '秒级时间戳',
  `unionid` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` int DEFAULT NULL COMMENT '状态10	待付款；20	待发货；21	部分发货；30	待收货；100	完成；200	全部商品售后之后，订单取消；250	未付款用户主动取消或超时未付款订单自动取消；',
  `aftersale_detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '售后信息json',
  `pay_info` varchar(5500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付信息json',
  `product_price` int DEFAULT NULL COMMENT '商品总价，单位为分',
  `order_price` int DEFAULT NULL COMMENT '订单金额，单位为分，order_price=original_order_price-discounted_price-deduction_price-change_down_price',
  `freight` int DEFAULT NULL COMMENT '运费，单位为分',
  `discounted_price` int DEFAULT NULL COMMENT '优惠券优惠金额，单位为分',
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收货人姓名',
  `postal_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮编',
  `province_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '省份',
  `city_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '城市',
  `county_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '区',
  `detail_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '详细地址',
  `tel_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系方式\r\n',
  `house_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '门牌号码',
  `virtual_order_tel_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '虚拟发货订单联系方式(deliver_method=1时返回)',
  `tel_number_ext_info` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '额外的联系方式信息（虚拟号码相关）',
  `use_tel_number` int DEFAULT NULL COMMENT '0：不使用虚拟号码，1：使用虚拟号码',
  `hash_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标识当前店铺下一个唯一的用户收货地址',
  `delivery_product_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '发货物流信息JSON',
  `ship_done_time` int DEFAULT NULL COMMENT '发货完成时间，秒级时间戳',
  `ewaybill_order_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '电子面单代发时的订单密文\r\n',
  `settle_info` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结算信息json',
  `audit_status` int DEFAULT NULL COMMENT '订单审核状态（0待审核1已审核）',
  `audit_time` datetime DEFAULT NULL COMMENT '订单审核时间',
  `erp_send_company` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'erp发货快递公司',
  `erp_send_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'erp发货快递单号',
  `erp_send_status` int DEFAULT '0' COMMENT 'erp发货状态',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `order_id_index` (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2013566020173561858 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of oms_wei_order
-- ----------------------------
BEGIN;
INSERT INTO `oms_wei_order` (`id`, `shop_id`, `order_id`, `openid`, `create_time`, `update_time`, `unionid`, `status`, `aftersale_detail`, `pay_info`, `product_price`, `order_price`, `freight`, `discounted_price`, `user_name`, `postal_code`, `province_name`, `city_name`, `county_name`, `detail_info`, `tel_number`, `house_number`, `virtual_order_tel_number`, `tel_number_ext_info`, `use_tel_number`, `hash_code`, `delivery_product_info`, `ship_done_time`, `ewaybill_order_code`, `settle_info`, `audit_status`, `audit_time`, `erp_send_company`, `erp_send_code`, `erp_send_status`) VALUES (2013566019775102977, 1012, '3732020127376219136', 'oVlvg5OITOvZQ2PVmvycrr_1qXa4', 1762137170, 1762137536, NULL, 250, '{\"aftersale_order_list\":[],\"on_aftersale_order_cnt\":0}', '{\"prepay_id\":\"up_wx0310325136164702dc3605957adc7f0000\",\"prepay_time\":1762137171}', 3990, 3990, 0, NULL, '齐**', '000000', '广东省', '深圳市', '宝安区', '****', '158****0119', '', '', 'null', 0, '5f2f993769c055852bb3da1592ac10d2', '[]', 0, 'ofg1xYAvyPvG7TBdaccKsuYY9hx624r_ekLtm7hPZBNePySgTfcNzHcHxhf-RVhpfw8bI9nc3O-w', '{\"predict_commission_fee\":0}', 0, NULL, NULL, NULL, 0);
INSERT INTO `oms_wei_order` (`id`, `shop_id`, `order_id`, `openid`, `create_time`, `update_time`, `unionid`, `status`, `aftersale_detail`, `pay_info`, `product_price`, `order_price`, `freight`, `discounted_price`, `user_name`, `postal_code`, `province_name`, `city_name`, `county_name`, `detail_info`, `tel_number`, `house_number`, `virtual_order_tel_number`, `tel_number_ext_info`, `use_tel_number`, `hash_code`, `delivery_product_info`, `ship_done_time`, `ewaybill_order_code`, `settle_info`, `audit_status`, `audit_time`, `erp_send_company`, `erp_send_code`, `erp_send_status`) VALUES (2013566019926097922, 1012, '3732019710102225152', 'oVlvg5OITOvZQ2PVmvycrr_1qXa4', 1762135579, 1762136146, NULL, 250, '{\"aftersale_order_list\":[],\"on_aftersale_order_cnt\":0}', '{\"prepay_id\":\"up_wx0310062046287080b09a7c15b5c5160001\",\"prepay_time\":1762135580}', 3990, 3990, 0, NULL, '齐**', '000000', '广东省', '深圳市', '宝安区', '****', '158****0119', '', '', 'null', 0, '5f2f993769c055852bb3da1592ac10d2', '[]', 0, 'ofbq0leqpQDlVH2lmxhFRVof2j5F_QRtWwU2dLRiTtBK2UFkAZu9eo1oh0bO29qKRzgltEpTuD_w', '{\"predict_commission_fee\":0}', 0, NULL, NULL, NULL, 0);
INSERT INTO `oms_wei_order` (`id`, `shop_id`, `order_id`, `openid`, `create_time`, `update_time`, `unionid`, `status`, `aftersale_detail`, `pay_info`, `product_price`, `order_price`, `freight`, `discounted_price`, `user_name`, `postal_code`, `province_name`, `city_name`, `county_name`, `detail_info`, `tel_number`, `house_number`, `virtual_order_tel_number`, `tel_number_ext_info`, `use_tel_number`, `hash_code`, `delivery_product_info`, `ship_done_time`, `ewaybill_order_code`, `settle_info`, `audit_status`, `audit_time`, `erp_send_company`, `erp_send_code`, `erp_send_status`) VALUES (2013566020014178305, 1012, '3732019573055177472', 'oVlvg5OITOvZQ2PVmvycrr_1qXa4', 1762135056, 1762135558, NULL, 250, '{\"aftersale_order_list\":[],\"on_aftersale_order_cnt\":0}', '{\"prepay_id\":\"up_wx03095737653182d83852649e0f35f60000\",\"prepay_time\":1762135057}', 3990, 3990, 0, NULL, '齐**', '000000', '广东省', '深圳市', '宝安区', '****', '158****0119', '', '', 'null', 0, '5f2f993769c055852bb3da1592ac10d2', '[]', 0, 'ofIllike3VQsOj9FoP01qGFfLPdQntlhIh9qg6JbkkIz4Ue6QJj8Z_0qLwADM2CM9-p1fD4gy98w', '{\"predict_commission_fee\":0}', 0, NULL, NULL, NULL, 0);
INSERT INTO `oms_wei_order` (`id`, `shop_id`, `order_id`, `openid`, `create_time`, `update_time`, `unionid`, `status`, `aftersale_detail`, `pay_info`, `product_price`, `order_price`, `freight`, `discounted_price`, `user_name`, `postal_code`, `province_name`, `city_name`, `county_name`, `detail_info`, `tel_number`, `house_number`, `virtual_order_tel_number`, `tel_number_ext_info`, `use_tel_number`, `hash_code`, `delivery_product_info`, `ship_done_time`, `ewaybill_order_code`, `settle_info`, `audit_status`, `audit_time`, `erp_send_company`, `erp_send_code`, `erp_send_status`) VALUES (2013566020102258690, 1012, '3732019206799114496', 'oVlvg5OITOvZQ2PVmvycrr_1qXa4', 1762133659, 1762134121, NULL, 250, '{\"aftersale_order_list\":[],\"on_aftersale_order_cnt\":0}', '{\"prepay_id\":\"up_wx03093420851925b5e20cdc7891abbf0001\",\"prepay_time\":1762133661}', 3990, 3990, 0, NULL, '齐**', '000000', '广东省', '深圳市', '宝安区', '****', '158****0119', '', '', 'null', 0, '5f2f993769c055852bb3da1592ac10d2', '[]', 0, 'ofI1wjDLfJ2Ybuq4bbkYapcSRPdLyEu0jl8FVwWu8m_h4ovKhUIyMkX2HULh5lFzuUIdNXTKJG6Q', '{\"predict_commission_fee\":0}', 0, NULL, NULL, NULL, 0);
INSERT INTO `oms_wei_order` (`id`, `shop_id`, `order_id`, `openid`, `create_time`, `update_time`, `unionid`, `status`, `aftersale_detail`, `pay_info`, `product_price`, `order_price`, `freight`, `discounted_price`, `user_name`, `postal_code`, `province_name`, `city_name`, `county_name`, `detail_info`, `tel_number`, `house_number`, `virtual_order_tel_number`, `tel_number_ext_info`, `use_tel_number`, `hash_code`, `delivery_product_info`, `ship_done_time`, `ewaybill_order_code`, `settle_info`, `audit_status`, `audit_time`, `erp_send_company`, `erp_send_code`, `erp_send_status`) VALUES (2013566020173561857, 1012, '3732018776705210880', 'oVlvg5OITOvZQ2PVmvycrr_1qXa4', 1762132017, 1762132391, NULL, 250, '{\"aftersale_order_list\":[],\"on_aftersale_order_cnt\":0}', '{\"prepay_id\":\"up_wx03090658797600710ef0e6b43dce1b0000\",\"prepay_time\":1762132018}', 3990, 3990, 0, NULL, '齐**', '000000', '广东省', '深圳市', '宝安区', '****', '158****0119', '', '', 'null', 0, '5f2f993769c055852bb3da1592ac10d2', '[]', 0, 'ofmuHXgcMO_EyX91JCYzbe4hiz_tx5ayR5bNqYlEGEyHu8Ugw4AOKiPKzpR2qhgGuLjuQ1bKT3tw', '{\"predict_commission_fee\":0}', 0, NULL, NULL, NULL, 0);
COMMIT;

-- ----------------------------
-- Table structure for oms_wei_order_item
-- ----------------------------
DROP TABLE IF EXISTS `oms_wei_order_item`;
CREATE TABLE `oms_wei_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单id（平台订单id）',
  `product_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品spuid',
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品skuid\r\n',
  `thumb_img` varchar(550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku小图',
  `sku_cnt` int DEFAULT NULL COMMENT 'sku数量',
  `sale_price` int DEFAULT NULL COMMENT '售卖单价（单位：分）',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品标题',
  `on_aftersale_sku_cnt` int DEFAULT NULL COMMENT '正在售后/退款流程中的 sku 数量',
  `finish_aftersale_sku_cnt` int DEFAULT NULL COMMENT '完成售后/退款的 sku 数量',
  `sku_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品编码',
  `market_price` int DEFAULT NULL COMMENT '市场单价（单位：分）',
  `sku_attrs` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sku属性JSON',
  `real_price` int DEFAULT NULL COMMENT 'sku实付总价，取estimate_price和change_price中较小值',
  `out_product_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品外部spuid',
  `out_sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品外部skuid',
  `is_discounted` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否有优惠金额，非必填，默认为false',
  `estimate_price` int DEFAULT NULL COMMENT '优惠后sku总价，非必填，is_discounted为true时有值',
  `is_change_price` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否修改过价格，非必填，默认为false',
  `change_price` int DEFAULT NULL COMMENT '改价后sku总价，非必填，is_change_price为true时有值',
  `out_warehouse_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '区域库存id',
  `sku_deliver_info` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品发货信息JSON',
  `extra_service` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品额外服务信息JSON',
  `use_deduction` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否使用了会员积分抵扣\r\n',
  `deduction_price` int DEFAULT NULL COMMENT '会员积分抵扣金额，单位为分',
  `order_product_coupon_info_list` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品优惠券信息，逐步替换 order.order_detail.coupon_info',
  `o_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2013566020194533379 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of oms_wei_order_item
-- ----------------------------
BEGIN;
INSERT INTO `oms_wei_order_item` (`id`, `shop_id`, `order_id`, `product_id`, `sku_id`, `thumb_img`, `sku_cnt`, `sale_price`, `title`, `on_aftersale_sku_cnt`, `finish_aftersale_sku_cnt`, `sku_code`, `market_price`, `sku_attrs`, `real_price`, `out_product_id`, `out_sku_id`, `is_discounted`, `estimate_price`, `is_change_price`, `change_price`, `out_warehouse_id`, `sku_deliver_info`, `extra_service`, `use_deduction`, `deduction_price`, `order_product_coupon_info_list`, `o_goods_id`, `o_goods_sku_id`) VALUES (2013566019838017537, 1012, '3732020127376219136', '10000239803737', '3531475359', 'https://wst.wxapp.tc.qq.com/161/20304/snscosdownload/SZ/reserved/6839f1ff00015fba288ae5867af20115000000a000004f50', 1, 3990, '雷士照明led吸顶灯灯芯替换圆形灯板节能灯芯冷光高显6W至40W护眼', 0, 0, '', 3990, '[{\"attr_key\":\"规格\",\"attr_value\":\"18W白光\"}]', 3990, NULL, NULL, 'null', 3990, 'null', NULL, '', '{\"stock_type\":0}', '{\"seven_day_return\":1,\"freight_insurance\":0}', 'null', NULL, '[]', NULL, NULL);
INSERT INTO `oms_wei_order_item` (`id`, `shop_id`, `order_id`, `product_id`, `sku_id`, `thumb_img`, `sku_cnt`, `sale_price`, `title`, `on_aftersale_sku_cnt`, `finish_aftersale_sku_cnt`, `sku_code`, `market_price`, `sku_attrs`, `real_price`, `out_product_id`, `out_sku_id`, `is_discounted`, `estimate_price`, `is_change_price`, `change_price`, `out_warehouse_id`, `sku_deliver_info`, `extra_service`, `use_deduction`, `deduction_price`, `order_product_coupon_info_list`, `o_goods_id`, `o_goods_sku_id`) VALUES (2013566019963846657, 1012, '3732019710102225152', '10000239803737', '3531475359', 'https://wst.wxapp.tc.qq.com/161/20304/snscosdownload/SZ/reserved/6839f1ff00015fba288ae5867af20115000000a000004f50', 1, 3990, '雷士照明led吸顶灯灯芯替换圆形灯板节能灯芯冷光高显6W至40W护眼', 0, 0, '', 3990, '[{\"attr_key\":\"规格\",\"attr_value\":\"18W白光\"}]', 3990, NULL, NULL, 'null', 3990, 'null', NULL, '', '{\"stock_type\":0}', '{\"seven_day_return\":1,\"freight_insurance\":0}', 'null', NULL, '[]', NULL, NULL);
INSERT INTO `oms_wei_order_item` (`id`, `shop_id`, `order_id`, `product_id`, `sku_id`, `thumb_img`, `sku_cnt`, `sale_price`, `title`, `on_aftersale_sku_cnt`, `finish_aftersale_sku_cnt`, `sku_code`, `market_price`, `sku_attrs`, `real_price`, `out_product_id`, `out_sku_id`, `is_discounted`, `estimate_price`, `is_change_price`, `change_price`, `out_warehouse_id`, `sku_deliver_info`, `extra_service`, `use_deduction`, `deduction_price`, `order_product_coupon_info_list`, `o_goods_id`, `o_goods_sku_id`) VALUES (2013566020051927042, 1012, '3732019573055177472', '10000239803737', '3531475359', 'https://wst.wxapp.tc.qq.com/161/20304/snscosdownload/SZ/reserved/6839f1ff00015fba288ae5867af20115000000a000004f50', 1, 3990, '雷士照明led吸顶灯灯芯替换圆形灯板节能灯芯冷光高显6W至40W护眼', 0, 0, '', 3990, '[{\"attr_key\":\"规格\",\"attr_value\":\"18W白光\"}]', 3990, NULL, NULL, 'null', 3990, 'null', NULL, '', '{\"stock_type\":0}', '{\"seven_day_return\":1,\"freight_insurance\":0}', 'null', NULL, '[]', NULL, NULL);
INSERT INTO `oms_wei_order_item` (`id`, `shop_id`, `order_id`, `product_id`, `sku_id`, `thumb_img`, `sku_cnt`, `sale_price`, `title`, `on_aftersale_sku_cnt`, `finish_aftersale_sku_cnt`, `sku_code`, `market_price`, `sku_attrs`, `real_price`, `out_product_id`, `out_sku_id`, `is_discounted`, `estimate_price`, `is_change_price`, `change_price`, `out_warehouse_id`, `sku_deliver_info`, `extra_service`, `use_deduction`, `deduction_price`, `order_product_coupon_info_list`, `o_goods_id`, `o_goods_sku_id`) VALUES (2013566020140007426, 1012, '3732019206799114496', '10000239803737', '3531475359', 'https://wst.wxapp.tc.qq.com/161/20304/snscosdownload/SZ/reserved/6839f1ff00015fba288ae5867af20115000000a000004f50', 1, 3990, '雷士照明led吸顶灯灯芯替换圆形灯板节能灯芯冷光高显6W至40W护眼', 0, 0, '', 3990, '[{\"attr_key\":\"规格\",\"attr_value\":\"18W白光\"}]', 3990, NULL, NULL, 'null', 3990, 'null', NULL, '', '{\"stock_type\":0}', '{\"seven_day_return\":1,\"freight_insurance\":0}', 'null', NULL, '[]', NULL, NULL);
INSERT INTO `oms_wei_order_item` (`id`, `shop_id`, `order_id`, `product_id`, `sku_id`, `thumb_img`, `sku_cnt`, `sale_price`, `title`, `on_aftersale_sku_cnt`, `finish_aftersale_sku_cnt`, `sku_code`, `market_price`, `sku_attrs`, `real_price`, `out_product_id`, `out_sku_id`, `is_discounted`, `estimate_price`, `is_change_price`, `change_price`, `out_warehouse_id`, `sku_deliver_info`, `extra_service`, `use_deduction`, `deduction_price`, `order_product_coupon_info_list`, `o_goods_id`, `o_goods_sku_id`) VALUES (2013566020194533378, 1012, '3732018776705210880', '10000239803737', '3531475359', 'https://wst.wxapp.tc.qq.com/161/20304/snscosdownload/SZ/reserved/6839f1ff00015fba288ae5867af20115000000a000004f50', 1, 3990, '雷士照明led吸顶灯灯芯替换圆形灯板节能灯芯冷光高显6W至40W护眼', 0, 0, '', 3990, '[{\"attr_key\":\"规格\",\"attr_value\":\"18W白光\"}]', 3990, NULL, NULL, 'null', 3990, 'null', NULL, '', '{\"stock_type\":0}', '{\"seven_day_return\":1,\"freight_insurance\":0}', 'null', NULL, '[]', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for oms_wei_refund
-- ----------------------------
DROP TABLE IF EXISTS `oms_wei_refund`;
CREATE TABLE `oms_wei_refund` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` int DEFAULT NULL COMMENT '店铺id',
  `after_sale_order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '售后单号',
  `after_sales_status` int DEFAULT NULL COMMENT '售后状态（参考拼多多）',
  `after_sales_type` int DEFAULT NULL COMMENT '售后类型（参考拼多多）',
  `status` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '售后单当前状态，参考：\r\nUSER_CANCELD	用户取消申请\r\nMERCHANT_PROCESSING	商家受理中\r\nMERCHANT_REJECT_REFUND	商家拒绝退款\r\nMERCHANT_REJECT_RETURN	商家拒绝退货退款\r\nUSER_WAIT_RETURN	待买家退货\r\nRETURN_CLOSED	退货退款关闭\r\nMERCHANT_WAIT_RECEIPT	待商家收货\r\nMERCHANT_OVERDUE_REFUND	商家逾期未退款\r\nMERCHANT_REFUND_SUCCESS	退款完成\r\nMERCHANT_RETURN_SUCCESS	退货退款完成\r\nPLATFORM_REFUNDING	平台退款中\r\nPLATFORM_REFUND_FAIL	平台退款失败\r\nUSER_WAIT_CONFIRM	待用户确认\r\nMERCHANT_REFUND_RETRY_FAIL	商家打款失败，客服关闭售后\r\nMERCHANT_FAIL	售后关闭\r\nUSER_WAIT_CONFIRM_UPDATE	待用户处理商家协商\r\nUSER_WAIT_HANDLE_MERCHANT_AFTER_SALE	待用户处理商家代发起的售后申请',
  `openid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家身份标识',
  `unionid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '买家在开放平台的唯一标识符，若当前视频号小店已绑定到微信开放平台账号下会返回',
  `product_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品spuid',
  `sku_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品skuid',
  `count` int DEFAULT NULL COMMENT '售后数量',
  `fast_refund` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否极速退款RefundInfo',
  `refund_reason` int DEFAULT NULL COMMENT '标明售后单退款直接原因, 枚举值参考 RefundReason',
  `refund_amount` int DEFAULT NULL COMMENT '退款金额（分）',
  `return_waybill_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '快递单号',
  `return_delivery_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流公司id',
  `return_delivery_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流公司名称',
  `merchant_upload_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '售后相关商品信息JSON',
  `create_time` int DEFAULT NULL COMMENT '售后单创建时间戳',
  `update_time` int DEFAULT NULL COMMENT '售后单更新时间戳',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退款原因',
  `reason_text` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退款原因解释',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '售后类型。REFUND:退款；RETURN:退货退款。',
  `order_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单号，该字段可用于获取订单',
  `details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'detail json',
  `complaint_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '纠纷id，该字段可用于获取纠纷信息',
  `refund_resp` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '微信支付退款的响应',
  `pull_status` int DEFAULT NULL COMMENT '推送状态（0未推送；1推送成功；2推送失败）',
  `pull_time` datetime DEFAULT NULL COMMENT '订单审核时间',
  `o_goods_id` bigint DEFAULT NULL COMMENT '商品id(o_goods外键)',
  `o_goods_sku_id` bigint DEFAULT NULL COMMENT '商品skuid(o_goods_sku外键)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='视频号小店退款';

-- ----------------------------
-- Records of oms_wei_refund
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for oms_wei_waybill_account
-- ----------------------------
DROP TABLE IF EXISTS `oms_wei_waybill_account`;
CREATE TABLE `oms_wei_waybill_account` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_id` bigint NOT NULL COMMENT '店铺id',
  `seller_shop_id` bigint DEFAULT NULL COMMENT '平台店铺id，全局唯一，一个店铺分配一个shop_id',
  `delivery_id` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '快递公司编码',
  `company_type` int DEFAULT NULL COMMENT '快递公司类型1：加盟型 2：直营型',
  `site_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '网点编码',
  `site_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '网点名称',
  `acct_id` bigint DEFAULT NULL COMMENT '电子面单账号id，每绑定一个网点分配一个acct_id',
  `acct_type` int DEFAULT NULL COMMENT '面单账号类型0：普通账号 1：共享账号',
  `status` int DEFAULT NULL COMMENT '面单账号状态',
  `available` int DEFAULT NULL COMMENT '面单余额',
  `allocated` int DEFAULT NULL COMMENT '累积已取单',
  `cancel` int DEFAULT NULL COMMENT '累计已取消',
  `recycled` int DEFAULT NULL COMMENT '累积已回收',
  `monthly_card` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '月结账号，company_type 为直营型时有效',
  `site_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '网点信息JSON',
  `sender_province` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '省名称（一级地址）',
  `sender_city` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '市名称（二级地址）',
  `sender_county` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sender_street` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sender_address` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '详细地址',
  `name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货人',
  `mobile` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货手机号',
  `phone` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货固定电话',
  `is_show` int DEFAULT NULL COMMENT '是否前台显示1显示0不显示',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='视频号小店电子面单账户信息表';

-- ----------------------------
-- Records of oms_wei_waybill_account
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='参数配置表';

-- ----------------------------
-- Records of sys_config
-- ----------------------------
BEGIN;
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, '系统名称', 'sys.name', '启航电商OMS系统', 'Y', 'admin', '2023-08-07 19:31:38', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'false', 'Y', 'admin', '2023-08-07 19:31:38', '', NULL, '是否开启验证码功能（true开启，false关闭）');
COMMIT;

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='部门表';

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
BEGIN;
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (100, 0, '0', '启航技术', 0, '老齐', '15888888888', '280645618@qq.com', '0', '0', 'admin', '2023-08-07 19:31:37', 'admin', '2024-09-15 17:52:12');
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (101, 100, '0,100', '研发中心', 1, '老齐', '15888888888', '280645618@qq.com', '0', '0', 'admin', '2023-08-07 19:31:37', 'admin', '2024-09-15 17:52:47');
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (102, 100, '0,100', '市场中心', 2, '方', '15888888888', 'market@qihangerp.cn', '0', '0', 'admin', '2023-08-07 19:31:37', 'admin', '2024-09-15 17:53:28');
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (103, 101, '0,100,101', '研发部门', 1, '至简', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2023-08-07 19:31:37', '', NULL);
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (104, 101, '0,100,101', '市场部门', 2, '至简', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2023-08-07 19:31:37', '', NULL);
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (105, 101, '0,100,101', '测试部门', 3, '至简', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2023-08-07 19:31:37', '', NULL);
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (106, 101, '0,100,101', '财务部门', 4, '至简', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2023-08-07 19:31:37', '', NULL);
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (107, 101, '0,100,101', '运维部门', 5, '至简', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2023-08-07 19:31:37', '', NULL);
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (108, 102, '0,100,102', '市场部门', 1, '至简', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2023-08-07 19:31:37', '', NULL);
INSERT INTO `sys_dept` (`dept_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (109, 102, '0,100,102', '财务部门', 2, '至简', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2023-08-07 19:31:37', '', NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='字典数据表';

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
BEGIN;
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '性别男');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '性别女');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '通知');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '公告');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '停用状态');
COMMIT;

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE KEY `dict_type` (`dict_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='字典类型表';

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
BEGIN;
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2023-08-07 19:31:38', '', NULL, '登录状态列表');
COMMIT;

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '路由参数',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2130 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='菜单权限表';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
BEGIN;
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, '订单管理', 0, 10, '/order', 'Layout', '', 1, 0, 'M', '0', '0', '', 'shopping', 'admin', '2023-12-27 15:00:27', 'admin', '2024-08-25 15:45:43', '系统管理目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, '售后管理', 0, 30, '/refund', 'Layout', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2023-12-27 15:00:27', 'admin', '2024-08-25 15:45:54', '至简官网地址');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3, '店铺&平台设置', 0, 50, 'shop', 'Layout', '', 1, 0, 'M', '0', '0', '', 'dict', 'admin', '2023-12-29 13:29:44', 'admin', '2025-10-01 02:33:33', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4, '商品管理', 0, 1, 'goods', 'Layout', '', 1, 0, 'M', '0', '0', '', 'international', 'admin', '2023-12-29 16:53:03', 'admin', '2025-10-01 02:30:31', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5, '系统设置', 0, 99, '/system', 'Layout', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2023-12-27 15:00:27', 'admin', '2023-12-29 09:07:42.856856', '系统管理目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (100, '发货订单库', 2087, 1, 'order_list', 'order/index', '', 1, 0, 'C', '0', '0', '', 'shopping', 'admin', '2023-12-27 15:00:27', 'admin', '2026-01-20 10:09:51', '用户管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (101, '订单拉取日志', 1, 32, 'order_pull_logs', 'order/shopOrder/pull_log', '', 1, 0, 'C', '0', '0', '', 'documentation', 'admin', '2023-12-27 15:00:27', 'admin', '2025-05-19 14:11:59', '角色管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (102, '店铺订单管理', 1, 3, 'shop_order_list', 'order/shopOrder/index', '', 1, 0, 'C', '0', '0', '', 'monitor', 'admin', '2023-12-27 15:00:27', 'admin', '2024-04-06 11:18:00', '菜单管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (104, '售后中心', 2, 1, 'refund_list', 'refund/index', '', 1, 0, 'C', '0', '0', '', 'tree', 'admin', '2023-12-27 15:00:27', 'admin', '2024-09-15 18:58:16', '岗位管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (105, '售后拉取日志', 2, 36, 'refund_pull_logs', 'refund/shopRefund/pull_log', '', 1, 0, 'C', '0', '0', '', 'dict', 'admin', '2023-12-27 15:00:27', 'admin', '2025-05-19 14:12:28', '字典管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (106, '店铺售后管理', 2, 2, 'shop_refund_list', 'refund/shopRefund/index', '', 1, 0, 'C', '0', '0', '', 'edit', 'admin', '2023-12-27 15:00:27', 'admin', '2024-07-20 11:56:11', '参数设置菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (108, '店铺管理', 3, 1, 'shop_list', 'shop/index', '', 1, 0, 'C', '0', '0', '', 'tree', 'admin', '2023-12-29 09:14:02', 'admin', '2025-03-24 13:03:00', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (110, '平台开关', 3, 81, 'platform/setting', 'shop/platform/index', '', 1, 0, 'C', '0', '0', '', 'system', 'admin', '2023-12-29 13:32:41', 'admin', '2025-05-20 20:36:38', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (112, '商品库SKU明细', 4, 10, 'sku_list', 'goods/spec/index', '', 1, 0, 'C', '1', '0', '', 'tree', 'admin', '2023-12-29 16:35:55', 'admin', '2025-10-01 02:30:40', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (116, '用户管理', 5, 1, 'user', 'system/user/index', '', 1, 0, 'C', '0', '0', '', 'user', 'admin', '2023-12-27 15:00:27', '', '', '用户管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (117, '菜单管理', 5, 1, 'menu', 'system/menu/index', '', 1, 0, 'C', '0', '0', '', 'user', 'admin', '2023-12-27 15:00:27', '', '', '用户管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2077, '店铺商品', 4, 21, 'shop_goods', 'shop/goods/index', NULL, 1, 0, 'C', '0', '0', '', 'shopping', 'admin', '2024-03-28 10:29:59', 'admin', '2025-10-08 03:16:26', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2078, '添加商品', 4, 99, 'create', 'goods/create', NULL, 1, 0, 'C', '1', '0', '', 'checkbox', 'admin', '2024-03-18 07:59:57', 'admin', '2025-10-01 02:32:19', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2079, '字典管理', 5, 9, 'dict', 'system/dict/index', NULL, 1, 0, 'C', '0', '0', '', 'dict', 'admin', '2024-03-18 08:43:55', 'admin', '2024-03-18 08:44:08', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2087, '发货管理', 0, 20, 'ship', NULL, NULL, 1, 0, 'M', '0', '0', '', 'guide', 'admin', '2024-03-30 17:36:10', 'admin', '2024-08-25 15:45:48', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2088, '发货设置', 2087, 90, 'ship_set', 'shipping/logistics/index', NULL, 1, 0, 'C', '0', '0', '', 'checkbox', 'admin', '2024-03-30 17:37:01', 'admin', '2026-01-20 10:12:02', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2089, '发货记录', 2087, 33, 'record', 'shipping/record/index', NULL, 1, 0, 'C', '0', '0', '', 'guide', 'admin', '2024-03-30 17:37:42', 'admin', '2026-01-20 10:11:56', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2090, '角色管理', 5, 2, 'role', 'system/role/index', NULL, 1, 0, 'C', '0', '0', NULL, 'peoples', 'admin', '2024-03-31 12:40:50', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2091, '部门管理', 5, 3, 'dept', 'system/dept/index', NULL, 1, 0, 'C', '0', '0', NULL, 'tree', 'admin', '2024-03-31 12:42:57', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2092, '售后处理记录', 2, 5, 'processing', 'afterSale/index', NULL, 1, 0, 'C', '0', '0', '', 'documentation', 'admin', '2024-04-06 17:27:03', 'admin', '2024-07-28 18:59:41', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2094, '打单发货', 2087, 30, 'print', 'shipping/ewaybillPrint/index', NULL, 1, 0, 'C', '0', '0', '', 'edit', 'admin', '2024-07-20 11:04:54', 'admin', '2026-01-20 10:10:58', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2096, '备货出库', 2087, 2, 'stockup', 'shipping/stockup/index.vue', NULL, 1, 0, 'C', '1', '0', '', 'email', 'admin', '2024-07-20 11:53:24', 'admin', '2026-01-20 10:11:34', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2097, '物流跟踪', 2087, 5, 'logistics', 'shipping/stocking/index', NULL, 1, 0, 'C', '0', '1', '', 'list', 'admin', '2024-07-20 11:54:18', 'admin', '2025-05-25 14:32:27', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2099, '手工订单管理', 1, 10, 'offline_order_list', 'order/private/index', NULL, 1, 0, 'C', '0', '0', '', 'checkbox', 'admin', '2024-07-27 17:33:03', 'admin', '2026-01-20 10:08:14', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2100, '私域售后管理', 2, 3, 'offline_aftersale', 'refund/private/index', NULL, 1, 0, 'C', '0', '1', '', 'code', 'admin', '2024-07-27 17:33:33', 'admin', '2025-05-25 14:59:03', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2103, '手动创建私域订单', 1, 49, 'offline_order_create', 'order/private/create', NULL, 1, 0, 'C', '1', '0', '', 'date', 'admin', '2024-07-27 20:30:07', 'admin', '2025-03-24 11:46:51', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2104, '商品库', 4, 0, 'goods_list', 'goods/index', NULL, 1, 0, 'C', '0', '0', 'goods', 'example', 'admin', '2024-08-25 14:35:54', 'admin', '2025-10-01 02:30:12', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2105, '库存管理', 0, 40, 'stock', NULL, NULL, 1, 0, 'M', '1', '1', '', 'lock', 'admin', '2024-08-25 15:54:14', 'admin', '2025-10-01 02:34:24', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2106, '商品入库管理', 2105, 10, 'stock_in', 'stock/stockIn/index.vue', NULL, 1, 0, 'C', '0', '0', '', 'download', 'admin', '2024-08-25 15:56:04', 'admin', '2025-03-24 13:35:21', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2108, '供应商管理', 4, 90, 'supplier_list', 'goods/supplier/index', NULL, 1, 0, 'C', '0', '0', '', 'people', 'admin', '2024-08-25 18:27:55', 'admin', '2024-09-07 15:51:17', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2109, '分类管理', 4, 80, 'category_list', 'goods/category/index', NULL, 1, 0, 'C', '0', '0', '', 'edit', 'admin', '2024-08-25 18:43:28', 'admin', '2025-10-01 02:32:02', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2110, '品牌管理', 4, 81, 'brand_list', 'goods/brand/index', NULL, 1, 0, 'C', '0', '0', '', 'icon', 'admin', '2024-08-25 18:45:47', 'admin', '2025-10-01 02:32:09', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2111, '分类规格属性', 4, 101, 'goods_category/attribute', 'goods/category/categoryAttribute', NULL, 1, 0, 'C', '1', '0', '', 'button', 'admin', '2024-08-25 18:49:22', 'admin', '2024-09-07 16:17:01', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2112, '规格属性值', 4, 102, 'goods_category/attribute_value', 'goods/category/categoryAttributeValue', NULL, 1, 0, 'C', '1', '0', '', 'date', 'admin', '2024-08-25 18:51:55', 'admin', '2024-09-07 16:23:53', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2114, '仓库仓位设置', 2105, 90, 'warehouse', 'stock/warehouse/index.vue', NULL, 1, 0, 'C', '0', '0', '', 'cascader', 'admin', '2024-09-21 20:07:26', 'admin', '2025-03-24 13:46:52', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2116, '商品出库管理', 2105, 20, 'stock_out', 'stock/stockOut/index', NULL, 1, 0, 'C', '0', '0', '', 'guide', 'admin', '2024-09-21 20:44:46', 'admin', '2025-03-24 13:46:42', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2117, '仓位管理', 2105, 91, 'position', 'stock/warehouse/position', NULL, 1, 0, 'C', '1', '0', '', '404', 'admin', '2024-09-22 11:52:18', 'admin', '2025-03-24 13:47:04', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2118, '新建商品入库单', 2105, 11, 'stock_in/create', 'stock/stockIn/create.vue', NULL, 1, 0, 'C', '1', '0', '', '404', 'admin', '2024-09-22 14:49:40', 'admin', '2025-03-24 13:35:30', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2129, '手工发货', 2087, 20, 'ship_order', 'shipping/wait_ship', NULL, 1, 0, 'C', '0', '0', '', 'checkbox', 'admin', '2025-06-01 13:36:57', 'admin', '2026-01-20 10:10:45', '');
COMMIT;

-- ----------------------------
-- Table structure for sys_oss
-- ----------------------------
DROP TABLE IF EXISTS `sys_oss`;
CREATE TABLE `sys_oss` (
  `oss_id` bigint NOT NULL AUTO_INCREMENT COMMENT '文件id',
  `file_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '文件名',
  `original_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '原名',
  `file_suffix` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '文件后缀名',
  `url` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'URL地址',
  `object_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '对象名',
  `bucket` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '桶名',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`oss_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='文件表';

-- ----------------------------
-- Records of sys_oss
-- ----------------------------
BEGIN;
INSERT INTO `sys_oss` (`oss_id`, `file_name`, `original_name`, `file_suffix`, `url`, `object_name`, `bucket`, `order_num`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1, '主图画板 1.jpg', '主图画板 1.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/09/07/a3e935aa-d1b3-4524-bd84-e567df01f2e3.jpg', '/images/2024/09/07/a3e935aa-d1b3-4524-bd84-e567df01f2e3.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 17:38:57', '', NULL);
INSERT INTO `sys_oss` (`oss_id`, `file_name`, `original_name`, `file_suffix`, `url`, `object_name`, `bucket`, `order_num`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (2, '主图画板2.jpg', '主图画板2.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/09/07/1dbe1530-787f-4461-9f20-3efa3c332588.jpg', '/images/2024/09/07/1dbe1530-787f-4461-9f20-3efa3c332588.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 17:57:54', '', NULL);
INSERT INTO `sys_oss` (`oss_id`, `file_name`, `original_name`, `file_suffix`, `url`, `object_name`, `bucket`, `order_num`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (3, '主图画板5.jpg', '主图画板5.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/09/07/2dc06b89-8661-4a72-a7cd-7f85f4545c6e.jpg', '/images/2024/09/07/2dc06b89-8661-4a72-a7cd-7f85f4545c6e.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 18:03:24', '', NULL);
INSERT INTO `sys_oss` (`oss_id`, `file_name`, `original_name`, `file_suffix`, `url`, `object_name`, `bucket`, `order_num`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (4, '主图画板 4.jpg', '主图画板 4.jpg', '.jpg', 'http://127.0.0.1:9000/ecerp//images/2024/09/07/3ed00452-5973-4c7e-91ae-5e87aa32dd23.jpg', '/images/2024/09/07/3ed00452-5973-4c7e-91ae-5e87aa32dd23.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 18:03:46', '', NULL);
INSERT INTO `sys_oss` (`oss_id`, `file_name`, `original_name`, `file_suffix`, `url`, `object_name`, `bucket`, `order_num`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5, '主图画板5.jpg', '主图画板5.jpg', '.jpg', 'http://127.0.0.1:9000/ecerp/images/2024/09/07/4b2583ae-65ae-45b6-9227-ebbee99d6558.jpg', '/images/2024/09/07/4b2583ae-65ae-45b6-9227-ebbee99d6558.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 18:04:47', '', NULL);
INSERT INTO `sys_oss` (`oss_id`, `file_name`, `original_name`, `file_suffix`, `url`, `object_name`, `bucket`, `order_num`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (6, '主图画板2.jpg', '主图画板2.jpg', '.jpg', 'http://223.83.100.30:9001/omsimage/images/2024/09/07/a64ff14b-09d4-42d6-8d52-0344360efdbf.jpg', '/images/2024/09/07/a64ff14b-09d4-42d6-8d52-0344360efdbf.jpg', 'omsimage', 0, '0', '0', '', '2024-09-07 19:10:39', '', NULL);
INSERT INTO `sys_oss` (`oss_id`, `file_name`, `original_name`, `file_suffix`, `url`, `object_name`, `bucket`, `order_num`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (7, '主图画板 1.jpg', '主图画板 1.jpg', '.jpg', 'http://223.83.100.30:9001/omsimage/images/2024/09/07/af19385d-a1dd-4efb-8257-3099706d1272.jpg', '/images/2024/09/07/af19385d-a1dd-4efb-8257-3099706d1272.jpg', 'omsimage', 0, '0', '0', '', '2024-09-07 19:26:36', '', NULL);
INSERT INTO `sys_oss` (`oss_id`, `file_name`, `original_name`, `file_suffix`, `url`, `object_name`, `bucket`, `order_num`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (8, '主图画板 1.jpg', '主图画板 1.jpg', '.jpg', 'http://223.83.100.30:9001/omsimage/images/2024/09/07/5aac40e1-ddc1-41a8-a468-28d81e699980.jpg', '/images/2024/09/07/5aac40e1-ddc1-41a8-a468-28d81e699980.jpg', 'omsimage', 0, '0', '0', '', '2024-09-07 20:37:14', '', NULL);
INSERT INTO `sys_oss` (`oss_id`, `file_name`, `original_name`, `file_suffix`, `url`, `object_name`, `bucket`, `order_num`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (9, '主图画板 1.jpg', '主图画板 1.jpg', '.jpg', 'http://223.83.100.30:9001/omsimage/images/2024/09/07/b28f4e15-8997-418c-bd32-b4beb4966f6b.jpg', '/images/2024/09/07/b28f4e15-8997-418c-bd32-b4beb4966f6b.jpg', 'omsimage', 0, '0', '0', '', '2024-09-07 20:37:51', '', NULL);
INSERT INTO `sys_oss` (`oss_id`, `file_name`, `original_name`, `file_suffix`, `url`, `object_name`, `bucket`, `order_num`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (50, 'x4.jpg', 'x4.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/08/28/x4.jpg', '/images/2024/08/28/x4.jpg', 'ecerp', 0, '0', '0', '', '2024-08-28 22:39:05', '', NULL);
INSERT INTO `sys_oss` (`oss_id`, `file_name`, `original_name`, `file_suffix`, `url`, `object_name`, `bucket`, `order_num`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (51, 'x11.jpg', 'x11.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/08/28/x11.jpg', '/images/2024/08/28/x11.jpg', 'ecerp', 0, '0', '0', '', '2024-08-28 22:47:11', '', NULL);
INSERT INTO `sys_oss` (`oss_id`, `file_name`, `original_name`, `file_suffix`, `url`, `object_name`, `bucket`, `order_num`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (52, '主图画板 4.jpg', '主图画板 4.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/09/07/主图画板 4.jpg', '/images/2024/09/07/主图画板 4.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 17:31:44', '', NULL);
INSERT INTO `sys_oss` (`oss_id`, `file_name`, `original_name`, `file_suffix`, `url`, `object_name`, `bucket`, `order_num`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (53, '主图画板 4.jpg', '主图画板 4.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/09/07/主图画板 4.jpg', '/images/2024/09/07/主图画板 4.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 17:35:41', '', NULL);
INSERT INTO `sys_oss` (`oss_id`, `file_name`, `original_name`, `file_suffix`, `url`, `object_name`, `bucket`, `order_num`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (54, '主图画板 1.jpg', '主图画板 1.jpg', '.jpg', 'http://127.0.0.1:9000/images/2024/09/07/f35a3cb8-1b9e-41f4-8158-31d458c7efb3.jpg', '/images/2024/09/07/f35a3cb8-1b9e-41f4-8158-31d458c7efb3.jpg', 'ecerp', 0, '0', '0', '', '2024-09-07 17:36:09', '', NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='角色信息表';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_role` (`role_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2023-08-07 19:31:37', '', NULL, '超级管理员');
INSERT INTO `sys_role` (`role_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2023-08-07 19:31:37', 'admin', '2025-10-01 02:31:21', '普通角色');
COMMIT;

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='角色和菜单关联表';

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_task
-- ----------------------------
DROP TABLE IF EXISTS `sys_task`;
CREATE TABLE `sys_task` (
  `id` int NOT NULL,
  `task_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cron` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='后台任务配置表';

-- ----------------------------
-- Records of sys_task
-- ----------------------------
BEGIN;
INSERT INTO `sys_task` (`id`, `task_name`, `cron`, `method`, `remark`, `create_time`) VALUES (1, '拉取淘宝订单', '-', NULL, '定时更新淘宝订单', '2024-03-07 09:52:40');
INSERT INTO `sys_task` (`id`, `task_name`, `cron`, `method`, `remark`, `create_time`) VALUES (2, '拉取京东POP订单', '-', NULL, '拉取京东POP订单', '2024-03-07 09:23:36');
INSERT INTO `sys_task` (`id`, `task_name`, `cron`, `method`, `remark`, `create_time`) VALUES (3, '拉取拼多多订单', '-', NULL, '定时拉取拼多多订单', '2024-04-09 11:24:14');
INSERT INTO `sys_task` (`id`, `task_name`, `cron`, `method`, `remark`, `create_time`) VALUES (4, '拉取抖店订单', '-', NULL, '定时拉取抖店订单', '2024-04-09 11:24:54');
INSERT INTO `sys_task` (`id`, `task_name`, `cron`, `method`, `remark`, `create_time`) VALUES (5, '拉取天猫退款', '-', NULL, '定时拉取天猫退款', '2024-04-09 11:25:43');
INSERT INTO `sys_task` (`id`, `task_name`, `cron`, `method`, `remark`, `create_time`) VALUES (6, '拉取京东售后', '-', NULL, '定时拉取京东售后', '2024-04-09 11:26:26');
INSERT INTO `sys_task` (`id`, `task_name`, `cron`, `method`, `remark`, `create_time`) VALUES (7, '拉取拼多多退款', '-', NULL, '定时拉取拼多多退款', '2024-04-09 11:27:01');
INSERT INTO `sys_task` (`id`, `task_name`, `cron`, `method`, `remark`, `create_time`) VALUES (8, '拉取抖店退款', '-', NULL, '定时拉取抖店退款', '2024-04-09 11:27:38');
INSERT INTO `sys_task` (`id`, `task_name`, `cron`, `method`, `remark`, `create_time`) VALUES (11, '拉取京东自营订单', '-', NULL, '拉取京东自营订单', '2024-05-27 10:57:44');
INSERT INTO `sys_task` (`id`, `task_name`, `cron`, `method`, `remark`, `create_time`) VALUES (12, '拉取京东自营退货', '-', NULL, '拉取京东自营退货', NULL);
INSERT INTO `sys_task` (`id`, `task_name`, `cron`, `method`, `remark`, `create_time`) VALUES (21, '推送待发货订单到ERP', '-', NULL, '推送待发货订单到ERP', '2024-04-22 15:48:48');
INSERT INTO `sys_task` (`id`, `task_name`, `cron`, `method`, `remark`, `create_time`) VALUES (22, '推送待处理售后到ERP', '-', NULL, '推送待处理售后到ERP', '2024-04-22 15:48:48');
INSERT INTO `sys_task` (`id`, `task_name`, `cron`, `method`, `remark`, `create_time`) VALUES (23, '推送已取消的订单到ERP', '-', NULL, '推送已取消的订单到ERP', '2024-05-29 17:57:02');
COMMIT;

-- ----------------------------
-- Table structure for sys_task_logs
-- ----------------------------
DROP TABLE IF EXISTS `sys_task_logs`;
CREATE TABLE `sys_task_logs` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `task_id` int DEFAULT NULL COMMENT '任务ID',
  `result` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结果',
  `start_time` datetime DEFAULT NULL COMMENT '开始运行时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `status` int DEFAULT NULL COMMENT '状态1运行中，2已结束',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='后台任务运行日志表';

-- ----------------------------
-- Records of sys_task_logs
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户信息表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_user` (`user_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, NULL, 'admin', '启航老齐A', '00', '280645618@qq.com', '18123879144', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-10-09 09:38:50', 'admin', '2023-08-07 19:31:37', '', '2025-10-09 01:38:50', '管理员');
INSERT INTO `sys_user` (`user_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, NULL, 'openapi', 'openApi接口专用', '00', '2806456181@qq.com', '15818590000', '0', '', '$2a$10$fHkhoqbMiyracAsTzl38H.55bu.M.of1FXk2EK7RQBjfic3tLU0Ue', '0', '0', '127.0.0.1', '2024-06-24 10:23:35', 'admin', '2024-03-17 14:55:22', 'admin', '2024-06-24 10:23:35', NULL);
INSERT INTO `sys_user` (`user_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (101, 101, '15818590119', 'aaa123', '00', '', '', '0', '', '$2a$10$pXcT6cHaObMeKuYd9vZb5uEb8PyUdF2AcqqRN1cBqiA9rV4qYQW7G', '0', '2', '', NULL, 'admin', '2024-08-15 13:45:25', '', NULL, NULL);
INSERT INTO `sys_user` (`user_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (102, 101, '15818590119', '老齐', '00', '', '', '0', '', '$2a$10$ysk.zgJ8wh25c7vOjKyZ8uarM2hkG0S51j8GYdJSo2kZmc3f8HdKe', '0', '0', '', NULL, 'admin', '2024-08-15 13:49:59', 'admin', '2025-02-10 16:26:20', NULL);
INSERT INTO `sys_user` (`user_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (103, 100, '18025303180', '老方', '00', '', '', '0', '', '$2a$10$QnLM3NluG5q1xpmWep0QUOFfvNrd02hwenL4HkV0uhMbm4cEX1uIG', '0', '0', '', NULL, 'admin', '2024-09-21 17:17:56', '', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户和角色关联表';

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (1, 1);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (2, 2);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (102, 2);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (103, 2);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
