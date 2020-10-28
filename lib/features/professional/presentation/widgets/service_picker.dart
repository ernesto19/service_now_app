import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/bloc.dart';

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
                  padding: EdgeInsets.only(left: 20, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('SERVICIO: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          Text(service.name.toUpperCase(), style: TextStyle(fontSize: 16))
                        ]
                      ),
                      Row(
                        children: [
                          Text('PRECIO: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          Text('S/ ${service.price}', style: TextStyle(fontSize: 16))
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
                              child: Image.network(
                                service.gallery[index].url, 
                                fit: BoxFit.cover
                              )
                            );
                          }
                        )
                      ) 
                      : Container(
                        height: 150,
                        width: 150,
                        color: Colors.black26,
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: Icon(Icons.image, size: 60),
                              ),
                            ),
                            Text('No image')
                          ]
                        )
                      )
                    ]
                  )
                ),
                SizedBox(height: 20),
                Divider(
                  color: Colors.black45,
                  height: 1
                ),
                SizedBox(height: 20)
              ],
            );
          },
          childCount: state.services.length
        ),
      );
    });
  }
}