import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/utils/validators.dart';

class WifiCredentialsForm extends StatefulWidget {
  const WifiCredentialsForm({super.key, required this.onSave});

  final void Function(String ssid, String password) onSave;

  @override
  State<WifiCredentialsForm> createState() => _WifiCredentialsFormState();
}

class _WifiCredentialsFormState extends State<WifiCredentialsForm> {
  final _formKey = GlobalKey<FormState>();

  String? _ssid;
  String? _password;

  void _save() {
    final form = _formKey.currentState!;

    if (!form.validate()) {
      return;
    }

    form.save();
    widget.onSave(_ssid!, _password!);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 24,
          bottom: max(MediaQuery.of(context).viewInsets.bottom, 16),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: [
              const Text(
                'Please enter your WiFi credentials to connect your '
                'new system.',
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'SSID',
                  border: OutlineInputBorder(),
                ),
                validator: Validators.required,
                textInputAction: TextInputAction.next,
                onSaved: (value) => _ssid = value,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: Validators.required,
                textInputAction: TextInputAction.done,
                obscureText: true,
                onSaved: (value) => _password = value,
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _save, child: const Text('Connect')),
            ],
          ),
        ),
      ),
    );
  }
}
