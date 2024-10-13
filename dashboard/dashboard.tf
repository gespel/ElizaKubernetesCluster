resource "helm_release" "kubernetes_dashboard" {
  name       = "kubernetes-dashboard"
  namespace  = "default"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
}

resource "kubernetes_manifest" "admin_account" {
  manifest = yamldecode(file("${path.module}/dashboards-auth-serviceaccount.yaml"))
  depends_on = [ helm_release.kubernetes_dashboard ]
}

resource "kubernetes_manifest" "cluster_role_binding" {
  manifest = yamldecode(file("${path.module}/dashboards-auth-clusterrolebinding.yaml"))
  depends_on = [ helm_release.kubernetes_dashboard, kubernetes_manifest.admin_account ]
}
