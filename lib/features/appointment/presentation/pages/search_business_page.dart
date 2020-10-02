import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';
import 'package:service_now/features/appointment/presentation/widgets/business_list.dart';
import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/custom_google_map.dart';
import '../widgets/custom_search.dart';

class SearchBusinessPage extends StatefulWidget {
  static final routeName = 'search_business_page';
  final Category category;

  SearchBusinessPage({Key key, this.category}) : super(key: key);

  @override
  _SearchBusinessPageState createState() => _SearchBusinessPageState();
}

class _SearchBusinessPageState extends State<SearchBusinessPage> {
  final AppointmentBloc _bloc = AppointmentBloc();
  
  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: this._bloc,
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<AppointmentBloc, AppointmentState>(
              builder: (_, state) {
                if (state.loading) {
                  return Center(
                    child: CircularProgressIndicator()
                  );
                }

                final CameraPosition initialPosition = CameraPosition(target: state.myLocation, zoom: 15);

                return CustomGoogleMap(initialPosition: initialPosition);
              }
            ),
            CustomHeader(),
            DraggableScrollableSheet(
              initialChildSize: 0.40,
              minChildSize: 0.15,
              builder: (BuildContext context, ScrollController scrollController) {
                return Card(
                  color: Colors.grey[200],
                  elevation: 12.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              color: Colors.white
                            )
                          )
                        ),
                        BusinessList()
                      ]
                    )
                  )
                );
              }
            )
          ]
        )
      )
    );
  }
}

class CustomHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomSearch(),
      ],
    );
  }
}