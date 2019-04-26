function Invoke-SQLiteQuery {
  <#
      .SYNOPSIS
      With "Invoke-SQLiteQuery" you can invoke a SQLite query to your SQLite database.

      .DESCRIPTION
      Add a more complete description of what the function does.

      .PARAMETER Database
      Path to your SQLite database -Database

      .PARAMETER Query
      Your SQLite Quer -Query

      .EXAMPLE
      Invoke-SQLiteQuery -Database "$HOME/SampleDB.sqlite" -Query (Get-Content "$HOME/SampleDB.sql" | Out-String)
      Invoke a SQLite query from a SQL file

      .NOTES
      Module for my PSConfEU 2019 talk

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Invoke-SQLiteQuery

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>

  param
  (
    [String]
    [Parameter(
        Mandatory, 
        ValueFromPipeline,
        ValueFromPipelineByPropertyName,
        HelpMessage='Path to your database')
    ]
    [Alias('FullName', 'Name', 'FilePath')]
    $Database,
  
    [String]
    [Parameter(
        Mandatory, 
        ValueFromPipeline, 
        HelpMessage='Your SQL query')]
    $Query
  )
  
    #region BEGIN
    begin {
        $SystemDataSQLiteDll = Join-Path -Path $PSScriptRoot -ChildPath 'System.Data.SQLite.dll'
        
        if (!(Test-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'SQLite.Interop.dll')))
        {
          if ($IsLinux) {
            $SQLiteInteropdllLin = Join-Path -Path $PSScriptRoot -ChildPath 'SQLite.Interop.dll_lin'
            $SQLiteInteropdll =  Join-Path -Path $PSScriptRoot -ChildPath 'SQLite.Interop.dll'

            Copy-Item -Path $SQLiteInteropdllLin -Destination $SQLiteInteropdll -Force
          }
          elseif ($IsMacOS) {
            $SQLiteInteropdllOsx = Join-Path -Path $PSScriptRoot -ChildPath 'SQLite.Interop.dll_osx'
            $SQLiteInteropdll =  Join-Path -Path $PSScriptRoot -ChildPath 'SQLite.Interop.dll'

            Copy-Item -Path $SQLiteInteropdllOsx -Destination $SQLiteInteropdll -Force
          }
          else {
            $SQLiteInteropdllX64 = Join-Path -Path $PSScriptRoot -ChildPath 'SQLite.Interop.dll_x64'
            $SQLiteInteropdll =  Join-Path -Path $PSScriptRoot -ChildPath 'SQLite.Interop.dll'

            Copy-Item -Path $SQLiteInteropdllX64 -Destination $SQLiteInteropdll -Force
          }
        }
        Add-Type -Path $SystemDataSQLiteDll
    }
    #endregion
    
    #region PROCESS
    process {
        $con = New-Object -TypeName System.Data.SQLite.SQLiteConnection
        $con.ConnectionString = (('Data Source={0}' -f $Database))
        $con.Open()
        $sql = $con.CreateCommand()
        $sql.CommandText = $Query
        $reader = $sql.ExecuteReader()
        
        [System.Collections.ArrayList]$values = @()
        while ($reader.Read())
        {
          for ([int]$i = 0; $i -lt $reader.Read(); $i++) 
          {
            $values.Add($reader.GetValue($i))
          }
          $values
        }
    }
    #endregion

    #region END
    end {
        $sql.Dispose()
        $con.Close()
    }
    #endregion
}

Export-ModuleMember -Function 'Invoke-SQLiteQuery'