#!/usr/bin/ruby

# Load environment variables.
require 'dotenv'
Dotenv.load

# Get plist location.
plist_location = "#{ENV['BUILT_PRODUCTS_DIR']}/#{ENV['PRODUCT_NAME']}.app/Info.plist"
puts "-- plist location: #{plist_location}"

# Set the variables in the plist.
puts "-- Set the correct variables"
`/usr/libexec/PlistBuddy "#{plist_location}" -c "set API_HOST #{ENV['API_HOST']}"`
`/usr/libexec/PlistBuddy "#{plist_location}" -c "set API_PROTOCOL #{ENV['API_PROTOCOL']}"`
`/usr/libexec/PlistBuddy "#{plist_location}" -c "set API_VERSION #{ENV['API_VERSION']}"`
`/usr/libexec/PlistBuddy "#{plist_location}" -c "set Fabric:APIKey #{ENV['FABRIC_API_KEY']}"`

