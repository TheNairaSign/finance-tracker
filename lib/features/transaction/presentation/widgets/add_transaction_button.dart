import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddTransactionButton extends StatelessWidget {
  const AddTransactionButton({super.key, this.color, required this.onPressed, required this.text, required this.asset});
  final Color? color;
  final VoidCallback onPressed;
  final String text;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          // side: BorderSide(color: Colors.grey.withValues(alpha: .3), width: .3),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 25,
            width: 25,
            alignment: Alignment.center,
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: color?.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(asset),
          ),
          SizedBox(width: 10),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
