import 'dart:convert';
import 'dart:ui';
// import 'dart:ui_web';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_informations_item.dart';
import 'package:weather_app/hourlyfore_cast_item.dart';
import 'package:weather_app/ignore.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
       String cityName = "London";
    final res = await http.get(
      Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$appId")
      );
      final data = jsonDecode(res.body);
      
      if(data['cod'] != '200'){
        throw "Something unexpected error!!";
      }
      return data;

    //  
      
      
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              setState(() {});
            },
            icon: Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) { 
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: const CircularProgressIndicator.adaptive());
          }
          
          if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString())
              );
          }

          final data = snapshot.data!;
          final weather = data['list'][0];
          final currentTemp = weather['main']['temp'];
          final currentSky = weather['weather'][0]['main'];
          final currentHumidity = weather['main']['humidity'];
          final currentPressure = weather['main']['pressure'];
          final currentWindSpeed = weather['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //main card
                 SizedBox(
                  width: double.infinity,
                   child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemp K",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                                ),
                              SizedBox(height: 16,),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain' ? 
                                Icons.cloud:
                                Icons.thunderstorm,
                                size: 64,
                                ),
                              SizedBox(height: 16,),
                              Text(currentSky, style: TextStyle(fontSize: 20),)
                            ],
                          ),
                        ),
                      ),
                    ),
                   ),
                 ),
                 SizedBox(height: 20),
                 ///forecast
                 Text("Weather Forecast", style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                 ),),
                 SizedBox(height: 10,),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index){
                      final hourlySky = data['list'][index + 1]['weather'][0]['main'];
                      final time = DateTime.parse(data['list'][index + 1]['dt_txt']);
                      return HourlyForecast(
                        hours: DateFormat.Hm().format(time),
                        temperature: data['list'][index + 1]['main']['temp'].toString(),
                        icon: hourlySky == "Clouds" || hourlySky == "Rain" ?
                         Icons.cloud: 
                         Icons.thunderstorm
                        );
                      }
                    ),
                ),

                 SizedBox(height: 20,),
                 ///additionals
                  Text("Additonal Informations", style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                 ),),
                 SizedBox(height: 16,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformationsItem(
                      icon: Icons.water_drop,
                      value: currentHumidity.toString(),
                      label: "Humidity"
                      ),
                    AdditionalInformationsItem(
                      icon: Icons.air,
                      value: currentWindSpeed.toString(),
                      label: "Wind Speed"
                      ),
                    AdditionalInformationsItem(
                      icon: Icons.beach_access,
                      value: currentPressure.toString(), 
                      label: "Pressure"
                      ),
                  ],
                 ),
              ],
            ),
          );
        }
      ),
    );
  }
}
