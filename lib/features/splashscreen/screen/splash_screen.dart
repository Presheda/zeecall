import 'package:google_fonts/google_fonts.dart';
import 'package:zeecall/presentation/presentation_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    /// mock a small delay before proceeding to the call screen flow

    Future.delayed(Duration(milliseconds: 2500)).then(
        (value) => Navigator.of(context).popAndPushNamed(AppRouter.callScreen));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Text(
            "Zee Calls",
            style: GoogleFonts.bangers(
                fontSize: 30,
                fontStyle: FontStyle.normal,
                color: Color(0xff141414)),
          ),
        ),
      ),
    );
  }
}
