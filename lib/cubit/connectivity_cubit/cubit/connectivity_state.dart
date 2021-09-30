part of 'connectivity_cubit.dart';

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}
class ConnectivityInitial extends ConnectivityState {
  @override
  String toString()=>'ConnectivityInitial';
}
class ConnectivityMobileData extends ConnectivityState {
    @override
  String toString()=>'ConnectivityMobileData';
}
class ConnectivityWifi extends ConnectivityState{
    @override
  String toString()=>'ConnectivityWifi';
}
class ConnectivityOffline extends ConnectivityState{
    @override
  String toString()=>'ConnectivityOffline';
}
