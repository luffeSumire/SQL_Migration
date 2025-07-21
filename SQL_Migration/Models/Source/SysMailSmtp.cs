using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 寄信SMTP設定
/// </summary>
public partial class SysMailSmtp
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }

    /// <summary>
    /// 寄信指令位置
    /// </summary>
    public string? Mailpath { get; set; }

    /// <summary>
    /// 寄信模式
    /// </summary>
    public string? Protocol { get; set; }

    /// <summary>
    /// 管理者信箱
    /// </summary>
    public string? SmtpUser { get; set; }

    /// <summary>
    /// 管理者寄信密碼
    /// </summary>
    public string? SmtpPass { get; set; }

    /// <summary>
    /// smtp_port
    /// </summary>
    public string? SmtpPort { get; set; }

    /// <summary>
    /// &apos;&apos; or &apos;tls&apos; or &apos;ssl&apos;
    /// </summary>
    public string? SmtpCrypto { get; set; }

    /// <summary>
    /// host
    /// </summary>
    public string? SmtpHost { get; set; }
}
