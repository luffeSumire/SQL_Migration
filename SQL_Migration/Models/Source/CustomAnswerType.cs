using System;
using System.Collections.Generic;

namespace SQL_Migration.Models.Source;

/// <summary>
/// 回答方式；題目的回答方式建立
/// </summary>
public partial class CustomAnswerType
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
    /// 回答方式名稱；如：學生姓名、學生年級、分工任務
    /// </summary>
    public string? Cname { get; set; }

    /// <summary>
    /// 填充:&apos;input&apos;, 是非:&apos;yes_no&apos;,上傳:&apos;file&apos;,文字區塊:&apos;textarea&apos;,多選勾選:&apos;checkbox&apos;,單選下拉:&apos;select&apos;,單選點擊:&apos;radio&apos;,日期:&apos;date&apos;,日期區間:&apos;date_range&apos;
    /// </summary>
    public string? AnswerType { get; set; }

    /// <summary>
    /// 回答方式所對應的題目sid
    /// </summary>
    public int? QuestionSid { get; set; }

    /// <summary>
    /// 是否啟用；1:使用、0:不使用
    /// </summary>
    public byte? IsUse { get; set; }
}
