# Bash-AI

This shell script provides a simple terminal-based interface for interacting with a local AI service using natural language. It leverages [Gum](https://github.com/charmbracelet/gum) for stylish prompts and `bat`/`batcat` for clean output formatting.

## Features

- Prompt for a question via a stylish terminal input box
    
- Sends the question to a locally running AI API (`http://localhost:5001`)
    
- Formats and displays the AI's response using `batcat`
    
- Optional flag to clear the conversation thread
    

## Requirements

- Linux (x86_64)
    
- [`gum`](https://github.com/charmbracelet/gum)
    
- [`bat`](https://github.com/sharkdp/bat) (sometimes available as `batcat`)
    
- Running local AI API endpoint at `http://localhost:5001`
    

## Installation

```bash
cd /tmp
wget https://github.com/charmbracelet/gum/releases/download/v0.13.0/gum_0.13.0_Linux_x86_64.tar.gz
tar -xvzf gum_0.13.0_Linux_x86_64.tar.gz
sudo mv gum /usr/local/bin/
sudo apt update
sudo apt install bat
```

> Note: On some systems (e.g., Debian/Ubuntu), `bat` is installed as `batcat`.

## Script Setup

Create the script at `/home/bin/ai.sh` and make it executable:

```bash
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

```

`sudo chmod +x /home/bin/ai.sh`
