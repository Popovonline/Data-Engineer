--DROP TABLE fact_flights;
CREATE TABLE fact_flights (
	flight_id serial NOT NULL,
	flight_no bpchar(6) NOT NULL,
	passenger_id varchar(20) NOT NULL,
	actual_departure bigint NOT NULL,
	actual_arrival bigint NOT NULL,
	departure_delay_sec int NOT NULL,
	arrival_delay_sec int NOT NULL,
	aircraft_code bpchar(3) NOT NULL,
	departure_airport bpchar(3) NOT NULL,
	arrival_airport bpchar(3) NOT NULL,
	tariff_key SMALLINT NOT NULL,
	amount NUMERIC NOT NULL,
	CONSTRAINT fact_flights_pkey PRIMARY KEY (flight_id, passenger_id),
	CONSTRAINT fact_flights_passenger_id_fkey FOREIGN KEY (passenger_id) REFERENCES dim_passengers(passenger_id),
	CONSTRAINT fact_flights_aircraft_code_fkey FOREIGN KEY (aircraft_code) REFERENCES dim_aircrafts(aircraft_code),
	CONSTRAINT fact_flights_departure_airport_fkey FOREIGN KEY (departure_airport) REFERENCES dim_airports(airport_code),
	CONSTRAINT fact_flights_arrival_airport_fkey FOREIGN KEY (arrival_airport) REFERENCES dim_airports(airport_code),
	CONSTRAINT fact_flights_tariff_key_fkey FOREIGN KEY (tariff_key) REFERENCES dim_tariffs(tariff_key)
);