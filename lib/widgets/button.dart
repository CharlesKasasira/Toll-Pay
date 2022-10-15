import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double height;
  const CustomElevatedButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.height = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: const Color(0xFF1a1a1a),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Ink(
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a1a),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x801a1a1a),
              offset: Offset(0, 10),
              blurRadius: 20,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontFamily: "NunitoSans",
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
