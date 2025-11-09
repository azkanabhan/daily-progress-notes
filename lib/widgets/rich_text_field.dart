import 'package:flutter/material.dart';

class RichTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;

  const RichTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
  });

  @override
  State<RichTextField> createState() => _RichTextFieldState();
}

class _RichTextFieldState extends State<RichTextField> {
  bool _isBold = false;
  bool _isItalic = false;

  void _toggleBold() {
    setState(() {
      _isBold = !_isBold;
    });
    // Apply formatting to selected text
    final selection = widget.controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      final text = widget.controller.text;
      final selectedText = text.substring(selection.start, selection.end);
      final newText = _isBold ? '**$selectedText**' : selectedText.replaceAll('**', '');
      widget.controller.value = widget.controller.value.copyWith(
        text: text.replaceRange(selection.start, selection.end, newText),
        selection: TextSelection.collapsed(offset: selection.start + newText.length),
      );
    }
  }

  void _toggleItalic() {
    setState(() {
      _isItalic = !_isItalic;
    });
    // Apply formatting to selected text
    final selection = widget.controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      final text = widget.controller.text;
      final selectedText = text.substring(selection.start, selection.end);
      final newText = _isItalic ? '*$selectedText*' : selectedText.replaceAll('*', '');
      widget.controller.value = widget.controller.value.copyWith(
        text: text.replaceRange(selection.start, selection.end, newText),
        selection: TextSelection.collapsed(offset: selection.start + newText.length),
      );
    }
  }

  void _insertBullet() {
    final selection = widget.controller.selection;
    final text = widget.controller.text;
    final position = selection.baseOffset;
    
    // Insert bullet at current position
    final newText = text.substring(0, position) + '• ' + text.substring(position);
    widget.controller.value = widget.controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: position + 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              // Toolbar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.format_bold,
                        color: _isBold ? Theme.of(context).colorScheme.primary : Colors.grey.shade600,
                      ),
                      onPressed: _toggleBold,
                      tooltip: 'Bold',
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.format_italic,
                        color: _isItalic ? Theme.of(context).colorScheme.primary : Colors.grey.shade600,
                      ),
                      onPressed: _toggleItalic,
                      tooltip: 'Italic',
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.format_list_bulleted,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: _insertBullet,
                      tooltip: 'Bullet List',
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.undo,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        // Undo functionality
                      },
                      tooltip: 'Undo',
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Text Field
              TextField(
                controller: widget.controller,
                maxLines: null,
                minLines: 6,
                decoration: InputDecoration(
                  hintText: widget.hint ?? 'Tuliskan refleksimu di sini...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
