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

# Command-line argument handling
case "$1" in
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
