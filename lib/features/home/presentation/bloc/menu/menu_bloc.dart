import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/home/domain/usecases/get_permissions_by_user.dart';
import 'package:meta/meta.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/features/home/domain/usecases/log_out_by_user.dart';
import 'package:service_now/features/login/domain/entities/user.dart';
import 'package:service_now/features/login/presentation/pages/login_page.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetPermissionsByUser getPermissionsByUser;
  final LogOutByUser logOutByUser;

  MenuBloc({
    @required GetPermissionsByUser permissions,
    @required LogOutByUser logOut
  }) : assert(permissions != null, logOut != null),
       getPermissionsByUser = permissions,
       logOutByUser = logOut {
       add(GetPermissionsForUser());
  }

  @override
  MenuState get initialState => MenuState.inititalState;

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is GetPermissionsForUser) {
      final failureOrPermissions = await getPermissionsByUser(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrPermissions);
    } else if (event is LogOutForUser) {
      final failureOrLogOut = await logOutByUser(NoParams());
      yield* _eitherLogOutOrErrorState(failureOrLogOut);

      if (state.status == MenuStatus.logOut) {
        this._clearData();
        Navigator.pushNamed(event.context, LoginPage.routeName);
      }
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

  Stream<MenuState> _eitherLogOutOrErrorState(
    Either<Failure, int> failureOrLogOut
  ) async * {
    yield failureOrLogOut.fold(
      (failure) {
        return this.state.copyWith(status: MenuStatus.error);
      },
      (logOut) {
        return this.state.copyWith(status: MenuStatus.logOut);
      }
    );
  }

  void _clearData() {
    UserPreferences.instance.token = '';
    UserPreferences.instance.email = '';
    UserPreferences.instance.firstName = '';
    UserPreferences.instance.lastName = '';
    UserPreferences.instance.profileId = 0;
    UserPreferences.instance.userId = 0;
  }

  static MenuBloc of(BuildContext context) {
    return BlocProvider.of<MenuBloc>(context);
  }
}