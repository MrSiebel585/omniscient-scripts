#!/usr/bin/env python3

import os

def get_folder_size(folder):
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(folder):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            total_size += os.path.getsize(fp)
    return total_size

def get_largest_folders(path, num=10):
    folders = []
    for dirpath, dirnames, filenames in os.walk(path):
        folders.append((dirpath, get_folder_size(dirpath)))
    folders.sort(key=lambda x: x[1], reverse=True)
    return folders[:num]

log_file = open("largest_folders.log", "w")
for folder in get_largest_folders("/path/to/directory", num=10):
    log_file.write(f"{folder[0]}: {folder[1]} bytes\n")
log_file.close()

