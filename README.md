# Project3-Apple-iTunes-Music-Analysis
Apple iTunes Music Analysis
Project Overview

This project analyzes the Apple iTunes music store dataset to understand customer behavior, music preferences, and sales performance. The analysis is performed using SQL for data querying and Microsoft Power BI Desktop for interactive dashboard visualization.

The objective of this project is to transform raw transactional data into meaningful business insights that can support data-driven decision making.

Project Objectives

Analyze customer purchasing behavior

Identify the most popular music genres and artists

Evaluate sales performance across different countries

Track revenue trends over time

Build an interactive dashboard for business insights

Dataset Information

The project uses the iTunes relational database dataset containing multiple tables such as:

Customers

Employees

Invoices

Invoice Lines

Tracks

Albums

Artists

Genres

Media Types

Playlists

These tables are connected using Primary Keys and Foreign Keys to form a relational database structure.

Database Schema

The database schema includes the following key relationships:

Customer → Invoice

Invoice → Invoice Line

Track → Album → Artist

Track → Genre

Track → Media Type

Playlist → Playlist Track

This structure allows efficient analysis across different aspects of the music store.

SQL Analysis

SQL queries were used to perform exploratory and advanced data analysis, including:

Total revenue calculation

Customer distribution by country

Top spending customers

Most popular music genres

Top selling artists

Most purchased tracks

Employee sales performance

Monthly and yearly revenue trends

Advanced SQL techniques such as CTE, Window Functions, Ranking, and Aggregations were used to generate deeper insights.

Dashboard Visualization

An interactive dashboard was created using Microsoft Power BI Desktop to visualize key metrics.

Dashboard features include:

Total Revenue

Total Orders

Total Customers

Monthly Revenue Trend

Top Customers

Most Purchased Genres

These visualizations help understand business performance quickly.

Key Insights

Some important insights from the analysis include:

A small group of customers contributes a large portion of revenue

Certain genres such as Rock and Pop dominate music purchases

Sales vary across different countries

Some artists generate significantly higher revenue than others

Revenue trends change across months and years

Tools & Technologies Used

SQL (MySQL)

CSV Dataset

Microsoft Power BI Desktop

GitHub for project documentation

Repository Structure
Apple-iTunes-Music-Analysis
│
├── Dataset
├── SQL Queries
├── Dashboard
├── Report
└── README.md
Author

Bhumika Patil
Data Science with Gen AI Internship Project – Innovexis
