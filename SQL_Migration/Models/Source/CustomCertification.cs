using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 使用者認證
/// </summary>
public partial class CustomCertification
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    /// <summary>
    /// 使用者編號
    /// </summary>
    public long? MemberSid { get; set; }

    /// <summary>
    /// 等級
    /// </summary>
    public byte? Level { get; set; }

    /// <summary>
    /// 審核
    /// </summary>
    public string? Review { get; set; }

    /// <summary>
    /// 送審日期
    /// </summary>
    public string? Reviewdate { get; set; }

    /// <summary>
    /// 通過時間
    /// </summary>
    public string? Passdate { get; set; }

    /// <summary>
    /// 退件時間
    /// </summary>
    public string? Returndate { get; set; }

    /// <summary>
    /// 補件時間
    /// </summary>
    public string? Additionaldate { get; set; }

    /// <summary>
    /// 證書編號
    /// </summary>
    public int? CertificateSid { get; set; }

    /// <summary>
    /// 獎牌歷史
    /// </summary>
    public string? Rewardhistory { get; set; }

    /// <summary>
    /// 刪除
    /// </summary>
    public byte? IsDel { get; set; }

    /// <summary>
    /// 檔案
    /// </summary>
    public string? PdfFile { get; set; }

    /// <summary>
    /// 新增方式
    /// </summary>
    public string? AddType { get; set; }

    public string? Lan { get; set; }

    public int? Sequence { get; set; }

    public virtual ICollection<CustomCertificationAnswer> CustomCertificationAnswers { get; set; } = new List<CustomCertificationAnswer>();

    public virtual ICollection<CustomCertificationStepRecord> CustomCertificationStepRecords { get; set; } = new List<CustomCertificationStepRecord>();

    public virtual CustomMember? MemberS { get; set; }
}
