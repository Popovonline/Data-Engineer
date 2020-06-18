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

	/* insert data to name_director */ -- ���� �� ��������� ���� � id, ��� �� ���� ������
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

	/* insert data to script_author */ -- ���� �� ��������� ���� � id, ��� �� ���� ������
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

	/* insert data to cameraman */ -- ���� �� ��������� ���� � id, ��� �� ���� ������
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

	/* insert data to age_ */ -- ���� ���� ������ ��������, �� ��� �� ����������� ��� null, ��� ��� ������, ���� ��� ������?
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

	/* insert data to genre */ -- -- ���� ���� ������ ��������, �� ��� �� ����������� ��� null, ��� ��� ������, ���� ��� ������?
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
join <�������>

	/* Drop table of films*/
drop table films;


--id - ���������� ����������� ����
--film_key - ����������� ����, ���� id �� ������� films_raw - ����� 10 ��� ���������� ������� 
--start_ts - ������ �� �������, ����� ������ ������ ����� ���������. �������� �� ��������� - 1900-01-01
--end_ts - ������ �� �������, ����� ������ ������ ��������� ���� ����������. �������� �� ��������� - 2999-12-31
--is_current - ����, ������������, �������� �� ������ ������ ������� ����������� ��������� (1 - ��, 0 - ���)
--create_ts - ���� � ����� ���������� ������
--update_ts - ���� � ����� ���������� ������


--	�� ������ ������������: ���������� ���������� ��������� ���� 
--(����� title, year � status) �� ��������� ��������, � � ������� films ������ ��������� �� ���. 
--� ������ �����, ��������, ���������� ��������� bridge table 
--(http://davidlai101.com/blog/2017/08/03/handling-many-to-many-joins-using-a-bridge-table-part-1/)
