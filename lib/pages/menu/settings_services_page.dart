import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:service_now/features/home/presentation/bloc/bloc.dart';
import 'package:service_now/features/home/presentation/widgets/home_bottom_bar.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import '../../injection_container.dart';

class SettingsCategories extends StatefulWidget {
  static final routeName = 'settings_categories_page';

  @override
  _SettingsCategoriesState createState() => _SettingsCategoriesState();
}

class _SettingsCategoriesState extends State<SettingsCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración categorías', style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: buildBody(context),
      bottomNavigationBar: HomeBottomBar()
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
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      final bloc = CategoryBloc.of(context);

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final Category category = state.categories[index];
                            return CheckboxListTile(
                              title: Text(category.name),
                              value: category.favorite == 1,
                              activeColor: secondaryDarkColor,
                              onChanged: (bool value) {
                                bloc.add(OnFavoritesEvent(category.id));
                              }
                            );
                          },
                          childCount: state.categories.length
                        )
                      );
                    }
                  ),
                  // SliverToBoxAdapter(
                  //   child: Container(
                  //     padding: EdgeInsets.only(top: 40),
                  //     child: RoundedButton(
                  //       onPressed: () {}, 
                  //       label: 'Guardar',
                  //       backgroundColor: secondaryDarkColor
                  //     ),
                  //   )
                  // )
                ]
              )
            )
          ]
        )
      ),
    );
  }
}