import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.text,
    required this.onchange,
  });

  final void Function(String) onchange;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey[300],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ]),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(7),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              debugPrint("pressed");
            },
            icon: const Icon(Icons.search),
          ),
          Expanded(
            child: TextField(
              onChanged: onchange,
              decoration: const InputDecoration(
                hintText: "Enter a movie name",
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}
