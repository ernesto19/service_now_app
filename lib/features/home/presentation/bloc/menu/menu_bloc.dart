import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/home/domain/usecases/get_permissions_by_user.dart';
import 'package:meta/meta.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/features/login/domain/entities/user.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetPermissionsByUser getPermissionsByUser;

  MenuBloc({
    @required GetPermissionsByUser permissions,
  }) : assert(permissions != null),
       getPermissionsByUser = permissions {
       add(GetPermissionsForUser());
  }

  @override
  MenuState get initialState => MenuState.inititalState;

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is GetPermissionsForUser) {
      final failureOrPermissions = await getPermissionsByUser(NoParams());

      yield* _eitherLoadedOrErrorState(failureOrPermissions);
    } 
  }

  Stream<MenuState> _eitherLoadedOrErrorState(
    Either<Failure, List<Permission>> failureOrPermissions
  ) async * {
    yield failureOrPermissions.fold(
      (failure) {
        return this.state.copyWith(status: MenuStatus.error, permissions: []);
      },
      (permissions) {
        return this.state.copyWith(status: MenuStatus.ready, permissions: permissions);
      }
    );
  }

  static MenuBloc of(BuildContext context) {
    return BlocProvider.of<MenuBloc>(context);
  }
}