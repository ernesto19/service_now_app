import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/bloc.dart';
import 'package:service_now/utils/colors.dart';

class ServicePicker extends StatefulWidget {

  const ServicePicker();

  @override
  _ServicePickerState createState() => _ServicePickerState();
}

class _ServicePickerState extends State<ServicePicker> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfessionalBloc, ProfessionalState> (builder: (context, state) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            ProfessionalService service = state.services[index];

            return Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    children: [
                                      Text('Servicio: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                      Text(service.name.toUpperCase(), style: TextStyle(fontSize: 16))
                                    ]
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Precio: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                      Text('S/ ', style: TextStyle(fontSize: 13)),
                                      Text(service.price, style: TextStyle(fontSize: 16))
                                    ]
                                  ),
                                )
                              ]
                            )
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: FloatingActionButton(
                              backgroundColor: secondaryColor,
                              child: Icon(Icons.edit, size: 20),
                              mini: true,
                              onPressed: () => {}
                            ),
                          )
                        ]
                      ),
                      SizedBox(height: 10),
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
                      )
                    ]
                  )
                )
              ]
            );
          },
          childCount: state.services.length
        )
      );
    });
  }
}