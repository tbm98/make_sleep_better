class Profile {
  Profile(this.name, this.timeWaitingToSleep, this.cycleSleep);

  String name;
  int timeWaitingToSleep = 14; // it is average minute
  int cycleSleep = 90; //average is 1h30m
}
