import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ButtonOptions {
  const ButtonOptions({
    required this.textStyle,
    this.elevation,
    this.height = 55,
    this.width = double.infinity,
    this.padding,
    this.color,
    this.disabledColor,
    this.disabledTextColor,
    this.splashColor,
    this.iconSize,
    this.iconColor,
    this.iconPadding,
    this.borderRadius,
    this.borderSide,
  });

  final TextStyle? textStyle;
  final double? elevation;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final Color? splashColor;
  final double? iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? iconPadding;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
}

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconData,
    required this.options,
    this.showLoadingIndicator = true,
    this.isOutline = false,
  }) : super(key: key);

  final String text;
  final Widget? icon;
  final IconData? iconData;
  final Function() onPressed;
  final ButtonOptions options;
  final bool showLoadingIndicator;
  final bool isOutline;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Widget textWidget = loading
        ? Center(
            child: SizedBox(
              width: 23,
              height: 23,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.options.textStyle!.color ?? Colors.white,
                ),
              ),
            ),
          )
        : AutoSizeText(
            widget.text,
            style: widget.options.textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );

    final onPressed = widget.showLoadingIndicator
        ? () async {
            if (loading) {
              return;
            }
            setState(() => loading = true);
            try {
              await widget.onPressed();
            } finally {
              if (mounted) {
                setState(() => loading = false);
              }
            }
          }
        : () => widget.onPressed();

    ButtonStyle style = ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: widget.options.borderRadius ?? BorderRadius.circular(8),
          side: widget.options.borderSide ?? BorderSide.none,
        ),
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return widget.options.disabledTextColor;
          }
          return widget.options.textStyle!.color;
        },
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return widget.options.disabledColor;
          }
          return widget.options.color;
        },
      ),
      overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.pressed)) {
          return widget.options.splashColor;
        }
        return null;
      }),
      padding: MaterialStateProperty.all(widget.options.padding ??
          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0)),
      elevation:
          MaterialStateProperty.all<double>(widget.options.elevation ?? 0),
    );

    if (widget.icon != null || widget.iconData != null) {
      return SizedBox(
        height: widget.options.height,
        width: widget.options.width,
        child: ElevatedButton.icon(
          icon: Padding(
            padding: widget.options.iconPadding ?? EdgeInsets.zero,
            child: widget.icon ??
                Icon(
                  widget.iconData,
                  size: widget.options.iconSize,
                  color: widget.options.iconColor ??
                      widget.options.textStyle!.color,
                ),
          ),
          label: textWidget,
          onPressed: onPressed,
          style: style,
        ),
      );
    }

    return SizedBox(
      height: widget.options.height,
      width: widget.options.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: textWidget,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final double width, height;
  final Color? color;
  final Color? textColor;
  final bool isOutline;
  const CustomButton(
      {required this.text,
      required this.onPressed,
      this.height = 55,
      this.width = double.infinity,
      this.color,
      this.isOutline = false,
      this.textColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: onPressed,
      text: text,
      options: ButtonOptions(
        width: width,
        height: height,
        color: color ?? Theme.of(context).primaryColor,
        textStyle: getButtonTextStyle(context, textColor ?? Colors.white),
        elevation: 0,
        borderSide: const BorderSide(color: Colors.transparent, width: 1),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String text;
  final Color? boarderSideColor;
  final Color? buttonInerColor;
  final Function() onPressed;
  const OutlineButton(
      {required this.text,
      required this.onPressed,
      super.key,
      this.boarderSideColor,
      this.buttonInerColor});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
        text: text,
        onPressed: onPressed,
        options: ButtonOptions(
            borderRadius: BorderRadius.circular(50),
            borderSide:
                BorderSide(color: boarderSideColor ?? Colors.white, width: 2),
            color: buttonInerColor ?? Colors.transparent,
            textStyle: getButtonTextStyle(context, Colors.white)));
  }
}

class RoundButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final double? width, height;
  final Color? color;
  final Color? textColor;
  final bool isOutline;
  final IconData? iconData;
  final Widget? icon;
  final double radius;
  final double padding;
  const RoundButton(
      {required this.text,
      required this.onPressed,
      this.height = 45,
      this.width,
      this.color,
      this.isOutline = false,
      this.textColor,
      this.iconData,
      this.icon,
      this.radius = 32,
      this.padding = 10,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(radius),
        border: isOutline ? getBorder(context) : null,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null || iconData != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: icon ??
                      Icon(
                        iconData,
                        size: 24,
                        color: textColor ?? Colors.white,
                      ),
                ),
              Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getButtonTextStyle(context, textColor ?? Colors.white)
                    .copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle getButtonTextStyle(BuildContext context, Color textColor) =>
    TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600);

getBorder(BuildContext context) => BorderSide(
      color: Theme.of(context).primaryColor,
      width: 2,
    );
