import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weathercast/Themes/app_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int temperature = 0;
  String location = 'Chennai';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/clear.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
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
                    children: [
                      Text(
                        'Today',
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
                            Icon(
                              Icons.wb_sunny_outlined,
                              size: 50,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              temperature.toString() + ' °C',
                              style: GoogleFonts.montserrat(
                                  fontSize: 50,
                                  fontWeight: FontWeight.normal,
                                  color: AppColor.kwhite),
                            ),
                          ])
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: TextField(
                    style: TextStyle(
                      color: AppColor.kprimaryColor,
                    ),
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                      setState(() {
                        //email = value;
                      });
                    },
                    //textAlign: TextAlign.start,
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
                        borderSide:
                            BorderSide(color: AppColor.kwhite, width: 1.5),
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
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    children: [
                      Text(
                        'Today',
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: AppColor.kwhite),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Tomorrow',
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: AppColor.klightGrey),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Next 7 days',
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: AppColor.klightGrey),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_right,
                        color: AppColor.klightGrey,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
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
                            '8',
                            style: GoogleFonts.montserrat(
                                fontSize: 30,
                                fontWeight: FontWeight.normal,
                                color: AppColor.kwhite),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'km/h',
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
                            '82',
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
                            'Rain',
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: AppColor.kwhite),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '7',
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
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
