import 'package:escoladeverao/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation(
      {Key? key, required this.onTap, required this.currentIndex})
      : super(key: key);

  final int currentIndex;
  final Function(int) onTap;

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.orange, width: 1.h),
          left: BorderSide(color: Colors.orange, width: 1.h),
          right: BorderSide(color: Colors.orange, width: 1.h),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomAppBar(
          color: AppColors.background,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => widget.onTap(0),
                child: Image.asset(
                  'assets/icons/home-icon.png',
                  color: widget.currentIndex == 0
                      ? AppColors.orangePrimary
                      : AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => widget.onTap(1),
                child: Image.asset(
                  'assets/icons/calendar-icon.png',
                  color: widget.currentIndex == 1
                      ? AppColors.orangePrimary
                      : AppColors.textPrimary,
                ),
              ),
              Container(
                width: 52.h,
                height: 52.h,
                decoration: BoxDecoration(
                    color: AppColors.orangePrimary,
                    borderRadius: BorderRadius.all(Radius.circular(40.h))),
                child: GestureDetector(
                  onTap: () => widget.onTap(2),
                  child: Image.asset(
                    'assets/icons/scan-icon.png',
                    color: widget.currentIndex == 2
                        ? Colors.white
                        : AppColors.textPrimary,
                    fit: BoxFit.none,
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => widget.onTap(3),
                child: Image.asset(
                  'assets/icons/profile-icon.png',
                  color: widget.currentIndex == 3
                      ? AppColors.orangePrimary
                      : AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => widget.onTap(4),
                child: Image.asset(
                  'assets/icons/config-icon.png',
                  color: widget.currentIndex == 4
                      ? AppColors.orangePrimary
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
