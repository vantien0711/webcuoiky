-- PharmaCare Database Schema
-- Tạo cơ sở dữ liệu cho website bán thuốc và sản phẩm chăm sóc sức khỏe

-- Bảng danh mục sản phẩm
CREATE TABLE categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    image VARCHAR(255),
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng thương hiệu
CREATE TABLE brands (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    logo VARCHAR(255),
    description TEXT,
    website VARCHAR(255),
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng sản phẩm
CREATE TABLE products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    brand_id INTEGER,
    category_id INTEGER,
    sku VARCHAR(100) UNIQUE,
    description TEXT,
    short_description VARCHAR(500),
    price DECIMAL(10,2) NOT NULL,
    old_price DECIMAL(10,2),
    cost_price DECIMAL(10,2),
    stock_quantity INTEGER DEFAULT 0,
    min_stock_alert INTEGER DEFAULT 10,
    weight DECIMAL(8,2),
    dimensions VARCHAR(100),
    main_image VARCHAR(255),
    gallery_images TEXT, -- JSON array of image URLs
    is_active BOOLEAN DEFAULT 1,
    is_featured BOOLEAN DEFAULT 0,
    is_bestseller BOOLEAN DEFAULT 0,
    is_new BOOLEAN DEFAULT 0,
    rating DECIMAL(3,2) DEFAULT 0,
    rating_count INTEGER DEFAULT 0,
    view_count INTEGER DEFAULT 0,
    meta_title VARCHAR(255),
    meta_description TEXT,
    meta_keywords VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brands(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Bảng thuộc tính sản phẩm
CREATE TABLE product_attributes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Bảng đánh giá sản phẩm
CREATE TABLE product_reviews (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(255),
    comment TEXT,
    is_verified_purchase BOOLEAN DEFAULT 0,
    is_approved BOOLEAN DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

-- Bảng khách hàng
CREATE TABLE customers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender ENUM('male', 'female', 'other'),
    avatar VARCHAR(255),
    is_active BOOLEAN DEFAULT 1,
    is_verified BOOLEAN DEFAULT 0,
    verification_token VARCHAR(255),
    reset_password_token VARCHAR(255),
    reset_password_expires TIMESTAMP,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng địa chỉ khách hàng
CREATE TABLE customer_addresses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    address_type ENUM('home', 'work', 'other') DEFAULT 'home',
    full_name VARCHAR(200) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100) DEFAULT 'Vietnam',
    is_default BOOLEAN DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

-- Bảng đơn hàng
CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id INTEGER NOT NULL,
    customer_address_id INTEGER NOT NULL,
    status ENUM('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded') DEFAULT 'pending',
    payment_status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
    payment_method ENUM('cod', 'bank_transfer', 'credit_card', 'momo', 'zalopay') DEFAULT 'cod',
    subtotal DECIMAL(10,2) NOT NULL,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    shipping_amount DECIMAL(10,2) DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL,
    notes TEXT,
    tracking_number VARCHAR(100),
    shipped_at TIMESTAMP,
    delivered_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (customer_address_id) REFERENCES customer_addresses(id)
);

-- Bảng chi tiết đơn hàng
CREATE TABLE order_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    product_sku VARCHAR(100),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Bảng giỏ hàng
CREATE TABLE cart_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE(customer_id, product_id)
);

-- Bảng danh sách yêu thích
CREATE TABLE wishlist_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE(customer_id, product_id)
);

