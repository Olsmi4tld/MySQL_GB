use example1;

create table storehouses_products (
id serial primary key,
storehouse_id int unsigned,
product_id int unsigned,
value int unsigned comment 'Запас товарной позиции на скалде',
created_at datetime default current_timestamp,
updated_at datetime default current_timestamp on update current_timestamp
) comment = 'Запасы на складе';


insert into
storehouses_products (storehouse_id, product_id, value)
values
(1, 543, 0),
(1, 789, 2500),
(1, 3432, 0),
(1, 826, 30),
(1, 719, 500),
(1, 638, 1);


select * from storehouses_products order by value;

select id, value, IF(value > 0, 0, 1) as sort from storehouses_products order by value;

select * from storehouses_products order by if(value > 0, 0, 1), value;

