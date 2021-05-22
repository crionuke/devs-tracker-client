import 'package:devs_tracker_client/repositories/purchase_repository/purchase_repository.dart';
import 'package:devs_tracker_client/repositories/push_repository/push_repository.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/error_response.dart';
import 'package:devs_tracker_client/repositories/server_repository/providers/model/search_developer.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SearchEvent {}

class ReloadEvent extends SearchEvent {}

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
  final String error;
  final SearchDeveloper searchDeveloper;

  SearchResult.found(this.searchDeveloper) : error = null;

  SearchResult.failed(this.searchDeveloper, this.error);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PurchaseRepository purchaseRepository;
  final ServerRepository serverRepository;
  final PushRepository pushRepository;

  SearchBloc(
      this.purchaseRepository, this.serverRepository, this.pushRepository)
      : super(SearchState.loading()) {
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() => reload());
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is ReloadEvent) {
      yield SearchState.initiated();
    } else if (event is DeveloperSelected) {
      yield SearchState.loading();
      yield await serverRepository.trackerProvider
          .post(purchaseRepository.getUserID(), pushRepository.getDeviceToken(),
              event.searchDeveloper.appleId)
          .then((_) => pushRepository.requestPermission().then((value) =>
              SearchState.finished(SearchResult.found(event.searchDeveloper))))
          .catchError((error) {
        if (error is DioError &&
            error.response != null &&
            error.response.data is Map) {
          print("DioError: " + error.response.toString());
          return SearchState.finished(SearchResult.failed(event.searchDeveloper,
              ErrorResponse.fromJson(error.response.data).id));
        } else {
          print("Error: " + error.toString());
        }

        return SearchState.failed();
      });
    }
  }

  void select(SearchDeveloper searchDeveloper) {
    add(DeveloperSelected(searchDeveloper));
  }

  Future<List<SearchDeveloper>> search(String term) async {
    return await serverRepository.developerProvider
        .search(purchaseRepository.getUserID(), pushRepository.getDeviceToken(),
            term)
        .then((response) => response.developers)
        .catchError((error) => throw Error());
  }

  void reload() {
    add(ReloadEvent());
  }
}
