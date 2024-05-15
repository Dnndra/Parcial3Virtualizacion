provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "docker-desktop"
}

resource "kubernetes_deployment" "hola-mundo" {
  metadata {
    name = "api"
    labels = {
        App = "HolaMundo"
    }
  }
  
  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "HolaMundo"
      }
    }
    template {
      metadata {
        labels = {
          App = "HolaMundo"
        }
      }
      spec {
        container {
          image = "dnndra/api-hola-mundo:latest"
          name = "example"

          port {
            container_port = 3000

          }

          resources {
            limits = {
                cpu = "0.5"
                memory = "512Mi"
            }
            requests = {
              cpu = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hola-mundo" {
  metadata {
    name = "hola-mundo"
  }
  spec {
    selector = {
      App = kubernetes_deployment.hola-mundo.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 3000
      target_port = 3000
    }

    type = "NodePort"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx"
    labels = {
        App = "ScalableNginx"
    }
  }
  
  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ScalableNginx"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableNginx"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name = "example"

          port {
            container_port = 80

          }

          resources {
            limits = {
                cpu = "0.5"
                memory = "512Mi"
            }
            requests = {
              cpu = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx"
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30202
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

resource "kubernetes_deployment" "mongo" {
  metadata {
    name = "mongo"
    labels = {
      App = "MongoDB"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "MongoDB"
      }
    }

    template {
      metadata {
        labels = {
          App = "MongoDB"
        }
      }

      spec {
        container {
          image = "mongo:latest"
          name  = "mongo"

          port {
            container_port = 27017
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

resource "kubernetes_service" "mongo" {
  metadata {
    name = "mongo"
  }

  spec {
    selector = {
      App = kubernetes_deployment.mongo.spec.0.template.0.metadata[0].labels.App
    }

    port {
      node_port   = 30203
      port        = 27017
      target_port = 27017
    }

    type = "NodePort"
  }
}