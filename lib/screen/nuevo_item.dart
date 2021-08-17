import 'package:flutter/material.dart';
import 'package:menu/data/database.dart';
import 'package:menu/models/modelos.dart';
import 'package:menu/service/menu_stream.dart';

class NuevoItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> datos =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String codigo;
    String descripcion = '';
    String precio = '';
    bool modificando = false;

    if (datos['codigo'].length > 0) {
      codigo = datos['codigo'];
      descripcion = datos['descripcion'];
      precio = datos['precio'].toString();
      modificando = datos['modificando'];
    } else {
      codigo = '';
    }

    final db = new DataBase();
    final _codigoController = new TextEditingController(text: codigo);
    final _descripcionController = new TextEditingController(text: descripcion);
    final _precioController = new TextEditingController(text: precio);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(73, 144, 171, 1),
        title: Text('Nuevo Item'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              TextFormField(
                //initialValue: codigoProd,
                controller: _codigoController,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El nombre es obligatorio';
                },
              ),
              TextFormField(
                controller: _descripcionController,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El nombre es obligatorio';
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _precioController,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El nombre es Precio';
                },
              )
            ],
          ),
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
          final nuevoItem = MenuModelo(
              codigo: _codigoController.text,
              descripcion: _descripcionController.text,
              precio: double.parse(_precioController.text));
          if (!modificando) {
            db.nuevoDato(nuevoItem);
            MenuStream.obtieneItemsMenu();
            Navigator.pop(context);
          } else {
            db.update(nuevoItem);
            MenuStream.obtieneItemsMenu();
            Navigator.pop(context);
          }
        },
        child: Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
