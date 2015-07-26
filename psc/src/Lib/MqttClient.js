/* global exports */
"use strict";

// module Lib.MqttClient

exports.connect = function(info) {
	var client = new Paho.MQTT.Client(info.host, info.port, info.clientId);
	return function(destination) {
		return function(actions) {
			client.onMessageArrived = function(message) {
				actions.messageArrived(message.payloadString);
			};
			client.connect({
				timeout: 3,
				userName: info.username,
				password: info.password,
				onSuccess: function() {
					client.subscribe(destination, {
						qos: 0,
						onSuccess: function() {
							actions.connected(client);
						}
					});
				}
			});
			return client;
		};
	};
};
exports.send = function(client, destination, data) {
	var message = new Paho.MQTT.Message(data);
	message.destinationName = destination;
	message.qos = 0;
	message.retained = false;
	client.send(message);
};
