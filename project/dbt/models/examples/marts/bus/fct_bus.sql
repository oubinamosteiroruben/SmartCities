{{ config(
    materialized ='materializedview'
) }}


with fct_bus as (
    SELECT * 
    FROM {{ ref('stg_bus_information') }} fi
),

/*

fct_bus_12 as(
    select * 
    from fct_bus 
    where paradaId = '12'
),

fct_bus_12_last as (
    select id, max(modified) as lastMeasure from fct_bus_12 group by id
)

select tot.id, lastMeasure, tot.tiempo1, tot.distancia1, tot.destino1
from fct_bus_12_last as last left join fct_bus_12 as tot on last.id = tot.id and last.lastMeasure = tot.modified
order by tiempo1 asc

*/


fct_bus_last as (
    select paradaId,id, max(modified) as lastMeasure from fct_bus group by id, paradaId
)

select last.paradaId, tot.id, lastMeasure, tot.tiempo1, tot.distancia1, tot.destino1
from fct_bus_last as last left join fct_bus as tot on last.id = tot.id and last.lastMeasure = tot.modified
order by tiempo1 asc

