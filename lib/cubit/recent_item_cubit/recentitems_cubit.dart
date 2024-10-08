import 'package:bloc/bloc.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/repository/recent_store_items_repository.dart';

class RecentItemsCubit extends Cubit<List<Part>> {
  RecentItemsCubit() : super([]);
  final RecentStoreItemsRepository _recentStoreItemsRepository =
      RecentStoreItemsRepository();

  listenForRecentParts({required String company}) async {
    // _recentStoreItemsRepository.fetchRecentItems().lis
    await for (List<Part> recentParts
        in _recentStoreItemsRepository.fetchRecentItems(collection: company)) {
      //new part have been added
      emit(recentParts);
    }
  }
}
