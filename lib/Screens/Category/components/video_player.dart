import 'package:dizzy_admin/Config/contstants/constants.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:dizzy_admin/Config/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';

class VideoCard extends StatefulWidget {
  final String videoUrl;
  final String text;

  const VideoCard({super.key, required this.videoUrl, required this.text});

  @override
  VideoCardState createState() => VideoCardState();
}

class VideoCardState extends State<VideoCard> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      // ignore: deprecated_member_use
      videoPlayerController: VideoPlayerController.network(widget.videoUrl)
        ..setLooping(true)
        ..initialize().then((_) {
          flickManager.flickControlManager?.pause();
        }),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 7),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              widget.text,
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
          ]),
        ),
        Card(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: FutureBuilder(
              future: flickManager.flickVideoManager!.videoPlayerController!
                  .initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return FlickVideoPlayer(
                    flickManager: flickManager,
                    flickVideoWithControls: const FlickVideoWithControls(
                      controls: FlickPortraitControls(),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
