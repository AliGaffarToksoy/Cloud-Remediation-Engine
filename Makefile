# 🛡️ Sentinel-Ops (Cloud Remediation Engine) Otomasyon Dosyası
# Kullanım: Terminalde 'make <komut>' yazmanız yeterlidir.

.PHONY: help start-all stop-all k8s-start k8s-stop local-up local-down

help:
	@echo "🚀 Sentinel-Ops Makefile Komutları:"
	@echo "-----------------------------------"
	@echo "  make start-all    - K8s ve LocalStack'i aynı anda başlatır"
	@echo "  make stop-all     - K8s ve LocalStack'i güvenle durdurur"
	@echo "  make k8s-start    - Sadece Minikube kümesini başlatır"
	@echo "  make local-up     - Sadece LocalStack'i başlatır"

start-all: k8s-start local-up
	@echo "✅ Tüm sistemler başarıyla ayağa kaldırıldı!"

stop-all: k8s-stop local-down
	@echo "💤 Tüm sistemler uykuya alındı."

k8s-start:
	@echo "☸️ Kubernetes (Minikube) başlatılıyor..."
	minikube start

k8s-stop:
	@echo "🛑 Kubernetes (Minikube) durduruluyor..."
	minikube stop

local-up:
	@echo "☁️ LocalStack başlatılıyor..."
	cd localstack && docker compose start

local-down:
	@echo "☁️ LocalStack durduruluyor..."
	cd localstack && docker compose stop