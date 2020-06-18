	/*Initial table*/
select * from films_raw;
__________________________________________________________________________________________________

	/* Create table of film_category*/
create table film_category_new (
	id_category serial primary key,
	category varchar (50) unique not null
);

	/* insert data to film_category*/
select * from film_category_new;
insert into film_category_new (category) select distinct category from films_raw;

	/* Drop table of film_category*/
drop table film_category_new;
__________________________________________________________________________________________________

	/* Create table of name_studio*/
create table name_studio (
	id_name serial primary key,
	name_studio varchar (400) unique not null
);

	/* insert data to name_studio */
select * from name_studio;
insert into name_studio (name_studio) select distinct studio from films_raw;

	/* Drop table of name_studio*/
drop table name_studio;
__________________________________________________________________________________________________

	/* Create table of name_director*/
create table name_director (
	id_director serial primary key,
	name_director varchar (400) unique not null
);

	/* insert data to name_director */ -- есть по несколько имен в id, что не есть хорошо
select * from name_director;
insert into name_director (name_director) select distinct director from films_raw;

	/* Drop table of name_director*/
drop table name_director;
__________________________________________________________________________________________________

	/* Create table of script_author*/
create table script_author (
	id_script_author serial primary key,
	name_script_author varchar (400) unique not null
);

	/* insert data to script_author */ -- есть по несколько имен в id, что не есть хорошо
select * from script_author;
insert into script_author (name_script_author) select distinct script_author from films_raw;

	/* Drop table of script_author*/
drop table script_author;
__________________________________________________________________________________________________

/* Create table of cameraman*/
create table cameraman (
	id_cameraman serial primary key,
	name_cameraman varchar (400) unique not null
);

	/* insert data to cameraman */ -- есть по несколько имен в id, что не есть хорошо
select * from cameraman;
insert into cameraman (name_cameraman) select distinct cameraman from films_raw;

	/* Drop table of cameraman*/
drop table cameraman;
__________________________________________________________________________________________________

/* Create table of age_*/
create table age_ (
	id_age serial primary key,
	title_age varchar (400) unique not null
);

	/* insert data to age_ */ -- есть одно пустое значение, но оно не определенно как null, как его убрать, ведь это выброс?
select * from age_;
insert into age_ (title_age) select distinct age from films_raw;

	/* Drop table of age_*/
drop table age_;

__________________________________________________________________________________________________

/* Create table of genre*/
create table genre (
	id_genre serial primary key,
	name_genre varchar (50) unique not null
);

	/* insert data to genre */ -- -- есть одно пустое значение, но оно не определенно как null, как его убрать, ведь это выброс?
select * from genre;
insert into genre (name_genre) select distinct genre from films_raw;

	/* Drop table of genre*/
drop table genre;

__________________________________________________________________________________________________

/* Create table of country_ */
create table country_ (
	id_country serial primary key,
	name_country varchar (100) unique not null
);

	/* insert data to country_ */ 
select * from country_;
insert into country_ (name_country) select distinct country from films_raw;

	/* Drop table of country_*/
drop table country_;
__________________________________________________________________________________________________


	/* Create table of films*/
create table films as 
select * from films_raw
join <таблицы>

	/* Drop table of films*/
drop table films;


--id - уникальный суррогатный ключ
--film_key - натуральный ключ, поле id из таблицы films_raw - нашел 10 тыс уникальных фильмов 
--start_ts - момент во времени, когда данная запись стала актуальна. Значение по умолчанию - 1900-01-01
--end_ts - момент во времени, когда данная запись перестала быть актуальной. Значение по умолчанию - 2999-12-31
--is_current - флаг, показывающий, является ли данная строка текущим действующим значением (1 - да, 0 - нет)
--create_ts - дата и время добавления записи
--update_ts - дата и время обновления записи


--	По поводу избыточности: необходимо разбросать текстовые поля 
--(кроме title, year и status) по отдельным таблицам, а в таблице films просто ссылаться на них. 
--В случае стран, например, необходимо построить bridge table 
--(http://davidlai101.com/blog/2017/08/03/handling-many-to-many-joins-using-a-bridge-table-part-1/)
