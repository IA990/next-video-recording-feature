import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/professional.dart';
import '../services/api_service.dart';

class AddProfessionalScreen extends StatefulWidget {
  const AddProfessionalScreen({Key? key}) : super(key: key);

  @override
  State<AddProfessionalScreen> createState() => _AddProfessionalScreenState();
}

class _AddProfessionalScreenState extends State<AddProfessionalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  String _name = '';
  String _type = '';
  String _phone = '';
  String _photoUrl = '';
  double? _latitude;
  double? _longitude;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photoUrl = pickedFile.path;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_latitude == null || _longitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter valid latitude and longitude')),
        );
        return;
      }

      final professional = Professional(
        name: _name,
        type: _type,
        phone: _phone,
        location: '',
        photoUrl: _photoUrl,
        latitude: _latitude!,
        longitude: _longitude!,
      );

      try {
        await ApiService.createProfessional(professional);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Professional added successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add professional: \$e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Professional'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value ?? '',
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Type'),
                onSaved: (value) => _type = value ?? '',
                validator: (value) => value == null || value.isEmpty ? 'Please enter a type' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _phone = value ?? '',
                validator: (value) => value == null || value.isEmpty ? 'Please enter a phone number' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _photoUrl.isEmpty
                      ? const Text('No image selected.')
                      : Image.file(
                          File(_photoUrl),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _latitude = double.tryParse(value ?? ''),
                validator: (value) => value == null || double.tryParse(value) == null ? 'Enter valid latitude' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _longitude = double.tryParse(value ?? ''),
                validator: (value) => value == null || double.tryParse(value) == null ? 'Enter valid longitude' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
