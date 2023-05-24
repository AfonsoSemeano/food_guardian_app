import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
      ),
      body: Column(
        children: const [
          _ImageInput(),
          _NameInput(),
          _ExpirationDateInput(),
          _SectionInput(),
          _QuantityInput(),
          _SubmitButton(),
        ],
      ),
    );
  }
}

class _ImageInput extends StatelessWidget {
  const _ImageInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(label: Text('Image Input')),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(label: Text('Name Input')),
    );
  }
}

class _ExpirationDateInput extends StatelessWidget {
  const _ExpirationDateInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(label: Text('Expiration Date Input')),
    );
  }
}

class _SectionInput extends StatelessWidget {
  const _SectionInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(label: Text('Section Input')),
    );
  }
}

class _QuantityInput extends StatelessWidget {
  const _QuantityInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(label: Text('Quantity Input')),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text('Submit'),
    );
  }
}
