import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/address/bloc.dart';
import 'package:service_now/libs/search_api.dart';
import 'package:service_now/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/utils/all_translations.dart';

class CustomAppBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<AddressBloc>(context);

    return BlocBuilder<AddressBloc, AddressState>(
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
                        allTranslations.traslate('buscar'),
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 17
                        )
                      )
                    ),
                    onTap: () async {
                      final List<Place> history = state.history.values.toList();
                      SearchPlaceDelegate delegate = SearchPlaceDelegate(
                        state.myLocation,
                        history
                      );
                      final Place place = await showSearch<Place>(
                        context: context,
                        delegate: delegate
                      );

                      if (place != null) {
                        bloc.goToPlace(place);
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

class SearchPlaceDelegate extends SearchDelegate<Place> {
  final LatLng at;
  final List<Place> history;
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
      return FutureBuilder<List<Place>>(
        future: _api.searchPlace(this.query, this.at),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (_, index) {
                final Place place = snapshot.data[index];
                return ListTile(
                  title: Text(place.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(place.vicinity.replaceAll('<br/>', ' - '), style: TextStyle(fontSize: 12)),
                  onTap: () => this.close(context, place)
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
    List<Place> history = this.history;

    if (this.query.trim().length > 0) {
      final tmp = this.query.toLowerCase();
      history = history.where((element) {
        if (element.title.toLowerCase().contains(tmp)) {
          return true;
        } else if (element.vicinity.toLowerCase().contains(tmp)) {
          return true;
        }

        return false;
      }).toList();
    }

    return ListView.builder(
      itemBuilder: (_, index) {
        final Place place = history[index];
        return ListTile(
          leading: Icon(Icons.history),
          onTap: () => this.close(context, place),
          title: Text(
            place.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(place.vicinity.replaceAll('<br/>', ' - ')),
        );
      },
      itemCount: history.length,
    );
  }
}