# اختيار نسخة للاسترجاع ثم نسخها فوق index.html مع حفظ نسخة احتياطية تلقائية للحالة الحالية
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$snapDir = Join-Path $root "snapshots"
$snaps = Get-ChildItem -Path $snapDir -Directory | Sort-Object Name
if (-not $snaps) { Write-Host "لا توجد نسخ محفوظة."; exit }
Write-Host "النسخ المتاحة:"
for ($i=0; $i -lt $snaps.Count; $i++) { Write-Host "$($i+1). $($snaps[$i].Name)" }
$choice = Read-Host "ادخل رقم النسخة للاسترجاع"
$idx = [int]$choice - 1
if ($idx -lt 0 -or $idx -ge $snaps.Count) { Write-Host "رقم غير صالح."; exit }
$selected = $snaps[$idx]
$src = Join-Path $selected.FullName "index.html"
$dst = Join-Path $root "index.html"
# نسخة احتياطية للحالة الحالية قبل الاسترجاع
$backup = Join-Path $root ("index.backup_before_restore_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".html")
Copy-Item -Force $dst $backup
Copy-Item -Force $src $dst
Set-Content -Path (Join-Path $root "VERSION") -Value $selected.Name
Write-Host "تم الاسترجاع من: $($selected.Name)"
Write-Host "حُفظت حالتك السابقة في: $backup"
