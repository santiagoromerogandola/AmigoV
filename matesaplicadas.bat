@echo off
setlocal EnableDelayedExpansion
title ENTRENAMIENTO PRO - El Gran Chef V
mode con: cols=125 lines=55
:: Esto evita que el programa se cierre por errores de acentos
chcp 65001 >nul

:bloqueo
cls
echo.
echo  [ SISTEMA PROTEGIDO ]
echo.
echo Para entrar, escribe la combinacion de 3 letras:
set /p "combo=> "
if /i "%combo%"=="AFS" (
    goto inicializar
) else (
    echo Combinacion incorrecta. Saliendo...
    timeout /t 3
    exit
)

:inicializar
set "CUENTO_FILE=%TEMP%\cuento_v.txt"
set "PROGRESO_FILE=%AppData%\mi_progreso_v.txt"
set "LOG_ESCRITURA=%AppData%\mi_practica_v.txt"

:: Crear el cuento original usando un metodo que no falla con parentesis
powershell -NoProfile -ExecutionPolicy Bypass -Command "$c = @' " ^
"El Gran Chef V" ^
" " ^
"Esta es la historia de mi amigo V, un chico muy divertido que un día decidió que era un chef profesional porque vio un video en internet. Invitó a toda la clase a cenar a su casa diciendo que prepararía una pasta especial con una receta secreta de su abuela. Estaba muy emocionado y hasta se puso un gorro de cocina gigante que le tapaba casi los ojos." ^
" " ^
"Al llegar a su casa, el pobre V estaba en un lío total. Se distrajo hablando por el móvil y la pasta se convirtió en un bloque compacto de cemento. La salsa estaba tan picante que hasta el gato empezó a estornudar. Yo le dije que no pasaba nada, que se notaba el esfuerzo, pero el tío estaba concentrado intentando despegar la comida de la olla con un martillo." ^
" " ^
"Pasaron las horas y V seguía en la cocina haciendo ruidos extraños. Al final, apareció con una sonrisa y nos dijo que la receta secreta era en realidad pedir pizza por teléfono. Mi colega es un personaje, pero siempre nos hace reír. Al final cenamos pizza fría, pero fue la mejor noche de risas en mucho tiempo. Ahora ya no dice que es chef, ahora dice que es crítico de comida a domicilio." ^
"'@; $c | Out-File -FilePath '%CUENTO_FILE%' -Encoding UTF8"

:: Crear progreso inicial si no existe
if not exist "%PROGRESO_FILE%" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$t = Get-Content -Path '%CUENTO_FILE%' -Raw -Encoding UTF8; $res = ''; foreach ($c in $t.ToCharArray()) { if ($c -match '[a-zA-ZÁÉÍÓÚñÑáéíóú]') { $res += '_' } else { $res += $c } }; $res | Out-File -FilePath '%PROGRESO_FILE%' -Encoding UTF8"
)

:menu
cls
echo ========================================================================================================================
echo                                     SISTEMA DE MEMORIA - El Chef V (Version PRO)
echo ========================================================================================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$orig = Get-Content -Path '%CUENTO_FILE%' -Raw -Encoding UTF8; " ^
    "$prog = Get-Content -Path '%PROGRESO_FILE%' -Raw -Encoding UTF8; " ^
    "$res = ''; " ^
    "for ($i=0; $i -lt $orig.Length; $i++) { " ^
    "  $c = $orig[$i]; $p = $prog[$i]; " ^
    "  if ($c -match '[^a-zA-ZÁÉÍÓÚñÑáéíóú]') { $res += $c } " ^
    "  elseif ($p -ne '_') { $res += $c } " ^
    "  elseif ((Get-Random -Max 100) -lt 15) { $res += $c } " ^
    "  else { $res += '_' } " ^
    "}; " ^
    "Write-Host $res -ForegroundColor Cyan"
echo.
echo ========================================================================================================================
echo  [R] Refrescar Pistas   [E] ESCRIBIR (Guarda con __)   [V] VER TODO (Gratrok)   [X] RESET (3696)
echo ========================================================================================================================
set /p opt="Selecciona opcion: "

if /i "%opt%"=="R" goto menu
if /i "%opt%"=="E" goto modo_escritura
if /i "%opt%"=="V" goto verificar_pass
if /i "%opt%"=="X" goto verificar_reset
if /i "%opt%"=="S" exit
goto menu

:verificar_reset
echo.
set /p "rpass=Introduce la clave MAESTRA para resetear: "
if "%rpass%"=="3696" (
    del "%PROGRESO_FILE%"
    goto inicializar
) else (
    echo Incorrecto. & pause & goto menu
)

:verificar_pass
echo.
set /p "vpass=Introduce la clave para revelar: "
if "%vpass%"=="Gratrok" (
    cls & type "%CUENTO_FILE%" & echo. & pause & goto menu
) else (
    echo Incorrecto. & timeout /t 2 >nul & goto menu
)

:modo_escritura
cls
echo ========================================================================================================================
echo                                     MODO ESCRITURA - CORRECCION Y DESBLOQUEO
echo ========================================================================================================================
echo Instrucciones: Escribe palabras o frases. No importa si olvidas los acentos.
echo [!] PARA FINALIZAR Y GUARDAR: Escribe __ y pulsa ENTER.
echo.
echo ------------------------------------------------------------------------------------------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "function Norm($s) { return $s.ToLower().Normalize([Text.NormalizationForm]::FormD) -replace '\p{M}' } " ^
    "$origFull = Get-Content -Path '%CUENTO_FILE%' -Raw -Encoding UTF8; " ^
    "$origNorm = Norm($origFull); " ^
    "$inputLines = @(); " ^
    "while($true) { " ^
    "  $l = Read-Host ' > '; " ^
    "  if ($l.Trim() -eq '__') { break }; " ^
    "  if ($l.Contains('__')) { $inputLines += $l.Replace('__',''); break }; " ^
    "  $inputLines += $l; " ^
    "} " ^
    "$userRawText = $inputLines -join ' '; " ^
    "$userRawText | Out-File -FilePath '%LOG_ESCRITURA%' -Encoding UTF8; " ^
    "Write-Host '`n--- CORRECCION (Verde=Bien / Rojo=Mal) ---' -ForegroundColor White; " ^
    "$progArr = (Get-Content -Path '%PROGRESO_FILE%' -Raw -Encoding UTF8).ToCharArray(); " ^
    "$words = $userRawText.Split(' ', [StringSplitOptions]::RemoveEmptyEntries); " ^
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
    "Write-Host '`n`n[!] PROGRESO ACTUALIZADO CON ÉXITO.' -ForegroundColor Cyan;"

echo.
pause
goto menu
