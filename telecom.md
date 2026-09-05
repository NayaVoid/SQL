# Проект: Анализ и прогнозирование оттока клиентов телеком-оператора.
### Бизнес-задача: Снизить отток клиентов в телекоме.
### SQL-этап: Выгрузка данных, расчет LTV, определение финансовых потерь и когортный анализ.
### Python-этап: Визуализация найденных в SQL аномалий (красивые графики) и обучение ML-модели для прогнозирования.
### Бизнес-рекомендации:«Перевести клиентов с Fiber Optic на годовые контракты, предложив скидку, так как это снизит отток на Х%»).

### Результаты в SQL: Провела финансовый анализ базы данных (7043 строки). Выявила, что компания ежемесячно теряет 30% выручки (139k) из-за оттока клиентов.
### Результаты в Python: [Смотреть проект](https://github.com/NayaVoid/Python/blob/main/Telecom.ipynb)


#### Расчет оттока по контрактам. отток сделаем нумерациямиa + Считаем lifetime value(ltv) и средний чек в разрезе 
```sql
    select churn,  count(customerID) as total_clients,
	   round(avg(if(churn = 'yes', 1, 0))*100,2) as churn_rate ,
       round(avg(monthlycharges),2) as avg_ch ,
       round(avg(tenure),1) as avg_tenure,
       round(avg(coalesce(TotalCharges, 0)),2) as avg_lifetime_value
       from telecom
       group by churn;
```
       
 ### У клиентов со статусом Churn = 'Yes' (ушедшие) показатель avg_lifetime_value (LTV) будет в разы ниже, чем у оставшихся.При этом их avg_monthly_bill (ежемесячный чек) будет выше, чем у лояльных клиентов.
       
      ```sql
	  SELECT customerID, tenure, MonthlyCharges,
    COALESCE(TotalCharges, 0) AS TotalCharges_clean
    FROM telecom;
    ```

```sql
select customerID, totalcharges from telecom where totalcharges is null;
```

```sql
select
 ROUND(SUM(CASE WHEN churn = 'yes' THEN monthlycharges ELSE 0 END), 2) AS lost_monthly_revenue, 
    ROUND(SUM(CASE WHEN churn = 'no' THEN monthlycharges ELSE 0 END), 2) AS active_monthly_revenue, 
    ROUND((SUM(CASE WHEN churn = 'yes' THEN monthlycharges ELSE 0 END) / SUM(monthlycharges)) * 100, 2) AS lost_revenue_percent
FROM telecom;
```

### 2.Анализ по времени жизни. в какой именно период клиенты уходят
```sql
select case
   when tenure<=6 then '0-6 месяцев (Новички)'
   when tenure<=12 then '7-12 месяцев (До года)'
   when tenure<=24 then '1-2года(Стабильные)'
   else 'Лояльные'
  end as customer_ltv,
  count(*) as total_clients,
   round(avg(if(churn ='yes', 1,0))*100,2) as churn_rate
from telecom
group by customer_ltv
order by churn_rate;
 ```

### 3.Найдем идеальный профиль клиента
```sql
SELECT 
    InternetService,
    Contract,
    TechSupport,
    COUNT(*) AS total_clients,
    ROUND(AVG(IF(Churn = 'Yes', 1, 0)) * 100, 2) AS churn_rate_percent,
    ROUND(AVG(TotalCharges), 2) AS avg_ltv
FROM telecom
GROUP BY InternetService, Contract, TechSupport
HAVING total_clients > 100 -- Смотрим только крупные, значимые сегменты
ORDER BY avg_ltv DESC, churn_rate_percent ASC;
```







