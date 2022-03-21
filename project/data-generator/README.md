# OpenSky Data Generator

The `busGenerator.py` data generator pulls live flight information data from the Satander data web (http://datos.santander.es/api/rest/datasets/control_flotas_estimaciones.json) [^1] **every 30 seconds**, and uses the [Kafka Python client](https://kafka-python.readthedocs.io/en/master/) (`kafka-python`) to push events into Redpanda.

**Example:**

```javascript
{
      "ayto:tiempo1":"426",
      "ayto:distancia2":"8046",
      "ayto:destino1":"PASEO PEREDA 35",
      "ayto:distancia1":"2662",
      "ayto:tiempo2":"1739",
      "ayto:paradaId":"9",
      "ayto:destino2":"PASEO PEREDA 35",
      "ayto:fechActual":"2022-03-17T15:32:27.823Z",
      "dc:modified":"2022-03-17T15:32:33.164Z",
      "dc:identifier":"26",
      "ayto:etiqLinea":"3",
      "uri":"http://datos.santander.es/api/datos/control_flotas_estimaciones/26.json"}

```

[^1]: The Bus Network, http://datos.santander.es/dataset/?id=control-flota-autobuses

## Tweaking the code

If you make any changes to the data generator, rebuild the container using:

```bash
docker-compose build --no-cache

docker-compose up --force-recreate -d
```