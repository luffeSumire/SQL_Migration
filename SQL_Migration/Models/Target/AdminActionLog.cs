using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

public partial class AdminActionLog
{
    public long ActionLogId { get; set; }

    public long CertificationId { get; set; }

    public long QuestionId { get; set; }

    public long? AnswerId { get; set; }

    public long AdminUserId { get; set; }

    public string Action { get; set; } = null!;

    public int? PreviousStatus { get; set; }

    public int? NewStatus { get; set; }

    public DateTime ActionTime { get; set; }

    public string? Notes { get; set; }
}
