import 'package:flutter/material.dart';
import 'package:jobable_dpbo_final_project/Components/button.dart';
import 'package:jobable_dpbo_final_project/Components/colors.dart';
import 'package:jobable_dpbo_final_project/Components/textfield.dart';
import 'package:jobable_dpbo_final_project/JSON/users.dart';
import 'package:jobable_dpbo_final_project/Views/login.dart';

import '../SQLite/database_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  //Controllers
  final fullName = TextEditingController();
  final email = TextEditingController();
  final usrName = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final db = DatabaseHelper();
  signUp()async{
    var res = await db.createUser(Users(fullName: fullName.text,email: email.text,usrName: usrName.text, password: password.text));
    if(res>0){
      if(!mounted)return;
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               const Padding(
                 padding: EdgeInsets.symmetric(horizontal: 20),
                 child: Text("Register New Account",style: TextStyle(color: primaryColor,fontSize: 55,fontWeight: FontWeight.bold),),
               ),

                const SizedBox(height: 20),
                InputField(hint: "Full name", icon: Icons.person, controller: fullName, decoration: const InputDecoration(),),
                InputField(hint: "Email", icon: Icons.email, controller: email, decoration: const InputDecoration(),),
                InputField(hint: "Username", icon: Icons.account_circle, controller: usrName, decoration: const InputDecoration(),),
                InputField(hint: "Password", icon: Icons.lock, controller: password,passwordInvisible: true, decoration: const InputDecoration(),),
                InputField(hint: "Re-enter password", icon: Icons.lock, controller: confirmPassword,passwordInvisible: true, decoration: const InputDecoration(),),

                const SizedBox(height: 10),
                Button(label: "SIGN UP", press: (){
                  signUp();
                }),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?",style: TextStyle(color: Colors.grey),),
                    TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                        },
                        child: const Text("LOGIN"))
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}