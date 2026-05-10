# 🛒 Online Boutique: High-Velocity Microservices Ecosystem

<p align="center">
  <img src="https://rakeshkolipakaace.github.io/Microservices-e-commerce/hero_architecture.png" alt="Boutique 3D Architecture" width="100%">
</p>

[![Kubernetes](https://img.shields.io/badge/Platform-Kubernetes-blue?logo=kubernetes)](https://kubernetes.io/)
[![Docker](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker)](https://www.docker.com/)
[![Helm](https://img.shields.io/badge/Package-Helm-0F1628?logo=helm)](https://helm.sh/)

This project represents the **full-scale stabilization and architectural refinement** of a 12-microservice e-commerce ecosystem. It demonstrates the ability to manage complex, polyglot environments where high-performance networking and container orchestration are critical.

---

## 🖥️ Real-Time Operations
The Boutique is managed from a centralized DevOps command center, ensuring zero-downtime and real-time observability across all 12 services.

<p align="center">
  <img src="https://rakeshkolipakaace.github.io/Microservices-e-commerce/real_time_devops_center.png" alt="Real-Time DevOps Center" width="100%">
</p>

---

## 🎭 Active System Flow (Live Animation)
Below is the **live animated data flow** showing how requests pulse through the Enterprise DevOps architecture.

<p align="center">
  <img src="https://rakeshkolipakaace.github.io/Microservices-e-commerce/flow_architecture.svg" alt="Animated Architecture" width="100%">
</p>

---

## 📋 Service Intelligence: The 12 Pillars

| Service | Language | Core Responsibility | DevOps Significance |
| :--- | :--- | :--- | :--- |
| **Frontend** | Go | Server-side rendering (SSR) of the boutique UI. | Acts as the Ingress point; manages session cookies. |
| **ProductCatalog** | Go | Read-only access to the inventory JSON. | High-frequency read service; optimized for latency. |
| **CartService** | C# (.NET 8) | Manages items in the user's shopping cart. | State management; requires strict Redis connectivity. |
| **CheckoutService** | Go | Orchestrates the entire "Purchase" workflow. | Critical path; handles multiple downstream GRPC calls. |
| **CurrencyService** | Node.js | Real-time conversion of product prices. | Lightweight JS service; critical for global sales. |
| **PaymentService** | Node.js | Mocked gateway for processing credit cards. | Security-focused; high compliance requirements. |
| **ShippingService** | Go | Calculates shipping costs based on weight. | Stateless logic; easily scalable in the cluster. |
| **EmailService** | Python | Sends order confirmation emails. | Background processing; decoupled via async calls. |
| **Recommendation** | Python | Suggests "Related Products" using basic logic. | Machine Learning entry point; data-heavy service. |
| **AdService** | Java 21 | Serves targeted advertisements. | High performance; uses generated GRPC code. |
| **Redis** | C (Cache) | Distributed memory store for Cart Service. | Single point of state; requires high availability. |


---

## 🌐 The DevOps -> External World Interaction
How this project bridges the gap between code and the real world:

1.  **Ingress & Traffic Control:** In a production environment, an **ALB (Application Load Balancer)** routes port 443 (HTTPS) to the Frontend Service.
2.  **Service Isolation:** Internal services are protected by Kubernetes Network Policies and reside in private subnets.
3.  **Observability Loop:** Integrated health checks (Liveness/Readiness) ensure the cluster self-heals if a service fails.
4.  **Zero-Downtime Deployment:** Helm-managed rolling updates ensure the "External World" never experiences service interruptions.

---

*Engineered by **K. Rakesh** — Bridging the gap between Microservices and Infrastructure.*


