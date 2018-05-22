/*Find the names of all reviewers who rated Gone with the Wind. */
select distinct name 
from (movie natural join rating) natural join reviewer 
where title='Gone with the Wind';

/*For any rating where the reviewer is the same as the director 
of the movie, return the reviewer name, movie title, and number of stars. */
select name,title,stars
from (movie natural join rating) natural join reviewer 
where name=director;

/*Return all reviewer names and movie names together in a single list, 
alphabetized. (Sorting by the first name of the reviewer and first word 
in the title is fine; no need for special processing on last names or removing "The".) */
select *
from(
	select name as result from reviewer 
	union
	select title as result from movie) as A
order by A.result;

/*Find the titles of all movies not reviewed by Chris Jackson. */
select title 
from movie
where mID not in (select mid from rating natural join reviewer where name='Chris Jackson');

/*For all pairs of reviewers such that both reviewers gave a rating to the same movie, 
return the names of both reviewers. Eliminate duplicates, don't pair reviewers with 
themselves, and include each pair only once. For each pair, return the names in the 
pair in alphabetical order. */
select A.name,B.name  
from (select * from rating natural join reviewer) as A, 
	 (select * from rating natural join reviewer) as B
where A.mID=B.mID and A.name<B.name
group by A.name,B.name
order by A.name;

/*For each rating that is the lowest (fewest stars) currently in the database,
return the reviewer name, movie title, and number of stars. */
select name,title,stars
from (movie natural join rating) natural join reviewer
where stars = (select min(stars) from (movie natural join rating) natural join reviewer);

/*List movie titles and average ratings, from highest-rated to lowest-rated. 
If two or more movies have the same average rating, list them in alphabetical order. */
select title, avg(stars) 
from (movie natural join rating) natural join reviewer 
group by mID
order by avg(stars) desc,title;

/*Find the names of all reviewers who have contributed three or more ratings.
(As an extra challenge, try writing the query without HAVING or without COUNT.) */
select name
from(
	select name, sum(A.rID) as sumID
	from (select * from rating natural join reviewer) as A
	group by rID) as B
where B.sumID>=600;

/*Some directors directed more than one movie. For all such directors, 
return the titles of all movies directed by them, along with the director 
name. Sort by director name, then movie title. (As an extra challenge, 
try writing the query both with and without COUNT.) */
select title,director
from movie
where director in
	(select director
	from(
		select director, sum(mID) as sumID
		from movie 
        group by director) as A
	where A.sumID>=200)
order by director,title;

/*Find the movie(s) with the highest average rating. Return the movie 
title(s) and average rating. (Hint: This query is more difficult to write 
in SQLite than other systems; you might think of it as finding the highest 
average rating and then choosing the movie(s) with that average rating.) */
select title, avgS
from
	(select title, avg(stars) as avgS
	from (movie natural join rating) natural join reviewer 
	group by mID) as A
where A.avgS=(select max(avgS) from (select title, avg(stars) as avgS
			from (movie natural join rating) natural join reviewer 
			group by mID) as A);
            
/*Find the movie(s) with the lowest average rating. Return the movie title(s) 
and average rating. (Hint: This query may be more difficult to write in SQLite 
than other systems; you might think of it as finding the lowest average rating 
and then choosing the movie(s) with that average rating.) */
select title, avgS
from
	(select title, avg(stars) as avgS
	from (movie natural join rating) natural join reviewer 
	group by mID) as A
where A.avgS=(select min(avgS) from (select title, avg(stars) as avgS
			from (movie natural join rating) natural join reviewer 
			group by mID) as A);

/*For each director, return the director's name together with the title(s) 
of the movie(s) they directed that received the highest rating among all of 
their movies, and the value of that rating. Ignore movies whose director is NULL. */
select C.director,title , mmaxs
from(	select title, max(stars) as maxs,director
		from (movie natural join rating) natural join reviewer 
		group by mID 
		having director is not null) as B,
	(select director,max(maxs) as mmaxs
	from(
		select title, max(stars) as maxs,director
		from (movie natural join rating) natural join reviewer 
		group by mID 
		having director is not null) as A
	group by A.director) as C
where B.director=C.director and B.maxs=C.mmaxs
order by C.director;
