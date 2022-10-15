import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  const Empty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                height: 8,
              ),
              Icon(Icons.no_accounts_outlined),
              SizedBox(
                width: 5,
              ),
              Text(
                "There are no drivers yet.",
                style: TextStyle(
                    fontFamily: "Spartan",
                    color:
                        Color.fromARGB(255, 24, 24, 24),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
  }
}