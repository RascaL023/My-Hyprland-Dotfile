auth() { 
  for i in {1..3}; do
    clear;

    read -p "Password: " pass
    [[ $pass == "atmin123" ]] && return 0

  done
  return 1
}

config=~/.config
dotfile=~/.dotfile
tools_file="$dotfile/tools.list"

tools_reader() {
  while read -r tool; do
    # skip empty line & comment
    [[ -z "$tool" || "$tool" =~ ^# ]] && continue
    printf '%s\n' "$tool"
  done < "$tools_file"
}


staging() {
  while read -r dir; do
    while read -r path; do
      parent=$(dirname "$path")
      linkpath="$parent/$dir"
      target="$dotfile/$dir"

      if [[ -L "$linkpath" ]] &&
         [[ "$(readlink -f "$linkpath")" == "$(readlink -f "$target")" ]]; then
        echo "Skip: $dir already linked"
        continue
      fi

      if [[ -e "$target" ]]; then
        echo "Skip: $target already exists"
        continue
      fi

      echo "Linking $dir"

      mv "$linkpath" "$dotfile/"
      ln -sfn "$target" "$linkpath"

    done < <(find "$config" -type d -name "$dir" -print -quit)
  done < <(tools_reader)
}


restore() {
  while read -r dir; do
    linkpath="$config/$dir"
    realpath="$dotfile/$dir"

    [[ -L "$linkpath" ]] || {
      echo "Skip: $linkpath bukan symlink"
      continue
    }

    echo "Restoring $dir"
    unlink "$linkpath"
    mv "$realpath" "$linkpath"
  done < <(tools_reader)
}


menus() {
  while true; do
    echo "1. Start linkings"
    echo "2. Restore links"
    echo "0. Exit"
    read -p "❯ " inp

    case $inp in
      0)
        echo "Bye.."
        exit
        ;;
      1)
        staging
        ;;
      2)
        restore
        ;;
      *)
        echo "Invalid"
        ;;
    esac
    echo "Done..."
  done
}

if auth; then
  echo "Welcome $(whoami)!"
else
  exit
fi

menus
