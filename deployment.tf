resource "kubernetes_namespace" "demo" {
  metadata {
    name = "demo"
  }
}

resource "kubernetes_deployment" "demo_app" {
  metadata {
    name      = "demo-app"
    namespace = kubernetes_namespace.demo.metadata[0].name
    labels = { app = "demo-app" }
  }

  spec {
    replicas = 2

    selector {
      match_labels = { app = "demo-app" }
    }

    template {
      metadata {
        labels = { app = "demo-app" }
      }

      spec {
        container {
          name  = "demo-app"
          image = "jtmassa/portfolio_app:latest"

          port {
            container_port = 85
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "demo_lb" {
  metadata {
    name      = "demo-lb-service"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  spec {
    selector = { app = "demo-app" }

    port {
      port        = 85
      target_port = 85
    }

    type = "LoadBalancer"
  }
}
