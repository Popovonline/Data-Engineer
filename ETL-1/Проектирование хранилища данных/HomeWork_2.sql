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
JOIN dim.product p ON p.code :: int = si.book_id AND p.product_type = ' ниги'

UNION

SELECT
	to_char(si.dt, 'YYYYMMDD')::int as date_key,
	si.customer_id,
	si.store_id,
	p.id,
	si.transaction_id, si.line_number, si.quantity,
	p.unit_price, p.unit_cost, p.unit_price * si.quantity, p.unit_cost * si.quantity, p.unit_price * si.quantity - p.unit_cost * si.quantity
FROM nds.sale_item si
JOIN dim.product p ON p.code :: int = si.film_id AND p.product_type = '‘ильмы'

UNION

SELECT
	to_char(si.dt, 'YYYYMMDD')::int as date_key,
	si.customer_id,
	si.store_id,
	p.id,
	si.transaction_id, si.line_number, si.quantity,
	p.unit_price, p.unit_cost, p.unit_price * si.quantity, p.unit_cost * si.quantity, p.unit_price * si.quantity - p.unit_cost * si.quantity
FROM nds.sale_item si
JOIN dim.product p ON p.code :: int = si.music_id AND p.product_type = 'ћузыка'
;