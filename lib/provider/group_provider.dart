// this get the current group being viewed
import 'package:zion/model/groupmodel.dart';

class CurrentGroupProvider {
  Group _group;

  set setGroup(Group group) {
    this._group = group;
  }

  Group get getGroup => this._group;
}
