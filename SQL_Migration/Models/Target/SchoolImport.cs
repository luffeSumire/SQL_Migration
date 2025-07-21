using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

/// <summary>
/// 政府管轄學校列表基本資訊匯入表
/// </summary>
public partial class SchoolImport
{
    /// <summary>
    /// 學校匯入記錄ID (主鍵)
    /// </summary>
    public int Id { get; set; }

    /// <summary>
    /// 學校代碼 (CSV中的代碼)
    /// </summary>
    public string Code { get; set; } = null!;

    /// <summary>
    /// 學校名稱
    /// </summary>
    public string Name { get; set; } = null!;

    /// <summary>
    /// 行政區ID (根據郵遞區號對應)
    /// </summary>
    public int? DistrictId { get; set; }

    /// <summary>
    /// 縣市ID (根據行政區對應)
    /// </summary>
    public int? CountyId { get; set; }

    /// <summary>
    /// 地址 (去除郵遞區號、縣市、地區後的地址)
    /// </summary>
    public string? Address { get; set; }

    /// <summary>
    /// 電話號碼
    /// </summary>
    public string? Tel { get; set; }

    /// <summary>
    /// 學校網址
    /// </summary>
    public string? Url { get; set; }

    /// <summary>
    /// 原始地址 (CSV中的完整地址)
    /// </summary>
    public string? OriginalAddress { get; set; }

    /// <summary>
    /// 公私立標示 (CSV中的公/私立)
    /// </summary>
    public string? PublicPrivateType { get; set; }

    public string? Remarks { get; set; }

    public DateTime CreatedTime { get; set; }

    public long CreatedUserId { get; set; }

    public DateTime? UpdatedTime { get; set; }

    public long? UpdatedUserId { get; set; }

    /// <summary>
    /// 狀態 (0=軟刪除, 1=啟用, 2=停用)
    /// </summary>
    public byte Status { get; set; }

    public DateTime? DeletedTime { get; set; }

    public long? DeletedUserId { get; set; }

    public int SortOrder { get; set; }

    public virtual County? County { get; set; }

    public virtual District? District { get; set; }
}
