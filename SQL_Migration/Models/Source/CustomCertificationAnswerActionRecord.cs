using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 使用者認證回答紀錄
/// </summary>
public partial class CustomCertificationAnswerActionRecord
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    /// <summary>
    /// 答案編號
    /// </summary>
    public int? CertificationAnswerSid { get; set; }

    public int? CertificationAnswerRecordSid { get; set; }

    public string? RecordContent { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }
}
