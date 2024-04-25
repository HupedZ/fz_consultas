import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fz_consultas/postgre/conection_database.dart';
import 'package:fz_consultas/providers/consulta_form_provider.dart';
import 'package:fz_consultas/providers/login_form_provider.dart';
//import 'package:fz_consultas/ui/input_decorations.dart';
import 'package:fz_consultas/ui/inputc_decorations.dart';
//import 'package:fz_consultas/widgets/card_container.dart';
import 'package:fz_consultas/widgets/cardconsulta_container.dart';
import 'package:fz_consultas/widgets/consulta_background.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';

class ConsultaScreen extends StatelessWidget {
   
  const ConsultaScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConsultaBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height:300),


              CardCContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text('Consulta', style: Theme.of(context).textTheme.headlineMedium,),
                    const SizedBox(height: 30,),

                    MultiProvider(
                        providers: [
                        ChangeNotifierProvider(create: (_) => DBProvider(),),
                        ChangeNotifierProvider(create: (_) => ConsultaFormProvider(),),
                        ChangeNotifierProvider(create: (_) => LoginFormProvider(), ),
                        ],
                        child: _ConsultaForm(),
                  
                    
                    )   
                                     
                  ]
                  
                )
              ),
            ],
          ),
        ),
        ),
    );
  }
}
// ignore: must_be_immutable
class _ConsultaForm extends StatelessWidget  {
  String? valorDelTextFormField;
  

  
  
  @override
  Widget build(BuildContext context) {
    DBProvider dbprovider = Provider.of<DBProvider>(context);
    final consultaForm = Provider.of<ConsultaFormProvider>(context);
    return Container(
      child: Form(
        key: consultaForm.cformKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputcDecorations.consultaInputDecoration(
                hintText: '',
                labelText: consultaForm.switchValue ? 'Buscar por Código' : 'Buscar por Referencia',
                prefixIcon: Icons.search
              ),
              onChanged: ( value ) {
                if (consultaForm.switchValue) {
                consultaForm.codigo = value;
                } else {
              consultaForm.referencia = value;
              }
              valorDelTextFormField = value;
              },
              validator: ( value ) {
      
                    return ( value != null && value.isNotEmpty ) 
                      ? null
                      : '';                                    
                    
                },
                
      
            ),
            const SizedBox(height: 10,),

             const Text('Buscar por Código'),



            CupertinoSwitch(
              value: consultaForm.switchValue,
              activeColor: Color.fromARGB(255, 3, 213, 35),
              onChanged: (bool? value) {
                consultaForm.setSwitchValue(value ?? false);
              },
            ),


              
            
            

             MaterialButton(             
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.orangeAccent,
              onPressed: consultaForm.isLoading ? null : () async {
                if (!consultaForm.isValidForm()) return ;
                print('abajo de return del if');
  
                
                
                 

                FocusScope.of(context).unfocus();

                if (consultaForm.switchValue) {
                  try{
                 // Si el switch está activado
                await dbprovider.consultarC(context, consultaForm.codigo, valorDelTextFormField!);

                  }catch(e){                   
                    print(e);
                  }
                } else {
               // Si el switch está desactivado
                await dbprovider.consultarR(context, consultaForm.referencia, valorDelTextFormField!);
              }
              },
              
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  consultaForm.isLoading
                    ? 'Espere'
                    : 'Buscar',
                  style: const TextStyle(color: Colors.white),
                  ),
                  
                  
              ) 
              
              )
              
              

          ],
          
        ),
        
       ),
       
    );
    
  }
}
