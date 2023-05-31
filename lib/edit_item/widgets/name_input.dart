part of '../views/edit_item_page.dart';

class _NameInput extends StatefulWidget {
  _NameInput({super.key});

  @override
  State<_NameInput> createState() => _NameInputState();
}

class _NameInputState extends State<_NameInput> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final name = context.read<EditItemBloc>().state.name.value;

    updateTextAndCursorPosition(name);
  }

  void updateTextAndCursorPosition(String newText) {
    final selection = controller.selection;
    final cursorPosition = selection.extentOffset;
    final newCursorPosition = min(cursorPosition, newText.length);

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemBloc, EditItemState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        final nameValue = state.name.value;

        if (controller.text != nameValue) {
          updateTextAndCursorPosition(nameValue);
        }
        return TextField(
          key: ValueKey('Name Input'),
          controller: controller,
          onChanged: (value) =>
              context.read<EditItemBloc>().add(NameChanged(value)),
          decoration: InputDecoration(
            label: Text('Name Input'),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            errorText: state.name.getErrorMessage(),
          ),
        );
      },
    );
  }
}
