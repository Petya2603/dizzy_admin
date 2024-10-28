import 'package:dizzy_admin/Config/contstants/constants.dart';
import 'package:dizzy_admin/Config/theme/theme.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  late AudioPlayer audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  void playPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(widget.audioUrl));
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: music, borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.only(left: 5, right: 5, top: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            SizedBox(
              height: 70,
              width: 70,
              child: ExtendedImage.network(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    widget.desc,
                    style: TextStyle(fontSize: 12, color: grey2),
                  ),
                ),
              ],
            ),
          ]),
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: playPause,
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
    );
  }
}
