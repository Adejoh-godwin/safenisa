import 'package:flutter/material.dart';


circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 20.0),
    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.amberAccent)),
  );
}

linearProgress() {
 return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 20.0),
    child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.amberAccent)),
  );
}
