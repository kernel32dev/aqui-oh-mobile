import 'dart:convert';

import 'package:aqui_oh_mobile/repos/reclamacao.dart';
import 'package:aqui_oh_mobile/views/nova_reclamacao.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class NovaReclamacaoDialogState extends State<NovaReclamacaoDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  Future<void>? imageFuture;
  Future<void>? locationFuture;
  String? image;
  Position? location;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    List<int> bytes = await pickedFile.readAsBytes();
    String base64String = base64Encode(bytes);
    String mimeType =
        MimeTypeResolver().lookup(pickedFile.path, headerBytes: bytes)!;
    setState(() {
      image = 'data:$mimeType;base64,$base64String';
    });
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    final location = await Geolocator.getCurrentPosition();
    setState(() {
      this.location = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nova Reclamação'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Título'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Descrição'),
          ),
          SizedBox(height: 10),
          FutureBuilder(
              future: imageFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () => setState(() {
                    imageFuture = pickImage();
                  }),
                  child: Text(image == null
                      ? 'Adicionar uma imagem'
                      : 'Mudar a imagem'),
                );
              }),
          SizedBox(height: 10),
          FutureBuilder(
              future: locationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (location == null) {
                  return ElevatedButton(
                    onPressed: () => setState(() {
                      locationFuture = getCurrentLocation();
                    }),
                    child: Text('Capturar Localização'),
                  );
                }
                return Center(child: Text('Localização capturada'));
              }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            ReclamacaoRepo.createReclamacao(
                    title: titleController.text,
                    text: descriptionController.text,
                    image: image!,
                    lat: location!.latitude,
                    lng: location!.longitude)
                .then((row) {
              widget.onCreate(row);
            }).catchError((e) {
              print(e);
            });
            // Adicionar lógica para salvar a reclamação com imagem e localização
            Navigator.of(context).pop();
          },
          child: Text('Salvar'),
        ),
      ],
    );
  }
}
