import 'package:flutter/material.dart';

abstract class MembershipEvent {}

class AcquireMembershipForUser extends MembershipEvent {
  final BuildContext context;

  AcquireMembershipForUser(this.context);
}

class GetMembershipForUser extends MembershipEvent {
  GetMembershipForUser();
}