using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 使用者的服務單位
/// </summary>
public partial class CustomPlace
{
    public long? Createdate { get; set; }

    public string? Createuser { get; set; }

    public string? Createip { get; set; }

    public long? Updatedate { get; set; }

    public string? Updateuser { get; set; }

    public string? Updateip { get; set; }

    public int Sid { get; set; }

    public int Sequence { get; set; }

    public string? Lan { get; set; }

    /// <summary>
    /// school:生態學校,epa:環保人員,tutor:輔導人員
    /// </summary>
    public string Type { get; set; } = null!;

    /// <summary>
    /// 名稱
    /// </summary>
    public string? PlaceCname { get; set; }

    /// <summary>
    /// 縣市sid
    /// </summary>
    public int? CitySid { get; set; }

    /// <summary>
    /// 地區sid
    /// </summary>
    public int? AreaSid { get; set; }

    /// <summary>
    /// 地址
    /// </summary>
    public string? Address { get; set; }

    /// <summary>
    /// 電話
    /// </summary>
    public string? Tel { get; set; }

    /// <summary>
    /// 上架時間
    /// </summary>
    public string? Startdate { get; set; }

    /// <summary>
    /// 下架時間
    /// </summary>
    public string? Enddate { get; set; }
}
