import 'package:flutter/material.dart';
import 'package:wellmeadows_hospital/controller/app_controller.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}
class _LoginscreenState extends State<Loginscreen> {
  TextEditingController _idC = TextEditingController();
  TextEditingController _passwordC = TextEditingController();
  String errorMsg = "";
  bool isAnyError=false;
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var width=size.width;
    var hight=size.height;


    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Image.asset('assets/logo.png'),
                height: 200,
                width: 300,
              ),
            ],
          ),
          Text(
            'Login',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 50),
          SizedBox(
            width: 250,
            child: TextField(
              controller: _idC,
              decoration: InputDecoration(
                hintText: 'Enter Your staff id',
                label: Text('id'),
                // labelText: 'id'
                border: OutlineInputBorder(
                  // borderRadius:
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          SizedBox(
            width: 250,
            child: TextField(
              controller: _passwordC,
              decoration: InputDecoration(
                hintText: 'Enter Your Password',
                label: Text('password'),
                border: OutlineInputBorder(
                  // borderRadius:
                ),
              ),
            ),
          ),
          if (isAnyError && errorMsg.isNotEmpty) SizedBox(height: 15),
          if (isAnyError && errorMsg.isNotEmpty)
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.red,
              child: Text(
                errorMsg,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          SizedBox(height: 15),
          SizedBox(
            width: 150,
            child: FloatingActionButton(child: Text('Login'), onPressed: () async {
                // handle login behavoiur
              int? id=int.tryParse(_idC.text);
              if(_idC.text.isEmpty || _passwordC.text.isEmpty)
                {
                  errorMsg="Please Fill All Fields";
                  isAnyError=true;
                  setState(() {
                  });
                }
              else if(id==null){
                errorMsg="Id Should be Number";
                isAnyError=true;
                setState(() {
                });
              }
              var passwordOf = await AppController.getPasswordOf(id: id!);
              print(passwordOf);
              if(passwordOf==null){
                errorMsg="Id Does Not Exists";
                isAnyError=true;
                setState(() {
                });
              }else if(_passwordC.text.compareTo(passwordOf)!=0)
              {
                errorMsg="Password is Wrongg";
                isAnyError=true;
                setState(() {
                });
              }else if(id==1){
                AppController.setWhoIsLoggedIn(id);
                Navigator.pushReplacementNamed(context, '/directorDashboard');
              }else{
                String str=await AppController.getRouteFromLoginToWhere(id);
                print(str);
                AppController.setWhoIsLoggedIn(id);
                Navigator.pushReplacementNamed(context, str);
              }
            }),
          ),
        ],
      ),
      bottomSheet: Text('Developed By Mudassir'),
    );
  }
}
