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

            return GestureDetector(
              child: Container(
                margin: EdgeInsets.only(bottom: 10, right: 15, left: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.web, size: 20),
                            SizedBox(width: 5),
                            Text('Precio:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            SizedBox(width: 10),
                            Text('S/ ', style: TextStyle(fontSize: 13)),
                            Text(service.price, style: TextStyle(fontSize: 15, fontFamily: 'sans'))
                          ]
                        )
                      ]
                    )
                  )
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
              ),
              onTap: () {}
            );
          },
          childCount: state.services.length
        ),
      );
    });
  }
}