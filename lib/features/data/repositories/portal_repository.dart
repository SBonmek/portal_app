import 'package:flutter/material.dart';
import 'package:portal_app/features/data/models/portal_model.dart';
import 'package:portal_app/features/data/remotes/portal_remote.dart';

class PortalRepository extends ChangeNotifier {
  PortalRepository() {
    getPortalList();
  }
  // temp data
  bool isLoaded = false;
  List<PortalModel> portalList = [];

  final PortalRemote _portalRemote = PortalRemoteImpl();

  Future<void> getPortalList() async {
    try {
      isLoaded = false;
      notifyListeners();
      portalList.clear();

      portalList = await _portalRemote.getPortalList();
      
    } catch (error) {
      print(error);
      portalList.clear();
    }

    isLoaded = true;
    notifyListeners();
  }
}
