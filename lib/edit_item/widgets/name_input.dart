part of '../views/edit_item_page.dart';

class _NameInput extends StatelessWidget {
  const _NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemBloc, EditItemState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
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
