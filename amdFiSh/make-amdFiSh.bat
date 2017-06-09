@echo off
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "datestamp=%YY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%" & set "fullstamp=%YYYY%-%MM%-%DD%_%HH%%Min%%Sec%"

REM OS Windows
"fasm.exe" "amdFish64_base.asm"      -m 50000 "Windows\amdFish64_BASE_%datestamp%.exe"
"fasm.exe" "amdFish64_popcnt.asm"    -m 50000 "Windows\amdFish64_POP_%datestamp%.exe"
"fasm.exe" "amdFish64_bmi2.asm"      -m 50000 "Windows\amdFish64_BMI2_%datestamp%.exe"

REM OS Linux
"fasm.exe" "amdFishX_base.asm"      -m 50000 "Linux\amdFishX_BASE_%datestamp%"
"fasm.exe" "amdFishX_popcnt.asm"    -m 50000 "Linux\amdFishX_POP_%datestamp%"
"fasm.exe" "amdFishX_bmi2.asm"      -m 50000 "Linux\amdFishX_BMI2_%datestamp%"
