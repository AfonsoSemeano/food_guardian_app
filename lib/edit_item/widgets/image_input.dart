part of '../views/edit_item_page.dart';

class _ImageInput extends StatelessWidget {
  const _ImageInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(label: Text('Image Input')),
    );
  }
}
