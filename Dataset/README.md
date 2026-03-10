
# Dataset

## Overview
This folder contains the CSV files used for the Apple iTunes Music Analysis project.  
The dataset represents a relational database of the Apple iTunes digital music store.

It includes information about customers, employees, invoices, tracks, artists, albums, genres, playlists, and media types.

These files were imported into a MySQL database to perform SQL analysis and build a business intelligence dashboard.

---

## Dataset Tables

The dataset contains the following CSV files:

album.csv  
Contains information about music albums and their corresponding artists.

artist.csv  
Stores details of artists whose music is available in the store.

customer.csv  
Contains customer information such as name, country, and contact details.

employee.csv  
Includes details about employees who manage customer relationships.

genre.csv  
Stores music genre categories such as Rock, Pop, Jazz, etc.

invoice.csv  
Contains customer purchase transactions.

invoice_line.csv  
Stores detailed purchase information for each invoice.

media_type.csv  
Contains information about different music media formats.

playlist.csv  
Stores playlists created in the music store.

playlist_track.csv  
Maps tracks to playlists.

track.csv  
Contains detailed information about songs including album, genre, and media type.

---

## Dataset Usage

These datasets were imported into a MySQL database using MySQL Workbench Import Wizard.  
Primary keys and foreign keys were used to establish relationships between tables.

This relational structure enabled complex SQL queries for analyzing customer behavior, music trends, and revenue performance.

---

## Source

The dataset is based on the sample Apple iTunes database commonly used for SQL practice and data analysis projects.
