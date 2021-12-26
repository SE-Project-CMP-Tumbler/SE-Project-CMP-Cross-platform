
/// [TimePacket] represents the block of notifications happened in the same day
class TimePacket {
  /// [TimePacket] constructor
  TimePacket({required final this.packetTime, required final this.packet});
  
  /// the date time of the packet
  DateTime packetTime;

  /// the list of notifications object
  List<dynamic> packet;
}
