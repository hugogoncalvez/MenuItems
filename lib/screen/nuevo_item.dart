import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:menu/data/database.dart';
import 'package:menu/models/modelos.dart';
import 'package:menu/service/menu_stream.dart';
import 'package:menu/widget/obtiene_imagen.dart';

class NuevoItemPage extends StatefulWidget {
  @override
  _NuevoItemPageState createState() => _NuevoItemPageState();
}

class _NuevoItemPageState extends State<NuevoItemPage> {
  String imagenPath = '';
  bool modificando = false;
  bool modifImagen = false;
  String tituloAppBar = '';

  final _formKey = GlobalKey<FormState>();
  final db = new DataBase();

  final _codigoController = new TextEditingController();
  final _descripcionController = new TextEditingController();
  final _precioController = new TextEditingController();
  bool sizeFull = false;
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> datos =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (datos.isNotEmpty) {
      _codigoController.text = datos['codigo'];
      _descripcionController.text = datos['descripcion'];
      _precioController.text = datos['precio'].toString();
      if (datos['imagen'].length > 0 && !modifImagen) {
        imagenPath = datos['imagen'];
      }
      modificando = datos['modificando'];
    }

    (modificando)
        ? tituloAppBar = 'Modificando Plato'
        : tituloAppBar = 'Nuevo Plato';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(73, 144, 171, 1),
        title: Text(tituloAppBar, style: TextStyle(fontSize: 17)),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(73, 144, 171, 1),
            ),
            onPressed: (() async {
              (modificando) ? modifImagen = true : modifImagen = false;
              _seleccionarImgen(context);
            }),
            icon: Icon(Icons.camera_alt),
            label: Text(
              'Imagen',
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 600),
                curve: Curves.elasticInOut,
                width: sizeFull ? 380 : 100.0,
                height: sizeFull ? 260 : 100,
                decoration: _buildBoxDecoration(),
                child: Opacity(
                  opacity: 0.8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        sizeFull = !sizeFull;
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: obtieneImagen(imagenPath),
                    ),
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: _TextForms(
                  modificando: modificando,
                  codigoController: _codigoController,
                  descripcionController: _descripcionController,
                  precioController: _precioController),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Color.fromRGBO(73, 144, 171, 1),
        child: Row(
          children: [
            Container(
              height: 50,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(31, 107, 38, 1),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final nuevoItem = MenuModelo(
                  codigo: _codigoController.text,
                  descripcion: _descripcionController.text,
                  precio: double.parse(_precioController.text),
                  imagen: imagenPath);
              if (!modificando) {
                db.nuevoDato(nuevoItem);
                MenuStream.obtieneItemsMenu();
                Navigator.pop(context);
              } else {
                db.update(nuevoItem);
                MenuStream.obtieneItemsMenu();
                Navigator.pop(context);
              }
            }
          },
          child: Icon(Icons.save)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _seleccionarImgen(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Seleccione de donde va a tomar la imagen?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Galería"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Cámara"),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _openGallery(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    this.setState(() {
      imagenPath = image!.path;
    });

    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 60);
    this.setState(() {
      imagenPath = image!.path;
    });

    Navigator.of(context).pop();
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.black,
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
          ]);
}

class _TextForms extends StatelessWidget {
  const _TextForms({
    Key? key,
    required this.modificando,
    required TextEditingController codigoController,
    required TextEditingController descripcionController,
    required TextEditingController precioController,
  })  : _codigoController = codigoController,
        _descripcionController = descripcionController,
        _precioController = precioController,
        super(key: key);

  final bool modificando;
  final TextEditingController _codigoController;
  final TextEditingController _descripcionController;
  final TextEditingController _precioController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              readOnly: modificando,
              controller: _codigoController,
              validator: (value) {
                if (value == null || value.length < 1)
                  return 'El código es obligatorio';
              },
              decoration: _inputDecoration('Código del plato'),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _descripcionController,
              validator: (value) {
                if (value == null || value.length < 1)
                  return 'El nombre es obligatorio';
              },
              decoration: _inputDecoration('Nombre del plato'),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _precioController,
              validator: (value) {
                if (value == null || value.length < 1)
                  return 'El precio es obligatorio';
              },
              decoration: _inputDecoration('Precio del plato'),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    String label = labelText;
    return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.only(left: 20),
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFB35214),
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFB35214),
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFB35214),
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFB35214),
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
    );
  }
}
