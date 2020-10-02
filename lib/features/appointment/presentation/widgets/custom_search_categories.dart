import 'package:flutter/material.dart';

class CustomSearchCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          SizedBox(width: 16),
          CustomCategoryChip(Icons.fastfood, "Takeout"),
          SizedBox(width: 12),
          CustomCategoryChip(Icons.directions_bike, "Delivery"),
          SizedBox(width: 12),
          CustomCategoryChip(Icons.local_gas_station, "Gas"),
          SizedBox(width: 12),
          CustomCategoryChip(Icons.shopping_cart, "Groceries"),
          SizedBox(width: 12),
          CustomCategoryChip(Icons.local_pharmacy, "Pharmacies"),
          SizedBox(width: 12),
        ],
      ),
    );
  }
}

class CustomCategoryChip extends StatelessWidget {
  final IconData iconData;
  final String title;

  CustomCategoryChip(this.iconData, this.title);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Row(
        children: <Widget>[Icon(iconData, size: 16), SizedBox(width: 8), Text(title)],
      ),
      backgroundColor: Colors.grey[50],
    );
  }
}