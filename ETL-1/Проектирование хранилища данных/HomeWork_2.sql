CREATE SCHEMA dim;
CREATE SCHEMA fact;

DROP TABLE IF EXISTS dim.date;
CREATE TABLE dim.date
AS
WITH dates AS (
    SELECT dd::date AS dt
    FROM generate_series
            ('2010-01-01'::timestamp
            , '2030-01-01'::timestamp
            , '1 day'::interval) dd
)
SELECT
    to_char(dt, 'YYYYMMDD')::int AS id,
    dt AS date,
    to_char(dt, 'YYYY-MM-DD') AS ansi_date,
    date_part('isodow', dt)::int AS day,
    date_part('week', dt)::int AS week_number,
    date_part('month', dt)::int AS month,
    date_part('isoyear', dt)::int AS year,
    (date_part('isodow', dt)::smallint BETWEEN 1 AND 5)::int AS week_day,
    (to_char(dt, 'YYYYMMDD')::int IN (
        20130101,
        20130102,
        20130103,
        20130104,
        20130105,
        20130106,
        20130107,
        20130108,
        20130223,
        20130308,
        20130310,
        20130501,
        20130502,
        20130503,
        20130509,
        20130510,
        20130612,
        20131104,
        20140101,
        20140102,
        20140103,
        20140104,
        20140105,
        20140106,
        20140107,
        20140108,
        20140223,
        20140308,
        20140310,
        20140501,
        20140502,
        20140509,
        20140612,
        20140613,
        20141103,
        20141104,
        20150101,
        20150102,
        20150103,
        20150104,
        20150105,
        20150106,
        20150107,
        20150108,
        20150109,
        20150223,
        20150308,
        20150309,
        20150501,
        20150504,
        20150509,
        20150511,
        20150612,
        20151104,
        20160101,
        20160102,
        20160103,
        20160104,
        20160105,
        20160106,
        20160107,
        20160108,
        20160222,
        20160223,
        20160307,
        20160308,
        20160501,
        20160502,
        20160503,
        20160509,
        20160612,
        20160613,
        20161104,
        20170101,
        20170102,
        20170103,
        20170104,
        20170105,
        20170106,
        20170107,
        20170108,
        20170223,
        20170224,
        20170308,
        20170501,
        20170508,
        20170509,
        20170612,
        20171104,
        20171106,
        20180101,
        20180102,
        20180103,
        20180104,
        20180105,
        20180106,
        20180107,
        20180108,
        20180223,
        20180308,
        20180309,
        20180430,
        20180501,
        20180502,
        20180509,
        20180611,
        20180612,
        20181104,
        20181105,
        20181231,
        20190101,
        20190102,
        20190103,
        20190104,
        20190105,
        20190106,
        20190107,
        20190108,
        20190223,
        20190308,
        20190501,
        20190502,
        20190503,
        20190509,
        20190510,
        20190612,
        20191104,
        20200101, 20200102, 20200103, 20200106, 20200107, 20200108,
       20200224, 20200309, 20200501, 20200504, 20200505, 20200511,
       20200612, 20201104))::int AS holiday
FROM dates
ORDER BY dt;

ALTER TABLE dim.date ADD PRIMARY KEY (id);

drop table dim.customer cascade;

CREATE TABLE dim.customer (
    id int not null primary key,
    customer_key int not null,
    name varchar(100) not null,
    gender char(1) not null,
    birth_date date,
    address varchar(500),
    city varchar(100),
    region varchar(100),
    phone bigint,
    email varchar(100),
    status varchar(30)
);

INSERT INTO dim.customer
    (id,
    customer_key,
    name,
    gender,
    birth_date,
    address,
    city,
    region,
    phone,
    email,
    status)
