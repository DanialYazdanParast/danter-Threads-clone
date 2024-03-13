import 'package:danter/core/constants/custom_colors.dart';
import 'package:danter/data/model/post.dart';

import 'package:danter/core/widgets/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen(
      {super.key,
      required this.postEntity,
      required this.indeximage,
      required this.pagename});
  final PostEntity postEntity;
  final int indeximage;
  final String pagename;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  bool celectmultiply = true;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    // to re-show bars
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  celectmultiply = !celectmultiply;
                });
              },
              child: PageView.builder(
                itemCount: widget.postEntity.image.length,
                clipBehavior: Clip.hardEdge,
                controller: PageController(initialPage: widget.indeximage),
                itemBuilder: (context, index) {
                  return Hero(
                    tag: '${widget.pagename}${widget.postEntity.image[index]}',
                    child: InteractiveViewer(
                      panEnabled: false, // Set it to false
                      boundaryMargin: EdgeInsets.all(100),
                      minScale: 0.5,
                      maxScale: 4,

                      child: ImageLodingService(
                        imageUrl:
                            'https://dan.chbk.run/api/files/6291brssbcd64k6/${widget.postEntity.id}/${widget.postEntity.image[index]}',
                        boxFit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),
            celectmultiply == true
                ? Positioned(
                    top: 10,
                    left: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: LightThemeColors.secondaryTextColor
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(100)),
                        child: const Icon(
                          CupertinoIcons.multiply,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
