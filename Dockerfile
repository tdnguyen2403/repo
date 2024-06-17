# Sử dụng hình ảnh Python chính thức từ Docker Hub
FROM python:3.8-slim

# Đặt thư mục làm việc trong container
WORKDIR /app

# Sao chép file requirements.txt vào thư mục làm việc
COPY requirements.txt .

# Cài đặt các gói phụ thuộc từ requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Sao chép toàn bộ mã nguồn của bạn vào thư mục làm việc
COPY . .

# Mở cổng 80 cho ứng dụng
EXPOSE 80

# Đặt biến môi trường (nếu cần)
ENV NAME World

# Chạy ứng dụng Python khi container khởi động
CMD ["python", "app.py"]
