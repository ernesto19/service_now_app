import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/home/presentation/bloc/menu/menu_bloc.dart';
import 'package:service_now/features/home/presentation/bloc/menu/menu_event.dart';
import 'package:service_now/features/home/presentation/bloc/menu/menu_state.dart';
import 'package:service_now/features/home/presentation/pages/conditions_page.dart';
import 'package:service_now/features/home/presentation/pages/membership_page.dart';
import 'package:service_now/features/home/presentation/pages/messages_page.dart';
import 'package:service_now/features/home/presentation/pages/payment_gateway_page.dart';
import 'package:service_now/features/home/presentation/pages/profile_page.dart';
import 'package:service_now/features/home/presentation/pages/settings_services_page.dart';
import 'package:service_now/features/login/domain/entities/user.dart';
import 'package:service_now/features/professional/presentation/pages/pending_service_tray_page.dart';
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
      child: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          // ignore: close_sinks
          final bloc = MenuBloc.of(context);
          bloc.add(GetPermissionsForUser());

          if (state.status == MenuStatus.ready) {
            List<Permission> permissions = state.permissions;
            permissions.sort((a, b) {
              return a.order.compareTo(b.order);
            });
            
            return Scaffold(
              body: SafeArea(
                child: Container(
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
                          itemCount: permissions.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              leading: /*state.permissions[index].id == 7 
                              ? Badge(
                                badgeContent: Text('2', style: TextStyle(color: Colors.white, fontSize: 10)),
                                child: SvgPicture.asset(
                                  state.permissions[index].icon,
                                  height: 23
                                )
                              )
                              : */SvgPicture.asset(
                                permissions[index].icon,
                                height: 23
                              ),
                              title: Text(allTranslations.traslate(permissions[index].translateName)),
                              onTap: () => _onTap(permissions[index].id, context, bloc)
                            );
                          }
                        )
                      ),
                      UserPreferences.instance.rol == 3 ? Container(
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
                      ) : Container()
                    ]
                  )
                )
              )
            );
          }

          return Scaffold(
            body: Center(
              child: Text('Cargando ...'),
            ),
          );
        }
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
      case 7:
        Navigator.pushNamed(context, MessagesPage.routeName);
        break;
      case 8:
        Navigator.pushNamed(context, MembershipPage.routeName);
        break;
      case 3:
        Navigator.pushNamed(context, ProfilePage.routeName);
        break;
      case 9:
        Navigator.pushNamed(context, PendingServiceTrayPage.routeName);
        break;
      case 4:
        Navigator.pushNamed(context, ConditionsPage.routeName);
        break;
      default:
    }
  }
}