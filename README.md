# 🛒 Online Boutique: High-Velocity Microservices Ecosystem

[![Kubernetes](https://img.shields.io/badge/Platform-Kubernetes-blue?logo=kubernetes)](https://kubernetes.io/)
[![Docker](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker)](https://www.docker.com/)
[![Helm](https://img.shields.io/badge/Package-Helm-0F1628?logo=helm)](https://helm.sh/)

This project represents the **full-scale stabilization and architectural refinement** of a 12-microservice e-commerce ecosystem. It demonstrates the ability to manage complex, polyglot environments where high-performance networking and container orchestration are critical.

---

## 🎭 The "3D" Transaction Flow
This sequence illustrates the "heartbeat" of the system. From the moment an external user clicks a product to the final checkout, see how data pulses through the cluster.

```mermaid
sequenceDiagram
    autonumber
    participant U as 🌐 External User
    participant F as 🚀 Frontend (Go)
    participant C as 📦 Product Catalog (Go)
    participant K as 🛒 Cart (C#)
    participant R as 💾 Redis (Cache)
    participant P as 💳 Payment (Node.js)
    participant E as 📧 Email (Python)

    U->>F: Browse Store (HTTP:9090)
    F->>C: GetProducts (GRPC:80)
    C-->>F: Product List
    F-->>U: Render HTML
    U->>F: Add to Cart
    F->>K: AddItem (GRPC:80)
    K->>R: Persist Session (TCP:6379)
    U->>F: Place Order
    F->>P: ProcessPayment (GRPC:80)
    P-->>F: Success
    F->>E: SendConfirmation (GRPC:80)
    E-->>U: SMTP Confirmation
```

---

## 🏗️ Architectural Topology
The "External World" interacts with the Frontend, which acts as a **Gatekeeper** to the internal service mesh.

```mermaid
flowchart TD
    %% Styling
    classDef external fill:#f96,stroke:#333,stroke-width:2px;
    classDef internal fill:#69f,stroke:#333,stroke-width:1px;
    classDef database fill:#9f9,stroke:#333,stroke-width:2px;
    classDef devops fill:#f69,stroke:#333,stroke-width:2px;

    User((🌐 Internet User)):::external -->|Ingress/LB| Frontend[🚀 Frontend Server]:::internal
    
    subgraph "Microservices Core (High-Availability)"
        Frontend -->|Port 80| Catalog[📦 Product Catalog]:::internal
        Frontend -->|Port 80| Cart[🛒 Cart Service]:::internal
        Frontend -->|Port 80| Currency[💱 Currency Engine]:::internal
        Frontend -->|Port 80| Shipping[🚚 Shipping Logic]:::internal
        
        Cart -->|Port 6379| Redis[(💾 Redis Cache)]:::database
        
        Frontend -->|Port 80| Checkout[💰 Checkout Orchestrator]:::internal
        Checkout -->|Port 80| Payment[💳 Payment Gateway]:::internal
        Checkout -->|Port 80| Email[📧 Email Notifier]:::internal
        Checkout -->|Port 80| Ads[📢 Ad Service]:::internal
    end

    subgraph "DevOps Excellence"
        Jenkins[⚙️ CI/CD Jenkins]:::devops -.->|Artifacts| Docker[🐳 Docker Hub]
        Helm[☸️ Helm/K8s]:::devops -.->|Deploy| Frontend
    end
```

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
| **LoadGenerator** | Python | Simulates user traffic using Locust. | Stress testing; validates DevOps scaling policies. |

---

## 🌐 The DevOps -> External World Interaction
How this project bridges the gap between code and the real world:

1.  **Ingress & Traffic Control:** In a production environment (like AWS EKS), the DevOps engineer configures an **ALB (Application Load Balancer)** to route port 443 (HTTPS) to the Frontend Service on port 80.
2.  **Service Isolation:** Internal services are **invisible** to the external world. They exist in a private subnet, protected by Kubernetes Network Policies.
3.  **Observability Loop:** When an external user encounters a 500 error, DevOps tools (Prometheus/Grafana) alert the engineer, who traces the request back through the gRPC mesh to the failing pod.
4.  **Zero-Downtime Deployment:** Using **Helm**, we can update the `PaymentService` image and perform a "Rolling Update," ensuring external users never see a 404 page during a release.

---

*Engineered by **K. Rakesh** — Bridging the gap between Microservices and Infrastructure.*
