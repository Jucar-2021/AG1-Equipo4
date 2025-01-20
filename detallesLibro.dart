import 'package:ag1_equipo_4/pdfLeer.dart';
import 'package:flutter/material.dart';

class Detalles extends StatefulWidget {
  final List list;
  final int selec;
  const Detalles({super.key, required this.list, required this.selec});

  @override
  State<Detalles> createState() => _DetallesState();
}

class _DetallesState extends State<Detalles> {
  late List _listaLocal;
  late int _id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listaLocal = widget.list;

    _id = widget.selec;

    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${_listaLocal[_id]['titulo']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          mayuculas(_listaLocal[_id]['titulo']),
          maxLines: 2,
          style: const TextStyle(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            height: MediaQuery.of(context).size.height / 1.1,
            width: MediaQuery.of(context).size.width - 10,
            left: 10,
            top: MediaQuery.of(context).size.height * 0.004,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 90,
                  ),
                  Text(
                    'Autor(es): ',
                    style: const TextStyle(
                        fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                          child: Text(
                        capitalizeNombres(_listaLocal[_id]['autor']),
                        softWrap: true,
                        style: TextStyle(
                            color: const Color.fromARGB(255, 27, 9, 166),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Descripcion: ',
                    style: const TextStyle(
                        fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Text(
                          capitalize(_listaLocal[_id]['descripcion']),
                          softWrap: true,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 1, 3, 94),
                              fontSize: 20,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black, // fondo
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15), // Espaciado interno
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Bordes redondeados
                          ),
                        ),
                        onPressed: () async {
                          String leerPdf =
                              "http://192.168.0.54/Libros/uploads/${_listaLocal[_id]['libro']}";
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Pdfleer(leerPdf: leerPdf),
                            ),
                          );
                        },
                        child: Text(
                          'LEER',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: '',
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "http://192.168.0.54/Libros/uploads/${_listaLocal[_id]['portada']}"),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String capitalize(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String mayuculas(String? text) {
    if (text == null || text.isEmpty) return '';
    return text.toUpperCase();
  }

  String capitalizeNombres(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ') // Dividir
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' '); // Unir
  }
}
