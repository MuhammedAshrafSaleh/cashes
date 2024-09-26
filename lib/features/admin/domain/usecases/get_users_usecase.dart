// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:cashes/app/core/errors/app_errors.dart';
import 'package:cashes/app/core/usecase/usecase.dart';
import 'package:cashes/app/models/app_user.dart';
import 'package:cashes/features/admin/domain/repositories/admin_repository.dart';

class GetUsersUsecase implements UseCase<List<AppUser>, NoParams> {
  AdminRepository adminRepository;
  GetUsersUsecase({required this.adminRepository});

  @override
  Future<Either<Failure, List<AppUser>>> call(NoParams params) async {
    return await adminRepository.getUsers();
  }
}
