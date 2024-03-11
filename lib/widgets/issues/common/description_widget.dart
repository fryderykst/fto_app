import 'package:flutter/material.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({super.key, required this.textController});
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Description:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              )),
          EnterDescriptionForm(textController: textController),
        ]);
  }
}

class EnterDescriptionForm extends StatelessWidget {
  EnterDescriptionForm({super.key, required this.textController});

  final TextEditingController textController;
  final ScrollController textFieldScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      scrollController: textFieldScrollController,
      maxLines: 10,
      onChanged: (value) {
        textFieldScrollController.jumpTo(textFieldScrollController.position.maxScrollExtent);
      },
      decoration: const InputDecoration(
        floatingLabelAlignment: FloatingLabelAlignment.start,
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
        labelText: 'Enter description (optional)',
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }
}
