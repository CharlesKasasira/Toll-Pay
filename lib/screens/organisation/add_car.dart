import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/widgets/appbar_avatar.dart';
import 'package:tollpay/widgets/button.dart';

class AddCar extends StatefulWidget {
  const AddCar({Key? key}) : super(key: key);

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  bool _isLoading = false;
  late final TextEditingController _plateController;
  late final TextEditingController _classController;
  late final TextEditingController _colorController;
  late final TextEditingController _modelController;

  final _focusPlate = FocusNode();
  final _focusClass = FocusNode();
  final _focusColor = FocusNode();
  final _focusModel = FocusNode();

  Future<void> _addCar() async {
    setState(() {
      _isLoading = true;
    });
    final plateNumber = _plateController.text;
    final classType = _classController.text;
    final color = _colorController.text;
    final model = _modelController.text;

    final response = await supabase.from("cars").insert([
      {
        'owned_by': supabase.auth.user()!.id,
        'plate_number': plateNumber,
        'class': classType,
        'color': color,
        'model': model
      }
    ]).execute();

    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Successful"),
            content: const Text("The car was added successfully"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("OK"),
              )
            ],
          );
        },
      );

      _plateController.clear();
      _classController.clear();
      _colorController.clear();
      _modelController.clear();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _plateController = TextEditingController();
    _classController = TextEditingController();
    _colorController = TextEditingController();
    _modelController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _plateController.dispose();
    _classController.dispose();
    _colorController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusPlate.unfocus();
        _focusClass.unfocus();
        _focusColor.unfocus();
        _focusModel.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          shadowColor: const Color.fromARGB(100, 158, 158, 158),
          backgroundColor: ksecondary,
          elevation: 0,
          foregroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Add Car",
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              AppBarAvatar()
            ],
          ),
          leading: Builder(builder: (context) {
            return Container(
              width: 25,
              height: 25,
              margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 4),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                // onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  Get.back();
                },
              ),
            );
          }),
        ),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Plate Number'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _plateController,
                            focusNode: _focusPlate,
                            decoration: const InputDecoration(
                              isDense: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Enter plate number',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Class'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _classController,
                            focusNode: _focusClass,
                            decoration: const InputDecoration(
                              isDense: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Enter class',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Model'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _modelController,
                            focusNode: _focusModel,
                            decoration: const InputDecoration(
                              isDense: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Enter model',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Color'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _colorController,
                            focusNode: _focusColor,
                            decoration: const InputDecoration(
                              isDense: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Enter color',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const SizedBox(height: 18),
                      CustomElevatedButton(
                        onTap: _addCar,
                        text: "ADD CAR",
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
