import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizzy_admin/config/cards/banner_cards.dart';
import 'package:flutter/material.dart';

import '../../config/cards/audio_player_card.dart';
import '../../config/cards/video_player_card.dart';

class CategoryView extends StatelessWidget {
  CategoryView({
    super.key,
    required this.categoryname,
    required this.documents,
  });
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String categoryname;
  final List<DocumentSnapshot> documents;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {
        Map<String, dynamic>? data =
            documents[index].data() as Map<String, dynamic>?;
        if (data == null ||
            data['category'] == null ||
            data['category']['id'] == null) {
          return const Center(child: Text('В этой категории нет информации'));
        }
        String categoryId = data['category']['id'];

        return buildCategoryCard(categoryId, data, index);
      },
    );
  }

  Widget buildCategoryCard(
      String? categoryId, Map<String, dynamic> data, int index) {
    switch (categoryId) {
      case '1':
        return BannerCARD(
          bannerData: data,
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
            title: Text('No category'),
          ),
        );
    }
  }
}
