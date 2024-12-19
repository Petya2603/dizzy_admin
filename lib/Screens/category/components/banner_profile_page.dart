import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostPage extends StatelessWidget {
  PostPage({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
  });
  final String imageUrl;
  final String title;
  final String description;
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    bool isDesktop = screenWidth >= 1024;

    double titleFontSize = isMobile ? 18 : (isTablet ? 24 : 28);
    double descriptionFontSize = isMobile ? 14 : (isTablet ? 18 : 20);
    double padding = isMobile ? 10 : (isTablet ? 20 : 30);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: padding, bottom: padding / 2),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: ExtendedImage.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: isDesktop ? screenWidth * 0.7 : screenWidth * 0.9,
                  height: isDesktop ? 400 : (isTablet ? 300 : 200),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: padding / 2),
                child: Text(
                  description,
                  style: TextStyle(fontSize: descriptionFontSize),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
