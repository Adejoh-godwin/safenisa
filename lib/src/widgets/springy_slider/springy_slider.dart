import 'package:flutter/material.dart';
import 'package:safenisa/src/widgets/springy_slider/slider_controller.dart';
import 'package:safenisa/src/widgets/springy_slider/slider_dragger.dart';
import 'package:safenisa/src/widgets/springy_slider/slider_goo.dart';
import 'package:safenisa/src/widgets/springy_slider/slider_marks.dart';
import 'package:safenisa/src/widgets/springy_slider/slider_points.dart';
import 'package:safenisa/src/widgets/springy_slider/slider_state.dart';

class SpringySlider extends StatefulWidget {
  final int markCount;
  final Color positiveColor;
  final Color negativeColor;

  SpringySlider({
    this.markCount,
    this.positiveColor,
    this.negativeColor,
  });

  @override
  _SpringySliderState createState() => new _SpringySliderState();
}

class _SpringySliderState extends State<SpringySlider>
    with TickerProviderStateMixin {
  final double paddingTop = 50.0;
  final double paddingBottom = 50.0;

  SpringySliderController sliderController;

  @override
  void initState() {
    super.initState();
    sliderController = new SpringySliderController(
      sliderPercent: 0.5,
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    double sliderPercent = sliderController.sliderValue;
    if (sliderController.state == SpringySliderState.springing) {
      sliderPercent = sliderController.springingPercent;
    }

    return SliderDragger(
      sliderController: sliderController,
      paddingTop: paddingTop,
      paddingBottom: paddingBottom,
      child: Stack(
        children: <Widget>[
          SliderMarks(
            markCount: widget.markCount,
            markColor: widget.positiveColor,
            backgroundColor: widget.negativeColor,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
          ),
          SliderGoo(
            sliderController: sliderController,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
            child: SliderMarks(
              markCount: widget.markCount,
              markColor: widget.negativeColor,
              backgroundColor: widget.positiveColor,
              paddingTop: paddingTop,
              paddingBottom: paddingBottom,
            ),
          ),
          new SliderPoints(
            sliderController: sliderController,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
          ),
//          new SliderDebug(
//            sliderPercent: sliderController.state == SpringySliderState.dragging
//                ? sliderController.draggingPercent
//                : sliderPercent,
//            paddingTop: paddingTop,
//            paddingBottom: paddingBottom,
//          ),
        ],
      ),
    );
  }
}
