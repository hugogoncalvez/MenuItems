import 'package:flutter/material.dart';
import 'dart:async';

import 'package:menu/data/database.dart';
import 'package:menu/models/modelos.dart';

class MenuStream extends ChangeNotifier {
  //
  static StreamController<List<MenuModelo>> _streamController =
      StreamController.broadcast();
  //
  static close() {
    _streamController.close();
  }

  static Stream get streamControllerDatos => _streamController.stream;

  // Future<MenuModelo> nuevoItem(
  //     String itemMenu, String valor, String codigo) async {
  //   // se crea la instancia del modelo
  //   final nuevoItem =
  //       MenuModelo(descripcion: itemMenu, precio: valor, codigo: codigo);
  //   final id = await DataBase.db.nuevoDato(nuevoItem);
  //   //asignar el ID de la base de datos al modelo
  //   nuevoItem.id = id;

  //   this.listaMenu.add(nuevoItem);
  //   _streamController.add(nuevoItem.toJson());
  //   return nuevoItem;
  // }

  static void obtieneItemsMenu() async {
    final db = new DataBase();
    final lista = await db.getTodosLosDatos();
    _streamController.add(lista);
  }

  static obtieneItemsMenuPorId(String codigo) async {
    final db = new DataBase();
    final lista = await db.getDatosByID(codigo);
    _streamController.add(lista);
  }

  static void borrarTodos() async {
    final db = new DataBase();
    final lista = await db.deleteAll();
    obtieneItemsMenu();
  }

  static void borrarItemMenuPorId(String codigo) async {
    final db = new DataBase();
    await db.deleteByID(codigo);
    obtieneItemsMenu();
  }
}
