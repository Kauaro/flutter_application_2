@echo off
echo Executando Flutter App...
cd /d "%~dp0"

echo Verificando se a porta 8080 está livre...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080') do (
    echo Matando processo %%a que está usando a porta 8080...
    taskkill /PID %%a /F >nul 2>&1
)

echo Baixando dependências...
.\flutter\bin\flutter.bat pub get

echo Iniciando servidor Flutter na porta 8080...
.\flutter\bin\flutter.bat run -d chrome --web-port=8080

pause
