import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:service_now/features/login/domain/entities/user.dart';

enum MenuStatus { checking, loading, selecting, downloading, ready, error, logOut }

class MenuState extends Equatable {
  final List<Permission> permissions;
  final MenuStatus status;

  MenuState({ @required this.permissions, @required this.status });

  static MenuState get inititalState => MenuState(
    status: MenuStatus.checking,
    permissions: const []
  );

  MenuState copyWith({
    List<Permission> permissions,
    MenuStatus status,
  }) {
    return MenuState(
      permissions: permissions ?? this.permissions,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [permissions, status];
}