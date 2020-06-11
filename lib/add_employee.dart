import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:focus_security/bank_details.dart';
import 'package:focus_security/document_details.dart';
import 'package:focus_security/employee.dart';
import 'package:focus_security/laoding.dart';
import 'package:focus_security/question_details.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AddEmployee extends StatefulWidget {
  final Employee employee;

  AddEmployee({this.employee});

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  File _image;
  int count = 0;
  String nextId;

  @override
  void initState() {
    super.initState();
    nextId = "emp_$count";
    if (widget.employee.interviewer == null)
      widget.employee.interviewer =
          Interviewer(date: DateTime.now(), name: '', postion: '');

    getCount();
  }

  void printEmployee() async {
    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Text('Employee ID: ${widget.employee.id}'),
            pw.Text(
                'Full name: ${widget.employee.firstName} ${widget.employee.middleName} ${widget.employee.lastName}'),
            pw.Text(
                'Address : ${widget.employee.address}, ${widget.employee.city}, ${widget.employee.state}'),
            pw.Text('Phone : ${widget.employee.phone}'),
            pw.Text(
                'Dob : ${DateFormat('dd/MM/yyyy').format(widget.employee.dob)}'),
            pw.Text('Gender : ${widget.employee.gender}'),
            pw.Text(
                'Security license NO : ${widget.employee.securityLicenseNo}'),
            pw.Text('Flate rate : ${widget.employee.rate}'),
          ]); // Center
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  getCount() async {
    count = (await Firestore.instance.collection('Employees').getDocuments())
            .documents
            .length +
        1;

    setState(() {
      nextId = "emp_$count";
      print(nextId);
    });
  }

  void saveEmployee() async {
    print("Started.....$count");
    Get.dialog(LoadingScreen());

    if (_image != null) {
      var imageLink = await uploadImage();
      print("Basem image link $imageLink");
      widget.employee.imageUrl = imageLink;
    }

    if (widget.employee.id == null) {
      widget.employee.id = "emp_$count";
      await Firestore.instance
          .collection("Employees")
          .document(widget.employee.id)
          .setData(widget.employee.toJson());
    } else {
      await Firestore.instance
          .collection("Employees")
          .document(widget.employee.id)
          .updateData(widget.employee.toJson());
    }
    Get.back();
    count++;
    await getCount();
    Get.back();
  }

  void pickFile() async {
    _image = await FilePicker.getFile(type: FileType.image);
    setState(() {});
  }

  Future<String> uploadImage() async {
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

    final StorageReference storageReference =
        storage.ref().child('image').child('emp$count.png');

    final StorageUploadTask uploadTask = storageReference.putFile(
      _image,
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'activity': 'test'},
      ),
    );

    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      print('EVENT ${event.type} ${event.snapshot.bytesTransferred}');
    });

