/*import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _mobileNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Your App Name'),
      ),
      body: SingleChildScrollView(
        padding:const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(
                child:Icon(
                  Icons.account_circle,
                  size: 100.0,
                ),
              ),
              const SizedBox(height: 20.0),


              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration:const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email address.';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 10.0),


              TextFormField(
                obscureText: true,
                decoration:const  InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password.';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 10.0),

              TextFormField(
                keyboardType: TextInputType.phone,
                decoration:const InputDecoration(
                  labelText: 'Mobile Number (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                onSaved: (value) => _mobileNumber = value!,
              ),
              const SizedBox(height: 20.0),


              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    debugPrint('Email: $_email, Password: $_password, Mobile: $_mobileNumber');

                  }
                },
                child:const  Text('Login'),
              ),
              const SizedBox(height: 20.0),

              const Divider(thickness: 2.0),
              const SizedBox(height: 20.0),

              ElevatedButton.icon(
                onPressed: () {
                  debugPrint(' pom pom ');
                },
                icon:const Icon(Icons.gpp_bad_outlined),
                label:const Text('Continue with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
              const SizedBox(height: 10.0),

              ElevatedButton.icon(
                onPressed: () {
                  debugPrint('pom pmo pom ');
                },
                icon:const Icon(Icons.facebook),
                label:const Text('Continue with Facebook'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/