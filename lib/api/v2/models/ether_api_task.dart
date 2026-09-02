enum EtherApiTaskStatus {
  created,
  queued,
  running,
  completed,
  failed,
  cancelled,
}

class EtherApiTask {
  final String id;
  final String description;
  EtherApiTaskStatus status;
  final DateTime createdAt;
  DateTime updatedAt;
  dynamic result;
  String? error;

  EtherApiTask({
    required this.id,
    required this.description,
    this.status = EtherApiTaskStatus.created,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.result,
    this.error,
  }) : createdAt = createdAt ?? DateTime.now().toUtc(),
       updatedAt = updatedAt ?? DateTime.now().toUtc();

  void transition(EtherApiTaskStatus next) {
    status = next;
    updatedAt = DateTime.now().toUtc();
  }

  void complete(dynamic value) {
    result = value;
    error = null;
    transition(EtherApiTaskStatus.completed);
  }

  void fail(String message) {
    error = message;
    result = null;
    transition(EtherApiTaskStatus.failed);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (result != null) 'result': result,
      if (error != null) 'error': error,
    };
  }
}
