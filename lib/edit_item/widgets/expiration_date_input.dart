part of '../views/edit_item_page.dart';

class _ExpirationDateInput extends StatelessWidget {
  _ExpirationDateInput({super.key}) : controller = TextEditingController();

  final TextEditingController controller;

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemBloc, EditItemState>(
      buildWhen: (previous, current) =>
          previous.expirationDate != current.expirationDate,
      builder: (context, state) {
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
