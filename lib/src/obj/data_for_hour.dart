class DataForHour {
  DataForHour(this.satisfied, this.normal, this.unsatisfied);

  int unsatisfied = 0, normal = 0, satisfied = 0;

  int get sum => unsatisfied + normal + satisfied;

  void addLevel(int level) {
    switch (level) {
      case 1:
        unsatisfied++;
        break;
      case 2:
        normal++;
        break;
      case 3:
        satisfied++;
        break;
    }
  }

  double get level {
    if (sum == 0) {
      return 0;
    }
    return (unsatisfied * -1 + normal * 0 + satisfied * 1) / sum;
  }

  double get unpt {
    if (sum == 0) {
      return 0;
    }
    return unsatisfied / sum;
  }

  double get nopt {
    if (sum == 0) {
      return 0;
    }
    return normal / sum;
  }

  double get sapt {
    if (sum == 0) {
      return 0;
    }
    return satisfied / sum;
  }

  @override
  String toString() {
    return '$unsatisfied;$normal;$satisfied;$level';
  }
}
