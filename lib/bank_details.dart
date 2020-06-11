import 'package:flutter/material.dart';
import 'package:focus_security/employee.dart';

class BankDetailScreen extends StatefulWidget {
  final Employee employee;

  BankDetailScreen({this.employee});

  @override
  _BankDetailScreenState createState() => _BankDetailScreenState();
}

class _BankDetailScreenState extends State<BankDetailScreen> {
  @override
  void initState() {
    if (widget.employee.bankDetail == null)
      widget.employee.bankDetail = BankDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.employee.firstName} ${widget.employee.lastName}"),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  widget.employee.bankDetail.fullName = value;
                },
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                      text: widget.employee.bankDetail != null
                          ? widget.employee.bankDetail.fullName
                          : ''),
                ),
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Full name',
                ),
              ),
              TextField(
                onChanged: (value) {
                  widget.employee.bankDetail.bankName = value;
                },
                controller: TextEditingController.fromValue(TextEditingValue(
                    text: widget.employee.bankDetail != null
                        ? widget.employee.bankDetail.bankName
                        : '')),
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Bank',
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        widget.employee.bankDetail.superFund =
                            double.parse(value);
                      },
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: widget.employee.bankDetail != null
                                ? widget.employee.bankDetail.superFund
                                    .toString()
                                : ''),
                      ),
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Super fund',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        widget.employee.bankDetail.abn = value;
                      },
                      controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: widget.employee.bankDetail != null
                                  ? widget.employee.bankDetail.abn
                                  : '')),
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'abn',
                      ),
                    ),
                  )
                ],
              ),
              TextField(
                onChanged: (value) {
                  widget.employee.bankDetail.accountNo = value;
                },
                controller: TextEditingController.fromValue(TextEditingValue(
                    text: widget.employee.bankDetail != null
                        ? widget.employee.bankDetail.accountNo
                        : '')),
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Account No',
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    onChanged: (value) {
                      widget.employee.bankDetail.fullName = value;
                    },
                    controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: widget.employee.bankDetail != null
                                ? widget.employee.bankDetail.bsb
                                : '')),
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'BSB',
                    ),
                  )),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        widget.employee.bankDetail.taxFileNo = int.parse(value);
                      },
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: widget.employee.bankDetail != null
                                ? widget.employee.bankDetail.taxFileNo
                                    .toString()
                                : ''),
                      ),
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Tax file No',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 26,
              ),
              Text("Next of kin"),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        widget.employee.bankDetail.kinName = value;
                      },
                      controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: widget.employee.bankDetail != null
                                  ? widget.employee.bankDetail.kinName
                                  : '')),
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        widget.employee.bankDetail.relationship = value;
                      },
                      controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: widget.employee.bankDetail != null
                                  ? widget.employee.bankDetail.relationship
                                  : '')),
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Relationship',
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                onChanged: (value) {
                  widget.employee.bankDetail.kinAddress = value;
                },
                controller: TextEditingController.fromValue(TextEditingValue(
                    text: widget.employee.bankDetail != null
                        ? widget.employee.bankDetail.kinAddress
                        : '')),
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
              ),
              TextField(
                onChanged: (value) {
                  widget.employee.bankDetail.phone = value;
                },
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                      text: widget.employee.bankDetail != null
                          ? widget.employee.bankDetail.phone
                          : ''),
                ),
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Phone',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
