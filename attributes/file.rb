# encoding: utf-8
#
# Cookbook Name:: matrix_server
# Attributes:: file
#

normal['file']['header'] = <<-EOF.gsub(/^\s*/, '')
  #
  # File: @filename
  # Generated by Chef for @hostname.
  # Local modifications will be overwritten.
  #
EOF
