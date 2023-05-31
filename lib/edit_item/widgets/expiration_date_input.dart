part of '../views/edit_item_page.dart';

class _ExpirationDateInput extends StatefulWidget {
  _ExpirationDateInput({super.key});

  @override
  State<_ExpirationDateInput> createState() => _ExpirationDateInputState();
}

class _ExpirationDateInputState extends State<_ExpirationDateInput> {
  Future<void> _selectDate(
      BuildContext context, ExpirationDate expirationDateInput) async {
    DateTime? selectedDate;
    if (expirationDateInput.value.isNotEmpty && expirationDateInput.isValid) {
      selectedDate = DateFormat('dd/MM/yyyy').parse(expirationDateInput.value);
    }
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).colorScheme.secondary,
            onPrimary: Theme.of(context).primaryColor,
          ),
        ),
        child: child!,
      ),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      if (context.mounted) {
        controller.text = formattedDate;
        Future.delayed(Duration.zero,
            () => FocusScope.of(context).requestFocus(FocusNode()));
        context.read<EditItemBloc>().add(ExpirationDateChanged(formattedDate));
      }
    }
  }

  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final name = context.read<EditItemBloc>().state.expirationDate.value;

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
      buildWhen: (previous, current) =>
          previous.expirationDate != current.expirationDate,
      builder: (context, state) {
        final expirationValue = state.expirationDate.value;
        if (controller.text != expirationValue) {
          updateTextAndCursorPosition(expirationValue);
        }
        return Row(
          children: [
            Expanded(
              child: TextField(
                key: ValueKey('Expiration Date Input'),
                controller: controller,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp('[0-9/]'),
                  ), // Allow only numbers and "/"
                ],
                onChanged: (value) {
                  context
                      .read<EditItemBloc>()
                      .add(ExpirationDateChanged(value));
                },
                decoration: InputDecoration(
                  label: Text('Expiration Date Input'),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  errorText: state.expirationDate.getErrorMessage(),
                ),
              ),
            ),
            IconButton(
              onPressed: () => _selectDate(context, state.expirationDate),
              icon: Icon(Icons.calendar_month),
            ),
          ],
        );
      },
    );
  }
}
