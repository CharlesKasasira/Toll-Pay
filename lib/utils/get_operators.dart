import 'package:tollpay/utils/constants.dart';

Future getOperators() async {
  final response = await supabase.from('profiles').select().eq("roles", "operator").execute();

  final data = response.data;
  final error = response.error;

  if (data != null) {
  } else {}

  if (error != null) {
    print("the error is ${error.message}");
  }
  print(data);
  return data;
}
