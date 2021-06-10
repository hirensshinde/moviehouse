import 'package:flutter/material.dart';
import 'package:moviehouse/models/navigation_item.dart';

class NavigationProvider extends ChangeNotifier {
  NavigationItem _navigationItem = NavigationItem.home;

  // Navigation Getter
  NavigationItem get navigationItem => _navigationItem;
  // Navigation setter
  void setNavigationItem(NavigationItem navigationItem) {
    _navigationItem = navigationItem;

    notifyListeners();
  }
}
