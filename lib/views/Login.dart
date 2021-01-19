

import 'package:desappega/models/UserApp.dart';
import 'package:desappega/utils/sign_in.dart';
import 'package:desappega/widgets/CustomButton.dart';
import 'package:desappega/widgets/CustomInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'Register.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //controlers
  TextEditingController _controllerEmail =
      TextEditingController();
  TextEditingController _controllerPassword =
      TextEditingController();


  _horizontalLine() => Container(height: 1.0, color: Colors.white);

  String _errorMessage = "";

  _validateFields() {
    //Recupera dados dos campos
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty) {
        setState(() {
          _errorMessage = "";
        });

        UserApp user = UserApp();
        user.email = email;
        user.password = password;

        _loginUser(user);
      } else {
        setState(() {
          _errorMessage = "Preencha a senha!";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Preencha o E-mail utilizando @";
      });
    }
  }

  _loginUser(UserApp user) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((firebaseUser) {
      //redireciona para página principal
      Navigator.pushReplacementNamed(context, "/");
    }).catchError((error) {
      setState(() {
        print("User " + user.email + user.password);
        print("erro app" + error.toString());
        _errorMessage =
            "Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          backgroundColor: (Color(0xff400101)),
        ),
        body: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            padding: EdgeInsets.all(16),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: SvgPicture.asset(
                        "images/logo.svg",
                        width: 200,
                        height: 150,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: CustomInput(
                        controller: _controllerEmail,
                        hint: "E-mail",
                        autofocus: true,
                        type: TextInputType.emailAddress,
                      ),
                    ),
                    CustomInput(
                        controller: _controllerPassword,
                        hint: "Senha",
                        obscure: true,
                        maxLines: 1),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: CustomButton(
                        text: "Entrar",
                        onPressed: () {
                          _validateFields();
                        },
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        child: Text(
                          "Não tem conta? cadastra-se!",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                      ),
                    ),
                    Center(
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(flex: 4, child: _horizontalLine()),
                        SizedBox(width: 16),
                        Flexible(
                          flex: 2,
                          child: Text(
                            "ou",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Flexible(flex: 4, child: _horizontalLine()),
                      ],
                    ),
                    SizedBox(height: 16),
                    _signInButton(),
                  ],
                ),
              ),
            )
        )
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.white,
      onPressed: () {
        signInWithGoogle().then((result) {
          if (result != null) {
            Navigator.pushReplacementNamed(context, "/");
          }
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        SvgPicture.asset("images/logo_google.svg", width: 20,
        height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Acessar com o Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}