import 'package:flutter/material.dart';

class SizedRow extends StatelessWidget {
  final List<Widget> children;
  final double height;
  const SizedRow({
    required this.children,
    required this.height,
    key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: height,
          child: Row(
            children: children,
          ),
        ),
      ),
    );
  }
}