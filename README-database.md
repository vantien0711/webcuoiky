# PharmaCare Database Documentation

## Tổng quan

Cơ sở dữ liệu PharmaCare được thiết kế để quản lý website bán thuốc và sản phẩm chăm sóc sức khỏe trực tuyến. Hệ thống bao gồm các bảng chính để quản lý sản phẩm, khách hàng, đơn hàng và các tính năng khác.

## Cấu trúc cơ sở dữ liệu

### 1. Bảng chính

#### `categories` - Danh mục sản phẩm

- `id`: Khóa chính
- `name`: Tên danh mục
- `slug`: URL-friendly name
- `description`: Mô tả danh mục
- `image`: Hình ảnh danh mục
- `is_active`: Trạng thái hoạt động

#### `brands` - Thương hiệu

- `id`: Khóa chính
- `name`: Tên thương hiệu
- `slug`: URL-friendly name
- `logo`: Logo thương hiệu
- `description`: Mô tả thương hiệu
- `website`: Website chính thức

#### `products` - Sản phẩm

- `id`: Khóa chính
- `name`: Tên sản phẩm
- `slug`: URL-friendly name
- `brand_id`: ID thương hiệu (FK)
- `category_id`: ID danh mục (FK)
- `sku`: Mã sản phẩm
- `description`: Mô tả chi tiết
- `price`: Giá hiện tại
- `old_price`: Giá cũ
- `stock_quantity`: Số lượng tồn kho
- `main_image`: Hình ảnh chính
- `is_bestseller`: Sản phẩm bán chạy
- `is_new`: Sản phẩm mới
- `rating`: Đánh giá trung bình
- `rating_count`: Số lượng đánh giá

#### `customers` - Khách hàng

- `id`: Khóa chính
- `email`: Email (unique)
- `password_hash`: Mật khẩu đã mã hóa
- `first_name`: Tên
- `last_name`: Họ
- `phone`: Số điện thoại
- `date_of_birth`: Ngày sinh
- `gender`: Giới tính
- `is_verified`: Đã xác thực email
- `last_login`: Lần đăng nhập cuối

#### `orders` - Đơn hàng

- `id`: Khóa chính
- `order_number`: Mã đơn hàng (unique)
- `customer_id`: ID khách hàng (FK)
- `status`: Trạng thái đơn hàng
- `payment_status`: Trạng thái thanh toán
- `payment_method`: Phương thức thanh toán
- `subtotal`: Tổng tiền hàng
- `tax_amount`: Thuế
- `shipping_amount`: Phí vận chuyển
- `total_amount`: Tổng cộng
- `tracking_number`: Mã vận chuyển

#### `order_items` - Chi tiết đơn hàng

- `id`: Khóa chính
- `order_id`: ID đơn hàng (FK)
- `product_id`: ID sản phẩm (FK)
- `quantity`: Số lượng
- `unit_price`: Đơn giá
- `total_price`: Thành tiền

### 2. Bảng phụ trợ

#### `cart_items` - Giỏ hàng

- `id`: Khóa chính
- `customer_id`: ID khách hàng (FK)
- `product_id`: ID sản phẩm (FK)
- `quantity`: Số lượng

#### `wishlist_items` - Danh sách yêu thích

- `id`: Khóa chính
- `customer_id`: ID khách hàng (FK)
- `product_id`: ID sản phẩm (FK)

#### `product_reviews` - Đánh giá sản phẩm

- `id`: Khóa chính
- `product_id`: ID sản phẩm (FK)
- `customer_id`: ID khách hàng (FK)
- `rating`: Điểm đánh giá (1-5)
- `title`: Tiêu đề đánh giá
- `comment`: Nội dung đánh giá
- `is_verified_purchase`: Mua hàng đã xác thực

#### `coupons` - Mã giảm giá

- `id`: Khóa chính
- `code`: Mã giảm giá (unique)
- `discount_type`: Loại giảm giá (percentage/fixed)
- `discount_value`: Giá trị giảm
- `minimum_amount`: Giá trị đơn hàng tối thiểu
- `usage_limit`: Giới hạn sử dụng
- `expires_at`: Ngày hết hạn

## Cài đặt và sử dụng

### 1. Thiết lập cơ sở dữ liệu

```sql
-- Chạy file database.sql để tạo cơ sở dữ liệu
sqlite3 pharmacare.db < database.sql
```

### 2. Sử dụng trong JavaScript

```javascript
// Import database class
import { PharmaCareDB } from "./js/database.js";

// Khởi tạo database
const db = new PharmaCareDB();

// Lấy danh sách sản phẩm
const products = await db.getProducts({
  category_id: 2,
  min_price: 100000,
  max_price: 500000,
});

// Thêm sản phẩm vào giỏ hàng
await db.addToCart(customerId, productId, quantity);

// Tạo đơn hàng mới
const order = await db.createOrder({
  customer_id: customerId,
  items: cartItems,
  shipping_address: address,
  payment_method: "cod",
});
```

### 3. Sử dụng API

