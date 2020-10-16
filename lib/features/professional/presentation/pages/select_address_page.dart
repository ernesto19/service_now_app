import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/features/professional/presentation/bloc/bloc.dart';
import 'package:service_now/features/professional/presentation/widgets/custom_app_bar.dart';
import 'package:service_now/injection_container.dart';

class SelectAdressPage extends StatelessWidget {
  const SelectAdressPage({ @required CameraPosition initialPosition }) : _initialPosition = initialPosition;
  
  final CameraPosition _initialPosition;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfessionalBloc>(),
      child: Scaffold(
        appBar: CustomAppBar(),
        body: cuerpo()
      )
    );
  }

  Widget cuerpo() {
    return BlocProvider(
      create: (_) => sl<ProfessionalBloc>(),
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<ProfessionalBloc, ProfessionalState>(
              builder: (context, state) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: GoogleMap(
                    initialCameraPosition: _initialPosition,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    onTap: (location) {
                      print('$location');
                    },
                  )
                );
              }
            )
          ]
        )
      )
    );
  }
}