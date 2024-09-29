import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

Future<String> getUniqueID() async {
  final box = await Hive.openBox('app_data');
  var uniqueID = box.get('uniqueID');

  if (uniqueID == null) {
    uniqueID =
        Uuid().v4(); // Generate a unique ID using UUID for the first time
    await box.put('uniqueID', uniqueID); // Store it in Hive
  }

  return uniqueID;
}
