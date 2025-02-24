#!/usr/bin/env ruby

# Service script for opening wiki links in a text editor.
# Works with bookmarker script and the bookmark CLI. Scans
# for [[wiki links]]. Works with [[wiki links|display
# text]]. If duti is installed, get app name for file
# extension.

BOOKMARKER = "~/scripts/bookmarker"
DUTI = "/opt/homebrew/bin/duti"

def parse_input(input)
  input.scan(/\[\[([a-z0-9 ]+)(?:\|.*?)?\]\]/i).flatten
end

def notify(message)
  `osascript -e 'display notification "#{message}" with title "Wiki Link Service"'`
end

def yn(message)
  `osascript -e 'button returned of (display dialog "#{message}" with title "Wiki Link Service" buttons {"Yes", "No"})'`.strip == "Yes"
end

ids = parse_input($stdin.read)

if ids.empty?
  notify "No WikiLink found"
  exit 1
end

ids.each do |id|
  path = `#{BOOKMARKER} find "#{id}"`.strip

  if path.empty?
    # If bookmark isn't found, try to find it with Spotlight
    spotlight_path = `mdfind "description:#{id}"`.strip.split(/\n/).first
    path = spotlight_path if File.exist?(spotlight_path)

    if path.empty?
      notify "No bookmark found for #{first_id}"
      exit
    end
  end

  if File.directory?(path)
    `open -R "#{path}"` if yn("Open #{File.basename(path)} in Finder?")
    exit 0
  end

  app = "default application"

  if File.executable?(DUTI)
    app = `#{DUTI} -x #{File.extname(path).delete(".")}`.split(/\n/).first.sub(/\.app$/, "")
  end

  `open "#{path}"` if yn("Open #{File.basename(path)} in #{app}?")
end
