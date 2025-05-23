import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class TextFieldComponent extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool isPassword;
  final bool isRequired;
  final String? Function(String?)? validator;
  final Function(String _)? onChanged;
  final TextInputType keyboardType;
  final int maxLength;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final Widget? prefixWidget;
  final Color? fillColor;
  final Color? labelColor;
  final Color? borderColor;
  final Color? cursorColor;
  final Color? focusColor;
  final bool enlargePrfixWidget;
  final bool readOnly;
  final bool enabled;
  final double fontSize;
  final int maxLines;
  final int minLines;
  final void Function()? onTap;
  final FocusNode? currentFocus;
  final FocusNode? nextFocus;
  final EdgeInsetsGeometry? padding;
  final bool isSmall;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final List<TextInputFormatter>? formatter;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final TextCapitalization textCapitalization;
  final bool enableSuggestions;
  final bool autocorrect;
  final void Function()? onEditingComplete;
  final Widget? subText;
  final bool showLimit;
  final InputBorder? border;

  const TextFieldComponent({
    this.onEditingComplete,
    this.controller,
    super.key,
    this.hintText,
    this.labelText,
    this.isPassword = false,
    this.isRequired = false,
    this.showLimit = false,
    this.validator,
    this.onChanged(String _)?,
    this.keyboardType = TextInputType.text,
    this.maxLength = 30,
    this.suffixIcon,
    this.fontSize = 12,
    this.onSuffixPressed,
    this.prefixWidget,
    this.onTap,
    this.fillColor,
    this.borderColor = Colors.transparent,
    this.focusColor = Colors.transparent,
    this.labelColor = Colors.black,
    this.cursorColor,
    this.enlargePrfixWidget = true,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.currentFocus,
    this.nextFocus,
    this.padding,
    this.isSmall = false,
    this.hintTextStyle,
    this.textStyle,
    this.formatter,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.center,
    this.textCapitalization = TextCapitalization.words,
    this.autocorrect = false,
    this.enableSuggestions = true,
    this.minLines = 1,
    this.subText,
    this.border,
  });

  @override
  State<TextFieldComponent> createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return widget.isSmall == false
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _showLabelText(),
              SizedBox(height: 8,),
              Center(child: _textField(context)),
            ],
          )
        : _textField(context);
  }

  Widget _textField(BuildContext context) {
    return TextFormField(
      cursorColor: widget.cursorColor,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      controller: widget.controller,
      readOnly: widget.readOnly,
      focusNode: widget.currentFocus,
      enableSuggestions: widget.isPassword ? false : true,
      autocorrect: widget.autocorrect,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: widget.enabled,
      obscureText: widget.isPassword ? _hidePassword : !_hidePassword,
      maxLength: widget.maxLength,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.nextFocus != null
          ? TextInputAction.next
          : TextInputAction.done,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete ??
          () {
            widget.currentFocus?.unfocus();
            if (widget.nextFocus != null) {
              widget.nextFocus?.requestFocus();
            }
          },
      onFieldSubmitted: (v) {
        widget.currentFocus?.unfocus();
        if (widget.nextFocus != null) {
          widget.nextFocus?.requestFocus();
        }
      },
      style: widget.textStyle ??
          TextStyle(color: Colors.white),
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.formatter,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      decoration: InputDecoration(
        counterText: widget.showLimit ? null : '',
        filled: true,
        errorMaxLines: 2,
        fillColor: widget.fillColor ?? Colors.amber,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),

        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: widget.padding ??
            EdgeInsetsDirectional.only(
                start: 16,
                top: 16,
                bottom: 15,
                end: widget.suffixIcon != null ? 0 : 16),
        hintText: widget.hintText ?? '',
        // hintStyle: widget.hintTextStyle ?? context.titleSmall,
        hintStyle: widget.hintTextStyle ??
            TextStyle(color: Colors.white),
        prefixIcon: widget.prefixWidget != null
            ? SizedBox(
                width: widget.enlargePrfixWidget ? 32 : null,
                child: widget.prefixWidget,
              )
            : null,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isPassword)
              GestureDetector(
                child: _hidePassword
                    ? const Icon(Icons.visibility_off, color: Colors.white)
                    : const Icon(Icons.visibility, color: Colors.white),
                onTap: () {
                  setState(() {
                    _hidePassword = !_hidePassword;
                  });
                },
              ),
            if (widget.isPassword && widget.suffixIcon != null) const SizedBox(height: 5,),
            if (widget.suffixIcon != null)
              GestureDetector(
                onTap: widget.onSuffixPressed,
                child: widget.suffixIcon,
              ),
          ],
        ),
      ),
    );
  }

  Widget _showLabelText() {
    if (widget.labelText != null) {
      return Row(
        children: [
          Text(
            widget.labelText!,
            style: TextStyle(
              color: widget.labelColor,
              fontSize: widget.fontSize,
            ),
          ),
          if (widget.subText != null) ...[
            const Spacer(),
            widget.subText!,
          ],
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

class TextFieldComponentNew extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool isPassword;
  final bool isRequired;
  final String? Function(String?)? validator;
  final Function(String _)? onChanged;
  final TextInputType keyboardType;
  final int maxLength;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final Widget? prefixWidget;
  final Color? fillColor;
  final Color? labelColor;
  final Color? borderColor;
  final Color? cursorColor;
  final Color? focusColor;
  final bool enlargePrfixWidget;
  final bool readOnly;
  final bool enabled;
  final double fontSize;
  final int maxLines;
  final int minLines;
  final void Function()? onTap;
  final FocusNode? currentFocus;
  final FocusNode? nextFocus;
  final EdgeInsetsGeometry? padding;
  final bool isSmall;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final List<TextInputFormatter>? formatter;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final TextCapitalization textCapitalization;
  final bool enableSuggestions;
  final bool autocorrect;
  final void Function()? onEditingComplete;
  final Widget? subText;
  final bool showLimit;
  final InputBorder? border;

  const TextFieldComponentNew({
    this.onEditingComplete,
    this.controller,
    super.key,
    this.hintText,
    this.labelText,
    this.isPassword = false,
    this.isRequired = false,
    this.showLimit = false,
    this.validator,
    this.onChanged(String _)?,
    this.keyboardType = TextInputType.text,
    this.maxLength = 30,
    this.suffixIcon,
    this.fontSize = 12,
    this.onSuffixPressed,
    this.prefixWidget,
    this.onTap,
    this.fillColor,
    this.borderColor = Colors.transparent,
    this.focusColor = Colors.transparent,
    this.labelColor = Colors.black,
    this.cursorColor,
    this.enlargePrfixWidget = true,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.currentFocus,
    this.nextFocus,
    this.padding,
    this.isSmall = false,
    this.hintTextStyle,
    this.textStyle,
    this.formatter,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.center,
    this.textCapitalization = TextCapitalization.words,
    this.autocorrect = false,
    this.enableSuggestions = true,
    this.minLines = 1,
    this.subText,
    this.border,
  });

  @override
  State<TextFieldComponentNew> createState() => _TextFieldComponentNewState();
}

class _TextFieldComponentNewState extends State<TextFieldComponentNew> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return widget.isSmall == false
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _showLabelText(),
              SizedBox(height: 8,),
              Center(child: _textField(context)),
            ],
          )
        : _textField(context);
  }

  Widget _textField(BuildContext context) {
    return TextFormField(
      cursorColor: widget.cursorColor,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      controller: widget.controller,
      readOnly: widget.readOnly,
      focusNode: widget.currentFocus,
      enableSuggestions: widget.isPassword ? false : true,
      autocorrect: widget.autocorrect,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: widget.enabled,
      obscureText: widget.isPassword ? _hidePassword : !_hidePassword,
      maxLength: widget.maxLength,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.nextFocus != null
          ? TextInputAction.next
          : TextInputAction.done,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete ??
          () {
            widget.currentFocus?.unfocus();
            if (widget.nextFocus != null) {
              widget.nextFocus?.requestFocus();
            }
          },
      onFieldSubmitted: (v) {
        widget.currentFocus?.unfocus();
        if (widget.nextFocus != null) {
          widget.nextFocus?.requestFocus();
        }
      },
      style: widget.textStyle,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.formatter,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      decoration: InputDecoration(
        counterText: widget.showLimit ? null : '',
        filled: true,
        errorMaxLines: 2,
        fillColor: widget.fillColor ?? Colors.purple,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),

        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: widget.padding ??
            EdgeInsetsDirectional.only(
                start: 16,
                top: 16,
                bottom: 15,
                end: widget.suffixIcon != null ? 0 : 16),
        hintText: widget.hintText ?? '',
        // hintStyle: widget.hintTextStyle ?? context.titleSmall,
        hintStyle: widget.hintTextStyle,
        //   context.titleSmall?.copyWith(color: Colors.white),
        prefixIcon: widget.prefixWidget != null
            ? SizedBox(
                width: widget.enlargePrfixWidget ? 32 : null,
                child: widget.prefixWidget,
              )
            : null,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isPassword)
              GestureDetector(
                child: _hidePassword
                    ? const Icon(Icons.visibility_off, color: Colors.white)
                    : const Icon(Icons.visibility, color: Colors.white),
                onTap: () {
                  setState(() {
                    _hidePassword = !_hidePassword;
                  });
                },
              ),
            if (widget.isPassword && widget.suffixIcon != null) const SizedBox(height: 5,),
            if (widget.suffixIcon != null)
              GestureDetector(
                onTap: widget.onSuffixPressed,
                child: widget.suffixIcon,
              ),
          ],
        ),
      ),
    );
  }

  Widget _showLabelText() {
    if (widget.labelText != null) {
      return Row(
        children: [
          Text(
            widget.labelText!,
            style: TextStyle(
              color: widget.labelColor,
              fontSize: widget.fontSize,
            ),
          ),
          if (widget.subText != null) ...[
            const Spacer(),
            widget.subText!,
          ],
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
