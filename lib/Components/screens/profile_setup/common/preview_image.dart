import 'package:flutter/material.dart';
import 'dart:io';

class PreviewImage extends StatelessWidget {
  final File _image;
  PreviewImage(this._image);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      // alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image.file(_image),
    );
  }
}
