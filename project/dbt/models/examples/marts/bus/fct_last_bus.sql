{{ config(
    materialized ='materializedview'
) }}


with fct_bus as (

    SELECT * 
    FROM {{ ref('stg_bus_information') }} fi

)

select id, modified from fct_bus order by id, modified