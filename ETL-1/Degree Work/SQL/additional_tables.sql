--DROP TABLE dim_passengers_rejected;
CREATE TABLE dim_passengers_rejected (
	passenger_id varchar(20) NOT NULL,
	passenger_name text NOT NULL,
	email varchar(50),
	phone varchar(15),
	CONSTRAINT dim_passengers_rejected_pkey PRIMARY KEY (passenger_id)
);

--DROP TABLE dim_aircrafts_rejected;
CREATE TABLE dim_aircrafts_rejected (
	aircraft_code varchar(5),
	model varchar(50) NOT NULL,
	"range" int NOT NULL,
	CONSTRAINT dim_aircrafts_rejected_pkey PRIMARY KEY (aircraft_code)
);

--DROP TABLE dim_airports_rejected;
CREATE TABLE dim_airports_rejected (
	airport_code char(3),
	airport_name varchar(50) NOT NULL,
	city varchar(30) NOT NULL,
	coordinates varchar(45) NOT NULL,
	timezone varchar(20) NOT NULL,
	CONSTRAINT dim_airports_rejected_pkey PRIMARY KEY (airport_code)
);

--DROP TABLE dim_tariffs_rejected;
CREATE TABLE dim_tariffs_rejected (
	tariff_key SMALLINT,
	tariff varchar(10) NOT NULL,
	CONSTRAINT dim_tariffs_rejected_pkey PRIMARY KEY (tariff_key)
);

--DROP TABLE tickets_passengers;
CREATE TABLE tickets_passengers (
	ticket_no varchar(20) NOT NULL,
	passenger_id varchar(20) NOT NULL,
	passenger_name text NOT NULL,
	email varchar(50),
	phone varchar(15),
	CONSTRAINT tickets_passengers_pkey PRIMARY KEY (ticket_no)
);

--DROP TABLE tickets_tariffs;
CREATE TABLE tickets_tariffs (
	ticket_no varchar(20) NOT NULL,
	flight_id int NOT NULL,
	tariff_key SMALLINT NOT NULL,
	tariff varchar(10) NOT NULL,
	amount NUMERIC NOT NULL,
	CONSTRAINT tickets_tariffs_pkey PRIMARY KEY (ticket_no, flight_id)
);

--DROP TABLE tickets_passengers_rejected;
CREATE TABLE tickets_passengers_rejected (
	ticket_no varchar(20) NOT NULL,
	passenger_id varchar(20) NOT NULL,
	passenger_name text NOT NULL,
	email varchar(50),
	phone varchar(15),
	CONSTRAINT tickets_passengers_rejected_pkey PRIMARY KEY (ticket_no)
);

--DROP TABLE tickets_tariffs_rejected;
CREATE TABLE tickets_tariffs_rejected (
	ticket_no varchar(20) NOT NULL,
	flight_id int NOT NULL,
	tariff_key SMALLINT NOT NULL,
	tariff varchar(10) NOT NULL,
	amount NUMERIC NOT NULL,
	CONSTRAINT tickets_tariffs_rejected_pkey PRIMARY KEY (ticket_no, flight_id)
);

--DROP TABLE fact_flights_rejected;
CREATE TABLE fact_flights_rejected (
	flight_id serial NOT NULL,
	flight_no bpchar(6) NOT NULL,
	passenger_id varchar(20) NOT NULL,
	actual_departure timestamp NOT NULL,
	actual_arrival timestamp NOT NULL,
	departure_delay_sec int NOT NULL,
	arrival_delay_sec int NOT NULL,
	aircraft_code bpchar(3) NOT NULL,
	departure_airport bpchar(3) NOT NULL,
	arrival_airport bpchar(3) NOT NULL,
	tariff_key SMALLINT NOT NULL,
	amount NUMERIC NOT NULL,
	CONSTRAINT fact_flights_rejected_pkey PRIMARY KEY (flight_id, passenger_id)
);