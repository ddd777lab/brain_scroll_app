import 'package:flutter/material.dart';

/// 可搜索的下拉选择框组件
class SearchableDropdown extends StatefulWidget {
  final String? value;
  final List<String> items;
  final String hintText;
  final ValueChanged<String?> onChanged;
  final String? labelText;

  const SearchableDropdown({
    super.key,
    this.value,
    required this.items,
    this.hintText = '请选择',
    required this.onChanged,
    this.labelText,
  });

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _filteredItems = [];
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _controller.text = widget.value ?? '';
  }

  @override
  void didUpdateWidget(SearchableDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _filteredItems = widget.items;
        _focusNode.requestFocus();
      }
    });
  }

  void _selectItem(String item) {
    widget.onChanged(item);
    setState(() {
      _isExpanded = false;
      _controller.text = item;
    });
    _focusNode.unfocus();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  /// 收起下拉框
  void _collapse() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
      });
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
        ],
        // 触发区域
        GestureDetector(
          onTap: _toggleExpanded,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isExpanded ? theme.primaryColor : Colors.grey[300]!,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _controller.text.isEmpty ? widget.hintText : _controller.text,
                    style: TextStyle(
                      fontSize: 15,
                      color: _controller.text.isEmpty ? Colors.grey[400] : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
        // 下拉建议框
        if (_isExpanded) ...[
          const SizedBox(height: 8),
          // 遮罩层：点击外部收起下拉框
          Stack(
            children: [
              // 透明遮罩覆盖全屏，点击收起
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _collapse,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              // 建议框本体
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 搜索框
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[200]!),
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: '搜索${widget.labelText ?? ''}',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onChanged: _filterItems,
                        autofocus: true,
                      ),
                    ),
                    // 列表 - 移除 Expanded，使用 ConstrainedBox + ListView
                    Flexible(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          final isSelected = item == widget.value;
                          return ListTile(
                            dense: true,
                            selected: isSelected,
                            selectedTileColor: Colors.green[50],
                            title: Text(
                              item,
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected ? Colors.green[700] : Colors.black87,
                                fontWeight: isSelected ? FontWeight.w600 : null,
                              ),
                            ),
                            onTap: () => _selectItem(item),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
