import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizzy_admin/Screens/AddCategoryContent/controller/post_controller.dart';
import 'package:dizzy_admin/config/constants/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/constants.dart';
import '../add_category_content.dart';

// ignore: must_be_immutable
class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final PostController postController = Get.put(PostController());
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _photo = result.files.single.bytes;
      });
    }
  }

  Uint8List? _photo;
  Future uploadImage() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final String category = postController.selectedCategory.value;
      if (category.isEmpty) {
        showSnackBar("Ошибка проверки",
            "Пожалуйста, выберите категорию перед сохранением.", Colors.red);
        return;
      }
      DateTime now = DateTime.now();
      final storageRef =
          FirebaseStorage.instance.ref().child('post/images/$now.png');
      List<int> imageBytes = _photo!;
      String base64Image = base64Encode(imageBytes);

      await storageRef
          .putString(base64Image,
              format: PutStringFormat.base64,
              metadata: SettableMetadata(contentType: 'image/png'))
          .then((p0) async {
        var downloadUrl = await storageRef.getDownloadURL();
        String url = downloadUrl.toString();

        await firestore.collection(category).add({
          'name': titleController.text,
          'desc': descController.text,
          // ignore: unnecessary_null_comparison
          'images': url != null ? [url] : [],
          'category': {
            'id': '1',
            'name': 'Пост',
          },
          'timestamp': FieldValue.serverTimestamp(),
          'time': '05:00',
        });
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AddCaregoryContent()));
        showSnackBar(
          "Успех",
          "Данные успешно загружены!",
          Colors.green,
        );
      });
    } catch (e) {
      showSnackBar(
        "Ошибка",
        "Произошла ошибка при загрузке данных.",
        Colors.red,
      );
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
              uploadImage();
            }
          },
          child: const Text('Сохранить', style: TextStyle(color: AppColors.orange)),
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
            const Text('Фото',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: _photo != null
                        ? Image.memory(_photo!, fit: BoxFit.fill)
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
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text('Текст',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: buildTextFormField(
                labelText: 'Введите Текст',
                controller: descController,
                hintText: 'Введите Текст',
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
                  child: TextFormField(
                    controller: postController.categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Введите название',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 56.0,
                  child: ElevatedButton(
                    onPressed: () => postController
                        .addNewCategory(postController.categoryController.text),
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
                  postController.categories.value = categories;
                });
                return Obx(() => Wrap(
                      spacing: 12.0,
                      runSpacing: 12.0,
                      children: postController.categories.map((category) {
                        bool isSelected =
                            postController.selectedCategory.value == category;
                        return ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            postController.toggleCategory(category);
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
