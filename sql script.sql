



-- handling foreign characters by creating the schema and then appending the csv file from python

create TABLE [netflix_db].[netflix_raw](
	[show_id] [varchar](10) primary key,
	[type] [varchar](10) NULL,
	[title] [nvarchar](200) NULL,
	[director] [varchar](250) NULL,
	[cast] [varchar](1000) NULL,
	[country] [varchar](150) NULL,
	[date_added] [varchar](20) NULL,
	[release_year] [int] NULL,
	[rating] [varchar](10) NULL,
	[duration] [varchar](10) NULL,
	[listed_in] [varchar](100) NULL,
	[description] [varchar](500) NULL
);

select * from netflix_raw;

-- REMOVING THE DUPLICATES

select show_id, count(*) 
from netflix_raw
group by show_id
having count(*)>1; -- no duplicates in show_id ,therefore setting it as a primary key

select title, count(*) 
from netflix_raw
group by title
having count(*)>1; -- duplicates in title


select * from netflix_raw
where title in 
(select title 
from netflix_raw
group by title
having count(*)>1); -- got to know that the duplicate is having different types so if the title and type both are same then we remove the duplicate

select * from netflix_raw
where (title, type)  in 
(select title,type  
from netflix_raw
group by title,type 
having count(*)>1)
order by title; -- the output shows three duplicates so now we'll write the query to remove the duplicates


with cte as (
select * ,row_number() over(partition by title , type order by show_id) as rn
from netflix_raw
)
select * from cte 
where rn = 1; -- this table contains the desired results, we will use this table to do more modifications.

-- CREATING NEW AND SEPARATE TABLES FOR listed_in(genre), director, country, cast because these columns have mutiple values in one column

select show_id, trim(value) as director
into netflix_directors
from netflix 
cross apply string_split(director, ','); --

select * from netflix_directors;


select show_id, trim(value) as genre
into netflix_genre
from netflix 
cross apply string_split(listed_in, ',');

select * from netflix_genre;


select show_id, trim(value) as country
into netflix_countries
from netflix 
cross apply string_split(country, ',');

select * from netflix_countries;


select show_id, trim(value) as cast
into netflix_cast
from netflix 
cross apply string_split(cast, ',');

select * from netflix_cast;


-- POPULATING MISSING VALUES IN COUNTRY

select director, country 
from netflix_countries as nc inner join netflix_directors as nd
on nc.show_id = nd.show_id 
group by director, country
order by director; -- USING THE LOGIC THAT IF A DIRECTOR HAS MADE MULTIPLE MOVIES THAN THEY MUST HAVE SAME COUNTRY COLUMN.

insert into netflix_countries
select show_id, m.country 
from netflix as n
inner join (
select director, country 
from netflix_countries as nc inner join netflix_directors as nd
on nc.show_id = nd.show_id 
group by director, country 
) as m 
on n.director = m.director
where n.country is null; -- POPULATED THE COUNTRY COLUMN WITH THE AVAILABLE OPTIONS (NOT ALL ARE POPULATED , BUT WE DID AS MANY AS WE COULD HAVE)

select * from netflix_countries;

-- DATA TYPE CONVERSION FOR DATE_ADDED

with cte as(
select * ,
ROW_NUMBER() OVER(PARTITION BY title, type order by show_id) as rn
from netflix
)
select show_id, type, title, cast(date_added as date) as date_added,
release_year, rating, duration, description 
from cte 
where rn = 1; -- converted the data type of date_added using the cast function.


-- FINAL CLEAN TABLE 

with cte as(
select * ,
ROW_NUMBER() OVER(PARTITION BY title, type order by show_id) as rn
from netflix_raw
)
select show_id, type, title, cast(date_added as date) as date_added, 
release_year, rating, case when duration is null then rating else duration end as duration, description
into netflix
from cte;  -- this will work as the final clean table we have obtained after pre-processing







-- Netflix data analysis

/*1  For each director count the no of movies and tv shows created by them in separate columns 
     for directors who have created tv shows and movies both */

	 select nd.director,
	 count(distinct case when nf.type = 'Movie' then nf.show_id end) as no_of_movies,
	 count(distinct case when nf.type = 'TV Show' then nf.show_id end) as no_of_tvshow
	 from netflix_directors as nd
	 inner join netflix_f as nf
	 on nd.show_id = nf.show_id
	 group by nd.director
	 having count(distinct nf.type) > 1 ;

	



/* 2 Which country has highest number of comedy movies */


select  top 1 nc.country , COUNT(distinct ng.show_id ) as no_of_movies
from netflix_genre ng
inner join netflix_countries nc on ng.show_id=nc.show_id
inner join netflix_f n on ng.show_id=nc.show_id
where ng.genre='Comedies' and n.type='Movie'
group by  nc.country
order by no_of_movies desc ; 


/*3 For each year (as per date added to netflix), which director has maximum number of movies released*/


with cte as (
select nd.director,YEAR(date_added) as date_year,count(n.show_id) as no_of_movies
from netflix n
inner join netflix_directors nd on n.show_id=nd.show_id
where type='Movie'
group by nd.director,YEAR(date_added)
)
, cte2 as (
select *
, ROW_NUMBER() over(partition by date_year order by no_of_movies desc, director) as rn
from cte
)
select * from cte2 where rn=1 ;



/* 4 what is average duration of movies in each genre */


select ng.genre , avg(cast(REPLACE(duration,' min','') AS int)) as avg_duration
from netflix n
inner join netflix_genre ng on n.show_id=ng.show_id
where type='Movie'
group by ng.genre
order by avg_duration desc;



/*5  find the list of directors who have created horror and comedy movies both.
display director names along with number of comedy and horror movies directed by them */


select  nd.director
, count(distinct case when ng.genre='Comedies' then n.show_id end) as no_of_comedy 
, count(distinct case when ng.genre='Horror Movies' then n.show_id end) as no_of_horror
from netflix n
inner join netflix_genre ng on n.show_id=ng.show_id
inner join netflix_directors nd on n.show_id=nd.show_id
where type='Movie' and ng.genre in ('Comedies','Horror Movies')
group by nd.director
having COUNT(distinct ng.genre)=2;

