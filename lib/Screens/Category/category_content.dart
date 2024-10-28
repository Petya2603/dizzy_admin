import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizzy_admin/Config/contstants/constants.dart';
import 'package:dizzy_admin/Config/contstants/widgets.dart';
import 'package:dizzy_admin/Config/theme/theme.dart';
import 'package:dizzy_admin/Screens/Category/components/audio_player.dart';
import 'package:dizzy_admin/Screens/Category/components/product_Card.dart';
import 'package:dizzy_admin/Screens/Category/components/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
// ignore: depend_on_referenced_packages

class CategoryContent extends StatelessWidget {
  CategoryContent({
    super.key,
    required this.categoryname,
  });
  final firestore = FirebaseFirestore.instance;
  final String categoryname;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: firestore.collection(categoryname).get(),
      builder: (context, collectionSnapshot) {
        if (collectionSnapshot.hasError) {
          return const Center(child: Text("Error"));
        } else if (collectionSnapshot.connectionState ==
            ConnectionState.waiting) {
          return Center(child: spinKit());
        }
        final documents = collectionSnapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            var data = documents[index];
            var categoryId = data['category']['id'];

            return buildCategoryCard(categoryId, data, index);
          },
        );
      },
    );
  }

  Widget buildCategoryCard(String categoryId, var data, int index) {
    switch (categoryId) {
      case '1':
        return Container(
          margin: const EdgeInsets.only(left: 5, right: 5, top: 7),
          child: Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(4)),
                margin: const EdgeInsets.only(left: 5, right: 5, top: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['name'],
                      style: TextStyle(fontSize: 18, color: black2),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        deleted,
                        colorFilter: ColorFilter.mode(orange, BlendMode.srcIn),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(
                    PostPage(
                      imageUrl: data['images'][index],
                      title: data['name'],
                      description: data['desc'],
                    ),
                  );
                },
                child: CachedNetworkImage(
                  imageUrl: data['images'][index],
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => spinKit(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ],
          ),
        );
      case '2':
        return VideoCard(
          videoUrl: data['video'],
          text: data['name'],
        );
      case '3':
        return AudioCard(
          audioUrl: data['music'],
          title: data['name'],
          image: data['image'],
          desc: data['desc'],
        );
      default:
        return const Card(
          child: ListTile(
            title: Text('Kategori yok'),
          ),
        );
    }
  }
}
