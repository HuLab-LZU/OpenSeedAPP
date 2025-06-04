// ignore_for_file: avoid_print

import 'package:iplant_api/iplant_api.dart';

void main() async {
  final client = IPlantApiClient();
  final indexInfo = await client.getIndexInfo();
  print(indexInfo);
}
