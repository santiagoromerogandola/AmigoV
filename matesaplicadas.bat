@echo off
setlocal EnableDelayedExpansion
title ENTRENAMIENTO PRO - El Chef V
mode con: cols=125 lines=55
chcp 65001 >nul

:bloqueo
cls
echo.
echo  [ SISTEMA PROTEGIDO ]
echo.
set /p "combo=Introduzca combinacion AFS para entrar: "
if /i "%combo%"=="AFS" ( goto inicializar ) else ( exit )

:inicializar
set "CUENTO_FILE=%TEMP%\cuento_v.txt"
set "PROGRESO_FILE=%AppData%\mi_progreso_v.txt"
set "PS_DISPLAY=%TEMP%\display_v.ps1"
set "PS_LOGIC=%TEMP%\logic_v.ps1"

:: Crear el cuento original
(
echo El Gran Chef V
echo.
echo Esta es la historia de mi amigo V, un chico muy divertido que un día decidió que era un chef profesional porque vio un video en internet. Invitó a toda la clase a cenar a su casa diciendo que prepararía una pasta especial con una receta secreta de su abuela. Estaba muy emocionado y hasta se puso un gorro de cocina gigante que le tapaba casi los ojos.
echo.
echo Al llegar a su casa, el pobre V estaba en un lío total. Se distrajo hablando por el móvil y la pasta se convirtió en un bloque compacto de cemento. La salsa estaba tan picante que hasta el gato empezó a estornudar. Yo le dije que no pasaba nada, que se notaba el esfuerzo, pero el tío estaba concentrado intentando despegar la comida de la olla con un martillo.
echo.
echo Pasaron las horas y V seguía en la cocina haciendo ruidos extraños. Al final, apareció con una sonrisa y nos dijo que la receta secreta era en realidad pedir pizza por teléfono. Mi colega es un personaje, pero siempre nos hace reír. Al final cenamos pizza fría, pero fue la mejor noche de risas en mucho tiempo. Ahora ya no dice que es chef, ahora dice que es crítico de comida a domicilio.
) > "%CUENTO_FILE%"

:: Crear progreso inicial si no existe
if not exist "%PROGRESO_FILE%" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$t = Get-Content -Path '%CUENTO_FILE%' -Raw -Encoding UTF8; $res = ''; foreach ($c in $t.ToCharArray()) { if ($c -match '[a-zA-ZÁÉÍÓÚñÑáéíóú]') { $res += '_' } else { $res += $c } }; $res | Out-File -FilePath '%PROGRESO_FILE%' -Encoding UTF8"
)

:menu
cls
echo ========================================================================================================================
echo                                     SISTEMA DE MEMORIA - El Chef V (Version Blindada)
echo ========================================================================================================================
echo.
:: Crear script de visualizacion
(
echo $orig = Get-Content -Path '%CUENTO_FILE%' -Raw -Encoding UTF8
echo $prog = Get-Content -Path '%PROGRESO_FILE%' -Raw -Encoding UTF8
echo $res = ""
echo for ($i=0; $i -lt $orig.Length; $i++) {
echo   $c = $orig[$i]; $p = $prog[$i]
echo   if ($c -match '[^a-zA-ZÁÉÍÓÚñÑáéíóú]') { $res += $c }
echo   elseif ($p -ne '_') { $res += $c }
echo   elseif ((Get-Random -Max 100) -lt 15) { $res += $c }
echo   else { $res += '_' }
echo }
echo Write-Host $res -ForegroundColor Cyan
) > "%PS_DISPLAY%"
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_DISPLAY%"

echo.
echo ========================================================================================================================
echo  [R] Refrescar Pistas   [E] ESCRIBIR (Guarda con __)   [V] VER TODO   [X] RESET (3696)   [S] Salir
echo ========================================================================================================================
set /p opt="Selecciona opcion: "
if /i "%opt%"=="R" goto menu
if /i "%opt%"=="E" goto modo_escritura
if /i "%opt%"=="V" goto verificar_pass
if /i "%opt%"=="X" goto verificar_reset
if /i "%opt%"=="S" exit
goto menu

:verificar_reset
set /p "rpass=Clave 3696: "
if "%rpass%"=="3696" ( del "%PROGRESO_FILE%" & goto inicializar )
goto menu

:verificar_pass
set /p "vpass=Introduce la clave secreta para revelar: "
if "%vpass%"=="Gratrok" ( cls & type "%CUENTO_FILE%" & echo. & pause & goto menu ) else ( echo Clave incorrecta. & timeout /t 2 >nul & goto menu )

:modo_escritura
cls
echo ========================================================================================================================
echo                                     MODO ESCRITURA - CORRECCION Y DESBLOQUEO
echo ========================================================================================================================
echo Escribe palabras o frases. Para terminar y guardar escribe __ y pulsa ENTER.
echo.
(
echo function Norm($s) { return $s.ToLower().Normalize([Text.NormalizationForm]::FormD) -replace '\p{M}' }
echo $origFull = Get-Content -Path '%CUENTO_FILE%' -Raw -Encoding UTF8
echo $origNorm = Norm($origFull)
echo $inputLines = @()
echo while($true) { $l = Read-Host ' > '; if ($l.Trim() -eq '__') { break }; if ($l.Contains('__')) { $inputLines += $l.Replace('__',''); break }; $inputLines += $l }
echo $userRawText = $inputLines -join ' '
echo $progArr = (Get-Content -Path '%PROGRESO_FILE%' -Raw -Encoding UTF8).ToCharArray()
echo Write-Host "`n--- CORRECCION ---" -ForegroundColor White
echo $words = $userRawText.Split(' ', [StringSplitOptions]::RemoveEmptyEntries)
echo foreach ($wRaw in $words) {
echo   $w = Norm($wRaw)
echo   if ($origNorm.Contains($w)) {
echo     Write-Host ($wRaw + ' ') -NoNewline -ForegroundColor Green
echo     $idx = 0; while (($idx = $origNorm.IndexOf($w, $idx)) -ne -1) {
echo       for ($j=0; $j -lt $w.Length; $j++) { $progArr[$idx + $j] = $origFull[$idx + $j] }
echo       $idx += $w.Length
echo     }
echo   } else { Write-Host ($wRaw + ' ') -NoNewline -ForegroundColor Red }
echo }
echo (-join $progArr) ^| Out-File -FilePath '%PROGRESO_FILE%' -Encoding UTF8
echo Write-Host "`n`n[!] PROGRESO GUARDADO." -ForegroundColor Cyan
) > "%PS_LOGIC%"
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_LOGIC%"
echo.
pause
goto menu
