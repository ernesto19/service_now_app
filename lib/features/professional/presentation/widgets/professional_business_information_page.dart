import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/utils/colors.dart';

class ProfessionalBusinessInformationPage extends StatelessWidget {
  const ProfessionalBusinessInformationPage({ @required this.business });

  final ProfessionalBusiness business;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(business.description),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.web, size: 17, color: secondaryDarkColor),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(business.categoryName, style: TextStyle(fontSize: 13))
                      )
                    ]
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/license.svg',
                        color: secondaryDarkColor,
                        height: 15
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(business.licenseNumber, style: TextStyle(fontSize: 13))
                      )
                    ]
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/address.svg',
                        color: secondaryDarkColor,
                        height: 15
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(business.address, style: TextStyle(fontSize: 13))
                      )
                    ]
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/facebook-icon.svg',
                        color: secondaryDarkColor,
                        height: 15
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(business.fanpage, style: TextStyle(fontSize: 13))
                      )
                    ]
                  )
                ]
              )
            )
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    // margin: EdgeInsets.only(right: 10),
                    height: 200,
                    width: 200,
                    child: Image.network(
                      business.gallery[index].url, 
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
                itemCount: business.gallery.length
              )
            )
          )
        ]
      )
    );
  }
}