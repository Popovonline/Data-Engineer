--ДОМАШНЕЕ ЗАДАНИЕ "Введение в хранилища данных"
--Перед началом работы
--Склонировать репозиторий: https://github.com/Siao-pin/data-engineer
--Загрузить таблицу с фильмами в БД. Для этого необходимо выполнить скрипт lecture1/films_raw.sql
--
--Задание
--Необходимо нормализовать таблицу films_raw (загруженную на предыдущем шаге). Сделать из неё таблицу films таким образом, чтобы вся избыточная информация была разложена по соответствующим таблицам.
--
--Пример: значения из колонки category сложить в таблицу film_category. В таблице films текстовую колонку category заменить на ссылку category_id на таблицу film_category.
--
--Колонки year и status заменять не надо. Обработка year будет в рамках Задачи со звёздочкой. status же имеет всего 3 значения и создание для него отдельной таблицы не имеет смысла (в виде упражнения можно сделать поле типом enum).
--
--Помимо внешних ключей к новым таблицам, которые вы создадите в таблице должны присутствовать поля:
--
--id - уникальный суррогатный ключ
--film_key - натуральный ключ, поле id из таблицы films_raw
--start_ts - момент во времени, когда данная запись стала актуальна. Значение по умолчанию - 1900-01-01
--end_ts - момент во времени, когда данная запись перестала быть актуальной. Значение по умолчанию - 2999-12-31
--is_current - флаг, показывающий, является ли данная строка текущим действующим значением (1 - да, 0 - нет)
--create_ts - дата и время добавления записи
--update_ts - дата и время обновления записи
--
--Указания к выполнению:
--
--Для загрузки файла sql удобно использовать консольную утилиту psql
--Для выполнения задания потребуется работа с массивами https://www.postgresql.org/docs/9.6/functions-array.html
--
--Задание со звёздочкой
--Создать таблицу film_years для связи натурального ID фильма с годом его выпуска. Важно помнить, что года выпуска могу идти через запятую. В этом случае, необходимо добавить каждый год. Также года могут разделяться знаком тире. Это означает, что необходимо внести в таблицу диапазон лет, началом и концом которого являются соответственно левый и правый год.
--
--Пример: для значения year = ‘2008,2010,2012-2015’в таблицу будут записаны года: 2008, 2010, 2012, 2013, 2014, 2015.
	
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

	/* Create table of studio*/
create table studio (
	id_studio serial primary key,
	name_studio varchar (400) unique not null
);

	/* insert data to studio */
select * from studio;

insert into studio (name_studio)
select distinct trim(t.token)
FROM   films_raw fr, unnest(string_to_array(fr.studio, ',')) t(token)
where   trim(t.token) != ''

	/* Drop table of studio*/
drop table studio;
__________________________________________________________________________________________________

	/* Create table of studio_film*/
create table studio_film (
    id_studio_film serial primary key,
    id_studio integer,    
    id_film integer    
);

	/* insert data to studio_film */
select * from studio_film;

insert into studio_film (id_film , id_studio)
select distinct id, st.id_studio from  films_raw fr, unnest(string_to_array(fr.studio, ',')) t(token)
inner join studio st on st.name_studio  = trim(t.token)
where   trim(t.token) != '';

	/* Drop table of studio_film*/
drop table studio_film;

-- !!!!! Bridge Table - films_studios_bridge !!!!!

create table films_studios_bridge (
	id_film integer not null references films(id),
	id_studio integer not null references studio(id_studio)
);

insert into films_studios_bridge (id_film, id_studio) 
with t as (
	select distinct id as film_key, 
	unnest(string_to_array(studio, ', ')) as studio_name
	from films_raw
)
select f.id, s.id_studio
from t
join films f on f.film_key = t.film_key
join studio s on s.name_studio = t.studio_name;

select * from films_studios_bridge;

drop table films_studios_bridge;
__________________________________________________________________________________________________

	/* Create table of director*/
create table director (
	id_director serial primary key,
	name_director varchar (400) unique not null
);

	/* insert data to director */
select * from director;

insert into director (name_director)
select distinct trim(t.token) 
from films_raw fr, unnest(string_to_array(fr.director , ',')) t(token);

	/* Drop table of director*/
drop table director;
__________________________________________________________________________________________________

	/* Create table of director_film*/
create table director_film (
    id_director_film serial primary key,
    id_director integer,    
    id_film integer
);

	/* insert data to director_film */
select * from director_film;

insert into director_film (id_film ,id_director)
select distinct fr.id, d.id_director 
from films_raw fr,  unnest(string_to_array(fr.director , ',')) t(token)
inner join director d on d.name_director  =  trim(t.token) ;

	/* Drop table of director*/
drop table director_film;

-- !!!!! Bridge Table - films_directors_bridge !!!!!

create table films_directors_bridge (
	id_film integer not null references films(id),
	id_director integer not null references director (id_director)
);

insert into films_directors_bridge (id_film, id_director)
with t as  (
	select distinct id AS film_key, 
	unnest(string_to_array(director, ', ')) as name_director
	from films_raw
)
select f.id, d.id_director
from t
join films f on f.film_key = t.film_key
join director d on d.name_director = t.name_director;

select * from films_directors_bridge;

drop table films_directors_bridge;
__________________________________________________________________________________________________

	/* Create table of author*/
create table author (
	id_author serial primary key,
	name_author varchar (400) unique not null
);

	/* insert data to author */
select * from author;

insert into author (name_author)
select distinct trim(t.token) 
from films_raw fr,  unnest(string_to_array(fr.script_author , ',')) t(token);

	/* Drop table of script_author*/
