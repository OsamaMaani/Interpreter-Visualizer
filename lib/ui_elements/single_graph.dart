import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/graphite.dart';


class SingleGraph extends StatefulWidget {
  final int statementIndex;
  final int index;
  final double duration;
  final AnimationController animationController;
  SingleGraph(this.index, this.statementIndex, this.animationController, this.duration);

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



    const presetBasic0 = '[{"id":"A","next":[]}]';
    const presetBasic1 = '[{"id":"A","next":["B"]},{"id":"B","next":[]}]';
    const presetBasic2 = '[{"id":"A","next":["B", "C"]},{"id":"B","next":[]}, {"id":"C","next":[]}]';
    const presetBasic3 = '[{"id":"A","next":["B", "C"]},{"id":"B","next":["D"]}, {"id":"C","next":[]}, {"id":"D","next":[]}]';

    List listOfJSON1 = [presetBasic0, presetBasic1, presetBasic2, presetBasic3];


    var p0 = '[{"next":[],"id":"0"}]';
    var p1 = '[{"next":["1"],"id":"0"},{"next":[],"id":"1"}]';
    var p2 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":[],"id":"2"}]';
    var p3 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":[],"id":"3"}]';
    var p4 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":[],"id":"4"}]';
    var p5 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":[],"id":"5"}]';
    var p6 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":[],"id":"6"}]';
    var p7 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":[],"id":"7"}]';
    var p8 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":[],"id":"8"}]';
    var p9 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":["9"],"id":"8"},{"next":[],"id":"9"}]';
    var p10 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":["9"],"id":"8"},{"next":["10"],"id":"9"},{"next":[],"id":"10"}]';
    var p11 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":["9"],"id":"8"},{"next":["10"],"id":"9"},{"next":["11"],"id":"10"},{"next":[],"id":"11"}]';
    var p12 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":["9"],"id":"8"},{"next":["10"],"id":"9"},{"next":["11"],"id":"10"},{"next":["12"],"id":"11"},{"next":[],"id":"12"}]';
    var p13 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":["9"],"id":"8"},{"next":["10"],"id":"9"},{"next":["11"],"id":"10"},{"next":["12"],"id":"11"},{"next":[],"id":"12"}]';
    var p14 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":["9"],"id":"8"},{"next":["10"],"id":"9"},{"next":["11"],"id":"10"},{"next":["12"],"id":"11"},{"next":[],"id":"12"}]';
    var p15 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":["9"],"id":"8"},{"next":["10"],"id":"9"},{"next":["11"],"id":"10"},{"next":["12"],"id":"11"},{"next":[],"id":"12"}]';
    var p16 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":["9"],"id":"8"},{"next":["10"],"id":"9"},{"next":["11"],"id":"10"},{"next":["12"],"id":"11"},{"next":[],"id":"12"}]';
    var p17 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":["9"],"id":"8"},{"next":["10"],"id":"9"},{"next":["11"],"id":"10"},{"next":["12"],"id":"11"},{"next":[],"id":"12"}]';
    var p18 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":["9"],"id":"8"},{"next":["10"],"id":"9"},{"next":["11"],"id":"10"},{"next":["12"],"id":"11"},{"next":[],"id":"12"}]';
    var p19 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":["9"],"id":"8"},{"next":["10"],"id":"9"},{"next":["11"],"id":"10"},{"next":["12"],"id":"11"},{"next":[],"id":"12"}]';
    var p20 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":["9"],"id":"8"},{"next":["10"],"id":"9"},{"next":["11"],"id":"10"},{"next":["12"],"id":"11"},{"next":[],"id":"12"}]';
    var p21 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":["9"],"id":"8"},{"next":["10"],"id":"9"},{"next":["11"],"id":"10"},{"next":["12"],"id":"11"},{"next":[],"id":"12"}]';
    var p22 = '[{"next":["1"],"id":"0"},{"next":["2"],"id":"1"},{"next":["3"],"id":"2"},{"next":["4"],"id":"3"},{"next":["5"],"id":"4"},{"next":["6"],"id":"5"},{"next":["7"],"id":"6"},{"next":["8"],"id":"7"},{"next":["9"],"id":"8"},{"next":["10"],"id":"9"},{"next":["11"],"id":"10"},{"next":["12"],"id":"11"},{"next":[],"id":"12"}]';

    List listOfJSON2 = [p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22];


    // const presetBasic = '[{"id":"A","next":["B"]},{"id":"B","next":["C","D","E"]},'
    //     '{"id":"C","next":["F"]},{"id":"D","next":["J"]},{"id":"E","next":["J"]},'
    //     '{"id":"J","next":["I"]},{"id":"I","next":["H"]},{"id":"F","next":["K"]},'
    //     '{"id":"K","next":["L"]},{"id":"H","next":["L"]},{"id":"L","next":["P"]},'
    //     '{"id":"P","next":["M","N"]},{"id":"M","next":[]},{"id":"N","next":[]}]';


    // const presetComplex = '[{"id":"A","next":["B"]},{"id":"U","next":["G"]},'
    //     '{"id":"B","next":["C","D","E","F","M"]},{"id":"C","next":["G"]},'
    //     '{"id":"D","next":["H"]},{"id":"E","next":["H"]},{"id":"F","next":["N","O"]},'
    //     '{"id":"N","next":["I"]},{"id":"O","next":["P"]},{"id":"P","next":["I"]},'
    //     '{"id":"M","next":["L"]},{"id":"G","next":["I"]},{"id":"H","next":["J"]},'
    //     '{"id":"I","next":[]},{"id":"J","next":["K"]},'
    //     '{"id":"K","next":["L"]},{"id":"L","next":[]}]';


    var listOfGraphs = [listOfJSON1, listOfJSON2];

    var graph = nodeInputFromJson(listOfGraphs[widget.statementIndex][widget.index]);
    var newNodeID = ["A", "B", "C", "D"];


    if(_animation.value > 0 && _animation.value < 1){
      // print(widget.index);
    }



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
              backgroundColor: (widget.index.toString() == node.id ? Colors.red : Colors.blue),
              radius: 30.0,
              child: Text(widget.statementIndex.toString()),
              // child: ListView.builder(
              //   itemCount: widget.index + 1,
              //   itemBuilder: (context, index){
              //     return Center(child: Text("Haha" * (index + 1), style: text_style_circle));
              //   },
              // ),
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


