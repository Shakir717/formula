import 'package:flutter/material.dart';
import 'package:formula/const/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({Key? key, this.validator, required this.controller, required this.text, this.inputDecoration,  this.editingComplete=false,this.readOnly=false, this.onTap, this.maxLine=1, this.inputType, this.onChanged,  this.onFieldSubmitted}) : super(key: key);
 final String? Function(String?)? validator;
 final TextEditingController controller;
 final String text;
 final InputDecoration? inputDecoration;
 final bool editingComplete,readOnly;
 final Function()? onTap;
 final int maxLine;
 final TextInputType? inputType;
 final String? Function(String)? onChanged;
 final String? Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    return TextFormField(
      onChanged:onChanged,
      style: TextStyle(color: white),
      onFieldSubmitted: onFieldSubmitted,
      keyboardType:inputType,
      maxLines: maxLine,
      readOnly:readOnly,
      onTap: onTap,
      validator:validator,
      controller: controller,
      textInputAction:(editingComplete) ? TextInputAction.done:TextInputAction.next,
      onEditingComplete:()=> (editingComplete) ? focus.unfocus():focus.nextFocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration:inputDecoration?? InputDecoration(
        enabled: true,
        enabledBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        hintStyle:TextStyle(color: white),
        helperStyle: TextStyle(color: white),
        floatingLabelStyle: TextStyle(color: white),
        labelStyle: TextStyle(color: white),
        labelText: text,

      )
    );
  }
}
