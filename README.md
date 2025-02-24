# bookmarker

[bookmark-cli]: https://github.com/ttscoff/bookmark-cli

This script is designed to work with [bookmark-cli]. It creates a JSON reference file allowing for short bookmark names to reference files. The links are "sturdy" and will survive the target file being moved or renamed.

The original version of this script was created by Ralf Hülsmann.

## Installation

Copy the `bookmarker` file to your $PATH and make sure it's executable with `chmod a+x /path/to/bookmarker`.

I prefer to make symlinks to scripts like this so that I can pull changes in the original repo directory and my script updates automatically:

    ln -s /path/to/bookmarker/bookmarker /opt/homebrew/bin/


## Usage

```console
Usage:
  bookmarker add|save /path/to/file [alias] → Save bookmark
  bookmarker get|find 123456789             → Retrieve bookmark
  bookmarker delete|x 123456789             → Delete bookmark
  bookmarker list|ls                        → Show all bookmarks
```

If an alias is not passed to the add subcommand, a numeric id will be generated automatically.

When running the add command, the resulting bookmark is output to STDOUT. The key will be downcased and spaces will be removed, so the actual key may be different than the input. Passing the command to `pbcopy` will therefore end with the new key in the clipboard.

Passing an alias or numeric id to the `get` subcommand will output the resulting path to STDOUT, so you can pass the result to another command (e.g. `pbcopy` or an `open` command).

If a bookmarked file exists in a synced directory that matches the filesystem on another machine, the bookmark will work on the other machine as well.

## System Service

The included wiki_link_service.rb file can be used in a macOS System Service (Quick Action) to allow wiki linking from any application, e.g. `[[my bookmark]]`, where "my bookmark" is an alias created by the `bookmarker` script.

To create a System Service:

1. Open Automator and create a new Quick Action. You can leave all the settings at their default.
2. Add a `Run shell script` action to the service
3. Set the interpreter to `/usr/bin/ruby`
4. Paste the contents of `wiki_link_service` to the Run Shell Script action
5. Save the Service as "Open Wiki Link"

Now you can select text containing a `[[wiki link]]` that references a bookmarked file, right click, and select Services->Open Wiki Link. The bookmarked file will be opened in its default application.