import 'package:desappega/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:desappega/models/UserApp.dart';
import 'package:desappega/widgets/CustomInput.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Controllers
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  String _errorMessage = "";

  _validateFields() {
    //Recupera dados dos campos
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (name.length >= 3) {
      if (email.isNotEmpty && email.contains("@")) {
        if (password.length >= 6 && password.length <= 10) {
          setState(() {
            _errorMessage = "";

            UserApp user = UserApp();

            user.name = name;
            user.email = email;
            user.password = password;

            _RegisterUser(user);
          });
        } else {
          setState(() {
            _errorMessage = "A senha deve ter entre 6 e 10 caracteres";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Preencha um e-mail válido";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Nome precisa ter mais de 3 caracteres";
      });
    }
  }

  //fazer o cadastro do usuário
  _RegisterUser(UserApp user) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((firebaseUser) {
      //redireciona para página principal
      Navigator.pushReplacementNamed(context, "/");
    }).catchError((error) {
      print("erro app: " + error.toString());
      setState(() {
        _errorMessage =
            "Erro ao cadastrar usuário, verifique os campos e tente novamente!";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
        backgroundColor: (Color(0xff400101)),
      ),
      body: Container(
          decoration: BoxDecoration(color: Color(0xffA61103)),
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                      "images/user.png",
                      width: 200,
                      height: 150,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CustomInput(
                      controller: _controllerName,
                      hint: "Nome",
                      autofocus: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: CustomInput(
                      controller: _controllerEmail,
                      hint: "E-mail",
                      type: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: CustomInput(
                      controller: _controllerPassword,
                      hint: "Senha",
                      obscure: true,
                        maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: CustomButton(
                      text: "Cadastrar",
                      onPressed: () {
                        _validateFields();
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
