#!/usr/bin/env bash

set -eo pipefail

export GUM_CHOOSE_HEADER_FOREGROUND="#76946A"
export GUM_CHOOSE_CURSOR_FOREGROUND="#76946A"
export GUM_CHOOSE_ITEM_FOREGROUND="#2A2A2A"

echo

cd "$(dirname "$0")" || exit 1

awk '{print "\033[32m" $0 "\033[0m"}' ./utils/ascii-art.txt

cd ..

npm install

build() {
  npm run build
}

run() {
  npm run run
}

format() {
  npm run format
}

lint() {
  npm run lint
}

dev() {
  npm run dev
}

help() {
  echo
  echo -e "\033[32mUSAGE\033[0m"
  echo "    $0 [OPTIONS]"
  echo -e "\033[32mDESCRIPTION\033[0m"
  echo "    Build, run, format, line and manage DL from a single script."
  echo
  echo -e "\033[32mOPTIONS\033[0m"
  echo "    -b,--build         Build the program"
  echo "    -r,--run           Run the program"
  echo "    -B,--build-run     Build and run the program"
  echo "    -f,--format        Format the program"
  echo "    -l,--lint          Lint the program"
  echo "    -F,--format-lint   Format and lint the program"
  echo "    -a,--all           Format, lint, build and run the program"
  echo "    -h,--help          Show this help message"
  echo

  exit 0
}

if [ -z "$1" ]; then
  echo
else
  case "$1" in
  "-b" | "--build")
    build
    echo

    exit 0
    ;;
  "-r" | "--run")
    run
    echo

    exit 0
    ;;
  "-B" | "--build-run")
    build
    run
    echo

    exit 0
    ;;
  "-f" | "--format")
    format
    echo

    exit 0
    ;;
  "-l" | "--lint")
    lint
    echo

    exit 0
    ;;
  "-F" | "--format-lint")
    format
    lint
    echo

    exit 0
    ;;
  "-a" | "--all")
    format
    lint
    build
    run

    exit 0
    ;;
  "-h" | "--help")
    help
    ;;
  *)
    echo
    echo -e "\033[32mInvalid option:\033[0m $1"
    help
    ;;
  esac
fi

if command -v gum >/dev/null 2>&1; then
  SELECTION=$(
    gum choose \
      --header "What do you want to do?" \
      --height 9 \
      "Build" "Run" "Build and run" "Format" "Lint" "Format and lint" "All" "Quit" "Help"
  )

  case "$SELECTION" in
  "Build")
    echo

    build
    ;;
  "Run")
    run
    ;;
  "Build and run")
    build
    run
    ;;
  "Format")
    format
    ;;
  "Lint")
    lint
    ;;
  "Format and lint")
    format
    lint
    ;;
  "All")
    format
    lint
    build
    run
    ;;
  "Quit")
    exit 0
    ;;
  "Help")
    help
    ;;
  esac
else
  echo

  PS3="What do you want to do? "
  options=(
    "Build" "Run" "Build and run" "Format" "Lint" "Format and lint" "All" "Quit" "Help"
  )

  select opt in "${options[@]}"; do
    case "$opt" in
    "Build")
      echo

      build
      ;;
    "Run")
      run
      ;;
    "Build and run")
      build
      run
      ;;
    "Format")
      format
      ;;
    "Lint")
      lint
      ;;
    "Format and lint")
      format
      lint
      ;;
    "All")
      format
      lint
      build
      run
      ;;
    "Quit")
      exit 0
      ;;
    "Help")
      help
      ;;
    *)
      echo "invalid option $REPLY"
      help
      ;;
    esac
  done
fi
