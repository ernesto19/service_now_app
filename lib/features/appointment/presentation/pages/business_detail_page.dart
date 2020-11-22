import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/responsive.dart';
import 'business_information_page.dart';
import 'business_photos_page.dart';

class BusinessDetailPage extends StatefulWidget {
  static final routeName = 'business_detail_page';
  final Business business;

  const BusinessDetailPage({ @required this.business});

  @override
  _BusinessDetailPageState createState() => _BusinessDetailPageState();
}

class _BusinessDetailPageState extends State<BusinessDetailPage> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: responsive.hp(35),
                floating: false,
                flexibleSpace: CarouselSlider(
                  options: CarouselOptions(
                    height: 350
                  ),
                  items: widget.business.gallery.map((item) => Container(
                    child: Center(
                      child: Image.network(item.url, fit: BoxFit.cover, width: 1000, height: 350)
                    ),
                  )).toList()
                )
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: allTranslations.traslate('information_tab_title')),
                      Tab(text: allTranslations.traslate('photos_tab_title'))
                    ]
                  )
                )
              )
            ];
          },
          body: TabBarView(
            children: [
              BusinessInformationPage(business: widget.business),
              BusinessPhotosPage(business: widget.business),
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
      child: _tabBar
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}