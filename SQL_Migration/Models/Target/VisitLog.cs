using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Target;

/// <summary>
/// 使用者頁面瀏覽記錄表，用於統計網站訪問量和使用者行為分析
/// </summary>
public partial class VisitLog
{
    /// <summary>
    /// 瀏覽記錄唯一識別碼
    /// </summary>
    public long VisitLogId { get; set; }

    /// <summary>
    /// 頁面路徑 (例：/about, /products)
    /// </summary>
    public string Pathname { get; set; } = null!;

    /// <summary>
    /// 使用者裝置資訊 (User Agent)
    /// </summary>
    public string? Device { get; set; }

    /// <summary>
    /// 客戶端 IP 位址
    /// </summary>
    public string? ClientIp { get; set; }

    /// <summary>
    /// 瀏覽時間
    /// </summary>
    public DateTime VisitTime { get; set; }
}
