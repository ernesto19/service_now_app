import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/blocs/category/bloc.dart';

class SettingsCategories extends StatefulWidget {
  static final routeName = 'settings_categories_page';

  @override
  _SettingsCategoriesState createState() => _SettingsCategoriesState();
}

class _SettingsCategoriesState extends State<SettingsCategories> {
  final CategoryBloc _bloc = CategoryBloc();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Configuración servicios', style: labelTitleForm),
          backgroundColor: primaryColor
        ),
        body: BlocProvider.value(
          value: _bloc,
          child: Container(
            child: BlocBuilder<CategoryBloc, CategoryState> (
              builder: (_, state) {
                if (state.status == CategoryStatus.ready) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    primary: false,
                    itemCount: state.services.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SingleChildScrollView(
                        child: Container(
                          child: CheckboxListTile(
                            title: Text(state.services[index].name),
                            value: state.services[index].favorite,
                            onChanged: (bool value) {
                              setState(() {
                                state.services[index].favorite = value;
                              });
                            },
                          )
                        )
                      );
                    }
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator()
                  );
                }
              }
            )
          )
        )
      )
    );
  }
}