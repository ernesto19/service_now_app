import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:service_now/features/home/presentation/bloc/bloc.dart';
import 'package:service_now/features/home/presentation/widgets/home_bottom_bar.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import '../../../../injection_container.dart';

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
        title: Text(allTranslations.traslate('categories_settings_title'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: buildBody(context),
      bottomNavigationBar: HomeBottomBar()
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
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      // ignore: close_sinks
                      final bloc = HomeBloc.of(context);

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