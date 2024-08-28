import 'package:bloc/bloc.dart';
import 'package:cashes/app/screens/home/states.dart';

import '../../core/firebase configurations/firebase_firebase_manager.dart';

class ProjectListViewModel extends Cubit<ProjectListStates> {
  ProjectListViewModel() : super(LoadingState());
  // TODO: Hold Data - Handle Logic

  void getProjects({required userId}) async {
    try {
      emit(LoadingState());
      await FirebaseFirestoreManager.getAllProjectByUserId(userId: userId);
    } catch (e) {

    }
  }
}
