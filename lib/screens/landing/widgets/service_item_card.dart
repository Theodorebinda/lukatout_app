import 'package:digipublic_studiant/constant/colors.dart';
import 'package:digipublic_studiant/models/menu.dart';
import 'package:flutter/material.dart';

class ServiceItemCard extends StatelessWidget {
  // final VoidCallback onPressed;
  final ValueChanged<IAppMenu>? onValueChanged;
  final IAppMenu menuItem;
  final Widget svgWidget;
  const ServiceItemCard({
    super.key,
    required this.onValueChanged,
    required this.menuItem,
    required this.svgWidget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onValueChanged!(menuItem);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.0,
              width: 50.0,
              child: svgWidget,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                menuItem.name,
                style: const TextStyle(
                    color: DigiPublicAColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
