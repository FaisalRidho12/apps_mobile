import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the chart package
import 'mqtt_service.dart'; // Import your mqtt_service.dart
import 'package:google_fonts/google_fonts.dart';

class MonitoringPage extends StatefulWidget {
  final MqttService mqttService;

  const MonitoringPage({Key? key, required this.mqttService}) : super(key: key);

  @override
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  String temperature = "Loading...";
  String humidity = "Loading...";
  List<FlSpot> temperatureData = [];
  List<FlSpot> humidityData = [];
  int time = 0;

  @override
  void initState() {
    super.initState();

    // Set callback for receiving DHT data
    widget.mqttService.onDhtDataReceived = (temp, hum) {
      setState(() {
        temperature = temp;
        humidity = hum;
        time++;

        // Add new data points for the chart
        temperatureData
            .add(FlSpot(time.toDouble(), double.tryParse(temp) ?? 0.0));
        humidityData.add(FlSpot(time.toDouble(), double.tryParse(hum) ?? 0.0));

        // Limit the data size for the chart (show only last 10 points)
        if (temperatureData.length > 10) {
          temperatureData.removeAt(0);
          humidityData.removeAt(0);
        }
      });
    };

    // Connect to MQTT broker
    widget.mqttService.connect();
  }

  @override
  void dispose() {
    widget.mqttService
        .disconnect(); // Disconnect MQTT when the page is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Monitoring',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF594545),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Temperature and Humidity Info
            Text(
              'Suhu: $temperature °C',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            Text(
              'Kelembapan: $humidity %',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30),

            // Temperature Graph
            Text(
              'Grafik Suhu',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: temperatureData,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Humidity Graph
            Text(
              'Grafik Kelembapan',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: humidityData,
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 4,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
