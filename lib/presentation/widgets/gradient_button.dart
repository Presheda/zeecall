import 'widget_export.dart';

class GradientButton extends StatelessWidget {
  final String title;
  void Function() onTap;
  final Color? firstColor;
  final Color? textColor;
  double? height;

  late bool enabled;

  GradientButton(
      {required this.title,
      required this.onTap,
      this.firstColor,
      this.textColor,
      this.enabled = true,
      this.height});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onTap : null,
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width, height ?? 55)),
          backgroundColor: MaterialStateProperty.all(enabled
              ? firstColor ?? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          )),
      child: Center(
        child: CustomText(
          title: title,
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
