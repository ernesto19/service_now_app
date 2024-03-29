import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/domain/entities/industry.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/bloc.dart';
import 'package:service_now/features/professional/presentation/pages/address_page.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/models/place.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/input_form_field.dart';
import 'package:service_now/widgets/rounded_button.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'professional_business_gallery_page.dart';

class ProfessionalBusinessRegisterPage extends StatefulWidget {
  static final routeName = 'professional_business_register_page';
  final ProfessionalBusiness business;

  const ProfessionalBusinessRegisterPage({ @required this.business });

  @override
  _ProfessionalBusinessRegisterPageState createState() => _ProfessionalBusinessRegisterPageState();
}

class _ProfessionalBusinessRegisterPageState extends State<ProfessionalBusinessRegisterPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _fanpageController = TextEditingController();
  final _phoneController = TextEditingController();
  String _industrySelected;
  String _categorySelected;
  Place _place;
  String _addressController = allTranslations.traslate('business_address_placeholder');
  var _addressColor = Colors.black38;
  List<Asset> images = List<Asset>();

  @override
  void initState() {
    if (widget.business != null) {
      _industrySelected             = widget.business.industryId.toString();
      _categorySelected             = widget.business.categoryId.toString();
      _nameController.text          = widget.business.name;
      _descriptionController.text   = widget.business.description;
      _licenseNumberController.text = widget.business.licenseNumber;
      _addressController            = widget.business.address;
      _fanpageController.text       = widget.business.fanpage;
      _phoneController.text         = widget.business.phone;
      _place                        = Place(id: '1', title: 'title', position: LatLng(double.parse(widget.business.latitude), double.parse(widget.business.longitude)), vicinity: '');
      _addressColor                 = Colors.black;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.business == null ? allTranslations.traslate('register_business_title') : allTranslations.traslate('update_business_title'), style: labelTitleForm),
        backgroundColor: primaryColor,
        actions: [
          widget.business == null 
          ? Container()
          : IconButton(
            icon: Icon(Icons.add_photo_alternate), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalBusinessGalleryPage(businessId: widget.business.id)))
          )
        ]
      ),
      body: SafeArea(
        child: _buildBody(context)
      ),
    );
  }

  BlocProvider<ProfessionalBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfessionalBloc>(),
      child: BlocBuilder<ProfessionalBloc, ProfessionalState>(
        builder: (context, state) {
          // ignore: close_sinks
          final bloc = ProfessionalBloc.of(context);
          bloc.add(GetIndustriesForProfessional());
          String text = allTranslations.traslate('loading_message');

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      widget.business == null
                      ? state.formStatus == RegisterBusinessFormDataStatus.ready 
                        ? Column(
                          children: [
                            _buildIndustiesSelect(state.formData.industries),
                            SizedBox(height: 12),
                            _buildCategoriesSelect(state.formData.categories),
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
                        )
                      : Container(),
                      SizedBox(height: 10),
                      _buildName(),
                      SizedBox(height: 20),
                      _buildDescription(),
                      SizedBox(height: 20),
                      _buildLicenseNumber(),
                      SizedBox(height: 20),
                      _buildAddress(),
                      SizedBox(height: 20),
                      _buildFanpage(),
                      SizedBox(height: 20),
                      _buildPhone(),
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
                  : widget.business == null ? Container(
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
                  ),
                ) : Container()
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 10),
                  child: _buildSaveButton(bloc)
                )
              )
            ]
          );
        }
      )
    );
  }

  void goToAddressScreen() async {
    await Navigator.push(context, 
      MaterialPageRoute(
        builder: (BuildContext context) => AddressPage()
      )
    ).then((value) {
      setState(() {
        _place = value;
        if (_place != null) {
          _addressController = _place.title + ' - ' + _place.vicinity.replaceAll('<br/>', ' - ');
          _addressColor = Colors.black;
        }
      });
    });
  }

  Widget _buildName() {
    return InputFormField(
      hint: allTranslations.traslate('business_name_placeholder'),
      label: allTranslations.traslate('business_name_label'),
      inputType: TextInputType.text,
      controller: _nameController,
      maxLength: 100
    );
  }

  Widget _buildDescription() {
    return InputFormField(
      hint: allTranslations.traslate('business_description_placeholder'),
      label: allTranslations.traslate('business_description_label'),
      inputType: TextInputType.text,
      controller: _descriptionController,
      maxLength: 100
    );
  }

  Widget _buildLicenseNumber() {
    return InputFormField(
      hint: allTranslations.traslate('business_license_placeholder'),
      label: allTranslations.traslate('business_license_label'),
      inputType: TextInputType.text,
      controller: _licenseNumberController,
      maxLength: 100
    );
  }

  Widget _buildFanpage() {
    return InputFormField(
      hint: allTranslations.traslate('business_fanpage_placeholder'),
      label: allTranslations.traslate('business_fanpage_label'),
      inputType: TextInputType.text,
      controller: _fanpageController,
      maxLength: 100
    );
  }

  Widget _buildPhone() {
    return InputFormField(
      hint: allTranslations.traslate('business_phone_placeholder'),
      label: allTranslations.traslate('business_phone_label'),
      inputType: TextInputType.number,
      controller: _phoneController,
      maxLength: 11
    );
  }

  Widget _buildAddress() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomLeft, 
            child: Text(
              allTranslations.traslate('business_address_label'), 
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black, 
                fontWeight: 
                FontWeight.bold
              )
            )
          ),
          SizedBox(height: 15.0),
          Container(
            alignment: Alignment.bottomLeft,
            child: InkWell(
              child: Text(
                _addressController, 
                style: TextStyle(fontSize: 15.0, color: _addressColor)
              ),
              onTap: goToAddressScreen
            )
          ),
          SizedBox(height: 9.0),
          Container(
            child: Divider(
              height: 1,
              color: Colors.black
            )
          )
        ]
      )
    );
  }

  Widget _buildSaveButton(ProfessionalBloc bloc) {
    return RoundedButton(
      label: widget.business == null ? allTranslations.traslate('register_button_text') : allTranslations.traslate('update_button_text'),
      backgroundColor: secondaryDarkColor,
      width: double.infinity,
      onPressed: widget.business == null 
        ? () => bloc.add(RegisterBusinessForProfessional(_nameController.text, _descriptionController.text, int.parse(_industrySelected), int.parse(_categorySelected), _licenseNumberController.text, '1', '${_place.position.latitude}', '${_place.position.longitude}', _addressController, _fanpageController.text, _phoneController.text ?? '', images, context)) 
        : () => bloc.add(UpdateBusinessForProfessional(widget.business.id, _nameController.text, _descriptionController.text, int.parse(_industrySelected), int.parse(_categorySelected), _licenseNumberController.text, '1', '${_place.position.latitude}', '${_place.position.longitude}', _addressController, _fanpageController.text, _phoneController.text ?? '', context))
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
        maxImages: 5,
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