import 'package:ag1_equipo_4/cargaLibro.dart';
import 'package:flutter/material.dart';

class Agregar extends StatefulWidget {
  const Agregar({super.key});

  @override
  State<Agregar> createState() => _AgregarState();
}

class _AgregarState extends State<Agregar> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  TextEditingController _autorController = TextEditingController();
  late String t;
  late String a;
  late String d;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos del libro a cargar'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: _tituloController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: "Titulo",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: _autorController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: "Autor(s)",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: _descripcionController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: "Descipcion",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            t = _tituloController.text;
            a = _autorController.text;
            d = _descripcionController.text;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new CargaLibro(
                t: t,
                a: a,
                d: d,
              ),
            ),
          );
          _autorController.clear();
          _descripcionController.clear();
          _tituloController.clear();
        },
        child: Icon(Icons.file_upload),
        tooltip: 'Selecionar libro',
      ),
    );
  }
}
