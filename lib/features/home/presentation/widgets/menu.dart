import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/home/presentation/bloc/menu/menu_bloc.dart';
import 'package:service_now/features/home/presentation/bloc/menu/menu_event.dart';
import 'package:service_now/features/home/presentation/bloc/menu/menu_state.dart';
import 'package:service_now/features/home/presentation/pages/payment_gateway_page.dart';
import 'package:service_now/features/home/presentation/pages/settings_services_page.dart';
import 'package:service_now/features/professional/presentation/pages/professional_business_page.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/widgets/rounded_button.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MenuBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<MenuBloc, MenuState>(
            builder: (context, state) {
              // ignore: close_sinks
              final bloc = MenuBloc.of(context);

              if (state.status == MenuStatus.ready) {
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${UserPreferences.instance.firstName ?? ''} ${UserPreferences.instance.lastName ?? ''}', style: TextStyle(fontSize: 18)),
                            Text(UserPreferences.instance.email ?? '')
                          ]
                        )
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.permissions.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              leading: SvgPicture.asset(
                                state.permissions[index].icon,
                                height: 23
                              ),
                              title: Text(allTranslations.traslate(state.permissions[index].translateName)),
                              onTap: () => _onTap(state.permissions[index].id, context, bloc)
                            );
                          }
                        )
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: RoundedButton(
                          onPressed: () => Navigator.pushNamed(context, PaymentGatewayPage.routeName), 
                          label: allTranslations.traslate('acquire_membership'),
                          backgroundColor: secondaryDarkColor,
                          width: double.infinity,
                          fontSize: 14,
                          icon: Container(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.person_add, color: Colors.white, size: 18)
                          )
                        )
                      )
                    ]
                  )
                );
              }

              return Center(
                child: Text('Cargando ...'),
              );
            }
          )
        )
      )
    );
  }

  void _onTap(int id, BuildContext context, MenuBloc bloc) {
    switch (id) {
      case 2:
        Navigator.pushNamed(context, SettingsCategories.routeName);
        break;
      case 1:
        Navigator.pushNamed(context, ProfessionalBusinessPage.routeName);
        break;
      case 6:
        bloc.add(LogOutForUser(context));
        break;
      default:
    }
  }
}