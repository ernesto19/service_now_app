import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/bloc.dart';
import 'package:service_now/features/professional/presentation/pages/professional_service_register_page.dart';
import 'package:service_now/features/professional/presentation/widgets/service_picker.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';

class ProfessionalBusinessServicesPage extends StatelessWidget {
  const ProfessionalBusinessServicesPage({ @required this.business });

  final ProfessionalBusiness business;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[100],
        child: CustomScrollView(
          slivers: [
            BlocBuilder<ProfessionalBloc, ProfessionalState>(
              builder: (context, state) {
                // ignore: close_sinks
                final bloc = ProfessionalBloc.of(context);
                bloc.add(GetServicesForProfessional(business.id));

                String text = '';

                if (state.status == ProfessionalStatus.readyServices) {
                  if (state.services.length > 0) {
                    return ServicePicker();
                  } else {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: 50),
                            Icon(Icons.mood_bad, size: 60, color: Colors.black38),
                            SizedBox(height: 10),
                            Text('Aún no tiene servicios registrados'),
                          ],
                        ),
                      ),
                    );
                  }
                } else if (state.status == ProfessionalStatus.error) {
                  text = 'Error';
                } else {
                  text = allTranslations.traslate('loading_message');
                }

                return SliverFillRemaining(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: LinearProgressIndicator(),
                      ),
                      Text(text)
                    ]
                  )
                );
              }
            )
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: secondaryDarkColor,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalServiceRegisterPage(businessId: business.id)))
      )
    );
  }
}