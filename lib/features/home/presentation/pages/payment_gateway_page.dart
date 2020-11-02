import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/home/presentation/bloc/membership/bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_now/utils/text_styles.dart';

class PaymentGatewayPage extends StatefulWidget {
  static final routeName = 'payment_gateway_page';

  @override
  _PaymentGatewayPageState createState() => _PaymentGatewayPageState();
}

class _PaymentGatewayPageState extends State<PaymentGatewayPage> {
  final _creditCardNumberController = TextEditingController();
  final _fechaVencimientoController = TextEditingController();
  final _cvvController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  String creditNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.traslate('acquire_membership'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: buildBody(context)
    );
  }

  BlocProvider<MembershipBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MembershipBloc>(),
      child: BlocBuilder<MembershipBloc, MembershipState>(
        builder: (context, state) {
          // ignore: close_sinks
          final bloc = MembershipBloc.of(context);

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
                                          hintText: 'Ernesto'
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
                                      hintText: 'Chira'
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
                                hintText: 'ernesto.chira@mail.com'
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
                          Text('Solicitar', style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'raleway')),
                          // Text('Pagar', style: TextStyle(color: Colors.white, fontSize: 19, fontFamily: 'raleway')),
                          // SizedBox(width: 10),
                          // Text('S/ 100.00', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold, fontFamily: 'raleway'))
                        ],
                      )
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    onPressed: () => bloc.add(AcquireMembershipForUser(context))
                  ),
                )
              ]
            )
          );
        }
      )
    );
  }
}