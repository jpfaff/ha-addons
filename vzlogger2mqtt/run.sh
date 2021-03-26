#!/usr/bin/with-contenv bashio

CONFIG_PATH=/data/options.json

# Settings for pyhpsu.conf
VERBOSE="$(bashio::config 'verbose')"
MQTT_BROKER="$(bashio::config 'mqtt_broker')"
MQTT_PORT="$(bashio::config 'mqtt_port')"
MQTT_USERNAME="$(bashio::config 'mqtt_username')"
MQTT_PASSWORD="$(bashio::config 'mqtt_password')"
MQTT_TOPIC="$(bashio::config 'mqtt_topic')"

METER_PROTOCOL="$(bashio::config 'meter_protocol')"
METER_PARITY="$(bashio::config 'meter_parity')"
METER_BAUDRATE="$(bashio::config 'meter_baudrate')"
METER_AGGTIME="$(bashio::config 'meter_aggtime')"
METER_DEVICE="$(bashio::config 'meter_device')"
METER_DEVICE2="$(bashio::config 'meter_device2')"

CHANNELS=$(jq -r 'if .channels then [.channels[] | ""{ \"api\" : \"null\", \n \"identifier\" : \""+.identifier+""\", \n  \"aggmode\": \""+.aggmode+"\"}" | join(",\n") else "" end' /data/options.json)

echo "$CHANNELS"

# Replace in pyhpsu.conf
echo "Initializing vzlogger configuration ..."

sed -i "s/{verbose}/${VERBOSE}/g" "vzlogger.conf"
sed -i "s/{mqtt_broker}/${MQTT_BROKER}/g" "vzlogger.conf"
sed -i "s/{mqtt_port}/${MQTT_PORT}/g" "vzlogger.conf"
sed -i "s/{mqtt_username}/${MQTT_USERNAME}/g" "vzlogger.conf"
sed -i "s/{mqtt_password}/${MQTT_PASSWORD}/g" "vzlogger.conf"
sed -i "s/{mqtt_topic}/${MQTT_TOPIC}/g" "vzlogger.conf"
sed -i "s/{channels}/${CHANNELS//$'\n'/\\n}/g" "vzlogger.conf"


echo
echo vzlogger.conf: 
echo
cat vzlogger.conf
echo


/vzlogger/vzlogger --config /vzlogger.conf