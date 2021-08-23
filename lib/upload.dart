import 'package:cloud_firestore/cloud_firestore.dart';

class Upload {
  Future<void> addData(blogData) async {
    FirebaseFirestore.instance.collection("News").add(blogData).catchError((e) {
      print(e);
    });
  }

  getData() async {
    return FirebaseFirestore.instance.collection("news").snapshots();
  }
}
