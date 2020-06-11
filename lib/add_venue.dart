import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:focus_security/laoding.dart';
import 'package:focus_security/venue.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

class AddVenue extends StatefulWidget {
  final Venue venue;

  AddVenue({this.venue});

  @override
  _AddVenueState createState() => _AddVenueState();
}

class _AddVenueState extends State<AddVenue> {
  File _file;
  int count = 0;

  @override
  void initState() {
    super.initState();

    getCount();
  }

  getCount() async {
    count = (await Firestore.instance.collection('Venues').getDocuments())
            .documents
            .length +
        1;
  }

  Future<String> uploadFile() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'Focus',
      options: FirebaseOptions(
        googleAppID: (Platform.isIOS || Platform.isMacOS)
            ? '1:405351146469:ios:a1774c898660cf1640050c'
            : '1:405351146469:android:a1774c898660cf1640050c',
        apiKey: 'AIzaSyBVXYGRfKBc2F9c9WYOpa4TZ2zFKE9LFOU',
        projectID: 'focus-employee-legalities',
      ),
    );
    final FirebaseStorage storage = FirebaseStorage(
        app: app, storageBucket: 'gs://focus-employee-legalities.appspot.com');

    final StorageReference storageReference = storage
        .ref()
        .child('time_sheet')
        .child('emp$count${p.extension(_file.path)}');

    final StorageUploadTask uploadTask = storageReference.putFile(
      _file,
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'activity': 'test'},
      ),
    );

    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      print('EVENT ${event.type} ${event.snapshot.bytesTransferred}');
    });

    var img = await uploadTask.onComplete;
    var imageLink = (await img.ref.getDownloadURL()).toString();

    streamSubscription.cancel();
    int idx = imageLink.lastIndexOf('&token');
    String link = imageLink.substring(0, idx);
    return link;
  }

  saveVenue() async {
    print("Started.....$count");

    Get.dialog(LoadingScreen());

    if (_file != null) {
      var imageLink = await uploadFile();
      print("Basem image link $imageLink");
      widget.venue.file = imageLink;
    }

    if (widget.venue.id == null) {
      widget.venue.id = "venue_$count";
      await Firestore.instance
          .collection("Venues")
          .document(widget.venue.id)
          .setData(widget.venue.toJson());
    } else {
      await Firestore.instance
          .collection("Venues")
          .document(widget.venue.id)
          .updateData(widget.venue.toJson());
    }
    Get.back();
    count++;
    await getCount();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Venue'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: TextEditingController.fromValue(
                    TextEditingValue(text: widget.venue.name)),
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Venue name',
                ),
                onChanged: (value) {
                  widget.venue.name = value;
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                onTap: () async {
                  widget.venue.date = await showDatePicker(
                    initialDatePickerMode: DatePickerMode.day,
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1960, 1, 1),
                    lastDate: DateTime.now().add(Duration(days: 365 * 3)),
                  );
                  setState(() {});
                },
                controller: TextEditingController.fromValue(TextEditingValue(
                    text: widget.venue.date != null
                        ? DateFormat('dd/MM/yyyy').format(widget.venue.date)
                        : '')),
                readOnly: true,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Date',
                ),
              ),
              TextField(
                  controller: TextEditingController.fromValue(TextEditingValue(
                      text: (widget.venue.fare ?? 0.0).toString())),
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Venue fare',
                  ),
                  onChanged: (value) {
                    widget.venue.fare = double.parse(value);
                  }),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text(((_file == null && widget.venue.file == null))
                    ? 'Add timesheet'
                    : 'Added'),
                trailing: (_file == null && widget.venue.file == null)
                    ? null
                    : Icon(Icons.check),
                subtitle:
                    Text(widget.venue.file == null ? '' : widget.venue.file),
                onTap: () async {
                  _file = await FilePicker.getFile(type: FileType.image);
                  setState(() {});
                },
              ),
              SizedBox(
                height: 8,
              ),
              FlatButton(
                  onPressed: () async {
                    var url = widget.venue.file;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text('open file'.toUpperCase())),
              SizedBox(
                height: 12,
              ),
              TextField(
                  textInputAction: TextInputAction.newline,
                  enableInteractiveSelection: true,
                  enableSuggestions: true,
                  maxLines: 10,
                  controller: TextEditingController.fromValue(
                      TextEditingValue(text: (widget.venue.note ?? ''))),
                  decoration: InputDecoration(
                    labelText: 'Incidents',
                    alignLabelWithHint: false,
                  ),
                  onChanged: (value) {
                    widget.venue.note = value;
                  }),
              SizedBox(
                height: 20,
              ),
              Center(
                child: MaterialButton(
                  onPressed: () {
                    saveVenue();
                  },
                  color: Theme.of(context).primaryColor,
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  height: 45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Text('Save'.toUpperCase()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