```javascript
// Import API class
import { PharmaCareAPI } from "./api/database-api.js";

// Khởi tạo API
const api = new PharmaCareAPI();

// Lấy danh sách sản phẩm
const products = await api.getProducts({
  search: "vitamin",
  category_id: 2,
});

// Đăng ký khách hàng mới
const customer = await api.registerCustomer({
  email: "user@example.com",
  password: "password123",
  first_name: "Nguyen",
  last_name: "Van A",
  phone: "0123456789",
});

// Đăng nhập
const loginResult = await api.loginCustomer({
  email: "user@example.com",
  password: "password123",
});
```

## Các tính năng chính

### 1. Quản lý sản phẩm

- Thêm, sửa, xóa sản phẩm
- Phân loại theo danh mục và thương hiệu
- Quản lý tồn kho
- Đánh giá và bình luận

### 2. Quản lý khách hàng

- Đăng ký và đăng nhập
- Quản lý thông tin cá nhân
- Lịch sử đơn hàng
- Địa chỉ giao hàng

### 3. Quản lý đơn hàng

- Tạo đơn hàng từ giỏ hàng
- Theo dõi trạng thái đơn hàng
- Quản lý thanh toán
- Mã vận chuyển

### 4. Giỏ hàng và yêu thích

- Thêm/xóa sản phẩm khỏi giỏ hàng
- Cập nhật số lượng
- Danh sách yêu thích
- Lưu trữ lâu dài

### 5. Mã giảm giá

- Tạo mã giảm giá
- Áp dụng cho đơn hàng
- Theo dõi sử dụng
- Hạn chế thời gian

## Bảo mật

### 1. Mã hóa mật khẩu

```javascript
// Sử dụng bcrypt để mã hóa mật khẩu
const bcrypt = require("bcrypt");
const hashedPassword = await bcrypt.hash(password, 10);
```

### 2. JWT Authentication

```javascript
// Tạo token xác thực
const jwt = require("jsonwebtoken");
const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET);
```

### 3. Validation

```javascript
// Kiểm tra dữ liệu đầu vào
const validateProduct = (product) => {
  if (!product.name || product.name.length < 3) {
    throw new Error("Tên sản phẩm phải có ít nhất 3 ký tự");
  }
  if (product.price <= 0) {
    throw new Error("Giá sản phẩm phải lớn hơn 0");
  }
};
```

## Backup và Restore

### 1. Backup cơ sở dữ liệu

```bash
# Backup SQLite
sqlite3 pharmacare.db ".backup backup_$(date +%Y%m%d_%H%M%S).db"

# Backup MySQL
mysqldump -u username -p pharmacare > backup_$(date +%Y%m%d_%H%M%S).sql
```

### 2. Restore cơ sở dữ liệu

```bash
# Restore SQLite
sqlite3 pharmacare.db < backup_file.db

# Restore MySQL
mysql -u username -p pharmacare < backup_file.sql
```

## Monitoring và Logging

### 1. Theo dõi hiệu suất

```sql
-- Xem thống kê sản phẩm
SELECT * FROM product_stats;

-- Xem thống kê đơn hàng
SELECT * FROM order_stats;

-- Sản phẩm bán chạy nhất
SELECT p.name, COUNT(oi.id) as total_sold
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id
ORDER BY total_sold DESC
LIMIT 10;
```

### 2. Logging

```javascript
// Ghi log các hoạt động quan trọng
const logger = {
  info: (message, data) => {
    console.log(`[INFO] ${new Date().toISOString()}: ${message}`, data);
  },
  error: (message, error) => {
    console.error(`[ERROR] ${new Date().toISOString()}: ${message}`, error);
  },
};
```

## Troubleshooting

### 1. Lỗi thường gặp

**Lỗi kết nối database:**

```javascript
// Kiểm tra kết nối
try {
  await db.init();
  console.log("Database connected successfully");
} catch (error) {
  console.error("Database connection failed:", error);
}
```

**Lỗi duplicate key:**

```sql
-- Kiểm tra dữ liệu trùng lặp
SELECT email, COUNT(*) as count
FROM customers
GROUP BY email
HAVING count > 1;
```

### 2. Tối ưu hiệu suất

**Indexes quan trọng:**

```sql
-- Index cho tìm kiếm sản phẩm
CREATE INDEX idx_products_search ON products(name, description);

-- Index cho đơn hàng
CREATE INDEX idx_orders_date ON orders(created_at);

-- Index cho giỏ hàng
CREATE INDEX idx_cart_customer_product ON cart_items(customer_id, product_id);
```

## Liên hệ và hỗ trợ

Nếu bạn gặp vấn đề hoặc cần hỗ trợ, vui lòng liên hệ:

- Email: support@pharmacare.vn
- Hotline: 1900-1234
- Website: https://pharmacare.vn

---

**Lưu ý:** Đây là tài liệu cơ bản. Để biết thêm chi tiết về các tính năng nâng cao, vui lòng tham khảo tài liệu kỹ thuật chi tiết.
