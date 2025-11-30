import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class GifPasteExcel extends StatefulWidget {
  const GifPasteExcel({Key? key}) : super(key: key);

  @override
  State<GifPasteExcel> createState() => _GifPasteExcelState();
}

class _GifPasteExcelState extends State<GifPasteExcel>
    with TickerProviderStateMixin {
  late GifController controller;
  @override
  void initState() {
    controller = GifController();
    super.initState();
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 500,
        child: GifView(
          image: AssetImage('images/example.gif'),
          controller: controller,
        ),
      ),
    );
  }
}
