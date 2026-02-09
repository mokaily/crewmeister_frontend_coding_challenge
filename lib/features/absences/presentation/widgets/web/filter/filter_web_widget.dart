import 'dart:async';

import 'package:crewmeister_frontend_coding_challenge/core/locatlizations/app_strings.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/presentation/bloc/absences_bloc.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/presentation/widgets/form_search_field_widget.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/presentation/widgets/mobile/filter_bottom_sheet/filter_date_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterWebWidget extends StatefulWidget {
  const FilterWebWidget({super.key});

  @override
  State<FilterWebWidget> createState() => _FilterWebWidgetState();
}

class _FilterWebWidgetState extends State<FilterWebWidget> {
  // State to hold filter values
  final List<String> _selectedTypes = [];
  final List<String> _selectedStatuses = [];
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Initialize state from Bloc if needed, or just start empty/default.
    // Ideally we sync with current bloc state.
    final state = context.read<AbsencesBloc>().state;
    if (state is AbsencesLoaded) {
      if (state.filterTypes != null) _selectedTypes.addAll(state.filterTypes!);
      if (state.filterStatuses != null) {
        _selectedStatuses.addAll(state.filterStatuses!);
      }
      _startDate = state.filterStartDate;
      _endDate = state.filterEndDate;
      if (state.filterMemberName != null) {
        _searchController.text = state.filterMemberName!;
      }
    }

    // Trigger initial preview? Maybe not needed if we just show current state.
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
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

  void _toggleType(String type) {
    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }
    });
    _updatePreview();
  }

  void _toggleStatus(String status) {
    setState(() {
      if (_selectedStatuses.contains(status)) {
        _selectedStatuses.remove(status);
      } else {
        _selectedStatuses.add(status);
      }
    });
    _updatePreview();
  }

  void _clearFilters() {
    setState(() {
      _selectedTypes.clear();
      _selectedStatuses.clear();
      _startDate = null;
      _endDate = null;
      _searchController.clear();
    });
    _updatePreview();
  }

  void _applyFilters() {
    context.read<AbsencesBloc>().add(
      ApplyFiltersEvent(
        types: _selectedTypes,
        statuses: _selectedStatuses,
        startDate: _startDate,
        endDate: _endDate,
        memberName: _searchController.text,
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(onPressed: _clearFilters, child: const Text('Clear All')),
            ],
          ),
          const SizedBox(height: 24),

          // Search Member
          _sectionTitle("SEARCH MEMBER"),
          const SizedBox(height: 8),
          FormSearchFieldWidget(searchController: _searchController, onAction: _onSearchChanged),
          const SizedBox(height: 24),

          // Absence Type
          _sectionTitle("ABSENCE TYPE"),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTypeCheckbox(AppStrings.vacation, 'vacation'),
              _buildTypeCheckbox(AppStrings.sickness, 'sickness'),
            ],
          ),
          const SizedBox(height: 24),

          // Date Range
          _sectionTitle("DATE RANGE"),
          const SizedBox(height: 8),
          FilterDateButtonWidget(
            label: AppStrings.fromDate,
            date: _startDate,
            onDateSelected: (date) {
              setState(() => _startDate = date);
              _updatePreview();
            },
          ),
          const SizedBox(height: 8),
          FilterDateButtonWidget(
            label: AppStrings.toDate,
            date: _endDate,
            onDateSelected: (date) {
              setState(() => _endDate = date);
              _updatePreview();
            },
          ),
          const SizedBox(height: 24),

          // Status
          _sectionTitle("STATUS"),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatusCheckbox(AppStrings.requested, 'requested'),
              _buildStatusCheckbox(AppStrings.confirmed, 'confirmed'),
              _buildStatusCheckbox(AppStrings.rejected, 'rejected'),
            ],
          ),

          const SizedBox(height: 32),

          // Apple Button
          BlocBuilder<AbsencesBloc, AbsencesState>(
            builder: (context, state) {
              final count = state is AbsencesLoaded ? state.filterPreviewCount : null;
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: Text(
                    count != null ? "Apply Filters ($count)" : "Apply Filters",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCheckbox(String label, String value) {
    return InkWell(
      onTap: () => _toggleType(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Checkbox(
              value: _selectedTypes.contains(value),
              onChanged: (v) => _toggleType(value),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCheckbox(String label, String value) {
    return InkWell(
      onTap: () => _toggleStatus(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Checkbox(
              value: _selectedStatuses.contains(value),
              onChanged: (v) => _toggleStatus(value),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
