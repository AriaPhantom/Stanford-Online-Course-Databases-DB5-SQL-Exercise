/*For every situation where student A likes student B, but student B likes a different student C, return the names 
and grades of A, B, and C. */
select h1.name as name1,h1.grade as grade1,h2.name as name2,h2.grade as grade2,h3.name as name3,h3.grade as grade3
from highschooler h1,highschooler h2,highschooler h3,(select l1.id1,l1.id2,l2.id2 as id3
													from likes l1,likes l2
													where l1.id2=l2.id1 and l1.id1<>l2.id2) as temp
where h1.id=temp.id1 and h2.ID=temp.id2 and h3.ID=temp.id3;

/*Find those students for whom all of their friends are in different grades from themselves. Return the students' 
names and grades. */
select name,grade
from(
	select distinct friend.ID1, h3.name,h3.grade
	from friend,highschooler h3
	where friend.ID1=h3.ID and friend.ID1 not in (select distinct id1
												 from friend,highschooler h1, highschooler h2
												 where friend.ID1=h1.ID and friend.ID2=h2.ID and h1.grade=h2.grade)
	) as temp;
    
/*What is the average number of friends per student? (Your result should be just one number.) */
select avg(friendcount)
from(
	select id1 as id, count(id2) as friendcount
	from friend
	group by id1
	union
	select id,0
	from highschooler
	where id not in (select id1 from friend)) as temp;
    
/*Find the number of students who are either friends with Cassandra or are friends of friends of 
Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. */
select count(id)
from (
	select id2 as id
	from (
		select f1.id2,f2.id2 as id3
		from friend f1,friend f2
		where f1.ID2=f2.ID1 and f1.id1 in (select id from Highschooler where name='Cassandra') and f2.id2 not in (select id from Highschooler where name='Cassandra') ) as temp1
	union
	select id3 as id
	from (
		select f1.id2,f2.id2 as id3
		from friend f1,friend f2
		where f1.ID2=f2.ID1 and f1.id1 in (select id from Highschooler where name='Cassandra') and f2.id2 not in (select id from Highschooler where name='Cassandra') ) as temp2) as temp;
        
/*Find the name and grade of the student(s) with the greatest number of friends. */
select name,grade
from highschooler
where id in(select id from(select id1 as id, count(id2) as friendcount	from friend	group by id1) as temp2 
						where temp2.friendcount=(select max(friendcount) 
												from(select id1 as id, count(id2) as friendcount from friend group by id1) as temp1));