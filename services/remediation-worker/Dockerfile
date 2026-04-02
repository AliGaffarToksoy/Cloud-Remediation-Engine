# Hafif bir Python sürümü kullanıyoruz (M3 Pro'da saniyeler içinde iner)
FROM python:3.11-slim

# Konteyner içindeki çalışma dizinimiz
WORKDIR /app

# Sadece requirements dosyasını kopyalayıp kütüphaneleri kuruyoruz (Cache optimizasyonu için)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Şimdi motorumuzun kodunu kopyalıyoruz
COPY worker.py .

# Konteyner ayağa kalktığında çalıştırılacak komut
CMD ["python", "worker.py"]