import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
/*import 'package:news/FirebaseApi.dart';
import 'package:path/path.dart' as path;*/
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  File? selectedImage;
  bool _isLoading = false;
  var image;

  Future getImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  uploadToFirebase() async {
    setState(() {
      _isLoading = true;
    });
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("newsImages")
        .child('/$postedBy.jpg');

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
  }

  /*Future uploadBlog() async {
    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });
      File imageFile = File(pickedImage!.path);
      final destination = 'newsImages/$imageFile';
      final String fileName = path.basename(pickedImage!.path);
      final UploadTask task = firebase_storage.FirebaseStorage.instance
          .ref(fileName)
          .putFile(
              imageFile,
              SettableMetadata(customMetadata: {
                'uploaded_by': 'A bad guy',
                'description': 'Some description...'
              }));
      var downloadUrl = (await (await task).ref.getDownloadURL());
      print("this is the url $downloadUrl");
    } else {
      //as
    }
  }*/
  /*Future uploadFile() async {
    if (selectedImage != null) {
      final fileName = path.basename(selectedImage!.path);
      final destination = 'newsImages/$fileName';



      FirebaseApi.uploadFile(destination, File(fileName));
    } else {
      print("nothing done!");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text('Write News'),
        ),
        body: _isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        uploadToFirebase();
                      },
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
                            decoration:
                                InputDecoration(hintText: "Author Name"),
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
                            decoration:
                                InputDecoration(hintText: "News Description"),
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
                                onPressed: uploadToFirebase,
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
