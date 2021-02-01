import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {

  bool _isLoading = false;
  SharedPreferences sharedPreferences;
  String token = '';
  List<Result> data_results;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token')??'');
    });
    setState(() {
      _isLoading = true;
    });
    var response = await http.get(
        "https://mg-indonesia.co.id/api/v1/opname/2020-11-28/2020-11-28",
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json;',
        }
    );
    if(response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      if(body['version'] != null) {
        setState(() {
          _isLoading = false;
        });
        List<Result> results = List<Result>.from(body["result"][0].map((x) => Result.fromJson(x)));
        data_results = results;
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.lightBlueAccent,Colors.blue[200]],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView.builder(
          itemCount: data_results.length,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              title: Card(
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
                          "Area : "+data_results[index].area,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Category : "+data_results[index].category,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Name : "+data_results[index].name,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

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
      child: Text("List Data",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 30.0,
              fontWeight: FontWeight.bold)),
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
    title: Text('List Data'),
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

class resultData {
  String version;
  List<Result> result;

  resultData({this.version, this.result});

  resultData.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    if (json['result'][0] != null) {
      result = new List<Result>();
      json['result'][0].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    if (this.result != null) {
      data['result'][0] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  bool productUomId;
  int id;
  double productQtyCorrect;
  String area;
  String createDate;
  String category;
  String name;
  double productQty;
  String productId;

  Result(
      {this.productUomId,
        this.id,
        this.productQtyCorrect,
        this.area,
        this.createDate,
        this.category,
        this.name,
        this.productQty,
        this.productId});

  Result.fromJson(Map<String, dynamic> json) {
    // productUomId = json['product_uom_id'];
    id = json['id'];
    productQtyCorrect = json['product_qty_correct'];
    area = json['area'];
    createDate = json['create_date'];
    category = json['category'];
    name = json['name'];
    productQty = json['product_qty'];
    // productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_uom_id'] = this.productUomId;
    data['id'] = this.id;
    data['product_qty_correct'] = this.productQtyCorrect;
    data['area'] = this.area;
    data['create_date'] = this.createDate;
    data['category'] = this.category;
    data['name'] = this.name;
    data['product_qty'] = this.productQty;
    data['product_id'] = this.productId;
    return data;
  }
}