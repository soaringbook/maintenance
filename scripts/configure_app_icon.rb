#!/usr/bin/ruby

require 'json'

#
# IMPORTANT: To be able to use this script, install ImageMagick and GhostScript.
# => brew install imagemagick
# => brew install gs
#

# This line is needed to be able to run the convert command.
ENV['PATH'] = "#{ENV['PATH']}:/usr/local/bin"

# Define some basic Xcode variables.
source_root = ENV['SRCROOT']
target_name = ENV['TARGET_NAME']
configuration = ENV['CONFIGURATION']
configuration_build_dir = ENV['CONFIGURATION_BUILD_DIR']
unlocalized_resources_folder_path = ENV['UNLOCALIZED_RESOURCES_FOLDER_PATH']
target_path = "#{configuration_build_dir}/#{unlocalized_resources_folder_path}"

appIcon = "AppIcon"

# Retrieve the version and build string and remove the new line.
version = `/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${INFOPLIST_FILE}"`
build = `/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${INFOPLIST_FILE}"`
version.delete!("\n")
build.delete!("\n")
version = "#{version} / #{build}"

puts "[VERBOSE] Badging icons with #{version}"

# Define the path to the icon asset catalog and parse the Contents.json file.
unless appiconset = Dir.glob('**/*.appiconset').first
  abort "No Appiconsest Found!"
end
contents_file = "#{appiconset}/Contents.json"
xcassets = JSON.parse(IO.read(contents_file))

puts "[VERBOSE] Source path: #{appiconset}"
puts "[VERBOSE] Target path: #{target_path}"

# Loop through all icons present in the asset catalog.
for asset in xcassets["images"]
  # Define the base name of the icon and the size.
  icon_name = "#{appIcon}#{asset["size"]}"
  width = height = asset["size"].to_i

  # If this is a retina icon, add @2x to the target name and increase the size of rectangle which will contain the version string.
  if asset["scale"] == "2x"
    icon_name << "@2x"
    width *= 2
    height *= 2
  end

  # If this is a retina icon, add @2x to the target name and increase the size of rectangle which will contain the version string.
  if asset["scale"] == "3x"
    icon_name << "@3x"
    width *= 3
    height *= 3
  end

  # If this is an icon for the iPad, extend the target name with ~ipad.
  if asset["idiom"] == "ipad"
    icon_name << "~ipad"
  end

  # Only draw the version string in a 6th of the icon height.
  height /= 8.0

  # Define the base and target path for the new generated icon name.
  base_file = "#{appiconset}/#{asset["filename"]}"
  target_file = "#{target_path}/#{icon_name}.png"

  # Draw the version string on the bottom of the icon with the given size and height. The background is transparent.
  `convert -background '#0000' -fill "#2F4050" -gravity center -size #{width}x#{height} caption:"#{version}" "#{base_file}" +swap -gravity south -composite "#{target_file}"`
end
