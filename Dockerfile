# 使用 Streamlit 官方提供的 Python 基礎映像
FROM python:3.10-slim-buster

# 設定工作目錄
WORKDIR /app

# 安裝 Tesseract OCR 引擎及其繁體中文語言包和 OpenCV 相關的系統依賴
# libgl1-mesa-glx: 解決OpenGL相關錯誤
# libglib2.0-0, libsm6, libxext6, libxrender1, libfontconfig1: OpenCV在無頭模式下可能需要的通用圖形庫
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-chi-tra \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libfontconfig1 \
    # 清理APT緩存，減少映像大小
    && rm -rf /var/lib/apt/lists/*

# 複製您的 requirements.txt 並安裝 Python 依賴
COPY requirements.txt .
RUN pip install -r requirements.txt

# 複製您的 Streamlit 應用程式檔案
COPY . .

# 設定 Tesseract 語言數據檔案的路徑。這是非常關鍵的。
# 通常在Debian系統中，Tesseract語言包會安裝到這個路徑
ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/4.00/tessdata

# 啟動 Streamlit 應用程式
EXPOSE 8501
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.enableCORS=false"]