WITH active AS (
    SELECT DISTINCT customer_id
    FROM nds.sale_item si
    WHERE dt BETWEEN now() - INTERVAL '1 YEAR' AND now()
)
SELECT
    cust.id,
    cust.customer_id,
    full_name,
    gender,
    birth_date,
    a.name || ', ' || c.name || ', ' || r.name as address,
    c.name as city,
    r.name as region,
    phone,
    email,
    CASE WHEN active.customer_id IS NOT NULL THEN 'Активен' ELSE 'Не активен' END AS status
FROM nds.customer cust
JOIN nds.address a on a.id = cust.address_id
JOIN nds.city c on c.id = a.city_id
JOIN nds.region r on r.id = c.region_id
LEFT JOIN active on active.customer_id = cust.id
;

drop table dim.store cascade;

CREATE TABLE dim.store (
    id int not null primary key,
    store_key int not null,
    title varchar(100) not null,
    address varchar(500),
    city varchar(100),
    region varchar(100),
    prev_region varchar(100),
    store_type varchar(20),
    prev_region_date date
);

INSERT INTO dim.store(id, store_key, title, address, city, region, prev_region, store_type, prev_region_date)
WITH t as (
    SELECT
        store_id as id,
        store_id as store_key,
        title,
        a.name as address,
        c.name as city,
        r.name as region,
        coalesce(lag(r.name) over w, r.name) as prev_region,
        lead(r.name) over w as next_region,
        positions_cnt,
        date_open
    FROM nds.store s
    JOIN nds.address a on a.id = s.address_id
    JOIN nds.city c on c.id = a.city_id
    JOIN nds.region r on r.id = c.region_id
    WINDOW w AS (PARTITION BY store_id ORDER BY date_open)
)
SELECT
        id,
        store_key,
        title,
        address,
        city,
        region,
        prev_region,
        CASE WHEN positions_cnt < 1000 THEN 'м' ELSE 'б' END AS store_type,
        date_open
FROM t
WHERE next_region is null;

DROP TABLE IF EXISTS dim.product CASCADE;
CREATE TABLE dim.product (
    id serial not null primary key,
    code varchar(20) not null,
    name varchar(250) not null,
    artist varchar(150) not null,
    product_type varchar(20) not null,
    product_category varchar(150) not null,
    unit_price float8 not null,
    unit_cost float8 not null,
    status varchar(100) not null,
    effective_ts date not null,
    expire_ts date not null,
    is_current bool
);


INSERT INTO dim.product (code, name, artist, product_type, product_category, unit_price, unit_cost, status, effective_ts, expire_ts, is_current)
SELECT * FROM (
	WITH genres as (
		SELECT DISTINCT m2g.music_id, first_value(g.name) over (partition by music_id order by genre_id) as genre_id
		FROM nds.music_to_genres m2g
		JOIN nds.genres g on g.id = m2g.genre_id)
	SELECT
		m.id :: varchar as code,
		m.album as name,
		coalesce(a.name, 'Неизвестно') as artist,
		'Музыка' as product_type,
		coalesce(genres.genre_id, 'Неизвестно') as product_category,
		m.price as unit_price,
		m.cost as unit_cost,
		CASE
			WHEN m.status = 'p' THEN 'Ожидается'
			WHEN m.status = 'o' THEN 'Доступен'
			WHEN m.status = 'e' THEN 'Не продается'
		END AS status,
		m.start_ts as effective_ts,
		m.end_ts as expire_ts,
		m.is_current
	FROM nds.music m
	LEFT JOIN nds.artists a on a.id = m.artist_id
	LEFT JOIN genres on genres.music_id = m.id
	
	UNION ALL
	
	(
	WITH authors AS (
		SELECT DISTINCT bta.book_id, first_value(ba."name") OVER (PARTITION BY bta.book_id ORDER BY bta.author_id) AS author_name
		FROM nds.book_to_author bta
		JOIN nds.book_author ba ON ba.id = bta.author_id)
	SELECT
		b.id :: varchar AS code,
		b.nomenclature AS name,
		coalesce(a.author_name, 'Неизвестно') as artist,
		'Книги' as product_type,
		coalesce(bc.name, 'Неизвестно') as product_category,
		b.price AS unit_price,
		b.cost AS unit_cost,
		CASE
			WHEN b.status = 'p' THEN 'Ожидается'
			WHEN b.status = 'o' THEN 'Доступен'
			WHEN b.status = 'e' THEN 'Не продается'
		END AS status,
		b.start_ts as effective_ts,
		b.end_ts as expire_ts,
		b.is_current
	FROM nds.book b
	LEFT JOIN authors a ON a.book_id = b.id
	LEFT JOIN nds.book_category bc ON bc.id = b.category_id
	)
	
	UNION ALL
	
	(
	WITH directors AS (
		SELECT DISTINCT ftd.film_id, first_value(fd."name") OVER (PARTITION BY ftd.film_id ORDER BY ftd.director_id) AS director_name
		FROM nds.films_to_director ftd
		JOIN nds.films_director fd ON fd.id = ftd.director_id)
	SELECT
		f.id :: varchar AS code,
		f.title AS name,
		coalesce(d.director_name, 'Неизвестно') AS artist,
		'Фильмы' as product_type,
		coalesce(fg.name, 'Неизвестно') as product_category,
		f.price AS unit_price,
		f.cost AS unit_cost,
		CASE
			WHEN f.status = 'p' THEN 'Ожидается'
			WHEN f.status = 'o' THEN 'Доступен'
			WHEN f.status = 'e' THEN 'Не продается'
		END AS status,
		f.start_ts as effective_ts,
		f.end_ts as expire_ts,
		f.is_current
	FROM nds.films f
	LEFT JOIN directors d ON d.film_id = f.id
	LEFT JOIN nds.films_genre fg ON fg.id = f.genre_id
	)
) s;


