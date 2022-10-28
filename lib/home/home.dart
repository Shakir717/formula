import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formula/const/colors.dart';
import 'package:formula/preset/preset.dart';
import 'package:formula/widgets/custom_dropdown_button.dart';
import 'package:formula/widgets/toast.dart';
import '../database/shared_prefs_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {


  int seconds=0,minutes=0,hours=0;
  String digitSeconds='00',digitMinutes='00',digitHours='00';
  Timer? timer;
  bool started=false;


  /// formula values
  double _time = 25;
  double _break=0;
  double intrest=0;
  double overage=0;
  double energy=0;
  double tt=0;


  formula( PresetModel presetModel){


    debugPrint('stop timer value:$minutes');

    /// how energetic you are
    energy=one?-0.1:two?0:0.1;

    debugPrint('energy value:$energy');

    intrest=presetModel.interest==1? 0:
    presetModel.interest==2? 0.05:
    presetModel.interest==3 ?0.1:
    presetModel.interest==4? 0.15 :0.2;

    debugPrint('interest value:$intrest');

    /// calculate overage
    overage=overage>0?overage-1:0;
    debugPrint('overage value:$overage');

    /// _time is prefix time 25min
    double t=(_time+overage)*(1+energy);

    debugPrint('time after time+overage * 1+ energy:$t');

    double temp= t * (1+energy);
    debugPrint('temp value:$temp');

    if(temp<10){
      tt=10;
    }else{
      tt=temp;
    }

    /// save time for future
    storage.saveToDisk('time', tt.toInt());
    _time=tt;

    ///reset
    _break=0;
    intrest=0;
    overage=0;
    energy=0;
    tt=0;
    setState((){});
  }


  /// start timer function
  void start(){
    reset();
    if(mounted){
      started=true;
      timer= Timer.periodic(const Duration(seconds: 1), (timer) {
        int localSeconds=seconds+1;
        int localMinutes=minutes;
        int localHours=hours;
        if(localSeconds > 59){
          if(localMinutes>59){
            localHours++;
            localMinutes=0;
          }else{
            localMinutes++;
            localSeconds=0;
          }
        }
        setState((){
          seconds=localSeconds;
          minutes=localMinutes;
          hours=localHours;
          digitSeconds=(seconds>10)?'$seconds':'0$seconds';
          digitMinutes=(minutes>10)?'$minutes':'0$minutes';
          digitHours=(hours>10)?'$hours':'0$hours';
        });
      });
    }

  }


  /// stop timer function
  void stop(){
    setState((){
      timer!.cancel();
      started=false;
    });

  }

  /// reset function
  void reset(){
    if(timer !=null){
      timer!.cancel();
    }
    timer=null;
    setState((){
      seconds=0;
      minutes=0;
      hours=0;
      digitSeconds='00';
      digitMinutes='00';
      digitHours='00';
      started=false;
    });
  }





  updatePresetList(){
    List encodedList=storage.getFromDisk('list')??[];

    if (kDebugMode) {
      print(encodedList);
    }

    final list =storage.decodeList(encodedList);
    preset.clear();
    preset.addAll(list);
    setState((){});

  }

  bool enableEnergetic=false;
  final CountDownController _controller = CountDownController();


  List<PresetModel> preset=[];
  final storage=LocalStorageService();
  @override
  void initState(){
    updateTime();
    super.initState();
  }


  updateTime(){

    double min =double.parse((storage.getFromDisk('time')??25).toString());
    _time=min;
    updatePresetList();
    setState((){});

  }

  @override
  Widget build(BuildContext context) {
    final dropdownValue=ref.watch(dropDownValueProvide);
    return Scaffold(
      backgroundColor: blue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:blue,
        centerTitle: true,
        title: Container(
          width: 200,
          height: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: white)
          ),
          child: CustomDropDownButton(
            title: 'preset', items: preset,
          ),
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: skyBlue,
        child: DrawerHeader(
          child:ListTile(
          onTap: ()async{

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Preset()),
            );

          },
          title: const Text('Preset',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
        ), ),
      ),

      body: Column(children:[
        const SizedBox(height: 20,),
        Text('${(_time).toInt()} min',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: white),),
        const SizedBox(height:8,),
      //   Center(
      //     child: CircularCountDownTimer(
      //     // Countdown duration in Seconds.
      //     duration:50000,
      //
      //     // Countdown initial elapsed Duration in Seconds.
      //     initialDuration: 0,
      //
      //     // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
      //     controller: _controller,
      //
      //     // Width of the Countdown Widget.
      //     width: MediaQuery.of(context).size.width / 2,
      //
      //     // Height of the Countdown Widget.
      //     height: MediaQuery.of(context).size.height / 4,
      //
      //     // Ring Color for Countdown Widget.
      //     ringColor: Colors.grey[300]!,
      //
      //     // Ring Gradient for Countdown Widget.
      //     ringGradient: null,
      //
      //     // Filling Color for Countdown Widget.
      //     fillColor: skyBlue,
      //
      //     // Filling Gradient for Countdown Widget.
      //     fillGradient: null,
      //
      //     // Background Color for Countdown Widget.
      //     backgroundColor: blue,
      //
      //     // Background Gradient for Countdown Widget.
      //     backgroundGradient: null,
      //
      //     // Border Thickness of the Countdown Ring.
      //     strokeWidth: 20.0,
      //
      //     // Begin and end contours with a flat edge and no extension.
      //     strokeCap: StrokeCap.round,
      //
      //     // Text Style for Countdown Text.
      //     textStyle: const TextStyle(
      //       fontSize: 33.0,
      //       color: Colors.white,
      //       fontWeight: FontWeight.bold,
      //     ),
      //
      //     // Format for the Countdown Text.
      //     textFormat: CountdownTextFormat.S,
      //
      //     // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
      //     isReverse: false,
      //
      //     // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
      //     isReverseAnimation: false,
      //
      //     // Handles visibility of the Countdown Text.
      //     isTimerTextShown: true,
      //
      //     // Handles the timer start.
      //     autoStart: false,
      //
      //     // This Callback will execute when the Countdown Starts.
      //     onStart: () {
      //       // Here, do whatever you want
      //       debugPrint('Countdown Started');
      //     },
      //
      //     // This Callback will execute when the Countdown Ends.
      //     onComplete: () {
      //       // Here, do whatever you want
      //       debugPrint('Countdown Ended');
      //     },
      // ),
      //   ),

        Container(
          width: 300,
          height: 100,

          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: blue,
            border: Border.all(color: white.withOpacity(.3),width: 2)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("$digitHours:$digitMinutes:$digitSeconds",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold,color: white),),
              Text("   hh    min   sec ",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: white),),

            ],
          ),),
        const SizedBox(height: 20,),
        // start stop
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 30,
            ),
            _button(title: "Start", onPressed: (){
              if(dropdownValue.title.isNotEmpty){
                start();
              }else{
                showToast(message: 'please select value from dropdown');
              }
            }),
            const SizedBox(
              width: 30,
            ),
            _button(title:"Stop",onPressed: (){
                stop();
                formula(dropdownValue);
              // final time=_controller.getTime();
              // if(int.parse(time)>0){
              //   _controller.pause();
              //
              //
              //   final t=int.parse(time)/60;
              //   if(t > _time){
              //     overage=t-_time;
              //
              //   }
              //   setState((){
              //     enableEnergetic=false;
              //   });
              //   formula(int.parse(time),dropdownValue);
              //   _controller.restart();
              //   _controller.pause();
              // }else{
              //   showToast(message: 'please start timer ');
              // }


            }),
            // const SizedBox(
            //   width: 10,
            // ),
           // _button(title: "Resume", onPressed: () => _controller.resume()),
            const SizedBox(
              width: 10,
            ),
           //  SizedBox(width: 30,),
           //  _button(
           //      title: "Stop",
           //      onPressed: () => _controller.restart(duration: _duration)),
            const SizedBox(
              width: 30,
            ),
          ],
        ),
        const SizedBox(height: 20,),

        Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: double.maxFinite,
            child: OutlinedButton(
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

                }, child:Text('Start Break',style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: white),)),
          ),
        ),
        const SizedBox(height: 80,),
        if(started)...[
          Text('How energetic you are?',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: white),),
          const SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  [
            IconButton(onPressed:(){
              energeticUpdate(1);
            },
              icon: Icon(Icons.battery_0_bar,color: one?white:Colors.grey,size: 40,),),

            IconButton(onPressed:(){
              energeticUpdate(2);
            },
              icon:Icon(Icons.battery_full,color: two?white:Colors.grey,size: 40,),
            ),


            IconButton(onPressed:(){
              energeticUpdate(3);
            },
              icon:Icon(Icons.electric_bolt,color: three?white:Colors.grey,size: 40,),),


          ],)
        ]
      ],),
    );
  }
  bool one=false,two=true,three=false;

  energeticUpdate(int i){
    switch(i) {
      case 1: {
        setState((){
          two=false;
          three=false;
          one=true;
        });
        // statements;
      }
      break;

      case 2: {
        setState((){
          two=true;
          three=false;
          one=false;
        });      }
      break;

      case 3: {
        setState((){
          two=false;
          three=true;
          one=false;
        });
      }
      break;

      default: {
        setState((){
          two=false;
          three=true;
          one=false;
        });
      }
      break;
    }
  }
  Widget _button({required String title, VoidCallback? onPressed}) {
    return Expanded(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.purple),
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }

}
