CREATE DATABASE dwh_bookings;

--DROP TABLE dim_calendar;
CREATE TABLE dim_calendar
AS
WITH dates AS (
	SELECT dd::date AS dt
	FROM generate_series (
		'2017-01-01'::timestamp,
		'2030-01-01'::timestamp,
		'1 day'::INTERVAL
	) dd
)
SELECT
	to_char(dt, 'YYYYMMDD')::int AS id,
	dt AS date,
	to_char(dt, 'YYYY-MM-DD') AS ansi_date,
	date_part('isodow', dt)::int AS "day",
	date_part('week', dt)::int AS week_number,
	date_part('month', dt)::int AS "month",
	date_part('isoyear', dt)::int AS "year",
	(date_part('isodow', dt)::SMALLINT BETWEEN 1 AND 5)::int AS week_day,
	(to_char(dt, 'YYYYMMDD')::int IN (
		20170101,
		20180101,
		20190101,
		20200101,
		20210101,
		20220101,
		20230101,
		20240101,
		20250101,
		20260101,
		20270101,
		20280101,
		20290101,
		20300101
		)	
	)::int AS holiday
FROM dates
ORDER BY dt;

ALTER TABLE dim_calendar ADD PRIMARY KEY (id);

--DROP TABLE dim_passengers;
CREATE TABLE dim_passengers (
	passenger_id varchar(20) NOT NULL,
	passenger_name text NOT NULL,
	email varchar(50),
	phone varchar(15),
	CONSTRAINT dim_passengers_pkey PRIMARY KEY (passenger_id)
);

--DROP TABLE dim_aircrafts;
CREATE TABLE dim_aircrafts (
	aircraft_code varchar(5),
	model varchar(50) NOT NULL,
	"range" int NOT NULL,
	CONSTRAINT dim_aircrafts_pkey PRIMARY KEY (aircraft_code)
);

--DROP TABLE dim_airports;
CREATE TABLE dim_airports (
	airport_code char(3),
	airport_name varchar(50) NOT NULL,
	city varchar(30) NOT NULL,
	coordinates varchar(45) NOT NULL,
	timezone varchar(20) NOT NULL,
	CONSTRAINT dim_airports_pkey PRIMARY KEY (airport_code)
);

--DROP TABLE dim_tariffs;
CREATE TABLE dim_tariffs (
	tariff_key SMALLINT,
	tariff varchar(10) NOT NULL,
	CONSTRAINT dim_tariff_pkey PRIMARY KEY (tariff_key)
);