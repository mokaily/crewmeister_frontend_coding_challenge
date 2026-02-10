import 'dart:async';

import 'package:crewmeister_frontend_coding_challenge/core/locatlizations/app_strings.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/presentation/bloc/absences_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../form_search_field_widget.dart';
import 'filter_date_button_widget.dart';
import 'filter_select_button_widget.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final List<String> initialTypes;
  final List<String> initialStatuses;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const FilterBottomSheetWidget({
    super.key,
    required this.initialTypes,
    required this.initialStatuses,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  State<FilterBottomSheetWidget> createState() => _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late List<String> _selectedTypes;
  late List<String> _selectedStatuses;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _selectedTypes = List.from(widget.initialTypes);
    _selectedStatuses = List.from(widget.initialStatuses);
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;

    _updatePreview();
  }

  void _updatePreview() {
    context.read<AbsencesBloc>().add(
      PreviewFilterCountEvent(
        types: _selectedTypes,
        statuses: _selectedStatuses,
        startDate: _startDate,
        endDate: _endDate,
        memberName: _searchController.text,
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _updatePreview();
    });
  }

  void closeBottomSheet(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _toggle(List<String> list, String value) {
    setState(() {
      list.contains(value) ? list.remove(value) : list.add(value);
    });
    _updatePreview();
  }

  Widget _sectionTitle(String text) {
    return Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 60,
            height: 8,
            margin: const EdgeInsets.only(top: 8, bottom: 12),
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppStrings.filterTitle, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.close)),
              ],
            ),
          ),

          const Divider(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Member
                  _sectionTitle("Search Member"),
                  const SizedBox(height: 8),
                  FormSearchFieldWidget(searchController: _searchController, onAction: _onSearchChanged),
                  const SizedBox(height: 24),

                  /// Absence Type
                  _sectionTitle(AppStrings.absenceType),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilterSelectButtonWidget(
                        label: AppStrings.vacation,
                        selected: _selectedTypes.contains('vacation'),
                        onTap: () => _toggle(_selectedTypes, 'vacation'),
                      ),
                      FilterSelectButtonWidget(
                        label: AppStrings.sickness,
                        selected: _selectedTypes.contains('sickness'),
                        onTap: () => _toggle(_selectedTypes, 'sickness'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Status
                  _sectionTitle(AppStrings.statusType),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    children: [
                      FilterSelectButtonWidget(
                        label: AppStrings.requested,
                        selected: _selectedStatuses.contains('requested'),
                        onTap: () => _toggle(_selectedStatuses, 'requested'),
                      ),
                      FilterSelectButtonWidget(
                        label: AppStrings.confirmed,
                        selected: _selectedStatuses.contains('confirmed'),
                        onTap: () => _toggle(_selectedStatuses, 'confirmed'),
                      ),
                      FilterSelectButtonWidget(
                        label: AppStrings.rejected,
                        selected: _selectedStatuses.contains('rejected'),
                        onTap: () => _toggle(_selectedStatuses, 'rejected'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Date Range
                  _sectionTitle(AppStrings.dateRange),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FilterDateButtonWidget(
                          label: AppStrings.fromDate,
                          date: _startDate,
                          onDateSelected: (date) {
                            setState(() {
                              _startDate = date;
                            });
                            _updatePreview();
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_forward, size: 18, color: Colors.grey),
                      ),
                      Expanded(
                        child: FilterDateButtonWidget(
                          label: AppStrings.toDate,
                          date: _endDate,
                          onDateSelected: (date) {
                            setState(() {
                              _endDate = date;
                            });
                            _updatePreview();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          /// Bottom CTA
          BlocBuilder<AbsencesBloc, AbsencesState>(
            builder: (context, state) {
              final count = state is AbsencesLoaded ? state.filterPreviewCount : null;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AbsencesBloc>().add(
                            ApplyFiltersEvent(
                              types: _selectedTypes,
                              statuses: _selectedStatuses,
                              startDate: _startDate,
                              endDate: _endDate,
                              memberName: _searchController.text,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: Text(AppStrings.showResultsCount(count.toString())),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedTypes.clear();
                            _selectedStatuses.clear();
                            _startDate = null;
                            _endDate = null;
                          });
                          _updatePreview();
                        },
                        child: Text(AppStrings.clearFilters),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
