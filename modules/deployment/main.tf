
provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority)
  token                  = var.cluster_auth_token
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority)
    token                  = var.cluster_auth_token
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

  depends_on = [kubernetes_namespace.argocd]
}


