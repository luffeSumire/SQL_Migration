using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 證書(很重要2、3、4 sid 不可以刪 對應 銅銀綠旗證書)
/// </summary>
public partial class CustomCertificate
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    /// <summary>
    /// 證書名稱
    /// </summary>
    public string? Cname { get; set; }

    /// <summary>
    /// 版本號
    /// </summary>
    public string? Version { get; set; }

    /// <summary>
    /// 是否使用；1:使用、0:不使用
    /// </summary>
    public byte? IsUse { get; set; }

    public string? Lan { get; set; }

    public int? Sequence { get; set; }
}
