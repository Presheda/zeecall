import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeecall/presentation/utils/logger.dart';

class ZeeCallObserver extends BlocObserver{



  @override
  void onChange(BlocBase bloc, Change change) {
    AppLogger.log("d", "$bloc $change");
    super.onChange(bloc, change);
  }

  @override
  void onClose(BlocBase bloc) {
    AppLogger.log("d", "$bloc");
    super.onClose(bloc);
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    AppLogger.log("d", "$bloc $error $stackTrace");
    super.onError(bloc, error, stackTrace);
  }


  @override
  void onEvent(Bloc bloc, Object? event) {
    AppLogger.log("d", "$bloc $event");
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    AppLogger.log("d", "$bloc $transition");
    super.onTransition(bloc, transition);
  }



}