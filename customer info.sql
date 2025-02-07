select * from customers;
select * from transactions; 

#Cписок клиентов с непрерывной историей за год, то есть каждый месяц на регулярной основе без пропусков за указанный годовой период, средний чек за период с 01.06.2015 по 01.06.2016, средняя сумма покупок за месяц, количество всех операций по клиенту за период;
WITH monthly_stats AS (
    SELECT 
        DATE_FORMAT(t.date_new, '%Y-%m') AS month,    
        COUNT(DISTINCT t.ID_client) AS clients_count,
        COUNT(t.Id_check) AS operations_count,        
        SUM(t.Sum_payment) AS total_sum,             
        AVG(t.Sum_payment) AS avg_check         
    FROM Transactions t
    WHERE t.date_new BETWEEN '2015-06-01' AND '2016-06-01'
    GROUP BY DATE_FORMAT(t.date_new, '%Y-%m')
),

#информацию в разрезе месяцев:
#средняя сумма чека в месяц;
#среднее количество операций в месяц;
#среднее количество клиентов, которые совершали операции;
#долю от общего количества операций за год и долю в месяц от общей суммы операций;
#вывести % соотношение M/F/NA в каждом месяце с их долей затрат;

annual_totals AS (
    SELECT 
        SUM(operations_count) AS total_operations_year,   
        SUM(total_sum) AS total_sum_year                 
    FROM monthly_stats
),
gender_distribution AS (
    SELECT
        DATE_FORMAT(t.date_new, '%Y-%m') AS month,
        SUM(CASE WHEN c.Gender = 'M' THEN t.Sum_payment ELSE 0 END) AS male_spent,
        SUM(CASE WHEN c.Gender = 'F' THEN t.Sum_payment ELSE 0 END) AS female_spent,
        SUM(CASE WHEN c.Gender IS NULL THEN t.Sum_payment ELSE 0 END) AS na_spent,
        COUNT(DISTINCT CASE WHEN c.Gender = 'M' THEN t.ID_client ELSE NULL END) AS male_count,
        COUNT(DISTINCT CASE WHEN c.Gender = 'F' THEN t.ID_client ELSE NULL END) AS female_count,
        COUNT(DISTINCT CASE WHEN c.Gender IS NULL THEN t.ID_client ELSE NULL END) AS na_count
    FROM Transactions t
    JOIN Customers c ON t.ID_client = c.ID_client
    WHERE t.date_new BETWEEN '2015-06-01' AND '2016-06-01'
    GROUP BY DATE_FORMAT(t.date_new, '%Y-%m')
)
SELECT 
    ms.month,
    ms.avg_check AS average_check_per_month,                
    ms.operations_count AS avg_operations_per_month,         
    ms.clients_count AS avg_clients_per_month,               
    ms.operations_count / at.total_operations_year AS operation_share_per_month, 
    ms.total_sum / at.total_sum_year AS sum_share_per_month, 
    gd.male_spent / ms.total_sum * 100 AS male_share,       
    gd.female_spent / ms.total_sum * 100 AS female_share,  
    gd.na_spent / ms.total_sum * 100 AS na_share,            
    gd.male_count / ms.clients_count * 100 AS male_count_share, 
    gd.female_count / ms.clients_count * 100 AS female_count_share, 
    gd.na_count / ms.clients_count * 100 AS na_count_share  
FROM 
    monthly_stats ms
    CROSS JOIN annual_totals at
    JOIN gender_distribution gd ON ms.month = gd.month
ORDER BY ms.month;

#возрастные группы клиентов с шагом 10 лет и отдельно клиентов, у которых нет данной информации, с параметрами сумма и количество операций за весь период, и поквартально - средние показатели и %.
select 
case 
when age between 0 and 10 then 'to 10'
when age between 10 and 20 then '10-20'
when age between 20 and 30 then '20-30'
when age between 30 and 40 then '30-40'
when age between 40 and 50 then '40-50'
else '50+'
end as age_group,
sum(t.Sum_payment) as total_sales, count(t.Count_products) as total_transactions
from customers c
join transactions t on c.id_client = t.ID_client
group by  age_group;
