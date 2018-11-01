import 'package:scoped_model/scoped_model.dart';

const tag = 'NavModel';

abstract class NavModel extends Model {
  int _currentNavItem = 0;

  int get currentNavItem => _currentNavItem;

  setSelectedNavItem(int selectedNavItem) {
    _currentNavItem = selectedNavItem;
    print('$tag selected nav item is $selectedNavItem');
    notifyListeners();
  }
}
