{{ config(materialized='table') }}

WITH
    crims AS (
        SELECT *, 
        FROM {{ ref('mdl_crims_capitalization') }}
    )
SELECT
    crim_id AS `CrimID`,
    any_ AS `Any`,
    num_mes AS `NumeroMes`,
    nom_mes AS `Mes`,
    data_particio AS `DataParticio`,
    regio_policial_rp AS `RegioPolicial`,
    area_basica_policial_abp AS `AreaBasicaPolicial`,
    provincia AS `Provincia`,
    comarca AS `Comarca`,
    municipi AS `Municipi`,
    tipus_de_lloc_dels_fets AS `TipusDeLloc`,
    CASE
        WHEN tipus_de_fet = 'Delictes' THEN 'Delicte'
        WHEN tipus_de_fet = 'Infraccions administratives' THEN 'Infracció administrativa'
        ELSE tipus_de_fet
    END AS `TipusDeFet`,
    tipus_de_fet_codi_penal_o AS `FetCodiPenal`,
    CASE
        WHEN ambit_procediment_fet = 'LGTBI fòbia' THEN 'LGTBI-fòbia'
        ELSE ambit_procediment_fet
    END AS `Ambit`,
    CASE
        WHEN rol_victima_o_autoria = 'Persona autora' THEN 'Autor'
        ELSE rol_victima_o_autoria
    END AS `VictimaOAutor`,
    sexe AS `Sexe`,
    edat_inici_fets AS `Edat`,
    nombre AS `Nombre`
FROM
    crims
WHERE
        nombre IS NOT NULL
    AND edat_inici_fets < 150