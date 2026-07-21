-- análise retenção de clientes
WITH safra_clientes AS (
SELECT c.customer_unique_id,
DATE_FORMAT(MIN(o.order_purchase_timestamp), '%Y-%m-01') AS mes_safra
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
),
historico_compras AS (
SELECT c.customer_unique_id,s.mes_safra,
DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') AS mes_compra
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN safra_clientes s ON c.customer_unique_id = s.customer_unique_id
WHERE o.order_status = 'delivered'
),
idade_compras AS (
SELECT mes_safra,mes_compra,customer_unique_id,
TIMESTAMPDIFF(MONTH, STR_TO_DATE(mes_safra, '%Y-%m-%d'), STR_TO_DATE(mes_compra, '%Y-%m-%d')) AS mes_vida
FROM historico_compras
)
SELECT mes_safra,mes_vida,
COUNT(DISTINCT customer_unique_id) AS clientes_ativos
FROM idade_compras
WHERE mes_safra >= '2017-01-01' 
GROUP BY mes_safra, mes_vida
ORDER BY mes_safra, mes_vida;