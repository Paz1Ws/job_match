import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobFilterState {
  final String? jobTitleLike;
  // final String? locationLike;
  // final int? categoryIndex;
  // final Set<int>? jobTypeIndexes;
  // final (double, double)? salaryRange;
  // TODO Tags
  // TODO features

  JobFilterState({
    this.jobTitleLike,
    // this.locationLike,
    // this.jobTypeIndexes,
    // this.salaryRange
  });

  JobFilterState copyWith({
    String? jobTitleLike,
    // String? locationLike,
    // Set<int>? jobTypeIndexes,
    // (double, double)? salaryRange
  }) => JobFilterState(
    jobTitleLike: jobTitleLike ?? this.jobTitleLike,
    // locationLike: locationLike ?? this.locationLike,
    // jobTypeIndexes: jobTypeIndexes ?? this.jobTypeIndexes,
    // salaryRange: salaryRange ?? this.salaryRange
  );
}

final jobFilterProvider = StateProvider<JobFilterState>((ref) => JobFilterState());