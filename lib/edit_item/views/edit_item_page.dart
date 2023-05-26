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

part '../widgets/expiration_date_input.dart';
part '../widgets/image_input.dart';
part '../widgets/name_input.dart';
part '../widgets/quantity_input.dart';
part '../widgets/section_input.dart';
part '../widgets/submit_button.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({super.key, this.isCreateMode = false});

  final heightBetweenEachElement = 20.0;
  final bool isCreateMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isCreateMode ? 'Create Item' : 'Edit Item',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
      ),
      body: BlocProvider(
        create: (context) => EditItemBloc(
          foodSpacesRepository: context.read<FoodSpacesRepository>(),
          foodSpace: context.read<HomeBloc>().state.foodSpace,
        ),
        child: BlocBuilder<EditItemBloc, EditItemState>(
          buildWhen: (previous, current) =>
              previous.isLoading != current.isLoading,
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
                        SizedBox(height: 20),
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
                          _ImageInput(),
                          SizedBox(height: heightBetweenEachElement),
                          _NameInput(),
                          SizedBox(height: heightBetweenEachElement),
                          _ExpirationDateInput(),
                          SizedBox(height: heightBetweenEachElement),
                          _SectionInput(),
                          SizedBox(height: heightBetweenEachElement),
                          _QuantityInput(),
                          SizedBox(height: heightBetweenEachElement),
                          _SubmitButton(isCreateMode: isCreateMode),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
