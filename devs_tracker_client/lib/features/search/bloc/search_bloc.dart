import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/search_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SearchEvent {}

class ResetPageEvent extends SearchEvent {}

class DeveloperSelected extends SearchEvent {

  final SearchDeveloper searchDeveloper;

  DeveloperSelected(this.searchDeveloper);
}

class SearchState {
  final bool loading;
  final bool failed;
  final bool finished;

  SearchResult result;

  SearchState.loading()
      : loading = true,
        failed = false,
        finished = false,
        result = null;

  SearchState.initiated()
      : loading = false,
        failed = false,
        finished = false,
        result = null;

  SearchState.failed()
      : loading = false,
        failed = true,
        finished = false,
        result = null;

  SearchState.finished(this.result)
      : loading = false,
        failed = false,
        finished = true;
}

class SearchResult {
  final int statusCode;
  final SearchDeveloper searchDeveloper;

  SearchResult(this.statusCode, this.searchDeveloper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;

  SearchBloc(this.purchaseRepository, this.serverRepository)
      : super(SearchState.loading()) {
    resetPage();
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is ResetPageEvent) {
      yield SearchState.initiated();
    } else if (event is DeveloperSelected) {
      yield SearchState.loading();
      yield await serverRepository.trackerProvider.post(
          purchaseRepository.getUserID(), event.searchDeveloper.appleId)
          .then((statusCode) =>
          SearchState.finished(SearchResult(statusCode, event.searchDeveloper)))
          .catchError((error) {
        print("Error: " + error.toString());
        return SearchState.failed();
      });
    }
  }

  void select(SearchDeveloper searchDeveloper) {
    add(DeveloperSelected(searchDeveloper));
  }

  Future<List<SearchDeveloper>> search(String term) async {
    return await serverRepository
        .developerProvider.search(purchaseRepository.getUserID(), term)
        .then((response) => response.developers)
        .catchError((error) => throw Error());
  }

  void resetPage() {
    add(ResetPageEvent());
  }
}
