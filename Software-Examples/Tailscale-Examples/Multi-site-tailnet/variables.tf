
variable "public_key_file" {
    type = string
    default = "~/.ssh/id_rsa.pub"
}

variable "num_of_cities" {
    type = number
    default = 1
    validation {
    condition     = var.num_of_cities >= 1 && var.num_of_cities <= 7 #Only reason I put 7 here is that I only defined 7 City names in the main.tf (var.city_names)
    error_message = "Num of Cities must be 1-7"
  }
}

