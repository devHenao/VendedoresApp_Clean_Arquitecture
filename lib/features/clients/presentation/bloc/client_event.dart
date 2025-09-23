import 'package:equatable/equatable.dart';

abstract class ClientEvent extends Equatable {
  const ClientEvent();

  @override
  List<Object> get props => [];
}

class LoadClients extends ClientEvent {}

class SearchClients extends ClientEvent {
  final String query;

  const SearchClients(this.query);

  @override
  List<Object> get props => [query];
}
