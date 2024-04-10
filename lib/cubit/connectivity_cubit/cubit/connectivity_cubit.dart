import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit() : super(ConnectivityInitial()) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult status) {
      _networkStatus(status);
    });
  }

  _networkStatus(ConnectivityResult status) {
    //Begin...

    switch (status) {
      case ConnectivityResult.mobile:
        emit(ConnectivityMobileData());
        break;

      case ConnectivityResult.wifi:
        emit(ConnectivityWifi());
        break;

      case ConnectivityResult.none:
        emit(ConnectivityOffline());
        break;
    }
  }

  @override
  void onChange(Change<ConnectivityState> change) {
    print(change.nextState);
    super.onChange(change);
  }
}
