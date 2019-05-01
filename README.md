# SQLiteModule
With "Invoke-SQLiteQuery" you can invoke a SQLite query to your SQLite database in PowerShell


PowerShell binary cmdlet Invoke-SQLiteQuery
------------------------------------------------------------

* Invoke-SQLiteQuery -Database /path/to/sqlite.db -Query "SELECT name FROM sqlite_master WHERE type='table';"


Installation from PowerShell Gallery (PSGallery)
------------------------------------------------

You can download the module from PSGallery in PowerShell with this command:

```Install-Module -Name SQLiteModule```

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

### Access the same SQLite in-memory (:memory:) database with two or more steps

We cannot access the same in-memory database from different processes. A new connection to :memory: always creates a new database, because every :memory: database is distinct from every other. This is different from an on-disk database, where multiple connections with the same connection string creates a connection to one database.

Within one process it is possible to share an in-memory database with the use of an URI:

```
Invoke-SQLiteQuery -Database "file::memory:?cache=shared" -Query "CREATE TABLE contacts (                              
 contact_id INTEGER PRIMARY KEY,               
 first_name TEXT NOT NULL,
 last_name TEXT NOT NULL,
 email TEXT NOT NULL UNIQUE,
 phone TEXT NOT NULL UNIQUE
 );"

Invoke-SQLiteQuery -Database "file::memory:?cache=shared" -Query "INSERT INTO contacts (first_name,last_name,email,phone) VALUES('Johnny','Cash','j@cash.com',555346);"

Invoke-SQLiteQuery -Database "file::memory:?cache=shared" -Query "SELECT * FROM contacts;"
```
