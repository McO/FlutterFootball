import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class LogoIcon extends StatelessWidget {
  final String url;
  final double height;

  const LogoIcon(this.url, this.height);

  @override
  Widget build(BuildContext context) {
    try {
      if (url != null && url.isNotEmpty) {
        if (url.toLowerCase().endsWith('.svg')) {
          return SvgPicture.network(
            url,
            height: height,
          );
        }
        if (url.toLowerCase().endsWith('.png')) {
          return Image.network(
            url,
            height: height,
          );
        }
      }
    }
    catch (e) {
      print('Exception in _buildImage for $url: $e');
    }

    return Container();


//    try {
//      if (team.logoUrl?.isEmpty ?? true) {
//        String path = 'assets/images/teams/' + team.id.toString() + '.png';
//        rootBundle.load(path).then((value) {
//          return CircleAvatar(
//            backgroundColor: Colors.grey,
//            backgroundImage: AssetImage(path),
//            maxRadius: 8,
//          );
//        }).catchError((_) {
//          return null;
//        });
////      return AssetImage(path);
//      }
//    } catch (_) {}
//
//    try {
//      return SvgPicture.network(
//        team.logoUrl ?? '',
//        height: 30,
//      );
//    } catch (_) {}
//
//    return Image.network(team.logoUrl);
  }
}