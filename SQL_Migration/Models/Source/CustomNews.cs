using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 文字編輯器內容
/// </summary>
public partial class CustomNews
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    public int Sequence { get; set; }

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
    /// 使用者sid
    /// </summary>
    public long? MemberSid { get; set; }

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
    /// certification:認證,release:校園投稿,activity:活動,International:國際,other:其他
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

    public virtual ICollection<CustomReleaseEnTw> CustomReleaseEnTwReleaseEns { get; set; } = new List<CustomReleaseEnTw>();

    public virtual ICollection<CustomReleaseEnTw> CustomReleaseEnTwReleaseTws { get; set; } = new List<CustomReleaseEnTw>();

    public virtual ICollection<CustomReleasePhoto> CustomReleasePhotos { get; set; } = new List<CustomReleasePhoto>();
}
