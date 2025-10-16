# Projeto de Migração e Normalização de Dados de Vendas

Este repositório contém os scripts SQL para um projeto de estudo completo de ETL (Extração, Transformação e Carga), simulando um cenário de migração de dados de um sistema legado (exportado em CSV) para um banco de dados relacional normalizado.

**Autor:** [Seu Nome]
**Data:** Outubro de 2025
**Tecnologia:** PostgreSQL

---

## Objetivo

O objetivo era pegar um arquivo CSV denormalizado contendo dados de vendas e estruturá-los corretamente em um esquema com 4 tabelas (`customers`, `products`, `orders`, `order_items`) para garantir a integridade dos dados e eliminar a redundância.

---

## O Processo

O projeto foi dividido nas seguintes etapas:

1.  **Criação do Schema:** Definição e criação das tabelas finais e da tabela de estágio (`sales_stage`).
2.  **Extração e Carga (E/L):** Importação dos dados brutos do arquivo `vendas_outubro.csv` para a `sales_stage` usando o comando `\copy`.
3.  **Transformação e Normalização (T):**
    * Extração de clientes únicos para a tabela `customers`.
    * Criação dos registros de pedidos na tabela `orders`, utilizando `JOIN` para buscar a referência do cliente.
    * População da tabela `order_items` com um `JOIN` múltiplo para conectar pedidos e produtos.
4.  **Validação:** Execução de consultas analíticas complexas para verificar a integridade e as relações entre os dados.

---

## Consulta de Validação Final

A consulta abaixo junta as 4 tabelas para reconstruir a visão original dos dados, provando que a normalização foi bem-sucedida.

```sql
-- Cole aqui sua consulta de validação final --
SELECT ...
```
