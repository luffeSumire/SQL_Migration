using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

/// <summary>
/// 校園投稿審核狀態表 - 記錄校園投稿的審核流程和狀態變更
/// </summary>
public partial class CampusSubmissionReview
{
    /// <summary>
    /// 審核記錄主鍵
    /// </summary>
    public int CampusSubmissionReviewId { get; set; }

    /// <summary>
    /// 校園投稿ID (外鍵)
    /// </summary>
    public int CampusSubmissionId { get; set; }

    /// <summary>
    /// 審核狀態 (0=審核中, 1=審核通過, 2=審核不通過)
    /// </summary>
    public byte ReviewStatus { get; set; }

    /// <summary>
    /// 審核意見
    /// </summary>
    public string? ReviewComment { get; set; }

    /// <summary>
    /// 送審日期
    /// </summary>
    public DateTime? ReviewDate { get; set; }

    /// <summary>
    /// 通過日期
    /// </summary>
    public DateTime? ApprovedDate { get; set; }

    /// <summary>
    /// 審核人員ID
    /// </summary>
    public long? ReviewerId { get; set; }

    /// <summary>
    /// 建立時間
    /// </summary>
    public DateTime CreatedTime { get; set; }

    /// <summary>
    /// 建立者ID
    /// </summary>
    public long CreatedUserId { get; set; }

    /// <summary>
    /// 更新時間
    /// </summary>
    public DateTime? UpdatedTime { get; set; }

    /// <summary>
    /// 更新者ID
    /// </summary>
    public long? UpdatedUserId { get; set; }

    /// <summary>
    /// 狀態 (0=軟刪除, 1=啟用, 2=停用)
    /// </summary>
    public byte Status { get; set; }

    /// <summary>
    /// 軟刪時間
    /// </summary>
    public DateTime? DeletedTime { get; set; }

    /// <summary>
    /// 刪除者ID
    /// </summary>
    public long? DeletedUserId { get; set; }

    /// <summary>
    /// 顯示排序 (值越小越前面)
    /// </summary>
    public int SortOrder { get; set; }

    public virtual CampusSubmission CampusSubmission { get; set; } = null!;

    public virtual Account CreatedUser { get; set; } = null!;

    public virtual Account? DeletedUser { get; set; }

    public virtual Account? Reviewer { get; set; }

    public virtual Account? UpdatedUser { get; set; }
}
