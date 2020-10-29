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

class LicenseScreen extends StatelessWidget {
  final List<Employee> list = [];

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
            for (var item in list)
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          printEmployees();
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.print,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Employees').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: Text('Loading...'));
            default:
              list.clear();
              for (var item in snapshot.data.docs) {
                Employee employee = Employee.fromJson(item.data());
                if (employee.expiryDate != null) {
                  if (employee.expiryDate.difference(DateTime.now()).inDays <=
                      30) {
                    list.add(employee);
                  }
                }
              }
              return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  Employee employee = list[index];
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
                          : CachedNetworkImageProvider(employee.imageUrl),
                      radius: 30,
                    ),
                    title: Text("${employee.firstName} ${employee.lastName}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(employee.phone ?? ''),
                        Text(
                            "After: ${(employee.expiryDate.difference(DateTime.now()).inDays)} day(s)"),
                      ],
                    ),
                    isThreeLine: true,
                  );
                },
                itemCount: list.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
              );
          }
        },
      ),
    );
  }
}
