import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
/*import 'package:news/FirebaseApi.dart';
import 'package:path/path.dart' as path;*/
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news/upload.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
final usersRef = FirebaseFirestore.instance.collection('');

class PostNews extends StatefulWidget {
  const PostNews({Key? key}) : super(key: key);

  @override
  _PostNewsState createState() => _PostNewsState();
}

class _PostNewsState extends State<PostNews> {
  String postedBy = "";
  String newsTitle = "";
  String desc = "";
  String body = "";

  Upload upload = new Upload();
  ImagePicker picker = ImagePicker();

  File? selectedImage;
  //bool _isLoading = false;
  var image;

  Future getImage() async {
    final image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        selectedImage = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  uploadToFirebase() async {
    await Firebase.initializeApp();
    if (selectedImage != null) {
      /*setState(() {
        _isLoading = true;
      });*/
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("newsImages.jpg")
          .child('defaultProfile.png');

      final UploadTask task = ref.putFile(selectedImage!);

      var downloadUrl = await (await task).ref.getDownloadURL();
      print("this is url $downloadUrl");

      Map<String, String> blogMap = {
        "imgUrl": downloadUrl,
        "authorName": postedBy,
        "title": newsTitle,
        "description": desc,
        "body": body,
      };
      upload.addData(blogMap).then(
            (result) => print("done"),
          );
      /*setState(() {
        _isLoading = false;
      });*/
    } else {
      //asd
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text('Write News'),
        ),
        body:
            /*_isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            :*/
            Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => getImage(),
                child: selectedImage != null
                    ? Container(
                        height: 150,
                        child: Image.file(
                          File(selectedImage!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(6)),
                        width: double.infinity,
                        child: Icon(Icons.add_a_photo),
                      ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.green,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(hintText: "Author Name"),
                      onChanged: (value) {
                        postedBy = value;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: "News Title"),
                      onChanged: (value) {
                        newsTitle = value;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: "News Description"),
                      onChanged: (value) {
                        desc = value;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: "News Body"),
                      onChanged: (value) {
                        body = value;
                      },
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () => uploadToFirebase(),
                          child: Text('Make Post')),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
