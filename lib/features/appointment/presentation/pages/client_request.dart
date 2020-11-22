import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/features/appointment/domain/entities/service.dart';
import 'package:service_now/widgets/rounded_button.dart';

import 'payment_services_page.dart';

class ClientRequest extends StatefulWidget {
  final String notification;

  const ClientRequest({ @required this.notification });

  @override
  _ClientRequestState createState() => _ClientRequestState();
}

class _ClientRequestState extends State<ClientRequest> {
  Map<String, dynamic> message;
  List<Service> services = List();

  @override
  void initState() {
    message = json.decode(widget.notification);
    services = _getServices(message);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitud', style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: BlocProvider(
        create: (_) => sl<AppointmentBloc>(),
        child: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            // ignore: close_sinks
            // final bloc = AppointmentBloc.of(context);

            return Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[100],
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.only(top: 20, bottom: 10, left: 15, right: 15),
                            child: Text('Seleccione los servicios que desee solicitar al negocio:'),
                          ),
                        ),
                        services.length > 0 ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              Service service = services[index];

                              return CheckboxListTile(
                                title: Row(
                                  children: [
                                    Text(service.name + ' - ' + 'S/ ${service.price}', style: TextStyle(fontSize: 13))
                                  ],
                                ),
                                value: service.selected == 1,
                                activeColor: secondaryDarkColor,
                                onChanged: (bool value) {
                                  setState(() {
                                    service.selected = service.selected == 1 ? 0 : 1;
                                  });
                                }
                              );
                            },
                            childCount: services.length
                          )
                        ) : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Container(
                              padding: EdgeInsets.only(top: 150),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.mood_bad, size: 60, color: Colors.black38),
                                    SizedBox(height: 10),
                                    Text('No hay registros para mostrar')
                                  ],
                                )
                              ),
                            ),
                            childCount: 1
                          )
                        )
                      ]
                    )
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: RoundedButton(
                    onPressed: () {
                      double totalPagar = 0.0;
                      services.where((element) => element.selected == 1)
                              .toList()
                              .forEach((service) {
                        totalPagar += double.parse(service.price);
                      });

                      // print('======= $totalPagar =======');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentServicesPage(totalPrice: totalPagar, services: services)));
                    }, 
                    label: allTranslations.traslate('confirm_request_button_text'),
                    backgroundColor: secondaryDarkColor,
                    width: double.infinity
                  )
                )
              ],
            );
          }
        )
      )
    );
  }

  List<Service> _getServices(Map<String, dynamic> json) {
    List<Service> services = List();
    for (var service in json['services']) {
      services.add(
        Service(
          id: service['business_service_id'],
          name: service['name'],
          price: service['price'],
          photos: [],
          selected: 0
        )
      );
    }

    return services;
  }
}