import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formula/const/colors.dart';
import 'package:formula/preset/preset.dart';

class CustomDropDownButton extends ConsumerStatefulWidget {
   List<PresetModel> items;
  String title;
  CustomDropDownButton({Key? key, required this.items,  required this.title,}) : super(key: key);

  @override
  CustomDropDownButtonState createState() => CustomDropDownButtonState();
}

class CustomDropDownButtonState extends ConsumerState<CustomDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<dynamic>(
      decoration: const InputDecoration.collapsed(hintText: ''),
      focusColor:Colors.white,
      dropdownColor: skyBlue.withOpacity(.7),
      //elevation: 5,
      style:  const TextStyle(color: Colors.white),
      iconEnabledColor:Colors.white,
      items:widget.items.map<DropdownMenuItem<dynamic>>((value) {

        return DropdownMenuItem<dynamic>(
          value: value,
          child: Text(value.title,style: const TextStyle(color:Colors.white),),
        );
      }).toList(),
      isExpanded: false,

      hint:Text(widget.title,style: TextStyle(color: white),),
      onChanged: (value) {
         setState(() {
            widget.title = value.title!;
            ref.read(dropDownValueProvide.notifier).state=value;
          });
      },
    );
  }
}
final dropDownValueProvide=StateProvider.autoDispose((ref) => PresetModel('', 1.0));
