# SQLiteModule
With "Invoke-SQLiteQuery" you can invoke a SQLite query to your SQLite database in PowerShell


PowerShell Cmdlet Invoke-SQLiteQuery
------------------------------------

* Invoke-SQLiteQuery -Database /path/to/sqlite.db -Query "SELECT name FROM sqlite_master WHERE type='table';"


Installation from PowerShell Gallery (PSGallery)
------------------------------------------------

You can download the module from PSGallery in PowerShell with this command:

```Install-Module -Name SQLiteModule -Scope CurrentUser```

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

### Double the leading two backslashes in the file name of the database if you have to deal with an UNC path

```
Invoke-SQLiteQuery -Database \\\\10.09.08.07\db\Chinook_Sqlite.sqlite -Query "SELECT COUNT(*) FROM Album;"
```

### Join tables Album and Artist and Format the output of the query
```
Invoke-SQLiteQuery -Database ./Chinook_Sqlite.sqlite -Query "SELECT Name, Title FROM Album JOIN Artist on Album.ArtistId = Artist.ArtistId ORDER BY title LIMIT 10;" | ForEach-Object { $_ -join ";" } | ConvertFrom-Csv -Header 'Artist','Album' -Delimiter ';'
```

### Save result of a query to a CSV file

```
Invoke-SQLiteQuery -Database ./Chinook_Sqlite.sqlite -Query "SELECT Name, Title FROM Album JOIN Artist on Album.ArtistId = Artist.ArtistId ORDER BY title LIMIT 10;" | ForEach-Object { $_ -join ";" } | ConvertFrom-Csv -Header 'Artist','Album' -Delimiter ';' | Export-Csv -Path ./myfile.csv
```

### Find the track with longest duration and the album
```
Invoke-SQLiteQuery -Database ./Chinook_Sqlite.sqlite -Query "SELECT Album.Title, Name, Milliseconds FROM Track JOIN Album ON Track.AlbumId = Album.AlbumID WHERE Milliseconds = (SELECT MAX(Milliseconds) FROM Track);" | ForEach-Object { $_ -join ';'} | ConvertFrom-Csv -Header 'Album','Title','Duration' -Delimiter ';' | Format-List
```

### Using an In-Memory database

```
Invoke-SQLiteQuery -Database ":memory:" -Query "SELECT 35 + 7;"
```

### SQLite uses a dynamic type system and provides five basic datatypes called storage classes

```
Invoke-SQLiteQuery -Database ":MEMORY:" -Query "SELECT typeof(42),typeof(1.5),typeof('Hello, World'),typeof(x'BAADA555'),typeof(NULL);"
```

## You can save the data to a CSV file or pipe it directly to Import-Excel
```
$data = Invoke-SQLiteQuery -Database $Chinook -Query "
  SELECT genre.name, COUNT(*),
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) over(), 2) as pct
  from genre
  LEFT JOIN track USING(genreid)
GROUP BY genre.name ORDER BY genre.name;" | 
ForEach-Object { $_ -join ";" } | 
ConvertFrom-Csv -Header 'Name','Counts', 'PCT %' -Delimiter ';'

$c = New-ExcelChart -Title Genres `
-ChartType Line -Header "Something" `
-XRange "Impressions[Name]" `
-YRange @("Impressions[Counts]","Impressions['PCT %']")

$data | Export-Excel temp.xlsx -AutoSize -TableName Impressions -Show -ExcelChartDefinition $c
```

### This example is from RamblingCookieMonster because PSSQLite gives me the idea to implement SqlParameters.
### https://ramblingcookiemonster.github.io/SQLite-and-PowerShell/

### Let's create a data source and a table:

```
$Database = "C:\Users\Public\Names.sqlite"
$Query = "DROP TABLE NAMES; CREATE TABLE NAMES (
        Fullname VARCHAR(20) PRIMARY KEY,
        Surname TEXT,
        Givenname TEXT,
        Birthdate DATETIME)"

Invoke-SqliteQuery -Database $Database -Query $Query 
```

### That was pretty easy! We used a SQLite PRAGMA statement to see basic details on the table I created.

```
"`nDatabase Integrity: Database is $(Invoke-SQLiteQuery $Database -Query 'PRAGMA INTEGRITY_CHECK')"

$sql = Invoke-SQLiteQuery $Database -Query "SELECT sql FROM sqlite_master WHERE type = 'table'"
```

### Now let's insert some data and pull it back out:

```
$query = "INSERT INTO NAMES (Fullname, Surname, Givenname, Birthdate) VALUES (@full, 'Cookie', 'Monster', @BD)"                  
Invoke-SqliteQuery -Database $Database -Query $query -SqlParameters @{
        full = "Cookie Monster"
        BD   = (Get-Date("2006-12-12"))
    } 
```

### Check to see if we inserted the data:

```
Invoke-SqliteQuery -Da $Database -Q "SELECT * FROM NAMES" | ForEach-Object { $_ -join ";" } | ConvertFrom-Csv -Header 'Fullname', 'Surname', 'Givenname', 'Birthdate' -Delimiter ";" 
```
