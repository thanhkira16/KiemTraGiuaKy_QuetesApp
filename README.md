# 📱 Daily Quotes – Ứng dụng Danh ngôn hàng ngày

Ứng dụng di động hiển thị danh ngôn (quote) ngẫu nhiên và cho phép người dùng lưu lại những câu yêu thích ❤️.

Được phát triển bằng **Flutter** và sử dụng **Capacitor Storage Plugin** để lưu dữ liệu cục bộ.  
Hỗ trợ đa nền tảng: **Android**, **iOS**, và **Web**.

---

## ✨ Tính năng chính

### 🏠 Màn hình chính
- Hiển thị **danh ngôn ngẫu nhiên**
- Nút **“Quote mới”** để đổi sang danh ngôn khác
- Nút ❤️ để **thêm/bỏ yêu thích**
- Hiệu ứng **fade-in** và **slide-up** khi đổi quote

### 💗 Màn hình yêu thích
- Hiển thị các danh ngôn đã đánh dấu ❤️
- Cho phép **xóa từng quote** hoặc **xóa tất cả**
- Dữ liệu được lưu bằng **@capacitor/storage** (hoặc `SharedPreferences`)

---

## 🛠️ Công nghệ sử dụng

| Công nghệ                          | Mục đích                          |
|------------------------------------|-----------------------------------|
| **Flutter 3.9.2**                  | Framework phát triển ứng dụng     |
| **Dart**                           | Ngôn ngữ lập trình                |
| **Provider**                       | Quản lý trạng thái (state management) |
| **Capacitor Storage / SharedPreferences** | Lưu trữ dữ liệu cục bộ            |
| **HTTP**                           | Gọi API danh ngôn                 |
| **ZenQuotes API**                  | Nguồn danh ngôn ngẫu nhiên        |

---

## 🚀 Cài đặt & Chạy ứng dụng

### 1️⃣ Cài dependencies
```bash
flutter pub get
```

### 2️⃣ Chạy ứng dụng
```bash
flutter run
```

### 3️⃣ Build cho phát hành
```bash
flutter build apk --release
```

---

## 🎨 Thiết kế giao diện
- Nền gradient màu tím → xanh cho màn hình chính
- Nền hồng → đỏ cho màn hình yêu thích
- Font chữ dễ đọc, bố cục đơn giản theo Material Design 3

---

## 🎯 Yêu cầu kỹ thuật
- ✅ 2 màn hình (chính & yêu thích)
- ✅ Hiển thị danh ngôn ngẫu nhiên
- ✅ Lưu danh sách yêu thích bằng Capacitor Storage
- ✅ Giao diện đơn giản, có hiệu ứng chuyển đổi quote

---

## 📚 Thông tin thêm
- **Đề tài**: ĐỀ 3 – Ứng dụng Danh ngôn hàng ngày
- **Ngôn ngữ**: Tiếng Việt
- **Trạng thái**: ✅ Hoàn thành
- **License**: MIT