using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 給簡易CRUD用的，當input欄位包含select需要有一些設定值時，可以使用這邊的設定
/// </summary>
public partial class SimpleInputSource
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public int? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }

    /// <summary>
    /// 標記讓程式知道要抓誰的tag
    /// </summary>
    public string? SimpleTag { get; set; }

    /// <summary>
    /// 對應html的type
    /// </summary>
    public string? HtmlType { get; set; }

    /// <summary>
    /// 對應html的標籤
    /// </summary>
    public string? HtmlTag { get; set; }

    /// <summary>
    /// 對應html的value
    /// </summary>
    public string? HtmlValue { get; set; }

    /// <summary>
    /// 顯示的名稱
    /// </summary>
    public string? Cname { get; set; }
}
