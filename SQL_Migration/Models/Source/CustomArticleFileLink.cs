using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 用於管理相關連結及檔案下載
/// </summary>
public partial class CustomArticleFileLink
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public int Sid { get; set; }

    public int Sequence { get; set; }

    public string? Lan { get; set; }

    /// <summary>
    /// 使用連結或檔案的表sid
    /// </summary>
    public int? TableSid { get; set; }

    /// <summary>
    /// 使用連結或檔案的名稱
    /// </summary>
    public string? TableName { get; set; }

    /// <summary>
    /// file:檔案,link:連結
    /// </summary>
    public string? Type { get; set; }

    /// <summary>
    /// 檔案下載標題或相關連結名稱
    /// </summary>
    public string? Title { get; set; }

    /// <summary>
    /// 相關連結的url
    /// </summary>
    public string? LinkUrl { get; set; }

    /// <summary>
    /// 上傳的檔案
    /// </summary>
    public string? Fileinfo { get; set; }

    /// <summary>
    /// 上傳的檔案(odt)
    /// </summary>
    public string? FileinfoOdt { get; set; }
}
