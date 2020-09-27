import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:service_now/features/home/presentation/bloc/bloc.dart';
import 'package:service_now/pages/service/search_service.dart';
import 'package:permission_handler/permission_handler.dart';

class CategoryPicker extends StatefulWidget {

  const CategoryPicker();

  @override
  _CategoryPickerState createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> with WidgetsBindingObserver {
  bool _fromSettings = false;
  Category _category;

  Future<void> _request() async {
    final PermissionStatus status = await Permission.locationWhenInUse.request();

    switch (status) {
      case PermissionStatus.undetermined:
        break;
      case PermissionStatus.granted:
        this._goToMap();
        break;
      case PermissionStatus.denied:
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.permanentlyDenied:
        await openAppSettings();
        _fromSettings = true;
        break;
    }
  }

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _fromSettings) {
      this._check();
    }
  }

  _check() async {
    final bool hasAccess = await Permission.locationWhenInUse.isGranted;
    if (hasAccess) {
      this._goToMap();
    }
  }

  _goToMap() {
    // Navigator.pushNamed(context, SearchService.routeName, arguments: _category);
    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchService(category: _category)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState> (builder: (_, state) {
      List<Category> lista = List();
      if (state.status == CategoryStatus.ready) {
        lista = state.categories.where((element) => element.favorite == 1).toList();
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return GestureDetector(
              child: Container(
                margin: EdgeInsets.only(bottom: 10, right: 15, left: 15),
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.network(
                        lista[index].logo,
                        fit: BoxFit.fill
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [ Colors.white12, Colors.black87 ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                          )
                        )
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Text(
                            lista[index].name,
                            style: TextStyle(
                              inherit: true,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'raleway',
                              shadows: [
                                Shadow(
                                  offset: Offset(-1.5, -1.5),
                                  color: Colors.black
                                ),
                                Shadow(
                                  offset: Offset(1.5, -1.5),
                                  color: Colors.black
                                ),
                                Shadow(
                                  offset: Offset(1.5, 1.5),
                                  color: Colors.black
                                ),
                                Shadow(
                                  offset: Offset(-1.5, 1.5),
                                  color: Colors.black
                                )
                              ]
                            )
                          ),
                        ),
                      )
                    ]
                  )
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: Offset(2, 2)
                    )
                  ]
                )
              ),
              onTap: () {
                _category = lista[index];
                print(lista[index].id);
                _request();
              }
            );
          },
          childCount: lista.length
        ),
      );
    });
  }
}