import 'package:flutter/material.dart';
import 'package:service_now/features/home/presentation/bloc/bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/models/user.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/pages/home/widgets/category_picker.dart';
import 'package:service_now/pages/menu/settings_services_page.dart';
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
  String _iniciales = '';

  @override
  void dispose() {
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
    return InnerDrawer(
      key: _drawerKey,
      onTapClose: true,
      rightChild: Menu(),
      scaffold: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: buildBody(context)
        )
      )
    );
  }

  BlocProvider<CategoryBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoryBloc>(),
      child: Container(
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
                    builder: (context, state) {
                      String text = '';

                      // if (state is Loaded) {
                      if (state.status == CategoryStatus.ready) {
                        // return ServicePicker();
                        return SettingsCategories();
                      // } else if (state is Loading) {
                      } else if (state.status == CategoryStatus.checking) {
                        text = 'Cargando ...';
                      } else if (state.status == CategoryStatus.selecting) {
                        return SettingsCategories();
                      } else {
                        text = 'Error';
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
      ),
    );
  }
}