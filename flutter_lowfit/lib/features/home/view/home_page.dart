import 'package:flutter/material.dart' hide BottomNavigationBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lowfit/features/class_list/view/class_list_page.dart';
import 'package:flutter_lowfit/features/shared/app_bar.dart';
import 'package:flutter_lowfit/features/shared/theme/app_colors.dart';
import 'package:flutter_lowfit/features/home/bloc/home_bloc.dart';
import 'package:flutter_lowfit/core/services/home_service.dart';
import 'package:flutter_lowfit/core/services/storage_service.dart';
import 'package:flutter_lowfit/features/home/view/widgets/greeting_header.dart';
import 'package:flutter_lowfit/features/home/view/widgets/sessions_card.dart';
import 'package:flutter_lowfit/features/home/view/widgets/upcoming_classes.dart';
import 'package:flutter_lowfit/features/shared/bottom_navigation_bar.dart';
import 'package:flutter_lowfit/features/home/view/widgets/trainers_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc _homeBloc;
  

  @override
  void initState() {
    super.initState();
    final homeService = HomeService();
    final storageService = StorageService();
    _homeBloc = HomeBloc(homeService, storageService);
    _homeBloc.add(FetchHome());
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeBloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const MyAppBar(),
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is HomeSuccess) {
                final data = state.response;

                final progress = data.sessionProgress.total == 0
                    ? 0.0
                    : data.sessionProgress.completed /
                        data.sessionProgress.total;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        GreetingHeader(userName: data.userName),

                        const SizedBox(height: 25),

                        const Text(
                          'Personal goal this week',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 12),

                        SessionsCard(
                          completed: data.sessionProgress.completed,
                          total: data.sessionProgress.total,
                          progress: progress,
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          'Upcoming classes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        UpcomingClassesCard(
                          onViewClasses: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ClassListPage(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 28),

                        TrainersList(
                          trainers: data.trainers,

                          // Tap en entrenador → clases filtradas
                          onTrainerTap: (trainer) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ClassListPage(
                                  trainerId: trainer.id,
                                  trainerName: trainer.name,
                                ),
                              ),
                            );
                          },

                          // See all → todas las clases
                          onSeeAll: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ClassListPage(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              }

              if (state is HomeError) {
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
        ),
        bottomNavigationBar: const MyBottomNavigationBar(currentIndex: 0),
      ),
    );
  }
}