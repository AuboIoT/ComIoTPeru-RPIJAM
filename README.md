# ComIoTPeru-RPIJAM

## Node-RED configuration
Use a *network* component, specifically the *mqtt in* to receive the data send by the Mosquitto broker.
Use the following parameters:
- Sever: mosquitto:1883"
- Action: "Subscribe to single topic"
- Topic: "commands/vaper"
- QoS: "2"
- Protocol: "MQTT V3.1.1"

Install the InfluxDB plugin for Node-RED.
Use a *storage* component specifically the *influxdb out* to receive the data send by the previous configured node.
Connect both of them.
Use the following parameters:
- Name: "influxdb/vaper"
- Server: "[v1.8-flux] influxdb"
- Database: "mydb"
- Measurement: "commands/vaper"

In the server properties use this:
- Name: "influxdb"
- Version: 1.8-flux"
- URL: "http://influxdb:8086"
- Username: "admin"
- Password: "admin123"

Use a *common* component, specifically the *debug* to show the data send by the Mosquitto broker.
Connect this component with the first node.

Finally, push button "Deploy".

## Grafana configuration

Enter Grafana, go to "Data Sources", use "InfluxDB". Use the following parameters:
- Name: "InfluxDB"
- Query Language: "InfluxQL"
- URL: "http://influxdb:8086"
- Auth: "Basic Auth" activated
- User: admin
- Password: admin123
- Database: "mydb"
- User: "admin"
- Password: "admin123"
- HTTP Method: "POST"

Push button "Save & Test".
Create a new dashboard. For the query you can use the following ones as reference.
'SELECT mean("temperature") FROM "autogen"."commands/vaper" WHERE $timeFilter GROUP BY time($__interval) fill(null)'
'SELECT mean("humidity") FROM "autogen"."commands/vaper" WHERE $timeFilter GROUP BY time($__interval) fill(null)'
'SELECT mean("PM2.5") FROM "autogen"."commands/vaper" WHERE $timeFilter GROUP BY time($__interval) fill(null)'
'SELECT mean("TVOC") FROM "autogen"."commands/vaper" WHERE $timeFilter GROUP BY time($__interval) fill(null)'
'SELECT mean("alert") FROM "autogen"."commands/vaper" WHERE $timeFilter GROUP BY time($__interval) fill(null)'


