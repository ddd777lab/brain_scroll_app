import 'package:flutter/material.dart';

/// 标签选择器组件
class TagSelector extends StatefulWidget {
  final List<String> tags;
  final List<String> selectedTags;
  final ValueChanged<List<String>> onSelectionChanged;
  final String? addNewLabel;
  final Color selectedColor;

  const TagSelector({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.onSelectionChanged,
    this.addNewLabel,
    this.selectedColor = const Color(0xFF4ADE80), // 薄荷绿
  });

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _customTags = [];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    final newSelected = List<String>.from(widget.selectedTags);
    if (newSelected.contains(tag)) {
      newSelected.remove(tag);
    } else {
      newSelected.add(tag);
    }
    widget.onSelectionChanged(newSelected);
    setState(() {});
  }

  void _addCustomTag() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.tags.contains(text) && !_customTags.contains(text)) {
      setState(() {
        _customTags.add(text);
      });
      _controller.clear();
      _focusNode.unfocus();
    }
  }

  void _removeCustomTag(String tag) {
    setState(() {
      _customTags.remove(tag);
    });
    final newSelected = List<String>.from(widget.selectedTags)..remove(tag);
    widget.onSelectionChanged(newSelected);
  }

  @override
  Widget build(BuildContext context) {
    final allTags = [...widget.tags, ..._customTags];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 已选标签展示区
        if (widget.selectedTags.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedTags.map((tag) {
              final isCustom = _customTags.contains(tag);
              return Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: widget.selectedColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.selectedColor,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tag,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: widget.selectedColor.withOpacity(0.9),
                          ),
                        ),
                        if (isCustom) ...[
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => _removeCustomTag(tag),
                            child: Icon(
                              Icons.close,
                              size: 14,
                              color: widget.selectedColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        // 标签选择区
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allTags.map((tag) {
            final isSelected = widget.selectedTags.contains(tag);
            return GestureDetector(
              onTap: () => _toggleTag(tag),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? widget.selectedColor
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? widget.selectedColor
                        : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // 添加自定义标签输入框
        if (widget.addNewLabel != null)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    labelText: widget.addNewLabel,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: widget.selectedColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _addCustomTag(),
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _addCustomTag,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.selectedColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('添加'),
              ),
            ],
          ),
      ],
    );
  }
}
