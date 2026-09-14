import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

TextFormField TextFormFieldSearch(BuildContext context,
    {TextEditingController? controller,
    ValueChanged<String>? onFieldSubmitted,
    ValueChanged<String>? onChanged}) {
  String val = controller?.text ?? "";
  return TextFormField(
    controller: controller,
    textAlign: TextAlign.right,
    keyboardType: TextInputType.name,
    textInputAction: TextInputAction.go,
    onFieldSubmitted: onFieldSubmitted,
    onChanged: onChanged,
    decoration: commonInputDecoration(
      suffixIcon: Icon(
        Icons.search,
        size: 20,
      ),
      prefixIcon: val.isEmpty
          ? null
          : IconButton(
              onPressed: () {
                val = "";
                controller?.text = "";
                controller?.clear;
                if (onFieldSubmitted != null) onFieldSubmitted("");
                if (onChanged != null) onChanged("");

                FocusScope.of(context).unfocus();
              },
              icon: Icon(Icons.clear),
            ),
      // hintText: AppLocalizations.of(context)!.search_for_products,
    ),
  );
}

InputDecoration commonInputDecoration(
    {String? hintText, Widget? prefixIcon, Widget? suffixIcon}) {
  return InputDecoration(
    filled: true,
    // fillColor: Colors.grey.withOpacity(0.1),
    hintText: hintText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    // hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
    contentPadding: EdgeInsets.symmetric(horizontal: 16),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
  );
}
