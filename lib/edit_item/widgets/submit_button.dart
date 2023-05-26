part of '../views/edit_item_page.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({super.key, required this.isCreateMode});

  final bool isCreateMode;

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
                  Navigator.of(context).pop();
                  if (isCreateMode) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditItemPage(
                          isCreateMode: true,
                        ),
                      ),
                    );
                  }
                }
              : null,
          child: Text('Submit'),
        );
      },
    );
  }
}
