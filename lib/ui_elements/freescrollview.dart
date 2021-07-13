import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FreeScrollView extends StatefulWidget {
  final Widget child;
  final ScrollPhysics physics;

  const FreeScrollView(
      {Key key,
      this.physics = const ClampingScrollPhysics(),
      @required this.child})
      : super(key: key);

  @override
  State<FreeScrollView> createState() => _FreeScrollViewState();
}

class _FreeScrollViewState extends State<FreeScrollView> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  final Map<Type, GestureRecognizerFactory> _gestureRecognizers =
      <Type, GestureRecognizerFactory>{};

  @override
  void initState() {
    super.initState();
    _gestureRecognizers[PanGestureRecognizer] =
        GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
            () => PanGestureRecognizer(),
            (instance) => instance
              ..onDown = _handleDragDown
              ..onStart = _handleDragStart
              ..onUpdate = _handleDragUpdate
              ..onEnd = _handleDragEnd
              ..onCancel = _handleDragCancel
              ..minFlingDistance = widget.physics.minFlingDistance
              ..minFlingVelocity = widget.physics.minFlingVelocity
              ..maxFlingVelocity = widget.physics.maxFlingVelocity
              ..velocityTrackerBuilder = ScrollConfiguration.of(context)
                  .velocityTrackerBuilder(context)
              ..dragStartBehavior = DragStartBehavior.start);
  }

  @override
  Widget build(BuildContext context) => Stack(children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizontalController,
            physics: widget.physics,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                // ignore: avoid_redundant_argument_values
                controller: _verticalController,
                physics: widget.physics,
                child: widget.child)),
        Positioned.fill(
            child: RawGestureDetector(
          gestures: _gestureRecognizers,
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
        )),
      ]);

  Drag _horizontalDrag;
  Drag _verticalDrag;
  ScrollHoldController _horizontalHold;
  ScrollHoldController _verticalHold;

  void _handleDragDown(DragDownDetails details) {
    _horizontalHold =
        _horizontalController.position.hold(() => _horizontalHold = null);
    _verticalHold =
        _verticalController.position.hold(() => _verticalHold = null);
  }

  void _handleDragStart(DragStartDetails details) {
    _horizontalDrag = _horizontalController.position
        .drag(details, () => _horizontalDrag = null);
    _verticalDrag =
        _verticalController.position.drag(details, () => _verticalDrag = null);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _horizontalDrag?.update(DragUpdateDetails(
        sourceTimeStamp: details.sourceTimeStamp,
        delta: Offset(details.delta.dx, 0),
        primaryDelta: details.delta.dx,
        globalPosition: details.globalPosition));
    _verticalDrag?.update(DragUpdateDetails(
        sourceTimeStamp: details.sourceTimeStamp,
        delta: Offset(0, details.delta.dy),
        primaryDelta: details.delta.dy,
        globalPosition: details.globalPosition));
  }

  void _handleDragEnd(DragEndDetails details) {
    _horizontalDrag?.end(DragEndDetails(
        velocity: details.velocity,
        primaryVelocity: details.velocity.pixelsPerSecond.dx));
    _verticalDrag?.end(DragEndDetails(
        velocity: details.velocity,
        primaryVelocity: details.velocity.pixelsPerSecond.dy));
  }

  void _handleDragCancel() {
    _horizontalHold?.cancel();
    _horizontalDrag?.cancel();
    _verticalHold?.cancel();
    _verticalDrag?.cancel();
  }
}
