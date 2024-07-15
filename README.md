# Netflix-Data-Analysis-using-SQL

## Understanding Viewer Preferences and Performance

![Netflix Data Analysis](https://github.com/abhaygupt-a/Netflix-Data-Analysis-using-SQL/blob/main/Netflix%20Data%20Analysis%20PNG.png)

### Introduction
This project focuses on analyzing Netflix data to uncover viewer behaviors and content trends. By refining data types, resolving inconsistencies, and leveraging SQL queries, the analysis aims to provide actionable insights for optimizing content strategies and enhancing user experience on the platform.

### Objectives and Scope
- **Enhance Data Quality and Consistency**
- **Deepen Understanding of Viewer Preferences**
- **Optimize Operational Efficiency**
- **Drive Strategic Decision-Making**

### Workflow
1. **Data Collection and Loading**
2. **Data Cleaning**
3. **Data Analysis**
4. **Insights and Results**

### Data Collection and Loading

#### Data Sources
- Netflix dataset containing information about movies, TV shows, directors, cast, genres, countries, duration, and ratings downloaded from Kaggle.

#### Data Loading Process
- Data was initially loaded into Python for preprocessing and then imported into the raw data layer of MS SQL Server.

### Data Cleaning
- **Title Column**: Converted from `varchar` to `nvarchar` to support foreign characters and ensure visibility and correct representation of all characters.
- **Optimal Column Lengths**: Determined using Python to improve loading speed by changing from max length to required length.
- **Primary Key**: Identified `show_id` as unique and established it as the primary key to ensure data integrity and uniqueness.
- **Normalization**: Refactored columns containing multiple values separated by commas into separate tables to enhance data integrity and allow efficient querying.
- **Date Consistency**: Changed the data type of the "Date Added" column from `varchar` to `date` for accurate date handling.
- **Handling Null Values**: Filled null values in the "Country" column by analyzing the "Director" column, assuming that directors typically create content in their own country. Used a `CASE` statement to resolve discrepancies where null values in the "Duration" column were incorrectly placed in the "Rating" column.

### Data Analysis
- SQL queries were used to efficiently select only unique rows for each title in the Netflix data table by assigning row numbers partitioned by title, thereby ensuring duplicates were handled appropriately.

### Insights and Results

#### Key Insights
- **Content Preferences**: Highlighted the popularity of comedy movies in the United States, guiding localized content acquisition strategies.
- **Directorial Excellence**: Recognized prolific directors and their impact on Netflix’s content diversity and viewer engagement.
- **Genre Analysis**: Provided insights into viewer preferences based on genre and average duration, informing content curation strategies.

#### Strategic Implications
1. **Enhanced Content Relevance**: Targeting popular genres like comedy in the United States improves viewer engagement.
2. **Strategic Partnerships**: Collaborating with top directors diversifies content and attracts broader audiences.
3. **Operational Efficiency**: Optimizing content length enhances viewer satisfaction and retention.
4. **Informed Decision-Making**: Data-driven insights enable precise resource allocation and competitive positioning.

### Made By
Abhay Gupta


