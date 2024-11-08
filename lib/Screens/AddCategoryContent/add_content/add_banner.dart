import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Config/theme/theme.dart';
import '../controller/banner_controller.dart';

// ignore: must_be_immutable
class AddBanner extends StatefulWidget {

  const AddBanner({super.key});

  @override
  State<AddBanner> createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {
  final BannerController bannerController = Get.put(BannerController());

  File? selectedImage;

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        selectedImage = File(result.files.single.path!);
      });
    }
  }

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
          const SizedBox(height: 20),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: () {
                        bannerController.toggleHidden();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          backgroundColor:
                              bannerController.isHidden.value ? white : red,
                          side: BorderSide(color: red),
                          padding: const EdgeInsets.symmetric(vertical: 20)),
                      child: Text('Скрывать',
                          style: TextStyle(
                            color:
                                bannerController.isHidden.value ? red : white,
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: () {
                        bannerController.toggleHidden();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          backgroundColor:
                              bannerController.isHidden.value ? green : white,
                          side: BorderSide(
                            color: green,
                            width: 2.0,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20)),
                      child: Text('Показать',
                          style: TextStyle(
                            color:
                                bannerController.isHidden.value ? white : green,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
