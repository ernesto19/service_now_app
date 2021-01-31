import 'package:flutter/material.dart';
import 'package:service_now/blocs/professional_bloc.dart';
import 'package:service_now/features/home/presentation/pages/home_page.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/input_text.dart';
import 'package:service_now/widgets/rounded_button.dart';

class PaymentMeansConfigurationPage extends StatefulWidget {
  final ProfessionalBusiness business;

  const PaymentMeansConfigurationPage({ @required this.business });

  @override
  _PaymentMeansConfigurationPageState createState() => _PaymentMeansConfigurationPageState();
}

class _PaymentMeansConfigurationPageState extends State<PaymentMeansConfigurationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _paypalKeyController = TextEditingController();
  final _paypalSecretController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(allTranslations.traslate('configurar_medios_pago'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(children: [
            InputText(
              controller: _paypalKeyController,
              iconPath: 'assets/icons/license.svg',
              placeholder: 'Key paypal',
              obscureText: false
            ),
            SizedBox(height: 10),
            InputText(
              controller: _paypalSecretController,
              iconPath: 'assets/icons/key.svg',
              placeholder: 'Secret paypal',
              obscureText: false
            ),
            SizedBox(height: 30),
            RoundedButton(
              label: allTranslations.traslate('register_button_text'),
              width: 200,
              onPressed: () {
                this._showProgressDialog();
                String key = _paypalKeyController.text;
                String secret = _paypalSecretController.text;
                bloc.registerPaypal(key, secret, widget.business.id);
                bloc.paypalRegistroResponse.listen((response) {
                  if (response.error == 0) {
                    Navigator.pop(_scaffoldKey.currentContext);
                    this._showDialog(allTranslations.traslate('registro_exitoso'), 'Sus datos de pago han sido almacenados correctamente.');
                  } else {
                    Navigator.pop(_scaffoldKey.currentContext);
                    this._showDialog(allTranslations.traslate('registro_fallido'), response.message);
                  }
                });
              }
            )
          ]
        )
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
                  child: Text(allTranslations.traslate('register_message'), style: TextStyle(fontSize: 15.0)),
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
          title: Text(title,
              style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
          content: Text(
            message,
            style: TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(allTranslations.traslate('aceptar'), style: TextStyle(fontSize: 14.0)),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(_scaffoldKey.currentContext, HomePage.routeName, (route) => false)
            )
          ],
        );
      }
    );
  }
}