import 'package:ag1_equipo_4/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class IpAsignacion {
  static const String _ipKey = '';

  Future<String?> ultimaIp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_ipKey);
    } catch (e) {
      print("Error al obtener la IP: $e");
      return null;
    }
  }

  Future<void> traerIp(String ip) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_ipKey, ip);
    } catch (e) {
      print("Error al guardar la IP: $e");
    }
  }

  Future<String> obtenerUltimaIp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? ip = prefs.getString(_ipKey);

      print("IP recuperada: ${ip ?? "0.0.0.0"}");

      return ip ?? "0.0.0.0";
    } catch (e) {
      print("Error al obtener la IP: $e");
      return "0.0.0.0"; // Devuelve la IP predeterminada en caso de error
    }
  }
}

class IPinput extends StatefulWidget {
  @override
  _IpInputScreenState createState() => _IpInputScreenState();
}

class _IpInputScreenState extends State<IPinput> {
  final IpAsignacion _ipManager = IpAsignacion();
  TextEditingController _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _validarIp();
  }

  Future<void> _validarIp() async {
    String? Ipactual = await _ipManager.ultimaIp();
    if (Ipactual != null) {
      _ipController.text = Ipactual;
    }
  }

  Future<void> _guardarIp() async {
    String ip = _ipController.text;
    await _ipManager.traerIp(ip);

    print('IP guardada: $ip');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración de IP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              controller: _ipController,
              decoration:
                  InputDecoration(labelText: 'Ingrese la IP del servidor'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _guardarIp();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ));
              },
              child: Text('Guardar IP'),
            ),
          ],
        ),
      ),
    );
  }
}
