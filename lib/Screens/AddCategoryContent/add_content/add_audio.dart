import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Config/contstants/widgets.dart';
import '../../../Config/theme/theme.dart';
import '../add_category_content.dart';
import '../controller/post_controller.dart';

// ignore: must_be_immutable
class AddAudio extends StatefulWidget {
  const AddAudio({super.key});

  @override
  State<AddAudio> createState() => _AddAudioState();
}

class _AddAudioState extends State<AddAudio> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final PostController audioController = Get.put(PostController());
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _photo = result.files.single.bytes;
        });
      }
    } catch (e) {
      showSnackbar("Ошибка проверки", "Фото не добавлено",
          backgroundColor: red);
    }
  }

  Future<void> pickAudio() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _music = result.files.single.bytes;
        });
      }
    } catch (e) {
      showSnackbar("Ошибка проверки", "Аудио не добавлено",
          backgroundColor: red);
    }
  }

  Uint8List? _photo;
  Uint8List? _music;

  Future<void> uploadMedia() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final String category = audioController.selectedCategory.value;
      if (category.isEmpty) {
        showSnackbar("Ошибка проверки",
            "Пожалуйста, выберите категорию перед сохранением.",
            backgroundColor: red);
        return;
      }
      DateTime now = DateTime.now();
      final imageStorageRef =
          FirebaseStorage.instance.ref().child('aydym/images/$now.png');
      List<int> imageBytes = _photo!;
      String base64Image = base64Encode(imageBytes);
//
      await imageStorageRef
          .putString(base64Image,
              format: PutStringFormat.base64,
              metadata: SettableMetadata(contentType: 'image/png'))
          .then((p0) async {
        var imageUrl = await imageStorageRef.getDownloadURL();
        String imageurl = imageUrl.toString();
//
        final audioStorageRef =
            FirebaseStorage.instance.ref().child('aydym/aydym/$now.mp3');
        List<int> audioBytes = _music!;
        String base64Audio = base64Encode(audioBytes);

        UploadTask audioUploadTask = audioStorageRef.putString(
          base64Audio,
          format: PutStringFormat.base64,
          metadata: SettableMetadata(contentType: 'audio/mpeg'),
        );
        await audioUploadTask.whenComplete(() async {
          var audioUrl = await audioStorageRef.getDownloadURL();
          String audiourl = audioUrl.toString();
          await firestore.collection(category).add({
            'name': titleController.text,
            'desc': descController.text,
            // ignore: unnecessary_null_comparison
            'image': imageurl != null ? [imageurl] : [],
            'category': {
              'id': '3',
              'name': 'Музыка',
            },
            // ignore: unnecessary_null_comparison
            'music': audiourl != null ? [audiourl] : [],
            'timestamp': FieldValue.serverTimestamp(),
            'time': '05:00',
          });

          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddCaregoryContent()));
          showSnackbar("Успех", "Данные успешно загружены!",
              backgroundColor: green2);
        });
      });
    } catch (e) {
      showSnackbar("Ошибка проверки",
          "Пожалуйста, выберите категорию перед сохранением.",
          backgroundColor: red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                isLoading = true;
              });
              uploadMedia();
            }
          },
          child: Text('Сохранить', style: TextStyle(color: orange)),
        ),
      ]),
      body: Form(
        key: _formKey,
        child: ListView(children: [
          if (isLoading)
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Center(
                child: CircularProgressIndicator(color: orange),
              ),
            ),
          const Text('Название',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          buildTextFormField(
            labelText: 'Введите название',
            controller: titleController,
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
          buildTextFormField(
            labelText: 'Введите имя исполнителя',
            controller: descController,
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
                  child: _photo != null
                      ? Image.memory(_photo!, fit: BoxFit.cover)
                      : const Center(
                          child: Text(
                            ' Добавить Фото',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                ),
                if (_photo != null)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: orange,
                    child: Text(
                      'Изменить',
                      style: TextStyle(color: white),
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
                child: _music != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Аудио добавлено",
                            style: TextStyle(color: green),
                          ),
                        ],
                      )
                    : const Center(
                        child: Text(
                          'Добавить Аудио',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
              ),
              if (_music != null)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: orange,
                  child: Text(
                    'Изменить',
                    style: TextStyle(color: white),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 10),
          const Text('Категория',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: buildTextFormField(
                  labelText: 'Введите название',
                  controller: audioController.categoryController,
                ),
              ),
              SizedBox(
                height: 56.0,
                child: ElevatedButton(
                  onPressed: () => audioController
                      .addNewCategory(audioController.categoryController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    'Добавить',
                    style: TextStyle(color: white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('Category').get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: spinKit());
              } else if (snapshot.error != null) {
                return const Text("Error");
              }
              var categories = snapshot.data!.docs
                  .map((doc) => doc['name'] as String)
                  .toList();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                audioController.categories.value = categories;
              });

              return Obx(() => Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: audioController.categories.map((category) {
                      bool isSelected =
                          audioController.selectedCategory.value == category;
                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          audioController.toggleCategory(category);
                        },
                        selectedColor: black,
                        backgroundColor: white,
                        labelStyle:
                            TextStyle(color: isSelected ? white : black),
                        checkmarkColor: isSelected ? white : null,
                      );
                    }).toList(),
                  ));
            },
          ),
        ]),
      ),
    );
  }
}
