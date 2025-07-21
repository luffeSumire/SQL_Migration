using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 使用者認證步驟紀錄
/// </summary>
public partial class CustomCertificationStepRecord
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
    /// 步驟評審意見
    /// </summary>
    public string? StepOpinion { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }

    public int? Step { get; set; }

    public virtual CustomCertification? CertificationS { get; set; }
}
