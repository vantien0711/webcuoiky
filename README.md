# 🏥 PharmaCare - Nhà thuốc trực tuyến

## 📋 Mô tả dự án

PharmaCare là một website nhà thuốc trực tuyến hiện đại, cung cấp các sản phẩm chăm sóc sức khỏe chất lượng cao với giao diện thân thiện và trải nghiệm mua sắm tuyệt vời.

## 🚀 Tính năng chính

### 🛍️ **Mua sắm trực tuyến**

- **5 trang sản phẩm chuyên biệt:**
  - 📋 [Thuốc](thuoc.html) - Các loại thuốc kê đơn và không kê đơn
  - 💊 [Vitamin & Thực phẩm chức năng](vitamin.html) - Bổ sung dinh dưỡng
  - 🧴 [Chăm sóc da](cham-soc-da.html) - Mỹ phẩm và kem dưỡng
  - 🏥 [Thiết bị y tế](thiet-bi-y-te.html) - Máy đo huyết áp, đường huyết
  - 👶 [Sản phẩm trẻ em](tre-em.html) - Sữa bột và thuốc trẻ em

### 🔍 **Tìm kiếm và lọc sản phẩm**

- Tìm kiếm theo tên, mô tả
- Lọc theo danh mục, thương hiệu, giá
- Sắp xếp theo nhiều tiêu chí
- Phân trang thông minh

### 🛒 **Giỏ hàng và thanh toán**

- Thêm/xóa sản phẩm vào giỏ hàng
- Quản lý số lượng sản phẩm
- Thanh toán an toàn
- Lưu trữ giỏ hàng

### ❤️ **Danh sách yêu thích**

- Thêm sản phẩm vào wishlist
- Quản lý danh sách yêu thích
- Đồng bộ với tài khoản

### 👤 **Hệ thống tài khoản**

- [Đăng ký](register.html) tài khoản mới
- [Đăng nhập](login.html) an toàn
- Quản lý thông tin cá nhân
- Lịch sử đơn hàng

### 💬 **Hỗ trợ khách hàng**

- Chat với dược sĩ 24/7
- [Liên hệ](contact.html) trực tiếp
- Hướng dẫn sử dụng sản phẩm

## 🗂️ Cấu trúc dự án

```
web - Copy/
├── 📄 index.html              # Trang chủ
├── 📄 thuoc.html              # Trang thuốc
├── 📄 vitamin.html            # Trang vitamin & thực phẩm chức năng
├── 📄 cham-soc-da.html        # Trang chăm sóc da
├── 📄 thiet-bi-y-te.html      # Trang thiết bị y tế
├── 📄 tre-em.html             # Trang sản phẩm trẻ em
├── 📄 promotion.html          # Trang khuyến mãi
├── 📄 contact.html            # Trang liên hệ
├── 📄 login.html              # Trang đăng nhập
├── 📄 register.html           # Trang đăng ký
├── 📄 database.sql            # Cơ sở dữ liệu SQL
├── 📄 README-database.md      # Hướng dẫn database
├── 📄 README.md               # Hướng dẫn sử dụng (file này)
├── 📁 css/                    # Thư mục CSS
│   ├── 📄 styles.css          # CSS chính
│   ├── 📄 product-styles.css  # CSS trang sản phẩm
│   ├── 📄 auth-styles.css     # CSS trang đăng nhập/đăng ký
│   ├── 📄 contact-styles.css  # CSS trang liên hệ
│   └── 📄 promotion-styles.css # CSS trang khuyến mãi
├── 📁 js/                     # Thư mục JavaScript
│   ├── 📄 script.js           # JavaScript chính
│   ├── 📄 product-script.js   # JavaScript trang sản phẩm
│   ├── 📄 database.js         # Database client-side
│   ├── 📄 auth-scipt.js       # JavaScript đăng nhập/đăng ký
│   ├── 📄 contact-script.js   # JavaScript trang liên hệ
│   └── 📄 promotion-script.js # JavaScript trang khuyến mãi
└── 📁 api/                    # Thư mục API
    └── 📄 database-api.js     # API và Mock API
```

## 🛠️ Công nghệ sử dụng

### **Frontend**

- **HTML5** - Cấu trúc trang web
- **CSS3** - Giao diện và animation
- **JavaScript (ES6+)** - Tương tác và logic
- **Font Awesome** - Icon library
- **Google Fonts** - Typography

### **Backend & Database**

- **SQLite** - Cơ sở dữ liệu chính
- **IndexedDB** - Database client-side
- **RESTful API** - Giao tiếp dữ liệu
- **Mock API** - Phát triển frontend

### **Tính năng nâng cao**

- **Responsive Design** - Tương thích mọi thiết bị
- **Progressive Web App** - Trải nghiệm app-like
- **Local Storage** - Lưu trữ dữ liệu local
- **Session Management** - Quản lý phiên đăng nhập

## 🚀 Cách sử dụng

### **1. Khởi chạy website**

```bash
# Mở file index.html trong trình duyệt
# Hoặc sử dụng Live Server
# Hoặc chạy local server
python -m http.server 8000
```

### **2. Navigation**

- **Trang chủ**: Xem tổng quan và truy cập nhanh
- **Sản phẩm**: Dropdown menu với 5 danh mục chính
- **Khuyến mãi**: Xem các ưu đãi đặc biệt
- **Liên hệ**: Thông tin liên hệ và hỗ trợ

### **3. Mua sắm**

1. **Duyệt sản phẩm**: Chọn danh mục sản phẩm
2. **Tìm kiếm**: Sử dụng thanh tìm kiếm
3. **Lọc sản phẩm**: Áp dụng bộ lọc theo nhu cầu
4. **Thêm vào giỏ**: Click "Thêm vào giỏ hàng"
5. **Thanh toán**: Hoàn tất đơn hàng

### **4. Tài khoản**

- **Đăng ký**: Tạo tài khoản mới
- **Đăng nhập**: Truy cập tài khoản
- **Quản lý**: Xem lịch sử đơn hàng

## 📱 Responsive Design

Website được thiết kế responsive cho:

- **Desktop** (1200px+)
- **Tablet** (768px - 1199px)
- **Mobile** (320px - 767px)

## 🔧 Tùy chỉnh

### **Thêm sản phẩm mới**

1. Cập nhật `database.sql` với dữ liệu sản phẩm
2. Thêm vào `api/database-api.js` mock data
3. Cập nhật bộ lọc trong các trang sản phẩm

### **Thay đổi giao diện**

1. Chỉnh sửa CSS trong thư mục `css/`
2. Cập nhật HTML structure
3. Thêm animation và hiệu ứng

### **Tích hợp backend thật**

1. Thay thế `MockPharmaCareAPI` bằng API thật
2. Cập nhật endpoint trong `api/database-api.js`
3. Cấu hình authentication và security

## 🐛 Xử lý lỗi

### **Lỗi thường gặp**

- **Sản phẩm không hiển thị**: Kiểm tra database connection
- **Giỏ hàng không lưu**: Kiểm tra localStorage
- **Đăng nhập không hoạt động**: Kiểm tra authentication logic

### **Debug**

- Mở Developer Tools (F12)
- Kiểm tra Console tab
- Xem Network tab cho API calls

## 📞 Hỗ trợ

- **Hotline**: 1900-1234
- **Email**: support@pharmacare.vn
- **Địa chỉ**: 123 Đường ABC, Quận 1, TP.HCM

## 📄 License

© 2024 PharmaCare. Tất cả quyền được bảo lưu.

---

**PharmaCare** - Chăm sóc sức khỏe toàn diện cho mọi gia đình! 🏥💊
