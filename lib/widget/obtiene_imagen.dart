import 'package:flutter/material.dart';
import 'dart:io';

obtieneImagen(String? imagen) {
  if (imagen == null || imagen.length == 0) {
    return Image(
      fit: BoxFit.cover,
      image: AssetImage('assets/no-image.png'),
    );
  }
  return Image.file(
    File(imagen),
    fit: BoxFit.cover,
  );
}

BoxDecoration buildBoxDecoration() => BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.black,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
        ]);
