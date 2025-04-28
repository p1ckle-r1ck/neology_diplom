variable "cloud" {
  type = object({
    folder_id    = string
    default_zone = string
    cloud_id     = string

  })
}

variable "network-zones" {
  type = object({
    a = string
    b = string
    d = string
    m = string
  })
  default = {
    a = "ru-central1-a"
    b = "ru-central1-b"
    d = "ru-central1-d"
    m = "ru-central1-m"
  }
}

variable "k8s-instance" {
  type = map(object({
    image_id      = string
    cores         = number
    memory        = number
    core_fraction = number
  }))
  default = {
    "master_node" = {
      image_id      = "fd8u4lo7mqb9ikhuskqp"
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
    "worker_node" = {
      image_id      = "fd8u4lo7mqb9ikhuskqp"
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}
variable "force_redeploy" {
  type = bool
  description = "Deploy Kuber cluster?"
}