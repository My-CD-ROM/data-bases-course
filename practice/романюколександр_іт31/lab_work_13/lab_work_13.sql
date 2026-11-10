SELECT printf("%.2f тов.", quantity)
FROM orders

SELECT printf("%5d тов.", quantity)
FROM orders

SELECT date(order_date, "+7 days") AS "відправлено"
FROM orders
WHERE status = "замовлено"

SELECT strftime("%Y-%m", order_date) AS order_month, COUNT(*)
FROM orders
GROUP BY order_month

SELECT strftime("%Y", "not-a-date")