drop table author;
__________________________________________________________________________________________________

	/* Create table of authors_film*/
create table authors_film (
    id_authors_film serial primary key,
    id_author integer,    
    id_film integer
);

	/* insert data to authors_film */
select * from authors_film;

insert into authors_film (id_film,id_author)
select distinct fr.id, a.id_author 
from films_raw fr,  unnest(string_to_array(fr.script_author , ',')) s(token)
inner join author a on a.name_author  =  trim(s.token) ;

	/* Drop table of authors_film*/
drop table authors_film;
__________________________________________________________________________________________________

/* Create table of cameraman*/
create table cameraman (
	id_cameraman serial primary key,
	name_cameraman varchar (400) unique not null
);

	/* insert data to cameraman */
select * from cameraman;

insert into cameraman (name_cameraman)
select distinct trim(t.token) 
from films_raw fr,  unnest(string_to_array(fr.cameraman , ',')) t(token);

	/* Drop table of cameraman*/
drop table cameraman;
__________________________________________________________________________________________________

	/* Create table of cameramans_film*/
create table cameramans_film (
    id_cameramans_film serial primary key,
    id_cameraman integer,    
    id_film integer
);

	/* insert data to cameraman */
select * from cameramans_film;

insert into  cameramans_film (id_film, id_cameraman)
select distinct fr.id, c.id_cameraman 
from films_raw fr,  unnest(string_to_array(fr.cameraman , ',')) t(token)
inner join cameraman c on c.name_cameraman  =  trim(t.token);

	/* Drop table of cameraman*/
drop table cameramans_film;
__________________________________________________________________________________________________

/* Create table of age_*/
create table age_ (
	id_age serial primary key,
	title_age varchar (400) unique not null
);

	/* insert data to age_ */
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

	/* insert data to genre */ 
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

insert into country_ (name_country)
select distinct trim( replace (t.token, E'\n','') )
from films_raw fr,  unnest(string_to_array(fr.country , '|')) t(token)

	/* Drop table of country_*/
drop table country_;
__________________________________________________________________________________________________

	/* Create table of countries_film */
create table countries_film (
    id_countries_film serial primary key,
    id_country integer,    
    id_film integer
);
	/* insert data to countries_film */ 
select * from countries_film;

insert into countries_film (id_film,id_country)
select distinct fr.id, c.id_country
from films_raw fr,  unnest(string_to_array(fr.country , '|')) t(token)
inner join country_ c on c.name_country  =  trim( replace (t.token, E'\n','') ) ;

	/* Drop table of countries_film*/
drop table countries_film; 
__________________________________________________________________________________________________

	/* Create table of status */
create table status (
    id_status serial primary key,
    name_status varchar(10)
);

	/* insert data to status */ 
select * from status;
insert into status (name_status) select distinct status from films_raw;

	/* Drop table of status*/
drop table status; 
__________________________________________________________________________________________________

	/* Create general table of films*/
 
create table films (
    id serial primary key,
    film_key integer, 
    start_ts date default '1900-01-01',
    end_ts date default '2999-12-31',
    is_current integer default 0,
    create_ts date default  now(),
    update_ts date default  now(),
    title varchar(400), 
    id_age integer,
    id_genre integer,
    id_category integer,
    price float,
    cost float,
    id_status integer
);


	/* insert data to films */ 
select * from films;

insert into films (film_key, start_ts, end_ts, is_current, create_ts, update_ts, title,
id_age,
id_genre,
id_category,
price,
cost,
id_status) 
select fr.id,
	to_date(fr.date, 'YYYY-MM-DD' )  start_ts,
	coalesce (lead (to_date(fr.date, 'YYYY-MM-DD' )) over (partition by fr.id  order by to_date(fr.date, 'YYYY-MM-DD' )  ), '2999-12-31' )  end_ts,
	case when lead (to_date(fr.date, 'YYYY-MM-DD' )) over (partition by fr.id  order by to_date(fr.date, 'YYYY-MM-DD' ) ) is null then 1  else 0 end  is_current,
	now() create_ts,
	now() update_ts,
	fr.title, 
	id_age,
	g.id_genre,
	c.id_category,
	cast (fr.price  as float),
	cast (fr.cost  as float),
	s.id_status
from  films_raw fr
inner join status s on s.name_status = fr.status 
inner join age_ a on a.title_age = fr.age 
inner join genre g on g.name_genre = fr.genre 
inner join film_category_new c on c.category = fr.category

	/* Drop table of films*/
drop table films;


-- Task *
	/* Create table of film_years */
create table film_years (
    year integer,
    id_film varchar(10)
);

	/* insert data to film_years */ 
select * from film_years;

with recursive r as (
	select fr.id , fr.dyear, min(t.token) minyear , max(cast( t.token as integer)) maxyear, min(cast(t.token as integer))  currentyear 
	from (
	select  distinct fr.id , trim(t.token) dyear
	from films_raw fr,  unnest(string_to_array(fr.year, ',')) t(token)
	) fr,  unnest(string_to_array(fr.dyear, '-')) t(token)
	group by fr.id ,fr.dyear 	
	union 	
	select  r.id as id,  r.dyear as dyear,   r. minyear  as minyear,  r.maxyear as maxyear, currentyear + 1 as currentyear
	from r 
	where currentyear < r.maxyear
)
insert into film_years (id_film, year)
select id as id_film, currentyear as year from r
order by r.id, r.currentyear;

	/* Drop table of film_years*/
drop table film_years;



