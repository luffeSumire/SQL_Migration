using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 文字編輯器內容
/// </summary>
public partial class CustomArticle
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public int Sid { get; set; }

    public int Sequence { get; set; }

    public int Hits { get; set; }

    public string? Lan { get; set; }

    /// <summary>
    /// 標題
    /// </summary>
    public string? Title { get; set; }

    /// <summary>
    /// 標籤sid 做分類使用
    /// </summary>
    public int? TagSid { get; set; }

    /// <summary>
    /// 開始日期(yyyy-mm-dd)
    /// </summary>
    public string? Startdate { get; set; }

    /// <summary>
    /// 結束日期(yyyy-mm-dd)
    /// </summary>
    public string? Enddate { get; set; }

    /// <summary>
    /// 圖片
    /// </summary>
    public string? Photo { get; set; }

    /// <summary>
    /// 檔案
    /// </summary>
    public string? Fileinfo { get; set; }

    /// <summary>
    /// 簡述說明
    /// </summary>
    public string? Explanation { get; set; }

    /// <summary>
    /// news:最新消息,video:精選影片,about:簡介,execute:執行方式,certification:認證介紹,fqa:常見問題,release:校園投稿說明,file_dl:檔案下載,related:友善連結
    /// </summary>
    public string? Type { get; set; }

    /// <summary>
    /// 連結
    /// </summary>
    public string? Link { get; set; }

    /// <summary>
    /// 是否另開(配合連結使用)
    /// </summary>
    public byte? IsBlank { get; set; }

    /// <summary>
    /// 特殊欄位
    /// </summary>
    public string? Other { get; set; }

    /// <summary>
    /// 是否顯示於首頁
    /// </summary>
    public byte? IsHome { get; set; }

    /// <summary>
    /// 多組標籤使用
    /// </summary>
    public string? TagAry { get; set; }

    /// <summary>
    /// 是否顯示
    /// </summary>
    public byte? IsShow { get; set; }
}
