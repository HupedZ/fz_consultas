import 'package:flutter/material.dart';
import 'package:fz_consultas/postgre/conection_database.dart';
import 'package:fz_consultas/providers/consulta_form_provider.dart';
import 'package:fz_consultas/providers/login_form_provider.dart';
import 'package:fz_consultas/screens/consulta_screen.dart';
import 'package:fz_consultas/screens/iniciarsesion_screen.dart';
import 'package:fz_consultas/screens/respuesta_screen.dart';
import 'package:provider/provider.dart';
void main() async{ 

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DBProvider()),
        ChangeNotifierProvider(create: (_) => ConsultaFormProvider()),
        ChangeNotifierProvider(create: (_) => LoginFormProvider()),
        // Otros providers que puedas tener
      ],
      child: const MyApp(),
    ),
  );
  }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fz Consultas',
      //home: const IniciarsesionScreen(),
      initialRoute: 'iniciarsesion',
      routes:{
        'iniciarsesion': (BuildContext context) => const IniciarsesionScreen(),
        'consulta'     : (BuildContext context) => const ConsultaScreen(),
        'respuesta'    : (BuildContext context) => const RespuestaForm(resultados: [], currentIndex: 0, busquedaText: '',),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300]
      ),
      
    );
    
  }
}
