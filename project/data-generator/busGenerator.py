#!/usr/bin/env python
import datetime
import time
import sys
import os
import urllib.request
import json
#import requests
import schedule
import logging
from kafka import KafkaProducer

def json_serializer(obj):
    if isinstance(obj, (datetime.datetime, datetime.date)):
        return obj.isoformat()
    raise "Type %s not serializable" % type(obj)


def get_bus():

    # Producer instance
    prod = KafkaProducer(bootstrap_servers='kafka:9092')

    try:
        #r = requests.get('http://datos.santander.es/api/rest/datasets/control_flotas_estimaciones.json').json()

        urlData = "http://datos.santander.es/api/rest/datasets/control_flotas_estimaciones.json"

        jsonData = getResponse(urlData)

        for i in jsonData["resources"]:
            print(f'ResourceName: {i["dc:identifier"]}')

            json_value=json.dumps({"tiempo1": i["ayto:tiempo1"],
                                   "distancia2": i["ayto:distancia2"],
                                   "destino1": i["ayto:destino1"],
                                   "distancia1": i["ayto:distancia1"],
                                   "tiempo2": i["ayto:tiempo2"],
                                   "paradaId": i["ayto:paradaId"],
                                   "destino2": i["ayto:destino2"],
                                   "fechActual": i["ayto:fechActual"],
                                   "modified": i["dc:modified"],
                                   "id": i["dc:identifier"],
                                   "etiqLinea": i["ayto:etiqLinea"]                                   
                    },default=json_serializer, ensure_ascii=False)

            prod.send(topic='bus_information', key=i["dc:identifier"].encode('utf-8'), value=json_value.encode('utf-8'))

        prod.flush()

    except Exception as e:
        print("Exception: %s" % str(e),file=sys.stderr)
        sys.exit(1)


def getResponse(url):
    operUrl = urllib.request.urlopen(url)
    if(operUrl.getcode()==200):
        data = operUrl.read()
        jsonData = json.loads(data)
    else:
        print("Error receiving data", operUrl.getcode())
    return jsonData



if __name__ == "__main__":

    get_bus()
    schedule.every(30).seconds.do(get_bus)

    while True:
        schedule.run_pending()
        time.sleep(1)
