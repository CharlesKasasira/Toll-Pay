import 'package:tollpay/utils/constants.dart';

Future getDrivers() async {
  final response =
      await supabase.from('profiles').select().eq("roles", "driver")
      .eq("organisation_id", supabase.auth.user()!.id)
      .execute();

  final data = response.data;
  final error = response.error;

  if (data != null) {
  } else {}

  if (error != null) {
    print("the error is ${error.message}");
  }
  return data;
}
