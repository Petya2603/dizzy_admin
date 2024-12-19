import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/constants.dart';
import '../../../config/constants/widgets.dart';
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
      showSnackBar("Ошибка проверки", "Фото не добавлено", Colors.red);
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
      showSnackBar("Ошибка проверки", "Аудио не добавлено", Colors.red);
    }
  }

  Uint8List? _photo;
  Uint8List? _music;

  Future<void> uploadMedia() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final String category = audioController.selectedCategory.value;
      if (category.isEmpty) {
        showSnackBar("Ошибка проверки",
            "Пожалуйста, выберите категорию перед сохранением.", Colors.red);
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
          showSnackBar("Успех", "Данные успешно загружены!", Colors.green);
        });
      });
    } catch (e) {
      showSnackBar("Ошибка проверки",
          "Пожалуйста, выберите категорию перед сохранением.", Colors.red);
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
          child: const Text('Сохранить', style: TextStyle(color: AppColors.orange)),
        ),
      ]),
      body: Form(
        key: _formKey,
        child: ListView(children: [
          if (isLoading)
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.orange),
              ),
            ),
          const Text('Название',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          buildTextFormField(
              labelText: 'Введите название',
              controller: titleController,
              hintText: 'Введите название'),
          const SizedBox(height: 5),
          const Text('Исполнитель',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          buildTextFormField(
            labelText: 'Введите имя исполнителя',
            controller: descController,
            hintText: 'Введите имя исполнителя',
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
                    color: AppColors.orange,
                    child: const Text(
                      'Изменить',
                      style: TextStyle(color: AppColors.white),
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
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Аудио добавлено",
                            style: TextStyle(color: Colors.green),
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
                  color: AppColors.orange,
                  child: const Text(
                    'Изменить',
                    style: TextStyle(color: AppColors.white),
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
                  hintText: 'Введите название',
                ),
              ),
              SizedBox(
                height: 56.0,
                child: ElevatedButton(
                  onPressed: () => audioController
                      .addNewCategory(audioController.categoryController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'Добавить',
                    style: TextStyle(color: AppColors.white),
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
                        selectedColor: AppColors.black,
                        backgroundColor: AppColors.white,
                        labelStyle:
                            TextStyle(color: isSelected ? AppColors.white : AppColors.black),
                        checkmarkColor: isSelected ? AppColors.white : null,
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
