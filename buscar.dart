import 'dart:convert';
import 'package:ag1_equipo_4/detallesLibro.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Buscar extends StatefulWidget {
  final String p;
  const Buscar({super.key, required this.p});

  @override
  State<Buscar> createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  int selec = 0;
  late String IP = widget.p;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _optenerDatos();
  }

  Future _optenerDatos() async {
    var url = "http://${IP}/Libros/verLibros.php";
    var res = await http.get(Uri.parse(url));
    return json.decode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blibioteca'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _optenerDatos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0, // Espaciado horizontal entre celdas
                    mainAxisSpacing: 8.0, // Espaciado vertical entre celdas
                    childAspectRatio: 0.80, // Relación de aspecto de cada celda
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    List list = snapshot.data;
                    return Card(
                      shadowColor: Colors.black,
                      child: ListTile(
                        title: Container(
                          width: 100,
                          height: 350,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                15), // Coincidir con el radio del borde
                            child: Image.network(
                              "http://$IP/Libros/uploads/${list[index]['portada']}",
                              fit: BoxFit
                                  .cover, // Ajustar la imagen al contenedor
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selec = index;
                          });

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) =>
                                      new Detalles(list: list, selec: selec)));
                        },
                        subtitle: Center(
                          child: Text(''),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
