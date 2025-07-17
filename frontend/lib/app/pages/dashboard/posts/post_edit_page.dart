import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pds_front/app/core/navigation/route_manager.dart';
import 'package:pds_front/app/models/create_post_model.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:pds_front/app/services/posts_service.dart';
import 'package:pds_front/app/widgets/header_widget.dart';
import 'package:pds_front/config.dart';

class EditPostPage extends StatefulWidget {
  final PostModel post;

  const EditPostPage({super.key, required this.post});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  String? _selectedCategory;
  bool _isActive = false;
  int _coverImage = 0;
  List<XFile> _images = [];
  List<String> _imagesToKeep = [];
  bool _isLoading = false;

  final picker = ImagePicker();

  final List<String> _categories = [
    'Carros',
    'Motos',
    'Caminhões',
    'Utilitários',
    'Peças Diversas',
  ];

  final Color customColor = const Color(0xFF007BFF);
  final Color focusBorderColor = Colors.white;
  final Color backgroundColor = const Color(0xFF1B1D25);
  final Color cardColor = const Color(0xFF232A3E);
  List<String> _existingImageUrls = [];

  Future<void> _pickImages() async {
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _images = picked;
      });
    }
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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _descriptionController =
        TextEditingController(text: widget.post.description);
    _priceController = TextEditingController(
      text: widget.post.price != null
          ? NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2)
              .format(widget.post.price)
          : '',
    );
    _selectedCategory = widget.post.category;
    _isActive = widget.post.active;
    _coverImage = widget.post.coverImage;
    _existingImageUrls = widget.post.images;
    _imagesToKeep = List.from(widget.post.images);
  }

  Future<void> _submit() async {
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
          coverImage: _coverImage,
          price: price.toDouble(),
          images: _images,
          existingImages: _imagesToKeep,
        );

        await PostService().updatePost(widget.post.id!, post);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post atualizado com sucesso!')),
          );
          context.go(RouteManager.postsList);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar post: $e')),
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
        HeaderWidget(title: "Editar postagem"),
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
                            onChanged: (value) =>
                                setState(() => _selectedCategory = value),
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
                              const Text('Ativo',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 12),
                              Switch(
                                value: _isActive,
                                onChanged: (value) =>
                                    setState(() => _isActive = value),
                                activeColor:
                                    const Color.fromARGB(255, 66, 222, 66),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          _buildImageUploadButton(
                            label: 'Selecionar Novas Imagens',
                            onPressed: _pickImages,
                            selected: _images.isNotEmpty,
                          ),
                          if (_existingImageUrls.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _existingImageUrls
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final url = entry.value;
                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          setState(() => _coverImage = index),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: _coverImage == index
                                              ? Border.all(
                                                  color: Colors.red, width: 3)
                                              : null,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                "${AppConfig.baseUrl}posts/images/$url"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.white),
                                        onPressed: () => setState(() {
                                          _imagesToKeep.remove(url);
                                          _existingImageUrls = List.from(
                                              _imagesToKeep); 
                                          if (_coverImage >=
                                              _existingImageUrls.length +
                                                  _images.length) {
                                            _coverImage =
                                                0; 
                                          }
                                        }),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                          if (_images.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _images.asMap().entries.map((entry) {
                                final index = entry.key;
                                final image = entry.value;
                                return GestureDetector(
                                  onTap: () => setState(() => _coverImage =
                                      _existingImageUrls.length + index),
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
                                            border: _coverImage ==
                                                    _existingImageUrls.length +
                                                        index
                                                ? Border.all(
                                                    color: Colors.red, width: 3)
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
                                  borderRadius: BorderRadius.circular(30)),
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
                                      Icon(Icons.save, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text('Salvar Alterações',
                                          style:
                                              TextStyle(color: Colors.white)),
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
      labelStyle: const TextStyle(color: Colors.white),
      floatingLabelStyle: const TextStyle(color: Colors.white),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1,
      TextInputType keyboardType = TextInputType.text,
      List<TextInputFormatter>? inputFormatters}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label),
      validator: (value) => (value == null || value.trim().isEmpty)
          ? '$label é obrigatório'
          : null,
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
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
