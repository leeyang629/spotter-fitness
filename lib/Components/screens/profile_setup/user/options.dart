import 'package:flutter/material.dart';

class Options extends StatelessWidget {
  final List<String> options;
  final Function handleSelect;
  final String optionSelected;

  Options(this.options, this.handleSelect, this.optionSelected);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options
          .map((option) => ListTile(
              title: Text(option),
              leading: Radio<String>(
                  value: option,
                  groupValue: optionSelected,
                  onChanged: (String value) {
                    handleSelect(value);
                  })))
          .toList(),
    );
  }
}
