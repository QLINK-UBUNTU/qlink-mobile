import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlink/widgets/notifiers.dart';

class LineAnimationHandler extends StatefulWidget {
  const LineAnimationHandler({Key? key}) : super(key: key);

  @override
  State<LineAnimationHandler> createState() => _LineAnimationHandlerState();
}

class _LineAnimationHandlerState extends State<LineAnimationHandler> with TickerProviderStateMixin {

  AnimationController? lineAnimationController;
  Animation? lineAnimation;

  @override
  void initState(){
    super.initState();
    LineNotifier lineNotifier = Provider.of<LineNotifier>(context, listen: false);


    lineAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), );
    lineAnimation = CurvedAnimation(
      parent: lineAnimationController!,
      curve: Curves.linear)
      ..addListener( () {
          lineNotifier.lineAnimationValue = lineAnimationController!.value;
          if (lineAnimationController!.value == 1.0){
            stopLineAnimation(lineNotifier);
          }
      }
    );
    startLineAnimation(lineNotifier);
  }

  void startLineAnimation(LineNotifier lineNotifier){
    lineAnimationController!.forward(from: 0);
  }

  void stopLineAnimation(LineNotifier lineNotifier){
    lineAnimationController!.stop();
    startLineAnimation(lineNotifier);
  }

  @override
  void dispose(){
    lineAnimationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
