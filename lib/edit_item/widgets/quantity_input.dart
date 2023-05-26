part of '../views/edit_item_page.dart';

class _QuantityInput extends StatefulWidget {
  _QuantityInput();

  @override
  _QuantityInputState createState() => _QuantityInputState();
}

class _QuantityInputState extends State<_QuantityInput> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
      buildWhen: (previous, current) => previous.quantity != current.quantity,
      builder: (context, state) {
        final quantityValue = state.quantity.value;

        if (controller.text != quantityValue) {
          updateTextAndCursorPosition(quantityValue);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 90),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  context
                      .read<EditItemBloc>()
                      .add(const QuantityButtonClicked(isIncrement: false));
                },
                icon: Icon(Icons.remove),
              ),
              Expanded(
                child: TextField(
                  key: ValueKey('Quantity Input'),
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    context.read<EditItemBloc>().add(QuantityChanged(value));
                  },
                  decoration: InputDecoration(
                    label: Text('Quantity'),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    errorText: state.quantity.getErrorMessage(),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  context
                      .read<EditItemBloc>()
                      .add(const QuantityButtonClicked(isIncrement: true));
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
        );
      },
    );
  }
}
