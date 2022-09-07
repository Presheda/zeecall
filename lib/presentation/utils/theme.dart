import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ZeeCallLightTheme {
  static const Color blue = Color(0xff6678ff);
  static const Color greyBackgroundColor = Color(0xffEFEFEF);
  static const Color primaryColorLight = Color(0xff46B97F);
  static const Color errorColor = Color(0xffFF4D42);


  //body color
  static const Color textColorDark = Color(0xff82928B);


  static const Color textColorLight = Color(0xff919099);


  static const Color accentColor = Color(0xffEBA41D);
  static const backgroundColor = Colors.white;

  //text field color
  static const Color textFieldFilledColor = Color(0xffF2F2F2);

  static const Color textFieldLabelColor = Color(0xff808080);

  static const Color headerTextColor = Color(0xff07120D);

  ///-- empty cardLoader colors
  /// defaults it for headline 2 and 3
  static const Color headLine2Color = Color(0xff07120D);// Color(0xffD2D5D3);
  static const Color headLine3Color = Color(0xff07120D);// Color(0xffF2F2F2);

  static ThemeData appLightTheme() {
    return ThemeData.light().copyWith(



        primaryTextTheme: const  TextTheme(
          bodyText1:  TextStyle(color: primaryColorLight),
          headline6:  TextStyle(
            color: headerTextColor,
          ),
          headline2:  TextStyle(
            color: headLine2Color,
          ),
          headline3:  TextStyle(
            color: headLine3Color,
          ),

        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: greyBackgroundColor,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColorLight,
        ),
        dividerTheme: const DividerThemeData(),
        dialogTheme:
        const DialogTheme(contentTextStyle: TextStyle(color: textColorDark)),
        primaryColor: primaryColorLight,
        scaffoldBackgroundColor: backgroundColor,
        errorColor: errorColor,
        backgroundColor: greyBackgroundColor,
        accentColor: accentColor,
        textTheme: TextTheme(
          bodyText1: GoogleFonts.poppins(color: textColorDark),
          bodyText2: GoogleFonts.poppins(color: textColorDark),
          headline2: const TextStyle(
            color: headLine2Color,
          ),
          headline3: const TextStyle(
            color: headLine3Color,
          ),
          headline5: const TextStyle(color: headerTextColor),
          headline4: const TextStyle(color: headerTextColor),
          headline6: const TextStyle(
              fontFamily: "ITCAVANT", fontWeight: FontWeight.w700,
              color: headerTextColor,  fontSize: 24),
        ),
        primaryColorLight: textColorLight,
        primaryColorDark: textColorDark,
        tabBarTheme: const TabBarTheme(labelStyle:  TextStyle(color: textColorDark)),
        iconTheme: const IconThemeData(color: Colors.black),


        appBarTheme: const AppBarTheme(
          elevation: 0,
          brightness: Brightness.light,
          color: Colors.white,
          textTheme: TextTheme(
            headline1:  TextStyle(color: textColorDark),
            headline2:  TextStyle(color: textColorDark),
            headline3:  TextStyle(color: textColorDark),
            headline4:  TextStyle(color: textColorDark),
            headline5:  TextStyle(color: textColorDark),
            headline6: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          iconTheme:  IconThemeData(color:  Color(0xffBFBFBF)),
          actionsIconTheme: IconThemeData(color:  Color(0xffBFBFBF)),
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: primaryColorLight,
            unselectedItemColor: Color(0xffE7E4E4)
        ),


        disabledColor: const Color(0xffA1A1A1),

        inputDecorationTheme: const InputDecorationTheme(
            fillColor:   textFieldFilledColor,
            labelStyle: TextStyle(
                fontSize: 14,
                color: textFieldLabelColor)));
  }
}
