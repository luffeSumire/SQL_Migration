using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 文章分類
/// </summary>
public partial class CustomTag
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
    /// news:最新消息,video:精選影片,about:簡介,execute:執行方式,certification:認證介紹,fqa:常見問題,release:校園投稿說明,file_dl:檔案下載,related:友善連結,tutor:輔導人員
    /// </summary>
    public string? Type { get; set; }

    /// <summary>
    /// 名稱
    /// </summary>
    public string? Cname { get; set; }

    /// <summary>
    /// icon
    /// </summary>
    public string? Photo { get; set; }

    /// <summary>
    /// 模板、樣式
    /// </summary>
    public string? ShowStyle { get; set; }

    /// <summary>
    /// 上架時間
    /// </summary>
    public string? Startdate { get; set; }

    /// <summary>
    /// 下架時間
    /// </summary>
    public string? Enddate { get; set; }
}
