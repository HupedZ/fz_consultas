import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:fz_consultas/postgre/conection_database.dart';
import 'package:fz_consultas/providers/consulta_form_provider.dart';
import 'package:fz_consultas/widgets/cardrespuesta_container.dart';
import 'package:fz_consultas/widgets/respuesta_background.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class RespuestaForm extends StatefulWidget {
  final List<ResultadoBusqueda> resultados;
  final String busquedaText;
  
  const RespuestaForm({Key? key, required this.resultados, required int currentIndex, required this.busquedaText}) : super(key: key);

  @override
  
  _RespuestaFormState createState() => _RespuestaFormState();
}

class _RespuestaFormState extends State<RespuestaForm> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final consultaForm = Provider.of<ConsultaFormProvider>(context);
    print(widget.busquedaText);
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 251, 215, 168),
        title: const Text('Realizar otra consulta'),
      ),
      body: RespuestaBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 70),
              CardRContainer(
                child: Column(
                  children: [
                      MultiProvider(
                        providers: [
                        ChangeNotifierProvider(create: (_) => ConsultaFormProvider(),),
                        
                        ],
                        child: _RespuestaForm(resultados: const [], onIndexChanged: (int ) {  }, currentIndex: 0,),
                  
                    
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                           //Text('Busqueda:${widget.busquedaText}', style: TextStyle(fontSize: 20),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      
                      children: [

                     Text('Busqueda:${widget.busquedaText}', style: TextStyle(fontSize: 20),),
                     SizedBox(width: 100),
                     CupertinoSwitch(
                    value: consultaForm.switchValuer,
                    activeColor: Color.fromARGB(255, 3, 213, 35),
                     onChanged: (bool? value2) {
                     consultaForm.setSwitchValuer(value2 ?? false);
                     },
                     ),
                    //
                     /*FloatingActionButton(
                    child: const Icon(Icons.remove_red_eye),
                    backgroundColor: Colors.orangeAccent,
                    
                      onPressed: (){},
                        ),*/
                    
                    
                      ]
                    ),
                      ]
                    ),
                    const SizedBox(height: 10,),
                    _RespuestaForm(resultados: widget.resultados, currentIndex: currentIndex, onIndexChanged: (newIndex) {
                      setState(() {
                        currentIndex = newIndex;
                      });
                    },),
                    const SizedBox(height: 10,),
                    Text(
                      '${currentIndex + 1}/${widget.resultados.length}',
                      style: TextStyle(fontSize: 16),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RespuestaForm extends StatelessWidget {
  final List<ResultadoBusqueda> resultados;
  final int currentIndex;
  final Function(int) onIndexChanged;

  const _RespuestaForm({Key? key, required this.resultados, required this.currentIndex, required this.onIndexChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final consultaForm = Provider.of<ConsultaFormProvider>(context);

    return Container(
      child: Column(
        children: [
        
       if (resultados.isNotEmpty) 
              CardRContainer(
              child: Column(
                children: [
                  if(resultados[currentIndex].imgurl != null)
                Consumer<ConsultaFormProvider>(
                      builder: (context, imageProvider, _) {
                        return imageProvider.showImage
                             ?Column(
                              children: [
                             Image.network(
                                resultados[currentIndex].imgurl!,
                                width: 300,
                                height: 300,
                              ),
                               IconButton(
                          onPressed: () async {
                            // Mostrar un cuadro de diálogo de confirmación
                            final bool confirmacion = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('¿Estás seguro de eliminar esta imagen?', style: TextStyle(fontSize: 16) ),
                                content: Text('Esta acción no se puede deshacer.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Si el usuario confirma, cerrar el cuadro de diálogo y devolver true
                                      Navigator.pop(context, true);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                      content: Text('¡Imagen Eliminada!'),
                                      backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
                                      ),
                                    );
                                   },
                                    child: Text('Si, quiero eliminar', style: TextStyle(fontSize: 16)),
                                  ),
                                  SizedBox(width: 30,),
                                  TextButton(
                                    onPressed: () {
                                      // Si el usuario cancela, cerrar el cuadro de diálogo y devolver false
                                      Navigator.pop(context, false);
                                    },
                                    child: Text('Cancelar', style: TextStyle(fontSize: 16)),
                                  ),
                                ],
                              ),
                            );

                            // Si el usuario confirmó, eliminar la imagen
                            if (confirmacion == true) {
                              await DBProvider().eliminarImagen(resultados[currentIndex].code);
                            }
                          },
                          icon: Icon(Icons.delete, size: 40, color: Colors.red),
                        ),
                              ]
                            )
                            :   IconButton(
                                onPressed: () {
                                  consultaForm.toggleImageVisibility();
                                },
                                icon: Icon( Icons.remove_red_eye_outlined, size: 40, color: Colors.orange ),
                              );
                      },
                    ),
                  if(resultados[currentIndex].imgurl == null)
                IconButton(
                    onPressed: () async {
                      final result = await showDialog(
                         context: context,
                          builder: (context) => SimpleDialog(
                           title: Text('Seleccionar imagen'),
                           children: [
                              SimpleDialogOption(
                               onPressed: () => Navigator.pop(context, ImageSource.gallery),
                               child: Text('Galería'),
                             ),
                              SimpleDialogOption(
                                onPressed: () => Navigator.pop(context, ImageSource.camera),
                                child: Text('Cámara'),
                              ),
                            ],
                          ),
                       );
                      if (result != null) {
                      final picker = new ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(source: result);
                      final imageUrl = await uploadImage(pickedFile);
                      print(imageUrl);
                      if (imageUrl != null) {
                        // Llamar a la función para actualizar el registro en la base de datos
                      await DBProvider().actualizarRegistro(imageUrl, resultados[currentIndex].code);
                      ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                 content: Text('¡Imagen subida correctamente!'),
                                 backgroundColor: Colors.green, // Puedes personalizar el color de fondo.
                              ),
                            );
                    } else {
                      print('Error al subir la imagen');
                      ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                 content: Text('¡Error al subir la imagen!'),
                                 backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
                              ),
                            );  

                    }
                    };
                    },
                    icon: Icon( Icons.camera_alt_outlined, size: 40, color: Colors.orange ),
                  ),


                  Divider(),
                  ListTile(
                    title: Text(
                      'Codigo: ${resultados[currentIndex].code}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Referencia: ${resultados[currentIndex].refe}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      '${resultados[currentIndex].articulo}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Deposito ${resultados[currentIndex].stockd}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Stock: ${resultados[currentIndex].stock}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Ubicación: ${resultados[currentIndex].ubica}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Divider(),
                  Visibility(
                    visible: (consultaForm.switchValuer),
                    child:   
                    ListTile(
                      title:
                      
                       Text( 
                       'Precio de Costo: ${resultados[currentIndex].precioc}',
                        style: TextStyle(fontSize: 16),
                        
                      ),
                      
                    ),
                    
                  ),
                  Divider(),
                  
                  ListTile(
                    title: Text(
                      'Precio de Venta: ${resultados[currentIndex].precio}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 20),

          Visibility(
            visible: resultados.length > 1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final newIndex = (currentIndex - 1) % resultados.length;
                          onIndexChanged(newIndex < 0 ? resultados.length - 1 : newIndex);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orangeAccent,
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Anterior'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          onIndexChanged((currentIndex + 1) % resultados.length);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orangeAccent,
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Siguiente'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
          
        ],
      ),
    );
  }
    Future<String?> uploadImage(XFile? pickedFile) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dwbayvepu/image/upload?upload_preset=raz9skgp');

    final imageUploadRequest = http.MultipartRequest('POST', url );

    final file = await http.MultipartFile.fromPath('file', pickedFile!.path );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('algo salio mal');
      print( resp.body );
      return null;
    }

    final decodedData = json.decode( resp.body );
    return decodedData['secure_url'];

  }
}