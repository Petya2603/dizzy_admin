import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Config/theme/theme.dart';
import '../controller/video_controller.dart';

// ignore: must_be_immutable
class AddVideo extends StatelessWidget {
  AddVideo({super.key});
  VideoController videoController = VideoController();
  File? selectedVideo;
  Future<void> pickVideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    // if (result != null) {
    //   setState(() {
    //     selectedVideo = File(result.files.single.path!);  // Video dosyasını kaydet
    //   });
    // }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
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
          const Text('Исполнитель',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextFormField(
            controller: descController,
            decoration: const InputDecoration(
              labelText: 'Введите имя исполнителя',
              border: OutlineInputBorder(),
            ),
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
                  color: const Color.fromARGB(255, 238, 238, 238),
                  child: selectedVideo != null
                      ? Image.file(
                          selectedVideo!,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Text(
                            'Добавить Видео',
                            style: TextStyle(color: grey1),
                          ),
                        ),
                ),
                if (selectedVideo != null)
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
                  controller: videoController.categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Введите название',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 56.0,
                child: ElevatedButton(
                  onPressed: videoController.addCategory,
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
              children: videoController.categories.map((category) {
                bool isSelected =
                    videoController.selectedCategory.contains(category);
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    videoController.toggleCategory(category);
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
