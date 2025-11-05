# ---- base image ----
FROM python:3.10-slim

# 시스템 필수 패키지
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev curl && \
    rm -rf /var/lib/apt/lists/*

# 작업 디렉토리
WORKDIR /app

# 캐시 효율을 위해 requirements 먼저 복사/설치
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# 애플리케이션 복사
COPY . /app

# Streamlit 외부 접속을 허용하도록 설정
ENV STREAMLIT_SERVER_HEADLESS=true \
    STREAMLIT_SERVER_PORT=8501 \
    STREAMLIT_SERVER_ENABLECORS=false \
    STREAMLIT_SERVER_ENABLEXSRSFPROTECTION=false

EXPOSE 8501

# 앱 진입점 (app/app.py 경로 맞춰서 수정)
CMD ["streamlit", "run", "app.py", "--server.address=0.0.0.0"]
