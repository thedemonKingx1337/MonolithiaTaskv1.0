import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final dynamic selectedValue;
  final List<DropdownMenuItem<dynamic>>? items;
  final Function onChanged;
  final String? hint;

  const CustomDropDown({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 3, 5, 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
        color: Colors.blueGrey,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          value: selectedValue,
          iconSize: 24,
          hint: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              hint ?? "",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          onChanged: (dynamic newValue) {
            onChanged(newValue);
          },
          items: items,
        ),
      ),
    );
  }
}
