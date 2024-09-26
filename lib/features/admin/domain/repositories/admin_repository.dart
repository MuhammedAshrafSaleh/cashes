import 'package:cashes/app/core/errors/app_errors.dart';
import 'package:cashes/app/models/app_user.dart';
import 'package:cashes/app/models/project.dart';
import 'package:dartz/dartz.dart';

abstract class AdminRepository {
  Future<Either<Failure, List<AppUser>>> getUsers();
  Future<Either<Failure, List<Project>>> getProjects({
    required String userId,
  });
}

class GetProjectsParams {
  final String id;
  GetProjectsParams({required this.id});
}
