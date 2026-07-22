resource "kubernetes_namespace" "demo" {
  metadata {
    name = "demo"
  }
}

resource "kubernetes_deployment" "demo_app" {
  metadata {
    name      = "demo-app" // deployment name
    namespace = kubernetes_namespace.demo.metadata[0].name // specify the namespace
    labels = { app = "jull-app" }
  }

  spec {
    replicas = 2

    selector {
      match_labels = { app = "jull-app" } // match the deployment's label
    }

    template {
      metadata {
        labels = { app = "jull-app" } // match service selector so they can communicate
      }

      spec {
        container {
          name  = "jull-app"
          image = "jtmassa/portfolio_app:latest" // my image from Docker Hub

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
    name      = "demo-lb-service" // service name
    namespace = kubernetes_namespace.demo.metadata[0].name // specify the namespace
  }

  spec {
    selector = { app = "jull-app" } // match the deployment's label

    port {
      port        = 85
      target_port = 85
    }

    type = "LoadBalancer" // service type. Can also be ClusterIP, or  NodePort
  }
}
