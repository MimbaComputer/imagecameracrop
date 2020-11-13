import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Camera Crop | Mimba',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Image Camera Crop By Mimba'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _selectedFile;
  bool _inProgress = false;

  Widget getImageWidget() {
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile,
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    } else {
      return
          // Icon(
          //   Icons.camera,
          //   size: 300,
          // );
          Image.asset(
        "assets/images/placeholder.png",
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    }
  }

  getImage(ImageSource source) async {
    this.setState(() {
      _inProgress = true;
    });

    File image = await ImagePicker.pickImage(source: source);

    if (image != null) {
      File imageCropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.png,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.deepOrange,
          toolbarTitle: "RPS Cropper",
          statusBarColor: Colors.deepOrange.shade900,
          backgroundColor: Colors.white,
        ),
      );
      this.setState(() {
        _selectedFile = imageCropped;
        _inProgress = false;
      });
    } else {
      this.setState(() {
        _inProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getImageWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Colors.green,
                      onPressed: () {
                        getImage(ImageSource.camera);
                      },
                      child: Text(
                        "Camera",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: Colors.deepOrange,
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      child: Text(
                        "Device",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            (_inProgress)
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.95,
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  )
                : Center()
          ],
        ),
      ),
    );
  }
}
