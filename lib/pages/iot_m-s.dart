import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TemperaturePage extends StatefulWidget {
  final Stream<Map<String, String>> dhtStream;

  TemperaturePage({required this.dhtStream});

  @override
  _TemperaturePageState createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  double minTemperature = double.infinity;
  double maxTemperature = double.negativeInfinity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Suhu',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: const Color(0xFF594545),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFF8EA),
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8EA),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<Map<String, String>>(
        stream: widget.dhtStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            var temperature =
                double.tryParse(data['temperature'] ?? '0') ?? 0.0;

            // Update min and max temperature values
            if (temperature < minTemperature) minTemperature = temperature;
            if (temperature > maxTemperature) maxTemperature = temperature;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circular Percent Indicator for temperature
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: CircularPercentIndicator(
                          radius: 80,
                          lineWidth: 10,
                          percent: (temperature / 50).clamp(0.0, 1.0),
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons
                                        .thermostat_rounded, // Icon for temperature
                                    color: Color(0xFF594545),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${temperature.toInt()}°C',
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Suhu',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          progressColor: const Color(0xFF594545),
                          backgroundColor: const Color(0xFFFFF8EA),
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      ),
                    ),
                    // Displaying minimum and maximum temperature values
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Minimum Temperature
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.arrow_downward,
                                      color: Color(0xFF594545),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${minTemperature.toStringAsFixed(1)}°C',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF594545),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              // Maximum Temperature
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.arrow_upward,
                                      color: Color(0xFF594545),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${maxTemperature.toStringAsFixed(1)}°C',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF594545),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset('assets/images/loading-cat.gif'),
                  ),
                  const SizedBox(height: 0),
                  Text(
                    'Loading data...',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF594545),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
