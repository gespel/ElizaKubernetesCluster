resource "kubernetes_manifest" "nginx_reverse_proxy_configmap" {
    manifest = yamldecode(file("${path.module}/nginx-reverse-proxy-configmap.yaml"))
  
}

resource "kubernetes_manifest" "nginx_reverse_proxy_service" {
  manifest = yamldecode(file("${path.module}/nginx-reverse-proxy-service.yaml"))
}

resource "kubernetes_manifest" "nginx_reverse_proxy" {
    manifest = yamldecode(file("${path.module}/nginx-reverse-proxy-deployment.yaml"))
    depends_on = [ kubernetes_manifest.nginx_reverse_proxy_configmap, kubernetes_manifest.nginx_reverse_proxy_service ]
}