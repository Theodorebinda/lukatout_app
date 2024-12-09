import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lukatout/constant/colors.dart';

class PrimaryButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool activityIsRunning;
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.activityIsRunning,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      from: 10,
      // duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(10),
          color: widget.activityIsRunning ? Colors.grey.shade400 : Colors.brown,
          child: Stack(
            children: [
              MaterialButton(
                onPressed: widget.activityIsRunning ? () {} : widget.onPressed,
                minWidth: 200,
                height: 50,
                child: Text(
                  widget.label,
                  style: const TextStyle(color: Colors.white, fontSize: 19),
                ),
              ),
              if (widget.activityIsRunning)
                const Positioned(
                    top: 0.0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: DigiPublicAColors.blackColor,
                          ),
                        )))
            ],
          ),
        ),
      ),
    );
  }
}
