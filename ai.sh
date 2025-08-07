#!/bin/bash

AI_URL="http://localhost:5001"

function ask_question() {
  QUESTION=$(gum input --placeholder "Ask me anything..." --prompt.foreground "#00FFFF")
  [[ -z "$QUESTION" ]] && exit 0

  RESPONSE=$(curl -s -X POST "$AI_URL/ask" \
    -H "Content-Type: application/json" \
    -d "{\"question\": \"$QUESTION\"}")
  echo "$RESPONSE" | batcat --language=md --style=plain --paging=never
}

function clear_chat() {
  RESPONSE=$(curl -s -X POST "$AI_URL/clear_assistant")
  echo "Chat Thread Cleared" | batcat --language=md --style=plain --paging=never
}

function list_models() {
  RESPONSE=$(curl -s "$AI_URL/list_models")
  echo "$RESPONSE" | batcat --language=md --style=plain --paging=never
}

function change_model() {
  MODEL="$1"
  if [[ -z "$MODEL" ]]; then
    echo "Error: No model specified."
    exit 1
  fi
  RESPONSE=$(curl -s -X POST "$AI_URL/change_model" \
    -H "Content-Type: application/json" \
    -d "{\"model\": \"$MODEL\"}")
  echo "$RESPONSE" | batcat --language=md --style=plain --paging=never
}

function show_help() {
  cat <<EOF | batcat --language=md --style=plain --paging=never
Usage: $(basename "$0") [OPTIONS]

Without options, opens interactive prompt to ask a question.

Options:
  -h, --help             Show this help and exit
  --clear                Clear the current chat thread
  --models               List available models
  --change-model NAME    Change the active model to NAME

Examples:
  $(basename "$0") --models
  $(basename "$0") --change-model llama3.1
  $(basename "$0")
EOF
}

# Command-line argument handling
case "$1" in
  -h|--help)
    show_help
    ;;
  --clear)
    clear_chat
    ;;
  --models)
    list_models
    ;;
  --change-model)
    change_model "$2"
    ;;
  *)
    ask_question
    ;;
esac
