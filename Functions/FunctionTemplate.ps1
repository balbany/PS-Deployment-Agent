Function _SheetName_ ($Rows) {
    Write-Host "Deploying _SheetName_..." -ForegroundColor White
	ForEach( $row in $Rows ) {
        $splatRow = getSplat -Input $row
        Write-Host "    -   Ensuring object" (ConvertTo-Json $splatRow -Compress) -ForegroundColor White
        #Call lower level cmdlet/function for the current row here
        Invoke-Splat _Cmdlet_ $splatRow
    }
}