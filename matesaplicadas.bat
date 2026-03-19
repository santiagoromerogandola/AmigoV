@echo off
setlocal EnableDelayedExpansion
title SISTEMA DE ENTRENAMIENTO PROFESIONAL - Mi amigo V
mode con: cols=125 lines=55
:: Forzar codificación universal para evitar letras raras
chcp 65001 >nul

:bloqueo
cls
echo.
echo  [ SISTEMA PROTEGIDO ]
echo.
set /p "combo=Introduzca combinación AFS para entrar: "
:: Comparación directa sin paréntesis para evitar errores de sintaxis
if /i "%combo%" neq "AFS" exit
goto inicializar

:inicializar
:: Rutas de archivos en carpetas seguras del sistema
set "CUENTO_FILE=%TEMP%\cuento_v_final.txt"
set "PROGRESO_FILE=%AppData%\progreso_v_save.txt"

:: Crear el cuento original usando un método de "Texto en bloque" de PowerShell (El más estable del mundo)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$c = @' " ^
"El Gran Chef V " ^
" " ^
"Esta es la historia de mi amigo V, un chico muy divertido que un día decidió que era un chef profesional porque vio un video en internet. Invitó a toda la clase a cenar a su casa diciendo que prepararía una pasta especial con una receta secreta de su abuela. Estaba muy emocionado y hasta se puso un gorro de cocina gigante que le tapaba casi los ojos. " ^
" " ^
"Al llegar a su casa, el pobre V estaba en un lío total. Se distrajo hablando por el móvil y la pasta se convirtió en un bloque compacto de cemento. La salsa estaba tan picante que hasta el gato empezó a estornudar. Yo le dije que no pasaba nada, que se notaba el esfuerzo, pero el tío estaba concentrado intentando despegar la comida de la olla con un martillo. " ^
" " ^
"Pasaron las horas y V seguía en la cocina haciendo ruidos extraños. Al final, apareció con una sonrisa y nos dijo que la receta secreta era en realidad pedir pizza por teléfono. Mi colega es un personaje, pero siempre nos hace reír. Al final cenamos pizza fría, pero fue la mejor noche de risas en mucho tiempo. Ahora ya no dice que es chef, ahora dice que es crítico de comida a domicilio. " ^
"'@; $c | Out-File -FilePath '%CUENTO_FILE%' -Encoding UTF8"

:: Inicializar progreso si no existe
if exist "%PROGRESO_FILE%" goto menu
powershell -NoProfile -ExecutionPolicy Bypass -Command "$t = Get-Content -Path '%CUENTO_FILE%' -Raw -Encoding UTF8; $res = ''; foreach ($c in $t.ToCharArray()) { if ($c -match '[a-zA-ZÁÉÍÓÚñÑáéíóú]') { $res += '_' } else { $res += $c } }; $res | Out-File -FilePath '%PROGRESO_FILE%' -Encoding UTF8"

:menu
cls
echo ========================================================================================================================
echo                                     SISTEMA DE MEMORIA - El Chef V (Versión Blindada)
echo ========================================================================================================================
echo.
:: Mostrar progreso + pistas aleatorias (15%)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$orig = Get-Content -Path '%CUENTO_FILE%' -Raw -Encoding UTF8; $prog = Get-Content -Path '%PROGRESO_FILE%' -Raw -Encoding UTF8; $res = ''; for ($i=0; $i -lt $orig.Length; $i++) { $c = $orig[$i]; $p = $prog[$i]; if ($c -match '[^a-zA-ZÁÉÍÓÚñÑáéíóú]') { $res += $c } elseif ($p -ne '_') { $res += $c } elseif ((Get-Random -Max 100) -lt 15) { $res += $c } else { $res += '_' } }; Write-Host $res -ForegroundColor Cyan"
echo.
echo ========================================================================================================================
echo  [R] Refrescar Pistas   [E] ESCRIBIR (Guarda con __)   [V] VER TODO   [X] RESET (3696)   [S] Salir
echo ========================================================================================================================
set /p opt="Selecciona opción: "

if /i "%opt%"=="R" goto menu
if /i "%opt%"=="E" goto modo_escritura
if /i "%opt%"=="V" goto verificar_pass
if /i "%opt%"=="X" goto verificar_reset
if /i "%opt%"=="S" exit
goto menu

:verificar_reset
set /p "rpass=Clave Maestra: "
if "%rpass%" neq "3696" goto menu
del "%PROGRESO_FILE%"
goto inicializar

:verificar_pass
set /p "vpass=Contraseña para revelar: "
if "%vpass%" neq "Gratrok" goto menu
cls
echo === TEXTO COMPLETO ===
echo.
type "%CUENTO_FILE%"
echo.
pause
goto menu

:modo_escritura
cls
echo ========================================================================================================================
echo                                     MODO ESCRITURA - CORRECCIÓN POR PALABRAS
echo ========================================================================================================================
echo Escribe lo que recuerdes. Verde=Acierto / Rojo=Error. 
echo [!] PARA FINALIZAR Y GUARDAR: Escribe __ y pulsa ENTER.
echo.
echo ------------------------------------------------------------------------------------------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "function Norm($s) { return $s.ToLower().Normalize([System.Text.Encoding]::UTF8.EncodingName).Normalize([Text.NormalizationForm]::FormD) -replace '\p{M}' } " ^
    "$origFull = Get-Content -Path '%CUENTO_FILE%' -Raw -Encoding UTF8; " ^
    "$origNorm = Norm($origFull); " ^
    "$inputLines = @(); " ^
    "while($true) { $l = Read-Host ' > '; if ($l.Trim() -eq '__') { break }; $inputLines += $l } " ^
    "$userRaw = $inputLines -join ' '; " ^
    "$progArr = (Get-Content -Path '%PROGRESO_FILE%' -Raw -Encoding UTF8).ToCharArray(); " ^
    "Write-Host '`n--- CORRECCIÓN ---' -ForegroundColor White; " ^
    "$words = $userRaw.Split(' ', [StringSplitOptions]::RemoveEmptyEntries); " ^
    "foreach ($wRaw in $words) { " ^
    "    $w = Norm($wRaw); " ^
    "    if ($origNorm.Contains($w)) { " ^
    "        Write-Host ($wRaw + ' ') -NoNewline -ForegroundColor Green; " ^
    "        $idx = 0; while (($idx = $origNorm.IndexOf($w, $idx)) -ne -1) { " ^
    "            for ($j=0; $j -lt $w.Length; $j++) { $progArr[$idx + $j] = $origFull[$idx + $j] }; " ^
    "            $idx += $w.Length " ^
    "        } " ^
    "    } else { Write-Host ($wRaw + ' ') -NoNewline -ForegroundColor Red } " ^
    "} " ^
    "(-join $progArr) | Out-File -FilePath '%PROGRESO_FILE%' -Encoding UTF8; " ^
    "Write-Host '`n`n[!] PROGRESO GUARDADO CON ÉXITO.' -ForegroundColor Cyan"

echo.
pause
goto menu
