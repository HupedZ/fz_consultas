
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConsultaFormProvider extends ChangeNotifier {


  GlobalKey<FormState> cformKey = GlobalKey<FormState>();

  String referencia = '';
  String codigo = '';
 
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading( bool value ){
    _isLoading = value;
    notifyListeners();
  }
  bool _switchValue = false;
  
  bool get switchValue => _switchValue;

  void setSwitchValue(bool value) {
    _switchValue = value;
    notifyListeners();
  }
  bool _switchValuer = false;
  
  bool get switchValuer => _switchValuer;

  void setSwitchValuer(bool value2) {
    _switchValuer = value2;
    notifyListeners();
  }

  bool isValidForm(){
    print(cformKey.currentState?.validate());
    //print('aqui entre en ingresar');
    return cformKey.currentState?.validate() ?? false;
  }
  bool _showImage = false;

  bool get showImage => _showImage;

  void toggleImageVisibility() {
    _showImage = !_showImage;
    notifyListeners();
  }
  
}


