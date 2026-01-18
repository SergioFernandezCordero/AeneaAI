#!/usr/bin/env bash

# Start Ollama backgrounded
echo "## Run Ollama server"
/opt/aenea/ai/server/bin/ollama serve &

# Wait until port is ready
echo "## Waiting for Ollama to start"
retry_counter=0
while ! netstat -tna | grep 'LISTEN\>' | grep -q ':11434\>'; do
  ((++retry_counter))
  if (( retry_counter > 1 && retry_counter < 5)); then
    echo "## Not ready. Retry $retry_counter"
  elif (( retry_counter >= 5 )); then
    echo "## Ollama not ready. Killing al processes"
    killall ollama
    exit 1
  fi
  sleep 2
done

# Create Aenea model
echo "## Creating Aenea model"
/opt/aenea/ai/server/bin/ollama create aenea -f /opt/aenea/ai/model/Aenea.Modelfile || exit 2

# Run Aenea model
echo "## Running Aenea model"
/opt/aenea/ai/server/bin/ollama run aenea || exit 2

# The end
while :
do
	echo "## Enjoy your IA experience!"
	sleep 3600
done
