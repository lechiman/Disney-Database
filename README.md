# Disney+ Content Analysis 🎬

A comprehensive data analysis project exploring Disney+ streaming content, including detailed information about movies and TV shows available on the platform.

## 📊 Project Overview

This project contains a cleaned dataset of Disney+ titles and a complete SQL database setup for analyzing the content library. The analysis covers content distribution, ratings, genres, release patterns, and more insights into Disney's streaming offerings.

## 📁 Project Structure

```
Disney+/
├── README.md                    # This file
├── disney_plus_titles_cleaned.csv  # Main dataset (1,451 titles)
└── Disney+Database.sql          # Complete database setup & analysis queries
```

## 📈 Dataset Information

The `disney_plus_titles_cleaned.csv` contains **1,451 Disney+ titles** with the following attributes:

| Column | Description |
|--------|-------------|
| `show_id` | Unique identifier for each title |
| `type` | Content type (Movie or TV Show) |
| `title` | Title of the content |
| `director` | Director(s) of the content |
| `cast` | Main cast members |
| `country` | Country/countries of origin |
| `date_added` | Date added to Disney+ |
| `release_year` | Original release year |
| `rating` | Content rating (G, PG, TV-14, etc.) |
| `duration` | Runtime (minutes for movies, seasons for TV shows) |
| `listed_in` | Genres/categories |
| `description` | Brief content description |

## 🚀 Getting Started

### Prerequisites
- MySQL or any SQL-compatible database system
- CSV import capability (for database loading)

### Setup Instructions

1. **Clone or download** this repository
2. **Import the SQL database:**
   ```sql
   SOURCE Disney+Database.sql;
   ```
3. **Load the CSV data** into the created table structure
4. **Run the analysis queries** provided in the SQL file

## 🔍 Analysis Features

The SQL file includes ready-to-run queries for:

- **Content Distribution**: Movies vs TV Shows breakdown
- **Rating Analysis**: Most common content ratings
- **Temporal Trends**: Content release patterns by decade
- **Genre Analysis**: Popular content categories
- **Regional Distribution**: Content by country of origin
- **Duration Insights**: Runtime patterns and statistics

## 📊 Key Insights

Some interesting findings you can explore:

- Content type distribution (Movies vs TV Shows)
- Most popular content ratings on Disney+
- Release year trends showing Disney's content strategy
- Genre preferences and content categorization
- International content representation

## 🛠️ Usage Examples

### Basic Data Exploration
```sql
-- View sample data
SELECT * FROM disney_content LIMIT 10;

-- Count total content
SELECT COUNT(*) as total_titles FROM disney_content;
```

### Content Analysis
```sql
-- Content type breakdown
SELECT type, COUNT(*) as count 
FROM disney_content 
GROUP BY type;

-- Most common ratings
SELECT rating, COUNT(*) as count 
FROM disney_content 
GROUP BY rating 
ORDER BY count DESC;
```

## 📄 Data Source

This dataset contains information about Disney+ content and has been cleaned and structured for analysis purposes.

## 🤝 Contributing

Feel free to:
- Add new analysis queries
- Improve data visualization
- Suggest additional insights
- Report any data quality issues

## 📝 License

This project is for educational and analysis purposes.

---

**Happy Analyzing!** 🎭✨

*Explore the magical world of Disney+ content through data!*
