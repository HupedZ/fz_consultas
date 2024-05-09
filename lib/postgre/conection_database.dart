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
  final String? codigoB;

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
    required this.codigoB
  });
}

class DBProvider extends ChangeNotifier{
  /*bool? _completed;
  final Completer<void> _primaryCompleter = Completer<void>();
  Completer<void>? _secondaryCompleter;*/
  
Future<void> iniciar(BuildContext context, String usuario, String password) async {   
  
  final conn = await _connect();

  try {
      await conn.open();
      final results1 = await conn.query(
        'SELECT * FROM vendedor WHERE vdd_codigo = @nombre AND vdd_clave = @contrasena',
        substitutionValues: {'nombre': usuario, 'contrasena': password},
      );
      
      if (results1.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, 'consulta');
      }
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

      final results = await conn.query(
        'SELECT art_codigo, art_descri, art_barra, art_cospro, art_preven, art_unidad, sto_cantid, sto_deposi, art_ubica, art_imagen, art_codbar FROM articulo, stock WHERE sto_articu = art_codigo and art_barra LIKE @ref',
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
      codigoB: row[10]as String?
      ));
 }
      

      if (resultados.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => RespuestaForm(resultados: resultados, currentIndex: 0,  busquedaText: valorDelTextFormField,)));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('¡Referencia Invalida!'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
      }
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

      final results = await conn.query(
        'SELECT art_codigo, art_descri, art_barra, art_cospro, art_preven, art_unidad, sto_cantid, sto_deposi, art_ubica, art_imagen, art_codbar FROM articulo, stock WHERE sto_articu = art_codigo and art_codigo = @codigo',
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
      imgurl: row[9] as String?,
      codigoB: row[10]as String?
      ));
      
 }

      if (resultados.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => RespuestaForm(resultados: resultados, currentIndex: 0,  busquedaText: valorDelTextFormField,)));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('¡Codigo Invalido!'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
      }
    } finally {
      await conn.close();
      //notifyListeners();
    }
    return resultados;
  }

Future<List<ResultadoBusqueda>> consultarU(BuildContext context, String ubicacion, String valorDelTextFormField) async {
    final conn = await _connect();
    List<ResultadoBusqueda> resultados = [];
    try {
      await conn.open();

      final results = await conn.query(
        'SELECT art_codigo, art_descri, art_barra, art_cospro, art_preven, art_unidad, sto_cantid, sto_deposi, art_ubica, art_imagen, art_codbar FROM articulo, stock WHERE sto_articu = art_codigo and art_ubica = @ubicacion',
        substitutionValues: {'ubicacion': ubicacion},
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
      codigoB: row[10]as String?
      ));
      
 }

      if (resultados.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => RespuestaForm(resultados: resultados, currentIndex: 0,  busquedaText: valorDelTextFormField,)));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('¡Codigo Invalido!'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
      }
    } finally {
      await conn.close();
      //notifyListeners();
    }
    return resultados;
  }

Future<List<ResultadoBusqueda>> consultarB(BuildContext context, String codigoBarra, String valorDelTextFormField) async {
    final conn = await _connect();
    List<ResultadoBusqueda> resultados = [];
    try {
      await conn.open();

      final results = await conn.query(
        'SELECT art_codigo, art_descri, art_barra, art_cospro, art_preven, art_unidad, sto_cantid, sto_deposi, art_ubica, art_imagen, art_codbar FROM articulo, stock WHERE sto_articu = art_codigo and art_codbar = @codigoBarra',
        substitutionValues: {'codigobarra': codigoBarra},
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
      codigoB: row[10]as String?
      ));
      
 }

      if (resultados.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => RespuestaForm(resultados: resultados, currentIndex: 0,  busquedaText: valorDelTextFormField,)));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('¡Codigo Invalido!'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
      }
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
  }finally {
    await conn.close();
  }
}
Future<void> actualizarinventario(String conteo, codigo, stockd, stock, time) async {
  final conn = await _connect();

  try {
    await conn.open();

    // Actualizar el campo de imagen en la tabla de artículos
    await conn.execute(
      'INSERT INTO inven (inv_articu, inv_conteo, inv_deposi, inv_stock, inv_fechah) VALUES (@codigo, @conteo, @stockd, @stock, @hora)',
      substitutionValues: {'codigo': codigo, 'conteo' : conteo, 'stockd' : stockd, 'stock' : stock,'hora' : time },
    );
  } finally {
    await conn.close();
  }
}

Future<void> actualizarRegistro(String nuevoImageUrl, String codigo) async {
  final conn = await _connect();

  try {
    await conn.open();

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