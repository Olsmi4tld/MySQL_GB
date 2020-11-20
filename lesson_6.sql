select 
	name,
	surname,
	(select filename from photos where id = u.photo_id) 'personal_photo',
	(select count(*) from 
	(select target_user_id ff from friend_requests where initiator_user_id = u.id and status = 'approved'
		union
	select initiator_user_id ff from friend_requests where initiator_user_id = u.id and status = 'approved') as fr_tbl) 'friends',
	(select count(*) from friend_requests where target_user_id = 1 and status = 'approved') 'followers',
	(select count(*) from photos where user_id = u.id)'photos'
from users u
where id = 2;

select name, surname, phone from users where id in ( select * from 	
	(select 
	case
		when initiator_user_id = 1 and status = 'approved' then target_user_id
		when target_user_id = 1 and status = 'approved' then initiator_user_id
	end as friend_id
	from friend_requests) as fr_tbl where friend_id is not null);
	
select name, surname, phone, 
case (gender)
	when 'm' then 'Мужчина'
	when 'f' then 'Женщина'
end as 'gender',
-- if (gender=='m', 'Мужчина', 'Женщина')
timestampdiff(year, birthday, now()) as 'age'
from users 
where id in ( select * from 	
	(select 
	case
		when initiator_user_id = 1 and status = 'approved' then target_user_id
		when target_user_id = 1 and status = 'approved' then initiator_user_id
	end as friend_id
	from friend_requests) as fr_tbl where friend_id is not null);
	
select
from_user_id,
count(*) 'unread_msg',
(select concat(name, ' ', surname) from users where id  = m.from_user_id)
from messages m where to_user_id = 1 and is_read = 0 group by from_user_id;

select avg(`total_user_news`) 
from 
	(select count(*) as `total_user_news` from posts group by user_id) 
		as count_news_tbl;
		
select (select count(*) from users_communities)/(select count(*) from users);



-- Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки и/или улучшения (JOIN пока не применять).
-- Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

select
	id,
	name,
	surname,
(select count(*) from messages where from_user_id = u.id and to_user_id = 1) 'from',
(select count(*) from messages where to_user_id = u.id and from_user_id = 1) 'to',
(select count(*) from messages where from_user_id = u.id and to_user_id = 1) + (select count(*) from messages where to_user_id = u.id and from_user_id = 1) 'total'
from users u
where id in (
	select target_user_id ff from friend_requests where initiator_user_id = 1 and status = 'approved'
		union
	select initiator_user_id ff from friend_requests where target_user_id = 1 and status = 'approved'
) order by total desc
limit 1;

-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

select 
	u.id,
	u.name, 
	u.surname,
	timestampdiff(year, u.birthday, now()) as 'age',
	count(*) as total_likes
from users u
join posts p 
	on u.id = p.user_id
join likes_posts lp 
	on p.id = lp.post_id
group by u.id
order by age asc, total_likes desc
limit 10;


-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

 -- 1 вариант
SELECT IF(
(SELECT COUNT(*) FROM LIKES_posts WHERE user_id IN (
SELECT user_id FROM users WHERE gender = 'm')
)

(SELECT COUNT(*) FROM LIKES WHERE user_id IN (
SELECT user_id FROM users WHERE gender = 'f')
),
'male', 'female');
WITH SBD as (
SELECT user_id, COUNT(*) as smth FROM friendship
GROUP BY user_id

UNION

SELECT friend_id as user_id, COUNT(*) as smth FROM friendship
GROUP BY friend_id
UNION

SELECT user_id, COUNT(*) as smth FROM users_communities
GROUP BY user_id
UNION

SELECT user_id, COUNT(*) as smth FROM media
GROUP BY user_id
UNION
SELECT from_user_id as user_id, COUNT(*) as smth FROM messages
GROUP BY from_user_id
UNION

SELECT user_id, COUNT(*) as smth FROM likes_posts
GROUP BY user_id)
SELECT user_id, SUM(SBD.smth) AS smth FROM SBD
GROUP BY user_id
ORDER BY smth
LIMIT 10;

 -- 2 вариант
SELECT
gendercounts.gender, MAX(gendercounts.countlikes) as maxcountlikes FROM ( SELECT 'm' as gender, COUNT(*) as countlikes)
FROM likes_posts
WHERE user_id IN ( SELECT user_id
FROM users
WHERE gender = 'm'
)
UNION
SELECT
'f' as gender,
COUNT(*) as countlikes FROM likes_posts lp WHERE user_id IN (
SELECT user_id FROM profiles WHERE gender = 'f' ) ) gendercounts
ORDER BY count_likes DESC
;
SELECT
fromuserid,
MAX(countfromuserid) FROM (SELECT fromuserid, COUNT(*) AS countfromuserid -- кол-во сообщений от fromuserid
FROM messages
WHERE touserid = 1
GROUP BY fromuserid
ORDER BY countfromuserid DESC -- сортировка по убыванию кол-ва сообщений ) countmassages
;
