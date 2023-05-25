part of '../views/edit_item_page.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemBloc, EditItemState>(
      buildWhen: (previous, current) =>
          previous.validateInputs() != current.validateInputs(),
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.validateInputs()
              ? () {
                  context.read<EditItemBloc>().add(ItemAdded());
                }
              : null,
          child: Text('Submit'),
        );
      },
    );
  }
}
