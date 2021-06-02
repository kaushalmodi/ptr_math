task pullConfig, "Fetch my global config.nims":
  exec("git submodule add -f -b master https://github.com/kaushalmodi/nim_config")
when fileExists("nim_config/config.nims"):
  include "nim_config/config.nims" # This gives "nim test" and "nim docs" that's run on Travis

when getCommand() == "doc":
  # https://github.com/nim-lang/Nim/issues/18157#issuecomment-853317509
  # Export the documentation of the unexported internal templates
  # defined inside ptrMath as well.
  switch("docInternal", "on")
