	/*Initial table*/
select * from films_raw;

	/* Create table of film_category*/
create table film_category_new (
	id serial primary key,
	category varchar (50) unique not null
);

	/* insert data */
select * from film_category_new;

insert into film_category_new (category) select distinct category from films_raw 

	/* Drop table of film_category*/
drop table film_category_new;

--id - уникальный суррогатный ключ
--film_key - натуральный ключ, поле id из таблицы films_raw
--start_ts - момент во времени, когда данная запись стала актуальна. Значение по умолчанию - 1900-01-01
--end_ts - момент во времени, когда данная запись перестала быть актуальной. Значение по умолчанию - 2999-12-31
--is_current - флаг, показывающий, является ли данная строка текущим действующим значением (1 - да, 0 - нет)
--create_ts - дата и время добавления записи
--update_ts - дата и время обновления записи
	
	/* Create table of films*/
create table films (
	id serial primary key,
	film_key integer references films_raw (id), -- как убрать эту ошибку SQL Error [42830]: ОШИБКА: в целевой внешней таблице "films_raw" нет ограничения уникальности, соответствующего данным ключам
	start_ts date not null,
	end_ts date not null,
--	is_current, Что это за тип такой? никогда не сталкивался и какие значения будут по умолчанию?
	create_ts date not null, -- какое значение по умолчанию? в задании ничего не сказано
	update_ts date not null, -- какое значение по умолчанию? в задании ничего не сказано
	category integer references film_category_new (id),
	film_name varchar(400) not null
);

--insert into films (film_name, name_category) select title,category from films_raw;
--insert into films (category) select id from film_category_new
--
--select * from films
--
--	/* Drop table of films*/
--drop table films;


