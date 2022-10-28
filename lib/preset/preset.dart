import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formula/const/colors.dart';
import 'package:formula/database/shared_prefs_service.dart';
import 'package:formula/home/home.dart';
import 'package:formula/widgets/custom_textfield.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:formula/widgets/toast.dart';

class Preset extends ConsumerStatefulWidget {
  const Preset({Key? key}) : super(key: key);

  @override
  ConsumerState<Preset> createState() => _PresetState();
}

class _PresetState extends ConsumerState<Preset> {
final title=TextEditingController();
double rating=3;
List<PresetModel> presetList=[];
final storage=LocalStorageService();
@override
  void initState() {
  updatePresetList();
  super.initState();

  }

updatePresetList(){
 List encodedList=storage.getFromDisk('list')??[];
 print(encodedList);
 final list =storage.decodeList(encodedList);
 presetList.addAll(list);

}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: blue,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          icon: Icon(Icons.arrow_back,color: white,),
        ),
        elevation: 0,
        backgroundColor: skyBlue,
        centerTitle: true,
        title: const Text('Preset',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
       actions: [
         GestureDetector(
             onTap: (){
               storage.clearCache();
               presetList.clear();
               ref.read(presetListProvider.notifier).state=<PresetModel>[];
               setState((){});
             },
             child: Center(child: const Text('Clear  ',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),))),
       ],
      ),
      bottomSheet: Container(
        color: blue,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(color: white,),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: CustomTextField(
                      controller: title, text: 'Enter Title'),
                ),
              ),
            ),
            const SizedBox(height: 12,),
            Row(
              children: [
                Text('  Interest',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: white),),
                const SizedBox(width: 8,),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return const Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: Colors.white,
                        );
                      case 1:
                        return const Icon(
                          Icons.sentiment_dissatisfied,
                          color: Colors.white,                    );
                      case 2:
                        return const Icon(
                          Icons.sentiment_neutral,
                          color: Colors.white,                    );
                      case 3:
                        return const Icon(
                          Icons.sentiment_satisfied,
                          color: Colors.white,                    );
                      case 4:
                        return const Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.white,                    );
                    }
                    return const SizedBox();
                  },
                  onRatingUpdate: (r) {
                    setState((){
                      rating=r;
                    });
                    if (kDebugMode) {
                      print(rating);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12,),

            Container(
              width: double.maxFinite,
              height: 80,
              color: skyBlue,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  OutlinedButton(

                    style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(color:white)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.white,width: 2),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                      onPressed: (){
                      if(title.text.isNotEmpty){
                        final  priest=PresetModel(title.text, rating);
                        presetList.add(priest);
                        final encodedList=storage.encodeList(presetList);
                        storage.saveToDisk('list', encodedList);
                        title.clear();
                        ref.read(presetListProvider.notifier).state=presetList;
                        setState((){});
                      }else{
                        showToast(message: 'Please enter title');
                      }
                      }, child:Text('        +        ',style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold,color: white),))

              ],),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 200),
          shrinkWrap: true,
          itemCount: presetList.length,
          itemBuilder: (_,i){
            final preset=presetList[i];
            return Column(
              children: [
                ListTile(
                  title: Text(preset.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: white),),
                  subtitle: customInterest(preset.interest),
                ),
                Divider(color: white,),
              ],
            );
          }
      ),
    );
  }
  customInterest(double value){
    return Row(
      children: [
        Text('  Interest',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: white),),
        const SizedBox(width: 8,),
        RatingBar.builder(
          initialRating: value,
          minRating: 1,
          itemCount: 5,
          ignoreGestures: true,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return const Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.white,
                );
              case 1:
                return const Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.white,                    );
              case 2:
                return const Icon(
                  Icons.sentiment_neutral,
                  color: Colors.white,                    );
              case 3:
                return const Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.white,                    );
              case 4:
                return const Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.white,                    );
            }
            return const SizedBox();
          },
          onRatingUpdate: (r) {
            // setState((){
            //   rating=r;
            // });
            // if (kDebugMode) {
            //   print(rating);
            // }
          },
        ),
      ],
    );
  }
}
class PresetModel{
  String title;
  double interest;

  PresetModel(this.title, this.interest);

  factory PresetModel.fromJson(Map<String,dynamic> data){
    return PresetModel(data['title'], data['interest']);
  }
  static Map<String,dynamic> toJson(PresetModel presetModel){
    return {'title':presetModel.title,'interest':presetModel.interest};
  }
}

final presetListProvider=StateProvider((ref) => <PresetModel>[]);

final presetTimeProvider=StateProvider((ref) => 25);