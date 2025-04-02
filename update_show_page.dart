import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../config/api_config.dart';
import 'package:http/http.dart' as http;

class UpdateShowPage extends StatefulWidget {
  final Map<String, dynamic> show;

  const UpdateShowPage({super.key, required this.show});

  @override
  _UpdateShowPageState createState() => _UpdateShowPageState();
}

class _UpdateShowPageState extends State<UpdateShowPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _category;
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.show['title']);
    _descController = TextEditingController(text: widget.show['description']);
    _category = widget.show['category'];
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _updateShow() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${ApiConfig.showsEndpoint}/${widget.show['id']}'),
      )
        ..fields['title'] = _titleController.text
        ..fields['description'] = _descController.text
        ..fields['category'] = _category;

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', _imageFile!.path),
        );
      }

      final response = await request.send();
      
      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Retour avec succès
      } else {
        throw Exception('Échec de la mise à jour');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le Show')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _category,
                  items: ['movie', 'serie', 'anime'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _category = value!),
                  decoration: const InputDecoration(labelText: 'Catégorie'),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Titre'),
                  validator: (value) => value!.isEmpty ? 'Requis' : null,
                ),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                _imageFile != null
                    ? Image.file(_imageFile!, height: 150)
                    : widget.show['imageUrl'] != null
                        ? Image.network('${ApiConfig.baseUrl}${widget.show['imageUrl']}', height: 150)
                        : const Placeholder(height: 150),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Changer l\'image'),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _updateShow,
                        child: const Text('Enregistrer'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}