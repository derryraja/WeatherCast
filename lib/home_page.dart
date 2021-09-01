import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weathercast/Themes/app_color.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var temperature;
  String location = 'San Francisco';
  int woeid = 2487956;
  String weather = 'lightcloud';
  int wind = 8;
  int humidity = 82;
  int visibility = 7;
  String errorMessage = '';
  var time = Jiffy().yMMMMd;

  var minTemperatureForecast = List.filled(6, 0, growable: false);
  var maxTemperatureForecast = List.filled(6, 0, growable: false);
  //var abbreviationForecast = List.generate(7, (_) => 0);

  late Position _currentPosition;
  late String _currentAddress;

  String searchApiUrl =
      'https://www.metaweather.com/api/location/search/?query=';
  String locationApiUrl = 'https://www.metaweather.com/api/location/';

  initState() {
    super.initState();
    fetchLocation();
    fetchLocationDay();
  }

  Future fetchSearch(String input) async {
    try {
      var oriSearchResult = searchApiUrl + input;
      var searchResult = await http.get(Uri.parse(oriSearchResult));
      var result = json.decode(searchResult.body)[0];

      setState(() {
        location = result["title"];
        woeid = result["woeid"];
        errorMessage = '';
      });
    } catch (error) {
      setState(() {
        errorMessage =
            "Sorry, we don't have data about this city. Try another one.";
      });
    }
  }

  Future fetchLocation() async {
    var oriLocationResult = locationApiUrl + woeid.toString();
    var locationResult = await http.get(Uri.parse(oriLocationResult));
    var result = json.decode(locationResult.body);
    var consolidated_weather = result["consolidated_weather"];
    var data = consolidated_weather[0];
    setState(() {
      temperature = data["the_temp"].round();
      weather = data["weather_state_name"].replaceAll(' ', '').toLowerCase();
      wind = data["wind_speed"].round();
      humidity = data["humidity"];
      visibility = data["visibility"].round();
    });
  }

  Future fetchLocationDay() async {
    var today = DateTime.now();
    var oriLocationResult = locationApiUrl + woeid.toString();
    var locationDayResult = await http.get(Uri.parse(oriLocationResult));
    var result = json.decode(locationDayResult.body);
    var consolidated_weather = result["consolidated_weather"];

    var dataDay1 = consolidated_weather[1];
    var dataDay2 = consolidated_weather[2];
    var dataDay3 = consolidated_weather[3];
    var dataDay4 = consolidated_weather[4];
    var dataDay5 = consolidated_weather[5];

    setState(() {
      minTemperatureForecast[1] = dataDay1["min_temp"].round();
      maxTemperatureForecast[1] = dataDay1["max_temp"].round();
      //abbreviationForecast[i] = data["weather_state_abbr"];

      minTemperatureForecast[2] = dataDay2["min_temp"].round();
      maxTemperatureForecast[2] = dataDay2["max_temp"].round();

      minTemperatureForecast[3] = dataDay3["min_temp"].round();
      maxTemperatureForecast[3] = dataDay3["max_temp"].round();

      minTemperatureForecast[4] = dataDay4["min_temp"].round();
      maxTemperatureForecast[4] = dataDay4["max_temp"].round();

      minTemperatureForecast[5] = dataDay5["min_temp"].round();
      maxTemperatureForecast[5] = dataDay5["max_temp"].round();
    });
  }

  void onTextFieldSubmitted(String input) async {
    await fetchSearch(input);
    await fetchLocation();
    await fetchLocationDay();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
      onTextFieldSubmitted(place.locality);
      print(place.locality);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/$weather.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: temperature == null
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.white,
            ))
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.kwhite),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  time,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.kwhite),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                _getCurrentLocation();
                              },
                              child: Icon(
                                Icons.cached,
                                size: 36.0,
                                color: AppColor.kwhite,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              weather,
                              style: GoogleFonts.montserrat(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                  color: AppColor.kwhite),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  setIcon(),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Text(
                                    temperature.toString() + ' °C',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 50,
                                        fontWeight: FontWeight.normal,
                                        color: AppColor.kwhite),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (var i = 1; i < 6; i++)
                                forecastElement(i, minTemperatureForecast[i],
                                    maxTemperatureForecast[i]),
                            ],
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 40),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         'Today',
                      //         style: GoogleFonts.montserrat(
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.normal,
                      //             color: AppColor.kwhite),
                      //       ),
                      //       SizedBox(
                      //         width: 20,
                      //       ),
                      //       Text(
                      //         'Tomorrow',
                      //         style: GoogleFonts.montserrat(
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.normal,
                      //             color: AppColor.klightGrey),
                      //       ),
                      //       SizedBox(
                      //         width: 20,
                      //       ),
                      //       Text(
                      //         'Next 7 days',
                      //         style: GoogleFonts.montserrat(
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.normal,
                      //             color: AppColor.klightGrey),
                      //       ),
                      //       SizedBox(
                      //         width: 5,
                      //       ),
                      //       Icon(
                      //         Icons.arrow_right,
                      //         color: AppColor.klightGrey,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Wind',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.kwhite),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  wind.toString(),
                                  style: GoogleFonts.montserrat(
                                      fontSize: 30,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.kwhite),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'mph',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.klightGrey),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Humidity',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.kwhite),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  humidity.toString(),
                                  style: GoogleFonts.montserrat(
                                      fontSize: 30,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.kwhite),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '%',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.klightGrey),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Visibility',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.kwhite),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  visibility.toString(),
                                  style: GoogleFonts.montserrat(
                                      fontSize: 30,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.kwhite),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'miles',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.klightGrey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: TextField(
                          onSubmitted: (String input) {
                            onTextFieldSubmitted(input);
                          },
                          style: TextStyle(
                            color: AppColor.kwhite,
                          ),
                          cursorColor: AppColor.kwhite,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: AppColor.klightGrey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                  color: AppColor.kwhite, width: 1.5),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColor.kwhite,
                            ),
                            labelText: 'Search',
                            labelStyle: GoogleFonts.montserrat(
                                fontSize: 16, color: AppColor.kwhite),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(errorMessage,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.montserrat(
                              color: AppColor.klightGrey, fontSize: 13))
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

Widget setIcon() {
  var now = DateTime.now();
  Widget icon;

  if (now.hour < 06 || now.hour > 18 || now.hour == 0) {
    icon = Icon(
      Icons.nightlight_outlined,
      size: 50,
      color: Colors.white,
    );
  } else {
    icon = Icon(
      Icons.wb_sunny_outlined,
      size: 50,
      color: Colors.yellow,
    );
  }

  return icon;
}

Widget forecastElement(daysFromNow, minTemperature, maxTemperature) {
  var now = new DateTime.now();
  var oneDayFromNow = now.add(new Duration(days: daysFromNow));
  return Padding(
    padding: const EdgeInsets.only(right: 16.0),
    child: Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(205, 212, 228, 0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColor.klightGrey)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              new DateFormat.E().format(oneDayFromNow),
              style:
                  GoogleFonts.montserrat(color: AppColor.kwhite, fontSize: 24),
            ),
            Text(
              new DateFormat.MMMd().format(oneDayFromNow),
              style:
                  GoogleFonts.montserrat(color: AppColor.kwhite, fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'High: ' + maxTemperature.toString() + ' °C',
              style:
                  GoogleFonts.montserrat(color: AppColor.kwhite, fontSize: 16),
            ),
            Text(
              'Low: ' + minTemperature.toString() + ' °C',
              style:
                  GoogleFonts.montserrat(color: AppColor.kwhite, fontSize: 16),
            ),
          ],
        ),
      ),
    ),
  );
}
