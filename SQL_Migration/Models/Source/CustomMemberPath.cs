using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 使用者環境路徑
/// </summary>
public partial class CustomMemberPath
{
    public int? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public long Sid { get; set; }

    /// <summary>
    /// 使用者編號
    /// </summary>
    public long? MemberSid { get; set; }

    /// <summary>
    /// 使用者編號
    /// </summary>
    public long? LevelSid { get; set; }

    /// <summary>
    /// 水
    /// </summary>
    public byte? Water { get; set; }

    /// <summary>
    /// 永續食物
    /// </summary>
    public byte? Food { get; set; }

    /// <summary>
    /// 生物多樣性
    /// </summary>
    public byte? Biological { get; set; }

    /// <summary>
    /// 交通
    /// </summary>
    public byte? Traffic { get; set; }

    /// <summary>
    /// 氣候
    /// </summary>
    public byte? Weather { get; set; }

    /// <summary>
    /// 消耗與廢棄物
    /// </summary>
    public byte? Consume { get; set; }

    /// <summary>
    /// 能源
    /// </summary>
    public byte? Energy { get; set; }

    /// <summary>
    /// 健康生活
    /// </summary>
    public byte? Life { get; set; }

    /// <summary>
    /// 健康校園
    /// </summary>
    public byte? School { get; set; }

    /// <summary>
    /// 學校棲地
    /// </summary>
    public byte? Habitat { get; set; }

    /// <summary>
    /// 森林
    /// </summary>
    public byte? Forest { get; set; }

    /// <summary>
    /// 水體保護
    /// </summary>
    public byte? Protection { get; set; }

    public string? Lan { get; set; }

    public int? Sequence { get; set; }

    public virtual CustomMember? MemberS { get; set; }
}
