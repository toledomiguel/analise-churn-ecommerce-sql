# 🔍 Análise de Retenção e Churn em E-commerce com SQL Puro

Como se comporta a fidelidade de quem compra no varejo online brasileiro? 

Em vez de importar planilhas prontas no Pandas e sobrecarregar a memória RAM, este projeto extraia, limpa e modela mais de 100 mil registros do e-commerce brasileiro (Dataset da Olist) **diretamente no motor relacional do MySQL 8.0**. 

O objetivo foi construir uma **Cohort Analysis** (Análise de Safra) do zero para entender o ciclo de vida do cliente e provar o famoso "efeito penhasco" de retenção no varejo.

---

## 🛠️ Decisões de Arquitetura e Stack

* **Banco de Dados:** MySQL 8.0
* **Técnicas SQL Aplicadas:** 
  * `LOAD DATA LOCAL INFILE` para ingestão rápida de grandes volumes de dados (100k+ linhas em < 3 segundos).
  * **CTEs Encadeadas (Common Table Expressions)** para modularizar a lógica de identificação de safras sem queries aninhadas ilegíveis.
  * **Window Functions** (`MAX() OVER(PARTITION BY...)`) para cálculo dinâmico de percentuais de retenção em relação ao Mês 0.
  * Funções de manipulação temporal (`TIMESTAMPDIFF`, `DATE_FORMAT`, `NULLIF`).

---

## 💡 Desafios Técnicos Resolvidos no Processo

Trabalhar com dados reais exige lidar com sujeiras e incompatibilidades do sistema:
1. **O "Bug" do Padrão Linux vs. Windows:** Arquivos gerados em ambientes Linux utilizam `\n` como quebra de linha, enquanto o Windows espera `\r\n`. A ingestão falhava silenciosamente até adaptarmos o parser do MySQL com `LINES TERMINATED BY '\n'`.
2. **Tratamento de Nulos na Raiz:** Pedidos cancelados não possuem data de entrega. Em vez de limpar isso via código depois, configuramos variáveis temporárias na própria importação (`NULLIF(@val, '')`) para garantir a integridade do Schema.

---

## 📊 Principais Insights de Negócio

<img width="1071" height="353" alt="Captura de tela 2026-07-21 160009" src="https://github.com/user-attachments/assets/34b7115d-4534-42cb-b9b6-746b0db3b39c" />

<img width="1087" height="363" alt="Captura de tela 2026-07-21 155951" src="https://github.com/user-attachments/assets/ceae32a9-2aac-4f48-a529-1d65a1dcf8d8" />

Ao analisar a matriz gerada pela query, dois pontos de negócio ficam muito claros:

1. **O "Efeito Penhasco" do Varejo Geral:** Diferente de um modelo de assinatura (SaaS ou Streaming), onde a curva de retenção precisa ser estável, o marketplace da Olist apresenta uma queda drástica logo no Mês 1 (de 717 clientes ativos na safra de Jan/2017 para apenas 3 em Fev/2017 — cerca de **0,41%**). Isso acontece porque o consumidor entra no site para comprar itens de longo ciclo (ex: ferramentas, peças), não fazendo compras recorrentes mensais.
2. **Injeção de Marketing vs. Retenção:** Em Fevereiro de 2017, a Olist teve um salto massivo de novos clientes no Mês 0 (**1.628 clientes**, mais que o dobro de janeiro), reflexo de rodadas de investimento e marketing agressivo. No entanto, o percentual de retenção nos meses seguintes manteve-se praticamente idêntico (0,18% no M1). **Conclusão:** O topo do funil escalou muito bem, mas o desafio de LTV (Lifetime Value) e recompra permaneceu o mesmo.

---

## 📂 Estrutura dos Arquivos e Códigos

Clique nos links abaixo para conferir o código SQL completo e comentado de cada etapa:

* 📄 **[01_schema_e_tabelas.sql](01_schema_e_tabelas.sql):** Definição da arquitetura, chaves primárias/estrangeiras e tipagem de dados.
* 📄 **[02_importacao_dados.sql](02_importacao_dados.sql):** Script de ingestão de alta performance (`LOAD DATA LOCAL INFILE`) com tratamento de exceções para datas vazias (`NULLIF`) e quebras de linha.
* 📄 **[03_analise_retencao_cohort.sql](03_analise_retencao_cohort.sql):** Query analítica avançada utilizando CTEs encadeadas, Window Functions (`MAX OVER`) e manipulação temporal para gerar a matriz de churn.
