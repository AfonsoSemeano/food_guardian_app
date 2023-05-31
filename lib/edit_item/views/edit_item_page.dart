import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/edit_item/bloc/edit_item_bloc.dart';
import 'package:food_control_app/edit_item/models/expiration_date.dart';
import 'package:food_control_app/home/bloc/home_bloc.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';
import 'package:formz/formz.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

part '../widgets/expiration_date_input.dart';
part '../widgets/image_input.dart';
part '../widgets/name_input.dart';
part '../widgets/quantity_input.dart';
part '../widgets/section_input.dart';
part '../widgets/submit_button.dart';

class EditItemPage extends StatefulWidget {
  const EditItemPage({super.key, this.isCreateMode = false, this.item});

  final bool isCreateMode;
  final Item? item;

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final heightBetweenEachElement = 20.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<EditItemBloc>().add(ItemChanged(widget.item));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            context.read<EditItemBloc>().add(ClearStateRequested());
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.isCreateMode ? 'Create Item' : 'Edit Item',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
      ),
      body: BlocBuilder<EditItemBloc, EditItemState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.item != current.item,
        builder: (context, state) {
          return state.isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        child: LinearProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Loading...',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        _ImageInput(item: widget.item),
                        SizedBox(height: heightBetweenEachElement),
                        _NameInput(),
                        SizedBox(height: heightBetweenEachElement),
                        _ExpirationDateInput(),
                        SizedBox(height: heightBetweenEachElement),
                        _SectionInput(),
                        SizedBox(height: heightBetweenEachElement),
                        _QuantityInput(),
                        SizedBox(height: heightBetweenEachElement),
                        _SubmitButton(isCreateMode: widget.isCreateMode),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
