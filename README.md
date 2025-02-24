# bookmarker

[bookmark-cli]: https://github.com/ttscoff/bookmark-cli

This script is designed to work with [bookmark-cli]. It creates a JSON reference file allowing for short bookmark names.

The included wiki_link_service.rb file can be used in a macOS System Service (Quick Action) to allow wiki linking from any application, e.g. `[[my bookmark]]`, where "my bookmark" is an alias created by the `bookmarker` script.

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