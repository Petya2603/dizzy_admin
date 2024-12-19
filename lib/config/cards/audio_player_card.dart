import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../constants/constants.dart';
import '../../screens/category/controller/audio_controller.dart';

class AudioCard extends StatefulWidget {
  final String audioUrl;
  final String title;
  final String image;
  final String desc;

  const AudioCard(
      {super.key,
      required this.audioUrl,
      required this.title,
      required this.image,
      required this.desc});

  @override
  AudioCardState createState() => AudioCardState();
}

class AudioCardState extends State<AudioCard> {
  late AudioController audioController;

  @override
  void initState() {
    super.initState();
    audioController = Get.put(AudioController(), tag: widget.audioUrl);
  }

  @override
  void dispose() {
    Get.delete<AudioController>(tag: widget.audioUrl);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ExtendedImage.network(
              widget.image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  widget.desc,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Obx(() => Slider(
                      activeColor: AppColors.orange,
                      inactiveColor: AppColors.orange.withOpacity(0.3),
                      min: 0.0,
                      max: audioController.duration.value.inMilliseconds
                          .toDouble(),
                      value: audioController.position.value.inMilliseconds
                          .toDouble(),
                      onChanged: audioController.seekAudio,
                    )),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        audioController.position.value
                            .toString()
                            .split('.')
                            .first,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                      Text(
                        audioController.duration.value
                            .toString()
                            .split('.')
                            .first,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Obx(() => IconButton(
                    icon: Icon(
                      audioController.isPlaying.value
                          ? Icons.pause_circle
                          : Icons.play_circle,
                      color: AppColors.orange,
                      size: 40,
                    ),
                    onPressed: () =>
                        audioController.playPauseAudio(widget.audioUrl),
                  )),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  Assets.delete,
                  colorFilter: const ColorFilter.mode(AppColors.orange, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
