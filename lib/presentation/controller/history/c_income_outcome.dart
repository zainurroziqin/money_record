import 'package:get/get.dart';
import 'package:money_record/data/model/history.dart';
import 'package:money_record/data/source/source_history.dart';

class CIncomeOutcome extends GetxController{
  final _loading = false.obs;
  bool get loading => _loading.value;

  final _list = <History>[].obs;
  List<History> get list => _list.value;

  getList(String idUser, String type) async{
    _loading.value = true;
    update();
    _list.value = await SourceHistory.incomeOutcome(idUser, type);
    update();
     _loading.value = false;
    update();
  }

  search(String idUser, String type, String date) async{
    _loading.value = true;
    update();
    _list.value = await SourceHistory.incomeOutcomeSearch(idUser, type, date);
    update();
     _loading.value = false;
    update();
  }
}