// Cancel your subscription when done.
    var img = await uploadTask.onComplete;
    var imageLink = (await img.ref.getDownloadURL()).toString();

    streamSubscription.cancel();
    int idx = imageLink.lastIndexOf('&token');
    String link = imageLink.substring(0, idx);
    return link;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.employee.firstName == null
            ? 'Add Employee'
            : '${widget.employee.firstName} ${widget.employee.lastName}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      pickFile();
                    },
                    child: CircleAvatar(
                      backgroundImage: _image == null
                          ? widget.employee.imageUrl != null
                              ? CachedNetworkImageProvider(
                                  widget.employee.imageUrl)
                              : null
                          : FileImage(_image),
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 50,
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 36,
                  ),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: widget.employee.id ?? "emp_$count")),
                      enabled: false,
                      maxLines: 1,
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Employee ID',
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: TextEditingController.fromValue(
                    TextEditingValue(text: widget.employee.firstName ?? '')),
                onChanged: (value) {
                  widget.employee.firstName = value;
                },
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        widget.employee.middleName = value;
                      },
                      controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: widget.employee.middleName ?? '')),
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Middle Name',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        widget.employee.lastName = value;
                      },
                      controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: widget.employee.lastName ?? '')),
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                      ),
                    ),
                  )
                ],
              ),
              TextField(
                onChanged: (value) {
                  widget.employee.address = value;
                },
                controller: TextEditingController.fromValue(
                    TextEditingValue(text: widget.employee.address ?? '')),
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        widget.employee.city = value;
                      },
                      controller: TextEditingController.fromValue(
                          TextEditingValue(text: widget.employee.city ?? '')),
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'City',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        widget.employee.state = value;
                      },
                      controller: TextEditingController.fromValue(
                          TextEditingValue(text: widget.employee.state ?? '')),
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'State',
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        widget.employee.postalCode = int.parse(value);
                      },
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: (widget.employee.postalCode ?? 0).toString()),
                      ),
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Postal Code',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextField(
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: (widget.employee.age ?? 0).toString()),
                      ),
                      maxLines: 1,
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Age',
                      ),
                    ),
                  )
                ],
              ),
              TextField(
                onChanged: (value) {
                  widget.employee.phone = value;
                },
                controller: TextEditingController.fromValue(
                    TextEditingValue(text: widget.employee.phone ?? '')),
                keyboardType: TextInputType.phone,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onTap: () async {
                        widget.employee.dob = await showDatePicker(
                          initialDatePickerMode: DatePickerMode.day,
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1960, 1, 1),
                          lastDate: DateTime.now().add(Duration(days: 365 * 3)),
                        );
                        setState(() {
                          widget.employee.age =
                              (DateTime.now().year - widget.employee.dob.year);
                        });
                      },
                      controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: widget.employee.dob != null
                                  ? DateFormat('dd/MM/yyyy')
                                      .format(widget.employee.dob)
                                  : '')),
                      readOnly: true,
                      keyboardType: TextInputType.phone,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: widget.employee.dob.toString() ?? "1/1/2020",
                        labelText: 'DoB',
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton(
                      hint: Text("Gender"),
                      items: [
                        DropdownMenuItem(
                          child: Text('Male'),
                          value: 'Male',
                        ),
                        DropdownMenuItem(
                          child: Text('Female'),
                          value: 'Female',
                        ),
                        DropdownMenuItem(
                          child: Text('Other'),
                          value: 'Other',
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          widget.employee.gender = value;
                        });
                      },
                      value: widget.employee.gender,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              SwitchListTile(
                  value: widget.employee.fullNameAsStatedOnLicense ?? false,
                  title: Text('Full name as stated on License?'),
                  onChanged: (value) {
                    setState(() {
                      widget.employee.fullNameAsStatedOnLicense = value;
                    });
                  }),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        widget.employee.securityLicenseNo = value;
                      },
                      controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: widget.employee.securityLicenseNo ?? '')),
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Security license No',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: TextField(
                      onTap: () async {
                        widget.employee.expiryDate = await showDatePicker(
                          initialDatePickerMode: DatePickerMode.day,
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now().add(Duration(days: -20)),
                          lastDate: DateTime.now().add(Duration(days: 365 * 3)),
                        );
                        setState(() {});
                      },
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: widget.employee.expiryDate != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(widget.employee.expiryDate)
                                : ''),
                      ),
                      readOnly: true,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText:
                            widget.employee.expiryDate.toString() ?? "1/1/2020",
                        labelText: 'Expiry date',
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButton(
                      hint: Text('Position applied'),
                      items: [
                        DropdownMenuItem(
                          child: Text('Security Guard'),
                          value: 'Security Guard',
                        ),
                        DropdownMenuItem(
                          child: Text('Crowd Controller'),
                          value: 'Crowd Controller',
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          widget.employee.positionApplied = value;
                        });
                      },
                      value: widget.employee.positionApplied,
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: DropdownButton(
                      hint: Text('As'),
                      items: [
                        DropdownMenuItem(
                          child: Text('Full Time'),
                          value: 'Full Time',
                        ),
                        DropdownMenuItem(
                          child: Text('Part Time'),
                          value: 'Part Time',
                        ),
                        DropdownMenuItem(
                          child: Text('Casual'),
                          value: 'Casual',
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          widget.employee.asJob = value;
                        });
                      },
                      value: widget.employee.asJob,
                    ),
                  )
                ],
              ),
              MultiSelectFormField(
                titleText: 'Approved as ',

                dataSource: [
                  {"display": "Armed guard", "value": "Armed guard"},
                  {
                    "display": "Baton and handcuff",
                    "value": "Baton and handcuff"
                  },
                  {"display": "Body Guard", "value": "Body Guard"},
                  {"display": "Cash IN Transit", "value": "Cash IN Transit"},
                  {"display": "Control room", "value": "Control room"},
                  {"display": "Crowd controller", "value": "Crowd controller"},
                  {
                    "display": "Guard with a dog ",
                    "value": "Guard with a dog "
                  },
                  {"display": "Investigator", "value": "Investigator"},
                  {
                    "display": "Monitoring Room Operator",
                    "value": "Monitoring Room Operator"
                  },
                  {"display": "Security adviser", "value": "Security adviser"},
                  {"display": "Security guard", "value": "Security guard"},
                  {"display": "Security trainer", "value": "Security trainer"},
                  {"display": "Unarmed Guard", "value": "Unarmed Guard"},
                ],
                textField: 'display',
                valueField: 'value',
                okButtonLabel: 'OK',
                initialValue: widget.employee.approveAs,
                cancelButtonLabel: 'CANCEL',
                onSaved: (value) {
                  List<String> list = [];
                  for (var item in value) list.add(item);
                  setState(() {
                    widget.employee.approveAs = list;
                  });
                },
                // required: true,
                hintText: 'Please choose one or more',
              ),
              SwitchListTile(
                  title: Text('Are you citizen of Australia'),
                  value: widget.employee.areAustrlian ?? true,
                  onChanged: (value) {
                    setState(() {
                      widget.employee.areAustrlian = value;
                    });
                  }),
              SwitchListTile(
                value: widget.employee.convictedOfOffice ?? false,
                onChanged: (value) {
                  setState(() {
                    widget.employee.convictedOfOffice = value;
                  });
                },
                title: Text(
                    'Have you ever been convicted of an offence in Australia (not traffic Charges)?'),
              ),
              if (widget.employee.convictedOfOffice ?? false)
                TextField(
                  onChanged: (value) {
                    widget.employee.whenIfYes = value;
                  },
                  controller: TextEditingController.fromValue(
                      TextEditingValue(text: widget.employee.whenIfYes ?? '')),
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'When?',
                  ),
                ),
              if (widget.employee.convictedOfOffice ?? false)
                TextField(
                  onChanged: (value) {
                    widget.employee.explainIfYes = value;
                  },
                  controller: TextEditingController.fromValue(TextEditingValue(
                      text: widget.employee.explainIfYes ?? '')),
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Explain',
                  ),
                ),
              TextField(
                onChanged: (value) {
                  widget.employee.rate = double.parse(value);
                },
                controller: TextEditingController.fromValue(TextEditingValue(
                    text: (widget.employee.rate ?? 0.0).toString())),
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Flat rate',
                ),
              ),
              TextField(
                onChanged: (value) {
                  widget.employee.holiday = value;
                },
                controller: TextEditingController.fromValue(TextEditingValue(
                    text: (widget.employee.holiday ?? '').toString())),
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Public Holiday',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Bank Account',
                ),
                subtitle:
                    widget.employee.bankDetail != null ? Text('Verfied') : null,
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.to(BankDetailScreen(
                    employee: widget.employee,
                  ));
                },
              ),
              ListTile(
                title: Text(
                  'Questions',
                ),
                subtitle:
                    widget.employee.questions != null ? Text('Verfied') : null,
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.to(QuestionDetailsScreen(
                    employee: widget.employee,
                  ));
                },
              ),
              ListTile(
                title: Text(
                  'Documents',
                ),
                onTap: () {
                  Get.to(DocumentDetailScreen(
                    employee: widget.employee,
                  ));
                },
                subtitle: Text(widget.employee.documents != null
                    ? 'Verfied'
                    : 'Not Verfied'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              SizedBox(
                height: 8,
              ),
              Text(
                'Interviwer of application',
                textAlign: TextAlign.start,
              ),
              TextField(
                onChanged: (value) {
                  if (widget.employee.interviewer == null)
                    widget.employee.interviewer = Interviewer();
                  widget.employee.interviewer.name = value;
                },
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                      text: widget.employee.interviewer != null
                          ? widget.employee.interviewer.name
                          : ''),
                ),
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                onChanged: (value) {
                  if (widget.employee.interviewer == null)
                    widget.employee.interviewer = Interviewer();
                  widget.employee.interviewer.postion = value;
                  print(widget.employee.interviewer.postion);
                },
                controller: TextEditingController.fromValue(TextEditingValue(
                    text: widget.employee.interviewer != null
                        ? widget.employee.interviewer.postion
                        : '')),
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Position',
                ),
              ),
              TextField(
                onTap: () async {
                  if (widget.employee.interviewer == null)
                    widget.employee.interviewer = Interviewer();
                  widget.employee.interviewer.date = await showDatePicker(
                    initialDatePickerMode: DatePickerMode.day,
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().add(Duration(days: -20)),
                    lastDate: DateTime.now().add(Duration(days: 365 * 3)),
                  );
                  setState(() {});
                },
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                      text: widget.employee.interviewer != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(widget.employee.interviewer.date)
                          : ''),
                ),
                readOnly: true,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: widget.employee.interviewer != null
                      ? widget.employee.interviewer.date.toString()
                      : "1/1/2020",
                  labelText: 'Date',
                ),
              ),
              SizedBox(
                height: 36,
              ),
              Center(
                child: MaterialButton(
                  onPressed: () {
                    saveEmployee();
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
              ),
              SizedBox(
                height: 36,
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          printEmployee();
        },
        child: Icon(
          Icons.print,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
