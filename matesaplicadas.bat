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

:: Crear el cuento usando un metodo que no usa parentesis en Batch
powershell -NoProfile -Command "$c = 'El Gran Chef V\n\nEsta es la historia de mi amigo V, un chico muy divertido que un día decidió que era un chef profesional porque vio un video en internet. Invitó a toda la clase a cenar a su casa diciendo que prepararía una pasta especial con una receta secreta de su abuela. Estaba muy emocionado y hasta se puso un gorro de cocina gigante que le tapaba casi los ojos.\n\nAl llegar a su casa, el pobre V estaba en un lío total. Se distrajo hablando por el móvil y la pasta se convirtió en un bloque compacto de cemento. La salsa estaba tan picante que hasta el gato empezó a estornudar. Yo le dije que no pasaba nada, que se notaba el esfuerzo, pero el tío estaba concentrado intentando despegar la comida de la olla con un martillo.\n\nPasaron las horas y V seguía en la cocina haciendo ruidos extraños. Al final, apareció con una sonrisa y nos dijo que la receta secreta era en realidad pedir pizza por teléfono. Mi colega es un personaje, pero siempre nos hace reír. Al final cenamos pizza fría, pero fue la mejor noche de risas en mucho tiempo. Ahora ya no dice que es chef, ahora dice que es crítico de comida a domicilio.'; [IO.File]::WriteAllText('%CUENTO_FILE%', $c)"

:: Crear progreso inicial si no existe
if not exist "%PROGRESO_FILE%" powershell -NoProfile -Command "$t=[IO.File]::ReadAllText('%CUENTO_FILE%'); $res=''; foreach($c in $t.ToCharArray()){if($c -match '[a-zA-ZÁÉÍÓÚñÑáéíóú]'){$res+='_'}else{$res+=$c}}; [IO.File]::WriteAllText('%PROGRESO_FILE%',$res)"

:menu
cls
echo ========================================================================================================================
echo                                     SISTEMA DE MEMORIA - El Chef V (Version Blindada)
echo ========================================================================================================================
echo.
:: Mostrar progreso con colores (Comando de una sola linea)
powershell -NoProfile -Command "$o=[IO.File]::ReadAllText('%CUENTO_FILE%'); $p=[IO.File]::ReadAllText('%PROGRESO_FILE%'); $r=''; for($i=0;$i -lt $o.Length;$i++){ $c=$o[$i]; $k=$p[$i]; if($c -match '[^a-zA-ZÁÉÍÓÚñÑáéíóú]'){$r+=$c} elseif($k -ne '_'){$r+=$c} elseif((Get-Random -Max 100) -lt 15){$r+=$c} else{$r+='_'} }; Write-Host $r -ForegroundColor Cyan"
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
if "%rpass%"=="3696" del "%PROGRESO_FILE%" & goto inicializar
goto menu

:verificar_pass
set /p "vpass=Introduce la clave secreta para revelar: "
if "%vpass%"=="Gratrok" ( cls & type "%CUENTO_FILE%" & echo. & pause & goto menu ) else ( echo Clave incorrecta. & timeout /t 2 >nul & goto menu )

:modo_escritura
cls
echo ========================================================================================================================
echo                                     MODO ESCRITURA - CORRECCIÓN POR PALABRAS
echo ========================================================================================================================
echo Escribe palabras o frases. Verde=Bien / Rojo=Mal. Para terminar escribe __ y pulsa ENTER.
echo.
:: Motor de correccion y desbloqueo (Comando de una sola linea ultra-potente)
powershell -NoProfile -Command "function N($s){$s.ToLower().Normalize([Text.NormalizationForm]::FormD) -replace '\p{M}'}; $o=[IO.File]::ReadAllText('%CUENTO_FILE%'); $on=N($o); $lines=@(); while($true){$l=Read-Host ' > '; if($l.Trim() -eq '__'){break} $lines+=$l}; $u=$lines -join ' '; $un=N($u); $p=[IO.File]::ReadAllText('%PROGRESO_FILE%').ToCharArray(); Write-Host '`n--- CORRECCION ---' -F White; $words=$u.Split(' ',[StringSplitOptions]::RemoveEmptyEntries); foreach($wRaw in $words){ $w=N($wRaw); if($on.Contains($w)){ Write-Host ($wRaw+' ') -NoNewline -F Green; $idx=0; while(($idx=$on.IndexOf($w,$idx)) -ne -1){ for($j=0;$j -lt $w.Length;$j++){$p[$idx+$j]=$o[$idx+$j]} $idx+=$w.Length } } else { Write-Host ($wRaw+' ') -NoNewline -F Red } }; [IO.File]::WriteAllText('%PROGRESO_FILE%',(-join $p)); Write-Host '`n`n[!] PROGRESO GUARDADO.' -F Cyan"
echo.
pause
goto menu
