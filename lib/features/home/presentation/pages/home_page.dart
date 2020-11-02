import 'package:flutter/material.dart';
import 'package:service_now/features/home/presentation/bloc/bloc.dart';
import 'package:service_now/features/home/presentation/widgets/category_picker.dart';
import 'package:service_now/features/home/presentation/widgets/home_header.dart';
import 'package:service_now/features/home/presentation/widgets/menu.dart';
import 'package:service_now/injection_container.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/home/presentation/pages/settings_services_page.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';

class HomePage extends StatefulWidget {
  static final routeName = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<InnerDrawerState> _drawerKey = GlobalKey();
  String _iniciales = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
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

  BlocProvider<HomeBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>(),
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
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      String text = '';

                      if (state.status == HomeStatus.ready) {
                        return CategoryPicker();
                      } else if (state.status == HomeStatus.checking) {
                        text = allTranslations.traslate('loading_message');
                      } else if (state.status == HomeStatus.selecting) {
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