-- Bảng mã giảm giá
CREATE TABLE coupons (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    discount_type ENUM('percentage', 'fixed') NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    minimum_amount DECIMAL(10,2) DEFAULT 0,
    maximum_discount DECIMAL(10,2),
    usage_limit INTEGER,
    used_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT 1,
    starts_at TIMESTAMP,
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng lịch sử sử dụng mã giảm giá
CREATE TABLE coupon_usage (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    coupon_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    order_id INTEGER NOT NULL,
    discount_amount DECIMAL(10,2) NOT NULL,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (coupon_id) REFERENCES coupons(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- Bảng tin tức/blog
CREATE TABLE blog_posts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    excerpt TEXT,
    content TEXT NOT NULL,
    featured_image VARCHAR(255),
    author_id INTEGER,
    category VARCHAR(100),
    tags VARCHAR(255),
    is_published BOOLEAN DEFAULT 0,
    published_at TIMESTAMP,
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng liên hệ
CREATE TABLE contact_messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    subject VARCHAR(255),
    message TEXT NOT NULL,
    status ENUM('new', 'read', 'replied', 'closed') DEFAULT 'new',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng cài đặt hệ thống
CREATE TABLE settings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng tài khoản quản trị và người dùng
CREATE TABLE accounts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    role VARCHAR(20) NOT NULL DEFAULT 'user', -- 'admin' hoặc 'user'
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tài khoản admin mẫu (password: admin123, hash demo)
INSERT INTO accounts (username, password_hash, email, role, is_active)
VALUES ('admin', '$2a$10$demoHashForAdmin123', 'admin@pharmacare.vn', 'admin', 1);

-- Tạo indexes để tối ưu hiệu suất
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_brand ON products(brand_id);
CREATE INDEX idx_products_active ON products(is_active);
CREATE INDEX idx_products_featured ON products(is_featured);
CREATE INDEX idx_products_bestseller ON products(is_bestseller);
CREATE INDEX idx_products_new ON products(is_new);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_rating ON products(rating);

CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created ON orders(created_at);

CREATE INDEX idx_cart_customer ON cart_items(customer_id);
CREATE INDEX idx_wishlist_customer ON wishlist_items(customer_id);

CREATE INDEX idx_reviews_product ON product_reviews(product_id);
CREATE INDEX idx_reviews_customer ON product_reviews(customer_id);

-- Insert dữ liệu mẫu cho danh mục
INSERT INTO categories (name, slug, description) VALUES
('Thuốc', 'thuoc', 'Các loại thuốc kê đơn và không kê đơn'),
('Vitamin & Thực phẩm chức năng', 'vitamin', 'Vitamin và các sản phẩm bổ sung dinh dưỡng'),
('Chăm sóc da', 'cham-soc-da', 'Mỹ phẩm và sản phẩm chăm sóc da'),
('Chăm sóc cá nhân', 'cham-soc-ca-nhan', 'Sản phẩm vệ sinh cá nhân'),
('Thiết bị y tế', 'thiet-bi-y-te', 'Máy đo huyết áp, đường huyết, nhiệt kế...'),
('Sản phẩm cho trẻ em', 'san-pham-tre-em', 'Sữa bột, thuốc và sản phẩm chăm sóc trẻ em');

-- Insert dữ liệu mẫu cho thương hiệu
INSERT INTO brands (name, slug, description) VALUES
('Blackmores', 'blackmores', 'Thương hiệu vitamin và thực phẩm chức năng hàng đầu Australia'),
('Eucerin', 'eucerin', 'Thương hiệu dược mỹ phẩm chuyên về chăm sóc da'),
('Centrum', 'centrum', 'Thương hiệu vitamin tổng hợp của Pfizer'),
('Pfizer', 'pfizer', 'Tập đoàn dược phẩm hàng đầu thế giới'),
('Abbott', 'abbott', 'Công ty chăm sóc sức khỏe toàn cầu'),
('Omron', 'omron', 'Thương hiệu thiết bị y tế Nhật Bản');

-- Insert dữ liệu mẫu cho sản phẩm
INSERT INTO products (name, slug, brand_id, category_id, sku, description, price, old_price, stock_quantity, main_image, is_bestseller, is_new) VALUES
('Vitamin C 1000mg', 'vitamin-c-1000mg', 1, 2, 'VC1000', 'Vitamin C 1000mg hỗ trợ tăng cường sức đề kháng, chống oxy hóa hiệu quả.', 250000, 300000, 50, 'vitamin-c.jpg', 0, 1),
('Kem dưỡng ẩm Eucerin', 'kem-duong-am-eucerin', 2, 3, 'KEA001', 'Kem dưỡng ẩm da mặt chuyên sâu cho làn da khô, nhạy cảm.', 350000, 400000, 30, 'eucerin-moisturizer.jpg', 1, 0),
('Centrum Silver 50+', 'centrum-silver-50', 3, 2, 'CS50', 'Viên uống bổ sung đa vitamin và khoáng chất cho người trên 50 tuổi.', 450000, 500000, 20, 'centrum-silver.jpg', 1, 0),
('Panadol Extra', 'panadol-extra', 4, 1, 'PE001', 'Giảm đau, hạ sốt nhanh chóng, hiệu quả.', 120000, 150000, 100, 'panadol-extra.jpg', 1, 0),
('Pediasure hương vani', 'pediasure-huong-vani', 5, 6, 'PV001', 'Sữa bột dinh dưỡng cho trẻ biếng ăn, chậm tăng cân.', 550000, 600000, 40, 'pediasure-vanilla.jpg', 0, 1),
('Máy đo đường huyết Omron', 'may-do-duong-huyet-omron', 6, 5, 'MDH001', 'Máy đo đường huyết tại nhà chính xác, dễ sử dụng.', 850000, 950000, 15, 'omron-glucometer.jpg', 0, 0),
('Viên uống bổ não Ginkgo Biloba', 'ginkgo-biloba', 1, 2, 'GB001', 'Hỗ trợ tuần hoàn máu não, cải thiện trí nhớ.', 320000, 350000, 25, 'ginkgo-biloba.jpg', 0, 0),
('Kem chống nắng Eucerin SPF50', 'kem-chong-nang-eucerin-spf50', 2, 3, 'KCN001', 'Kem chống nắng vật lý phù hợp cho da nhạy cảm.', 380000, 420000, 35, 'eucerin-sunscreen.jpg', 1, 1),
('Paracetamol 500mg', 'Thuốc giảm đau, hạ sốt thông dụng, an toàn cho mọi lứa tuổi.', 80000, 100000, 1, 1, 'paracetamol.jpg', 200, 4.5, 150, 1, 1, 0, 'Hộp', 'all', 'all'),
('Omega 3 Fish Oil', 'Viên uống Omega 3 từ dầu cá tự nhiên, tốt cho tim mạch và não bộ.', 280000, 320000, 2, 1, 'omega-3.jpg', 60, 4.5, 160, 1, 1, 0, 'Hộp', 'all', 'all'),
('Sữa rửa mặt Cetaphil', 'Sữa rửa mặt dịu nhẹ, phù hợp cho mọi loại da, kể cả da nhạy cảm.', 220000, 250000, 3, 2, 'cetaphil-cleanser.jpg', 80, 4.6, 220, 1, 1, 0, 'Chai', 'all', 'sensitive'),
('Máy đo huyết áp Omron', 'Máy đo huyết áp điện tử tự động, kết quả chính xác.', 1200000, 1400000, 5, 6, 'omron-bp.jpg', 10, 4.7, 80, 1, 1, 0, 'Cái', 'all', 'all'),
('Viên uống canxi', 'Bổ sung canxi và vitamin D3, hỗ trợ xương chắc khỏe.', 180000, 200000, 2, 3, 'calcium.jpg', 85, 4.2, 100, 1, 0, 1, 'Hộp', 'all', 'all'),
('Kem trị mụn Benzoyl Peroxide', 'Kem trị mụn hiệu quả với thành phần Benzoyl Peroxide 2.5%.', 150000, 180000, 3, 21, 'benzoyl-peroxide.jpg', 90, 4.4, 160, 1, 0, 1, 'Tuýp', 'all', 'oily'),
('Nhiệt kế điện tử', 'Nhiệt kế điện tử đo trán, nhanh chóng và chính xác.', 350000, 400000, 4, 27, 'digital-thermometer.jpg', 100, 4.6, 220, 1, 1, 0, 'Cái', 'all', 'all'),
('Sữa bột Similac', 'Sữa bột dinh dưỡng cho trẻ sơ sinh, phát triển toàn diện.', 480000, 520000, 6, 5, 'similac.jpg', 35, 4.5, 160, 1, 0, 1, 'Hộp', 'all', 'all'),
('Viên uống collagen', 'Collagen peptide giúp làm đẹp da, chống lão hóa.', 420000, 480000, 2, 13, 'collagen.jpg', 65, 4.4, 130, 1, 1, 1, 'Hộp', 'women', 'all'),
('Kem dưỡng ban đêm', 'Kem dưỡng ẩm ban đêm, phục hồi và tái tạo da.', 280000, 320000, 3, 23, 'night-cream.jpg', 65, 4.6, 190, 1, 1, 0, 'Hũ', 'all', 'dry'),
('Thuốc ho Prospan', 'Si-rô ho thảo dược, an toàn cho trẻ em và người lớn.', 95000, 110000, 1, 4, 'omeprazole.jpg', 70, 4.4, 110, 1, 1, 0, 'Hộp', 'all', 'all'),
('Máy xông mũi họng', 'Máy xông mũi họng mini, tiện lợi cho gia đình.', 650000, 750000, 5, 38, 'baby-nebulizer.jpg', 70, 4.4, 130, 1, 0, 1, 'Cái', 'all', 'all'),
('Viên uống men vi sinh', 'Men vi sinh hỗ trợ tiêu hóa, tăng cường miễn dịch.', 160000, 180000, 2, 12, 'probiotics.jpg', 80, 4.6, 175, 1, 1, 0, 'Hộp', 'all', 'all'),
('Kem chống nắng Anessa', 'Kem chống nắng Nhật Bản, chống nước và mồ hôi.', 520000, 580000, 3, 20, 'vitamin-c-serum.jpg', 50, 4.5, 180, 1, 1, 0, 'Chai', 'all', 'all'),
('Thuốc nhỏ mắt', 'Thuốc nhỏ mắt kháng khuẩn, điều trị viêm kết mạc.', 75000, 85000, 1, 1, 'paracetamol.jpg', 120, 4.5, 150, 1, 1, 0, 'Hộp', 'all', 'all'),
('Máy massage cầm tay', 'Máy massage cầm tay, giảm đau cơ và thư giãn.', 450000, 500000, 4, 29, 'massage-device.jpg', 85, 4.3, 110, 1, 0, 0, 'Cái', 'all', 'all'),
('Sữa bột Enfamil', 'Sữa bột dinh dưỡng cho trẻ từ 0-6 tháng tuổi.', 520000, 580000, 6, 5, 'enfamil.jpg', 30, 4.4, 140, 1, 1, 0, 'Hộp', 'all', 'all'),
('Viên uống vitamin E', 'Vitamin E tự nhiên, chống oxy hóa, làm đẹp da.', 120000, 140000, 2, 1, 'vitamin-e.jpg', 100, 4.5, 160, 1, 1, 0, 'Hộp', 'all', 'all'),
('Kem trị nám', 'Kem trị nám chuyên sâu, làm sáng da hiệu quả.', 380000, 420000, 3, 20, 'vitamin-c-serum.jpg', 50, 4.5, 180, 1, 1, 0, 'Chai', 'all', 'all'),
('Thuốc trị đau dạ dày', 'Thuốc trị đau dạ dày, giảm acid dạ dày.', 110000, 130000, 1, 4, 'omeprazole.jpg', 70, 4.4, 110, 1, 1, 0, 'Hộp', 'all', 'all'),
('Máy đo SpO2', 'Máy đo nồng độ oxy trong máu, thiết bị y tế cần thiết.', 280000, 320000, 4, 32, 'spo2-monitor.jpg', 60, 4.5, 120, 1, 0, 0, 'Cái', 'all', 'all'),
('Viên uống glucosamine', 'Glucosamine hỗ trợ khớp, giảm đau xương khớp.', 320000, 360000, 2, 13, 'collagen.jpg', 65, 4.4, 130, 1, 0, 0, 'Hộp', 'all', 'all'),
('Kem dưỡng mắt', 'Kem dưỡng mắt chuyên sâu, giảm quầng thâm và nếp nhăn.', 180000, 200000, 3, 20, 'vitamin-c-serum.jpg', 50, 4.5, 180, 1, 1, 0, 'Chai', 'all', 'all'),
('Thuốc trị cảm cúm', 'Thuốc trị cảm cúm, giảm triệu chứng sốt, đau đầu.', 95000, 110000, 1, 1, 'paracetamol.jpg', 120, 4.5, 150, 1, 1, 0, 'Hộp', 'all', 'all'),
('Máy tạo độ ẩm', 'Máy tạo độ ẩm không khí, tốt cho đường hô hấp.', 850000, 950000, 4, 31, 'oxygen-concentrator.jpg', 25, 4.8, 80, 1, 1, 1, 'Cái', 'all', 'all'),
('Sữa bột Friso', 'Sữa bột dinh dưỡng cho trẻ từ 6-12 tháng tuổi.', 480000, 520000, 6, 5, 'friso.jpg', 25, 4.4, 140, 1, 1, 0, 'Hộp', 'all', 'all'),
('Viên uống vitamin D3', 'Vitamin D3 hỗ trợ hấp thu canxi, tăng cường xương.', 90000, 110000, 2, 1, 'vitamin-d3.jpg', 120, 4.6, 180, 1, 1, 0, 'Hộp', 'all', 'all'),
('Kem trị mụn đầu đen', 'Kem trị mụn đầu đen, làm sạch sâu lỗ chân lông.', 140000, 160000, 3, 21, 'benzoyl-peroxide.jpg', 90, 4.4, 160, 1, 0, 1, 'Tuýp', 'all', 'oily'),
('Thuốc trị tiêu chảy', 'Thuốc trị tiêu chảy, cầm tiêu chảy nhanh chóng.', 85000, 95000, 1, 4, 'omeprazole.jpg', 70, 4.4, 110, 1, 1, 0, 'Hộp', 'all', 'all'),
('Máy đo nhịp tim', 'Máy đo nhịp tim cầm tay, theo dõi sức khỏe tim mạch.', 320000, 360000, 4, 29, 'massage-device.jpg', 85, 4.3, 110, 1, 0, 0, 'Cái', 'all', 'all'),
('Viên uống sắt', 'Viên uống bổ sung sắt, phòng chống thiếu máu.', 110000, 130000, 2, 15, 'iron.jpg', 100, 4.1, 95, 1, 0, 0, 'Hộp', 'women', 'all'),
('Kem dưỡng tóc', 'Kem dưỡng tóc chuyên sâu, phục hồi tóc hư tổn.', 160000, 180000, 3, 20, 'vitamin-c-serum.jpg', 50, 4.5, 180, 1, 1, 0, 'Chai', 'all', 'all'),
('Thuốc trị đau răng', 'Thuốc giảm đau răng tạm thời, hiệu quả nhanh.', 65000, 75000, 1, 1, 'paracetamol.jpg', 120, 4.5, 150, 1, 1, 0, 'Hộp', 'all', 'all'),
('Máy đo cholesterol', 'Máy đo cholesterol tại nhà, theo dõi sức khỏe tim mạch.', 1800000, 2000000, 6, 5, 'omron-glucometer.jpg', 15, 4.7, 80, 1, 1, 0, 'Cái', 'all', 'all'),
('Sữa bột Nestle', 'Sữa bột dinh dưỡng cho trẻ từ 1-3 tuổi.', 420000, 460000, 6, 5, 'nestle.jpg', 35, 4.4, 140, 1, 1, 0, 'Hộp', 'all', 'all'),
('Viên uống kẽm', 'Viên uống bổ sung kẽm, tăng cường miễn dịch.', 95000, 115000, 2, 16, 'zinc.jpg', 85, 4.3, 105, 1, 1, 0, 'Hộp', 'all', 'all'),
('Kem trị sẹo', 'Kem trị sẹo hiệu quả, làm mờ sẹo cũ và mới.', 220000, 250000, 3, 20, 'vitamin-c-serum.jpg', 50, 4.5, 180, 1, 1, 0, 'Chai', 'all', 'all'),
('Thuốc trị táo bón', 'Thuốc trị táo bón, nhuận tràng tự nhiên.', 75000, 85000, 1, 4, 'omeprazole.jpg', 70, 4.4, 110, 1, 1, 0, 'Hộp', 'all', 'all'),
('Máy đo huyết áp cổ tay', 'Máy đo huyết áp cổ tay, tiện lợi và chính xác.', 950000, 1100000, 5, 38, 'baby-nebulizer.jpg', 70, 4.4, 130, 1, 0, 1, 'Cái', 'all', 'all');

-- Insert dữ liệu mẫu cho cài đặt hệ thống
INSERT INTO settings (setting_key, setting_value, description) VALUES
('site_name', 'PharmaCare', 'Tên website'),
('site_description', 'Nhà thuốc trực tuyến uy tín', 'Mô tả website'),
('contact_email', 'info@pharmacare.vn', 'Email liên hệ'),
('contact_phone', '1900-1234', 'Số điện thoại liên hệ'),
('contact_address', '123 Đường ABC, Quận 1, TP.HCM', 'Địa chỉ liên hệ'),
('shipping_fee', '30000', 'Phí vận chuyển mặc định'),
('min_order_amount', '200000', 'Giá trị đơn hàng tối thiểu để miễn phí vận chuyển'),
('tax_rate', '0.1', 'Tỷ lệ thuế VAT (10%)');

-- Tạo trigger để tự động cập nhật updated_at
CREATE TRIGGER update_products_timestamp 
    AFTER UPDATE ON products
    FOR EACH ROW
    BEGIN
        UPDATE products SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END;

CREATE TRIGGER update_customers_timestamp 
    AFTER UPDATE ON customers
    FOR EACH ROW
    BEGIN
        UPDATE customers SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END;

CREATE TRIGGER update_orders_timestamp 
    AFTER UPDATE ON orders
    FOR EACH ROW
    BEGIN
        UPDATE orders SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END;

-- Tạo view để thống kê sản phẩm
CREATE VIEW product_stats AS
SELECT 
    p.id,
    p.name,
    p.price,
    p.stock_quantity,
    p.rating,
    p.rating_count,
    p.view_count,
    b.name as brand_name,
    c.name as category_name,
    COUNT(oi.id) as total_sold,
    SUM(oi.quantity) as units_sold
FROM products p
LEFT JOIN brands b ON p.brand_id = b.id
LEFT JOIN categories c ON p.category_id = c.id
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id;

-- Tạo view để thống kê đơn hàng
CREATE VIEW order_stats AS
SELECT 
    o.id,
    o.order_number,
    o.status,
    o.payment_status,
    o.total_amount,
    o.created_at,
    c.first_name || ' ' || c.last_name as customer_name,
    c.email as customer_email
FROM orders o
JOIN customers c ON o.customer_id = c.id; 

-- Thêm dữ liệu sản phẩm cho trang Thuốc (medicine)
INSERT INTO products (name, description, price, old_price, category_id, brand_id, image, stock, rating, rating_count, is_active, is_bestseller, is_new, unit, audience, skin_type) VALUES
('Paracetamol 500mg', 'Thuốc giảm đau, hạ sốt hiệu quả', 25000, 30000, 1, 1, 'paracetamol.jpg', 100, 4.5, 150, 1, 1, 0, 'Hộp', 'all', 'all'),
('Ibuprofen 400mg', 'Thuốc chống viêm, giảm đau', 35000, 40000, 1, 2, 'ibuprofen.jpg', 80, 4.3, 120, 1, 1, 0, 'Hộp', 'all', 'all'),
('Amoxicillin 500mg', 'Kháng sinh điều trị nhiễm khuẩn', 45000, 50000, 1, 3, 'amoxicillin.jpg', 60, 4.2, 90, 1, 0, 1, 'Hộp', 'all', 'all'),
('Omeprazole 20mg', 'Thuốc điều trị dạ dày', 55000, 60000, 1, 4, 'omeprazole.jpg', 70, 4.4, 110, 1, 1, 0, 'Hộp', 'all', 'all'),
('Cetirizine 10mg', 'Thuốc chống dị ứng', 30000, 35000, 1, 5, 'cetirizine.jpg', 90, 4.1, 85, 1, 0, 1, 'Hộp', 'all', 'all'),
('Dextromethorphan', 'Thuốc ho, long đờm', 28000, 32000, 1, 6, 'dextromethorphan.jpg', 75, 4.0, 95, 1, 1, 0, 'Hộp', 'all', 'all'),
('Vitamin C 1000mg', 'Tăng cường sức đề kháng', 40000, 45000, 1, 7, 'vitamin-c.jpg', 120, 4.6, 180, 1, 1, 0, 'Hộp', 'all', 'all'),
('Calcium 500mg', 'Bổ sung canxi cho xương', 38000, 42000, 1, 8, 'calcium.jpg', 85, 4.2, 100, 1, 0, 1, 'Hộp', 'all', 'all');

-- Thêm dữ liệu sản phẩm cho trang Vitamin (vitamin)
INSERT INTO products (name, description, price, old_price, category_id, brand_id, image, stock, rating, rating_count, is_active, is_bestseller, is_new, unit, audience, skin_type) VALUES
('Vitamin D3 1000IU', 'Bổ sung vitamin D cho xương', 65000, 75000, 2, 9, 'vitamin-d3.jpg', 95, 4.7, 200, 1, 1, 0, 'Hộp', 'all', 'all'),
('Omega-3 1000mg', 'Dầu cá tốt cho tim mạch', 85000, 95000, 2, 10, 'omega3.jpg', 70, 4.5, 160, 1, 1, 0, 'Hộp', 'all', 'all'),
('Vitamin B Complex', 'Vitamin nhóm B tổng hợp', 55000, 65000, 2, 11, 'vitamin-b.jpg', 110, 4.3, 140, 1, 0, 1, 'Hộp', 'all', 'all'),
('Probiotics 10 tỷ CFU', 'Men vi sinh cho đường ruột', 75000, 85000, 2, 12, 'probiotics.jpg', 80, 4.6, 175, 1, 1, 0, 'Hộp', 'all', 'all'),
('Collagen 1000mg', 'Làm đẹp da, chống lão hóa', 95000, 110000, 2, 13, 'collagen.jpg', 65, 4.4, 130, 1, 1, 1, 'Hộp', 'women', 'all'),
('Glucosamine 1500mg', 'Tốt cho khớp xương', 78000, 88000, 2, 14, 'glucosamine.jpg', 90, 4.2, 115, 1, 0, 0, 'Hộp', 'all', 'all'),
('Iron 65mg', 'Bổ sung sắt cho máu', 45000, 55000, 2, 15, 'iron.jpg', 100, 4.1, 95, 1, 0, 1, 'Hộp', 'women', 'all'),
('Zinc 50mg', 'Tăng cường miễn dịch', 35000, 40000, 2, 16, 'zinc.jpg', 85, 4.3, 105, 1, 1, 0, 'Hộp', 'all', 'all');

-- Thêm dữ liệu sản phẩm cho trang Chăm sóc da (skincare)
INSERT INTO products (name, description, price, old_price, category_id, brand_id, image, stock, rating, rating_count, is_active, is_bestseller, is_new, unit, audience, skin_type) VALUES
('Kem dưỡng ẩm Cerave', 'Dưỡng ẩm cho da khô', 180000, 200000, 3, 17, 'cerave-moisturizer.jpg', 60, 4.8, 250, 1, 1, 0, 'Tuýp', 'all', 'dry'),
('Sữa rửa mặt Cetaphil', 'Rửa mặt dịu nhẹ cho da nhạy cảm', 120000, 140000, 3, 18, 'cetaphil-cleanser.jpg', 80, 4.6, 220, 1, 1, 0, 'Chai', 'all', 'sensitive'),
('Kem chống nắng SPF50', 'Chống nắng cao cấp', 250000, 280000, 3, 19, 'sunscreen-spf50.jpg', 70, 4.7, 300, 1, 1, 1, 'Tuýp', 'all', 'all'),
('Serum Vitamin C', 'Làm sáng da, chống oxy hóa', 320000, 350000, 3, 20, 'vitamin-c-serum.jpg', 50, 4.5, 180, 1, 1, 0, 'Chai', 'all', 'all'),
('Kem trị mụn Benzoyl Peroxide', 'Trị mụn hiệu quả', 150000, 170000, 3, 21, 'benzoyl-peroxide.jpg', 90, 4.4, 160, 1, 0, 1, 'Tuýp', 'all', 'oily'),
('Toner cho da dầu', 'Cân bằng dầu cho da dầu', 95000, 110000, 3, 22, 'toner-oily.jpg', 75, 4.2, 120, 1, 0, 0, 'Chai', 'all', 'oily'),
('Kem dưỡng ban đêm', 'Dưỡng ẩm sâu ban đêm', 280000, 320000, 3, 23, 'night-cream.jpg', 65, 4.6, 190, 1, 1, 0, 'Hũ', 'all', 'dry'),
('Mặt nạ dưỡng ẩm', 'Mặt nạ cấp ẩm tức thì', 45000, 55000, 3, 24, 'moisturizing-mask.jpg', 120, 4.3, 140, 1, 0, 1, 'Miếng', 'all', 'all');

-- Thêm dữ liệu sản phẩm cho trang Thiết bị y tế (medical)
INSERT INTO products (name, description, price, old_price, category_id, brand_id, image, stock, rating, rating_count, is_active, is_bestseller, is_new, unit, audience, skin_type) VALUES
('Máy đo huyết áp điện tử', 'Đo huyết áp chính xác tại nhà', 850000, 950000, 4, 25, 'blood-pressure-monitor.jpg', 40, 4.7, 180, 1, 1, 0, 'Cái', 'all', 'all'),
('Máy đo đường huyết', 'Theo dõi đường huyết thường xuyên', 650000, 750000, 4, 26, 'glucose-meter.jpg', 55, 4.5, 150, 1, 1, 0, 'Bộ', 'all', 'all'),
('Nhiệt kế điện tử', 'Đo nhiệt độ nhanh chóng', 120000, 140000, 4, 27, 'digital-thermometer.jpg', 100, 4.6, 220, 1, 1, 0, 'Cái', 'all', 'all'),
('Máy xông mũi họng', 'Xông thuốc trị ho, viêm mũi', 450000, 500000, 4, 28, 'nebulizer.jpg', 70, 4.4, 130, 1, 0, 1, 'Cái', 'all', 'all'),
('Máy massage cầm tay', 'Massage thư giãn cơ bắp', 350000, 400000, 4, 29, 'massage-device.jpg', 85, 4.3, 110, 1, 0, 0, 'Cái', 'all', 'all'),
('Băng gạc y tế', 'Băng vết thương sạch sẽ', 25000, 30000, 4, 30, 'medical-bandage.jpg', 200, 4.2, 95, 1, 0, 0, 'Hộp', 'all', 'all'),
('Máy tạo oxy mini', 'Tạo oxy cho người khó thở', 1200000, 1350000, 4, 31, 'oxygen-concentrator.jpg', 25, 4.8, 80, 1, 1, 1, 'Cái', 'all', 'all'),
('Máy đo SpO2', 'Đo nồng độ oxy trong máu', 280000, 320000, 4, 32, 'spo2-monitor.jpg', 60, 4.5, 120, 1, 0, 0, 'Cái', 'all', 'all');

-- Thêm dữ liệu sản phẩm cho trang Trẻ em (baby)
INSERT INTO products (name, description, price, old_price, category_id, brand_id, image, stock, rating, rating_count, is_active, is_bestseller, is_new, unit, audience, skin_type) VALUES
('Sữa tắm gội trẻ em', 'Sữa tắm dịu nhẹ cho bé', 95000, 110000, 5, 33, 'baby-shampoo.jpg', 80, 4.7, 200, 1, 1, 0, 'Chai', 'children', 'sensitive'),
('Kem chống hăm', 'Chống hăm tã cho trẻ sơ sinh', 75000, 85000, 5, 34, 'diaper-rash-cream.jpg', 120, 4.8, 280, 1, 1, 0, 'Tuýp', 'infant', 'sensitive'),
('Vitamin D3 cho trẻ', 'Bổ sung vitamin D cho bé', 85000, 95000, 5, 35, 'baby-vitamin-d.jpg', 90, 4.6, 180, 1, 1, 0, 'Chai', 'children', 'all'),
('Kem dưỡng ẩm trẻ em', 'Dưỡng ẩm da cho bé', 65000, 75000, 5, 36, 'baby-moisturizer.jpg', 100, 4.5, 160, 1, 0, 1, 'Tuýp', 'children', 'sensitive'),
('Thuốc hạ sốt trẻ em', 'Hạ sốt an toàn cho bé', 45000, 55000, 5, 37, 'baby-fever-medicine.jpg', 85, 4.4, 140, 1, 1, 0, 'Hộp', 'children', 'all'),
('Kem chống nắng trẻ em', 'Chống nắng dịu nhẹ cho bé', 120000, 140000, 5, 38, 'baby-sunscreen.jpg', 70, 4.3, 120, 1, 0, 0, 'Tuýp', 'children', 'sensitive'),
('Dầu massage trẻ em', 'Dầu massage cho bé', 55000, 65000, 5, 39, 'baby-massage-oil.jpg', 95, 4.2, 110, 1, 0, 1, 'Chai', 'infant', 'all'),
('Bột tắm trẻ em', 'Bột tắm thảo dược cho bé', 35000, 40000, 5, 40, 'baby-bath-powder.jpg', 110, 4.1, 95, 1, 0, 0, 'Gói', 'children', 'sensitive'); 