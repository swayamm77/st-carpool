import 'package:flutter/material.dart';

import '../current_user.dart';
import '../services/ola_maps_service.dart';

import '../services/address_service.dart';

import '../widgets/app_card.dart';
import '../widgets/empty_state.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final nameController = TextEditingController();

  final addressController = TextEditingController();

  double? selectedLat;
  double? selectedLng;

  List<dynamic> suggestions = [];

  bool isSearching = false;

  String selectedType = "Home";

  List addresses = [];

  bool isLoading = true;

  Future<void> deleteAddress(String addressId) async {
    try {
      await AddressService.deleteAddress(addressId);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Address deleted")));

      fetchAddresses();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() {
        suggestions = [];
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    final results = await OlaMapsService.searchPlaces(query);

    setState(() {
      suggestions = results;
      isSearching = false;
    });
  }

  Future<void> saveAddress() async {
    try {
      await AddressService.addAddress(
        userId: currentUser!["_id"],
        name: selectedType,
        address: addressController.text.trim(),
        lat: selectedLat!,
        lng: selectedLng!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address saved successfully!")),
      );

      addressController.clear();

      selectedLat = null;
      selectedLng = null;

      fetchAddresses();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> showAddAddressDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Address"),
          content: StatefulBuilder(
            builder: (context, dialogSetState) {
              return SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: const InputDecoration(
                          labelText: "Address Type",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: "Home", child: Text("Home")),
                          DropdownMenuItem(
                            value: "Office",
                            child: Text("Office"),
                          ),
                          DropdownMenuItem(
                            value: "Other",
                            child: Text("Other"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedType = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: "Search Address",
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        onChanged: (value) async {
                          final results = await OlaMapsService.searchPlaces(
                            value,
                          );

                          dialogSetState(() {
                            suggestions = results;
                          });
                        },
                      ),

                      if (suggestions.isNotEmpty)
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: suggestions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(suggestions[index]["description"]),
                                onTap: () {
                                  addressController.text =
                                      suggestions[index]["description"];

                                  selectedLat =
                                      suggestions[index]["geometry"]["location"]["lat"];

                                  selectedLng =
                                      suggestions[index]["geometry"]["location"]["lng"];

                                  dialogSetState(() {
                                    suggestions = [];
                                  });
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                await saveAddress();

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchAddresses() async {
    try {
      final result = await AddressService.getAddresses(currentUser!["_id"]);

      if (!mounted) return;

      setState(() {
        addresses = result;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Addresses")),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddAddressDialog();
        },
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: addresses.isEmpty
                        ? const EmptyState(
                            icon: Icons.location_on,
                            text: "No saved addresses",
                          )
                        : ListView.builder(
                            itemCount: addresses.length,
                            itemBuilder: (context, index) {
                              final address = addresses[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: AppCard(
                                  child: ListTile(
                                    leading: Icon(
                                      address["name"] == "Home"
                                          ? Icons.home
                                          : address["name"] == "Office"
                                          ? Icons.business
                                          : Icons.place,
                                    ),
                                    title: Text(address["name"]),
                                    subtitle: Text(address["address"]),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        final shouldDelete =
                                            await showDialog<bool>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Delete Address",
                                                  ),
                                                  content: const Text(
                                                    "Are you sure?",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                          context,
                                                          false,
                                                        );
                                                      },
                                                      child: const Text(
                                                        "Cancel",
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                          context,
                                                          true,
                                                        );
                                                      },
                                                      child: const Text(
                                                        "Delete",
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                        if (shouldDelete == true) {
                                          deleteAddress(address["_id"]);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
