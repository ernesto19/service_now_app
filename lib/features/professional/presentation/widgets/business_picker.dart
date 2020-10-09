import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/presentation/bloc/bloc.dart';

class BusinessPicker extends StatefulWidget {

  const BusinessPicker();

  @override
  _BusinessPickerState createState() => _BusinessPickerState();
}

class _BusinessPickerState extends State<BusinessPicker> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfessionalBloc, ProfessionalState> (builder: (_, state) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return GestureDetector(
              child: Container(
                margin: EdgeInsets.only(bottom: 10, right: 15, left: 15),
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 100,
                    color: Colors.redAccent,
                  ),
                  // child: Stack(
                  //   fit: StackFit.expand,
                  //   children: <Widget>[
                  //     Image.network(
                  //       lista[index].logo,
                  //       fit: BoxFit.fill
                  //     ),
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         gradient: LinearGradient(
                  //           colors: [ Colors.white12, Colors.black87 ],
                  //           begin: Alignment.topCenter,
                  //           end: Alignment.bottomCenter
                  //         )
                  //       )
                  //     ),
                  //     Positioned(
                  //       bottom: 0,
                  //       right: 0,
                  //       child: Container(
                  //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  //         child: Text(
                  //           lista[index].name,
                  //           style: TextStyle(
                  //             inherit: true,
                  //             fontSize: 25,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.white,
                  //             fontFamily: 'raleway',
                  //             shadows: [
                  //               Shadow(
                  //                 offset: Offset(-1.5, -1.5),
                  //                 color: Colors.black
                  //               ),
                  //               Shadow(
                  //                 offset: Offset(1.5, -1.5),
                  //                 color: Colors.black
                  //               ),
                  //               Shadow(
                  //                 offset: Offset(1.5, 1.5),
                  //                 color: Colors.black
                  //               ),
                  //               Shadow(
                  //                 offset: Offset(-1.5, 1.5),
                  //                 color: Colors.black
                  //               )
                  //             ]
                  //           )
                  //         ),
                  //       ),
                  //     )
                  //   ]
                  // )
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
              onTap: () {
                // _category = lista[index];
                // print(lista[index].id);
              }
            );
          },
          childCount: state.business.length
        ),
      );
    });
  }
}