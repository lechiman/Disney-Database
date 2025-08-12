# Sample Analysis Output

This file shows example output from running the Disney+ content analysis.

## Basic Dataset Info
```
Dataset loaded successfully: 1451 records
Total records: 1451
Columns: ['show_id', 'type', 'title', 'director', 'cast', 'country', 'date_added', 'release_year', 'rating', 'duration', 'listed_in', 'description']
```

## Content Type Distribution
```
Movie      1167 (80.4%)
TV Show     284 (19.6%)
```

## Top 10 Content Ratings
```
TV-PG     396 (27.3%)
TV-G      300 (20.7%)
PG        234 (16.1%)
TV-14     165 (11.4%)
G         144 (9.9%)
PG-13      89 (6.1%)
TV-MA      49 (3.4%)
TV-Y7      32 (2.2%)
TV-Y       25 (1.7%)
R          17 (1.2%)
```

## Content by Decade
```
1930s: 15 titles
1940s: 28 titles
1950s: 36 titles
1960s: 42 titles
1970s: 58 titles
1980s: 84 titles
1990s: 156 titles
2000s: 289 titles
2010s: 658 titles
2020s: 85 titles
```

## Top 10 Genres
```
Family: 387
Animation: 297
Comedy: 263
Drama: 188
Action-Adventure: 165
Kids: 127
Documentary: 119
Fantasy: 104
Biographical: 87
Animals & Nature: 84
```

## Key Insights

- **Movies dominate** the Disney+ catalog, making up over 80% of content
- **Family-friendly content** is the priority, with TV-PG and TV-G being the most common ratings
- **2010s saw massive growth** in content production, representing 45% of all titles
- **Family and Animation** are the top genres, aligning with Disney's brand identity
- **Recent focus** on diverse content types including documentaries and nature programming

## Visualizations Generated

Running `python analyze_disney_data.py` creates:
- Content type pie chart
- Ratings distribution bar chart  
- Release year histogram
- Top genres horizontal bar chart

All visualizations are saved as `disney_plus_analysis.png`
