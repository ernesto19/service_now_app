import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/blocs/appointment_bloc.dart';
import 'package:service_now/features/appointment/domain/entities/service.dart';
import 'package:service_now/features/appointment/presentation/bloc/payment_services/bloc.dart';
import 'package:service_now/injection_container.dart';
// import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_now/utils/text_styles.dart';

class PaymentServicesPage extends StatefulWidget {
  static final routeName = 'payment_services_page';

  final double totalPrice;
  final List<Service> services;
  final int professionaUserId;

  const PaymentServicesPage({ @required this.totalPrice, @required this.services, @required this.professionaUserId });

  @override
  _PaymentServicesPageState createState() => _PaymentServicesPageState();
}

class _PaymentServicesPageState extends State<PaymentServicesPage> {
  final _creditCardNumberController = TextEditingController();
  final _fechaVencimientoController = TextEditingController();
  final _cvvController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  String creditNumber = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(allTranslations.traslate('payment_services'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: buildBody(context)
    );
  }

  BlocProvider<PaymentServicesBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PaymentServicesBloc>(),
      child: BlocBuilder<PaymentServicesBloc, PaymentServicesState>(
        builder: (context, state) {
          // ignore: close_sinks
          // final bloc = PaymentServicesBloc.of(context);

          return Container(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Container(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10, right: 15, left: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3,
                          spreadRadius: 1,
                          offset: Offset(2, 2)
                        )
                      ]
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _creditCardNumberController,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.credit_card, color: secondaryDarkColor),
                                      border: InputBorder.none,
                                      hintText: '4444 3333 2222 1111',
                                      suffixIcon: Container(
                                        child: creditNumber.length >= 4 ? SvgPicture.asset(
                                          creditNumber.substring(0, 4) == '4444' ? 'assets/icons/visa.svg' : creditNumber.substring(0, 4) == '3333' ? 'assets/icons/mastercard.svg' : 'assets/icons/american-express.svg',
                                          height: 20
                                        ) : SizedBox(width: 0)
                                      )
                                    ),
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() => creditNumber = text );
                                    }
                                  ),
                                ),
                                SizedBox(width: 20)
                              ],
                            ),
                            SizedBox(height: 5),
                            Divider(
                              height: 0.0, 
                              color: Colors.black87
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5),
                                      TextField(
                                        controller: _fechaVencimientoController,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.calendar_today, color: secondaryDarkColor),
                                          border: InputBorder.none,
                                          hintText: '10 / 2020'
                                        ),
                                        textAlignVertical: TextAlignVertical.center,
                                        style: TextStyle(fontSize: 14)
                                      ),
                                      SizedBox(height: 5)
                                    ]
                                  )
                                ),
                                Container(
                                  height: 58,
                                  width: 0.5,
                                  color: Colors.black87,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    controller: _cvvController,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock_outline, color: secondaryDarkColor),
                                      border: InputBorder.none,
                                      hintText: '123'
                                    ),
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(fontSize: 14)
                                  )
                                )
                              ]
                            ),
                            Divider(
                              height: 0.5, 
                              color: Colors.black87
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5),
                                      TextField(
                                        controller: _firstNameController,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person_outline, color: secondaryDarkColor),
                                          border: InputBorder.none,
                                          hintText: 'Nombre'
                                        ),
                                        textAlignVertical: TextAlignVertical.center,
                                        style: TextStyle(fontSize: 14)
                                      ),
                                      SizedBox(height: 5)
                                    ]
                                  )
                                ),
                                Container(
                                  height: 58,
                                  width: 0.5,
                                  color: Colors.black87,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    controller: _lastNameController,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person_outline, color: secondaryDarkColor),
                                      border: InputBorder.none,
                                      hintText: 'Apellido'
                                    ),
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(fontSize: 14)
                                  )
                                )
                              ]
                            )
                          ]
                        )
                      )
                    )
                  )
                ),
                SizedBox(height: 10),
                Container(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10, right: 15, left: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3,
                          spreadRadius: 1,
                          offset: Offset(2, 2)
                        )
                      ]
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.mail, color: secondaryDarkColor),
                                border: InputBorder.none,
                                hintText: 'nombre.apellido@mail.com'
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(fontSize: 14)
                            ),
                            SizedBox(height: 5)
                          ]
                        )
                      )
                    )
                  )
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: FlatButton(
                    color: secondaryDarkColor,
                    child: Container(
                      width: double.infinity * 0.5,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Pagar', style: TextStyle(color: Colors.white, fontSize: 19, fontFamily: 'raleway')),
                          SizedBox(width: 10),
                          Text('S/ ${widget.totalPrice}', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold, fontFamily: 'raleway'))
                        ],
                      )
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    // onPressed: () => bloc.add(PaymentServicesForUser(UserPreferences.instance.userId, widget.services, context))
                    onPressed: () {
                      this._showProgressDialog();
                      bloc.finalizarSolicitud(widget.services, widget.professionaUserId);
                      bloc.finalizarServicioResponse.listen((response) {
                        if (response.error == 0) {
                          Navigator.pop(_scaffoldKey.currentContext);
                          this._showDialog('Registro exitoso', 'La solicitud ha sido registrada exitosamente.');
                        } else {
                          Navigator.pop(_scaffoldKey.currentContext);
                          this._showDialog('Registro fallido', response.message);
                        }
                      });
                    }
                  ),
                )
              ]
            )
          );
        }
      )
    );
  }

  void _showProgressDialog() {
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (context) {
        return Container(
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircularProgressIndicator(),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(/*allTranslations.traslate('sending_response_message')*/'Registrando solicitud ....', style: TextStyle(fontSize: 15.0)),
                )
              ],
            ),
          ),
        );
      }
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
              child: Text('ACEPTAR', style: TextStyle(fontSize: 14.0)),
              onPressed: () => Navigator.pop(_scaffoldKey.currentContext)
            )
          ],
        );
      }
    );
  }
}