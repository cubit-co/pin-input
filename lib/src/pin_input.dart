import 'package:flutter/material.dart';
import './pin_input_cursor.dart';

/// Cool input with pins
class PinInput extends StatefulWidget {
  final double pinSize;
  final int length;
  final bool obscureText;
  final Color activeColor;
  final TextStyle textStyle;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final String Function(String) validator;
  final void Function(String) onSaved;
  final void Function(String) onFieldSubmitted;

  PinInput({
    this.length = 4,
    this.pinSize = 45.0,
    this.obscureText = true,
    this.keyboardType = TextInputType.number,
    this.activeColor,
    this.textStyle,
    this.controller,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.onFieldSubmitted,
  });

  @override
  _PinInputState createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  // Represents width of each box
  static const double INPUT_BORDER_WIDTH = 2.0;

  TextEditingController _controller;
  ValueNotifier<String> _textControllerValue;

  // Controller for focus
  FocusNode _pinInputFocusNode;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
    _textControllerValue = ValueNotifier(_controller.value.text);
    _pinInputFocusNode = FocusNode();

    _controller?.addListener(_textChangeListener);

    _pinInputFocusNode?.addListener(() {
      setState(() {
        _isFocused = _pinInputFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _pinInputFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _focusPinInput,
      child: Stack(
        children: <Widget>[
          _wrappedTextFormField(),
          _pinInputs(),
        ],
      ),
    );
  }

  /// Wraps TextFormField that the user can't activate
  Widget _wrappedTextFormField() => AbsorbPointer(
        absorbing: true, // Prevent to activate text input
        child: TextFormField(
          maxLength: widget.length,
          onChanged: widget.onChanged,
          focusNode: _pinInputFocusNode,
          controller: _controller,
          keyboardType: TextInputType.number,
          autocorrect: false,
          maxLengthEnforced: true,
          enableSuggestions: false,
          showCursor: false,
          scrollPadding: EdgeInsets.zero,
          enableInteractiveSelection: false,
          validator: widget.validator,
          onSaved: widget.onSaved,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            counterText: '',
          ),
          style: TextStyle(
            color: Colors.transparent,
          ),
        ),
      );

  /// Show boxes in a row
  Widget _pinInputs() {
    return ValueListenableBuilder(
      valueListenable: _textControllerValue,
      builder: (BuildContext context, value, Widget child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: Iterable<int>.generate(widget.length)
              .map((index) => _pinInputItem(
                  withMargin: index < widget.length - 1, index: index))
              .toList(),
        );
      },
    );
  }

  /// Pin item, this will contain each item value
  Widget _pinInputItem({@required bool withMargin, int index}) {
    final pin = _controller.value.text;

    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 250),
      width: widget.pinSize,
      height: widget.pinSize,
      margin: withMargin ? EdgeInsets.only(right: 10) : EdgeInsets.zero,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.pinSize / 5),
          border: Border.all(
              color: _isFocused ? _activeColor : Colors.black38,
              width: INPUT_BORDER_WIDTH)),
      child: Center(
        child: index == pin.length
            ? _isFocused ? PinInputCursor() : null
            : pin.length > index
                ? widget.obscureText
                    ? _pinInputContentObscured()
                    : Text(pin[index], style: _textStyle)
                : Container(),
      ),
    );
  }

  Widget _pinInputContentObscured() {
    final circleDiameter = widget.pinSize * 0.2;

    return Container(
      height: circleDiameter,
      width: circleDiameter,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }

  // Pin input controls
  void _focusPinInput() {
    final focus = FocusScope.of(context);
    if (_pinInputFocusNode.hasFocus) _pinInputFocusNode.unfocus();
    if (focus.hasFocus) focus.unfocus();
    focus.requestFocus(FocusNode());
    Future.delayed(Duration.zero, () => focus.requestFocus(_pinInputFocusNode));
  }

  void _textChangeListener() {
    final String value = _controller.value.text;

    if (value != _textControllerValue.value) {
      try {
        _textControllerValue.value = value;
      } catch (e) {
        _textControllerValue = ValueNotifier(value);
      }
    }
  }

  // Custom class getters
  Color get _activeColor {
    return widget.activeColor ?? Theme.of(context).primaryColor;
  }

  TextStyle get _textStyle {
    return widget.textStyle ?? Theme.of(context).textTheme.subtitle1;
  }
}
