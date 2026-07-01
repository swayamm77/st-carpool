import 'package:flutter/material.dart';

class AddressPickerDialog extends StatefulWidget {
  final List addresses;

  const AddressPickerDialog({super.key, required this.addresses});

  @override
  State<AddressPickerDialog> createState() => _AddressPickerDialogState();
}

class _AddressPickerDialogState extends State<AddressPickerDialog> {
  Map? selectedAddress;

  @override
  void initState() {
    super.initState();

    if (widget.addresses.isNotEmpty) {
      selectedAddress = widget.addresses.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Pickup Location"),

      content: SizedBox(
        width: double.maxFinite,

        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.addresses.length,

          itemBuilder: (context, index) {
            final address = widget.addresses[index];

            return RadioListTile<Map>(
              value: address,
              groupValue: selectedAddress,

              title: Text(address["name"]),

              subtitle: Text(address["address"]),

              onChanged: (value) {
                setState(() {
                  selectedAddress = value;
                });
              },
            );
          },
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: selectedAddress == null
              ? null
              : () {
                  Navigator.pop(context, selectedAddress);
                },
          child: const Text("Select"),
        ),
      ],
    );
  }
}
