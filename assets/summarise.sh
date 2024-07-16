#!/bin/bash

# Script for generating dart types from coins_config.json

OUTPUT_FILE="summary.txt"
CONFIG_FILE="new_coins_config.json"

# Clear the output file
> "$OUTPUT_FILE"

# Retrieve the field names from the JSON file
FIELDS=$(jq -r 'first | keys_unsorted[]' "$CONFIG_FILE")

for field in $FIELDS; do
    echo "Checking field: $field" >> "$OUTPUT_FILE"
    echo "Possible null values:" >> "$OUTPUT_FILE"
    jq 'map(select(.["'"$field"'"] == null)) | length' "$CONFIG_FILE" >> "$OUTPUT_FILE"
    echo "Possible enum values:" >> "$OUTPUT_FILE"
    jq --arg f "$field" "[.[] | .[\$f]] | group_by(.)[] | select(length > 1) | { value: .[0], count: length, percentage: (length / (lengths | add)) * 100 } | sort_by(-.count)" "$CONFIG_FILE" >> "$OUTPUT_FILE"
    echo "Unique values:" >> "$OUTPUT_FILE"
    jq --arg f "$field" '[.[] | .[$f]] | unique | length' "$CONFIG_FILE" >> "$OUTPUT_FILE"
    echo "-------" >> "$OUTPUT_FILE"
done