import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          const _GreenBox(),
          const _HeaderIcon(),
          const _BottomIcon(),
          child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top:30),
        child: Image.asset('assets/siagro_logoc.png', scale: 3,),
        ),
      );    
  }
}
class _BottomIcon extends StatelessWidget {
  const _BottomIcon();
  @override
  
  Widget build(BuildContext context) {
    double opacidad = 0.8;
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top:564),
        
        child: Opacity(
          opacity: opacidad,
          child:Image.asset('assets/uniport2.jpg', scale: 2,),
          )
        ),
      );    
  }
}

class _GreenBox extends StatelessWidget {
  const _GreenBox();

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 1,
      decoration: _greenBackground(),
      child: const Stack(
        children: [
          Positioned(top:290, left: 5,child: _Bubble(),),
          Positioned(top:220, right: 5,child: _Bubble(),),
          Positioned(top:500, right: -25,child: _Bubble(),),
          Positioned(top:500, left: -25,child: _Bubble(),),
          Positioned(top:-40, left: -30,child: _Bubble(),),
          Positioned(top:-50, right: -20,child: _Bubble(),),

        ],
      ),
    );
  }

  BoxDecoration _greenBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(244, 246, 244, 1),
          Color.fromRGBO(244, 246, 244, 1),
        ]
      )
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.orangeAccent
      ),
    );
  }
}