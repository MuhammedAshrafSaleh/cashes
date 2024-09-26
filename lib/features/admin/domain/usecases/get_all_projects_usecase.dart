import 'package:cashes/app/core/errors/app_errors.dart';
import 'package:cashes/app/core/usecase/usecase.dart';
import 'package:cashes/app/models/project.dart';
import 'package:cashes/features/admin/domain/repositories/admin_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllProjectsUsecase
    implements UseCase<List<Project>, GetProjectsParams> {
  AdminRepository adminRepository;
  GetAllProjectsUsecase({required this.adminRepository});
  @override
  Future<Either<Failure, List<Project>>> call(GetProjectsParams params) async {
    return await adminRepository.getProjects(userId: params.id);
  }
}

class GetProjectsParams {
  final String id;
  GetProjectsParams({required this.id});
}
