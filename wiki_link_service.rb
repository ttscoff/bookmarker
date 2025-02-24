#!/usr/bin/env ruby

# Service script for opening wiki links in a text editor.
# Works with bookmarker script and the bookmark CLI. Scans
# for [[wiki links]]. Works with [[wiki links|display
# text]]. If duti is installed, get app name for file
# extension.

BOOKMARKER = "~/scripts/bookmarker"

def parse_input(input)
  if input =~ /\[\[([a-z0-9 ]+)(?:\|.*?)?\]\]/i
    Regexp.last_match(1)
  end
end

def notify(message)
  `osascript -e 'display notification "#{message}" with title "Wiki Link Service"'`
end

def yn(message)
  `osascript -e 'button returned of (display dialog "#{message}" with title "Wiki Link Service" buttons {"Yes", "No"})'`.strip == "Yes"
end

first_id = parse_input($stdin.read)

if first_id.nil?
  notify "No WikiLink found"
  exit 1
end

path = `#{BOOKMARKER} find "#{first_id}"`.strip

if path.empty?
  notify "No bookmark found for #{first_id}"
  exit
end

if File.directory?(path)
  `open -R "#{path}"`
  exit
end

app = "default application"

if File.executable?("/opt/homebrew/bin/duti")
  app = `/opt/homebrew/bin/duti -x #{File.extname(path).delete(".")}`.split(/\n/).first.sub(/\.app$/, "")
end

`open "#{path}"` if yn("Open #{File.basename(path)} in #{app}?")
