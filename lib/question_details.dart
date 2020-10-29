import 'package:flutter/material.dart';
import 'package:focus_security/employee.dart';

class QuestionDetailsScreen extends StatefulWidget {
  final Employee employee;

  QuestionDetailsScreen({this.employee});

  @override
  _QuestionDetailsScreenState createState() => _QuestionDetailsScreenState();
}

class _QuestionDetailsScreenState extends State<QuestionDetailsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.employee.questions == null)
      widget.employee.questions = Questions();
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Verbal Skills',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: <Widget>[
                    RadioListTile(
                        value: "Average",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Average',
                        ),
                        groupValue: widget.employee.questions.verbalSkill,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.verbalSkill = values;
                          });
                        }),
                    RadioListTile(
                        value: "Good",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Good',
                        ),
                        groupValue: widget.employee.questions.verbalSkill,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.verbalSkill = values;
                          });
                        }),
                    RadioListTile(
                        value: "Very Good",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Very Good',
                        ),
                        groupValue: widget.employee.questions.verbalSkill,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.verbalSkill = values;
                          });
                        }),
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: 8,
              ),
              Text(
                "Listening",
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: <Widget>[
                    RadioListTile(
                        value: "Average",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Average',
                        ),
                        groupValue: widget.employee.questions.listening,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.listening = values;
                          });
                        }),
                    RadioListTile(
                        value: "Good",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Good',
                        ),
                        groupValue: widget.employee.questions.listening,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.listening = values;
                          });
                        }),
                    RadioListTile(
                        value: "Very Good",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Very Good',
                        ),
                        groupValue: widget.employee.questions.listening,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.listening = values;
                          });
                        }),
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: 8,
              ),
              Text(
                "Knowlodge",
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: <Widget>[
                    RadioListTile(
                        value: "Average",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Average',
                        ),
                        groupValue: widget.employee.questions.knowledge,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.knowledge = values;
                          });
                        }),
                    RadioListTile(
                        value: "Good",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Good',
                        ),
                        groupValue: widget.employee.questions.knowledge,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.knowledge = values;
                          });
                        }),
                    RadioListTile(
                        value: "Very Good",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Very Good',
                        ),
                        groupValue: widget.employee.questions.knowledge,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.knowledge = values;
                          });
                        }),
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: 8,
              ),
              Text(
                "Speaking",
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: <Widget>[
                    RadioListTile(
                        value: "Average",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Average',
                        ),
                        groupValue: widget.employee.questions.speaking,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.speaking = values;
                          });
                        }),
                    RadioListTile(
                        value: "Good",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Good',
                        ),
                        groupValue: widget.employee.questions.speaking,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.speaking = values;
                          });
                        }),
                    RadioListTile(
                        value: "Very Good",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Very Good',
                        ),
                        groupValue: widget.employee.questions.speaking,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.speaking = values;
                          });
                        }),
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: 8,
              ),
              Text(
                "Reading",
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: <Widget>[
                    RadioListTile(
                        value: "Average",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Average',
                        ),
                        groupValue: widget.employee.questions.reading,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.reading = values;
                          });
                        }),
                    RadioListTile(
                        value: "Good",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Good',
                        ),
                        groupValue: widget.employee.questions.reading,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.reading = values;
                          });
                        }),
                    RadioListTile(
                        value: "Very Good",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Very Good',
                        ),
                        groupValue: widget.employee.questions.reading,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.reading = values;
                          });
                        }),
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: 8,
              ),
              Text(
                "Writing",
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: <Widget>[
                    RadioListTile(
                        value: "Average",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Average',
                        ),
                        groupValue: widget.employee.questions.writing,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.writing = values;
                          });
                        }),
                    RadioListTile(
                        value: "Good",
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          'Good',
                        ),
                        groupValue: widget.employee.questions.writing,
                        onChanged: (values) {
                          setState(() {
                            widget.employee.questions.writing = values;
                          });
                        }),
                    RadioListTile(
                      value: "Very Good",
                      dense: true,
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Text(
                        'Very Good',
                      ),
                      groupValue: widget.employee.questions.writing,
                      onChanged: (values) {
                        setState(() {
                          widget.employee.questions.writing = values;
                        });
                      },
                    ),
                  ],
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "what is your ABN number ",
                ),
                initialValue: widget.employee.questions.abn ?? "",
                onChanged: (value) {
                  widget.employee.questions.abn = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "What is your tax file number",
                ),
                initialValue: widget.employee.questions.taxFileNo ?? "",
                onChanged: (value) {
                  widget.employee.questions.taxFileNo = value;
                },
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "Do you have a valid drivers license ?",
                style: Theme.of(context).textTheme.headline6,
              ),
              RadioListTile(
                value: "Yes",
                dense: true,
                controlAffinity: ListTileControlAffinity.trailing,
                title: Text(
                  'Yes',
                ),
                groupValue: widget.employee.questions.validLicense,
                onChanged: (values) {
                  setState(() {
                    widget.employee.questions.validLicense = values;
                  });
                },
              ),
              RadioListTile(
                value: "NO",
                dense: true,
                controlAffinity: ListTileControlAffinity.trailing,
                title: Text(
                  'No',
                ),
                groupValue: widget.employee.questions.validLicense,
                onChanged: (values) {
                  setState(() {
                    widget.employee.questions.validLicense = values;
                  });
                },
              ),
              Text(
                "Who to contact in case of emergency",
                style: Theme.of(context).textTheme.headline6,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                ),
                initialValue: widget.employee.questions.emergency?.name ?? "",
                onChanged: (value) {
                  widget.employee.questions.emergency.name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Relationship",
                ),
                initialValue:
                    widget.employee.questions.emergency?.relationship ?? "",
                onChanged: (value) {
                  widget.employee.questions.emergency.relationship = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Contact number",
                ),
                initialValue:
                    widget.employee.questions.emergency?.contactNumber ?? "",
                onChanged: (value) {
                  widget.employee.questions.emergency.contactNumber = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
