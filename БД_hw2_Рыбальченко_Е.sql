
-- Рыбальченко Елена Павловна
-- Системы хранения и обработки данных
-- Домашнее задание №2
-- "Основные операторы PostgreSQL"

-- Цель:
-- Научиться работать с основными операторами PostgreSQL,
-- фильтровать таблицы по разным условиям,
-- писать вложенные запросы, объединять таблицы

-- 0.Создать таблицы со следующими структурами
-- и загрузить данные из csv-файлов. 

-- ОТВЕТ:
-- Создание таблицы customer:
create table customer_hw2(
customer_id int4 not null
,first_name text
,last_name text
,gender text
,DOB varchar(10)
,job_title text
,job_industry_category text
,wealth_segment text
,deceased_indicator text
,owns_car varchar(3)
,address text
,postcode text
,state text
,country text
,property_valuation int4
);
-- Создание первичного ключа:
alter table customer_hw2 add primary key (customer_id);

-- drop table transaction_hw2 ;
-- Создание таблицы transaction:
create table transaction_hw2(
 transaction_id int4 not null
,product_id int4 not null
,customer_id int4 not null
,transaction_date varchar(10)
,online_order text
,order_status text
,brand text
,product_line text
,product_class text
,product_size text
,list_price float4
,standart_cost float4
)
-- Создание первичного ключа:
alter table transaction_hw2 add primary key (transaction_id);

-- Импорт данных производится средствами DBeaver из csv-файлов,
-- скриншоты прилагаются.

-- 1. Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов.

-- ОТВЕТ:
select distinct brand
from transaction_hw2 t
where standart_cost > 1500; 

-- 2. Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно.

-- ОТВЕТ:
select *
from transaction_hw2 t
where order_status  = 'Approved' 
	and transaction_date::date between '2017-04-01' and '2017-04-09';

-- 3. Вывести все профессии у клиентов из сферы IT или Financial Services,
-- которые начинаются с фразы 'Senior'.

-- ОТВЕТ:
select distinct job_title 
from customer_hw2 c
where job_industry_category in ('IT', 'Financial Services') 
	and job_title like 'Senior%';

-- 4. Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services.

-- ОТВЕТ:
select distinct brand, job_industry_category
from transaction_hw2 t,customer_hw2 c 
where job_industry_category in ('Financial Services');

-- 5. Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles',
-- 'Norco Bicycles', 'Trek Bicycles'.

-- ОТВЕТ:
select customer_id , brand,online_order
from transaction_hw2 t 
where brand in ('Giant Bicycles','Norco Bicycles', 'Trek Bicycles') 
	and online_order like 'T%'
limit 10;

-- 6. Вывести всех клиентов, у которых нет транзакций. 
 
-- ОТВЕТ:
select *
from customer_hw2 c
left join transaction_hw2 t on c.customer_id = t.customer_id 
where t.customer_id is null;


-- 7. Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.

-- ОТВЕТ:
-- 
select *
from transaction_hw2 t
right join customer_hw2 c on c.customer_id = t.customer_id 
where c.job_industry_category = 'IT' 
	and  t.standart_cost = (select max(t.standart_cost) from transaction_hw2 t);


-- 8. Вывести всех клиентов из сферы IT и Health, 
--у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'.

-- ОТВЕТ:
-- Можно было применить другие виды join, но для разнообразия выбраны все виды

select *
from customer_hw2 c
full join transaction_hw2 t on c.customer_id = t.customer_id 
where c.job_industry_category in ('IT','Health') 
	and t.order_status like 'App%' 
	and t.transaction_date::date  between '2017-07-07' and '2017-07-17' ;
	