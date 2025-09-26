CREATE DATABASE ab_testing;
CREATE TABLE ab_testing (

user_id INTEGER,
timestamp TIMESTAMP,
group_name VARCHAR(10),
landing_page VARCHAR(15),
converted INTEGER,
country VARCHAR(5),
PRIMARY KEY (user_id, timestamp)

)


ALTER TABLE ab_testing
ADD CONSTRAINT check_converted CHECK (converted IN (0, 1));



;

COPY ab_testing(user_id, timestamp, group_name, landing_page, converted, country)
FROM 'YOURPATH'
DELIMITER ','
CSV HEADER;

SELECT * FROM ab_testing;