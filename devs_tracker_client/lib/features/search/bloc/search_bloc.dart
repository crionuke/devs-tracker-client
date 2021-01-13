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

class SearchPageState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchFinishedState extends SearchState {}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;

  SearchBloc(this.purchaseRepository, this.serverRepository)
      : super(SearchPageState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is DeveloperSelected) {
      DeveloperSelected developerSelected = event;
      yield SearchLoadingState();
      bool success = await serverRepository.trackerProvider.post(
          purchaseRepository.getUserID(), developerSelected.developerAppleId);
      if (success) {
        print("Tracker added, developerAppleId=${developerSelected
            .developerAppleId}");
      } else {
        // TODO: handle failed requests, show message etc.
      }
      yield SearchFinishedState();
    }
  }

  void select(int developerAppleId) {
    add(DeveloperSelected(developerAppleId));
  }

  Future<List<SearchDeveloper>> search(String term) async {
    SearchResponse searchResponseModel = await serverRepository
        .developerProvider.search(purchaseRepository.getUserID(), term);
    return searchResponseModel.developers;
  }
}
