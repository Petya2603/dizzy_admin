import 'package:dizzy_admin/Screens/Category/components/product_Card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extended_image/extended_image.dart';
import '../../../Config/theme/theme.dart';

class ImageScreen extends StatelessWidget {
  final String imagename, imageUrl, imagedesc;

  const ImageScreen({
    super.key,
    required this.imagename,
    required this.imageUrl,
    required this.imagedesc,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return buildDesktopLayout(context);
      } else if (constraints.maxWidth > 700 && constraints.maxWidth <= 1200) {
        return buildTabletLayout(context);
      } else {
        return buildMobileLayout(context);
      }
    });
  }

  Widget buildDesktopLayout(BuildContext context) {
    double titleFontSize = 24;
    double containerPadding = 15;
    double imageHeight = 400;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: containerPadding, vertical: 7),
      child: Column(
        children: [
          _buildTitleRow(titleFontSize, containerPadding),
          _buildImage(imageHeight, context),
        ],
      ),
    );
  }

  Widget buildTabletLayout(BuildContext context) {
    double titleFontSize = 20;
    double containerPadding = 10;
    double imageHeight = 300;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: containerPadding, vertical: 7),
      child: Column(
        children: [
          _buildTitleRow(titleFontSize, containerPadding),
          _buildImage(imageHeight, context),
        ],
      ),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    double titleFontSize = 16;
    double containerPadding = 5;
    double imageHeight = 200;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: containerPadding, vertical: 7),
      child: Column(
        children: [
          _buildTitleRow(titleFontSize, containerPadding),
          _buildImage(imageHeight, context),
        ],
      ),
    );
  }

  Widget _buildTitleRow(double titleFontSize, double containerPadding) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      margin: EdgeInsets.symmetric(horizontal: containerPadding, vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              imagename,
              style: TextStyle(fontSize: titleFontSize, color: black2),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          IconButton(
            onPressed: () {
              
            },
            icon: Icon(
              Icons.delete,
              color: orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(double imageHeight, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Get.to(
          PostPage(
            imageUrl: imageUrl,
            title: imagename,
            description: imagedesc,
          ),
        );
      },
      child: ExtendedImage.network(
        imageUrl,
        fit: BoxFit.cover,
        height: imageHeight,
        width: screenWidth * 0.8,
      ),
    );
  }
}
