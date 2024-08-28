import '../../models/project.dart';

class ProjectListStates {}

class InitailStates extends ProjectListStates {}

class LoadingState extends ProjectListStates {}

class ErrorState extends ProjectListStates {
  String errorMessage;
  ErrorState({required this.errorMessage});
}

class SuccessState extends ProjectListStates {
  List<Project> projects;
  SuccessState({required this.projects}); 
}
