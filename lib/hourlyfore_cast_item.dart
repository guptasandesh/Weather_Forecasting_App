import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String hours;
  final String temperature;
  final IconData icon;
  const HourlyForecast({super.key, required this.hours, required this.temperature, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                      elevation: 6,
                          child: Container(
                            width: 100,
                            padding: const EdgeInsets.all(8.0),
                            child: Column(                                                                    
                              children: [
                                Text(hours, style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8,),
                                Icon(icon, size: 32,),
                                SizedBox(height: 8,),
                                Text(temperature),
                              ],
                            ),
                          ),
                        );
  }
}