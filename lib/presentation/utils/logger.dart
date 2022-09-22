
import 'package:logger/logger.dart';

class AppLogger {
  static log(String levelTag, String message) {
    late Level level;

    switch (levelTag.toLowerCase()) {
      case "e":
        level = Level.error;
        break;

      case "d":
        level = Level.debug;
        break;

      case "w":
        level = Level.warning;

        break;
      case "i":
        level = Level.info;
        break;

      default:
        level = Level.verbose;
    }

    Logger logger = Logger();

    logger.log(level, message);
  }
}
