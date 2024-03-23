import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key, required this.textController});
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Title:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              )),
          EnterTitileForm(textController: textController),
        ]);
  }
}

class EnterTitileForm extends StatelessWidget {
  EnterTitileForm({super.key, required this.textController});
  final TextEditingController textController;

  final ScrollController textFieldScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        autovalidateMode: AutovalidateMode.always,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Title can\'t be empty!';
          return null;
        },
        controller: textController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter title',
          // errorText: 'Error',
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ));
  }
}
