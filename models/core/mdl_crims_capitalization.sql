{{ config(materialized='view') }}

WITH
    crims AS (
        SELECT *, 
        FROM {{ ref('stg_crims') }}
    )
SELECT
    crim_id,
    any_,
    num_mes,
    nom_mes,
    data_particio,
    regio_policial_rp,
    area_basica_policial_abp,
    provincia,
    comarca,
    municipi,
    tipus_de_lloc_dels_fets,
    CONCAT(UPPER(LEFT(tipus_de_fet, 1)), LOWER(SUBSTRING(tipus_de_fet, 2, LENGTH(tipus_de_fet)))) AS tipus_de_fet,
    CONCAT(UPPER(LEFT(tipus_de_fet_codi_penal_o, 1)), LOWER(SUBSTRING(tipus_de_fet_codi_penal_o, 2, LENGTH(tipus_de_fet_codi_penal_o)))) AS tipus_de_fet_codi_penal_o,
    ambit_procediment_fet,
    CONCAT(UPPER(LEFT(rol_victima_o_autoria, 1)), LOWER(SUBSTRING(rol_victima_o_autoria, 2, LENGTH(rol_victima_o_autoria)))) AS rol_victima_o_autoria,
    CONCAT(UPPER(LEFT(sexe, 1)), LOWER(SUBSTRING(sexe, 2, LENGTH(sexe)))) AS sexe,
    edat_inici_fets,
    nombre
FROM
    crims