import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

const tag = 'NavModel';

abstract class NavModel extends Model {
  int _currentNavItem = 0;

  int get currentNavItem => _currentNavItem;

  final _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  setSelectedNavItem(int selectedNavItem) {
    _currentNavItem = selectedNavItem;
    print('$tag selected nav item is $selectedNavItem');
    notifyListeners();
  }

  updateListViewPosition() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }
}
