import 'package:get/get.dart';

import '../models/clientModel.dart';

class InputSearchController extends GetxController {
  final searchQuery = ''.obs;

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

   RxList<Client> clients = [
    Client(name: "John", gmail: "john@gmail"),
    Client(name: "Jemmy", gmail: "jemmy@gmail"),
    Client(name: "Rex", gmail: "rex@gmail")
  ].obs;

  /// Add Client Data
  void add (Client element){
    clients.add(element);
  }
}
