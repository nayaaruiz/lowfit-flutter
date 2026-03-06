import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lowfit/core/models/class_response.dart';
import 'package:flutter_lowfit/core/models/reserva_response.dart';
import 'package:flutter_lowfit/core/services/class_service.dart';
import 'package:flutter_lowfit/core/services/cliente_service.dart';
import 'package:flutter_lowfit/core/services/storage_service.dart';
import 'package:flutter_lowfit/features/login/view/login_page.dart';
import 'package:flutter_lowfit/features/my_account/bloc/my_account_bloc.dart';
import 'package:flutter_lowfit/features/shared/app_bar.dart';
import 'package:flutter_lowfit/features/shared/theme/app_colors.dart';
import 'package:flutter_lowfit/features/shared/bottom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  late final MyAccountBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MyAccountBloc(ClienteService(), ClassService(), StorageService());
    _bloc.add(FetchMyAccountEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _logout() {
    _bloc.add(LogoutMyAccountEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFF26263D),
        appBar: const MyAppBar(),
        bottomNavigationBar: const MyBottomNavigationBar(currentIndex: 2),
        body: BlocListener<MyAccountBloc, MyAccountState>(
          listener: (context, state) {
            if (state is MyAccountLoggedOut) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            }

            if (state is MyAccountError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Stack(
            children: [
              SafeArea(
                child: BlocBuilder<MyAccountBloc, MyAccountState>(
                  builder: (context, state) {

                    if (state is MyAccountLoading || state is MyAccountInitial) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (state is MyAccountError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                      );
                    }

                    final cliente = (state as MyAccountSuccess).cliente;

                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [

                        const SizedBox(height: 20),

                        Text(
                          "My account",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 30),

                        _buildField("name", cliente.name),
                        const SizedBox(height: 16),

                        _buildField("surnames", cliente.surnames),
                        const SizedBox(height: 16),

                        _buildField("email", cliente.email),

                        const SizedBox(height: 30),

                        Text(
                          "Available classes",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 12),

                        ...state.availableClasses.map((classItem) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _classCard(classItem, state.reservations),
                        )),

                        const SizedBox(height: 30),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Tu cuota",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "Vencimiento: 09/03/2026",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 16),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: Text(
                                      "182,90€",
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    "3 days left",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        SizedBox(
                          height: 42,
                          child: ElevatedButton(
                            onPressed: _logout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            child: Text(
                              "Log out",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 80),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 6),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _classCard(ClassResponse classItem, List<ReservaResponse> reservations) {
    // Verificar si esta clase está reservada por el usuario
    final isReserved = reservations.any((reserva) => reserva.sesionId == classItem.id);

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classItem.name,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  classItem.startTime,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => isReserved
                  ? _cancelReservationBySessionId(classItem.id)
                  : _reserveClass(classItem.id),
              child: Text(
                isReserved ? "cancel" : "book",
                style: GoogleFonts.inter(
                  color: isReserved ? Colors.red : AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _cancelReservation(int reservationId) {
    _bloc.add(CancelReservationEvent(reservationId));
  }

  void _reserveClass(int classId) {
    _bloc.add(ReserveClassEvent(classId));
  }

  void _cancelReservationBySessionId(int sessionId) {
    // Encontrar la reserva correspondiente a esta sesión
    final state = _bloc.state;
    if (state is MyAccountSuccess) {
      final reservation = state.reservations.firstWhere(
        (reserva) => reserva.sesionId == sessionId,
        orElse: () => throw Exception('Reserva no encontrada'),
      );
      _cancelReservation(reservation.id!);
    }
  }
}