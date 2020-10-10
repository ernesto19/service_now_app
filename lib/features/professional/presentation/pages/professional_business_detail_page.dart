import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/presentation/bloc/bloc.dart';
import 'package:service_now/features/professional/presentation/widgets/business_detail_bottom_bar.dart';
import 'package:service_now/features/professional/presentation/widgets/header.dart';
import 'package:service_now/features/professional/presentation/widgets/service_picker.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/all_translations.dart';

class ProfessionalBusinessDetailPage extends StatefulWidget {
  static final routeName = 'professional_services_page';
  final ProfessionalBusiness business;

  const ProfessionalBusinessDetailPage({ @required this.business });

  @override
  _ProfessionalBusinessDetailPageState createState() => _ProfessionalBusinessDetailPageState();
}

class _ProfessionalBusinessDetailPageState extends State<ProfessionalBusinessDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
      bottomNavigationBar: BusinessDetailBottomBar()
    );
  }

  BlocProvider<ProfessionalBloc>  buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfessionalBloc>(),
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              child: CustomScrollView(
                slivers: [
                  Header(
                    title: widget.business.name,
                    titleSize: 22,
                    onTap: () => Navigator.pop(context)
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
                      child: Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.')
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      child: Text(
                        allTranslations.traslate('my_services_title'),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'raleway',
                          height: 1
                        )
                      )
                    ),
                  ),
                  BlocBuilder<ProfessionalBloc, ProfessionalState>(
                    builder: (context, state) {
                      // ignore: close_sinks
                      final bloc = ProfessionalBloc.of(context);
                      bloc.add(GetServicesForProfessional(1));

                      String text = '';

                      if (state.status == ProfessionalStatus.readyServices) {
                        return ServicePicker();
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
            )
          ]
        )
      )
    );
  }
}