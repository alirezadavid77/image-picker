import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  var _image;
  final picker = ImagePicker();
  List imageArray = [];


  void checkPermission ()async{

    var status = await Permission.camera.status;

    if(!status.isGranted){
      await Permission.camera.request();
    }
    if( await Permission.camera.isGranted){
      getImage();
    }
    else{
    print(status);
    }

  }

  Future getImage() async {
    var status = await Permission.camera.status;

    if(!status.isGranted){
      await Permission.camera.request();
    }
    if(await Permission.camera.isGranted){
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          imageArray.add(_image);
        } else {
          print('No image selected.');
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker '),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: (){
                  getImage();
                },
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height*.8,
              decoration: BoxDecoration(
                border: Border.all(width: 2),
              ),
              child: imageArray.isEmpty ? Center(child: Text('no image'),) : GridView.count(crossAxisCount: 4,
                children:
                  List.generate(imageArray.length, (index) {
                  var  file = imageArray[index];
                    return Image.file(file);
                 })
                ,


              ),
            )
          ],
        ),
      )
    );
  }
}