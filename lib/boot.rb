# File that bootstraps the application
require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

Money.rounding_mode = BigDecimal::ROUND_HALF_UP
Money.locale_backend = nil

require_relative 'product'
