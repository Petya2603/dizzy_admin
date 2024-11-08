import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizzy_admin/Config/contstants/widgets.dart';
import 'package:dizzy_admin/Screens/Category/components/audio_player.dart';
import 'package:dizzy_admin/Screens/Category/components/image_screen.dart';
import 'package:dizzy_admin/Screens/Category/components/video_player.dart';
import 'package:flutter/material.dart';

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
        return ImageScreen(
          imagename: data['name'],
          imageUrl: data['images'][0],
          imagedesc: data['desc'],
        );
      case '2':
        return VideoCard(
          videoUrl: data['video'][0],
          text: data['name'],
        );
      case '3':
        return AudioCard(
          audioUrl: data['music'][0],
          title: data['name'],
          image: data['image'][0],
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
