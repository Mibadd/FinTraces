import 'package:flutter/material.dart';

class CustomNumpad extends StatelessWidget {
  final Function(String) onNumberTap;
  final VoidCallback onBackspace;
  final VoidCallback onDone;

  const CustomNumpad({
    super.key,
    required this.onNumberTap,
    required this.onBackspace,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3']),
          _buildRow(['4', '5', '6']),
          _buildRow(['7', '8', '9']),
          _buildRow(['backspace', '0', 'done']),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items.map((item) {
        if (item == 'backspace') {
          return _buildButton(
            icon: Icons.backspace_outlined,
            onTap: onBackspace,
          );
        } else if (item == 'done') {
          return _buildButton(
            icon: Icons.check_circle_outline,
            onTap: onDone,
            color: Colors.teal,
          );
        } else {
          return _buildButton(
            text: item,
            onTap: () => onNumberTap(item),
          );
        }
      }).toList(),
    );
  }

  Widget _buildButton({
    String? text,
    IconData? icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                color: color?.withOpacity(0.1) ?? Colors.transparent,
              ),
              child: Center(
                child: icon != null
                    ? Icon(icon, color: color ?? Colors.grey.shade700, size: 28)
                    : Text(
                        text!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
