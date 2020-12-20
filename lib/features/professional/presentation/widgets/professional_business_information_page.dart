import 'package:flutter/material.dart';
import 'package:service_now/features/professional/presentation/pages/payment_means_configuration_page.dart';
import 'package:service_now/features/professional/presentation/pages/request_tray_page.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:service_now/blocs/professional_bloc.dart';
import 'package:service_now/features/professional/presentation/pages/professional_business_register_page.dart';
import 'package:service_now/features/professional/presentation/pages/professional_promotions_page.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/input_form_field.dart';

class ProfessionalBusinessInformationPage extends StatefulWidget {
  const ProfessionalBusinessInformationPage({ @required this.business });

  final ProfessionalBusiness business;

  @override
  _ProfessionalBusinessInformationPageState createState() => _ProfessionalBusinessInformationPageState();
}

class _ProfessionalBusinessInformationPageState extends State<ProfessionalBusinessInformationPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _licenseController = TextEditingController();
  final _addressController = TextEditingController();
  final _fanpageController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    _nameController.text        = widget.business.name;
    _descriptionController.text = widget.business.description;
    _licenseController.text     = widget.business.licenseNumber;
    _addressController.text     = widget.business.address;
    _fanpageController.text     = widget.business.fanpage;
    _phoneController.text       = widget.business.phone;

    bloc.fetchProfessionalBusinessGallery(widget.business.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: 'Solicitudes de colaboración',
        currentButton: FloatingActionButton(
          heroTag: "solicitudes",
          backgroundColor: secondaryDarkColor,
          mini: true,
          child: Icon(Icons.work),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RequestTrayPage(business: widget.business)));
          },
        )
      )
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: 'Configurar medios de pago',
        currentButton: FloatingActionButton(
          heroTag: "medios_pago",
          backgroundColor: secondaryDarkColor,
          mini: true,
          child: Icon(Icons.payment),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentMeansConfigurationPage(business: widget.business)));
          },
        )
      )
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: 'Promociones',
        currentButton: FloatingActionButton(
          heroTag: "promocion",
          backgroundColor: secondaryDarkColor,
          mini: true,
          child: Icon(Icons.label),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalPromotionsPage(business: widget.business)));
          },
        )
      )
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: 'Editar',
        currentButton: FloatingActionButton(
          heroTag: "editar",
          backgroundColor: secondaryDarkColor,
          mini: true,
          child: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalBusinessRegisterPage(business: widget.business)));
          }
        )
      )
    );

    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildName(),
                    SizedBox(height: 15),
                    _buildDescription(),
                    SizedBox(height: 15),
                    _buildLicense(),
                    SizedBox(height: 15),
                    _buildAddress(),
                    SizedBox(height: 15),
                    _buildFanpage(),
                    SizedBox(height: 15),
                    _buildPhone(),
                    SizedBox(height: 20)
                  ]
                )
              )
            ),
            SliverToBoxAdapter(
              child: _buildGallery()
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 20)
            )
          ]
        )
      ),
      floatingActionButton: UnicornDialer(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
        parentButtonBackground: secondaryDarkColor,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.menu),
        childButtons: childButtons
      )
      // floatingActionButton: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: List.generate(icons.length, (int index) {
      //     Widget child = Container(
      //       height: 70.0,
      //       width: 56.0,
      //       alignment: FractionalOffset.topCenter,
      //       child: ScaleTransition(
      //         scale: CurvedAnimation(
      //           parent: _controller,
      //           curve: Interval(
      //             0.0,
      //             1.0 - index / icons.length / 2.0,
      //             curve: Curves.easeOut
      //           ),
      //         ),
      //         child: FloatingActionButton(
      //           heroTag: null,
      //           backgroundColor: Colors.white,
      //           mini: true,
      //           child: Icon(icons[index], color: secondaryDarkColor),
      //           onPressed: () {
      //             if (index == 1) {
      //               Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalBusinessRegisterPage(business: widget.business)));
      //             } else {
      //               Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalPromotionsPage(business: widget.business)));
      //             }
      //           },
      //         ),
      //       ),
      //     );
      //     return child;
      //   }).toList()..add(
      //     FloatingActionButton(
      //       heroTag: null,
      //       backgroundColor: secondaryDarkColor,
      //       child: AnimatedBuilder(
      //         animation: _controller,
      //         builder: (BuildContext context, Widget child) {
      //           return Transform(
      //             transform: Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
      //             alignment: FractionalOffset.center,
      //             child: Icon(_controller.isDismissed ? Icons.menu : Icons.close),
      //           );
      //         },
      //       ),
      //       onPressed: () {
      //         if (_controller.isDismissed) {
      //           _controller.forward();
      //         } else {
      //           _controller.reverse();
      //         }
      //       },
      //     ),
      //   ),
      // )
    );
  }

  Widget _buildName() {
    return InputFormField(
      label: allTranslations.traslate('business_name_label'),
      inputType: TextInputType.text,
      controller: _nameController,
      maxLength: 100,
      enabled: false
    );
  }

  Widget _buildDescription() {
    return InputFormField(
      label: allTranslations.traslate('business_description_label'),
      inputType: TextInputType.text,
      controller: _descriptionController,
      maxLength: 100,
      enabled: false
    );
  }

  Widget _buildLicense() {
    return InputFormField(
      label: allTranslations.traslate('business_license_label'),
      inputType: TextInputType.text,
      controller: _licenseController,
      maxLength: 100,
      enabled: false
    );
  }

  Widget _buildAddress() {
    return InputFormField(
      label: allTranslations.traslate('business_address_label'),
      inputType: TextInputType.text,
      controller: _addressController,
      maxLength: 100,
      enabled: false
    );
  }

  Widget _buildFanpage() {
    return InputFormField(
      label: allTranslations.traslate('business_fanpage_label'),
      inputType: TextInputType.text,
      controller: _fanpageController,
      maxLength: 100,
      enabled: false
    );
  }

  Widget _buildPhone() {
    return InputFormField(
      label: allTranslations.traslate('business_phone_label'),
      inputType: TextInputType.number,
      controller: _phoneController,
      maxLength: 11
    );
  }

  Widget _buildGallery() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: widget.business.gallery.length > 0
      ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Galería', style: labelFormStyle),
          StreamBuilder(
            stream: bloc.allProfessionalBusinessGallery,
            builder: (context, AsyncSnapshot<GalleryResponse> snapshot) {
              if (snapshot.hasData) {
                GalleryResponse response = snapshot.data;

                return GridView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      height: 200,
                      width: 200,
                      child: FadeInImage(
                        image: NetworkImage(response.data[index].url ?? ''),
                        placeholder: AssetImage('assets/images/loader.gif'),
                        fadeInDuration: Duration(milliseconds: 200),
                        fit: BoxFit.cover
                      )
                    );
                  },
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10
                  ),
                  itemCount: response.data.length
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              return Center(
                child: CircularProgressIndicator()
              );
            }
          )
        ],
      )
      : Container(
        height: 200,
        width: 200,
        color: Colors.black12,
        margin: EdgeInsets.only(top: 15),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Icon(Icons.image, size: 100, color: Colors.black38),
              ),
            ),
            Text('No image'),
            SizedBox(height: 20)
          ]
        )
      )
    );
  }
}