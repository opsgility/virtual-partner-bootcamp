
Write-Output "Started parent runbook"

$out = ./MyChildPSRunbook.ps1 -text "bananas"

Write-Output "Child runbook output: $out"

Write-Output "Parent runbook finished"