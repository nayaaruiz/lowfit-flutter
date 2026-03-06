import 'package:flutter/material.dart' hide BottomNavigationBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lowfit/features/shared/theme/app_colors.dart';
import 'package:flutter_lowfit/features/class_detail/bloc/class_detail_bloc.dart';
import 'package:flutter_lowfit/core/services/class_service.dart';
import 'package:flutter_lowfit/core/services/storage_service.dart';
import 'package:flutter_lowfit/features/shared/bottom_navigation_bar.dart';

class ClassDetailPage extends StatefulWidget {
  final int classId;

  const ClassDetailPage({
    super.key,
    required this.classId,
  });

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {

  final ClassDetailBloc _classDetailBloc =
      ClassDetailBloc(ClassService(), StorageService());

  @override
  void initState() {
    super.initState();
    _classDetailBloc.add(FetchClassDetail(id: widget.classId));
  }

  @override
  void dispose() {
    _classDetailBloc.close();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _classDetailBloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<ClassDetailBloc, ClassDetailState>(
          builder: (context, state) {
            if (state is ClassDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is ClassDetailSuccess) {
              final classDetail = state.classDetail;

              final bool isFull = classDetail.spacesLeft <= 0;
              final bool isReserved = classDetail.isReserved;
              final bool disabled = isFull || isReserved;

              final String buttonLabel =
                  isReserved ? 'Reserved' : isFull ? 'Full' : 'Reserv class';

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ClassHeader(
                      image: classDetail.image,
                      onClose: () => Navigator.pop(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                classDetail.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _formatDate(classDetail.date),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                color: Colors.white.withValues(alpha: 0.7),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${classDetail.startTime} - ${classDetail.durationMinutes} mins',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          Text(
                            classDetail.description,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 1.5,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 36),

                          const Text(
                            'Instructor',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(classDetail.trainer.photo),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                classDetail.trainer.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    disabled ? Colors.grey : AppColors.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: disabled
                                  ? null
                                  : () {
                                      _classDetailBloc.add(
                                        ReserveSessionEvent(id: classDetail.id),
                                      );
                                    },
                              child: Text(
                                buttonLabel,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is ClassDetailError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            return const SizedBox();
          },
        ),
        bottomNavigationBar: const MyBottomNavigationBar(currentIndex: 1),
      ),
    );
  }
}

class _ClassHeader extends StatelessWidget {
  const _ClassHeader({
    required this.image,
    required this.onClose,
  });

  final String image;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          image,
          height: 350,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 350,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                AppColors.background,
              ],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}