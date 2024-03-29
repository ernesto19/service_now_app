import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:service_now/features/professional/domain/entities/industry.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/input_form_field.dart';
import 'package:service_now/widgets/rounded_button.dart';
import 'package:http/http.dart' as http;
import 'professional_service_gallery_page.dart';
import 'package:service_now/models/professional_business.dart';

class ProfessionalServiceRegisterPage extends StatefulWidget {
  static final routeName = 'professional_service_register_page';

  final ProfessionalBusiness business;
  final ProfessionalService professionalService;

  const ProfessionalServiceRegisterPage({ @required this.business, @required this.professionalService });

  @override
  _ProfessionalServiceRegisterPageState createState() => _ProfessionalServiceRegisterPageState();
}

class _ProfessionalServiceRegisterPageState extends State<ProfessionalServiceRegisterPage> {
  final _priceController = TextEditingController();
  String _industrySelected;
  String _categorySelected;
  String _serviceSelected;
  List<Asset> images = List<Asset>();
  final http.Client client = http.Client();
  String minPrice = '';
  String maxPrice = '';

  @override
  void initState() {
    if (widget.professionalService != null) {
      _priceController.text = widget.professionalService.price;
      _serviceSelected = widget.professionalService.serviceId.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.traslate('register_service_title'), style: labelTitleForm),
        backgroundColor: primaryColor,
        actions: [
          widget.professionalService == null 
          ? Container()
          : IconButton(
            icon: Icon(Icons.add_photo_alternate), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalServiceGalleryPage(serviceId: widget.professionalService.id)))
          )
        ]
      ),
      body: SafeArea(
        child: _buildBody(context)
      )
    );
  }

  BlocProvider<ProfessionalBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfessionalBloc>(),
      child: BlocBuilder<ProfessionalBloc, ProfessionalState>(
        builder: (context, state) {
          // ignore: close_sinks
          final bloc = ProfessionalBloc.of(context);
          bloc.add(GetCreateServiceFormForProfessional());
          String text = allTranslations.traslate('loading_message');

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                    state.serviceFormStatus == RegisterServiceFormDataStatus.ready 
                      ? Column(
                        children: [
                          widget.professionalService == null ? Column(
                            children: [
                              _buildIndustiesSelect(state.serviceFormData.industries),
                              SizedBox(height: 12),
                              _buildCategoriesSelect(state.serviceFormData.categories),
                              SizedBox(height: 12),
                            ],
                          ) : Container(),
                          _buildServicesSelect(state.serviceFormData.services)
                        ],
                      ) 
                      : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: LinearProgressIndicator(),
                          ),
                          Text(text)
                        ]
                      ),
                      SizedBox(height: 10),
                      _buildPrice(),
                      SizedBox(height: 10)
                    ]
                  )
                )
              ),
              SliverToBoxAdapter(
                child: images != null && images.length > 0 
                ? Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20), 
                  child: buildGridView()
                ) 
                : widget.professionalService == null ? Container(
                    padding: EdgeInsets.only(left: 20, bottom: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        child: Container(
                          height: 120,
                          width: 120,
                          color: Colors.black12,
                          child: Column(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Icon(Icons.add_a_photo, size: 60, color: Colors.black38),
                                ),
                              ),
                              SizedBox(height: 5)
                            ]
                          )
                        ),
                        onTap: loadAssets
                      ),
                  )
                ) : Container()
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 10),
                  child: _buildSaveButton(bloc)
                ),
              )
            ]
          );
        }
      )
    );
  }

  Widget _buildPrice() {
    return InputFormField(
      hint: allTranslations.traslate('business_price_placeholder'),
      label: allTranslations.traslate('business_price_label'),
      inputType: TextInputType.number,
      controller: _priceController,
      maxLength: 100
    );
  }

  Widget _buildIndustiesSelect(List<Industry> industries) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(alignment: Alignment.bottomLeft, child: Text(allTranslations.traslate('business_industry_label'), style: labelFormStyle)),
          DropdownButton<String>(
            hint: Text(allTranslations.traslate('business_industry_placeholder'), style: TextStyle(fontSize: 15.0)),
            isExpanded: true,
            style: TextStyle(fontFamily: 'sans', color: Colors.black87, fontSize: 15.0),
            underline: Divider(
              height: 0.0,
              color: Colors.black87
            ),
            items: industries.map((Industry item) {
              return DropdownMenuItem<String>(
                value: '${item.id}',
                child: Text(item.name),
              );
            }).toList(),
            value: _industrySelected,
            onChanged: (value) {
              setState(() {
                _industrySelected = value;
              });
            }
          )
        ]
      )
    );
  }

  Widget _buildCategoriesSelect(List<Category> categories) {
    List<Category> categoriesList = List();

    if (_industrySelected != null) {
      categoriesList = categories.where((element) => element.industryId == int.parse(_industrySelected)).toList();
    }

    return Container(
      child: Column(
        children: <Widget>[
          Container(alignment: Alignment.bottomLeft, child: Text(allTranslations.traslate('business_category_label'), style: labelFormStyle)),
          DropdownButton<String>(
            hint: Text(allTranslations.traslate('business_category_placeholder'), style: TextStyle(fontSize: 15.0)),
            isExpanded: true,
            style: TextStyle(fontFamily: 'sans', color: Colors.black87, fontSize: 15.0),
            underline: Divider(
              height: 0.0,
              color: Colors.black87
            ),
            items: categoriesList.map((Category item) {
              return DropdownMenuItem<String>(
                value: '${item.id}',
                child: Text(item.name),
              );
            }).toList(),
            value: _categorySelected,
            onChanged: (value) {
              setState(() {
                _categorySelected = value;
              });
            }
          )
        ]
      )
    );
  }

  Widget _buildServicesSelect(List<Service> services) {
    List<Service> servicesList = List();

    if (widget.professionalService != null) {
      servicesList.add(Service(id: widget.professionalService.serviceId, name: widget.professionalService.name, categoryId: 0));
    } else if (_categorySelected != null) {
      servicesList = services.where((element) => element.categoryId == int.parse(_categorySelected)).toList();
    }

    return Container(
      child: Column(
        children: <Widget>[
          Container(alignment: Alignment.bottomLeft, child: Text(allTranslations.traslate('business_service_label'), style: labelFormStyle)),
          DropdownButton<String>(
            hint: Text(allTranslations.traslate('business_service_placeholder'), style: TextStyle(fontSize: 15.0)),
            isExpanded: true,
            style: TextStyle(fontFamily: 'sans', color: Colors.black87, fontSize: 15.0),
            underline: Divider(
              height: 0.0,
              color: Colors.black87
            ),
            items: servicesList.map((Service item) {
              return DropdownMenuItem<String>(
                value: '${item.id}',
                child: Text(item.name),
              );
            }).toList(),
            value: _serviceSelected,
            onChanged: (value) {
              getJusticePrice(value);

              setState(() {
                _serviceSelected = value;
              });
            }
          )
        ]
      )
    );
  }

  Future getJusticePrice(String serviceId) async {
    final response = await client.post(
      'https://servicenow.konxulto.com/service_now/public/api/business/social_justice_price',
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(
        {
          'service_id': serviceId,
          'zip_code': widget.business.zipCode
        }
      )
    );

    if (response.statusCode == 200) {
      final body = ResponsePrecioJusto.fromJson(json.decode(response.body));

      if (body.error == 0 && body.data != null) {
        setState(() {
          minPrice = body.data.min;
          maxPrice = body.data.max;
        });
      }
    } else {
      print('error');
    }
  }

  Widget _buildSaveButton(ProfessionalBloc bloc) {
    return RoundedButton(
      label: widget.professionalService == null ? allTranslations.traslate('register_button_text') : allTranslations.traslate('update_button_text'),
      backgroundColor: secondaryDarkColor,
      width: double.infinity,
      onPressed: widget.professionalService == null
        ? () => bloc.add(RegisterServiceForProfessional(widget.business.id, int.parse(_serviceSelected), double.parse(_priceController.text), images, context))
        : () => bloc.add(UpdateServiceForProfessional(widget.professionalService.id, double.parse(_priceController.text), context))
    );
  }

  Widget buildGridView() {
    if (images != null) {
      return GridView.count(
        primary: false,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    } else {
      return Container(color: Colors.white);
    }
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        materialOptions: MaterialOptions(
          actionBarTitle: allTranslations.traslate('seleccionadas'),
          allViewTitle: allTranslations.traslate('seleccionadas'),
          actionBarColor: "#E2C662",
          actionBarTitleColor: "#FFFFFF",
          lightStatusBar: false,
          statusBarColor: '#B3993B',
          startInAllView: true,
          selectCircleStrokeColor: "#000000",
          selectionLimitReachedText: allTranslations.traslate('no_puede_seleccionar')
        )
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }
}

class PrecioJusto {
  String min;
  String max;

  PrecioJusto.fromJson(dynamic json) {
    min = json['min'];
    max = json['max'];
  }
}

class ResponsePrecioJusto {
  int error;
  String message;
  PrecioJusto data;

  ResponsePrecioJusto.fromJson(dynamic json) {
    error   = json['error'];
    message = json['message'];

    if (error == 0)
      data = PrecioJusto.fromJson(json['data']);
  }
}