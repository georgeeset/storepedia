import 'package:bloc/bloc.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/recent_store_items_repository.dart';


class RecentItemsCubit extends Cubit<List<Part>> {
  RecentItemsCubit() : super([]);
  RecentStoreItemsRepository _recentStoreItemsRepository= RecentStoreItemsRepository();

  listenForRecentParts()async{
   // _recentStoreItemsRepository.fetchRecentItems().lis
   await for(List<Part> recentParts in _recentStoreItemsRepository.fetchRecentItems()){
     //new part have been added
     emit(recentParts);
   }
  }
  
}
