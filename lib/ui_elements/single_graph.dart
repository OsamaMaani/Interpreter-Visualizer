import 'package:flutter/material.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/graphite.dart';


class SingleGraph extends StatefulWidget {
  final int _index;
  SingleGraph(this._index);
  
  @override
  _SingleGraphState createState() => _SingleGraphState();
}

class _SingleGraphState extends State<SingleGraph> with SingleTickerProviderStateMixin{

  Animation<double> animation;
  AnimationController animationController;


  @override
  void initState() {
    animationController = AnimationController(
      duration:Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    
    animation.addStatusListener((status) {
      setState(() {});
    });

    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    const presetBasic = '[{"id":"A","next":["B"]},{"id":"B","next":["C","D","E"]},'
        '{"id":"C","next":["F"]},{"id":"D","next":["J"]},{"id":"E","next":["J"]},'
        '{"id":"J","next":["I"]},{"id":"I","next":["H"]},{"id":"F","next":["K"]},'
        '{"id":"K","next":["L"]},{"id":"H","next":["L"]},{"id":"L","next":["P"]},'
        '{"id":"P","next":["M","N"]},{"id":"M","next":[]},{"id":"N","next":[]}]';

    const presetComplex = '[{"id":"A","next":["B"]},{"id":"U","next":["G"]},'
        '{"id":"B","next":["C","D","E","F","M"]},{"id":"C","next":["G"]},'
        '{"id":"D","next":["H"]},{"id":"E","next":["H"]},{"id":"F","next":["N","O"]},'
        '{"id":"N","next":["I"]},{"id":"O","next":["P"]},{"id":"P","next":["I"]},'
        '{"id":"M","next":["L"]},{"id":"G","next":["I"]},{"id":"H","next":["J"]},'
        '{"id":"I","next":[]},{"id":"J","next":["K"]},'
        '{"id":"K","next":["L"]},{"id":"L","next":[]}]';

    List listOfJSON = [presetBasic, presetBasic, presetComplex];

    var graph = nodeInputFromJson(listOfJSON[widget._index]);

    return Opacity(
      opacity: animation.value,
      child: DirectGraph(
        list: graph,
        cellWidth: 104.0,
        cellPadding: 14.0,
        contactEdgesDistance: 5.0,
        orientation: MatrixOrientation.Vertical,
        pathBuilder: customEdgePathBuilder,
        builder: (ctx, node) {
          return CircleAvatar(
            radius: 30.0,
            child: Center(
              child: Text(
                node.id,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          );
        },
        paintBuilder: (edge) {
          var p = Paint()
            ..color = Colors.blueGrey
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 2;
          return p;
        },
      ),
    );
  }


  Path customEdgePathBuilder(List<List<double>> points) {
    var path = Path();
    path.moveTo(points[0][0], points[0][1]);
    points.sublist(1).forEach((p) {
      path.lineTo(p[0], p[1]);
    });
    return path;
  }

}


