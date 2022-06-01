import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final double width;
  final Color color;
  final bool cache;
  final String imageUrl;
  final bool showEditIcon;
  ProfilePic(this.width,
      {this.color = Colors.white,
      this.cache = false,
      this.imageUrl,
      this.showEditIcon = false});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipOval(
          child: imageUrl != null && imageUrl != ""
              ? (cache
                  ? CachedNetworkImage(
                      fadeInDuration: const Duration(milliseconds: 0),
                      fadeOutDuration: const Duration(milliseconds: 0),
                      placeholder: (context, str) {
                        return Icon(
                          Icons.account_circle,
                          size: width,
                          color: this.color,
                        );
                      },
                      imageUrl: imageUrl,
                      width: width,
                      height: width,
                      fit: BoxFit.cover,
                      errorWidget:
                          (BuildContext context, String text, dynamic value) {
                        return Container(
                            child: Icon(
                          Icons.account_circle,
                          size: width,
                          color: this.color,
                        ));
                      },
                    )
                  : FadeInImage.assetNetwork(
                      width: width,
                      placeholder: "assets/images/avatar.png",
                      image: imageUrl,
                      imageErrorBuilder: (BuildContext context,
                          Object exception, StackTrace stackTrace) {
                        return Container(
                            child: Icon(
                          Icons.account_circle,
                          size: width,
                          color: this.color,
                        ));
                      },
                    ))
              : Icon(
                  Icons.account_circle,
                  size: width,
                  color: this.color,
                ),
        ),
        if (showEditIcon)
          Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(216, 216, 216, 1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1, color: Colors.black)),
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.edit_sharp,
                  size: 20,
                ),
              ))
      ],
    );
  }
}
