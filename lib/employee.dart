// To parse this JSON data, do
//
//     final employee = employeeFromJson(jsonString);

import 'dart:convert';

Employee employeeFromJson(String str) => Employee.fromJson(json.decode(str));

String employeeToJson(Employee data) => json.encode(data.toJson());

class Employee {
  String id;
  DateTime dob;
  List<Documents> documents;
  String whenIfYes = '';
  String explainIfYes = '';
  bool areAustrlian = true;
  BankDetail bankDetail = BankDetail();
  String city = '';
  Interviewer interviewer = Interviewer();
  bool fullNameAsStatedOnLicense = true;
  String imageUrl = '';
  Questions questions;
  String state = '';
  String gender = '';
  String asJob = '';
  String securityLicenseNo = '';
  String phone = '';
  String middleName = '';
  String firstName = '';
  String positionApplied = '';
  int postalCode = 0;
  int age = 0;
  DateTime expiryDate;
  List<dynamic> approveAs = [];
  String lastName = '';
  String address = '';
  bool convictedOfOffice = false;
  double rate;
  String holiday;

  Employee({
    this.dob,
    this.id,
    this.documents,
    this.whenIfYes,
    this.explainIfYes,
    this.areAustrlian,
    this.bankDetail,
    this.city,
    this.interviewer,
    this.fullNameAsStatedOnLicense,
    this.imageUrl,
    this.questions,
    this.state,
    this.gender,
    this.asJob,
    this.rate,
    this.securityLicenseNo,
    this.phone,
    this.middleName,
    this.firstName,
    this.holiday,
    this.positionApplied,
    this.postalCode,
    this.age,
    this.expiryDate,
    this.approveAs,
    this.lastName,
    this.address,
    this.convictedOfOffice,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        id: json["id"],
        documents: json["documents"] == null
            ? null
            : List<Documents>.from(
                json["documents"].map((x) => Documents.fromJson(x))),
        whenIfYes: json["whenIfYes"] == null ? null : json["whenIfYes"],
        explainIfYes:
            json["explainIfYes"] == null ? null : json["explainIfYes"],
        areAustrlian:
            json["areAustrlian"] == null ? null : json["areAustrlian"],
        bankDetail: json["bankDetail"] == null
            ? null
            : BankDetail.fromJson(json["bankDetail"]),
        city: json["city"] == null ? null : json["city"],
        interviewer: json["interviewer"] == null
            ? null
            : Interviewer.fromJson(json["interviewer"]),
        fullNameAsStatedOnLicense: json["fullNameAsStatedOnLicense"] == null
            ? null
            : json["fullNameAsStatedOnLicense"],
        imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
        questions: json["questions"] == null
            ? null
            : Questions.fromJson(json["questions"]),
        state: json["state"] == null ? null : json["state"],
        gender: json["gender"] == null ? null : json["gender"],
        asJob: json["asJob"] == null ? null : json["asJob"],
        securityLicenseNo: json["securityLicenseNo"] == null
            ? null
            : json["securityLicenseNo"],
        phone: json["phone"] == null ? null : json["phone"],
        middleName: json["middleName"] == null ? null : json["middleName"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        positionApplied:
            json["positionApplied"] == null ? null : json["positionApplied"],
        postalCode: json["postalCode"] == null ? null : json["postalCode"],
        age: json["age"] == null ? null : json["age"],
        expiryDate: json["expiryDate"] == null
            ? null
            : DateTime.parse(json["expiryDate"]),
        approveAs: json["approveAs"] == null ? null : json["approveAs"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        address: json["address"] == null ? null : json["address"],
        rate: json["rate"] == null ? null : json["rate"],
        holiday: json["holiday"] == null ? null : json["holiday"],
        convictedOfOffice: json["convictedOfOffice"] == null
            ? null
            : json["convictedOfOffice"],
      );

  Map<String, dynamic> toJson() => {
        "dob": dob == null ? null : dob.toIso8601String(),
        "documents": documents == null
            ? null
            : List<dynamic>.from(documents.map((x) => x.toJson())),
        "whenIfYes": whenIfYes == null ? null : whenIfYes,
        "explainIfYes": explainIfYes == null ? null : explainIfYes,
        "areAustrlian": areAustrlian == null ? null : areAustrlian,
        "bankDetail": bankDetail == null ? null : bankDetail.toJson(),
        "city": city == null ? null : city,
        "interviewer": interviewer == null ? null : interviewer.toJson(),
        "id": id,
        "fullNameAsStatedOnLicense": fullNameAsStatedOnLicense == null
            ? null
            : fullNameAsStatedOnLicense,
        "imageUrl": imageUrl == null ? null : imageUrl,
        "questions": questions == null ? null : questions.toJson(),
        "state": state == null ? null : state,
        "gender": gender == null ? null : gender,
        "asJob": asJob == null ? null : asJob,
        "securityLicenseNo":
            securityLicenseNo == null ? null : securityLicenseNo,
        "phone": phone == null ? null : phone,
        "middleName": middleName == null ? null : middleName,
        "firstName": firstName == null ? null : firstName,
        "positionApplied": positionApplied == null ? null : positionApplied,
        "postalCode": postalCode == null ? null : postalCode,
        "age": age == null ? null : age,
        "expiryDate": expiryDate == null ? null : expiryDate.toIso8601String(),
        "approveAs": approveAs == null ? null : approveAs,
        "lastName": lastName == null ? null : lastName,
        "address": address == null ? null : address,
        "rate": rate == null ? null : rate,
        "holiday": holiday == null ? null : holiday,
        "convictedOfOffice":
            convictedOfOffice == null ? null : convictedOfOffice,
      };
}

class BankDetail {
  String phone = '';
  String kinName = '';
  String bankName = '';
  String accountNo = '';
  double superFund = 0.0;
  String fullName = ' ';
  String kinAddress = '';
  String bsb = '';
  String relationship = '';
  int taxFileNo = 0;
  String abn = '';

  BankDetail({
    this.phone = '',
    this.kinName = '',
    this.bankName = '',
    this.accountNo = '',
    this.superFund = 0.0,
    this.fullName = '',
    this.kinAddress = '',
    this.bsb = '',
    this.relationship = '',
    this.taxFileNo = 0,
    this.abn = '',
  });

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
        phone: json["phone"] == null ? null : json["phone"],
        kinName: json["kinName"] == null ? null : json["kinName"],
        bankName: json["bankName"] == null ? null : json["bankName"],
        accountNo: json["accountNo"] == null ? null : json["accountNo"],
        superFund:
            json["superFund"] == null ? null : json["superFund"].toDouble(),
        fullName: json["fullName"] == null ? null : json["fullName"],
        kinAddress: json["kinAddress"] == null ? null : json["kinAddress"],
        bsb: json["bsb"] == null ? null : json["bsb"],
        relationship:
            json["relationship"] == null ? null : json["relationship"],
        taxFileNo: json["taxFileNo"] == null ? null : json["taxFileNo"],
        abn: json["abn"] == null ? null : json["abn"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone == null ? null : phone,
        "kinName": kinName == null ? null : kinName,
        "bankName": bankName == null ? null : bankName,
        "accountNo": accountNo == null ? null : accountNo,
        "superFund": superFund == null ? null : superFund,
        "fullName": fullName == null ? null : fullName,
        "kinAddress": kinAddress == null ? null : kinAddress,
        "bsb": bsb == null ? null : bsb,
        "relationship": relationship == null ? null : relationship,
        "taxFileNo": taxFileNo == null ? null : taxFileNo,
        "abn": abn == null ? null : abn,
      };
}

class Documents {
  String fileUrl = '';
  String kind = '';

  Documents({
    this.fileUrl,
    this.kind,
  });

  factory Documents.fromJson(Map<String, dynamic> json) => Documents(
        fileUrl: json["fileUrl"] == null ? null : json["fileUrl"],
        kind: json["kind"] == null ? null : json["kind"],
      );

  Map<String, dynamic> toJson() => {
        "fileUrl": fileUrl == null ? null : fileUrl,
        "kind": kind == null ? null : kind,
      };
}

class Interviewer {
  DateTime date;
  String name = '';
  String postion = '';

  Interviewer({
    this.date,
    this.name,
    this.postion,
  });

  factory Interviewer.fromJson(Map<String, dynamic> json) => Interviewer(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        name: json["name"] == null ? null : json["name"],
        postion: json["postion"] == null ? null : json["postion"],
      );

  Map<String, dynamic> toJson() => {
        "date": date == null ? null : date.toIso8601String(),
        "name": name == null ? null : name,
        "postion": postion == null ? null : postion,
      };
}

class Questions {
  String writing = '';
  String verbalSkill = '';
  String listening = '';
  String knowledge = '';
  String speaking = '';
  String reading = '';
  String emergencyContact = "";
  String taxFileNo = '';
  String abn = '';
  String validLicense = "";
  Emergency emergency = Emergency();

  Questions({
    this.writing = '',
    this.abn = "",
    this.emergency,
    this.verbalSkill = '',
    this.listening = '',
    this.taxFileNo = '',
    this.validLicense = '',
    this.emergencyContact = '',
    this.knowledge = '',
    this.speaking = '',
    this.reading = '',
  });

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
        writing: json["writing"] == null ? null : json["writing"],
        validLicense:
            json["validLicense"] == null ? null : json["validLicense"],
        verbalSkill: json["verbalSkill"] == null ? null : json["verbalSkill"],
        listening: json["listening"] == null ? null : json["listening"],
        knowledge: json["knowledge"] == null ? null : json["knowledge"],
        speaking: json["speaking"] == null ? null : json["speaking"],
        reading: json["reading"] == null ? null : json["reading"],
        abn: json["abn"] == null ? null : json["abn"],
        taxFileNo: json["taxFileNo"] == null ? null : json["taxFileNo"],
      );

  Map<String, dynamic> toJson() => {
        "writing": writing == null ? null : writing,
        "taxFileNo": taxFileNo == null ? null : taxFileNo,
        "verbalSkill": verbalSkill == null ? null : verbalSkill,
        "validLicense": validLicense == null ? null : validLicense,
        "listening": listening == null ? null : listening,
        "knowledge": knowledge == null ? null : knowledge,
        "speaking": speaking == null ? null : speaking,
        "reading": reading == null ? null : reading,
        "abn": abn == null ? null : abn,
      };
}

class Emergency {
  Emergency({
    this.name = "",
    this.relationship = "",
    this.contactNumber = "",
  });

  String name;
  String relationship;
  String contactNumber;

  factory Emergency.fromJson(Map<String, dynamic> json) => Emergency(
        name: json["name"] == null ? null : json["name"],
        relationship:
            json["relationship"] == null ? null : json["relationship"],
        contactNumber:
            json["contact_number"] == null ? null : json["contact_number"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "relationship": relationship == null ? null : relationship,
        "contact_number": contactNumber == null ? null : contactNumber,
      };
}
