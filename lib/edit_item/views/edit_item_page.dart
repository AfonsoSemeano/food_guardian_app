import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/edit_item/bloc/edit_item_bloc.dart';
import 'package:food_control_app/edit_item/models/expiration_date.dart';
import 'package:food_control_app/home/bloc/home_bloc.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

part '../widgets/expiration_date_input.dart';
part '../widgets/image_input.dart';
part '../widgets/name_input.dart';
part '../widgets/quantity_input.dart';
part '../widgets/section_input.dart';
part '../widgets/submit_button.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({super.key});

  final heightBetweenEachElement = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
      ),
      body: BlocProvider(
        create: (context) => EditItemBloc(
          foodSpacesRepository: context.read<FoodSpacesRepository>(),
          foodSpace: context.read<HomeBloc>().state.foodSpace,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                _SubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
