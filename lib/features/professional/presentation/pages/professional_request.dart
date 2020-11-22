import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/rounded_button.dart';

class ProfessionalRequest extends StatelessWidget {
  final String notification;

  const ProfessionalRequest({ @required this.notification });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> message = json.decode(notification);

    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitud', style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: BlocProvider(
        create: (_) => sl<ProfessionalBloc>(),
        child: BlocBuilder<ProfessionalBloc, ProfessionalState>(
          builder: (context, state) {
            // ignore: close_sinks
            final bloc = ProfessionalBloc.of(context);
            bloc.add(GetServicesForProfessional(int.parse(message['business_id'].toString())));

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
                            child: Text('Seleccione los servicios que puede brindar en estos momentos'),
                          ),
                        ),
                        state.status != ProfessionalStatus.readyServices ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Container(
                              padding: EdgeInsets.only(top: 200),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            childCount: 1
                          )
                        ) : state.services.length > 0 ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              ProfessionalService service = state.services[index];

                              return CheckboxListTile(
                                title: Text(service.name, style: TextStyle(fontSize: 13)),
                                value: service.selected == 1,
                                activeColor: secondaryDarkColor,
                                onChanged: (bool value) {
                                  bloc.add(OnSelectedServiceEvent(service.id));
                                }
                              );
                            },
                            childCount: state.services.length
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
                      bloc.add(RequestResponseForBusiness(state.services.where((element) => element.selected == 1).toList(), int.parse(message['user_id'].toString()), context));
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
}