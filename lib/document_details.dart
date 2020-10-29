import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:focus_security/employee.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

class DocumentDetailScreen extends StatefulWidget {
  final Employee employee;

  DocumentDetailScreen({this.employee});

  @override
  _DocumentDetailScreenState createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  Map<String, String> docs = {};
  String kind;
  int count = 0;
  bool isLoading = false;
  double progressValues = 0;
  double byts = 0;
  double bytsFrom = 0;

  @override
  void initState() {
    super.initState();
    if (widget.employee.documents == null) widget.employee.documents = [];
    if (widget.employee.documents.isNotEmpty) {
      widget.employee.documents.forEach((f) {
        docs[f.kind] = f.fileUrl;
      });
    }

    getCount();
  }

  getCount() async {
    count = (await FirebaseFirestore.instance.collection('Employee').get())
        .docs
        .length;
  }

  uploadFiles() async {
    widget.employee.documents.clear();
    setState(() {
      isLoading = true;
    });
    final FirebaseApp app = await Firebase.initializeApp(
      name: 'Focus',
      options: FirebaseOptions(
        appId: (Platform.isIOS || Platform.isMacOS)
            ? '1:405351146469:ios:a1774c898660cf1640050c'
            : '1:405351146469:android:a1774c898660cf1640050c',
        apiKey: 'AIzaSyBVXYGRfKBc2F9c9WYOpa4TZ2zFKE9LFOU',
        projectId: 'focus-employee-legalities',
      ),
    );
    final FirebaseStorage storage = FirebaseStorage(
        app: app, storageBucket: 'gs://focus-employee-legalities.appspot.com');

    docs.entries.forEach((f) async {
      final StorageReference storageReference = storage
          .ref()
          .child(f.key)
          .child('emp${count}_${f.key}${p.extension(f.value)}');
      final StorageUploadTask uploadTask = storageReference.putFile(
        File.fromUri(Uri.file(f.value)),
        StorageMetadata(
          contentLanguage: 'en',
          customMetadata: <String, String>{'activity': 'test'},
        ),
      );
      final StreamSubscription<StorageTaskEvent> streamSubscription =
          uploadTask.events.listen((event) {
        setState(() {
          var bytsSting = (event.snapshot.bytesTransferred / (1024 * 1024))
              .toStringAsFixed(2);
          byts = double.parse(bytsSting);
          var bytsFormString = (event.snapshot.totalByteCount / (1024 * 1024))
              .toStringAsFixed(2);
          bytsFrom = double.parse(bytsFormString);

          progressValues = double.parse((byts / bytsFrom).toStringAsFixed(2));
        });
        print('EVENT ${event.type} ${event.snapshot.bytesTransferred}');
      });

      var img = await uploadTask.onComplete;
      var imageLink = (await img.ref.getDownloadURL()).toString();
      int idx = imageLink.lastIndexOf('&token');
      String link = imageLink.substring(0, idx);
      widget.employee.documents.add(Documents(fileUrl: link, kind: f.key));

      streamSubscription.cancel();
      setState(() {
        isLoading = false;
      });
    });
  }

  openFile(String fileUrl) {
    launch(fileUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.employee.firstName} ${widget.employee.lastName}"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Document Type',
              style: Theme.of(context).textTheme.headline6,
            ),
            DropdownButton(
                hint: Text('Document type'),
                value: kind,
                items: [
                  DropdownMenuItem(
                    child: Text('Drivers License'),
                    value: 'Drivers License',
                  ),
                  DropdownMenuItem(
                    child: Text('International Passport'),
                    value: 'International Passport',
                  ),
                  DropdownMenuItem(
                    child: Text('CV'),
                    value: 'CV',
                  ),
                  DropdownMenuItem(
                    child: Text('Security License'),
                    value: 'Security License',
                  ),
                  DropdownMenuItem(
                    child: Text('Other License'),
                    value: 'Other License',
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    kind = value;
                  });
                }),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Container(
                height: 300,
                color: Colors.black38,
                child: ListView(
                  children: <Widget>[
                    for (var item in docs.entries)
                      ListTile(
                        title: Text(item.key),
                        onTap: () {
                          openFile(item.value);
                        },
                        subtitle: Text(p.basename(item.value)),
                        trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              docs.removeWhere((key, file) => key == item.key);
                              setState(() {});
                            }),
                      )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () async {
                    if (kind == null) {
                      Get.snackbar("Error", "Please, Select type first",
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }
                    File _file = await FilePicker.getFile(type: FileType.image);
                    docs[kind] = _file.path;
                    setState(() {});
                    print(docs);
                  },
                  icon: Icon(Icons.add),
                  label: Text(
                    'Add file'.toUpperCase(),
                  ),
                ),
                FlatButton.icon(
                  onPressed: () async {
                    uploadFiles();
                  },
                  icon: Icon(Icons.cloud_upload),
                  label: Text(
                    'upload'.toUpperCase(),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            if (isLoading)
              Row(
                children: <Widget>[
                  Expanded(
                      child: LinearProgressIndicator(
                    value: progressValues,
                  )),
                  SizedBox(
                    width: 12,
                  ),
                  Text("$byts/$bytsFrom MB")
                ],
              )
          ],
        ),
      ),
    );
  }
}
