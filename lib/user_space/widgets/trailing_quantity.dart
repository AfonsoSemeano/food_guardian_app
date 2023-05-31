part of './item_entry.dart';

class _TrailingQuantity extends StatefulWidget {
  const _TrailingQuantity({super.key, required this.item});

  final Item item;

  @override
  State<_TrailingQuantity> createState() => _TrailingQuantityState();
}

class _TrailingQuantityState extends State<_TrailingQuantity> {
  late int quantity;
  bool willSendToServer = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantity = widget.item.quantity;
  }

  void submitQuantity() {
    if (!willSendToServer) {
      willSendToServer = true;
      Future.delayed(
        Duration(milliseconds: 1500),
        () {
          context.read<UserSpaceBloc>().add(
                ItemQuantityButtonClicked(
                  item: widget.item,
                  newQuantity: quantity,
                  currentFoodSpace: context.read<HomeBloc>().state.foodSpace,
                ),
              );
          willSendToServer = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (quantity != 1)
              IconButton(
                onPressed: () {
                  setState(() {
                    quantity -= 1;
                  });
                  submitQuantity();
                },
                icon: const Icon(
                  Icons.remove,
                  size: 15,
                ),
              ),
            if (quantity == 1)
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                  size: 18,
                ),
              ),
            Text(quantity.toString()),
            IconButton(
              onPressed: () {
                setState(() {
                  quantity += 1;
                });
                submitQuantity();
              },
              icon: const Icon(
                Icons.add,
                size: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
