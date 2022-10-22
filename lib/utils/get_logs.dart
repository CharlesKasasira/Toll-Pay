import 'package:tollpay/utils/constants.dart';

Future getLogs() async {
  final response =
      await supabase.from('logs').select().execute();

  final data = response.data;
  final error = response.error;

  if (data != null) {
  } else {}

  if (error != null) {
    print("the error is ${error.message}");
  }
  return data;
}
