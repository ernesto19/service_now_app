import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/bloc.dart';
import 'package:service_now/features/professional/presentation/widgets/professional_business_information_page.dart';
import 'package:service_now/features/professional/presentation/widgets/professional_business_services_page.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';

class ProfessionalBusinessDetailPage extends StatefulWidget {
  static final routeName = 'professional_services_page';
  final ProfessionalBusiness business;

  const ProfessionalBusinessDetailPage({ @required this.business });

  @override
  _ProfessionalBusinessDetailPageState createState() => _ProfessionalBusinessDetailPageState();
}

class _ProfessionalBusinessDetailPageState extends State<ProfessionalBusinessDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context)
    );
  }

  BlocProvider<ProfessionalBloc>  buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfessionalBloc>(),
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: primaryColor,
                title: Text(widget.business.name),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    indicatorColor: secondaryDarkColor,
                    tabs: [
                      Tab(text: allTranslations.traslate('information_tab_title')),
                      Tab(text: allTranslations.traslate('services_tab_title'))
                    ]
                  )
                )
              )
            ];
          },
          body: TabBarView(
            children: [
              ProfessionalBusinessInformationPage(business: widget.business),
              ProfessionalBusinessServicesPage(business: widget.business)
            ]
          )
        )
      )
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: primaryColor,
      child: _tabBar
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}