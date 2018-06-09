use demo2;

/*It's time for the seniors to graduate. Remove all 12th graders from Highschooler. */
delete from highschooler where grade=12;

/*If two students A and B are friends, and A likes B but not vice-versa, remove the 
Likes tuple. */
delete from likes
where exists (select friend.id1 from friend where friend.id1 = likes.id1 and friend.id2=likes.id2)
	  and not exists (select l2.id1 from likes as l2 where l2.id1 = likes.id2 and l2.id2=likes.id1);
      
      
