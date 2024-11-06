@echo off

REM This Windows batch script ensures that the source mount points in devcontainer.json exist on the host.

setlocal enableextensions
echo "Ensuring mount points exist..."
if not exist "%USERPROFILE%\.kube" md "%USERPROFILE%\.kube"
if not exist "%USERPROFILE%\.minikube" md "%USERPROFILE%\.minikube"
endlocal
echo "Done."