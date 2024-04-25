import 'package:flutter/material.dart';

class CardCContainer extends StatelessWidget {

  final Widget child;

  const CardCContainer({
    super.key, 
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric( horizontal: 30 ),
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.all( 20 ),
          decoration: _createCardShape(),
          child: child,
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
    color: Color.fromARGB(255, 255, 247, 226),
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 15,
        offset: Offset(0, 5),
      )
    ],
    border: Border.all(color: Colors.orange, width: 2)
  );
}