import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataPage2 extends StatefulWidget {
  @override
  _DataPage2State createState() => _DataPage2State();
}

class _DataPage2State extends State<DataPage2> {

  bool _isLoading = false;
  SharedPreferences sharedPreferences;
  String token = '';

  @override
  void initState() {
    super.initState();
    getState();
  }

  getState() async {
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.grey,Colors.blue[200]],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            headerSection(),
            getData(token),
            dataSection(),
          ],
        ),
      ),
    );
  }

  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  getData(token) async {
    showAlertDialog(context, token);
    var response = await http.get(
        "https://mg-indonesia.co.id/api/v1/opname/2020-11-26/2020-11-26",
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json;',
        }
    );
    // if(response.statusCode == 200) {
    //   final Map body = json.decode(response.body);
    //   if(body['result'] == null) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //     showAlertDialog(context, "Something wrong ..");
    //   }
    //   if(body['version'] != null) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //     final res_data = Welcome.fromJson(body);
    //     showAlertDialog(context, res_data.version);
    //   }
    // }
    // else {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   print(response.body);
    // }
  }

  Container dataSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(20.0),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Login Form",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.email,
                    color: Colors.pink[200],
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.pinkAccent,
                    ),
                  ),
                  labelText: "Email: ",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.security,
                    color: Colors.pink[200],
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.pinkAccent,
                    ),
                  ),
                  labelText: "Password: ",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 5, right: 15.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      alignment: Alignment.center,
      child: Text("Data Page",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 30.0,
              fontWeight: FontWeight.bold)
      ),
    );
  }
}

showAlertDialog(BuildContext context, String text) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text('Title'),
    content: Text(text),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class Welcome {
  Welcome({
    this.version,
    this.result,
  });

  String version;
  List<dynamic> result;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    version: json["version"],
    result: List<dynamic>.from(json["result"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "version": version,
    "result": List<dynamic>.from(result.map((x) => x)),
  };
}

class ResultClass {
  ResultClass({
    this.productUomId,
    this.id,
    this.productQtyCorrect,
    this.area,
    this.createDate,
    this.category,
    this.name,
    this.productQty,
    this.productId,
  });

  String productUomId;
  int id;
  int productQtyCorrect;
  String area;
  DateTime createDate;
  String category;
  String name;
  double productQty;
  String productId;

  factory ResultClass.fromJson(Map<String, dynamic> json) => ResultClass(
    productUomId: json["product_uom_id"],
    id: json["id"],
    productQtyCorrect: json["product_qty_correct"],
    area: json["area"],
    createDate: DateTime.parse(json["create_date"]),
    category: json["category"],
    name: json["name"],
    productQty: json["product_qty"].toDouble(),
    productId: json["product_id"],
  );

  Map<String, dynamic> toJson() => {
    "product_uom_id": productUomId,
    "id": id,
    "product_qty_correct": productQtyCorrect,
    "area": area,
    "create_date": createDate.toIso8601String(),
    "category": category,
    "name": name,
    "product_qty": productQty,
    "product_id": productId,
  };
}
