import 'dart:async'; // Import StreamController
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late MqttServerClient client;
  Function(bool)?
      onConnectionChanged; // Callback to notify connection state changes
  Function(String, String)? onDhtDataReceived; // Callback for DHT data
  Function(String)? onFoodStockReceived; // Callback for food stock data
  final _dhtStreamController = StreamController<
      Map<String, String>>.broadcast(); // StreamController for DHT data
  final _foodStockStreamController = StreamController<
      String>.broadcast(); // StreamController for food stock data

  Stream<Map<String, String>> get dhtStream =>
      _dhtStreamController.stream; // Stream for DHT data
  Stream<String> get foodStockStream =>
      _foodStockStreamController.stream; // Stream for food stock data

  MqttService() {
    client = MqttServerClient('178.128.89.8', 'FlutterClient');
    client.port = 1883;
    client.logging(on: true);
    client.keepAlivePeriod = 20; // Set keepAlive period
    client.onConnected = _onConnected; // Assign callback for when connected
    client.onDisconnected =
        _onDisconnected; // Assign callback for when disconnected
  }

  Future<void> connect() async {
    final connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier("FlutterClient")
        .withWillTopic("willtopic")
        .withWillMessage("My will message")
        .startClean()
        .withWillQos(mqtt.MqttQos.atLeastOnce);
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == mqtt.MqttConnectionState.connected) {
      print('Connected');
      _notifyConnectionStatus(true); // Notify that the connection is successful
      subscribeTopics(); // Subscribe to topics after connection
    } else {
      print('Connection failed');
      client.disconnect();
      _notifyConnectionStatus(false); // Notify that the connection failed
    }
  }

  void subscribeTopics() {
    subscribe("catcare/dht"); // Subscribe to DHT topic
    subscribe("catcare/servo"); // Subscribe to servo topic
    subscribe(
        "catcare/foodstock"); // Subscribe to food stock topic (HC-SR04 sensor)
  }

  void _notifyConnectionStatus(bool isConnected) {
    if (onConnectionChanged != null) {
      onConnectionChanged!(isConnected); // Notify connection status
    }
  }

  // Callback for when connected
  void _onConnected() {
    print('MQTT Connected');
    _notifyConnectionStatus(true); // Notify connection status is connected
  }

  // Callback for when disconnected
  void _onDisconnected() {
    print('MQTT Disconnected');
    _notifyConnectionStatus(false); // Notify connection status is disconnected
  }

  void subscribe(String topic) {
    if (client.connectionStatus!.state == mqtt.MqttConnectionState.connected) {
      client.subscribe(topic, mqtt.MqttQos.atLeastOnce);
      client.updates!
          .listen((List<mqtt.MqttReceivedMessage<mqtt.MqttMessage?>>? c) {
        final mqtt.MqttMessage message = c![0].payload!;
        final String topic = c[0].topic;

        if (message is mqtt.MqttPublishMessage) {
          final String payload = mqtt.MqttPublishPayload.bytesToStringAsString(
              message.payload.message);
          callback(topic, payload); // Handle incoming message
        }
      });
    } else {
      print('Cannot subscribe, not connected');
    }
  }

  void callback(String topic, String payload) {
    if (topic == "catcare/dht") {
      List<String> data =
          payload.split(','); // Expecting "Suhu: x °C, Kelembapan: y %"
      String temp = data[0].split(':')[1].trim(); // Extract temperature
      String hum = data[1].split(':')[1].trim(); // Extract humidity

      // Notify the Flutter app about the new DHT data
      if (onDhtDataReceived != null) {
        onDhtDataReceived!(temp, hum);
      }

      // Send data to the stream for real-time updates
      _dhtStreamController.add({'temperature': temp, 'humidity': hum});
    } else if (topic == "catcare/foodstock") {
      // Handle food stock level (e.g., from HC-SR04)
      String stockLevel = payload; // Assuming payload is a percentage value
      // Notify the Flutter app about the new food stock data
      if (onFoodStockReceived != null) {
        onFoodStockReceived!(stockLevel);
      }
      // Send data to the stream for real-time updates
      _foodStockStreamController.add(stockLevel);
    } else if (topic == "catcare/servo") {
      // existing servo control logic...
    }
  }

  void publish(String topic, String message) {
    if (client.connectionStatus!.state == mqtt.MqttConnectionState.connected) {
      final mqtt.MqttClientPayloadBuilder builder =
          mqtt.MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topic, mqtt.MqttQos.atLeastOnce, builder.payload!);
    } else {
      print('Cannot publish, not connected');
    }
  }

  void disconnect() {
    client.disconnect();
    _dhtStreamController.close(); // Close the stream controller
    _foodStockStreamController
        .close(); // Close the food stock stream controller
  }
}
