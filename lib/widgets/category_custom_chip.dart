import 'package:flutter/material.dart';

class CategoryCustomChip extends StatelessWidget {
  const CategoryCustomChip({
    super.key,
    required this.category,
    required this.onSelect,
    required this.selected,
  });

  final String category;
  final VoidCallback onSelect;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.white : Colors.grey.shade600,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Align(
          child: Text(
            category,
            style: TextStyle(
                color: selected ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
