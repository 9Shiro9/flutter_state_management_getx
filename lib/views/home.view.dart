import 'package:flutter/material.dart';
import 'package:flutter_app/constant/constant.dart';
import 'package:flutter_app/controllers/searchController.dart';
import 'package:flutter_app/models/clientModel.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final inputSearchController = Get.put(InputSearchController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white54.withOpacity(0.95),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Clients',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.5,
                    height: 50,
                    child: TextField(
                      onChanged: (query) {
                        inputSearchController.setSearchQuery(query);
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Search',
                        suffixIcon: const Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: Colors.grey.withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: Colors.grey.withOpacity(0.2))),
                      ),
                    ),
                  ),
                  HWButton(
                    onTap: () {
                      showDialog(
                        barrierColor: Colors.white.withOpacity(0),
                        context: context,
                        builder: (context) => buildDialog(context),
                      );
                    },
                    textButton: 'Create Client',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(
                () {
                  if (inputSearchController.searchQuery.isEmpty) {
                    return buildTable(inputSearchController.clients, context);
                  } else {
                    // Perform your search and display filtered results
                    final filteredClients = inputSearchController.clients
                        .where((client) =>
                            client.name.toLowerCase().contains(
                                  inputSearchController.searchQuery
                                      .toLowerCase(),
                                ) ||
                            client.gmail.toLowerCase().contains(
                                  inputSearchController.searchQuery
                                      .toLowerCase(),
                                ))
                        .toList();

                    return buildTable(filteredClients.cast<Client>(), context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDialog(BuildContext context) {
    String nameError = '';
    String emailError = '';

    return Dialog(
      backgroundColor: AppColor.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p_20),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(AppSize.s_16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Create Client'),
                const SizedBox(height: AppSize.s_16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    errorText: nameError.isNotEmpty ? nameError : null,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: emailError.isNotEmpty ? emailError : null,
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Get values from the text fields
                    String name = nameController.text;
                    String email = emailController.text;

                    // Validate inputs
                    if (name.isEmpty) {
                      nameError = 'Name must not be empty';
                    } else {
                      nameError = '';
                    }
                    if (email.isEmpty) {
                      emailError = 'Email must not be empty';
                    } else {
                      emailError = '';
                    }
                    if (nameError.isEmpty && emailError.isEmpty) {
                      // Add a new Client model to the array
                      inputSearchController.add(Client(name: name, gmail: email));
                      // Close the dialog
                      nameController.clear();
                      emailController.clear();
                      Navigator.pop(context);
                    } else {
                      // Update the UI to display error messages
                      Get.forceAppUpdate();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Text color
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildTable(List<Client> clientList, context) {
    return Obx(() => Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Gmail')),
              ],
              rows: clientList
                  .map((client) => DataRow(
                        cells: [
                          DataCell(SizedBox(
                              width: 100,
                              height: 50,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(client.name,overflow: TextOverflow.ellipsis,maxLines: 1,))),),
                          DataCell(SizedBox(
                              width: 100,
                              height: 50,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(client.gmail,overflow: TextOverflow.ellipsis,maxLines: 1,)))),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ));
  }
}

class HWButton extends StatelessWidget {
  final String? textButton;
  final Function()? onTap;
  const HWButton({super.key, this.textButton = 'Default', required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.blue),
        width: size.width * 0.3,
        height: 48,
        child: Center(
          child: Text(
            textButton!,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
