import 'package:flutter/material.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/presentation/pages/professional_business_register_page.dart';
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

  @override
  void initState() {
    _nameController.text        = widget.business.name;
    _descriptionController.text = widget.business.description;
    _licenseController.text     = widget.business.licenseNumber;
    _addressController.text     = widget.business.address;
    _fanpageController.text     = widget.business.fanpage;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        backgroundColor: secondaryDarkColor,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalBusinessRegisterPage(business: widget.business)))
      )
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

  Widget _buildGallery() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: widget.business.gallery.length > 0
      ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Galería', style: labelFormStyle),
          GridView.builder(
            itemBuilder: (context, index) {
              return Container(
                height: 200,
                width: 200,
                child: FadeInImage(
                  image: NetworkImage(widget.business.gallery[index].url ?? ''),
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
            itemCount: widget.business.gallery.length
          ),
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