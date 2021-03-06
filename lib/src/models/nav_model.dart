import 'package:flutter/material.dart';
import 'package:kijiweni_flutter/src/utils/consts.dart';
import 'package:kijiweni_flutter/src/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:url_launcher/url_launcher.dart';

const _tag = 'NavModel';

abstract class NavModel extends Model {
  int _currentNavItem = 0;
  int get currentNavItem => _currentNavItem;
  String _deepLinkedCommunityId;
  String get deepLinkedCommunityId => _deepLinkedCommunityId; 

  final _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  setSelectedNavItem(int selectedNavItem) {
    _currentNavItem = selectedNavItem;
    // print('$_tag selected nav item is $selectedNavItem');
    notifyListeners();
  }

  updateListViewPosition() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }




  Future<Null> initUniLinks() async {
    print('$_tag at initiUniLinks');
    // Platform messages may fail, so we use a try/catch PlatformException.
    String communityId;
    try {
      String initialLink = await getInitialLink();
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      print('$_tag initialLink is: $initialLink');
      if (initialLink == null) return ;
       communityId = initialLink.substring(APP_DEEP_LINK_HEAD.length);
      _deepLinkedCommunityId = communityId;
      // print('$_tag the community id is: $communityId');
      notifyListeners();
      // return communityId;
      
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
      print('$_tag error getting initial link');
    }
  }
  resetInitialLinkData(){
    _deepLinkedCommunityId = null;
  }


  handleAppInfoAction(AppInfoAction action){
    switch(action){
      case AppInfoAction.call:
      _launchURL(URL_CALL);
      break;
      case AppInfoAction.email:
      _launchURL(URL_EMAIL);
      break;
      case AppInfoAction.more:
      _launchURL(URL_STORE);
      break;
    }
  }


  _launchURL(String url) async {
  
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  
}
