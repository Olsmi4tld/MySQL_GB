use example1;

DROP TABLE IF EXISTS users_lesson5;
СREATE TABLE users_lesson5 (
id SERIAL PRIMARY KEY,
name varchar(255) comment 'Имя покупателя',
birthday_at datetime comment 'Дата рождения',
created_at datetime,
updated_at datetime
) COMMENT = 'Покупатели';

insert into
users_lesson5 (name, birthday_at, created_at, updated_at)
values
('Gena', '1990-10-05', null, null),
('Natalia', '1984-11-12', null, null),
('Alex', '1985-05-20', null, null),
('Sergey', '1988-02-14', null, null),
('Ivan', '1998-01-12', null, null),
('Marya', '2006-08-29', null, null);
    
update users_lesson5 set created_at = now(), updated_at = now();

DROP TABLE IF EXISTS users_lesson5;
CREATE TABLE users_lesson5 (
id SERIAL PRIMARY KEY,
name varchar(255) comment 'Имя покупателя',
birthday_at datetime comment 'Дата рождения',
created_at varchar(255),
updated_at varchar(255)
) COMMENT = 'Покупатели';


insert into
users_lesson5 (name, birthday_at, created_at, updated_at)
values
('Gena', '1990-10-05', '07.01.2016 12:05', '07.01.2016 12:05'),
('Natalia', '1984-11-12', '07.01.2016 12:05', '07.01.2016 12:05'),
('Alex', '1985-05-20', '07.01.2016 12:05', '07.01.2016 12:05'),
('Sergey', '1988-02-14', '07.01.2016 12:05', '07.01.2016 12:05'),
('Ivan', '1998-01-12', '07.01.2016 12:05', '07.01.2016 12:05'),
('Marya', '2006-08-29', '07.01.2016 12:05', '07.01.2016 12:05');

select str_to_date(created_at, '%d.%m.%Y %k:%i') from users_lesson5;

update
users_lesson5
set
created_at = str_to_date(created_at, '%d.%m.%Y %k:%i'),
updated_at = str_to_date(updated_at, '%d.%m.%Y %k:%i');



alter table
users_lesson5
change
created_at created_at datetime default current_timestamp;

alter table
users_lesson5
change
updated_at updated_at datetime default current_timestamp on update current_timestamp;


describe users_lesson5;

select name, date_format(birthday_at, '%M') from users_lesson5;

select name from users_lesson5 where date_format(birthday_at, '%M') = 'may';

select name from users_lesson5 where date_format(birthday_at, '%M') in ('may', 'august');

select
avg(timestampdiff(year, birthday_at, now())) as age
from
users_lesson5;

select date_format(date(concat_ws('-', year(now()), month(birthday_at), day(birthday_at))), '%W') as day, count(*) as total from users_lesson5 group by day order by total desc;