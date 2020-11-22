import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:meta/meta.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/features/home/domain/entities/membership.dart';
import 'package:service_now/features/home/domain/usecases/acquire_membership_by_user.dart';
import 'package:service_now/features/home/domain/usecases/get_membership_by_user.dart';
import 'package:service_now/features/home/presentation/pages/home_page.dart';
import 'package:service_now/features/login/data/responses/login_response.dart';
import 'package:service_now/utils/all_translations.dart';
import 'membership_event.dart';
import 'membership_state.dart';

class MembershipBloc extends Bloc<MembershipEvent, MembershipState> {
  final AcquireMembershipByUser acquireMembershipByUser;
  final GetMembershipByUser getMembershipByUser;

  MembershipBloc({
    @required AcquireMembershipByUser acquireMembership,
    @required GetMembershipByUser getMembership
  }) : assert(acquireMembership != null, getMembership != null),
       acquireMembershipByUser = acquireMembership,
       getMembershipByUser = getMembership;

  @override
  MembershipState get initialState => MembershipState.inititalState;

  @override
  Stream<MembershipState> mapEventToState(MembershipEvent event) async* {
    if (event is AcquireMembershipForUser) {
      this._showProgressDialog(event.context);

      final failureOrSuccess = await acquireMembershipByUser(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrSuccess);

      if (state.status == MembershipStatus.ready) {
        Navigator.pushNamedAndRemoveUntil(event.context, HomePage.routeName, (Route<dynamic> route) => false);
      }
    } else if (event is GetMembershipForUser) {
      final failureOrMembership = await getMembershipByUser(NoParams());
      yield* _eitherLoadedMembershipOrErrorState(failureOrMembership);
    }
  }

  Stream<MembershipState> _eitherLoadedOrErrorState(
    Either<Failure, LoginResponse> failureOrSuccess
  ) async * {
    yield failureOrSuccess.fold(
      (failure) {
        return this.state.copyWith(status: MembershipStatus.error);
      },
      (success) {
        return this.state.copyWith(status: MembershipStatus.ready);
      }
    );
  }

  Stream<MembershipState> _eitherLoadedMembershipOrErrorState(
    Either<Failure, Membership> failureOrMembership
  ) async * {
    yield failureOrMembership.fold(
      (failure) {
        return this.state.copyWith(status: MembershipStatus.error);
      },
      (membership) {
        return this.state.copyWith(status: MembershipStatus.ready, membership: membership);
      }
    );
  }

  void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircularProgressIndicator(),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(allTranslations.traslate('acquiring_membership_message'), style: TextStyle(fontSize: 15.0)),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  static MembershipBloc of(BuildContext context) {
    return BlocProvider.of<MembershipBloc>(context);
  }
}