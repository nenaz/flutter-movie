import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<LoginPage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiomentrics;
  String _authorized = 'No authorized';
  bool _isAuthenticating = false;
  bool _isAvailableBiometricsButtonDisabled = true;
  bool _isAuthenticatingButtonDisabled = true;

  void initialState() {
    _isAvailableBiometricsButtonDisabled = _isAvailableBiometricsButtonDisabled;
    _isAuthenticatingButtonDisabled = _isAuthenticatingButtonDisabled;
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (error) {
      print(error);
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
      _isAvailableBiometricsButtonDisabled = false;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _availableBiomentrics = availableBiometrics;
      _isAuthenticatingButtonDisabled = false;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    const androidStrings = AndroidAuthMessages(
      cancelButton: 'Закрыть',
      goToSettingsButton: 'Настройки',
      goToSettingsDescription: 'Добавить отпечаток',
      signInTitle: 'Заголовок',
      fingerprintHint: 'Подсказка',
      fingerprintNotRecognized: 'Не рекогняйз',
      fingerprintRequiredTitle: 'Обязательный заголовок',
      fingerprintSuccess: 'Прошло хорошо',
    );
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
        localizedReason: 'Отсканируйте свой отпечаток пальца для входа',
        useErrorDialogs: false,
        stickyAuth: true,
        androidAuthStrings: androidStrings,
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'No authorized';
    setState(() {
      _authorized = message;
    });
    if (_authorized == 'Authorized') {
      Navigator.pushNamed(context, '/main-page');
    }
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Авторизация'),
      // ),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Container(
          // margin: const EdgeInsets.all(20),
          // elevation: 10,
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.red],
              ),
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Can check biometrics: $_canCheckBiometrics\n',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RaisedButton(
                  child: const Text('Check biomentrics'),
                  onPressed: _checkBiometrics,
                ),
                Text(
                  'available biomentrics: $_availableBiomentrics\n',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RaisedButton(
                  child: const Text('Get available biometrics'),
                  onPressed: _isAvailableBiometricsButtonDisabled
                    ? null
                    : _getAvailableBiometrics,
                  disabledColor: Colors.grey[300],
                ),
                Text(
                  'Current State: $_authorized\n',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RaisedButton(
                  child: Text(_isAuthenticating ? 'Cancel' : 'Authenticate'),
                  onPressed: _isAuthenticatingButtonDisabled
                    ? null
                    : _isAuthenticating
                        ? _cancelAuthentication
                        : _authenticate,
                  disabledColor: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
