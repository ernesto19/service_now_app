import 'package:flutter/material.dart';
import 'package:service_now/blocs/category/bloc.dart';
import 'package:service_now/models/user.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/pages/home/widgets/category_picker.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'widgets/home_header.dart';
import 'widgets/menu.dart';

class HomePage extends StatefulWidget {
  static final routeName = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = User();
  final GlobalKey<InnerDrawerState> _drawerKey = GlobalKey();
  final CategoryBloc _bloc = CategoryBloc();
  String _iniciales = '';

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context).settings.arguments;
      if (args != null) {
        setState(() {
          user = args;
        });
      }
    });

    _iniciales = UserPreferences.instance.lastName.toString().isEmpty ? UserPreferences.instance.firstName.substring(0, 2) : UserPreferences.instance.firstName.substring(0, 1) + UserPreferences.instance.lastName.substring(0, 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc, 
      child: InnerDrawer(
        key: _drawerKey,
        onTapClose: true,
        rightChild: Menu(),
        scaffold: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: CustomScrollView(
                      slivers: [
                        HomeHeader(
                          name: _iniciales,
                          drawerKey: this._drawerKey
                        ),

                        BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (_, state) {
                            if (state.status == CategoryStatus.ready) {
                              return ServicePicker();
                            }

                            String text = '';
                            switch (state.status) {
                              case CategoryStatus.checking:
                                text = 'Checking DB ...';
                                break;
                              case CategoryStatus.loading:
                                text = 'Loading services ...';
                                break;
                              default: text = '';
                            }

                            return SliverFillRemaining(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: LinearProgressIndicator(),
                                  ),
                                  Text(text)
                                ]
                              )
                            );
                          }
                        )
                      ]
                    )
                  )
                ]
              )
            )
          )
        )
      )
    );
  }
}