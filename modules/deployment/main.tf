
provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


resource "kubernetes_deployment" "hello_world_app" {
  metadata {
    name = "hello-world-app"
    labels = {
      app = "hello-world-app"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "hello-world-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "hello-world-app"
        }
      }
      spec {
        container {
          image = var.app_image
          name  = "hello-world-app"
          port {
            container_port = 5000
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hello_world_app" {
  metadata {
    name = "hello-world-service"  
  }
  
  spec {
    selector = {
      app = kubernetes_deployment.hello_world_app.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 5000
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "hello_world_app" {
  metadata {
    name = "hello-world-hpa"  
  }
  
  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.hello_world_app.metadata[0].name
    }
    min_replicas = 1
    max_replicas = 3
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 50
        }
      }
    }
  }
}


# Create namespace for ArgoCD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      "app.kubernetes.io/managed-by" = "Helm"
    }
  }

  # This will force delete the namespace if it exists
  lifecycle {
    ignore_changes = [
      metadata[0].labels,
      metadata[0].annotations,
    ]
  }
}

resource "null_resource" "cleanup_argocd" {
  triggers = {
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  provisioner "local-exec" {
    command = <<-EOT
      kubectl delete --ignore-not-found=true -n argocd service argocd-server
      kubectl delete --ignore-not-found=true -n argocd service argocd-repo-server
      kubectl delete --ignore-not-found=true -n argocd service argocd-redis
      kubectl delete --ignore-not-found=true -n argocd service argocd-dex-server
      kubectl delete --ignore-not-found=true -n argocd deployment argocd-server
      kubectl delete --ignore-not-found=true -n argocd deployment argocd-repo-server
      kubectl delete --ignore-not-found=true -n argocd deployment argocd-redis
      kubectl delete --ignore-not-found=true -n argocd deployment argocd-dex-server
      kubectl delete --ignore-not-found=true -n argocd deployment argocd-application-controller
    EOT
  }

  depends_on = [kubernetes_namespace.argocd]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "3.35.4"
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  force_update  = true
  replace       = true
  recreate_pods = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.extraArgs"
    value = "{--insecure}"
  }

  set {
    name  = "server.resources.limits.cpu"
    value = "1000m"
  }
  
  set {
    name  = "server.resources.limits.memory"
    value = "2Gi"
  }

  set {
    name  = "server.resources.requests.cpu"
    value = "500m"
  }

  set {
    name  = "server.resources.requests.memory"
    value = "1Gi"
  }

  # Add required labels and annotations
  set {
    name  = "global.additionalLabels.app\\.kubernetes\\.io/managed-by"
    value = "Helm"
  }

  depends_on = [
    kubernetes_namespace.argocd,
    null_resource.cleanup_argocd
  ]
}