import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/presentation/bloc/bloc.dart';
import 'package:service_now/libs/search_api.dart';
import 'package:service_now/models/place.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<ProfessionalBloc>(context);

    return BlocBuilder<ProfessionalBloc, ProfessionalState>(
      builder: (_, state) {
        return Container(
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  child: Row(
                    children: [
                      Text('Buscar ...'),
                      Icon(Icons.search)
                    ],
                  ), 
                  onPressed: () async {
                    SearchPlaceDelegate delegate = SearchPlaceDelegate();
                    final Place place = await showSearch<Place>(context: context, delegate: delegate);

                    if (place != null) {

                    }
                  }
                )
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 50);
}

class SearchPlaceDelegate extends SearchDelegate<Place> {
  final SearchAPI _api = SearchAPI.instance;

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
        future: _api.searchPlace(this.query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(snapshot.data[index].title, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(snapshot.data[index].vicinity.replaceAll('<br/>', ' - '), style: TextStyle(fontSize: 12))
                );
              },
              itemCount: snapshot.data.length
            );
          } else if (snapshot.hasError) {
            return Text('ERROR!');
          } 
          
          return CircularProgressIndicator();
        }
      );
    } else {
      return Text('');
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('');
  }
}