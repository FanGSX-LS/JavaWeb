# JavaWeb
大学生期末作品
#导入下面数据库
-- 管理员表
CREATE TABLE admins (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL COMMENT '用户名',
    password_hash VARCHAR(100) NOT NULL COMMENT '密码哈希',
    email VARCHAR(100) UNIQUE NOT NULL COMMENT '邮箱',
    role ENUM('admin', 'super_admin') DEFAULT 'admin' COMMENT '角色',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 部门表
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL COMMENT '部门名称',
    description TEXT COMMENT '部门描述'
);

-- 员工表
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    employee_no VARCHAR(20) UNIQUE NOT NULL COMMENT '员工编号',
    department_id INT NOT NULL COMMENT '所属部门',
    username VARCHAR(50) UNIQUE NOT NULL COMMENT '用户名',
    password_hash VARCHAR(100) NOT NULL COMMENT '密码哈希',
    email VARCHAR(100) UNIQUE NOT NULL COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '联系电话',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否在职',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- 设备类别表
CREATE TABLE device_categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL COMMENT '类别名称',
    parent_id INT DEFAULT NULL COMMENT '父类别ID',
    description TEXT COMMENT '类别描述',
    FOREIGN KEY (parent_id) REFERENCES device_categories(id)
);

-- 设备信息表
CREATE TABLE devices (
    id INT PRIMARY KEY AUTO_INCREMENT,
    device_no VARCHAR(50) UNIQUE NOT NULL COMMENT '设备编号',
    category_id INT NOT NULL COMMENT '设备类别',
    name VARCHAR(100) NOT NULL COMMENT '设备名称',
    model VARCHAR(100) COMMENT '型号',
    specification TEXT COMMENT '规格参数',
    manufacturer VARCHAR(100) COMMENT '制造商',
    purchase_date DATE COMMENT '购买日期',
    warranty_period INT COMMENT '保修期限(月)',
    status ENUM('available', 'in_use', 'maintenance', 'scrapped') DEFAULT 'available' COMMENT '设备状态',
    location VARCHAR(100) COMMENT '存放位置',
    price DECIMAL(10, 2) COMMENT '价格',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES device_categories(id)
);

-- 设备申请表
CREATE TABLE device_applications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    applicant_id INT NOT NULL COMMENT '申请人ID',
    device_id INT NOT NULL COMMENT '申请设备ID',
    reason TEXT NOT NULL COMMENT '申请原因',
    start_date DATE NOT NULL COMMENT '开始日期',
    end_date DATE NOT NULL COMMENT '结束日期',
    status ENUM('pending', 'approved', 'rejected', 'completed') DEFAULT 'pending' COMMENT '申请状态',
    approver_id INT DEFAULT NULL COMMENT '审批人ID',
    approval_time TIMESTAMP DEFAULT NULL COMMENT '审批时间',
    rejection_reason TEXT COMMENT '拒绝原因',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (applicant_id) REFERENCES employees(id),
    FOREIGN KEY (device_id) REFERENCES devices(id),
    FOREIGN KEY (approver_id) REFERENCES admins(id)
);

-- 公告表
CREATE TABLE announcements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL COMMENT '公告标题',
    content TEXT NOT NULL COMMENT '公告内容',
    publisher_id INT NOT NULL COMMENT '发布人ID',
    is_published TINYINT(1) DEFAULT 0 COMMENT '是否发布',
    publish_time TIMESTAMP DEFAULT NULL COMMENT '发布时间',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (publisher_id) REFERENCES admins(id)
);

-- 入库记录表
CREATE TABLE stock_ins (
    id INT PRIMARY KEY AUTO_INCREMENT,
    device_id INT NOT NULL COMMENT '设备ID',
    quantity INT NOT NULL COMMENT '入库数量',
    supplier VARCHAR(100) COMMENT '供应商',
    price DECIMAL(10, 2) COMMENT '单价',
    total_price DECIMAL(10, 2) COMMENT '总价',
    receipt_no VARCHAR(50) COMMENT '收据编号',
    operator_id INT NOT NULL COMMENT '操作人ID',
    operation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    remark TEXT COMMENT '备注',
    FOREIGN KEY (device_id) REFERENCES devices(id),
    FOREIGN KEY (operator_id) REFERENCES admins(id)
);

-- 出库记录表
CREATE TABLE stock_outs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    device_id INT NOT NULL COMMENT '设备ID',
    quantity INT NOT NULL COMMENT '出库数量',
    recipient VARCHAR(100) COMMENT '领取人',
    purpose TEXT COMMENT '用途',
    operator_id INT NOT NULL COMMENT '操作人ID',
    operation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    remark TEXT COMMENT '备注',
    FOREIGN KEY (device_id) REFERENCES devices(id),
    FOREIGN KEY (operator_id) REFERENCES admins(id)
);    
