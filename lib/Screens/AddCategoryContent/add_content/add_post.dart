import 'dart:io';

import 'package:dizzy_admin/Config/theme/theme.dart';
import 'package:dizzy_admin/Screens/AddCategoryContent/controller/post_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddPost extends StatelessWidget {
  AddPost({super.key});
  PostController postController = PostController();
  File? selectedImage;
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

  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, actions: [
        TextButton(
          onPressed: () {},
          child: Text('Сохранить', style: TextStyle(color: orange)),
        ),
      ]),
      body: ListView(
        children: [
          const Text('Название',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Введите название',
              border: OutlineInputBorder(),
            ),
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
          const SizedBox(height: 10),
          const Text('Текст',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: TextFormField(
              controller: textController,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Введите Текст',
                border: OutlineInputBorder(),
              ),
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
                  onPressed: postController.addCategory,
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
          Obx(
            () => Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: postController.categories.map((category) {
                bool isSelected =
                    postController.selectedCategory.contains(category);
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    postController.toggleCategory(category);
                  },
                  selectedColor: black,
                  backgroundColor: white,
                  labelStyle: TextStyle(color: isSelected ? white : black),
                  checkmarkColor: isSelected ? white : null,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
