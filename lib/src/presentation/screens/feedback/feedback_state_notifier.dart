import 'dart:convert';

import '../../../helpers/dates.dart';
import '../../../model/database/local/file_store.dart';
import '../../../model/entities/data.dart';
import 'feedback_state.dart';
import 'package:state_notifier/state_notifier.dart';

class FeedbackStateNotifier extends StateNotifier<FeedbackState>
    with LocatorMixin {
  FeedbackStateNotifier() : super(FeedbackState()) {
    _init();
  }

  DateSupport _dateSupport;
  FileStore _fileStore;

  void _init() async {
    _dateSupport = DateSupport();
    _fileStore = const FileStore();
    state = state.copyWith(listDataWakeUp: await _getListWakeUpNotYetRated());
  }

  Future<List<Data>> _getListWakeUpNotYetRated() async {
    final String readFromFile = await _fileStore.readData();
    final listDataFromFile = jsonDecode(readFromFile) as List;
    final listDataWakeUp = listDataFromFile
        .map((e) => Data.fromJson(e))
        .toList()
          ..removeWhere((element) => element.feedback);
    return listDataWakeUp ?? [];
  }

  String formatWithDMY(DateTime timeWakeUp) {
    return _dateSupport.formatWithDayDMY(timeWakeUp);
  }

  void rating(int level, int index) async {
//    Navigator.pop(context);
    //TODO: Tạm thời chưa truyền sự kiện tới view được
    if (level != 4) {
      state.listDataWakeUp[index].feedback = true;
      state.listDataWakeUp[index].level = level;
      await _fileStore.updateData(state.listDataWakeUp[index]);
    } else {
      await _fileStore.removeData(state.listDataWakeUp[index]);
    }
    state = FeedbackState(listDataWakeUp: await _getListWakeUpNotYetRated());
  }
}
