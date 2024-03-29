import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/blocs/user_bloc.dart';
import 'package:service_now/features/home/presentation/bloc/menu/menu_bloc.dart';
import 'package:service_now/features/home/presentation/bloc/menu/menu_event.dart';
import 'package:service_now/features/home/presentation/bloc/menu/menu_state.dart';
import 'package:service_now/features/home/presentation/pages/conditions_page.dart';
import 'package:service_now/features/home/presentation/pages/membership_page.dart';
import 'package:service_now/features/home/presentation/pages/messages_page.dart';
import 'package:service_now/features/home/presentation/pages/profile_page.dart';
import 'package:service_now/features/home/presentation/pages/service_tray_page.dart';
import 'package:service_now/features/home/presentation/pages/settings_services_page.dart';
import 'package:service_now/features/home/presentation/widgets/web_view_membership.dart';
import 'package:service_now/features/login/domain/entities/user.dart';
import 'package:service_now/features/professional/presentation/pages/pending_service_tray_page.dart';
import 'package:service_now/features/professional/presentation/pages/professional_business_page.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/widgets/expired_token_dialog.dart';
import 'package:service_now/widgets/rounded_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          final menuBloc = MenuBloc.of(context);
          menuBloc.add(GetPermissionsForUser());

          if (state.status == MenuStatus.ready) {
            List<Permission> permissions = state.permissions;
            permissions.sort((a, b) {
              return a.order.compareTo(b.order);
            });
            
            return Scaffold(
              key: _scaffoldKey,
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
                              onTap: () => _onTap(permissions[index].id, context, menuBloc)
                            );
                          }
                        )
                      ),
                      UserPreferences.instance.rol == 3 ? Container(
                        padding: EdgeInsets.all(10),
                        child: RoundedButton(
                          label: allTranslations.traslate('acquire_membership'),
                          backgroundColor: secondaryDarkColor,
                          width: double.infinity,
                          fontSize: 14,
                          icon: Container(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.person_add, color: Colors.white, size: 18)
                          ),
                          onPressed: () {
                            bloc.acquireMembership();
                            bloc.membershipResponse.listen((response) {
                              if (response.error == 0) {
                                // Navigator.pop(context);
                                // _openWeb(response.data);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewMembershipPage(url: response.data )));
                              } else if (response.message == 'Unauthenticated') {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return WillPopScope(
                                      onWillPop: () async => false,
                                      child: ExpiredTokenDialog()
                                    );
                                  }
                                );
                              } else {
                                Navigator.pop(_scaffoldKey.currentContext);
                                this._showDialog(allTranslations.traslate('registro_fallido'), response.message);
                              }
                            });
                          } 
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
              child: Text(allTranslations.traslate('loading_message')),
            ),
          );
        }
      )
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
          content: Text(message, style: TextStyle(fontSize: 16.0),),
          actions: <Widget>[
            FlatButton(
              child: Text(allTranslations.traslate('aceptar'), style: TextStyle(fontSize: 14.0)),
              onPressed: () => Navigator.pop(_scaffoldKey.currentContext)
            )
          ],
        );
      }
    );
  }

  _openWeb(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
      case 10:
        Navigator.pushNamed(context, ServiceTrayPage.routeName);
        break;
      case 4:
        Navigator.pushNamed(context, ConditionsPage.routeName);
        break;
      default:
    }
  }
}