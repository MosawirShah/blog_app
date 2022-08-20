import 'package:flutter/material.dart';
class RoundedButton extends StatelessWidget {
  RoundedButton({required this.title, required this.onPress});
  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        color: Colors.amber[700],
        minWidth: double.infinity,
        height: 50,
        child: Text(title, style: TextStyle(color: Colors.white),),
        onPressed: onPress,
      ),
    );
  }
}
