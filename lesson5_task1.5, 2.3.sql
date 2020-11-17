use example1;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT 'Название раздела',
UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';


INSERT INTO catalogs VALUES
(NULL, 'Процессоры'),
(NULL, 'Материнские платы'),
(NULL, 'Видеокарты'),
(NULL, 'Жесткие диски'),
(NULL, 'Оперативная память');

select * from catalogs where id in (5, 1, 2);

select field(0, 5, 1, 2);

select field(2, 5, 1, 2);

select id, name, field(id, 5, 1, 2) as pos from catalogs where id in (5, 1, 2);

select * from catalogs where id in (5, 1, 2) order by field(id, 5, 1, 2);

select exp(ln(1 * 2 * 3 * 4 * 5)), exp(ln(1) + ln(2) + ln(3) + ln(4) + ln(5));
