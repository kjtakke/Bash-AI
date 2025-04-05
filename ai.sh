#!/bin/bash

AI_URL="http://localhost:5001"

function ask_question() {
  QUESTION=$(gum input --placeholder "Ask me anything..." --prompt.foreground "#00FFFF")
  [[ -z "$QUESTION" ]] && exit 0

  RESPONSE=$(curl -s -X POST "$AI_URL/ask" \
    -H "Content-Type: application/json" \
    -d "{\"question\": \"$QUESTION\"}")
  # clear
  echo "$RESPONSE" | batcat --language=md --style=plain --paging=never
}

function clear_chat() {
  RESPONSE=$(curl -s -X POST "$AI_URL/clear_assistant")
  # clear
  echo "Chat Thread Cleared" | batcat --language=md --style=plain --paging=never
}


if [[ "$1" == "--clear" ]]; then
  clear_chat
else
  ask_question
fi
