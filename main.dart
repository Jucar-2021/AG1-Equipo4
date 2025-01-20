import 'dart:convert';
import 'package:ag1_equipo_4/detallesLibro.dart';
import 'package:flutter/material.dart';
import 'agregar.dart';
import 'buscar.dart';
import 'package:http/http.dart' as http;

import 'gestionIP.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selec = 0;
  late IpAsignacion opIp = IpAsignacion();
  late String IP;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _optenerDatos();
  }

  Future _optenerDatos() async {
    try {
      // Obtiene la IP almacenada
      String ip = await opIp.obtenerUltimaIp();
      var url = "http://${ip}/Libros/verLibros.php";
      setState(() {
        IP = ip;
        return;
      });

      print("Conectando a: $url");

      // Realiza la solicitud HTTP
      var res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        // Decodifica y retorna los datos si la conexión es exitosa
        return json.decode(res.body);
      } else {
        // Maneja errores HTTP (por ejemplo, 404 o 500)
        throw Exception('Error en la solicitud: Código ${res.statusCode}');
      }
    } catch (e) {
      // Captura errores como problemas de conexión o IP no válida
      print("Error al conectar: $e");
      setState(() {
        IP = 'Error al conectar con el servidor';
      });
      return []; // Retorna una lista vacía para evitar fallos en el renderizado
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 219, 201, 136),
        title: const Text(
          'AG1. MySQL Equipo 4',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _optenerDatos();
            },
            icon: Icon(Icons.update),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(40),
          children: <Widget>[
            const Text(
              'Menu',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: const Icon(Icons.manage_search),
              title: const Text(
                'Buscar',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                String p = IP;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => new Buscar(p: p),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              dense: false,
              title: const Text(
                'Agregar',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Agregar(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              dense: false,
              title: const Text(
                'Actualizar IP',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IPinput(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _optenerDatos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    List list = snapshot.data;
                    return Card(
                      shadowColor: Colors.black,
                      child: ListTile(
                        title: Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey, width: 3),
                            ),
                          ),
                          width: 100,
                          height: 300,
                          child: Image.network(
                              "http://${IP}/Libros/uploads/${list[index]['portada']}"),
                        ),
                        onTap: () {
                          setState(() {
                            selec = index;
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (contex) =>
                                  new Detalles(list: list, selec: selec),
                            ),
                          );
                        },
                        subtitle: Center(
                          child: Text(
                            mayuculas(list[index]['titulo']),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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

  String mayuculas(String? text) {
    if (text == null || text.isEmpty) return '';
    return text.toUpperCase();
  }
}
