import 'package:flutter/material.dart';

class PlayerPicture extends StatelessWidget {
  final String url;
  final double height;

  const PlayerPicture(this.url, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(
          width: 1.0,
          color: Color(0x00000000),
        ),
      ),
      child: getImage(),
    );
  }

  Image getImage() {
    try {
      if (url != null && url.isNotEmpty) {
        if (url.toLowerCase().endsWith('.png')) {
          return Image.network(
            url,
            height: height,
          );
        }
      }
    } catch (e) {
      print('Exception in _buildImage for $url: $e');
    }

    return Image.asset(
      'assets/images/icons/male-user.png',
      height: height,
    );
  }
}
