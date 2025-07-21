using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 回答選項；如果選擇回答方式為選項(如select)類型，用於建立選項(如option)
/// </summary>
public partial class CustomAnswerOption
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
    /// 選項名稱，如：學生、老師、其他
    /// </summary>
    public string? Cname { get; set; }

    /// <summary>
    /// 若選項後面是可以提供文字輸入的時候，需要開啟；1:使用、0:不使用
    /// </summary>
    public byte? InputUse { get; set; }

    /// <summary>
    /// 多選或單選所對應的回答方式sid
    /// </summary>
    public int? AnswerTypeSid { get; set; }

    /// <summary>
    /// 是否啟用；1:使用、0:不使用
    /// </summary>
    public byte? IsUse { get; set; }
}
