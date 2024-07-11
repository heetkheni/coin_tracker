class ChartModel {
  int time;
  double? open;
  double? high;
  double? low;
  double? close;

  ChartModel(
      {required this.close,
      required this.high,
      required this.low,
      required this.open,
      required this.time});

  factory ChartModel.fromJson(List chartList) {
    return ChartModel(
        close: chartList[0] == null ? null : chartList[0]!,
        high: chartList[1] == null ? null : chartList[1]!,
        low: chartList[2] == null ? null : chartList[2]!,
        open: chartList[3] == null ? null : chartList[3]!,
        time: chartList[4] == null ? null : chartList[4]!);
  }
}
