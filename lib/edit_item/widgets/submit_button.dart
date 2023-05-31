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
                  if (!isCreateMode) {
                    print('not create mode');
                    final item = context.read<EditItemBloc>().state.item;
                    context.read<EditItemBloc>().add(const ItemEdited());
                  } else {
                    print('is create mode');
                    context.read<EditItemBloc>().add(const ItemAdded());
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditItemPage(
                          isCreateMode: true,
                        ),
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                }
              : null,
          child: Text('Submit'),
        );
      },
    );
  }
}
