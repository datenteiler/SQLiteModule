# SQLiteModule
With "Invoke-SQLiteQuery" you can invoke a SQLite query to your SQLite database in PowerShell


PowerShell binary cmdlet Invoke-SQLiteQuery
------------------------------------------------------------

* Invoke-SQLiteQuery -Database /path/to/sqlite.db -Query "SELECT name FROM sqlite_master WHERE type='table';"


Installation from PowerShell Gallery (PSGallery)
------------------------------------------------

You can download the module from PSGallery in PowerShell with this command:

```Install-Module -Name InvokeSQLiteQuery```

How to use Invoke-SQLiteQuery
-----------------------------

[Download Chinook database as a sample database SQLite](https://github.com/lerocha/chinook-database/blob/master/ChinookDatabase/DataSources/Chinook_Sqlite.sqlite). It is an new and cool alternative to the Northwind database and ideal for demos and testing with the Top of the Pops.

### Show all columns in a SQLite table

```
Invoke-SQLiteQuery -Database "C:\Users\Public\Downloads\Chinook_Sqlite.sqlite" -Query "SELECT sql FROM sqlite_master WHERE type = 'table'"
 ```
 
### Query the table Album

``` 
Invoke-SQLiteQuery -Database "C:\Users\Public\Downloads\Chinook_Sqlite.sqlite" -Query "SELECT AlbumId, Title, ArtistId FROM Album ORDER BY title LIMIT 10;"
```
### Format the output of the query

```
Invoke-SQLiteQuery -Database ./Chinook_Sqlite.sqlite -Query "SELECT AlbumId, Title, ArtistId FROM Album ORDER BY title LIMIT 10;" | ForEach-Object  { $_ -join ';' } | ConvertFrom-Csv -Header 'AlbumID','Title','ArtistID' -Delimiter ';'
```

### Save result of a query to a CSV file

```
Invoke-SQLiteQuery -Database ./Chinook_Sqlite.sqlite -Query "SELECT AlbumId, Title, ArtistId FROM Album ORDER BY title LIMIT 10;" | ForEach-Object  { $_ -join ';' } | ConvertFrom-Csv -Header 'AlbumID','Title','ArtistID' -Delimiter ';' | Export-Csv -Path ./myfile.csv
```

### Using an In-Memory database

```
Invoke-SQLiteQuery -Database ":memory:" -Query "SELECT 35 + 7;"
```

