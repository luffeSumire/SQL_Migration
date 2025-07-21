using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 使用者認證步驟紀錄
/// </summary>
public partial class CustomEmailSendRecord
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public int? MemberSid { get; set; }

    public string? SendDate { get; set; }

    public string? Type { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }
}
