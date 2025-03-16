{{ config(materialized="view") }}

WITH
    crims AS (
        SELECT *
        FROM {{ source("staging", "crims") }}
    )
SELECT
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(["any_", "num_mes", "municipi", "tipus_de_lloc_dels_fets", "tipus_de_fet", "tipus_de_fet_codi_penal_o", "ambit_procediment_fet", "rol_victima_o_autoria", "sexe", "edat_inici_fets", "nombre"]) }} AS crim_id,

    -- data
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
    tipus_de_fet,
    tipus_de_fet_codi_penal_o,
    ambit_procediment_fet,
    rol_victima_o_autoria,
    sexe,
    edat_inici_fets,
    nombre
FROM
    crims

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
--{% if var("is_test_run", default=true) %}
--    limit 100
--{% endif %}