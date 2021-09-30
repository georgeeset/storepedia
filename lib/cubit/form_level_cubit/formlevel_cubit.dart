
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:store_pedia/cubit/edit_item_cubit/edititem_cubit.dart';
import 'package:store_pedia/model/part.dart';


class FormLevelCubit extends Cubit<int> {
 final EditItemCubit editItemCubit;
 late StreamSubscription editItemSubscription;
  FormLevelCubit({required this.editItemCubit}) : super(0){
    editItemSubscription=editItemCubit.stream.listen((update) {
      updateFormLevel(partForm: update);
    });
  }

  updateFormLevel({required Part partForm}){
     int score=0;

      if(partForm.partName !=null){
        score+=16;
      }
      if(partForm.partDescription !=null){
        score+= 16;
      }
      if(partForm.partNumber !=null){
        score+=2;
      }
      if(partForm.section!=null){
        score+=16;
      }

      /// store location or store id, whichever is provided is ok
      if(partForm.storeId !=null || partForm.storeLocation!=null){
        score+=16;
      }
     
      if(partForm.photo!=null){
        // form will not submit if photo is not filled. 
        // this score does not really matter. just to let 
        // us determine that a file is uploaded already
        score+=2;
      }

      if(partForm.brand!=null){
        score+=2;
      }
      print(score);
      emit(score);
  }

  clearScore(){
    emit(0); // if you need to force reset score
  }

  @override
  Future<void> close() { 
    editItemSubscription.cancel();
    return super.close();
  }
}

