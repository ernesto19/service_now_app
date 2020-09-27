import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/home/data/models/category_model.dart';
import 'package:service_now/features/home/presentation/bloc/bloc.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';

import '../../injection_container.dart';

class SettingsCategories extends StatelessWidget {
  static final routeName = 'settings_categories_page';

  @override
  Widget build(BuildContext context) {
    final bloc = CategoryBloc.of(context);
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Configuración servicios', style: labelTitleForm),
    //     backgroundColor: primaryColor
    //   ),
    //   body: buildBody(context)
    // );
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (_, state) {
      // return ListView.builder(
      //   scrollDirection: Axis.vertical,
      //   primary: false,
      //   itemCount: state.categories.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     return SingleChildScrollView(
      //       child: Container(
      //         child: CheckboxListTile(
      //           title: Text(state.categories[index].name),
      //           value: state.categories[index].favorite,
      //           onChanged: (bool value) {
      //             // bloc.add(OnFavoritesEvent(state.categories[index].id));
      //           },
      //         )
      //       )
      //     );
      //   }
      // );
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final CategoryModel category = state.categories[index];
            return CheckboxListTile(
              title: Text(category.name),
              value: category.favorite,
              onChanged: (bool value) {
                bloc.add(OnFavoritesEvent(category.id));
              }
            );
          },
          childCount: state.categories.length
        )
      );
    });
  }

  BlocProvider<CategoryBloc> buildBody(BuildContext contextoA) {
    return BlocProvider(
      create: (contextoB) => sl<CategoryBloc>(),
      child: Container(
        // child: ListView.builder(
        //   scrollDirection: Axis.vertical,
        //   primary: false,
        //   itemCount: state.categories.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     return SingleChildScrollView(
        //       child: Container(
        //         child: CheckboxListTile(
        //           title: Text(state.categories[index].name),
        //           value: state.categories[index].favorite,
        //           onChanged: (bool value) {
        //             bloc.add(OnFavoritesEvent(state.categories[index].id));
        //           },
        //         )
        //       )
        //     );
        //   }
        // )
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (contextoC, state) {
            // if (state is Loaded) {
            // if (state.status == CategoryStatus.checking) {
            //   return CircularProgressIndicator();
              // return ListView.builder(
              //   scrollDirection: Axis.vertical,
              //   primary: false,
              //   itemCount: state.categories.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     final CategoryModel category = state.categories[index];
              //     return SingleChildScrollView(
              //       child: Container(
              //         child: CheckboxListTile(
              //           title: Text(category.name),
              //           value: category.favorite,
              //           onChanged: (bool value) {
              //             // final bloc = CategoryBloc.of(context);
              //             // bloc.add(OnFavoritesEvent(state.categories[index].id));

              //             BlocProvider.of<CategoryBloc>(contextoC).add(OnFavoritesEvent(category.id));
              //             // bloc.add(OnFavoritesEvent(state.categories[index].id));
              //           },
              //         )
              //       )
              //     );
              //   }
              // );
            // } else {
              // return CircularProgressIndicator();
              return ListView.builder(
                scrollDirection: Axis.vertical,
                primary: false,
                itemCount: state.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  final CategoryModel category = state.categories[index];
                  return SingleChildScrollView(
                    child: Container(
                      child: CheckboxListTile(
                        title: Text(category.name),
                        value: category.favorite,
                        onChanged: (bool value) {
                          // final bloc = CategoryBloc.of(context);
                          // bloc.add(OnFavoritesEvent(state.categories[index].id));

                          BlocProvider.of<CategoryBloc>(contextoC).add(OnFavoritesEvent(category.id));
                          // bloc.add(OnFavoritesEvent(state.categories[index].id));
                        },
                      )
                    )
                  );
                }
              );
            // }
          }
        )
      )
    );
  }
}