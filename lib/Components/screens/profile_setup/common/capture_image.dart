import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/screens/profile_setup/common/preview_image.dart';
import 'package:spotter/core/storage.dart';
import 'package:spotter/providers/app_state.dart';
import 'dart:math' as math;

class CaptureImage extends StatefulWidget {
  final File _image;
  final Function(File) updateImageFile;
  final List<XFile> _images;
  final Function(List<XFile>) updateImageFiles;
  CaptureImage(
      this._image, this.updateImageFile, this._images, this.updateImageFiles);
  @override
  ImageState createState() => ImageState();
}

class ImageState extends State<CaptureImage> {
  final SecureStorage storage = SecureStorage();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Provider.of<AppState>(context, listen: false).userPersona == "owner"
            ? multiImagePreview()
            : singleImagePreview(),
        SizedBox(
          height: 20,
        ),
        TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.fromLTRB(10, 12, 10, 12)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(15, 32, 84, 1))),
            clipBehavior: Clip.hardEdge,
            onPressed: () {
              Provider.of<AppState>(context, listen: false).userPersona ==
                      "owner"
                  ? multiImageModal()
                  : singleImageModal();
            },
            child: Text(
              "UPLOAD",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900),
            )),
      ],
    );
  }

  singleImagePreview() {
    return widget._image == null
        ? Icon(
            Icons.photo_camera_rounded,
            size: MediaQuery.of(context).size.width * .75,
            color: Color.fromRGBO(255, 169, 0, 1),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PreviewImage(widget._image)));
            },
            child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * .375,
                backgroundColor: Color(0xffFDCF09),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * .375),
                  child: Image.file(
                    widget._image,
                    width: MediaQuery.of(context).size.width * .75,
                    height: MediaQuery.of(context).size.width * .75,
                    fit: BoxFit.fitHeight,
                  ),
                )),
          );
  }

  multiImagePreview() {
    return widget._images == null
        ? Icon(
            Icons.photo_camera,
            size: MediaQuery.of(context).size.width * .75,
            color: Color.fromRGBO(255, 169, 0, 1),
          )
        : GestureDetector(
            onTap: () {},
            child: Container(
              height: 300,
              // width: 300,
              alignment: Alignment.center,
              child: Stack(
                children: widget._images.reversed
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) => Transform.rotate(
                          origin: Offset(0, 225),
                          angle: math.pi *
                              ((widget._images.length * 0.5).ceil() -
                                  1 -
                                  entry.key) /
                              30,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              child: Image.file(
                                File(entry.value.path),
                                height: 275,
                                width: 175,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ));
  }

  singleImageModal() {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            color: Colors.black87,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 25, 0, 8),
              child: Row(
                children: [
                  modalIcon("Delete", Icons.delete, Colors.red),
                  SizedBox(
                    width: 20,
                  ),
                  modalIcon("Camera", Icons.camera, Colors.white),
                  SizedBox(
                    width: 20,
                  ),
                  modalIcon("Gallery", Icons.photo_album, Colors.white)
                ],
              ),
            ),
          );
        });
  }

  multiImageModal() {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            color: Colors.black87,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 25, 0, 8),
              child: Row(
                children: [
                  modalIcon("Delete", Icons.delete, Colors.red),
                  SizedBox(
                    width: 20,
                  ),
                  modalIcon("Gallery", Icons.photo_album, Colors.white)
                ],
              ),
            ),
          );
        });
  }

  Future<void> captureImage(String source) async {
    ImageSource imgSource = ImageSource.camera;
    if (source == "Gallery") {
      imgSource = ImageSource.gallery;
    }
    var image =
        await ImagePicker().pickImage(source: imgSource, imageQuality: 50);
    if (image != null) {
      await _cropImage(image);
    }
  }

  multipleImageCapture() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile> images = await _picker.pickMultiImage();
    if (images != null) widget.updateImageFiles(images);
  }

  Widget modalIcon(String label, IconData icon, Color iconColor) {
    return Column(
      children: [
        InkWell(
            onTap: () async {
              if (label == "Delete") {
                Provider.of<AppState>(context, listen: false).userPersona ==
                        "owner"
                    ? widget.updateImageFiles(null)
                    : widget.updateImageFile(null);
              } else {
                Provider.of<AppState>(context, listen: false).userPersona ==
                        "owner"
                    ? await multipleImageCapture()
                    : await captureImage(label);
                Navigator.of(context).pop();
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: iconColor,
                size: 30,
              ),
            )),
        Text(label, style: TextStyle(color: Colors.white))
      ],
    );
  }

  Future<Null> _cropImage(XFile imageSelected) async {
    File croppedFile = await ImageCropper.cropImage(
        // cropStyle: CropStyle.circle,
        sourcePath: imageSelected.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
            hideBottomControls: true),
        iosUiSettings:
            IOSUiSettings(title: '', rotateClockwiseButtonHidden: true));
    if (croppedFile != null) {
      widget.updateImageFile(croppedFile);
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    // _controller.dispose();
    super.dispose();
  }
}
