class EsignResponse {
  final List<Request> requests;
  final String groupId;
  final bool success;
  final String webhookSecurityKey;
  final DateTime requestTimestamp;
  final DateTime expiresAt;

  EsignResponse({
    required this.requests,
    required this.groupId,
    required this.success,
    required this.webhookSecurityKey,
    required this.requestTimestamp,
    required this.expiresAt,
  });

  EsignResponse copyWith({
    List<Request>? requests,
    String? groupId,
    bool? success,
    String? webhookSecurityKey,
    DateTime? requestTimestamp,
    DateTime? expiresAt,
  }) => EsignResponse(
    requests: requests ?? this.requests,
    groupId: groupId ?? this.groupId,
    success: success ?? this.success,
    webhookSecurityKey: webhookSecurityKey ?? this.webhookSecurityKey,
    requestTimestamp: requestTimestamp ?? this.requestTimestamp,
    expiresAt: expiresAt ?? this.expiresAt,
  );

  factory EsignResponse.fromJson(Map<String, dynamic> json) => EsignResponse(
    requests: List<Request>.from(
      json["requests"].map((x) => Request.fromJson(x)),
    ),
    groupId: json["group_id"],
    success: json["success"],
    webhookSecurityKey: json["webhook_security_key"],
    requestTimestamp: DateTime.parse(json["request_timestamp"]),
    expiresAt: DateTime.parse(json["expires_at"]),
  );

  Map<String, dynamic> toJson() => {
    "requests": List<dynamic>.from(requests.map((x) => x.toJson())),
    "group_id": groupId,
    "success": success,
    "webhook_security_key": webhookSecurityKey,
    "request_timestamp": requestTimestamp.toIso8601String(),
    "expires_at": expiresAt.toIso8601String(),
  };
}

class Request {
  final String requestId;
  final String signerName;
  final String signerEmail;
  final String signingUrl;

  Request({
    required this.requestId,
    required this.signerName,
    required this.signerEmail,
    required this.signingUrl,
  });

  Request copyWith({
    String? requestId,
    String? signerName,
    String? signerEmail,
    String? signingUrl,
  }) => Request(
    requestId: requestId ?? this.requestId,
    signerName: signerName ?? this.signerName,
    signerEmail: signerEmail ?? this.signerEmail,
    signingUrl: signingUrl ?? this.signingUrl,
  );

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    requestId: json["request_id"],
    signerName: json["signer_name"],
    signerEmail: json["signer_email"],
    signingUrl: json["signing_url"],
  );

  Map<String, dynamic> toJson() => {
    "request_id": requestId,
    "signer_name": signerName,
    "signer_email": signerEmail,
    "signing_url": signingUrl,
  };
}
