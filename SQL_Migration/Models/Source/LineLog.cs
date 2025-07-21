using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 記錄從line傳過來的訊息
/// </summary>
public partial class LineLog
{
    /// <summary>
    /// log的日期，預設為寫入資料當下的時間
    /// </summary>
    public DateTime Date { get; set; }

    /// <summary>
    /// 要記錄的內容，大部分都是整包line傳過來的http body param
    /// </summary>
    public string? Log { get; set; }

    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public int? Sequence { get; set; }
}
