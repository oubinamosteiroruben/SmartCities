{{ config(materialized='source') }}

{% set source_name %}
    {{ mz_generate_name('rp_bus_information') }}
{% endset %}

CREATE SOURCE {{ source_name }}
FROM KAFKA BROKER 'kafka:9092' TOPIC 'bus_information'
  KEY FORMAT BYTES
  VALUE FORMAT BYTES
ENVELOPE UPSERT;