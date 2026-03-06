import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lowfit/core/services/class_service.dart';
import 'package:flutter_lowfit/core/services/storage_service.dart';
import 'package:flutter_lowfit/features/shared/theme/app_colors.dart';
import 'package:flutter_lowfit/features/class_list/bloc/class_list_bloc.dart';
import 'package:flutter_lowfit/features/class_list/view/widgets/class_list.dart';
import 'package:flutter_lowfit/features/class_list/view/widgets/classes_tab_bar.dart';
import 'package:flutter_lowfit/features/class_list/view/widgets/date_selector.dart';
import 'package:flutter_lowfit/features/shared/bottom_navigation_bar.dart';

class ClassListPage extends StatefulWidget {
  final int? trainerId;
  final String? trainerName;

  const ClassListPage({
    super.key,
    this.trainerId,
    this.trainerName,
  });

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClassBloc(
        ClassService(),
        StorageService(),
      )..add(FetchClasses(widget.trainerId)),

      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ── Trainer header (optional) ──
              if (widget.trainerName != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Classes by ${widget.trainerName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // Tabs
              ClassesTabBar(
                selectedIndex: _selectedTab,
                onTabSelected: (i) => setState(() => _selectedTab = i),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: BlocBuilder<ClassBloc, ClassState>(
                  builder: (context, state) {
                    if (state is ClassLoading || state is ClassInitial) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (state is ClassError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    if (state is ClassLoaded) {
                      final displayedClasses = _selectedTab == 0
                          ? state.classes
                          : state.classes.where((c) => c.isReserved).toList();

                      return Column(
                        children: [
                          DateSelector(
                            dates: state.dates,
                            selectedDate: state.selectedDate,
                            onDateSelected: (date) {
                              context.read<ClassBloc>().add(
                                    FetchClassesForDate(
                                      date,
                                      widget.trainerId,
                                    ),
                                  );
                            },
                          ),

                          const SizedBox(height: 16),

                          Expanded(
                            child: ClassList(
                              classes: displayedClasses,
                              onBookPressed: (classId) {
                                context.read<ClassBloc>().add(ReserveClassEvent(classId));
                              },
                              onCancelPressed: (classId) {
                                context.read<ClassBloc>().add(CancelClassEvent(classId));
                              },
                            )
                          ),
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const MyBottomNavigationBar(currentIndex: 1),
      ),
    );
  }
}