
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pds_front/app/core/navigation/route_manager.dart';
import 'package:pds_front/app/models/create_post_model.dart';
import 'package:pds_front/app/services/posts_service.dart';
import 'package:pds_front/app/widgets/header_widget.dart';

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
  int _coverImage = 0;
  List<XFile> _images = [];
  bool _isLoading = false;

  final List<String> _categories = [
    'Carros',
    'Motos',
    'Caminhões',
    'Utilitários',
    'Peças Diversas',
  ];

  final Color customColor = const Color(0xFF91E4E2);
  final Color focusBorderColor = Colors.white;
  final Color backgroundColor = const Color(0xFF121212);
  final Color cardColor = const Color(0xFF1E1E1E);

  final picker = ImagePicker();

  Future<void> _pickImages() async {
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _images = picked;
      });
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _priceController.clear();
    setState(() {
      _selectedCategory = null;
      _isActive = false;
      _coverImage = 0;
      _images = [];
    });
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
        final price = formatter.parse(_priceController.text);

        final post = CreatePostModel(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory!,
          active: _isActive,
          images: _images, // Agora passa lista XFile
          coverImage: _coverImage,
          price: price.toDouble(),
        );

        await PostService().createPost(post);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post criado com sucesso!')),
          );
          _clearForm();

          context.go(RouteManager.postsList);
        }
      } catch (e, stackTrace) {
        print('Erro ao criar post: $e');
        print('StackTrace:\n$stackTrace');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao criar post: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderWidget(title: "Criar postagem"),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTextField('Título', _titleController),
                          const SizedBox(height: 16),
                          _buildTextField('Descrição', _descriptionController,
                              maxLines: 4),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: _inputDecoration('Categoria'),
                            value: _selectedCategory,
                            items: _categories
                                .map((c) =>
                                    DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (value) {
                              setState(() => _selectedCategory = value);
                            },
                            validator: (value) => value == null
                                ? 'Selecione uma categoria'
                                : null,
                            dropdownColor: cardColor,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            'Preço',
                            _priceController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [CurrencyInputFormatter()],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Ativo',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
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
                            label: 'Selecionar Imagens',
                            onPressed: _pickImages,
                            selected: _images.isNotEmpty,
                          ),
                          if (_images.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _images.asMap().entries.map((entry) {
                                final index = entry.key;
                                final image = entry.value;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _coverImage = index;
                                    });
                                  },
                                  child: FutureBuilder<Uint8List>(
                                    future: image.readAsBytes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.hasData) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: _coverImage == index
                                                ? Border.all(
                                                    color: Colors.red,
                                                    width: 3,
                                                  )
                                                : null,
                                            image: DecorationImage(
                                              image:
                                                  MemoryImage(snapshot.data!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey[300],
                                          child: const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        );
                                      }
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customColor,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black),
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.save, color: Colors.black),
                                      SizedBox(width: 8),
                                      Text('Salvar Anúncio'),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: customColor),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: customColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: focusBorderColor),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label),
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
        color: selected ? Colors.green : Colors.white,
      ),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white),
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
