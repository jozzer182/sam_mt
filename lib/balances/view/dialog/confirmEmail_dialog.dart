// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../bloc/main_bloc.dart';

class ConfirmEmailDialog extends StatefulWidget {
  ConfirmEmailDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfirmEmailDialog> createState() => _ConfirmEmailDialogState();
}

class _ConfirmEmailDialogState extends State<ConfirmEmailDialog> {
  String principalEmail = '';
  String copyEmail = '';

  @override
  void initState() {
    copyEmail = context.read<MainBloc>().state.user!.correo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isReady = principalEmail.isNotEmpty &&
        (principalEmail.contains('@enel.com') ||
            principalEmail.contains('@enelcom.onmicrosoft.com')) &&
        copyEmail.isNotEmpty;
    return AlertDialog(
      title: const Text('Confirmar Solicitado'),
      content: Container(
        height: 300,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Se enviará un correo electrónico a los siguientes correos:'),
            SizedBox(height: 10),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  principalEmail = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'xxx.xxx@enel.com',
                labelText: 'Correo Principal (ENEL)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: copyEmail,
              onChanged: (value) {
                setState(() {
                  copyEmail = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Correo de Copia',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: isReady
              ? () => Navigator.pop(
                  context,
                  EmailDialog(
                    principalEmail: principalEmail,
                    copyEmail: copyEmail,
                  ))
              : null,
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}

class EmailDialog {
  String principalEmail;
  String copyEmail;
  EmailDialog({
    required this.principalEmail,
    required this.copyEmail,
  });

  EmailDialog copyWith({
    String? principalEmail,
    String? copyEmail,
  }) {
    return EmailDialog(
      principalEmail: principalEmail ?? this.principalEmail,
      copyEmail: copyEmail ?? this.copyEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'principalEmail': principalEmail,
      'copyEmail': copyEmail,
    };
  }

  factory EmailDialog.fromMap(Map<String, dynamic> map) {
    return EmailDialog(
      principalEmail: map['principalEmail'] as String,
      copyEmail: map['copyEmail'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmailDialog.fromJson(String source) =>
      EmailDialog.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EmailDialog(principalEmail: $principalEmail, copyEmail: $copyEmail)';

  @override
  bool operator ==(covariant EmailDialog other) {
    if (identical(this, other)) return true;

    return other.principalEmail == principalEmail &&
        other.copyEmail == copyEmail;
  }

  @override
  int get hashCode => principalEmail.hashCode ^ copyEmail.hashCode;
}
