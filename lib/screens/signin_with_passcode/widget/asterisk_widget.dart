import 'package:flutter/material.dart';

class AsteriskWidget extends StatelessWidget {
  final int listLength;

  const AsteriskWidget({super.key, required this.listLength});

  @override
  Widget build(BuildContext context) {
    return Text(
      '.' * listLength,
      style: const TextStyle(
          fontSize: 50,height: 1 ,fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}