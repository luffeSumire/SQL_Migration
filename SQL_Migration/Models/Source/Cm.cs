using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

public partial class Cm
{
    /// <summary>
    /// 流水號
    /// </summary>
    public int Dsn { get; set; }

    /// <summary>
    /// 文章群組號
    /// </summary>
    public int? DocId { get; set; }

    /// <summary>
    /// 程式編號
    /// </summary>
    public string ProgId { get; set; } = null!;

    /// <summary>
    /// 標題
    /// </summary>
    public string? Title { get; set; }

    /// <summary>
    /// 內容
    /// </summary>
    public string? Body { get; set; }

    /// <summary>
    /// 上架日期
    /// </summary>
    public DateTime? STime { get; set; }

    /// <summary>
    /// 下架日期
    /// </summary>
    public DateTime? ETime { get; set; }

    /// <summary>
    /// 語系
    /// </summary>
    public int? LangId { get; set; }

    public string? Remarks { get; set; }

    /// <summary>
    /// 是否停用
    /// </summary>
    public byte? FlagDisable { get; set; }

    /// <summary>
    /// 排序
    /// </summary>
    public int? COrder { get; set; }

    /// <summary>
    /// 建立時間
    /// </summary>
    public DateTime? EsTime { get; set; }

    /// <summary>
    /// 更新時間
    /// </summary>
    public DateTime? UpTime { get; set; }

    /// <summary>
    /// 建立者
    /// </summary>
    public string? EsUsrId { get; set; }

    /// <summary>
    /// 修改者
    /// </summary>
    public string? UpUsrId { get; set; }

    /// <summary>
    /// 版本
    /// </summary>
    public int? Ver { get; set; }

    public byte? FlagIndex { get; set; }

    public string? UsrId { get; set; }
}
