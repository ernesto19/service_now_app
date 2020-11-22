import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/home/domain/entities/membership.dart';
import 'package:service_now/features/home/presentation/bloc/membership/bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';

class MembershipPage extends StatelessWidget {
  static final routeName = 'membership_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membresía', style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: buildBody(context)
    );
  }

  BlocProvider<MembershipBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MembershipBloc>(),
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15),
              child: CustomScrollView(
                slivers: [
                  BlocBuilder<MembershipBloc, MembershipState>(
                    builder: (context, state) {
                      // ignore: close_sinks
                      final bloc = MembershipBloc.of(context);
                      bloc.add(GetMembershipForUser());

                      if (state.status == MembershipStatus.ready) {
                        final Membership membership = state.membership;

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.only(top: 30),
                                child: Column(
                                  children: [
                                    Text('Estado', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5),
                                    Container(
                                      child: Text(membership.active == 1 ? 'ACTIVO' : 'INACTIVO', style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.center),
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: membership.active == 1 ? Colors.green : Colors.red,
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                      )
                                    ),
                                    SizedBox(height: 15),
                                    Text('Inicio membresía', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5),
                                    Text(membership.acquisitionDate, style: TextStyle(fontSize: 17)),
                                    SizedBox(height: 15),
                                    Text('Expiración membresía', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5),
                                    Text(membership.expiration, style: TextStyle(fontSize: 17))
                                  ]
                                )
                              );
                            },
                            childCount: 1
                          )
                        );
                      } else {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                  child: CircularProgressIndicator()
                                )
                              );
                            },
                            childCount: 1
                          )
                        );
                      }
                    }
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }
}