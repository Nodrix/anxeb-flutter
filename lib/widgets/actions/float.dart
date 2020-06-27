import 'package:flutter/material.dart';

class FloatAction extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;
  final bool disabled;
  final bool visible;

  FloatAction({this.color, this.icon, this.onPressed, this.disabled, this.visible});

  @override
  _FloatActionState createState() => _FloatActionState();
}

class _FloatActionState extends State<FloatAction> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.visible == false) {
      return Container();
    }
    return AbsorbPointer(
      absorbing: widget.disabled,
      child: Opacity(
        opacity: widget.disabled == true ? 0.6 : 1,
        child: FloatingActionButton(
          onPressed: widget.onPressed,
          backgroundColor: widget.color,
          child: Icon(widget.icon),
        ),
      ),
    );
  }
}