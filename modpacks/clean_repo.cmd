@echo off
git reflog expire --all --expire=now
git gc --prune=now --aggressive
pause