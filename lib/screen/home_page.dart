import 'package:flutter/material.dart';
import 'package:menu/models/modelos.dart';
import 'package:menu/service/menu_stream.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MenuStream.obtieneItemsMenu();
    return Scaffold(
      appBar: AppBar(
        title: Text('Platos del Menú'),
        backgroundColor: Color.fromRGBO(73, 144, 171, 1),
      ),
      body: StreamBuilder(
        stream: MenuStream.streamControllerDatos,
        builder: (BuildContext contex, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return Container();

          final List<MenuModelo> lista = snapshot.data;

          return ListView.builder(
              itemCount: lista.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                    onTap: () {
                      final bool update = true;
                      Navigator.pushNamed(context, 'nuevoItem', arguments: {
                        'codigo': lista[index].codigo,
                        'descripcion': lista[index].descripcion,
                        'precio': lista[index].precio,
                        'modificando': update
                      });
                    },
                    child: _Dismissible(lista: lista, index: index));
              });
        },
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
        onPressed: () {
          Navigator.pushNamed(
            context,
            'nuevoItem',
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _Dismissible extends StatelessWidget {
  const _Dismissible({
    Key? key,
    required this.lista,
    required this.index,
  }) : super(key: key);

  final List<MenuModelo> lista;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        padding: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        color: Colors.red,
        child: Icon(Icons.delete_forever),
      ),
      key: UniqueKey(),
      onDismissed: (direction) {
        MenuStream.borrarItemMenuPorId(lista[index].codigo);
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  leading:
                      Icon(Icons.dinner_dining, size: 40, color: Colors.indigo),
                  title: Text(
                    lista[index].descripcion,
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),
                  ),
                  subtitle: Text(lista[index].codigo),
                ),
              ),
              LimitedBox(
                maxWidth: 100,
                child: ListTile(
                  title: Text(
                    lista[index].precio.toString(),
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
