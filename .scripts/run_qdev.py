#!/usr/bin/env python3
import sys
import subprocess

command = [line for line in sys.stdin if line.strip()]

if command:
    command = command[0]
else:
    sys.exit(0)

args = [piece for piece in command.split(" ") if not (piece.startswith('-') or piece.startswith('[') or piece.startswith('<'))]

args.insert(1, '--interactive')

print(args)

subprocess.run(args, shell=True)

