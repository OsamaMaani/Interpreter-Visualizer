import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/graphite.dart';


class SingleGraph extends StatefulWidget {
  final int index;
  final double duration;
  final AnimationController animationController;
  SingleGraph(this.index, this.animationController, this.duration);

  @override
  _SingleGraphState createState() => _SingleGraphState();
}

class _SingleGraphState extends State<SingleGraph> with SingleTickerProviderStateMixin{
  Animation _animation;
  double start;
  double end;

  @override
  void initState() {
    super.initState();
    start = (widget.duration * widget.index ).toDouble();
    end = start + widget.duration;
    print("START $start , end $end");
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          start,
          end,
          curve: Curves.easeInOutCirc,
        ),
      ),
    )..addListener((){
      setState(() {
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    const presetBasic = '[{"id":"A","next":["B"]},{"id":"B","next":["C","D","E"]},'
        '{"id":"C","next":["F"]},{"id":"D","next":["J"]},{"id":"E","next":["J"]},'
        '{"id":"J","next":["I"]},{"id":"I","next":["H"]},{"id":"F","next":["K"]},'
        '{"id":"K","next":["L"]},{"id":"H","next":["L"]},{"id":"L","next":["P"]},'
        '{"id":"P","next":["M","N"]},{"id":"M","next":[]},{"id":"N","next":[]}]';

    const presetBasic0 = '[{"id":"A","next":[]}]';
    const presetBasic1 = '[{"id":"A","next":["B"]},{"id":"B","next":[]}]';
    const presetBasic2 = '[{"id":"A","next":["B", "C"]},{"id":"B","next":[]}, {"id":"C","next":[]}]';
    const presetBasic3 = '[{"id":"A","next":["B", "C"]},{"id":"B","next":["D"]}, {"id":"C","next":[]}, {"id":"D","next":[]}]';

    const presetComplex = '[{"id":"A","next":["B"]},{"id":"U","next":["G"]},'
        '{"id":"B","next":["C","D","E","F","M"]},{"id":"C","next":["G"]},'
        '{"id":"D","next":["H"]},{"id":"E","next":["H"]},{"id":"F","next":["N","O"]},'
        '{"id":"N","next":["I"]},{"id":"O","next":["P"]},{"id":"P","next":["I"]},'
        '{"id":"M","next":["L"]},{"id":"G","next":["I"]},{"id":"H","next":["J"]},'
        '{"id":"I","next":[]},{"id":"J","next":["K"]},'
        '{"id":"K","next":["L"]},{"id":"L","next":[]}]';

    List listOfJSON = [presetBasic0, presetBasic1, presetBasic2, presetBasic3, presetComplex];

    var graph = nodeInputFromJson(listOfJSON[widget.index]);
    var newNodeID = ["A", "B", "C", "D"];

    return Opacity(
      opacity: _animation.value,
      // opacity: animation,
      child: AbsorbPointer(absorbing: true,
        child: DirectGraph(
          list: graph,
          cellWidth: 120.0,
          cellPadding: 14.0,
          contactEdgesDistance: 5.0,
          orientation: MatrixOrientation.Vertical,
          pathBuilder: customEdgePathBuilder,
          builder: (ctx, node) {
            return CircleAvatar(
              backgroundColor: (newNodeID[widget.index] == node.id ? Colors.red : Colors.blue),
              radius: 30.0,
              child: ListView.builder(
                itemCount: widget.index + 1,
                itemBuilder: (context, index){
                  return Center(child: Text("Haha" * (index + 1), style: text_style_circle));
                },
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


