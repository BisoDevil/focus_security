import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focus_security/add_employee.dart';
import 'package:focus_security/employee.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = '';

  List<Employee> allEmps = [];

  printEmployees() async {
    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Table(children: [
            pw.TableRow(children: [
              pw.Text('ID'),
              pw.Text('Name'),
              pw.Text('Phone'),
              pw.Text('address'),
              pw.Text('Dob'),
              pw.Text('Gender'),
              pw.Text('Age'),
              pw.Text('Expiry')
            ]),
            for (var item in allEmps)
              pw.TableRow(children: [
                pw.Text('${item.id}'),
                pw.Text("${item.firstName} ${item.lastName}"),
                pw.Text("${item.phone}"),
                pw.Text("${item.address}"),
                pw.Text('${DateFormat('dd/MM/yyyy').format(item.dob)}'),
                pw.Text('${item.gender}'),
                pw.Text('${item.age}'),
                pw.Text('${DateFormat('dd/MM/yyyy').format(item.expiryDate)}'),
              ])
          ]); // Center
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Search for employee',
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Employees')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: Text('Loading...'));
                    default:
                      this.allEmps.clear();
                      for (var item in snapshot.data.docs) {
                        allEmps.add(Employee.fromJson(item.data()));
                      }
                      List<Employee> filtered = allEmps
                          .where((element) =>
                              "${element.firstName} ${element.middleName} ${element.lastName}"
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase()))
                          .toList();
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          Employee employee = filtered[index];
                          return ListTile(
                            onTap: () {
                              Get.to(AddEmployee(
                                employee: employee,
                              ));
                            },
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              backgroundImage: employee.imageUrl == null
                                  ? AssetImage('assets/images/logo.png')
                                  : CachedNetworkImageProvider(
                                      employee.imageUrl),
                              radius: 30,
                            ),
                            title: Text(
                                "${employee.firstName} ${employee.lastName}"),
                            subtitle: Text(employee.phone ?? ""),
                          );
                        },
                        itemCount: filtered.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                      );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        children: <Widget>[
          Spacer(),
          FloatingActionButton(
            heroTag: 'print',
            onPressed: () {
              printEmployees();
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.print,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () {
              Get.to(AddEmployee(
                employee: Employee(),
              ));
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
