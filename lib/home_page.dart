import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weathercast/Themes/app_color.dart';
import 'package:http/http.dart' as http;

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

  String searchApiUrl =
      'https://www.metaweather.com/api/location/search/?query=';
  String locationApiUrl = 'https://www.metaweather.com/api/location/';

  initState() {
    super.initState();
    fetchLocation();
  }

  Future fetchSearch(String input) async {
    var oriSearchResult = searchApiUrl + input;
    var searchResult = await http.get(Uri.parse(oriSearchResult));
    var result = json.decode(searchResult.body)[0];

    setState(() {
      location = result["title"];
      woeid = result["woeid"];
    });
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

  void onTextFieldSubmitted(String input) async {
    await fetchSearch(input);
    await fetchLocation();
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
                        child: Column(
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
                              'July 8th, 2020',
                              style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: AppColor.kwhite),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 200),
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
                        padding: const EdgeInsets.only(top: 200),
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
                                  'Miles',
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

  if (now.hour < 5 && now.hour > 16) {
    icon = Icon(
      Icons.nightlight_outlined,
      size: 50,
      color: Colors.blue,
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
