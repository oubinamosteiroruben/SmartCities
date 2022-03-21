{{ config(
    materialized ='materializedview'
) }}


with fct_bus as (

    SELECT * 
    FROM {{ ref('stg_bus_information') }} fi

),


fct_bus_1 as (
    select id, paradaId, etiqLinea, tiempo1 as tiempo, distancia1 as distancia, destino1 as destino, modified from fct_bus
),

fct_bus_2 as (
    select id, paradaId, etiqLinea, tiempo2 as tiempo, distancia2 as distancia, destino2 as destino, modified from fct_bus where destino2 not like ''
),

last_measures as (
    select id, max(modified) as lastModified from fct_bus group by id
),

total_measures as (
    select * from fct_bus_1 union all select * from fct_bus_2
)

select tm.* from total_measures as tm inner join last_measures as lm on tm.id = lm.id and tm.modified = lm.lastModified

