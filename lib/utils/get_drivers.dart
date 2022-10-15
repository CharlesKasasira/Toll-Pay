import 'constants.dart';

Future getDrivers() async {
    final response = await supabase.from('qrcodes').select().order('created_at', ascending: false).execute();

    final data = response.data;
    final error = response.error;

    if (data != null) {
    } else {
    }

    if (error != null) {
      print("the error is ${error.message}");
    }
    return data;
  }