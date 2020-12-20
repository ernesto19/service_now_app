import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/bloc.dart';
import 'package:service_now/features/professional/presentation/pages/professional_service_register_page.dart';
import 'package:service_now/models/professional_business.dart';
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

                return state.status != ProfessionalStatus.readyServices ? SliverList(
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

                      return ProfessionalServiceItem(service: service, business: business);
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
                );
              }
            )
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: secondaryDarkColor,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalServiceRegisterPage(businessId: business.id, professionalService: null)))
      )
    );
  }
}

class ProfessionalServiceItem extends StatelessWidget {
  const ProfessionalServiceItem({
    @required this.service,
    @required this.business
  });

  final ProfessionalService service;
  final ProfessionalBusiness business;

  @override
  Widget build(BuildContext context) {
    List<PopupMenuEntry<String>> menuOptions = List();

    menuOptions.add(
      PopupMenuItem<String>(
        value: '1',
        child: ListTile(
          leading: Icon(Icons.edit), 
          title: InkWell(
            child: Row(
              children: [
                Text('Editar')
              ]
            )
          )
        )
      )
    );

    // menuOptions.add(
    //   PopupMenuItem<String>(
    //     value: '2',
    //     child: ListTile(
    //       leading: Icon(Icons.redeem), 
    //       title: InkWell(
    //         child: Row(
    //           children: [
    //             Text('Promociones'),
    //             SizedBox(width: 20)
    //           ]
    //         )
    //       )
    //     )
    //   )
    // );

    return Column(
      children: [
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Text('Servicio: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                Text(service.name.toUpperCase(), style: TextStyle(fontSize: 14))
                              ]
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Precio: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                Text('S/ ', style: TextStyle(fontSize: 14)),
                                Text(service.price, style: TextStyle(fontSize: 16))
                              ]
                            )
                          )
                        ]
                      )
                    )
                  ),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == '1') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalServiceRegisterPage(businessId: business.id, professionalService: service)));
                      } else if (value == '2') {
                        // this._showConfirmDialog(context);
                      }
                    },
                    itemBuilder: (BuildContext context) => menuOptions
                  )
                ]
              ),
              service.gallery.length > 0 
              ? Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: service.gallery.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 10),
                      height: 150,
                      width: 150,
                      child: FadeInImage(
                        image: NetworkImage(service.gallery[index].url ?? ''),
                        placeholder: AssetImage('assets/images/loader.gif'),
                        fadeInDuration: Duration(milliseconds: 200),
                        fit: BoxFit.cover
                      )
                    );
                  }
                )
              ) 
              : Container(
                height: 150,
                width: 150,
                color: Colors.black12,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Icon(Icons.image, size: 60, color: Colors.black38),
                      ),
                    ),
                    Text('No image'),
                    SizedBox(height: 10)
                  ]
                )
              ),
              SizedBox(height: 10)
            ]
          )
        )
      ]
    );
  }
}