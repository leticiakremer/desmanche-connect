import 'dart:async';
import 'package:flutter/material.dart';

class DebounceInput extends StatefulWidget {
  final String label;
  final Duration debounceDuration;
  final void Function(String) onChanged;
  final TextStyle? style;
  final InputDecoration? decoration;

  const DebounceInput({
    super.key,
    required this.label,
    required this.onChanged,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.style,
    this.decoration,
  });

  @override
  State<DebounceInput> createState() => _DebounceInputState();
}

class _DebounceInputState extends State<DebounceInput> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onTextChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged(value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onTextChanged,
      style: widget.style ?? const TextStyle(color: Colors.white),
      decoration: widget.decoration ??
          InputDecoration(
            labelText: widget.label,
            labelStyle: const TextStyle(color: Colors.white70),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white38),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
    );
  }
}
