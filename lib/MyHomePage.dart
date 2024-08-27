import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'LoginPage.dart';
import 'Products.dart'; // Asegúrate de que esta clase esté bien definida e importada

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sprint0'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => LoginPage()), // Elimina const de aquí
                );
              }
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hola Mundo',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.teal,
        spacing: 12,
        spaceBetweenChildren: 12,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.facebook),
            label: 'Facebook',
            backgroundColor: Colors.blue,
            onTap: () => _launchURL('https://www.facebook.com'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.camera_alt),
            label: 'Instagram',
            backgroundColor: Colors.purple,
            onTap: () => _launchURL('https://www.instagram.com'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.email),
            label: 'Email',
            backgroundColor: Colors.red,
            onTap: () => _launchURL('mailto:someone@example.com'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.store),
            label: 'Productos CRUD',
            backgroundColor: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Products()), // Elimina const de aquí
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'No se pudo abrir el enlace $url';
    }
  }
}
