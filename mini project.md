# Mini project


### 1 Выводим количество пользователей в периоде
 Markdown
```sql
select count(distinct user_id)
from users
where dates between '2023-11-07' and '2023-11-15';

select dates from users;
```

### 2 Определили пользователя, который за весь перио посмотрел наибольшее количество обьявлении
```sql
select user_id, sum(view_adverts) as sum_adv
from users
group by user_id
order by sum_adv desc
limit 1;
```

### 3 Дни с наибольшим средним количеством просмотренных рекламных обьявлении на пользователя, но учитываем только дни с более чем 500 уникальными пользователями
```sql select dates, avg(view_adverts), count(distinct user_id)
from users
group by dates
having count(distinct user_id)> 500
order by avg(view_adverts) desc
limit 1;
```

### 4 Продолжительност ьприсутствия пользователя на сайте
```sql select user_id, count(distinct dates) as LT
from users
group by user_id
order by LT desc;
```

### 5 Для каждого пользователя подситаем среднее кол. просмотренной рекламы за день, затем выясняем, у кого самый самый высокий сред. показатель среди тех, кто был активенкак мин. 5 разных дней
```sql select user_id, avg(view_adverts), count(distinct dates)
from users
group by user_id
having count(distinct dates) >= 5
order by avg(view_adverts) desc
limit 1;
```

### Создаем новую базу данных mini_project у которых есть 2 таблицы
```sql create database mini_project;

create table T_TAB1(
ID INT,
GOODS_TYPE VARCHAR(20),
QUANTITY INT,
AMOUNT INT,
SELLER_NAME VARCHAR(50)
); 

create table T_TAB2(
ID INT,
NAME VARCHAR(20),
SALARY INT,
AGE INT
);

insert into t_tab1 (id, goods_type, quantity, amount, seller_name)
values
(1, 'MOBILE PHONE', 2, 400000, 'MIKE'),
(2, 'KEYBOARD', 1,10000, 'MIKE'),
(3, 'MOBILE PHONE', 1, 50000, 'JANE'),
(4, 'MONITOR', 1, 110000,'JOE'),
(5,'MONITOR', 2, 80000, 'JANE'),
(6,'MOBILE PHONE',1,130000, 'JOE,'),
(7, 'MOBILE PHONE', 1, 60000, 'AN,NA'),
(8, 'PRINTER', 1, 90000, 'ANNA'),
(9, 'KEYBOARD', 2, 10000, 'ANNA'),
(10, 'PRINTER', 1, 80000, 'MIKE');

create table T_TAB2
(
ID INT UNIQUE,
NAME VARCHAR(20),
SALARY INT,
AGE INT
);

insert into t_tab2 (id, name, salary, age)
values
( 1, 'ANNA', 110000, 27),
(2,'JANE',80000, 25),
(3, 'MIKE', 120000, 25),
(4, 'JOE', 120000, 25),
(5, 'RITA', 120000, 29);
```
### Уникальные категории товаров и их количество
```sql
select distinct goods_type from t_tab1;
select count(distinct goods_type) from t_tab1; 
```
### 2.2 Суммарное количество и суммарный стоимость товаров
```sql select sum(amount), sum(quantity)
from t_tab1
where goods_type = 'mobile phone';
```

### 2.3
```sql select name, salary
from t_tab2
where salary > 100000;
```

### 2.4
```sql select min(salary), max(salary), min(age), max(age)
from t_tab2;
```

### 2.5
```sql select avg(quantity)
from t_tab1
where goods_type in ('keyboard',' printer');
```

### 2.6
```sql select name, sum(amount)
from t_tab1 t1
join t_tab2 t2
on t1.seller_name = t2.name 
group by t2.name;
```
### 2.7
``` sql select t2.name, t1.goods_type, t2.age, t2.salary, t1.quantity, t1.amount
from t_tab1 t1
join t_tab2 t2
on t1.seller_name = t2.name 
where name = 'MIKE';
```

### 2.8
```sql select t2.name, t2.age
from t_tab2 t2
 left join t_tab1 t1
on t1.SELLER_NAME = t2.NAME
where t1.id is null;
```

### 2.9
```sql select name ,salary, age
from t_tab2
where age < 26;
```

### 2.10
```sql SELECT * FROM T_TAB1 t
JOIN T_TAB2 t2 ON t2.name = t.seller_name
WHERE t2.name = 'RITA';
```







