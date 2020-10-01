import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/features/home/domain/entities/category.dart';
import '../../blocs/maps/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../detail_page.dart';

class SearchService extends StatefulWidget {
  static final routeName = 'search_service_page';
  final Category category;

  SearchService({Key key, this.category}) : super(key: key);

  @override
  _SearchServiceState createState() => _SearchServiceState();
}

final List<String> imgList = [
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
  'https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350'
];

class _SearchServiceState extends State<SearchService> {
  final MapBloc _bloc = MapBloc();
  
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
            BlocBuilder<MapBloc, MapState>(
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
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(left: 20, top: 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('BARBERIA ABC$index', style: TextStyle(fontSize: 17)),
                                                SizedBox(height: 2),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text('3.5'),
                                                    SizedBox(width: 2),
                                                    RatingBar(
                                                      initialRating: 3.5,
                                                      minRating: 1,
                                                      direction: Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 20,
                                                      itemBuilder: (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber
                                                      ),
                                                      ignoreGestures: true,
                                                      onRatingUpdate: null
                                                    )
                                                  ]
                                                ),
                                                SizedBox(height: 2),
                                                Text('450 km'),
                                                SizedBox(height: 10)
                                              ]
                                            )
                                          ),
                                          Container(
                                            height: 170.0,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: imgList.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  margin: EdgeInsets.only(right: 10),
                                                  height: 200,
                                                  width: 200,
                                                  child: Image.network(
                                                    imgList[index], 
                                                    fit: BoxFit.cover
                                                  )
                                                );
                                              }
                                            )
                                          )
                                        ]
                                      )
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, BusinessDetailPage.routeName);
                                    }
                                  ),
                                  SizedBox(height: 10)
                                ]
                              );
                            },
                            childCount: 5
                          )
                        )
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

class CustomGoogleMap extends StatelessWidget {
  const CustomGoogleMap({
    Key key,
    @required CameraPosition initialPosition,
  }) : _initialPosition = initialPosition, super(key: key);

  final CameraPosition _initialPosition;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: GoogleMap(
        initialCameraPosition: _initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false
      )
    );
  }
}

// BUSCADOR
class CustomHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomSearchContainer(),
      ],
    );
  }
}

class CustomSearchContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 8), 
      child: Container(
        height: 50,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: <Widget>[
            CustomTextField()
          ]
        )
      )
    );
  }
}

class CustomTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        maxLines: 1,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          hintText: "Buscar",
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class CustomUserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(color: Colors.grey[500], borderRadius: BorderRadius.circular(16)),
    );
  }
}

class CustomSearchCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          SizedBox(width: 16),
          CustomCategoryChip(Icons.fastfood, "Takeout"),
          SizedBox(width: 12),
          CustomCategoryChip(Icons.directions_bike, "Delivery"),
          SizedBox(width: 12),
          CustomCategoryChip(Icons.local_gas_station, "Gas"),
          SizedBox(width: 12),
          CustomCategoryChip(Icons.shopping_cart, "Groceries"),
          SizedBox(width: 12),
          CustomCategoryChip(Icons.local_pharmacy, "Pharmacies"),
          SizedBox(width: 12),
        ],
      ),
    );
  }
}

class CustomCategoryChip extends StatelessWidget {
  final IconData iconData;
  final String title;

  CustomCategoryChip(this.iconData, this.title);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Row(
        children: <Widget>[Icon(iconData, size: 16), SizedBox(width: 8), Text(title)],
      ),
      backgroundColor: Colors.grey[50],
    );
  }
}