import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:task/view/moviesList.dart';

enum authmode { Signup, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  authmode _authmode = authmode.Login;
  // Map<String, String> _authData = {
  //   'email': '',
  //   'password': '',
  // };
  var _isLoading = false;

  Future<void> _submit() async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    final file = File('${directory.path}/info.json');
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_authmode == authmode.Login) {
      final res = await file.readAsString();
      Map<String, dynamic> res_map = json.decode(res);
      print(res_map);

      if (res_map.values.isNotEmpty) {
        if (_nameController.text == res_map['email'] &&
            _passwordController.text == res_map['password']) {
          print('inside if, email pass matched succesfuly');
          print(res_map['email']);
          print(res_map['password']);
          setState(() {
            _isLoading = false;
          });

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieList()),
          );
        } else {
          print('not  matched/////////////');
        }
      } else {
        print('values not present-----');
      }
      // Log user in
      //check if credentials match with saved data

      // if(_nameController.text == re5

    } else {
      // Sign user up
      // save data in json format
      Map<String, String> _userdata = {
        'email': _nameController.text,
        'password': _passwordController.text,
      };
      print(_userdata);
      file.writeAsString(json.encode(_userdata));

      // await Provider.of<Auth>(context, listen: false).signup(
      //   _authData['email'],
      //   _authData['password'],
      // );
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchauthmode() {
    if (_authmode == authmode.Login) {
      setState(() {
        _authmode = authmode.Signup;
      });
    } else {
      setState(() {
        _authmode = authmode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: deviceSize.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                // width: deviceSize.width,
                margin: EdgeInsets.only(top: 100, bottom: 50),
                child: Text(
                  _authmode == authmode.Login ? 'LOGIN' : 'SIGNUP',
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 24,
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 8.0,
                child: Container(
                  height: _authmode == authmode.Signup ? 320 : 260,
                  constraints: BoxConstraints(
                      minHeight: _authmode == authmode.Signup ? 320 : 260),
                  width: deviceSize.width * 0.75,
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: 'E-Mail'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty || value.contains('@')) {
                                return 'Invalid email!';
                              }
                            },
                            // onSaved: (value) {
                            //   _authData['email'] = value!;
                            // },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 5) {
                                return 'Password is too short!';
                              }
                            },
                            // onSaved: (value) {
                            //   _authData['password'] = value!;
                            // },
                          ),
                          if (_authmode == authmode.Signup)
                            TextFormField(
                              enabled: _authmode == authmode.Signup,
                              decoration: InputDecoration(
                                  labelText: 'Confirm Password'),
                              obscureText: true,
                              validator: _authmode == authmode.Signup
                                  ? (value) {
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match!';
                                      }
                                    }
                                  : null,
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          if (_isLoading)
                            CircularProgressIndicator()
                          else
                            RaisedButton(
                              child: Text(_authmode == authmode.Login
                                  ? 'LOGIN'
                                  : 'SIGN UP'),
                              onPressed: _submit,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 8.0),
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context)
                                  .primaryTextTheme
                                  .button!
                                  .color,
                            ),
                          FlatButton(
                            child: Text(
                                '${_authmode == authmode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                            onPressed: _switchauthmode,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 4),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            textColor: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey.shade100,
    );
  }
}
