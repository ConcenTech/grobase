import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/components/city_form_field.dart';
import '../../../core/utils/validators.dart';
import '../../../models/location.dart';

class NewSystemForm extends StatefulWidget {
  const NewSystemForm({super.key, required this.onSave});

  final void Function(String displayName, Location location) onSave;

  @override
  State<NewSystemForm> createState() => _NewSystemFormState();
}

class _NewSystemFormState extends State<NewSystemForm> {
  final _formKey = GlobalKey<FormState>();

  String? _systemName;
  Location? _systemLocation;

  void _save() {
    final form = _formKey.currentState!;

    if (!form.validate()) {
      return;
    }

    form.save();
    widget.onSave(_systemName!, _systemLocation!);
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
              const Text('Give your new system a name'),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'System name',
                  border: OutlineInputBorder(),
                ),
                validator: Validators.required,
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _systemName = value;
                },
              ),
              const Text('Where is your system located?'),
              CityFormField(
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                validator: Validators.required,
                textInputAction: TextInputAction.done,
                onSaved: (city) {
                  _systemLocation = Location.fromCity(city!);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Create System'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
