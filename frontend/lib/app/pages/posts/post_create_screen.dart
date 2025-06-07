import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String? _selectedCategory;
  bool _isActive = false;
  XFile? _coverImage;
  List<XFile> _images = [];

  final List<String> _categories = [
    'Carros',
    'Motos',
    'Caminhões',
    'Utilitários',
    'SUVs',
    'Vans',
    'Peças Diversas',
  ];

  final Color azul = const Color.fromARGB(255, 145, 228, 226);
  final Color escuro = const Color(0xFF171821);
  final picker = ImagePicker();

  Future<void> _pickCoverImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _coverImage = picked);
    }
  }

  Future<void> _pickImages() async {
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() => _images = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulário enviado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Nova Postagem'),
        backgroundColor: escuro,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField('Título', _titleController, escuro),
                  const SizedBox(height: 16),
                  _buildTextField('Descrição', _descriptionController, escuro,
                      maxLines: 4),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Categoria',
                      labelStyle: TextStyle(color: escuro),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    value: _selectedCategory,
                    items: _categories
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategory = value);
                    },
                    validator: (value) =>
                        value == null ? 'Selecione uma categoria' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Preço',
                    _priceController,
                    escuro,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CurrencyInputFormatter()],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Ativo',
                        style: TextStyle(
                            fontSize: 16,
                            color: escuro,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      Switch(
                        value: _isActive,
                        onChanged: (value) {
                          setState(() => _isActive = value);
                        },
                        activeColor: Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildImageUploadButton(
                    label: 'Selecionar Imagem de Capa',
                    onPressed: _pickCoverImage,
                    selected: _coverImage != null,
                  ),
                  const SizedBox(height: 8),
                  if (_coverImage != null)
                    Text(
                      _coverImage!.name,
                      style: TextStyle(color: escuro),
                    ),
                  const SizedBox(height: 16),
                  _buildImageUploadButton(
                    label: 'Selecionar Imagens',
                    onPressed: _pickImages,
                    selected: _images.isNotEmpty,
                  ),
                  const SizedBox(height: 8),
                  if (_images.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: _images
                          .map((img) => Chip(label: Text(img.name)))
                          .toList(),
                    ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save),
                    label: Text(
                      'Salvar Anúncio',
                      style: TextStyle(color: azul),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: escuro,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    Color textColor, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label é obrigatório';
        }
        return null;
      },
    );
  }

  Widget _buildImageUploadButton({
    required String label,
    required VoidCallback onPressed,
    required bool selected,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        selected ? Icons.check_circle : Icons.image,
        color: selected ? Colors.green : escuro,
      ),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: escuro,
        side: BorderSide(color: escuro),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // para remover tudo que não for número, validar melhor isso se faz sentido
    String numericOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (numericOnly.isEmpty) return newValue.copyWith(text: '');

    double value = double.parse(numericOnly) / 100;

    final newText = currencyFormat.format(value);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
