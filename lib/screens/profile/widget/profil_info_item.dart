import 'package:flutter/material.dart';
import 'package:lukatout/constant/colors.dart';

class ProfilInfoItem extends StatelessWidget {
  final String title;
  final String info;
  final IconData icon;
  const ProfilInfoItem({
    super.key,
    required this.info,
    required this.title,
    this.icon = Icons.person_pin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10.0),
        border: const Border(
          left: BorderSide(
            color: DigiPublicAColors.primaryColor, // Border color
            width: 3.0, // Border width
          ),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(color: DigiPublicAColors.primaryColor),
            ),
            subtitle: Text(
              info,
              style: const TextStyle(color: DigiPublicAColors.greyColor),
            ),
            trailing: Icon(
              icon,
              size: 22.0,
              color: DigiPublicAColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
