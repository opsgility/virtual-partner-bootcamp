workflow MyParentPSWRunbook
{
    Write-Output "Started parent runbook"

    $out = MyChildPSWRunbook -text "bananas"

    Write-Output "Child runbook output: $out"

    Write-Output "Parent runbook finished"
}