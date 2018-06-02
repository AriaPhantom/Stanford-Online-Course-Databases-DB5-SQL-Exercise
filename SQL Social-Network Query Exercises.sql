use demo2;

/*Find the names of all students who are friends with someone named Gabriel.*/
select name 
from highschooler
where ID in (select ID2 from friend where ID1 in (select ID from highschooler where name='Gabriel'));

/*For every student who likes someone 2 or more grades younger than themselves, return that student's
 name and grade, and the name and grade of the student they like. */
 select h1.name as name1,h1.grade as grade1,h2.name as name2,h2.grade as grade2
 from likes,highschooler as h1,highschooler as h2
 where ID1=h1.ID and ID2=h2.ID and h2.grade-h1.grade<=-2;
 
 
 /*For every pair of students who both like each other, return the name and grade of both students.
 Include each pair only once, with the two names in alphabetical order.  */
select name1,grade1,name2,grade2
from(
	select name1,grade1,name2,grade2,count(Ident) as count
	from (
		select h1.name as name1, h1.grade as grade1,ID1,ID2,h2.name as name2, h2.grade as grade2,ID1*ID2 as Ident
		from likes,highschooler as h1,highschooler as h2
		where likes.ID1=h1.ID and likes.ID2=h2.ID
		) as temp1
	group by temp1.Ident
    ) as temp2
where count=2
order by name1,name2;