import 'dart:math';

import 'package:equatable/equatable.dart';

void main() async {
  print("Help");

  Person p1 = Person(name: "Precious", ages: [
    Ages(year: "2022", month: "10"),
    Ages(year: "2021", month: "11"),
    Ages(year: "2023", month: "12"),
  ]);

  // p1.ages.add(
  //   Ages(year: "2024", month: "12"),
  // );

  Person p2 = Person(
      name: "Precious",
      ages:  List.of(p1.ages)
  );
   p2.ages.add(Ages(year: "2025", month: "07"));
   print(p1.ages);
   print(p2.ages);

 // ..insert(0, Ages(year: "2026", month: "01"))

  bool equal = p1 == p2;

  print(equal);

  Person p3 = p1.copyWith(ages: [
    Ages(year: "2022", month: "10"),
    Ages(year: "2021", month: "11"),
    Ages(year: "2023", month: "12"),
    Ages(year: "2024", month: "12"),
  ]);
}

class Person extends Equatable {
  final String name;

  final List<Ages> ages;

  Person({required this.name, required this.ages});

  @override
  List<Object?> get props => [name, ages];

  Person copyWith({
    String? name,
    List<Ages>? ages,
  }) {
    return Person(
      name: name ?? this.name,
      ages: ages ?? this.ages,
    );
  }
}

class Ages extends Equatable {
  final String year;

  final String month;

  Ages({required this.year, required this.month});

  @override
  List<Object?> get props => [year, month];
}
