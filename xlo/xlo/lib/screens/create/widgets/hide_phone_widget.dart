import 'package:flutter/material.dart';

class HidePhoneWidget extends FormField<bool> {


  HidePhoneWidget({FormFieldSetter<bool> onSaved, bool initialValue}) : super(
    initialValue: initialValue,
    onSaved: onSaved,
    builder: (state) {
      return Padding(
          padding: const EdgeInsets.all(9),
          child: Row(
            children: <Widget>[
              Checkbox(
                  value: state.value,
                  onChanged: (boolean) {
                    state.didChange(boolean);
                  }
              ),
              const Text("Ocultar o seu telefone neste anúncio"),

            ],
          ),
      );
    }
  );


}