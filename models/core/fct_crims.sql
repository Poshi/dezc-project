{{ config(materialized='table') }}

WITH
    crims AS (
        SELECT *, 
        FROM {{ ref('mdl_crims_tidy') }}
    )
SELECT
    `Any`,
    `Mes`,
    `DataParticio`,
    `Provincia`,
    `TipusDeLloc`,
    `Ambit`,
    `VictimaOAutor`,
    COUNT(*) AS N,
    AVG(edat) AS EdatMitja
FROM
    crims
GROUP BY
    `Any`,
    `Mes`,
    `DataParticio`,
    `Provincia`,
    `TipusDeLloc`,
    `Ambit`,
    `VictimaOAutor`
