import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/cities.dart';
import '../../services/cities_provider.dart';
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
  });

  final City? initialValue;

  final void Function(City? city)? onSaved;
  final void Function(City? city)? onChanged;
  final String? Function(City? city)? validator;

  final InputDecoration? decoration;

  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return FormField<City?>(
      initialValue: initialValue,
      onSaved: onSaved,
      validator: validator,
      builder: (state) {
        return Consumer(
          builder: (context, ref, child) {
            final (Cities? cities, Object? error) = ref
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
  });

  final City? initialValue;
  final void Function(City? city) onSelected;
  final List<City> Function(String query) search;
  final String? errorText;

  final InputDecoration? decoration;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<City>(
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
        );
      },
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<City>.empty();
        }
        return search(textEditingValue.text);
      },
      displayStringForOption: (city) => city.name,
    );
  }
}
