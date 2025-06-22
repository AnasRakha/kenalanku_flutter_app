import 'package:flutter/material.dart';
import 'package:kenalanku/controllers/crud_services.dart';

class UpdateContact extends StatefulWidget {
  final String docID, name, phone, email;

  const UpdateContact({
    super.key,
    required this.docID,
    required this.name,
    required this.phone,
    required this.email,
  });

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    super.initState();
  }

  void _updateContact() {
    if (_formKey.currentState!.validate()) {
      CRUDServices().updateContact(
        docId: widget.docID,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Kontak berhasil diperbarui")));
      Navigator.pop(context);
    }
  }

  void _deleteContact() {
    CRUDServices().deleteContact(widget.docID);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Kontak berhasil dihapus")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Kontak")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                _nameController,
                "Nama",
                validator: (v) {
                  if (v == null || v.isEmpty) return "Nama tidak boleh kosong";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _phoneController,
                "Nomor Telepon",
                keyboard: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _emailController,
                "Email",
                keyboard: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateContact,
                  child: const Text("Perbarui", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _deleteContact,
                  child: const Text(
                    "Hapus",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
