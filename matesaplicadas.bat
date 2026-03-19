<# :
@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((Get-Content '%~f0' -Raw) -replace '^<# :','')"
exit /b
#>

# --- CONFIGURACIÓN DEL JUEGO (POWERSHELL) ---
$CUENTO_PATH = "$env:TEMP\cuento_v_final.txt"
$PROGRESO_PATH = "$env:APPDATA\progreso_v_save.txt"

# 1. Definir el cuento original (Aquí no importa si hay paréntesis o acentos)
$CuentoOriginal = @'
El Gran Chef V

Esta es la historia de mi amigo V, un chico muy divertido que un día decidió que era un chef profesional porque vio un video en internet. Invitó a toda la clase a cenar a su casa diciendo que prepararía una pasta especial con una receta secreta de su abuela. Estaba muy emocionado y hasta se puso un gorro de cocina gigante que le tapaba casi los ojos.

Al llegar a su casa, el pobre V estaba en un lío total. Se distrajo hablando por el móvil y la pasta se convirtió en un bloque compacto de cemento. La salsa estaba tan picante que hasta el gato empezó a estornudar. Yo le dije que no pasaba nada, que se notaba el esfuerzo, pero el tío estaba concentrado intentando despegar la comida de la olla con un martillo.

Pasaron las horas y V seguía en la cocina haciendo ruidos extraños. Al final, apareció con una sonrisa y nos dijo que la receta secreta era en realidad pedir pizza por teléfono. Mi colega es un personaje, pero siempre nos hace reír. Al final cenamos pizza fría, pero fue la mejor noche de risas en mucho tiempo. Ahora ya no dice que es chef, ahora dice que es crítico de comida a domicilio.
'@

# Crear el archivo del cuento
$CuentoOriginal | Out-File -FilePath $CUENTO_PATH -Encoding UTF8 -Force

# --- FUNCIÓN DE NORMALIZACIÓN (PARA IGNORAR ACENTOS) ---
function Normalizar($s) {
    if (!$s) { return "" }
    $s = $s.ToLower().Normalize([System.Text.NormalizationForm]::FormD)
    $sb = New-Object System.Text.StringBuilder
    foreach ($c in $s.ToCharArray()) {
        if ([System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($c) -ne [System.Globalization.UnicodeCategory]::NonSpacingMark) {
            [void]$sb.Append($c)
        }
    }
    return $sb.ToString()
}

# --- SEGURIDAD INICIAL ---
Clear-Host
Write-Host "`n [ SISTEMA PROTEGIDO ]`n" -ForegroundColor Yellow
$combo = Read-Host "Introduzca combinación AFS para entrar"
if ($combo -ne "AFS") { Write-Host "Acceso Denegado"; Start-Sleep -s 2; exit }

# --- INICIALIZAR PROGRESO ---
if (!(Test-Path $PROGRESO_PATH)) {
    $res = ""
    foreach ($c in $CuentoOriginal.ToCharArray()) {
        if ($c -match '[a-zA-ZÁÉÍÓÚñÑáéíóú]') { $res += "_" } else { $res += $c }
    }
    $res | Out-File -FilePath $PROGRESO_PATH -Encoding UTF8
}

# --- MENÚ PRINCIPAL ---
while ($true) {
    Clear-Host
    Write-Host "===================================================================================================="
    Write-Host "                          SISTEMA DE ENTRENAMIENTO - El Chef V (Versión Híbrida)"
    Write-Host "====================================================================================================`n"

    $orig = Get-Content -Path $CUENTO_PATH -Raw -Encoding UTF8
    $prog = Get-Content -Path $PROGRESO_PATH -Raw -Encoding UTF8
    $display = ""

    for ($i=0; $i -lt $orig.Length; $i++) {
        $c = $orig[$i]; $p = $prog[$i]
        if ($c -match '[^a-zA-ZÁÉÍÓÚñÑáéíóú]') { $display += $c }
        elseif ($p -ne "_") { $display += $c }
        elseif ((Get-Random -Max 100) -lt 15) { $display += $c }
        else { $display += "_" }
    }
    Write-Host $display -ForegroundColor Cyan

    Write-Host "`n===================================================================================================="
    Write-Host " [R] Refrescar Pistas   [E] ESCRIBIR (Guarda con __)   [V] VER TODO   [X] RESET   [S] Salir"
    Write-Host "===================================================================================================="
    $opt = (Read-Host "Selecciona opción").ToUpper()

    if ($opt -eq "R") { continue }
    if ($opt -eq "S") { exit }
    
    if ($opt -eq "X") {
        $pass = Read-Host "Introduce clave para RESET (3696)"
        if ($pass -eq "3696") { Remove-Item $PROGRESO_PATH; Write-Host "Progreso borrado"; Start-Sleep -s 1; return }
    }

    if ($opt -eq "V") {
        $pass = Read-Host "Introduce clave para REVELAR (Gratrok)"
        if ($pass -eq "Gratrok") { Clear-Host; Write-Host $orig; pause }
    }

    if ($opt -eq "E") {
        Clear-Host
        Write-Host "MODO ESCRITURA - Escribe palabras o frases. Para finalizar escribe __ y pulsa ENTER.`n" -ForegroundColor Yellow
        $inputLines = @()
        while($true) {
            $l = Read-Host " > "
            if ($l.Trim() -eq "__") { break }
            $inputLines += $l
        }
        $userText = $inputLines -join " "
        $userNorm = Normalizar($userText)
        $origNorm = Normalizar($orig)
        $progArr = (Get-Content -Path $PROGRESO_PATH -Raw -Encoding UTF8).ToCharArray()
        
        $words = $userNorm.Split(" `t,.!?;:".ToCharArray(), [StringSplitOptions]::RemoveEmptyEntries)
        foreach ($w in $words) {
            if ($w.Length -gt 0) {
                $idx = 0
                while (($idx = $origNorm.IndexOf($w, $idx)) -ne -1) {
                    for ($j=0; $j -lt $w.Length; $j++) { $progArr[$idx + $j] = $orig[$idx + $j] }
                    $idx += $w.Length
                }
            }
        }
        (-join $progArr) | Out-File -FilePath $PROGRESO_PATH -Encoding UTF8
        Write-Host "`n[!] PROGRESO ACTUALIZADO." -ForegroundColor Green
        Start-Sleep -s 1
    }
}
