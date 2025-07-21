using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 給簡易CRUD用的，記錄Model所要join的table相關設定
/// </summary>
public partial class SimpleModelJoinSetting
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public int? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public int? Sequence { get; set; }

    public string? Lan { get; set; }

    public long Sid { get; set; }

    /// <summary>
    /// 對應simple_model_setting的sid
    /// </summary>
    public long? ModelSid { get; set; }

    /// <summary>
    /// 中文名稱
    /// </summary>
    public string? JoinCname { get; set; }

    /// <summary>
    /// 要join的table
    /// </summary>
    public string? JoinWithTable { get; set; }

    /// <summary>
    /// 要join的table as 名稱
    /// </summary>
    public string? JoinWithAs { get; set; }

    /// <summary>
    /// 要from的table
    /// </summary>
    public string? JoinFromTable { get; set; }

    /// <summary>
    /// 要join的table對應的變數名稱_from那張表
    /// </summary>
    public string? JoinLeftVar { get; set; }

    /// <summary>
    /// 要join的table對應的變數名稱_被join的表
    /// </summary>
    public string? JoinRightVar { get; set; }

    /// <summary>
    /// join的方式
    /// </summary>
    public string? JoinDirection { get; set; }
}
