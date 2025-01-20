import 'package:ag1_equipo_4/main.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdfx/pdfx.dart';
import 'db_conneccion.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CargaLibro extends StatefulWidget {
  final String t;
  final String a;
  final String d;

  const CargaLibro({
    super.key,
    required this.t,
    required this.a,
    required this.d,
  });

  @override
  State<CargaLibro> createState() => _CargaLibroState();
}

class _CargaLibroState extends State<CargaLibro> {
  File? _imag;
  File? _pdf;
  final imagPic = ImagePicker();
  final pdfPic = FilePicker;
  String nomPDF = 'Selecciona el libro a cargar';
  BDConnections UPLOAD = BDConnections();

  Future<void> pickPdf() async {
    setState(() {
      _imag = null;
    });
    // Selección del PDF
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Solo permite archivos PDF
    );

    if (result != null && result.files.single.path != null) {
      File pdfFile = File(result.files.single.path!);
      String pdfName = result.files.single.name;

      try {
        // Abrir PDF y procesar la primera página
        final doc = await PdfDocument.openFile(pdfFile.path);
        final opPag = await doc.getPage(1); // Primera página
        final portImage = await opPag.render(
          width: 1800,
          height: 1200,
        );
        await opPag.close();

        if (portImage?.bytes != null) {
          // archivo temporal para la portada
          final tempDir = await getTemporaryDirectory();
          final tempFile = File('${tempDir.path}/portada');
          await tempFile.writeAsBytes(portImage!.bytes);

          setState(() {
            _pdf = pdfFile;
            nomPDF = pdfName;
            _imag = tempFile; // Actualizar la portada como archivo
          });
        } else {
          print("Error al generar la portada del PDF.");
        }
      } catch (e) {
        print("Error al procesar el PDF: $e");
      }
    } else {
      print("No se seleccionó ningún archivo PDF.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carga de libro en PDF'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Hero(
                    tag: 'portada_${_imag?.path ?? "default"}',
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _imag != null
                              ? FileImage(_imag!)
                              : const AssetImage('assets/libr.jpg')
                                  as ImageProvider,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextField(
            controller: TextEditingController(text: nomPDF),
            decoration: InputDecoration(
              hintText: 'Selecciona el libro',
              floatingLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            readOnly: true,
            onTap: pickPdf,
          ),
          ElevatedButton(
            onPressed: () {
              try {
                UPLOAD.cargarLibro(_imag!, widget.t, widget.a, widget.d, _pdf!);
                _mensajeConfir(
                    'Confirmación', 'El libro se cargó exitosamente');
                nomPDF = '';
                setState(() {
                  _imag = null;
                });
              } catch (e) {
                _mensajeError('Carga no exitosa',
                    'El libro no se cargó correctamente. Error: $e');
              }
            },
            child: const Icon(
              Icons.upload,
              color: Colors.blueAccent,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  void _mensajeError(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.error,
            color: Colors.red,
            size: 60,
          ),
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _mensajeConfir(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
