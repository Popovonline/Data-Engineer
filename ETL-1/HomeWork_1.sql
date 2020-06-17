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

--id - ���������� ����������� ����
--film_key - ����������� ����, ���� id �� ������� films_raw
--start_ts - ������ �� �������, ����� ������ ������ ����� ���������. �������� �� ��������� - 1900-01-01
--end_ts - ������ �� �������, ����� ������ ������ ��������� ���� ����������. �������� �� ��������� - 2999-12-31
--is_current - ����, ������������, �������� �� ������ ������ ������� ����������� ��������� (1 - ��, 0 - ���)
--create_ts - ���� � ����� ���������� ������
--update_ts - ���� � ����� ���������� ������
	
	/* Create table of films*/
create table films (
	id serial primary key,
	film_key integer references films_raw (id), -- ��� ������ ��� ������ SQL Error [42830]: ������: � ������� ������� ������� "films_raw" ��� ����������� ������������, ���������������� ������ ������
	start_ts date not null,
	end_ts date not null,
--	is_current, ��� ��� �� ��� �����? ������� �� ����������� � ����� �������� ����� �� ���������?
	create_ts date not null, -- ����� �������� �� ���������? � ������� ������ �� �������
	update_ts date not null, -- ����� �������� �� ���������? � ������� ������ �� �������
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


