
--Creating database where tables will be stored
CREATE DATABASE IF NOT EXISTS ecommerce_analysis;



--Table creating
CREATE TABLE IF NOT EXISTS ecommerce_table (
    id              SERIAL          PRIMARY KEY,
    invoice_no      VARCHAR(20),
    stock_code      VARCHAR(20)     NOT NULL,
    description     TEXT,
    quantity        INT             NOT NULL,
    invoice_date    TIMESTAMP       NOT NULL,
    unit_price      DECIMAL(10,2)   NOT NULL,
    customer_id     VARCHAR(20),
    country         VARCHAR(50),
    date            DATE,
    invoice_time    TIME,
    invoice_day     INT,
    invoice_month   INT,
    invoice_year    INT,
    day_of_week     VARCHAR(15),
    invoice_hour    INT,
    total_price     DECIMAL(10,2)
);

ALTER TABLE ecommerce_table ALTER COLUMN stock_code TYPE VARCHAR(50);

--Import dataset to the table
COPY ecommerce_table (invoice_no, stock_code, description, quantity, invoice_date, unit_price, customer_id, country, date, invoice_time, invoice_day, invoice_month, invoice_year, day_of_week, invoice_hour, total_price)
FROM 'C:\\Users\\lelik\\Desktop\\vs\\AlexIrnazarovPet_projects\\E-commerceAnalysis\\Data\\ecommerce_cleaned.csv'
DELIMITER ','
CSV HEADER;




