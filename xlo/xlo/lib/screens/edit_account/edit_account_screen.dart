import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xlo/models/user.dart';
import 'package:xlo/screens/edit_account/widgets/user_type_widget.dart';

class editAccountScreen extends StatefulWidget {
  @override
  _editAccountScreenState createState() => _editAccountScreenState();
}

class _editAccountScreenState extends State<editAccountScreen> {

  final User _user = User();

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar conta'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          UserTypeWidget(
            initialValue: _user.userType,
            onSaved: (userType) {

            },
          ),
          TextFormField(
            initialValue: _user.name,
            decoration: _buildDecoration("Nome *"),
            validator: (name) {
              if(name.length < 6)
                return "Nome inválido";
              return null;
            },
            onSaved: (name) {

            },
          ),
          TextFormField(
            initialValue: _user.phone,
            decoration: _buildDecoration("Telefone *"),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              TelefoneInputFormatter() ,
            ],
            validator: (phone) {
              if(phone.length < 15)
                return "Telefone inválido";
              return null;
            },
            onSaved: (phone) {

            },
          ),
          TextFormField(
            obscureText: true,
            decoration: _buildDecoration("Nova senha"),
            validator: (pass) {
              if(pass.isEmpty)
                return null;
              if(pass.length < 6)
                return "Senha muito curta!";
              return null;
            },
            autovalidate: true,
          ),
          TextFormField(
            obscureText: true,
            decoration: _buildDecoration("Repita nova senha"),
            validator: (pass) {
              if(pass.isEmpty)
                return null;
              if(pass.length < 6)
                return "Senha muito curta!";
              return null;
            },
            autovalidate: true,
          ),
        ],
      ),
    );
  }
}
