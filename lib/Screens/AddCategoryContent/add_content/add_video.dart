import 'dart:async';
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
class AddVideo extends StatefulWidget {
  const AddVideo({super.key});

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  final PostController videoController = Get.put(PostController());
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Future<void> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        _video = result.files.single.bytes;
      });
    }
  }

  Uint8List? _video;
  Future<void> uploadVideo() async {
    setState(() {
      isLoading = true;
    });
    try {
      final firestore = FirebaseFirestore.instance;
      final String category = videoController.selectedCategory.value;
      if (category.isEmpty) {
        showSnackBar(
          "Ошибка проверки",
          "Пожалуйста, выберите категорию перед сохранением.",
          Colors.red,
        );
        return;
      }
      DateTime now = DateTime.now();
      final storageRef =
          FirebaseStorage.instance.ref().child('video/video/$now.m3u8');
      List<int> videoBytes = _video!;
      String base64Video = base64Encode(videoBytes);
      await storageRef
          .putString(base64Video,
              format: PutStringFormat.base64,
              metadata: SettableMetadata(contentType: 'video/mp4'))
          .then((p0) async {
        var downloadUrl = await storageRef.getDownloadURL();
        String url = downloadUrl.toString();
        await firestore.collection(category).add({
          'name': titleController.text,
          'desc': descController.text,
          // ignore: unnecessary_null_comparison
          'video': url != null ? [url] : [],
          'category': {
            'id': '2',
            'name': 'Видео',
          },
          'timestamp': FieldValue.serverTimestamp(),
          'time': '05:00',
        });
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AddCaregoryContent()));
        showSnackBar("Успех", "Данные успешно загружены!", Colors.green);
      });
    } catch (e) {
      showSnackBar(
          "Ошибка", "Произошла ошибка при загрузке данных.", Colors.red);
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

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
              uploadVideo();
            }
          },
          child: const Text('Сохранить',
              style: TextStyle(color: AppColors.orange)),
        ),
      ]),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            if (isLoading)
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.orange),
                ),
              ),
            const Text('Название',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            buildTextFormField(
              controller: titleController,
              labelText: 'Введите название',
              hintText: 'Введите название',
            ),
            const SizedBox(height: 10),
            const Text('Исполнитель',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            buildTextFormField(
              controller: descController,
              labelText: 'Введите имя исполнителя',
              hintText: 'Введите имя исполнителя',
            ),
            const SizedBox(height: 10),
            const Text('Видео',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: pickVideo,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: _video != null
                        ? const Center(
                            child: Text(
                              'Видео добавлено',
                              style: TextStyle(color: Colors.green),
                            ),
                          )
                        : const Center(
                            child: Text(
                              'Добавить Видео',
                              style: TextStyle(color: AppColors.grey1),
                            ),
                          ),
                  ),
                  if (_video != null)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: AppColors.orange,
                      child: const Text(
                        'Изменить',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
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
                    controller: videoController.categoryController,
                    labelText: 'Введите название',
                    hintText: 'Введите название',
                  ),
                ),
                SizedBox(
                  height: 56.0,
                  child: ElevatedButton(
                    onPressed: () => videoController.addNewCategory(
                        videoController.categoryController.text),
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
                  videoController.categories.value = categories;
                });
                return Obx(() => Wrap(
                      spacing: 12.0,
                      runSpacing: 12.0,
                      children: videoController.categories.map((category) {
                        bool isSelected =
                            videoController.selectedCategory.value == category;
                        return ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            videoController.toggleCategory(category);
                          },
                          selectedColor: AppColors.black,
                          backgroundColor: AppColors.white,
                          labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.black),
                          checkmarkColor: isSelected ? AppColors.white : null,
                        );
                      }).toList(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
