import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_al_sam_v02/chatarra/model/chatarra_enum.dart';
import 'package:v_al_sam_v02/chatarra/model/chatarra_reg_enum.dart';
import 'package:v_al_sam_v02/chatarra/model/chatarra_registros.dart';

import '../../bloc/main_bloc.dart';
import '../../models/mm60_b.dart';

class RowMaterialChatarra extends StatefulWidget {
  final int index;
  final ChatarraReg chatarraReg;
  final bool edit;
  const RowMaterialChatarra({
    required this.index,
    required this.chatarraReg,
    required this.edit,
    super.key,
  });

  @override
  State<RowMaterialChatarra> createState() => _RowMaterialChatarraState();
}

class _RowMaterialChatarraState extends State<RowMaterialChatarra> {
  TextEditingController ctdController = TextEditingController();
  late ChatarraReg data;
  late int index;
  late bool edit;

  @override
  void initState() {
    data = widget.chatarraReg;
    index = widget.index;
    edit = !widget.edit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        data = state.chatarra!.items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            height: 40,
            child: Row(
              // key: UniqueKey(),
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(data.item),
                SizedBox(width: 5),
                Expanded(
                  flex: 2,
                  child: Autocomplete<Mm60SingleB>(
                    // initialValue: e4eInit,
                    displayStringForOption: (option) {
                      return option.material;
                    },
                    optionsBuilder: (textEditingValue) {
                      return state.mm60B!.mm60List.where(
                        (e) =>
                            e.precio == '0' &&
                            e.material.length == 6 &&
                            e.material.toLowerCase().contains(
                              textEditingValue.text.toLowerCase(),
                            ),
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      if (edit) {
                        return SizedBox();
                      }
                      return Material(
                        child: SizedBox(
                          width: 300,
                          child: ListView.builder(
                            itemCount: options.length,
                            itemBuilder: (context, i) {
                              Mm60SingleB option = options.toList()[i];
                              String textOption =
                                  '${option.material} - ${option.descripcion}';
                              return ListTile(
                                title: Text(
                                  textOption,
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  onSelected(options.toList()[i]);
                                  context
                                      .read<MainBloc>()
                                      .chatarraCtrl
                                      .cambiarCampos
                                      .changeChatarra(
                                        index: '$index',
                                        campo: CampoChatarra.items,
                                        campoReg: CampoChatarraReg.e4e,
                                        value: options.toList()[i].material,
                                      );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                    fieldViewBuilder: (
                      context,
                      textEditingController,
                      focusNode,
                      onFieldSubmitted,
                    ) {
                      // if (e4eInit.text.isNotEmpty && e4eInit.text.length == 6) {
                      // textEditingController.text = e4eInit.text;

                      textEditingController.value = textEditingController.value
                          .copyWith(
                            text: data.e4e,
                            selection: TextSelection.collapsed(
                              offset: data.e4e.length,
                            ),
                          );
                      // }
                      return TextFormField(
                        controller:
                            textEditingController, // Required by autocomplete
                        focusNode: focusNode, // Required by autocomplete
                        readOnly: edit,
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: 'E4E',
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: data.e4eError),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: data.e4eError,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (edit) {
                            context
                                .read<MainBloc>()
                                .chatarraCtrl
                                .cambiarCampos
                                .changeChatarra(
                                  index: '$index',
                                  campo: CampoChatarra.items,
                                  campoReg: CampoChatarraReg.e4e,
                                  value: value,
                                );
                          }
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    data.descripcion,
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    data.um,
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Text('UMB'),
                Expanded(
                  flex: 2,
                  child: Builder(
                    builder: (context) {
                      ctdController.value = ctdController.value.copyWith(
                        text: data.ctd,
                        selection: TextSelection.collapsed(
                          offset: data.ctd.length,
                        ),
                      );
                      return TextFormField(
                        readOnly: edit,
                        controller: ctdController,
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: 'Ctd',
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: data.ctdError),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: data.ctdError,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          context.read<MainBloc>().chatarraCtrl.cambiarCampos.changeChatarra(
                            index: '$index',
                            campo: CampoChatarra.items,
                            campoReg: CampoChatarraReg.ctd,
                            value: value,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
