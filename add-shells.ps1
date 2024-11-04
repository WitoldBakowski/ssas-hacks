function dmCloneShellAll($SSAS)
{
cls
 [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices.Tabular") | Out-Null
$ts = [Microsoft.AnalysisServices.Tabular.Server]::new()
 $ts.Connect($SSAS)
 $ts.Databases.ForEach({
        if ( $_.Name -like "*Shell" ) {continue}
        if (  $ts.Databases.ContainsName("$($_.Name) Shell") ) {continue}
        Write-Host "Adding {$($_.Name) Shell}"
        dmCloneShell -srvName $_.Server.Name -modelName $_.Name 
 })
}

function dmCloneShell ($srvName, $modelName)
{
 [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices.Tabular")  | Out-Null
$s = [Microsoft.AnalysisServices.Tabular.Server]::new()
 $s.Connect($srvName)
$dm = $s.Databases.GetByName( $modelName)
$clone = [Microsoft.AnalysisServices.Tabular.Database]::new()
$dm.CopyTo( $clone) | Out-Null
$clone.Name = "$($modelName) Shell"
$clone.ID =  "$($modelName) Shell"
$newModel = [Microsoft.AnalysisServices.Tabular.Model]::new()
$newModel.Name = $modelName
$clone.Model = $newModel
$dm.Model.CopyTo( $clone.Model)
$s.Databases.Add( $clone)
$clone.Update( [Microsoft.AnalysisServices.UpdateOptions]::ExpandFull)
}

function dmDestroyShellAll($SSAS){
 [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices.Tabular") | Out-Null
$s = [Microsoft.AnalysisServices.Tabular.Server]::new()
 $s.Connect($SSAS )
 $dbs = @()
$s.Databases.ForEach(      
   {
           if ($_.Name -like "*Shell")
           {
           $dbs += $_               
           }
       } 
    )

for ($i = 0; $i -lt  $dbs.Count; $i++)
{ 
    $dbs[$i].Drop()
}
}
