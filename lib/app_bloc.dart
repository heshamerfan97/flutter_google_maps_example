import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter_example/controller/live_location_cubit.dart';

class AppBloc {
  static final liveLocationCubit = LiveLocationCubit();

  static final List<BlocProvider> providers = [
    BlocProvider<LiveLocationCubit>(
      create: (context) => liveLocationCubit,
    ),

  ];

  static void dispose() {
    liveLocationCubit.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}
