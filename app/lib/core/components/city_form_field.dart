import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/location.dart';
import '../../services/cities_service.dart';
import 'loading_indicator.dart';

class CityFormField extends StatelessWidget {
  const CityFormField({
    super.key,
    this.initialValue,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.decoration,
    this.textInputAction,
    this.textCapitalization,
  });

  final Location? initialValue;

  final void Function(Location? city)? onSaved;
  final void Function(Location? city)? onChanged;
  final String? Function(Location? city)? validator;

  final InputDecoration? decoration;

  final TextInputAction? textInputAction;

  final TextCapitalization? textCapitalization;

  @override
  Widget build(BuildContext context) {
    return FormField<Location?>(
      initialValue: initialValue,
      onSaved: onSaved,
      validator: validator,
      builder: (state) {
        return Consumer(
          builder: (context, ref, child) {
            final (CityService? cities, Object? error) = ref
                .watch(citiesProvider)
                .when(
                  data: (data) => (data, null),
                  error: (error, _) => (null, error),
                  loading: () => (null, null),
                );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (cities == null && error != null)
                  const LoadingIndicator()
                else
                  _AutoComplete(
                    initialValue: initialValue,
                    onSelected: (city) {
                      state.didChange(city);
                      onChanged?.call(city);
                    },
                    search: (query) => cities?.search(query) ?? [],
                    errorText: state.errorText,
                    decoration: decoration?.copyWith(
                      errorText: state.errorText ?? error?.toString(),
                    ),
                    textInputAction: textInputAction,
                    textCapitalization: textCapitalization,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _AutoComplete extends StatelessWidget {
  const _AutoComplete({
    super.key,
    required this.initialValue,
    required this.onSelected,
    required this.search,
    this.errorText,
    this.decoration,
    this.textInputAction,
    this.textCapitalization,
  });

  final Location? initialValue;
  final void Function(Location? city) onSelected;
  final List<Location> Function(String query) search;
  final String? errorText;

  final InputDecoration? decoration;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Location>(
      initialValue: initialValue != null
          ? TextEditingValue(text: initialValue!.name)
          : null,
      onSelected: onSelected,
      fieldViewBuilder: (_, controller, focusNode, onSubmit) {
        return TextFormField(
          decoration: decoration,
          controller: controller,
          focusNode: focusNode,
          onFieldSubmitted: (_) => onSubmit(),
          textInputAction: textInputAction,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
        );
      },
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Location>.empty();
        }
        return search(textEditingValue.text);
      },
      displayStringForOption: (city) => city.name,
    );
  }
}
