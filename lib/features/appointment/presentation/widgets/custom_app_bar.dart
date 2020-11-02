import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';
import 'package:service_now/libs/search_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomAppBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<AppointmentBloc>(context);

    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (_, state) {
        return Container(
          padding: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.black38, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    child: Text(
                      'Buscar',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 17
                      )
                    )
                  ),
                  onTap: () async {
                    final List<Business> history = state.history.values.toList();
                    SearchPlaceDelegate delegate = SearchPlaceDelegate(
                      state.myLocation,
                      history
                    );
                    final Business business = await showSearch<Business>(
                      context: context,
                      delegate: delegate
                    );

                    if (business != null) {
                      bloc.goToPlace(business, context);
                    }
                  }
                )
              )
            ]
          )
        );
      }
    );
  }
}

class SearchPlaceDelegate extends SearchDelegate<Business> {
  final LatLng at;
  final List<Business> history;
  final SearchAPI _api = SearchAPI.instance;

  SearchPlaceDelegate(this.at, this.history);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: () {
          this.query = '';
        }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back), 
      onPressed: () {
        close(context, null);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (this.query.trim().length > 3) {
      return FutureBuilder<List<Business>>(
        future: _api.searchBusiness(this.query, this.at),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (_, index) {
                final Business business = snapshot.data[index];
                return ListTile(
                  title: Text(business.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(business.address, style: TextStyle(fontSize: 12)),
                  onTap: () => this.close(context, business)
                );
              },
              itemCount: snapshot.data.length
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('ERROR!')
            );
          } 
          
          return Center(
            child: CircularProgressIndicator()
          );
        }
      );
    } else {
      return Text('');
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Business> history = this.history;

    if (this.query.trim().length > 0) {
      final tmp = this.query.toLowerCase();
      history = history.where((element) {
        if (element.name.toLowerCase().contains(tmp)) {
          return true;
        } else if (element.address.toLowerCase().contains(tmp)) {
          return true;
        }

        return false;
      }).toList();
    }

    return ListView.builder(
      itemBuilder: (_, index) {
        final Business place = history[index];
        return ListTile(
          leading: Icon(Icons.history),
          onTap: () => this.close(context, place),
          title: Text(
            place.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(place.address),
        );
      },
      itemCount: history.length,
    );
  }
}