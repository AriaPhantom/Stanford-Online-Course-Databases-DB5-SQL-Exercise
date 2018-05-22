/*Find the titles of all movies directed by Steven Spielberg.*/
SELECT title
FROM Movie
WHERE director='Steven Spielberg';

/*Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. */
SELECT distinct year
FROM Movie M,rating R
WHERE M.mID=R.mID and stars>=4;

/*Find the titles of all movies that have no ratings. */
SELECT title
FROM Movie M
WHERE M.mID not in (SELECT mID FROM rating R);

/*Some reviewers didn't provide a date with their rating. Find the names of all reviewers who
have ratings with a NULL value for the date. */
SELECT name
FROM Reviewer R
WHERE R.rID in (SELECT rID FROM rating R where ratingDate is null);

/*Write a query to return the ratings data in a more readable format: reviewer name, movie title, 
stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. */
SELECT R.name, title, stars, ratingDate
FROM Reviewer R, Rating RA, Movie M
WHERE R.rID=RA.rID and M.mID=RA.mID
order by R.name,title, stars;

/*For all cases where the same reviewer rated the same movie twice and gave it a higher rating the 
second time, return the reviewer's name and the title of the movie. */
select Reviewer.name, Movie.title
from Reviewer, Movie, (select R1.rID, R1.mID from Rating R1, Rating R2 where R1.rID=R2.rID and R1.mID=R2.mID and R2.ratingDate>R1.ratingDate and R2.stars>R1.stars) as T
where Reviewer.rID=T.rID and Movie.mID=T.mID;

/*For each movie that has at least one rating, find the highest number of stars that movie received.
 Return the movie title and number of stars. Sort by movie title. */
select title, max(stars)
from (movie natural join rating) natural join reviewer
group by mID
order by title;

/*For each movie, return the title and the 'rating spread', that is, the difference between highest 
and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. */
select title, max(stars)-min(stars) as 'rating spread'
from (movie natural join rating) natural join reviewer
group by mID
order by max(stars)-min(stars) desc,title;

/*Find the difference between the average rating of movies released before 1980 and the average rating of movies 
released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages 
for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) */
select avg(R1.av1)-avg(R2.av2)
from
(select avg(stars) as av1  from (movie natural join rating) natural join reviewer where year<1980 group by mID) as R1,
(select avg(stars) as av2  from (movie natural join rating) natural join reviewer where year>1980 group by mID) as R2;



