import 'package:devs_tracker_client/repositories/server_repository/developers_provider/model/developer_model.dart';
import 'package:devs_tracker_client/repositories/server_repository/developers_provider/model/search_response.dart';
import 'package:devs_tracker_client/repositories/server_repository/server_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SearchEvent {}

abstract class SearchState {}

class SearchInitialState extends SearchState {}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ServerRepository serverRepository;

  SearchBloc(this.serverRepository) : super(SearchInitialState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    yield SearchInitialState();
  }

  Future<List<DeveloperModel>> search(String term) async {
    SearchResponseModel searchResponseModel =
        await serverRepository.developersProvider.search(term);
    return searchResponseModel.developers;
  }
}
