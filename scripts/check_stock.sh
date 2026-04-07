#!/bin/bash

echo "Checking $WEB_URL for '$SEARCH_STRING'..."

# Fetch the page content
# -s: Silent mode (hides progress bar)
# -L: Follow redirects
CONTENT=$(curl -sL "$WEB_URL")

# Check if the substring exists in the content
if [[ "$CONTENT" == *"$SEARCH_STRING"* ]]; then
    echo "Match found! Sending POST request..."

    # Safely construct the JSON payload
    PAYLOAD=$(printf '{"text":"%s: %s"}' "$WEB_URL" "$SEARCH_STRING")

    curl -X POST "$SLACK_URL" \
         -H "Content-Type: application/json" \
         --data "$PAYLOAD" \
         -s -o /dev/null -w "Response Code: %{http_code}\n"
else
    echo "Substring not found. No action taken."
fi
