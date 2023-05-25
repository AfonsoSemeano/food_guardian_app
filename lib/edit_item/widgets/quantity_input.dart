part of '../views/edit_item_page.dart';

class _QuantityInput extends StatelessWidget {
  const _QuantityInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemBloc, EditItemState>(
      buildWhen: (previous, current) => previous.quantity != current.quantity,
      builder: (context, state) {
        return TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) =>
              context.read<EditItemBloc>().add(QuantityChanged(value)),
          decoration: InputDecoration(
            label: Text('Quantity Input'),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            errorText: state.quantity.getErrorMessage(),
          ),
        );
      },
    );
  }
}
