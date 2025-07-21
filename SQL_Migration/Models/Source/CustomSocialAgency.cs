using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class CustomSocialAgency
{
    /// <summary>
    /// 資料編號
    /// </summary>
    public long Sid { get; set; }

    /// <summary>
    /// 名稱
    /// </summary>
    public string? Title { get; set; }

    /// <summary>
    /// 描述
    /// </summary>
    public string? Description { get; set; }

    /// <summary>
    /// 封面圖片檔案名稱
    /// </summary>
    public string? FrontImg { get; set; }

    /// <summary>
    /// 實績 (\r\n換行)
    /// </summary>
    public string? AchievementList { get; set; }

    /// <summary>
    /// 協助學校內容 (\r\n換行)
    /// </summary>
    public string? SupportSchoolItemList { get; set; }

    /// <summary>
    /// 聯絡資訊
    /// </summary>
    public string? ContactInfo { get; set; }

    /// <summary>
    /// 建立時間 (timestamp)
    /// </summary>
    public int? Createdate { get; set; }

    /// <summary>
    /// 建立人
    /// </summary>
    public string? Createuser { get; set; }

    /// <summary>
    /// 最後更新時間 (timestamp)
    /// </summary>
    public int? Updatedate { get; set; }

    /// <summary>
    /// 最後更新人
    /// </summary>
    public string? Updateuser { get; set; }

    /// <summary>
    /// 更新人IP資訊
    /// </summary>
    public string? Updateip { get; set; }

    /// <summary>
    /// 建立人IP資訊
    /// </summary>
    public string? Createip { get; set; }
}
