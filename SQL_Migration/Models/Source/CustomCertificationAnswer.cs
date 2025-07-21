using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 使用者認證回答
/// </summary>
public partial class CustomCertificationAnswer
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    /// <summary>
    /// 認證編號
    /// </summary>
    public long? CertificationSid { get; set; }

    /// <summary>
    /// 題目編號
    /// </summary>
    public int? QuestionSid { get; set; }

    public int? UseCertificationAnswerRecordSid { get; set; }

    public int? ReviewCertificationAnswerRecordSid { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }

    public virtual CustomCertification? CertificationS { get; set; }

    public virtual ICollection<CustomCertificationAnswerRecord> CustomCertificationAnswerRecords { get; set; } = new List<CustomCertificationAnswerRecord>();
}
