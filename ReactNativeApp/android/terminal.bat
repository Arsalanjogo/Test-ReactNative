:rerun
adb reverse tcp:8081 tcp:8081
call "npx-start.bat"
goto rerun