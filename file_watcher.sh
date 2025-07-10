#!/bin/bash
fswatch -r "/path/to/monitor" | while read file_event; do
    logger -t file_watcher "$file_event"
done
