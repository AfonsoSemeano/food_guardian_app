part of '../views/edit_item_page.dart';

class _SectionInput extends StatelessWidget {
  const _SectionInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemBloc, EditItemState>(
      buildWhen: (previous, current) =>
          previous.section?.id != current.section?.id,
      builder: (context, state) {
        return Column(
          children: [
            Text('Section'),
            Wrap(
              spacing: 16,
              children: [
                ...context.read<HomeBloc>().state.foodSpace?.sections.map(
                          (s) => ChoiceChip(
                            label: Text(s.name),
                            selected: state.section?.id == s.id,
                            onSelected: (value) => context
                                .read<EditItemBloc>()
                                .add(SectionChanged(value ? s : null)),
                          ),
                        ) ??
                    []
              ],
            )
          ],
        );
      },
    );
  }
}
