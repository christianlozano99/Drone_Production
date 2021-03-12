# does the quickest output of brew --prefix possible for the basic cases:
# - `brew --prefix` (output HOMEBREW_PREFIX)
# - `brew --prefix <formula>` (output HOMEBREW_PREFIX/opt/<formula>)
# anything else? delegate to the slower cmd/--prefix.rb

homebrew-prefix() {
  while [[ "$#" -gt 0 ]]; do
      case $1 in
          # check we actually have --prefix and not e.g. --prefixsomething
          --prefix) local prefix="1"; shift ;;
          # reject all other flags
          -*) return 1 ;;
          *) [ -n "$formula" ] && return 1; local formula="$1"; shift ;;
      esac
  done
  [ -z "$prefix" ] && return 1
  [ -z "$formula" ] && echo "$HOMEBREW_PREFIX" && return 0

  local formula_path
  if [ -f "$HOMEBREW_REPOSITORY/Library/Taps/homebrew/homebrew-core/${formula}.rb" ]; then
    formula_path="$HOMEBREW_REPOSITORY/Library/Taps/homebrew/homebrew-core/${formula}.rb"
  else
    formula_path="$(find "$HOMEBREW_REPOSITORY/Library/Taps" -name "${formula}.rb" -print -quit)"
  fi
  [ -z "$formula_path" ] && return 1

  echo "$HOMEBREW_PREFIX/opt/$formula"
  return 0
}