DROP TABLE IF EXISTS fact.sale_item CASCADE;
CREATE TABLE fact.sale_item (
	date_key int not null references dim.date(id),
	customer_key int not null references dim.customer(id),
	store_key int NOT NULL REFERENCES dim.store(id),
	product_key int references dim.product(id),
	transaction_id int not null,
	line_number smallint not null,
	quantity smallint not null,
	unit_price float8,
	unit_cost float8,
	sales_value float8,
	sales_cost float8,
	margin float8
);


INSERT INTO fact.sale_item (date_key, customer_key, store_key, product_key, transaction_id, line_number, quantity, unit_price, unit_cost, sales_value, sales_cost, margin)
SELECT
	to_char(si.dt, 'YYYYMMDD')::int as date_key,
	si.customer_id,
	si.store_id,
	p.id,
	si.transaction_id, si.line_number, si.quantity,
	p.unit_price, p.unit_cost, p.unit_price * si.quantity, p.unit_cost * si.quantity, p.unit_price * si.quantity - p.unit_cost * si.quantity
FROM nds.sale_item si
JOIN dim.product p ON p.code :: int = si.book_id AND p.product_type = 'Книги'

UNION

SELECT
	to_char(si.dt, 'YYYYMMDD')::int as date_key,
	si.customer_id,
	si.store_id,
	p.id,
	si.transaction_id, si.line_number, si.quantity,
	p.unit_price, p.unit_cost, p.unit_price * si.quantity, p.unit_cost * si.quantity, p.unit_price * si.quantity - p.unit_cost * si.quantity
FROM nds.sale_item si
JOIN dim.product p ON p.code :: int = si.film_id AND p.product_type = 'Фильмы'

UNION

SELECT
	to_char(si.dt, 'YYYYMMDD')::int as date_key,
	si.customer_id,
	si.store_id,
	p.id,
	si.transaction_id, si.line_number, si.quantity,
	p.unit_price, p.unit_cost, p.unit_price * si.quantity, p.unit_cost * si.quantity, p.unit_price * si.quantity - p.unit_cost * si.quantity
FROM nds.sale_item si
JOIN dim.product p ON p.code :: int = si.music_id AND p.product_type = 'Музыка'

select * from fact.sale_item;
;