#!/bin/bash
# Format all example SQL files using VS Code command line

for file in examples/0*.sql; do
  echo "Formatting $file..."
  # We'll manually format these in VS Code
done

echo "Done! Open each file in VS Code and run Format Document (Shift+Option+F)"
