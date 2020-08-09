# File that bootstraps the application
require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

Money.rounding_mode = BigDecimal::ROUND_HALF_UP
Money.locale_backend = nil

require_relative 'product'
require_relative 'checkout'
require_relative 'global_discount'
require_relative 'bulk_discount'
