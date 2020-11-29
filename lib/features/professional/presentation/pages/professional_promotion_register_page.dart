import 'package:flutter/material.dart';
import 'package:service_now/blocs/professional_bloc.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';
import 'package:service_now/widgets/input_form_field.dart';
import 'package:service_now/widgets/rounded_button.dart';

class ProfessionalPromotionRegisterPage extends StatefulWidget {
  static final routeName = 'professional_promotion_register_page';

  final int businessId;

  const ProfessionalPromotionRegisterPage({ @required this.businessId });

  @override
  _ProfessionalPromotionRegisterPageState createState() => _ProfessionalPromotionRegisterPageState();
}

class _ProfessionalPromotionRegisterPageState extends State<ProfessionalPromotionRegisterPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  String _discountTypeSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.traslate('register_promotion_title'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: SafeArea(
        child: _buildBody(context)
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                _buildName(),
                SizedBox(height: 20),
                _buildDescription(),
                SizedBox(height: 20),
                _buildDiscountTypeSelect(),
                SizedBox(height: 15),
                _buildPrice(),
                SizedBox(height: 30),
                _buildSaveButton()
              ]
            )
          )
        )
      ]
    );
  }

  Widget _buildName() {
    return InputFormField(
      hint: allTranslations.traslate('promotion_name_placeholder'),
      label: allTranslations.traslate('promotion_name_label'),
      inputType: TextInputType.text,
      controller: _nameController,
      maxLength: 200
    );
  }

  Widget _buildDescription() {
    return InputFormField(
      hint: allTranslations.traslate('promotion_description_placeholder'),
      label: allTranslations.traslate('promotion_description_label'),
      inputType: TextInputType.text,
      controller: _descriptionController,
      maxLength: 500
    );
  }

  Widget _buildPrice() {
    return InputFormField(
      hint: allTranslations.traslate('promotion_quantity_placeholder'),
      label: allTranslations.traslate('promotion_quantity_label'),
      inputType: TextInputType.number,
      controller: _quantityController,
      maxLength: 100
    );
  }

  Widget _buildDiscountTypeSelect() {
    List<DiscountType> list = List();

    list.add(DiscountType(id: 1, description: 'Porcentaje'));
    list.add(DiscountType(id: 2, description: 'Monto'));

    return Container(
      child: Column(
        children: <Widget>[
          Container(alignment: Alignment.bottomLeft, child: Text(allTranslations.traslate('discount_type_label'), style: labelFormStyle)),
          DropdownButton<String>(
            hint: Text(allTranslations.traslate('discount_type_placeholder'), style: TextStyle(fontSize: 15.0)),
            isExpanded: true,
            style: TextStyle(fontFamily: 'sans', color: Colors.black87, fontSize: 15.0),
            underline: Divider(
              height: 0.0,
              color: Colors.black87
            ),
            items: list.map((DiscountType item) {
              return DropdownMenuItem<String>(
                value: '${item.id}',
                child: Text(item.description),
              );
            }).toList(),
            value: _discountTypeSelected,
            onChanged: (value) {
              setState(() {
                _discountTypeSelected = value;
              });
            }
          )
        ]
      )
    );
  }

  Widget _buildSaveButton() {
    return RoundedButton(
      label: allTranslations.traslate('register_button_text'),
      backgroundColor: secondaryDarkColor,
      width: double.infinity,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Container(
              child: AlertDialog(
                content: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Container(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(allTranslations.traslate('register_message'), style: TextStyle(fontSize: 15.0)),
                    )
                  ],
                ),
              ),
            );
          }
        );

        bloc.registerPromotion(_nameController.text, _descriptionController.text, _quantityController.text, _discountTypeSelected, widget.businessId);
        bloc.promotionRegisterResponse.listen((response) {
          if (response.error == 0) {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Registro exitoso', style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
                  content: Text('La promoción ha sido registrada exitosamente', style: TextStyle(fontSize: 16.0),),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('ACEPTAR', style: TextStyle(fontSize: 14.0)),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, true);
                      }
                    )
                  ],
                );
              }
            );
          }
        });
      }
    );
  }
}

class DiscountType {
  int id;
  String description;

  DiscountType({
    this.id,
    this.description
  });
}