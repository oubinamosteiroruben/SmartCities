/*

The purpose of this model is to create a flight_information staging model
with light transformations on top of the source.

*/

{{ config(
    materialized='view'
) }}


WITH source AS (

    SELECT * FROM {{ ref('rp_bus_information') }}

),

converted AS (

    SELECT convert_from(data, 'utf8') AS data FROM source

),

casted AS (

    SELECT cast(data AS jsonb) AS data FROM converted

),

renamed AS (

    SELECT 
    (data->>'id')::string as id,
        cast((concat('0',data->>'tiempo1'))::string as INT) as tiempo1,
        cast((concat('0',data->>'distancia2'))::string as INT)  as distancia2,
        (data->>'destino1')::string as destino1,
        cast((concat('0',data->>'distancia1'))::string as INT)  as distancia1,
        cast((concat('0',data->>'tiempo2'))::string as INT) as tiempo2,
        (data->>'paradaId')::string as paradaId,
        (data->>'destino2')::string as destino2,
        (data->>'fechActual')::string as fechActual,
        (data->>'modified')::string as modified,
        (data->>'etiqLinea')::string as etiqLinea

    FROM casted

)

SELECT * FROM renamed
