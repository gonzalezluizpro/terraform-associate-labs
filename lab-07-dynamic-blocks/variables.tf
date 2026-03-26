variable "sg_ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    description = string
    port        = number
    protocol    = string
    cidr        = string
  }))
  default = [
    {
      description = "SSH access"
      port        = 22
      protocol    = "tcp"
      cidr        = "0.0.0.0/0"
    },
    {
      description = "HTTP access"
      port        = 80
      protocol    = "tcp"
      cidr        = "0.0.0.0/0"
    },
    {
      description = "HTTPS access"
      port        = 443
      protocol    = "tcp"
      cidr        = "0.0.0.0/0"
    },
    {
      description = "DNS access"
      port        = 53
      protocol    = "udp"
      cidr        = "0.0.0.0/0"
    },
    {
      description = "NTP access"
      port        = 123
      protocol    = "udp"
      cidr        = "0.0.0.0/0"
    },
    {
      description = "Application port"
      port        = 8080
      protocol    = "tcp"
      cidr        = "0.0.0.0/0"
    },
    {
      description = "PostgreSQL access"
      port        = 5432
      protocol    = "tcp"
      cidr        = "0.0.0.0/0"
    }
  ]
}