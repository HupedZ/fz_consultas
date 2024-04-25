import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fz_consultas/screens/respuesta_screen.dart';
import 'package:postgres/postgres.dart';

class CodigoParaImagen { 
  final String codei;


  CodigoParaImagen({
    required this.codei,

  });
}

class ResultadoBusqueda { 
  final String code;
  final String refe;
  final String articulo;
  final double stock;
  final int stockd;
  final double precioc;
  final double precio;
  final String ubica;
  final String? imgurl;

  ResultadoBusqueda({
    required this.ubica,
    required this.code,
    required this.refe,
    required this.articulo,
    required this.stockd,
    required this.stock,
    required this.precioc,
    required this.precio,
    required this.imgurl,
  });
}

class DBProvider extends ChangeNotifier{
  /*bool? _completed;
  final Completer<void> _primaryCompleter = Completer<void>();
  Completer<void>? _secondaryCompleter;*/
  
Future<void> iniciar(BuildContext context, String usuario, String password) async {   
    print ("entre a initialize");
  
  final conn = await _connect();

  try {
      await conn.open();
      print("Conexión exitosa");
      final results1 = await conn.query(
        'SELECT * FROM vendedor WHERE vdd_codigo = @nombre AND vdd_clave = @contrasena',
        substitutionValues: {'nombre': usuario, 'contrasena': password},
      );
      
      if (results1.isNotEmpty) {
        print('Inicio de Sesión correcta');
        Navigator.pushReplacementNamed(context, 'consulta');
      } else {
        print('Credenciales incorrectas');
      }
    } catch (e) {
      print("Error durante la conexión: $e");
    } finally {
      await conn.close();
      notifyListeners();
      //_complete();
    }  
  
}
Future<List<ResultadoBusqueda>> consultarR(BuildContext context, String referencia, String valorDelTextFormField) async {
    final conn = await _connect();
    List<ResultadoBusqueda> resultados = [];

    try {
      await conn.open();
      print("Conexión exitosa");

      final results = await conn.query(
        'SELECT art_codigo, art_descri, art_barra, art_cospro, art_preven, art_unidad, sto_cantid, sto_deposi, art_ubica, art_imagen FROM articulo, stock WHERE sto_cantid>0 and sto_articu = art_codigo and art_barra LIKE @ref',
        substitutionValues: {'ref': '%$referencia%'},
      );


      for (var row in results) {
      resultados.add(ResultadoBusqueda(
      code: row[0] as String,
      refe: row[2] as String,
      articulo: row[1] as String,
      stock: double.parse(row[6] as String),
      stockd: int.parse(row[7] as String),
      precioc: double.parse(row[3] as String),  // Convertir a double
      precio: double.parse(row[4] as String), // Convertir a double
      ubica: row[8] as String,
      imgurl: row[9] as String?,
      ));
 }
      

      if (resultados.isNotEmpty) {
        print('Búsqueda realizada correctamente');
        print(resultados);
        Navigator.push(context, MaterialPageRoute(builder: (context) => RespuestaForm(resultados: resultados, currentIndex: 0,  busquedaText: valorDelTextFormField,)));
      } else {
        print('Referencia o Código inválido');
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text('¡Referencia Invalida!'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
      }
    } catch (e) {
      print("Error durante la conexión: $e");
    } finally {
      await conn.close();
      //notifyListeners();
    }
    return resultados;
  }

    
  

Future<List<ResultadoBusqueda>> consultarC(BuildContext context, String codigo, String valorDelTextFormField) async {
    final conn = await _connect();
    List<ResultadoBusqueda> resultados = [];
    try {
      await conn.open();
      print("Conexión exitosa");

      final results = await conn.query(
        'SELECT art_codigo, art_descri, art_barra, art_cospro, art_preven, art_unidad, sto_cantid, sto_deposi, art_ubica, art_imagen FROM articulo, stock WHERE sto_cantid>0 and sto_articu = art_codigo and art_codigo = @codigo',
        substitutionValues: {'codigo': codigo},
      );

      

      for (var row in results) {
      resultados.add(ResultadoBusqueda(
      code: row[0] as String,
      refe: row[2] as String,
      articulo: row[1] as String,
      stock: double.parse(row[6] as String),
      stockd: int.parse(row[7] as String),
      precioc: double.parse(row[3] as String),  // Convertir a double
      precio: double.parse(row[4] as String), // Convertir a double
      ubica: row[8] as String,
      imgurl: row[9] as String,
      ));
      
 }

      if (resultados.isNotEmpty) {
        print('Búsqueda realizada correctamente');
        Navigator.push(context, MaterialPageRoute(builder: (context) => RespuestaForm(resultados: resultados, currentIndex: 0,  busquedaText: valorDelTextFormField,)));
      } else {
        print('Referencia o Código inválido');
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text('¡Codigo Invalido!'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
      }
    } catch (e) {
      print("Error durante la conexión: $e");
    } finally {
      await conn.close();
      //notifyListeners();
    }
    return resultados;
  }

Future<void> eliminarImagen(String codigo) async {
  final conn = await _connect();

  try {
    await conn.open();
    print("Conexión exitosa");

    // Actualizar el campo de imagen en la tabla de artículos
    await conn.execute(
      'UPDATE articulo SET art_imagen = NULL WHERE art_codigo = @codigo',
      substitutionValues: {'codigo': codigo},
    );

    // Eliminar la entrada de imagen de la otra tabla
    await conn.execute(
      'DELETE FROM imagenes WHERE img_articu = @codigo',
      substitutionValues: {'codigo': codigo},
    );

    print('Registro de imagen eliminado correctamente');
  } catch (e) {
    print("Error al eliminar el registro de imagen: $e");
  } finally {
    await conn.close();
  }
}

Future<void> actualizarRegistro(String nuevoImageUrl, String codigo) async {
  final conn = await _connect();

  try {
    await conn.open();
    print("Conexión exitosa");

    // Actualizar el campo de imagen en la primera tabla
    await conn.execute(
      'UPDATE articulo SET art_imagen = @imageUrl WHERE art_codigo = @codigo',
      substitutionValues: {'imageUrl': nuevoImageUrl, 'codigo': codigo},
    );

    // Insertar en la otra tabla con la misma URL de imagen
    await conn.execute(
      'INSERT INTO imagenes (img_articu, img_url) VALUES (@codigo, @imageUrl)',
      substitutionValues: {'imageUrl': nuevoImageUrl, 'codigo': codigo},
    );

    print('Registro actualizado y nueva inserción realizada correctamente');
  } catch (e) {
    print("Error durante la actualización del registro e inserción en otra tabla: $e");
  } finally {
    await conn.close();
  }
  

}

Future<PostgreSQLConnection> _connect() async {
    return PostgreSQLConnection(
      '170.254.216.73',
      5432,
      'dbsiagro',
      username: 'postgres',
      password: 'siagro2024',
    );
  }
}


/*void _complete() {
    assert(_completed == true);
    _completed = true;
    _primaryCompleter.complete();
    _secondaryCompleter?.complete();
  }*/