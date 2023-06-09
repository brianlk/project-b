variable "project" {
  type = string
  default = "projectB"
}

# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "network-ip-range" {
  type = string
}

variable "public-net" {
  type = list
} 


variable "private-net" {
  type = list
} 

variable "iam-role-eks-arn" {
  type = string
}

variable "iam-role-node-arn" {
  type = string
}

variable "mode" {
  type = string
}

