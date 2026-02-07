import 'package:crewmeister_frontend_coding_challenge/features/absences/presentation/bloc/absences_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      ),
    );
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
                const Text('Filter Absences', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                  /// Absence Type
                  _sectionTitle('Absence Type'),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilterSelectButtonWidget(
                        label: 'Vacation',
                        selected: _selectedTypes.contains('vacation'),
                        onTap: () => _toggle(_selectedTypes, 'vacation'),
                      ),
                      FilterSelectButtonWidget(
                        label: 'Sickness',
                        selected: _selectedTypes.contains('sickness'),
                        onTap: () => _toggle(_selectedTypes, 'sickness'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Status
                  _sectionTitle('Status'),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    children: [
                      FilterSelectButtonWidget(
                        label: 'Requested',
                        selected: _selectedStatuses.contains('requested'),
                        onTap: () => _toggle(_selectedStatuses, 'requested'),
                      ),
                      FilterSelectButtonWidget(
                        label: 'Confirmed',
                        selected: _selectedStatuses.contains('confirmed'),
                        onTap: () => _toggle(_selectedStatuses, 'confirmed'),
                      ),
                      FilterSelectButtonWidget(
                        label: 'Rejected',
                        selected: _selectedStatuses.contains('rejected'),
                        onTap: () => _toggle(_selectedStatuses, 'rejected'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Date Range
                  _sectionTitle('Date Range'),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FilterDateButtonWidget(
                          label: "From Date",
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
                        child: Icon(Icons.arrow_forward, size: 18, color: Colors.grey,),
                      ),
                      Expanded(
                        child: FilterDateButtonWidget(
                          label: "To Date",
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
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: Text('Show ${count ?? '...'} Results'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedTypes.clear();
                            _selectedStatuses.clear();
                            _startDate = null;
                            _endDate = null;
                          });
                          _updatePreview();
                        },
                        child: const Text('Clear Filters'),
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
