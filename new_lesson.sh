#!/bin/bash
LESSON_NAME="$1"
mkdir -p "$LESSON_NAME"/{docs,files,screenshots}
touch "$LESSON_NAME"/{README.md,report.md}
echo "# Урок $LESSON_NAME" > "$LESSON_NAME/README.md" 
echo "# Отчёт по уроку $LESSON_NAME" > "$LESSON_NAME/report.md"
echo "Урок 'LESSON_NAME' создан!"