import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../Config/theme/theme.dart';

// ignore: must_be_immutable
class AddAudio extends StatelessWidget {
  AddAudio({super.key});

  final _formKey = GlobalKey<FormState>();
  File? selectedImage;
  File? selectedAudio;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    // if (result != null) {
    //   setState(() {
    //     selectedImage = File(result.files.single.path!);
    //   });
    // }
  }

  Future<void> pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    // if (result != null) {
    //   setState(() {
    //     selectedAudio = File(result.files.single.path!);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Form geçerli olduğunda kaydetme işlemi yapılabilir.
              // Başlık, sanatçı adı, seçilen fotoğraf ve ses dosyası kullanılabilir.
            }
          },
          child: Text('Сохранить', style: TextStyle(color: orange)),
        ),
      ]),
      body: Form(
        key: _formKey,
        child: ListView(children: [
          const Text('Название',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Введите название',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Требуется название';
              }
              return null;
            },
          ),
          const SizedBox(height: 5),
          const Text('Исполнитель',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextFormField(
            controller: descController,
            decoration: const InputDecoration(
              labelText: 'Введите имя исполнителя',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Требуется название';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          const Text('Фото',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: pickImage, // Resim seçici
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: selectedImage != null
                      ? Image.file(selectedImage!, fit: BoxFit.cover)
                      : const Center(
                          child: Text(
                            ' Добавить Фото',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                ),
                if (selectedImage != null)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: orange,
                    child: const Text(
                      'Изменить',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Аудио',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: pickAudio,
            child: Stack(alignment: Alignment.bottomRight, children: [
              Container(
                height: 90,
                width: double.infinity,
                color: Colors.grey[300],
                child: selectedAudio != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Ses dosyası seçildi: ${selectedAudio!.path.split('/').last}"),
                          const Icon(Icons.check_circle, color: Colors.green),
                        ],
                      )
                    : const Center(
                        child: Text(
                          'Добавить Аудио',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
              ),
              if (selectedAudio != null)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: orange,
                  child: const Text(
                    'Изменить',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }
}
