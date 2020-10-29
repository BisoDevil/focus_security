import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focus_security/add_venue.dart';
import 'package:focus_security/venue.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class VenueScreen extends StatefulWidget {
  @override
  _VenueScreenState createState() => _VenueScreenState();
}

class _VenueScreenState extends State<VenueScreen> {
  String searchText = '';
  List<Venue> allEmps = [];

  printEmployees() async {
    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Table(children: [
            pw.TableRow(children: [
              pw.Text('ID'),
              pw.Text('Name'),
              pw.Text('Date'),
              pw.Text('Fare'),
              pw.Text('Notes'),
            ]),
            for (var item in allEmps)
              pw.TableRow(children: [
                pw.Text('${item.id}'),
                pw.Text("${item.name}"),
                pw.Text('${DateFormat('dd/MM/yyyy').format(item.date)}'),
                pw.Text('${item.fare}'),
                pw.Text('${item.note}'),
              ])
          ]); // Center
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        children: <Widget>[
          Spacer(),
          FloatingActionButton(
            heroTag: 'add_venue',
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
            heroTag: 'print',
            onPressed: () {
              Get.to(
                AddVenue(
                  venue:
                      Venue(name: '', date: DateTime.now(), file: '', note: ''),
                ),
              );
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
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
                labelText: 'Search for Venue',
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Venues').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: Text('Loading...'));
                    default:
                      allEmps.clear();
                      for (var item in snapshot.data.docs) {
                        allEmps.add(Venue.fromJson(item.data()));
                      }
                      List<Venue> filtered = allEmps
                          .where((element) =>
                              element.name
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase()) ||
                              DateFormat('dd/MM/yyyy')
                                  .format(element.date)
                                  .contains(searchText))
                          .toList();
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          Venue venue = filtered[index];
                          return ListTile(
                            title: Text("${venue.name}"),
                            subtitle: Text(
                                "${DateFormat('dd/MM/yyyy').format(venue.date)}"),
                            onTap: () {
                              Get.to(AddVenue(venue: venue));
                            },
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
    );
  }
}
