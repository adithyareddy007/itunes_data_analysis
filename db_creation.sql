-- Artist
CREATE TABLE artist (
    artistid INT PRIMARY KEY,
    name VARCHAR(120)
);

-- Album
CREATE TABLE album (
    albumid INT PRIMARY KEY,
    title VARCHAR(160),
    artistid INT REFERENCES artist(artistid)
);

-- MediaType
CREATE TABLE media_type (
    mediatypeid INT PRIMARY KEY,
    name VARCHAR(120)
);

-- Genre
CREATE TABLE genre (
    genreid INT PRIMARY KEY,
    name VARCHAR(120)
);

-- Track
CREATE TABLE track (
    trackid INT PRIMARY KEY,
    name VARCHAR(200),
    albumid INT REFERENCES album(albumid),
    mediatypeid INT REFERENCES media_type(mediatypeid),
    genreid INT REFERENCES genre(genreid),
    composer VARCHAR(220),
    milliseconds INT,
    bytes INT,
    unitprice NUMERIC(10,2)
);

-- Playlist
CREATE TABLE playlist (
    playlistid INT PRIMARY KEY,
    name VARCHAR(120)
);

-- PlaylistTrack
CREATE TABLE playlist_track (
    playlistid INT REFERENCES playlist(playlistid),
    trackid INT REFERENCES track(trackid),
    PRIMARY KEY (playlistid, trackid)
);

-- Employee
CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    last_name VARCHAR(20),
    first_name VARCHAR(20),
    title VARCHAR(30),
    reports_to INT,
    levels VARCHAR(5),   
    birthdate TEXT,     
    hire_date TEXT,      
    address VARCHAR(70),
    city VARCHAR(40),
    state VARCHAR(40),
    country VARCHAR(40),
    postal_code VARCHAR(20),
    phone VARCHAR(30),
    fax VARCHAR(30),
    email VARCHAR(60)
);

-- Customer
CREATE TABLE customer (
    customerid INT PRIMARY KEY,
    firstname VARCHAR(40),
    lastname VARCHAR(20),
    company VARCHAR(80),
    address VARCHAR(70),
    city VARCHAR(40),
    state VARCHAR(40),
    country VARCHAR(40),
    postalcode VARCHAR(10),
    phone VARCHAR(24),
    fax VARCHAR(24),
    email VARCHAR(60),
    supportrepid INT REFERENCES employee(employee_id)
);

-- Invoice
CREATE TABLE invoice (
    invoiceid INT PRIMARY KEY,
    customerid INT REFERENCES customer(customerid),
    invoicedate TIMESTAMP,
    billingaddress VARCHAR(70),
    billingcity VARCHAR(40),
    billingstate VARCHAR(40),
    billingcountry VARCHAR(40),
    billingpostalcode VARCHAR(10),
    total NUMERIC(10,2)
);

-- InvoiceLine
CREATE TABLE invoice_line (
    invoicelineid INT PRIMARY KEY,
    invoiceid INT REFERENCES invoice(invoiceid),
    trackid INT REFERENCES track(trackid),
    unitprice NUMERIC(10,2),
    quantity INT
);

ALTER TABLE employee 
    ALTER COLUMN birthdate TYPE DATE USING to_date(split_part(birthdate, ' ', 1), 'DD-MM-YYYY');

ALTER TABLE employee 
    ALTER COLUMN hire_date TYPE DATE USING to_date(split_part(hire_date, ' ', 1), 'DD-MM-YYYY');

SELECT * FROM album;
SELECT * FROM artist;
SELECT * FROM customer;
SELECT * FROM employee;
SELECT * FROM genre;
SELECT * FROM invoice;
SELECT * FROM invoice_line;
SELECT * FROM media_type;
SELECT * FROM playlist;
SELECT * FROM playlist_track;
SELECT * FROM track;