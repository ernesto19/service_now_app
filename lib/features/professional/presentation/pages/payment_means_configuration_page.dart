import 'package:flutter/material.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/input_form_field.dart';

class PaymentMeansConfigurationPage extends StatefulWidget {
  final ProfessionalBusiness business;

  const PaymentMeansConfigurationPage({ @required this.business });

  @override
  _PaymentMeansConfigurationPageState createState() => _PaymentMeansConfigurationPageState();
}

class _PaymentMeansConfigurationPageState extends State<PaymentMeansConfigurationPage> {
  bool _isSelectedCredit = false;
  bool _isSelectedTransfer = false;
  final _fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración medios de pago', style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _isSelectedCredit,
                    onChanged: (bool value) {
                      setState(() {
                        _isSelectedCredit = value;
                      });
                    }
                  ),
                  Text('Tarjeta de crédito', style: TextStyle(color: Colors.black))
                ]
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _isSelectedTransfer,
                    onChanged: (bool value) {
                      setState(() {
                        _isSelectedTransfer = value;
                      });
                    }
                  ),
                  Text('Transferencia', style: TextStyle(color: Colors.black))
                ]
              ),
              SizedBox(height: 20),
              _isSelectedCredit ? Container(
                margin: EdgeInsets.only(bottom: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 10, top: 15, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text('TARJETA DE CRÉDITO', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                            )
                          ]
                        ),
                        SizedBox(height: 20),
                        InputFormField(
                          hint: 'NOMBRES APELLIDOS',
                          label: 'Nombre completo',
                          inputType: TextInputType.text,
                          controller: _fullNameController,
                          maxLength: 100
                        ),
                        SizedBox(height: 20),
                        InputFormField(
                          hint: '00/00',
                          label: 'Fecha de vencimiento',
                          inputType: TextInputType.text,
                          controller: _fullNameController,
                          maxLength: 100
                        ),
                        SizedBox(height: 20),
                        InputFormField(
                          hint: '123',
                          label: 'CVV',
                          inputType: TextInputType.text,
                          controller: _fullNameController,
                          maxLength: 100
                        ),
                        SizedBox(height: 10)
                      ]
                    )
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: Offset(2, 2)
                    )
                  ]
                )
              ) : Container(),
              SizedBox(height: 10),
              _isSelectedTransfer ? Container(
                margin: EdgeInsets.only(bottom: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 10, top: 15, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text('TRANSFERENCIA', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                            )
                          ]
                        ),
                        SizedBox(height: 20),
                        InputFormField(
                          hint: 'NOMBRE BANCO',
                          label: 'Banco',
                          inputType: TextInputType.text,
                          controller: _fullNameController,
                          maxLength: 100
                        ),
                        SizedBox(height: 20),
                        InputFormField(
                          hint: '198-93254158',
                          label: 'Número de cuenta',
                          inputType: TextInputType.text,
                          controller: _fullNameController,
                          maxLength: 100
                        ),
                        SizedBox(height: 20),
                        InputFormField(
                          hint: '0918756933214',
                          label: 'CCI',
                          inputType: TextInputType.text,
                          controller: _fullNameController,
                          maxLength: 100
                        ),
                        SizedBox(height: 10)
                      ]
                    )
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: Offset(2, 2)
                    )
                  ]
                )
              ) : Container()
            ]
          )
        ),
      )
    );
  }
}