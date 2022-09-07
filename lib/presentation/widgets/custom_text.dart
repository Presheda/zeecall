import 'package:google_fonts/google_fonts.dart';
import 'widget_export.dart';

class CustomText extends StatelessWidget {
  final String title;

  final double? fontSize;
  final Color? color;
  final int? maxLine;
  final String? fontFamily;
  final FontWeight? fontWeight;
  bool? isNaira = false;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  final double? lineHeight;
  final double? letterSpacing;

  CustomText(
      {this.color,
      required this.title,
      this.maxLine,
      this.fontSize,
      this.fontFamily,
      this.isNaira,
      this.textAlign,
      this.lineHeight,
      this.fontStyle,
      this.letterSpacing,
      this.fontWeight}) {
    isNaira ??= false;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLine ?? 3,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: isNaira!
          ? GoogleFonts.roboto(
              letterSpacing: letterSpacing,
              fontSize: fontSize ?? 10,
              fontWeight: fontWeight,
              height: lineHeight,
              color: color ?? Theme.of(context).textTheme.bodyText1!.color,
              fontStyle: fontStyle)
          : GoogleFonts.poppins(
              letterSpacing: letterSpacing,
              fontSize: fontSize ?? 10,
              fontStyle: fontStyle,
              height: lineHeight,
              color: color ?? Theme.of(context).textTheme.bodyText1!.color),
    );
  }
}

class CustomHeaderText extends StatelessWidget {
  final String title;

  final double? fontSize;
  final Color? color;
  final int? maxLine;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final double? lineHeight;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  final TextDecoration? textDecoration;

  CustomHeaderText(
      {this.color,
      required this.title,
      this.maxLine,
      this.fontSize,
      this.fontFamily,
      this.lineHeight,
      this.textAlign,
      this.fontStyle,
      this.textDecoration,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLine ?? 1,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: TextStyle(
        decoration: textDecoration,
        letterSpacing: -0.25,
        fontSize: fontSize ?? 10,
        fontFamily: "ITCAVANT",
        fontWeight: FontWeight.w600,
        fontStyle: fontStyle,
        height: lineHeight,
        color: color ?? Theme.of(context).textTheme.headline6!.color,
      ),
    );
  }
}
