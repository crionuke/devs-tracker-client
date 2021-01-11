import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/search_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/search_response.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SearchEvent {}

class DeveloperSelected extends SearchEvent {

  final int developerAppleId;

  DeveloperSelected(this.developerAppleId);
}

abstract class SearchState {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PurchaseRepository puchaseRepository;
  final ServerRepository serverRepository;

  SearchBloc(this.puchaseRepository, this.serverRepository)
      : super(SearchInitialState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is DeveloperSelected) {
      //
      yield SearchLoadingState();
    }
  }

  void select(int developerAppleId) {
    add(DeveloperSelected(developerAppleId));
  }

  Future<List<SearchDeveloper>> search(String term) async {
    SearchResponse searchResponseModel = await serverRepository
        .developerProvider.search(puchaseRepository.getUserID(), term);
    return searchResponseModel.developers;
  }
}
