import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_control_app/edit_item/views/edit_item_page.dart';
import 'package:food_control_app/home/bloc/home_bloc.dart';
import 'package:food_control_app/user_space/bloc/user_space_bloc.dart';
import 'package:food_spaces_repository/food_spaces_repository.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

part 'expiration_subtitle.dart';
part 'trailing_quantity.dart';

class ItemEntry extends StatefulWidget {
  const ItemEntry({super.key, required this.item});

  final Item item;

  @override
  State<ItemEntry> createState() => _ItemEntryState();
}

class _ItemEntryState extends State<ItemEntry> {
  bool isDeleted = false;

  @override
  Widget build(BuildContext context) {
    return isDeleted
        ? const SizedBox()
        : Card(
            elevation: 4, // Controls the shadow depth
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8), // Controls the corner radius
            ),
            child: ListTile(
              onTap: () {
                print('${widget.item.section} section');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditItemPage(
                      item: widget.item,
                    ),
                  ),
                );
              },
              leading: Container(
                width: 56,
                child: widget.item.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.item.image!,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.secondary,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Text('Failed to load image'),
                        ),
                      )
                    : Container(
                        width: 56,
                        height: 56,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            const Center(
                              child: Icon(
                                Icons.fastfood,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              title: Text(widget.item.name),
              subtitle: _ExpirationSubtitle(
                  expirationDate: widget.item.expirationDate),
              trailing: _TrailingQuantity(
                  item: widget.item,
                  deleteFn: () {
                    setState(() {
                      isDeleted = true;
                    });
                  }),
            ),
          );
  }
}
