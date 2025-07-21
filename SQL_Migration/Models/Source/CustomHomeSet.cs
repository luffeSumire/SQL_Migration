using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 首頁設定(首頁要求高度客製化,因此基本上都是欄位對應文字編輯器)
/// </summary>
public partial class CustomHomeSet
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public int Sid { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }

    /// <summary>
    /// tag名稱(工程師辨識用,方便透過tag直接抓資料)
    /// </summary>
    public string? Tag { get; set; }

    /// <summary>
    /// 區塊名稱(設定以及管理者看到)
    /// </summary>
    public string? Cname { get; set; }

    /// <summary>
    /// 圖片
    /// </summary>
    public string? Photo { get; set; }

    /// <summary>
    /// 純文字內容
    /// </summary>
    public string? Msg { get; set; }

    /// <summary>
    /// 標題
    /// </summary>
    public string? Title { get; set; }

    /// <summary>
    /// 特殊欄位
    /// </summary>
    public string? Other { get; set; }

    /// <summary>
    /// 連結
    /// </summary>
    public string? Siteurl { get; set; }

    /// <summary>
    /// 是否另開
    /// </summary>
    public byte? IsBlank { get; set; }

    /// <summary>
    /// 圖片高
    /// </summary>
    public int? PHeight { get; set; }

    /// <summary>
    /// 圖片寬
    /// </summary>
    public int? PWidth { get; set; }

    /// <summary>
    /// 文字編輯器
    /// </summary>
    public byte? IsEdit { get; set; }

    /// <summary>
    /// 顯示設定[白名單]
    /// </summary>
    public string? ShowAry { get; set; }
}
